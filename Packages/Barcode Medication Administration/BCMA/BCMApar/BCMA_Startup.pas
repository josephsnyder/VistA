unit BCMA_Startup;
{
================================================================================
*	File:  BCMA_Startup.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 33 $  $Modtime: 5/08/02 3:50p $
*
*	Description:  This unit contains  code for Initializing the application.
*
*	Notes:        Most of this code was originally in unit BCMA_Common.
*
*
================================================================================
}

interface

uses
  SysUtils, Classes, Windows, Forms,
  VHA_Objects, Splash;

type
  TUserTypes = (utUser, utStudent, utInstructor);

  THeapStatus = record
    TotalAddrSpace: Cardinal;
    TotalUncommitted: Cardinal;
    TotalCommitted: Cardinal;
    TotalAllocated: Cardinal;
    TotalFree: Cardinal;
    FreeSmall: Cardinal;
    FreeBig: Cardinal;
    Unused: Cardinal;
    Overhead: Cardinal;
    HeapErrorCode: Cardinal;
  end;

const
  DEFAULTLOGFILEPATH = 'C:\TEMP\';
  TestBuild = False; // Controls display of notification message at startup
  UserTypeCaption: array[TUserTypes] of string = ('User', 'Student',
    'Instructor');

//  RequiredPatch = 'PSB*3.0*68';
//  RequiredPatch = 'PSB*3.0*70';
  RequiredPatch = 'PSB*3.0*83';

    // minimun required patch on server (PSB*x.x*x for patches)
  RequiredMOBDLL = '1.1.0.7'; //Require BCMAORDERCOM.DLL;
  RequiredVersion = '3.0';
    //Required Version of BCMA, used for the version release
  //when no patch has been installed
var
  BytesAllocated: longInt;
{$IFDEF CAS_DDPE_TEST}
  UserAV: string;
{$ENDIF}
  InstructorName,
    PortString,
    ServerString,
    ServerIP: string;

  useDebugMode,
    useLogFile,
    NoAutoUpdate,
    useDebugLog,
    NoCCOW,
    setIHS: boolean;  // rpk 7/15/2010

  logFileName: string;
  ApplicationLogFile: TextFile;
  BCMAAULogFile: TextFile;
  ErrorList: TStringList;
  nowString: string;

  logCriticalSection: TRtlCriticalSection;

  AppFileVersion,
    AppExeName: string;

  BCMA_User: TBCMA_User;
  BCMA_Broker: TBCMA_Broker;

  UserIsLoggedOn: boolean;
  RPCTimeOut: Integer;

  ShutDown: Boolean;
  FirstPass: Boolean;
  IdleTime: TDateTime;

function BCMA_ApplicationInit(OnlineRequired: boolean): boolean;
(*
  Creates and opens the ApplicationLogFile, creates and initializes
  BCMA_Broker(TBCMA_Broker), BCMA_User(TBCMA_User) and
  BCMA_Patient(TBCMA_Patient).
*)

procedure BCMA_ApplicationQuit;
(*
  Performs cleanup operations for the application.
*)

procedure BCMAExceptionHandler(Sender: TObject; E: Exception);
(*
  This is the Global Exception Handler for the application.
*)

procedure writeLogMessageProc(Msg: string; Ex: exception; Msg2: TStrings = nil);
(*
  Writes a message to the ApplicationLogFile.  If Ex is not nil, then
  Ex.message is written to the ApplicationLogFile as well.
*)

procedure CloseLogFile;

function AllowMultCopies: Boolean;

implementation

uses
  Controls, StdCtrls, Dialogs, FileCtrl,
  TRpcb,
//  MFunStr,
  RpcConf1, InputQry, Instructor, BCMA_Util;

procedure OpenLogFile;
var
  ii: integer;
  LogFilePath: string;
begin
  ii := ParamCount;
  while useLogFile and (ii > 0) do
  begin
    useLogFile := not (upperCase(paramStr(ii)) = '/NOLOGFILE');
    dec(ii);
  end;

  //	logFileName := ChangeFileExt(application.ExeName, '.log');
  if useLogFile then
  begin
    InitializeCriticalSection(logCriticalSection);

    ErrorList := TStringList.create;

    LogFilePath := DEFAULTLOGFILEPATH;
    for ii := 1 to ParamCount do
      if upperCase(piece(paramStr(ii), '=', 1)) = 'L' then
        LogFilePath := piece(paramStr(ii), '=', 2);

    if LogFilePath[length(LogFilePath)] <> '\' then
      LogFilePath := LogFilePath + '\';
        (* Make sure the path is terminated with a '\'*)

    if not DirectoryExists(LogFilePath) then
      if not CreateDir(LogFilePath) then
        raise Exception.Create('Cannot create directory ' +
          upperCase(LogFilePath));

    logFileName := LOGFILEPATH +
      ChangeFileExt(extractFileName(application.ExeName), '.log');
    //logFileName := LOGFILEPATH + piece(extractFileName(application.ExeName), '.', 1) +  ' ' + GetComputer + '.log';
    AssignFile(ApplicationLogFile, logFileName);

    try
      if not FileExists(logFileName) then
      begin
        Rewrite(ApplicationLogFile);
        Writeln(ApplicationLogFile,
          '========== Log File for Bar Code Medication Administration (BCMA) ' +
          DateTimeToStr(Now) + ' ==========');
      end
      else
        Append(ApplicationLogFile);

    except
      on e: EInOutError do
      begin
        case e.errorCode of
          0: ; (* Do Nothing All is OK! *)
          2: messageDlg('File not found:  ' + logFileName, mtError, [mbOK], 0);
          3: messageDlg('Invalid file name:  ' + logFileName, mtError, [mbOK],
            0);
          4: messageDlg('Too many open files:  ' + logFileName, mtError, [mbOK],
            0);
          5, 32: messageDlg('Access denied:  ' + logFileName, mtError, [mbOK],
            0);
          100: messageDlg('End-Of-File:  ' + logFileName, mtError, [mbOK], 0);
          101: messageDlg('Disk full:  ' + logFileName, mtError, [mbOK], 0);
          106: messageDlg('Invalid input:  ' + logFileName, mtError, [mbOK], 0);
        else
          messageDlg('Could not create an application log file:' + #13#13 +
            logFileName + #13#13 + e.Message, mtError, [mbOK], 0);
        end;

        //					  DeleteCriticalSection(logCriticalSection);
        exit;

      end;
    end;

  end;
end;

procedure CloseLogFile;
begin
  if logFileName <> '' then
  begin
    //			Flush(ApplicationLogFile);
    if useDebugMode then
      writeLogMessageProc('Still Allocated=' +
        intToStr(GetHeapStatus.TotalAllocated - BytesAllocated) + ' Bytes', nil);

    writeLogMessageProc('====================== Exiting ' + AppExeName +
      ' ============================', nil);
    CloseFile(ApplicationLogFile);

    ErrorList.free;
    DeleteCriticalSection(logCriticalSection);

    logFileName := '';  // prevent multiple CloseLogFile actions;  rpk 2/3/2012
  end;
end;

function getElectronicSignature(UserType: TUserTypes): string;
var
  CheckState: Boolean;
begin
  result := inputPrompt(Application.Title, UserTypeCaption[UserType] +
    '''s Electronic Signature:',
    '', 0, True, True, CheckState, '');
end;

function BCMA_ApplicationInit(OnlineRequired: boolean): boolean;
var
  ii,
    TryCount,
    ModalResult: integer;

  UserType: TUserTypes;
begin
  result := False;

  OpenLogFile;

  with TVersionInfo.Create(application) do
  try
    AppFileVersion := FileVersion;
  finally
    Free;
  end;

  AppExeName := ExtractFileName(application.ExeName);
  AppExeName := copy(AppExeName, 1, length(AppExeName) -
    length(ExtractFileExt(AppExeName)));

  writeLogMessageProc('', nil);
  writeLogMessageProc(copy('====================== Starting ' + AppExeName + ' '
    +
    AppFileVersion + ' ===========================', 1, 64), nil);

  BytesAllocated := GetHeapStatus.TotalAllocated;
  NoCCOW := False;  // rpk 7/15/2010
  setIHS := False;  // rpk 7/15/2010

  if ParamCount > 0 then
    for ii := 1 to ParamCount do (* Check for command line values *)
    begin
      if upperCase(piece(paramStr(ii), '=', 1)) = 'P' then
        PortString := piece(paramStr(ii), '=', 2);

      if upperCase(piece(paramStr(ii), '=', 1)) = 'S' then
        ServerString := piece(paramStr(ii), '=', 2);

      if upperCase(piece(paramStr(ii), '=', 1)) = 'T' then
        RPCTimeOut := StrToInt(piece(paramStr(ii), '=', 2));

      useDebugMode := useDebugMode or (upperCase(paramStr(ii)) = '/DEBUG');

{$IFDEF DEBUGLOG_ON}
      useDebugLog := useDebugLog or (upperCase(paramStr(ii)) = '/DEBUGLOG');
{$ENDIF}

      NoCCOW := NoCCOW or (upperCase(paramStr(ii)) = '/NOCCOW');

      setIHS := setIHS or (upperCase(paramStr(ii)) = '/IHS');  // rpk 7/15/2010

      NoAutoUpdate := True;
      //NoAutoUpdate := NoAutoUpdate or (upperCase(paramStr(ii)) = '/NOAU');
{$IFDEF CAS_DDPE_TEST}
      if upperCase(piece(paramStr(ii), '=', 1)) = '/AV' then {JK 10/10/2008}
        UserAV := piece(paramStr(ii), '=', 2);
{$ENDIF}
    end;

  if useDebugLog = True then
  begin
    MessageBeep(MB_ICONASTERISK);
    DefMessageDlg('All RPC calls are being logged to a text file, (BCMA.LOG or BCMAPAR.LOG), located in the temp directory.  These files will contain '
      +
      'confidential patient information and are for debugging purposes only.  Delete this files immediately!',
        mtWarning, [mbOK], 0);
  end;
  // Create the Broker
  FrmSplash.lblStatus.Caption := 'Connecting to Broker Server...';
  Application.ProcessMessages;
  BCMA_Broker := TBCMA_Broker.Create(Application);
  with BCMA_Broker do
  begin
    LogErrorProc := writeLogMessageProc;
    DebugMode := useDebugMode;
    if RPCTimeOut = 0 then
      RPCTimeLimit := 300
    else
      RPCTimeLimit := RPCTimeOut;

    if (ServerString = '') or (PortString = '') then
      if (getServerInfo(ServerString, PortString) = mrCancel) then
      begin
        PortString := '';
        ServerString := '';
      end;

    if (ServerString <> '') and (PortString <> '') then
    begin
      Server := ServerString;
      ListenerPort := strToInt(PortString);
      ServerIP := GetServerIP(server);
{ $IFDEF CAS_DDPE_TEST}
{ $ELSE}
//      AllowShared := True;
{ $ENDIF}
      writeLogMessageProc('Server: ' + serverstring, nil);
      writeLogMessageProc('Server IP: ' + ServerIP, nil);
      writeLogMessageProc('ListenerPOrt: ' + portstring, nil);
      writeLogMessageProc('RPCTimeLimit: ' + IntToStr(RPCTimeLimit), nil);
      try
{$IFDEF CAS_DDPE_TEST}
        AccessVerifyCodes := UserAV;
{$ENDIF}
        connected := True;
        FrmSplash.lblStatus.Caption := 'Loading User Parameters...';
        FrmSplash.Update;

        // Create User Object and load it
        BCMA_User := TBCMA_User.Create(BCMA_Broker);
        with BCMA_User do
          if LoadData then
          begin
            if OnlineRequired and not OnLine then
            begin
              messageDlg('The BCMA application is not active for this division.',
                mtError, [mbOK], 0);
              connected := False;
            end
            else
            begin
              TryCount := 3;
              if isStudent then
                UserType := utStudent
              else
                UserType := utUser;

              if ESigRequired then
                while TryCount > 0 do
                  if isValidESig(getElectronicSignature(UserType)) then
                    break
                  else
                    dec(TryCount);

              //if there wasn't a valid esig entered, bail out
              if TryCount = 0 then
              begin
                Connected := false;
                exit
              end;

              if TryCount > 0 then
                if isStudent then
                begin
                  //					This a Student!
                  TryCount := 3;
                  while TryCount > 0 do
                    with TfrmInstructor.create(application) do
                    begin
                      ModalResult := ShowModal;
                      if ModalResult = mrOK then
                      begin
                        InstructorName := '/' + InstructorName;
                        break;
                      end
                      else if ModalResult = mrCancel then
                      begin
                        TryCount := 0;
                        break;
                      end
                      else
                        dec(TryCount);
                    end;
                end;
              //connected := (TryCount > 0);
              if (TryCount = 0) and (isReadOnly = false) then
                isReadOnly := True;
              //											if connected then
              //												begin
              writeLogMessageProc(UserTypeCaption[UserType] + ' ' + UserName +
                ' logged on!', nil);
              //													result := connected;
              Result := True;
              //	end;
              if setIHS then // if flag is true, override agency code and set to IHS; rpk 7/15/2010
                AgencyCode := 'I'; // rpk 7/15/2010
            end;
          end
          else
            connected := False;
      except
        on Ex: EBrokerError do
        begin
          //EBrokerConnectionError.create(Ex.code, ex.mnemonic, ex.message, LogErrorProc);
          DefMessageDlg('Broker Error' + #13 + BrokerErrorMessages(Ex.Code,
            Ex.Mnemonic) +
            #13 + Ex.Message, mtError, [mbOK], 0);
          connected := false;
          exit;
        end;
      end;
    end
    else
    begin
      writeLogMessageProc('No Server and/or Port Found.', nil);
      messageDlg('No Server and/or Port Found!', mtError, [mbOK], 0);
      exit;
    end;
  end;
end;

procedure BCMA_ApplicationQuit;
begin
  BCMA_User.free;
//	CloseLogFile;
end;

procedure BCMAExceptionHandler(Sender: TObject; E: Exception);
var
  msg: string;
begin
  Application.NormalizeTopMosts;
  msg := 'BCMA Error:';

  if E is EWin32Error then
    with E as EWin32Error do
      msg := msg + #13#10 + SysErrorMessage(ErrorCode);

  if (E is EOutOfMemory) or
    (E is EStackOverFlow) then
    with GetHeapStatus do
    begin
      msg := msg + #13#10 + 'Heap Status --';
      msg := msg + #13#10 + format('Total Addr Space: %d%%', [TotalAddrSpace]);
      msg := msg + #13#10 + format('Total Uncommitted: %d%%',
        [TotalUncommitted]);
      msg := msg + #13#10 + format('Total Committed: %d%%', [TotalCommitted]);
      msg := msg + #13#10 + format('Total Allocated: %d%%', [TotalAllocated]);
      msg := msg + #13#10 + format('Total Free: %d%%', [TotalFree]);
      msg := msg + #13#10 + format('Free Small: %d%%', [FreeSmall]);
      msg := msg + #13#10 + format('Free Big: %d%%', [FreeBig]);
      msg := msg + #13#10 + format('Unused: %d%%', [Unused]);
      msg := msg + #13#10 + format('Overhead: %d%%', [Overhead]);
      msg := msg + #13#10 + format('Heap ErrorCode: %d%%', [HeapErrorCode]);
    end;

  ShowException(E, ExceptAddr);
  writeLogMessageProc(msg, E);
  Application.RestoreTopMosts;
  Application.MainForm.Close;
  //FrmMain.Close;
end;

procedure writeLogMessageProc(msg: string; ex: exception; Msg2: TStrings = nil);
var
  ii: integer;
begin
  if useLogFile then
  begin
    try
      //				EnterCriticalSection(logCriticalSection);
      nowString := DateTimeToStr(Now);

      if msg = '' then
        writeln(ApplicationLogFile, '')
      else
        writeln(ApplicationLogFile, nowString + ' ' + msg);
      Flush(ApplicationLogFile);

      if ex <> nil then
      begin
        with ErrorList do
        begin
          Text := ex.message;
          for ii := 0 to count - 1 do
            writeln(ApplicationLogFile, nowString + ' ..' + strings[ii]);
        end;
      end;
      Flush(ApplicationLogFile);

      if Msg2 <> nil then
        for ii := 0 to Msg2.Count - 1 do
          writeln(ApplicationLogFile, nowString + ' ..' + Msg2[ii]);

      //				LeaveCriticalSection(logCriticalSection);
    except
      on e: EInOutError do
      begin
        case e.errorCode of
          0: ; (* Do Nothing!  All is OK! *)
          2: messageDlg('File not found:  ' + logFileName, mtError, [mbOK], 0);
          3: messageDlg('Invalid file name:  ' + logFileName, mtError, [mbOK],
            0);
          4: messageDlg('Too many open files:  ' + logFileName, mtError, [mbOK],
            0);
          5, 32: messageDlg('Access denied:  ' + logFileName, mtError, [mbOK],
            0);
          100: messageDlg('End-Of-File:  ' + logFileName, mtError, [mbOK], 0);
          101: messageDlg('Disk full:  ' + logFileName, mtError, [mbOK], 0);
          106: messageDlg('Invalid input:  ' + logFileName, mtError, [mbOK], 0);
        else
          messageDlg('Could not write to log file:' + #13#13 +
            logFileName + #13#13 + e.Message, mtError, [mbOK], 0);
        end;

        DeleteCriticalSection(logCriticalSection);
        halt;
      end;
    end;
  end;
end;

function AllowMultCopies: Boolean;
var
  i: integer;
begin
  Result := false;
  if ParamCount > 0 then
    for i := 1 to ParamCount do
      Result := Result or (upperCase(paramStr(i)) = '/AMC');

  if Result = True then
    DefMessageDlg('You are launching multiple copies of BCMA which should be used '
      +
      'for debug purposes only!', mtWarning, [mbOK], 0);
end;

initialization
  InstructorName := '';
  PortString := '';
  ServerString := '';
  logFileName := '';

  useDebugMode := False;
  useLogFile := True;
end.
