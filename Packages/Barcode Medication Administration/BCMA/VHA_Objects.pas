unit VHA_Objects;
{
================================================================================
*	File:  VHA_Objects.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 23 $  $Modtime: 5/08/02 3:50p $
*
*	Description:  This is a unit which contains VHA Objects developed for the
*               BCMA application.
*
*	Notes:  Need to document PSB USERLOAD Results rows.
*
*
================================================================================
}

interface

uses
  SysUtils,
  Classes,
  Controls,
  Windows,
  Forms,
  TRPCB,
// ZZZZZZBELLC Remove MOB2 define. stick with shared broker for the time being
{$IFDEF MOB2}
// when ready to use new ordercom.dll, use normal rpc broker; rpk 3/21/2016
  CCOWRPCBroker,
{$ELSE}
  SharedRPCBroker,
  VERGENCECONTEXTORLib_TLB,
{$ENDIF}
  ComOBJ;

const
  VersionInfoKeys: array[1..10] of string = (
    'CompanyName', 'FileDescription', 'FileVersion', 'InternalName',
    'LegalCopyRight', 'OriginalFileName', 'ProductName', 'ProductVersion',
    'Comments', 'ReleaseDate'
    );

  USEnglish = $040904E4;

type
  PTransBuffer = ^TTransBuffer;
  TTransBuffer = array[1..13] of smallint;

const
  CInfoStr: array[1..13] of string =
  ('FileVersion',
    'CompanyName',
    'FileDescription',
    'InternalName',
    'LegalCopyright',
    'LegalTradeMarks',
    'OriginalFileName',
    'ProductName',
    'ProductVersion',
    'Comments',
    'CurrentProgramVersion',
    'CurrentDatabaseVersion',
    'VersionDetails');

function BrokerErrorMessages(errorCode: integer; defString: string): string;
(*
  A function which translates numerical Error Codes into English.
*)
type
  TLogErrorProc = procedure(msg: string; ex: exception; Msg2: TStrings = nil);

  EBrokerConnectionError = class(Exception)
    (*
      A replacement for EBrokerError which displays English error messages
      instead of acronyms.  Writes all messages to an error log file, if one
      exists.
    *)
    ErrorCode: integer;
    Mnemonic: string;

    constructor Create(eCode: integer; shortMsg, longMsg: string;
      LogErrorProc: TLogErrorProc);
    (*
     Allocates memory for the exception, uses method BrokerErrorMessages to
     replace errorcodes with English, writes errors to a log file, if one is
     assigned, and displays the English error messages.
    *)
  end;

  TVersionInfo = class(TComponent)
  private
    FFileName: string;
    FLanguageID: DWord;
    FInfo: pointer;
    FInfoSize: longint;
    FCtlCompanyName: TControl;
    FCtlFileDescription: TControl;
    FCtlFileVersion: TControl;
    FCtlInternalName: TControl;
    FCtlLegalCopyRight: TControl;
    FCtlOriginalFileName: TControl;
    FCtlProductName: TControl;
    FCtlProductVersion: TControl;
    FCtlComments: TControl;
    FCtlReleaseDate: TControl;

    procedure SetFileName(Value: string);
    procedure SetVerProp(index: integer; value: TControl);
    function GetVerProp(index: integer): TControl;
    function GetIndexKey(index: integer): string;
    function GetKey(const KName: string): string;
    procedure Refresh;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    property CompanyName: string index 1 read GetIndexKey;
    property FileDescription: string index 2 read GetIndexKey;
    property FileVersion: string index 3 read GetIndexKey;
    property InternalName: string index 4 read GetIndexKey;
    property LegalCopyRight: string index 5 read GetIndexKey;
    property OriginalFileName: string index 6 read GetIndexKey;
    property ProductName: string index 7 read GetIndexKey;
    property ProductVersion: string index 8 read GetIndexKey;
    property Comments: string index 9 read GetIndexKey;
    property ReleaseDate: string index 10 read GetIndexKey;
    property FileName: string read FFileName write SetFileName;
    property LanguageID: DWord read FLanguageID write FLanguageID;

    constructor Create(AOwner: TComponent); override;
    (*
      Allocates memory and initializes variables for the object.
    *)

    destructor Destroy; override;
    (*
      Releases all memory allocated for the object.
    *)

    procedure OpenFile(FName: string);
    (*
      Uses method GetFileVersionInfo to retrieve version information for file
      FName.  If FName is blank, version information is obtained for the
      current executable (Application.ExeName).
    *)

    procedure Close;
    (*
      Releases memory allocated and clears all storage variables.
    *)

  published
    property CtlCompanyName: TControl index 1 read GetVerProp write SetVerProp;
    property CtlFileDescription: TControl index 2 read GetVerProp write
      SetVerProp;
    property CtlFileVersion: TControl index 3 read GetVerProp write SetVerProp;
    property CtlInternalName: TControl index 4 read GetVerProp write SetVerProp;
    property CtlLegalCopyRight: TControl index 5 read GetVerProp write
      SetVerProp;
    property CtlOriginalFileName: TControl index 6 read GetVerProp write
      SetVerProp;
    property CtlProductName: TControl index 7 read GetVerProp write SetVerProp;
    property CtlProductVersion: TControl index 8 read GetVerProp write
      SetVerProp;
    property CtlComments: TControl index 9 read GetVerProp write SetVerProp;
    property CtlReleaseDate: TControl index 10 read GetVerProp write SetVerProp;
  end;

//    TBCMA_Broker = class (tRPCBroker)
    (*
      A descendant of TRPCBroker that provides enhanced RPC parameter handling,
      debugging and error trapping capabilities.
    *)
//  TBCMA_Broker = class(TCCOWRPCBroker)

//// ZZZZZZBELLC Remove MOB2 define. stick with shared broker for the time being
// use rpc broker only with new ordercom.dll; rpk 2/29/2016
//  TBCMA_Broker = class(TRPCBroker)
{$IFDEF MOB2}
  TBCMA_Broker = class(TCCOWRPCBroker)
{$ELSE}
  TBCMA_Broker = class(TSharedRPCBroker)
{$ENDIF}

  private
    {Private Stuff}
    FLogErrorProc: TLogErrorProc;
{$IFNDEF MOB2}
    FContextor: TContextorControl;  //CCOW
{$ENDIF}
  public
    {Public Stuff}
    property LogErrorProc: TLogErrorProc read FLogErrorProc write FLogErrorProc;
    (*
     Pointer to an optional, external procedure which writes error information
     into an application errorlog file.
    *)
{$IFNDEF MOB2}
    property   Contextor: TContextorControl
                          read Fcontextor write FContextor;  //CCOW
{$ENDIF}

    function CallServer(RPC: string; callingParams: array of string; MultList:
      TStrings; TrueNull: Boolean = False): boolean;
    (*
     Uses:	TfrmDebug = class(TForm);

     This is a wrapper around the inherited Call procedure.  Enhancements are:
      - This is a function, rather than a procedure, which returns a True value
       only if there are no Broker Errors.
      - If DebugMode is True, then Call input arguments are displayed and
       then the output results shown.
      -	The Call itself is in a try/except block so that Broker Errors can
       be trapped and handled in a user friendly form and detailed error
       info can be entered into an application error log file, if one has
       been assigned.
    *)
  end;

  TBCMA_User = class(TObject)
    (*
      An class that holds User data and handles all User interaction with the
      VistA server.
    *)
  private
    FRPCBroker: TBCMA_Broker;
    FDUZ: string;
    FUserName: string;
    FIsManager: Boolean;
    FIsStudent: Boolean;
    FIsMOButtonUser: Boolean;
    FIsReadOnly,
      FUnableToScanKey: Boolean;
    FOrderRole: Integer;

    FDivisionIEN,
    //
    // SiteIEN is also known as facility division number in BCMA Parameters
    // (PSB USERLOAD: piece 2 of results[7])
    // It is used in setting the CCOW context.
    //
    FSiteIEN,
      FDivisionName,
      FInstructorDUZ: string;           //If this is a student, then this contains the DUZ of the instructor

    // FAgencyCode holds the value defined in the AGENCY CODE field (95) of the
    // INSTITUTION File (4) and set into the DUZ(“AG”) array variable.
    FAgencyCode: string;                // rpk 8/6/2009

    FESigRequired: boolean;
    FOnLine: boolean;
    FDTime: string;                     //User timeout interval in seconds.

    FChanged: boolean;
    FProductionAccount: Boolean;

  protected
    function getDTime: integer;

  public
    property DUZ: string read FDUZ;
    property UserName: string read FUserName;
    property IsManager: Boolean read FIsManager;
    property IsStudent: Boolean read FIsStudent;
    property IsMOButtonUser: Boolean read FIsMOButtonUser;
    property IsReadOnly: Boolean read FIsReadOnly write FIsReadOnly;
    property UnableToScanKey: Boolean read FUnableToScanKey;
    property DivisionIEN: string read FDivisionIEN;
    property ProductionAccount: Boolean read FProductionAccount;
    property SiteIEN: string read FSiteIEN;
    property DivisionName: string read FDivisionName;
    property InstructorDUZ: string read FInstructorDUZ write FInstructorDUZ;
    property AgencyCode: string read FAgencyCode; // rpk 8/6/2009
    property ESigRequired: boolean read FESigRequired;
    property OnLine: boolean read FOnLine;
    property DTime: integer read getDTime; //User Timeout interval
{$IFDEF TEST_ON}
    property OrderRole: integer read FOrderRole write FOrderRole; // for debug
{$ELSE}
    property OrderRole: integer read FOrderRole;
{$ENDIF}
    property Changed: boolean read FChanged;

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil;
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

    function LoadData: boolean;
    (*
      Creates user context 'PSB GUI CONTEXT - USER' then uses RPC
      'PSB USERLOAD' to retrieve user data fron the server,
    *)

    procedure SaveData;
    (*
      If any of the User properties have changed, the changes will be saved
      to the server.
    *)

    function isValidESig(ESig: string): boolean;
    (*
      Uses RPC 'PSB VALIDATE ESIG' to validate an Electronic Signature,
      ESig.  If valid, the return value is True.
    *)

  end;

implementation

uses
  Dialogs, TypInfo, Debug,
//  MFunStr,
  BCMA_Startup, Hash, BCMA_Util
{$IFDEF ZZ_RPC_LOG}
  , uZZ_RPCEvent, fZZ_EventLog          // zzzzzzandria 2015-01-29 ====================
{$ENDIF}
  ;

function BrokerErrorMessages(errorCode: integer; defString: string): string;
begin
  case ErrorCode of
    10013: result := 'Winsock Error!' + #13 + 'Permission denied.';
    10048: result := 'Winsock Error!' + #13 + 'Address already in use.';
    10049: result := 'Winsock Error!' + #13 +
      'Cannot assign requested address.';
    10047: result := 'Winsock Error!' + #13 +
      'Address family not supported by protocol family.';
    10037: result := 'Winsock Error!' + #13 + 'Operation already in progress.';
    10053: result := 'Winsock Error!' + #13 + 'Connection aborted by host.';
    10061: result := 'Winsock Error!' + #13 + 'Connection refused by host.';
    10054: result := 'Winsock Error!' + #13 + 'Connection reset by host.';
    10039: result := 'Winsock Error!' + #13 + 'Destination address required.';
    10014: result := 'Winsock Error!' + #13 + 'Bad address.';
    10064: result := 'Winsock Error!' + #13 + 'Host is down.';
    10065: result := 'Winsock Error!' + #13 + 'No route to host.';
    10036: result := 'Winsock Error!' + #13 + 'Operation now in progress.';
    10004: result := 'Winsock Error!' + #13 + 'Interrupted function call.';
    10022: result := 'Winsock Error!' + #13 + 'Invalid argument.';
    10056: result := 'Winsock Error!' + #13 + 'Socket already connected.';
    10024: result := 'Winsock Error!' + #13 + 'Too many open files.';
    10040: result := 'Winsock Error!' + #13 + 'Message too long.';
    10050: result := 'Winsock Error!' + #13 + 'Network is down.';
    10052: result := 'Winsock Error!' + #13 +
      'Network dropped connection on reset.';
    10051: result := 'Winsock Error!' + #13 + 'Network is unreachable.';
    10055: result := 'Winsock Error!' + #13 + 'No buffer space available.';
    10042: result := 'Winsock Error!' + #13 + 'Bad protocol option.';
    10057: result := 'Winsock Error!' + #13 + 'Socket is not connected.';
    10038: result := 'Winsock Error!' + #13 + 'Socket operation on non-socket.';
    10045: result := 'Winsock Error!' + #13 + 'Operation not supported.';
    10046: result := 'Winsock Error!' + #13 + 'Protocol family not supported.';
    10067: result := 'Winsock Error!' + #13 + 'Too many processes.';
    10043: result := 'Winsock Error!' + #13 + 'Protocol not supported.';
    10041: result := 'Winsock Error!' + #13 + 'Protocol wrong type for socket.';
    10058: result := 'Winsock Error!' + #13 +
      'Cannot send after socket shutdown.';
    10044: result := 'Winsock Error!' + #13 + 'Socket type not supported.';
    10060: result := 'Winsock Error!' + #13 + 'Connection timed out.';
    10035: result := 'Winsock Error!' + #13 +
      'Resource temporarily unavailable.';
    11001: result := 'Winsock Error!' + #13 + 'Host not found.';
    10093: result := 'Winsock Error!' + #13 +
      'Successful WSAStartup() not yet performed.';
    11004: result := 'Winsock Error!' + #13 +
      'Valid name, no data record of requested type.';
    11003: result := 'Winsock Error!' + #13 +
      'This is a non-recoverable error.';
    10091: result := 'Winsock Error!' + #13 +
      'Network subsystem is unavailable.';
    11002: result := 'Winsock Error!' + #13 +
      'Non-authoritative host not found.';
    10092: result := 'Winsock Error!' + #13 +
      'WINSOCK.DLL version out of range.';
    10094: result := 'Winsock Error!' + #13 + 'Graceful shutdown in progress.';
  else
    result := defString;
  end;
end;

////////// EBrokerConnectionError Mthods ////////////////////////////

constructor EBrokerConnectionError.Create(eCode: integer; shortMsg, longMsg:
  string;
  LogErrorProc: TLogErrorProc);
begin
  ErrorCode := eCode;
  Message := longMsg;

  Mnemonic := BrokerErrorMessages(ErrorCode, shortMsg);
  if Mnemonic = '' then
    Mnemonic := 'Broker Connection Error';
  if Message = '' then
    Message := Mnemonic;

  case ErrorCode of
    10013,
      10048,
      10049,
      10047,
      10037,
      10053,
      10061,
      10054,
      10039,
      10014,
      10064,
      10065,
      10036,
      10004,
      10022,
      10056,
      10024,
      10040,
      10050,
      10052,
      10051,
      10055,
      10042,
      10057,
      10038,
      10045,
      10046,
      10067,
      10043,
      10041,
      10058,
      10044,
      10060,
      10035,
      11001,
      10093,
      11004,
      11003,
      10091,
      11002,
      10092,
      10094:
      Message := Mnemonic + #13 + Message;
  else
  end;

  if assigned(LogErrorProc) then
  begin
    LogErrorProc('Connection to server not established!', self);
    DefMessageDlg(Mnemonic, mtError, [mbOK], 0);
  end;
end;

///// TVersionInfo Methods //////////////////////////////////////////

constructor TVersionInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLanguageID := USEnglish;
  SetFileName(EmptyStr);
end;

destructor TVersionInfo.Destroy;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  inherited Destroy;
end;

procedure TVersionInfo.SetFileName(Value: string);
begin
  FFileName := Value;
  if Value = EmptyStr then              // default to self
    FFileName := ExtractFileName(Application.ExeName);
  //		FFileName := ExtractFilePath(Application.ExeName);
  if csDesigning in ComponentState then
  begin
    Refresh
  end
  else
    OpenFile(Value);
end;

procedure TVersionInfo.OpenFile(FName: string);
var
  vlen: DWord;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  if Length(FName) <= 0 then
    FName := Application.ExeName;
  FInfoSize := GetFileVersionInfoSize(pchar(fname), vlen);
  if FInfoSize > 0 then
  begin
    GetMem(FInfo, FInfoSize);
    if not GetFileVersionInfo(pchar(fname), vlen, FInfoSize, FInfo) then
      raise Exception.Create('Cannot retrieve Version Information for ' +
        fname);
    Refresh;
  end;
end;

procedure TVersionInfo.Close;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  FInfoSize := 0;
  FFileName := EmptyStr;
end;

const
  vqvFmt = '\StringFileInfo\%8.8x\%s';

function TVersionInfo.GetKey(const KName: string): string;
var
  //vptr: pchar;
  vlen: DWord;
  //Added the following
  transStr: string;
  vptr: PTransBuffer;
  value: PChar;

begin
  Result := EmptyStr;
  if FInfoSize <= 0 then
    exit;

  //  If VerQueryValue(FInfo, pchar(Format(vqvFmt, [FLanguageID, KName])), pointer(vptr), vlen) Then
  if VerQueryValue(FInfo, PChar('\VarFileInfo\Translation'), Pointer(vptr), vlen)
    then
  begin
    //Added the following two lines:
    transStr := IntToHex(vptr^[1], 4) + IntToHex(vptr^[2], 4);
    if VerQueryValue(FInfo, pchar('StringFileInfo\' + transStr + '\' + KName),
      pointer(value), vlen) then
      //Result := vptr;
      Result := Value;
  end;
end;

function TVersionInfo.GetIndexKey(index: integer): string;
begin
  Result := GetKey(VersionInfoKeys[index]);
end;

function TVersionInfo.GetVerProp(index: integer): TControl;
begin
  case index of
    1: Result := FCtlCompanyName;
    2: Result := FCtlFileDescription;
    3: Result := FCtlFileVersion;
    4: Result := FCtlInternalName;
    5: Result := FCtlLegalCopyRight;
    6: Result := FCtlOriginalFileName;
    7: Result := FCtlProductName;
    8: Result := FCtlProductVersion;
    9: Result := FCtlComments;
    10: Result := FCtlReleaseDate;
  else
    Result := nil;
  end;
end;

procedure TVersionInfo.SetVerProp(index: integer; value: TControl);
begin
  case index of
    1: FCtlCompanyName := Value;
    2: FCtlFileDescription := Value;
    3: FCtlFileVersion := Value;
    4: FCtlInternalName := Value;
    5: FCtlLegalCopyRight := Value;
    6: FCtlOriginalFileName := Value;
    7: FCtlProductName := Value;
    8: FCtlProductVersion := Value;
    9: FCtlComments := Value;
    10: FCtlReleaseDate := Value;
  end;
  Refresh;
end;

procedure TVersionInfo.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  if Operation = opRemove then
  begin
    if AComponent = FCtlCompanyName then
      FCtlCompanyName := nil
    else if AComponent = FCtlFileDescription then
      FCtlFileDescription := nil
    else if AComponent = FCtlFileVersion then
      FCtlFileVersion := nil
    else if AComponent = FCtlInternalName then
      FCtlInternalName := nil
    else if AComponent = FCtlLegalCopyRight then
      FCtlLegalCopyRight := nil
    else if AComponent = FCtlOriginalFileName then
      FCtlOriginalFileName := nil
    else if AComponent = FCtlProductName then
      FCtlProductName := nil
    else if AComponent = FCtlProductVersion then
      FCtlProductVersion := nil
    else if AComponent = FCtlComments then
      FCtlComments := nil
    else if AComponent = FCtlReleaseDate then
      FCtlReleaseDate := nil;
  end;
end;

procedure TVersionInfo.Refresh;
var
  PropInfo: PPropInfo;

  procedure AssignText(Actl: TComponent; txt: string);
  begin
    if Assigned(ACtl) then
    begin
      PropInfo := GetPropInfo(ACtl.ClassInfo, 'Caption');
      if PropInfo <> nil then
        SetStrProp(ACtl, PropInfo, txt)
      else
      begin
        PropInfo := GetPropInfo(ACtl.ClassInfo, 'Text');
        if PropInfo <> nil then
          SetStrProp(ACtl, PropInfo, txt)
      end;
    end;
  end;

begin
  if csDesigning in ComponentState then
  begin
    AssignText(FCtlCompanyName, VersionInfoKeys[1]);
    AssignText(FCtlFileDescription, VersionInfoKeys[2]);
    AssignText(FCtlFileVersion, VersionInfoKeys[3]);
    AssignText(FCtlInternalName, VersionInfoKeys[4]);
    AssignText(FCtlLegalCopyRight, VersionInfoKeys[5]);
    AssignText(FCtlOriginalFileName, VersionInfoKeys[6]);
    AssignText(FCtlProductName, VersionInfoKeys[7]);
    AssignText(FCtlProductVersion, VersionInfoKeys[8]);
    AssignText(FCtlComments, VersionInfoKeys[9]);
    AssignText(FCtlReleaseDate, VersionInfoKeys[10]);
  end
  else
  begin
    AssignText(FCtlCompanyName, CompanyName);
    AssignText(FCtlFileDescription, FileDescription);
    AssignText(FCtlFileVersion, FileVersion);
    AssignText(FCtlInternalName, InternalName);
    AssignText(FCtlLegalCopyRight, LegalCopyRight);
    AssignText(FCtlOriginalFileName, OriginalFileName);
    AssignText(FCtlProductName, ProductName);
    AssignText(FCtlProductVersion, ProductVersion);
    AssignText(FCtlComments, Comments);
    AssignText(FCtlReleaseDate, ReleaseDate);
  end;
end;

///////////////////////////// TBCMA_Broker

function TBCMA_Broker.CallServer(RPC: string; callingParams: array of string;
  MultList: TStrings; TrueNull: Boolean = False): boolean;
const
  ParamTypeStrings: array[TParamType] of string =
  ('Literal', 'Reference', 'List', 'Global', 'Empty', 'Stream', 'Undefined');

var
// zzzzzzandria 2015-01-29 =====================================================
{$IFDEF ZZ_RPC_LOG}
  aStart, aStop: TDateTime;
  anEvent: TRPCEventItem;
{$ENDIF}
// zzzzzzandria 2015-01-29 =====================================================
  i, j: integer;
  emsg: string;
begin
  result := False;
  if socket = -1 then
    DefMessageDlg('No VistA server connection!', mtWarning, [mbOK], 0)
  else if connected = False then
    exit
  else
  begin
    // NOTE: Application.ProcessMessages is incorrect usage.
    // Allows interrupt of list handling and sorts which leads
    // to exceptions.  Also allows show / hide actions at inappopriate times.
    // Shows mostly in switching from Coversheet to other tabs.
//    Application.ProcessMessages;  // rpk 4/18/2011

    Screen.Cursor := crHourglass;
    RemoteProcedure := RPC;
    if TrueNull = false then
    begin

      //an empty array can't be passed, if we receive #127#127#, don't create any literals
      if callingParams[0] <> '~!#null#~!' then
        for i := 0 to High(callingParams) do
        begin
          Param[i].Value := callingParams[i];
          Param[i].PType := Literal;
        end;

      eMsg := 'RPC: ' + RPC;
      for i := 0 to Param.count - 1 do
        eMsg := eMsg + #13#10 + 'Param[' + intToStr(i) + ']=' +
          ParamTypeStrings[Param[i].ptype] + #9 + Param[i].value;

      i := Param.Count;                 // In case we have to add a list to the end....

      if MultList <> nil then
      begin
        for j := 0 to MultList.Count - 1 do
        begin
{$IFDEF ZZ_RPC_LOG}
          if pos('=', MultList[j]) = 0 then
            Param[i].Mult[IntToStr(j)] := MultList[j]
          else
            Param[i].Mult['"' + trim(piece(MultList[j], '=', 1)) + '"'] :=
              trim(piece(MultList[j], '=', 2));
{$ELSE}
          Param[i].Mult[IntToStr(j)] := MultList[j];
{$ENDIF}
          eMsg := eMsg + #13#10 + 'List[' + intToStr(j) + ']=' + #9 +
            MultList[j];
        end;
        Param[i].PType := List;
      end;
    end;
    if DebugMode then
      frmDebug.Execute('Calling RPC Broker', eMsg, nil);

    if useDebugLog then
    begin
      writeLogMessageProc('', nil);
      writeLogMessageProc(eMsg, nil);
    end;
{$IFDEF ZZ_RPC_LOG}                     // zzzzzzandria 2015-01-29 ===============================
    anEvent := nil;
    try
      aStart := Now;
      anEvent := getTRPCBEventItem(Self);
      Call;
      aStop := Now;
      anEvent.AppendResults(Self.Results, aStart, aStop);
      addRPCEvent(anEvent);
{$ELSE}
    try
      call;
{$ENDIF}                                // zzzzzzandria 2015-01-29 ===============================
      if DebugMode then
        frmDebug.Execute('RPC Broker Return Values', 'RPC Call: ' + RPC,
          Results);

      if useDebugLog then
      begin
        writeLogMessageProc('', nil);
        writeLogMessageProc(RPC + ', RPC Return Values:', nil, Results);
      end;

      result := True;
    except
      on E: EBrokerError do
      begin
        result := False;
        eMsg := eMsg + #13#10 + BrokerErrorMessages(E.Code, E.Mnemonic) +
          #13 + E.Message +
          #13#13 + 'BCMA failed to communicate with VistA and is unable' +
          #13#10 + 'to continue.  BCMA will now terminate.';
        DefMessageDlg('Broker RPC Error:' + #13 + eMsg, mtError, [mbOK], 0);
        E.message := eMsg + #13#10 + E.message;
{$IFDEF ZZ_RPC_LOG}
        if Assigned(anEvent) then
          anEvent.AppendError(E.Message);
        addRPCEvent(anEvent);
{$ELSE}
        if assigned(FLogErrorProc) then
          FLogErrorProc('Broker RPC Error:', E);
        Connected := False;
        ShutDown := True;
        application.terminate;
        abort;
{$ENDIF}
      end;
    end;
    Screen.Cursor := crDefault;
  end;
end;

///////////////////////////// TBCMA_User

constructor TBCMA_User.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  Clear;
end;

destructor TBCMA_User.Destroy;
begin
  (*
   if FChanged then
    if DefMessageDlg('The Current User data has been changed!'+#13#13+'Do you wish save your changes?',
           mtConfirmation, [mbYes, mbNo], 0) = idYes then
     SaveData;
  *)
  inherited Destroy;
end;

procedure TBCMA_User.Clear;
begin
  FDUZ := '';
  FUserName := '';
  FIsManager := False;
  FIsStudent := False;
  FIsMOButtonUser := False;
  FIsReadOnly := False;
  FUnableToScanKey := False;
  FDivisionIEN := '';
  FSiteIEN := '';
  FDivisionName := '';
  FAgencyCode := '';                    // rpk 8/6/2009
  FESigRequired := False;
  FOnLine := False;
  FDTime := '';
  FOrderRole := -1;

  FChanged := False;
  FProductionAccount := False;
end;

function TBCMA_User.LoadData: boolean;
begin
  result := False;
  try
    if FRPCBroker <> nil then
      with FRPCBroker do
      begin
        if FChanged then
          if DefMessageDlg('The Current User data has been changed!' + #13#13 +
            'Do you wish save your changes?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            SaveData;

        Clear;

        if CreateContext('PSB GUI CONTEXT - USER') then // this is a user
        begin
          if CheckVersion then
            exit;
          if CallServer('PSB USERLOAD', [''], nil) then
          begin
            if piece(FRPCBroker.Results[0], '^', 1) = '-1' then
            begin
              DefMessageDlg('Cannot load user parameters', mtError, [mbOK], 0);
              Exit;
            end;
            FDUZ := Results[0];
            FUserName := Results[1];
            FIsMOButtonUser := (StrToIntDef(Results[4], 0) = 1);
            FIsReadOnly := (StrToIntDef(Results[18], 0) = 1);
            FIsStudent := (StrToIntDef(Results[2], 0) = 1);

            //msf disable
{$IFDEF MSF_ON}
            FUnableToScanKey := (StrToIntDef(Results[24], 0) = 1);
{$ENDIF}
            if FIsStudent then
            begin
              // Load as a student
              FIsManager := False;
              FIsMOButtonUser := False;
              FUnableToScanKey := False;
            end
            else
            begin
              // Manager?
              FIsManager := (StrToIntDef(Results[3], 0) = 1);
            end;

            FDivisionIEN := piece(Results[7], '^', 1);
            FSiteIEN := piece(Results[7], '^', 2);
            FProductionAccount := (StrToIntDef(piece(Results[7], '^', 3), 0) =
              1);
            FDivisionName := Results[8];
            FESigRequired := (Results[9] = '1');
            FOnLine := (Results[10] = '1');
            FDTime := Results[11];
            // SDD for PSB USERLOAD AG is returned in 27,
            // S RESULTS(27)=$G(DUZ("AG"))  ;IHS/MSC/PLS

            // setIHS is an override to force the agency code to IHS when setIHS is true
            if setIHS then              // rpk 6/23/2010
              FAgencyCode := 'I'
            else begin
              // Results[27] does not exist in PSB*3*28
              if Results.Count > 27 then
                FAgencyCode := Results[27]
              else
                // default to VistA
                FAgencyCode := 'V';
            end;
            Result := True;             // User is considered loaded

            FChanged := False;
            if CallServer('ORWUBCMA USERINFO', [''], nil, True) then
              FOrderRole := StrToIntDef(Piece(Results[0], '^', 6), 0);

          end
        end
        else begin
          if assigned(FLogErrorProc) then
            FLogErrorProc('User Does Not Have Access To BCMA!', nil);
          DefMessageDlg('User Does Not Have Access To BCMA!', mtError, [mbok],
            0);
        end;
      end;
  except
    on e: EOleException do
    begin
      DefMessageDlg(e.message, mtError, [mbok], 0);
      if assigned(FRPCBroker.FLogErrorProc) then
        FRPCBroker.FLogErrorProc(e.message, nil);
      Result := False;
    end;
  end;
end;                                    // LoadData

procedure TBCMA_User.SaveData;
begin
  if FRPCBroker <> nil then
    if FChanged then
    begin
      (*
         Need an RPC to save VistA data for current user.
      *)
      FChanged := False;
    end;
end;

function TBCMA_User.isValidESig(ESig: string): boolean;
begin
  result := False;
  if FRPCBroker <> nil then
    with FRPCBroker do
      if CallServer('PSB VALIDATE ESIG', ['^' + encrypt(ESig)], nil) then
        result := (piece(Results[0], '^', 1) = '1');
end;

function TBCMA_User.getDTime: integer;
begin
  result := 0;
  if FDTime <> '' then
    result := strToIntDef(FDTime, 0);
end;

end.

