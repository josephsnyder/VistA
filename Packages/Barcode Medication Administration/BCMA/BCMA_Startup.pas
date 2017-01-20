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
* Command Line Switches:
*
* L=logfilepath where logfilepath is the directory where bcma.log is written.
* (default=C:\TEMP)
* P=n where n=portnumber
* S=string  where string=server (ip address or DNS)
* T=n  where n=RPCTimeOut (seconds; default = 300).  Sets RPCTimeLimit in
* SharedRPCBroker.
* /DEBUG  turns on Debug Mode; same as debug checkbox in Options form.
* /DEBUGLOG (available only when DEBUGLOG_ON is defined in compiler) turns on
*   detailed debuglog output in bcma.log
* /IHS turns on SetIHS which forces BCMA to use IHS mode as though running in an RPMS
* system.
* /K=n where n=KeyboardTimeoutValue (seconds; default = 400)
* /NOCCOW turns off CCOW functionality.
* /NOLOGFILE disables the output of the bcma.log file.
* /USERDEFAULTS reverts back to default form and other user settings.  Suppresses
* load of user-setting parameters.
*
================================================================================
}

interface

uses
  SysUtils, Classes, Windows, Forms,
  VHA_Objects, Splash;

type
//  TUserTypes = (utUser, utStudent, utInstructor);
  TUserTypes = (utUser, utStudent, utInstructor, utWitness); // rpk 4/25/2012

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
  TestBuild = False;                    // Controls display of notification message at startup
  UserTypeCaption: array[TUserTypes] of string = ('User', 'Student',
    'Instructor', 'Witness');

  // minimum required patch on server (PSB*x.x*x for patches)
//  RequiredPatch = 'PSB*3.0*70';
  RequiredPatch = 'PSB*3.0*83';

{ $IFDEF MOB2}
//  RequiredMOBDLL = '2.0.0.0';           // Require new BCMAORDERCOM.DLL;
//  RequiredMOBDLL = '2.0.16.0';          // Require new BCMAORDERCOM.DLL;
{ $ELSE}
//  RequiredMOBDLL = '1.1.0.7';           //Require old BCMAORDERCOM.DLL;
{ $ENDIF}
  RequiredMOB1DLL = '1.1.0.7';          //Require old BCMAORDERCOM.DLL;
  RequiredMOB2DLL = '2.0.16.0';         //Require new ORDERCOM.DLL;

  RequiredVersion = '3.0';
  //Required Version of BCMA, used for the version release
//when no patch has been installed

var
  BytesAllocated: longInt;

{$IFDEF CAS_DDPE_DEBUG}
  CAS_PID,
    CAS_IgnoreDll,
    UserAV: string;
  CAS_ShowReader: Boolean;
{$ENDIF}
{$IFDEF CAS_508_DEBUG}
  CAS_508: string;
{$ENDIF}
  InstructorName,
    PortString,
    ServerString,
    ServerIP: string;

  useDebugMode,
    useLogFile,
//    NoAutoUpdate,
  useDebugLog,
    useUserDefaults,                    // force use of default user parameters; rpk 8/25/2009
    NoCCOW,
    setIHS: boolean;

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
  RpcConf1, InputQry, Instructor, BCMA_Util, BCMA_Common,
  BCMA_Objects, uCCOW;

procedure SetKeyboardTimeoutValue(TimeoutVal: string);
var
  tmpVal: string;
  tmpIntVal: Integer;
begin
  {validate the parameter}
  tmpVal := Trim(TimeoutVal);
  try
    tmpIntVal := StrToInt(tmpVal);
    if (tmpIntVal >= 250) and (tmpIntVal <= 1500) then
      KeyBoardTimerInterval := tmpIntVal;
  except
    Exit;
  end;
end;

procedure OpenLogFile;
var
  I: Integer;
  ii: integer;
  LogFilePath: string;
  temp_path: string;
  bres, patherror: Boolean;
  PathList: TStringList;
begin
  bres := False;
  patherror := False;

  PathList := TStringList.Create;
  if PathList = nil then
    Exit;

  temp_path := '';

  ii := ParamCount;
  while useLogFile and (ii > 0) do begin
    useLogFile := not (upperCase(paramStr(ii)) = '/NOLOGFILE');
    dec(ii);
  end;

  if useLogFile then begin
    InitializeCriticalSection(logCriticalSection);
    ErrorList := TStringList.create;
    LogFilePath := '';

    for ii := 1 to ParamCount do
      if upperCase(piece(paramStr(ii), '=', 1)) = 'L' then begin
        LogFilePath := piece(paramStr(ii), '=', 2);
        if LogFilePath > '' then
          PathList.Add(LogfilePath);
      end;

    LogFilePath := DEFAULTLOGFILEPATH;

    PathList.Add(LogfilePath);

{$IFDEF TEST_ON}
    LogFilePath := GetEnvironmentVariable('TEMP');
    if LogFilePath > '' then begin
      PathList.Add(LogfilePath);
      temp_path := LogFilePath;
    end;

    LogFilePath := GetEnvironmentVariable('TMP');
    if LogFilePath > '' then begin
      // check for TEMP = TMP; avoid duplicates
      if LogFilePath <> temp_path then
        PathList.Add(LogfilePath);
    end;
{$ENDIF}

    for I := 0 to PathList.Count - 1 do begin
      LogFilePath := PathList[i];
      (* Make sure the path is terminated with a '\'*)
      if LogFilePath[length(LogFilePath)] <> '\' then
        LogFilePath := LogFilePath + '\';
      if not DirectoryExists(LogFilePath) then begin
        if not CreateDir(LogFilePath) then begin
          if useDebugLog then           // rpk 5/31/2011
            DefMessageDlg('Unable to create directory for ' + LogFilePath +
              '.', mtError, [mbOK], 0);
          Continue;                     // for pathlist
        end;
      end;

      logFileName := LOGFILEPATH +
        ChangeFileExt(extractFileName(application.ExeName), '.log');
      AssignFile(ApplicationLogFile, logFileName);

      try
        if not FileExists(logFileName) then begin
          Rewrite(ApplicationLogFile);
          Writeln(ApplicationLogFile,
            '========== Log File for Bar Code Medication Administration (BCMA) ' +
            DateTimeToStr(Now) + ' ==========');
        end
        else
          Append(ApplicationLogFile);

      except
        on e: EInOutError do begin
          if e.ErrorCode > 0 then begin
            if useDebugLog then         // rpk 5/31/2011
              DefMessageDlg('Could not create an application log file:' + #13#13 +
                logFileName + #13#13 +
                'Error: ' + IntToStr(e.ErrorCode) + ' : ' + e.Message,
                mtError, [mbOK], 0);

            patherror := True;
          end;
          Continue;                     // for pathlist
        end;
      end;
      bres := True;                     // created directory / opened file
      break;
    end;                                // for pathlist
  end;

  if bres then begin
    if useDebugLog and patherror then   // rpk 5/31/2011
      DefMessageDlg('Application log file will be written here:' + #13#13 +
        logFileName, mtInformation, [mbOK], 0);
  end
  else begin
    useLogFile := False;
    if useDebugLog then                 // rpk 5/31/2011
      DefMessageDlg('Could not create an application log file. No log file will be written:',
        mtError, [mbOK], 0);
    DeleteCriticalSection(logCriticalSection);
    if ErrorList <> nil then
      FreeAndNil(ErrorList);
  end;

  PathList.Free;

end;                                    // OpenLogFile

procedure CloseLogFile;
var
  totalloc: Cardinal;
  stillalloc: Integer;
begin
  if logFileName <> '' then begin
    if useLogFile then begin
      if useDebugMode then begin
        totalloc := GetHeapStatus.TotalAllocated; // rpk 5/14/2013
        stillalloc := totalloc - BytesAllocated;
        writeLogMessageProc('Still Allocated=' +
          intToStr(stillalloc) + ' Bytes', nil);
      end;

      writeLogMessageProc('====================== Exiting ' + AppExeName +
        ' ============================', nil);
      Flush(ApplicationLogFile);
      CloseFile(ApplicationLogFile);

      ErrorList.free;
      DeleteCriticalSection(logCriticalSection);
      useLogFile := False;              // make sure writelogmessageproc does not run;  rpk 5/23/2013
    end;

    logFileName := '';                  // prevent multiple close log file actions;  rpk 2/3/2012

  end;
end;                                    // CloseLogFile

function getElectronicSignature(UserType: TUserTypes): string;
var
  CheckState: Boolean;
begin
  result := inputPrompt(Application.Title, UserTypeCaption[UserType] +
    '''s Electronic Signature:',
    '', 0, True, True, otNone, CheckState, '');
end;

function BCMA_ApplicationInit(OnlineRequired: boolean): boolean;
var
  ii,
    TryCount: Integer;
  UserType: TUserTypes;
begin
  result := False;
  useDebugLog := False;                 // rpk 3/9/2009
  setIHS := False;                      // rpk 6/23/2010

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
  if ParamCount > 0 then
    for ii := 1 to ParamCount do        (* Check for command line values *)
    begin
      if upperCase(piece(paramStr(ii), '=', 1)) = 'P' then
        PortString := piece(paramStr(ii), '=', 2);

      if upperCase(piece(paramStr(ii), '=', 1)) = 'S' then
        ServerString := piece(paramStr(ii), '=', 2);

      if upperCase(piece(paramStr(ii), '=', 1)) = 'T' then
        RPCTimeOut := StrToInt(piece(paramStr(ii), '=', 2));

      if upperCase(piece(paramStr(ii), '=', 1)) = '/K' then {JK 10/10/2008}
        SetKeyboardTimeoutValue(piece(paramStr(ii), '=', 2));

      useDebugMode := useDebugMode or (upperCase(paramStr(ii)) = '/DEBUG');

      // added conditional define to remove availability of debug log in production; rpk 1/6/2011
{$IFDEF DEBUGLOG_ON}
      useDebugLog := useDebugLog or (upperCase(paramStr(ii)) = '/DEBUGLOG');
{$ENDIF}

      NoCCOW := NoCCOW or (upperCase(paramStr(ii)) = '/NOCCOW');

      useUserDefaults := useUserDefaults or (upperCase(paramStr(ii)) =
        '/USERDEFAULTS');               // rpk 8/25/2009

      setIHS := setIHS or (uppercase(paramStr(ii)) = '/IHS'); // rpk 6/23/2010

//      NoAutoUpdate := True;
      //NoAutoUpdate := NoAutoUpdate or (upperCase(paramStr(ii)) = '/NOAU');
{$IFDEF CAS_DDPE_DEBUG}
      if upperCase(piece(paramStr(ii), '=', 1)) = '/AV' then
        UserAV := piece(paramStr(ii), '=', 2);
      if upperCase(piece(paramStr(ii), '=', 1)) = '/CAS_IGNORE' then
        CAS_IgnoreDLL := 'YES';
      CAS_ShowReader := upperCase(piece(paramStr(ii), '=', 1)) = '/CAS_READER';
      if upperCase(piece(paramStr(ii), '=', 1)) = '/CAS_PID' then
        CAS_PID := piece(paramStr(ii), '=', 2);
{$ENDIF}
    end;

  if useDebugLog then begin
    MessageBeep(MB_ICONASTERISK);
    DefMessageDlg('All RPC calls are being logged to a text file, (BCMA.LOG or BCMAPAR.LOG), located in the temp directory.  These files will contain '
      +
      'confidential patient information and are for debugging purposes only.  Delete this file immediately!',
      mtWarning, [mbOK], 0);
  end;

  // Create the Broker
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
{$IFNDEF MOB2}
//// ZZZZZZBELLC Remove MOB2 define and use shared broker

// use rpc broker in future when ordercom.dll is released and comment out AllowShared; rpk 2/29/2016
      AllowShared := True;              // turn on Shared RPC Broker sharing for Med Order Button

{$ENDIF}
      writeLogMessageProc('Server: ' + serverstring, nil);
      writeLogMessageProc('Server IP: ' + ServerIP, nil);
      writeLogMessageProc('ListenerPOrt: ' + portstring, nil);
      writeLogMessageProc('RPCTimeLimit: ' + IntToStr(RPCTimeLimit), nil);

      if NOCCOW then                    // rpk 7/25/2013
        VACCOW := nil
      else begin
        Screen.Cursor := crHourglass;   // rpk 3/25/2013
        FrmSplash.WriteStatus('Attempting communication with CCOW...'); // rpk 3/25/2013
        VACCOW := NewCCOWContextor(Application); // rpk 3/25/2013
        if (VACCOW <> nil) then begin   // rpk 7/25/2013
          if NoCCOW then begin          // rpk 3/25/2013
            VACCOW.CCOWEnabled := False // rpk 3/25/2013
          end                           // rpk 3/25/2013
          else begin                    // rpk 3/25/2013
            FrmSplash.WriteStatus('Communicating with CCOW Vault...'); // rpk 3/25/2013
            if VACCOW.JoinContext('BCMA#') then // rpk 3/25/2013
              BCMA_Broker.Contextor := VACCOW.ContextManager // rpk 3/25/2013
            else
              BCMA_Broker.Contextor := nil;
            FrmSplash.WriteStatus('');  // rpk 3/26/2013
          end;                          // rpk 3/25/2013
        end;                            // if VACCOW <> nil
        Screen.Cursor := crDefault;
      end;                              // if NOCCOW

      FrmSplash.WriteStatus('Connecting to Broker Server...'); // rpk 3/26/2013
      try
{$IFDEF CAS_DDPE_DEBUG}
        AccessVerifyCodes := UserAV;
{$ENDIF}
        connected := True;
        FrmSplash.WriteStatus('Loading User Parameters...'); // rpk 6/9/2009
        // Create User Object and load it
        BCMA_User := TBCMA_User.Create(BCMA_Broker);
        with BCMA_User do
          if LoadData then
          begin
            if OnlineRequired and not OnLine then
            begin
              DefMessageDlg('The BCMA application is not active for this division.',
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
              if (TryCount = 0) and (isReadOnly = false) then
                isReadOnly := True;
              writeLogMessageProc(UserTypeCaption[UserType] + ' ' + UserName +
                ' logged on!', nil);
              Result := True;
            end;
          end
          else
            connected := False;
      except
        on Ex: EBrokerError do
        begin
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
      DefMessageDlg('No Server and/or Port Found!', mtError, [mbOK], 0);
      exit;
    end;
  end;
end;                                    // BCMA_ApplicationInit

procedure BCMA_ApplicationQuit;
begin
//  BytesAllocated := GetHeapStatus.TotalAllocated;

  BCMA_User.free;
//  CloseLogFile;  // NOTE: don't call closelogfile prior to main form destroy
end;                                    // BCMA_ApplicationQuit

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
  application.terminate;
  abort;
  //FrmMain.Close;
end;                                    // BCMAExceptionHandler

procedure writeLogMessageProc(msg: string; ex: exception; Msg2: TStrings = nil);
var
  ii: integer;
begin
  if useLogFile then begin
    try
      EnterCriticalSection(logCriticalSection);

      nowString := DateTimeToStr(Now);

      if msg = '' then
        writeln(ApplicationLogFile, '')
      else
        writeln(ApplicationLogFile, nowString + ' ' + msg);
      Flush(ApplicationLogFile);

      if ex <> nil then begin
        with ErrorList do begin
          Text := ex.message;
          for ii := 0 to count - 1 do
            writeln(ApplicationLogFile, nowString + ' ..' + strings[ii]);
        end;
      end;
      Flush(ApplicationLogFile);

      if Msg2 <> nil then
        for ii := 0 to Msg2.Count - 1 do
          writeln(ApplicationLogFile, nowString + ' ..' + Msg2[ii]);

      LeaveCriticalSection(logCriticalSection);
    except
      on e: EInOutError do begin
        case e.errorCode of
          0: ;                          (* Do Nothing!  All is OK! *)
          2: DefMessageDlg('File not found:  ' + logFileName, mtError, [mbOK], 0);
          3: DefMessageDlg('Invalid file name:  ' + logFileName, mtError, [mbOK],
              0);
          4: DefMessageDlg('Too many open files:  ' + logFileName, mtError, [mbOK],
              0);
          5, 32: DefMessageDlg('Access denied:  ' + logFileName, mtError, [mbOK],
              0);
          100: DefMessageDlg('End-Of-File:  ' + logFileName, mtError, [mbOK], 0);
          101: DefMessageDlg('Disk full:  ' + logFileName, mtError, [mbOK], 0);
          106: DefMessageDlg('Invalid input:  ' + logFileName, mtError, [mbOK], 0);
        else
          DefMessageDlg('Could not write to log file:' + #13#13 +
            logFileName + #13#13 + e.Message, mtError, [mbOK], 0);
        end;

        // change to allow program to run after log file failure
        CloseFile(ApplicationLogFile);  // rpk 5/13/2011
        LeaveCriticalSection(logCriticalSection); // rpk 5/13/2011
        ErrorList.free;                 // rpk 5/13/2011
        DeleteCriticalSection(logCriticalSection);
        useLogFile := False;            // rpk 5/13/2011
      end;
    end;
  end;
end;                                    // writeLogMessageProc

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

