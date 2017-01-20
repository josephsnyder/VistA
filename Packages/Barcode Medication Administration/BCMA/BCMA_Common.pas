unit BCMA_Common;
{
================================================================================
*	File:  BCMA_Common.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 56 $  $Modtime: 5/06/02 10:35a $
*
*	Description:  This unit contains global constants, variables, objects and
*               methods for the application.
*
*
================================================================================
}

interface

uses
  SysUtils,
  Classes,
  Graphics,
  Forms,
  comctrls,
  BCMA_Objects,
  Windows,
  messages,
  Dialogs,
  Registry,
  Controls,                             // rpk 1/18/2013
  uCCOW,
  ExtCtrls,
  oReport,
  fDspMemo,
  BCMA_Main;

const
  DTFORMAT = 'YYYYMMDD.HHNN';
  CCOWErrorMessage = 'BCMA was unable to communicate with CCOW due to an error.  CCOW patient' // rpk 8/21/2013
    +
    ' synchronization will be unavailable for the remainder of this session.';

  //-KeyBoardTimerInterval = 250;     {Removed as a constant and made into a variable by JK 10/10/2008 to support a variable on the command line}

  MSF_Report_CR = '!~';
  {JK 8/17/2008 - the MSF Detailed Report will parse the comment line
for this token pair to force a carriage return.}

  ReportCaptions: array[TReportTypes] of string = ('Patient Due List',
    'Patient Medication Log',
    'Medication Admin History',
    'Patient Ward Administration Times',
    'Patient Missed Medications',
    'PRN Effectiveness List',
    'Medication Variance Log',
    'Vitals Cumulative',
    'Medication History',
    'Unknown Actions',
    'BCMA Unable to Scan (Detailed)',
    'BCMA Unable to Scan (Summary)',

    'Medication Overview',
    'PRN Overview',
    'IV Overview',
    'Expired/DC''d/Expiring Orders',
    'Medication Therapy',
    'IV Bag Status',

    'Patient Inquiry',
    'Patient Allergy List',
    'BCMA - Display Order',
    'Patient Flags');

  ReportTypeCodes: array[TReportTypes] of string = ('DL',
    'ML',
    'MH',
    'WA',
    'MM',
    'PE',
    'MV',
    'VT',
    'PM',
    'XA',
    'SF',
    'ST',

    'CM',
    'CP',
    'CI',
    'CE',
    'MT',
    'IV',

    'PI',
    'AL',
    'DO',
    'PF');

  ScanStatusCodes: array[TScanStatus] of string = ('I',
    'S',
    'C',
    'H',
    'R',
    'M',
    'RM',
    'A',
    'N',
    'G',
    'U');

  ScanStatusText: array[TScanStatus] of string = ('Infusing',
    'Stopped',
    'Completed',
    'Held',
    'Refused',
    'Missing',
    'Removed',
    'Available',
    'Not Given',
    'Given',
    '*Unknown*');

  // RPK: in body site list, the body site name is the first piece,
  //  the injection flag (1) is the second piece,
  // the dermal flag (1) is the third piece
  injpos = 2;
  dermpos = 3;
  sitedelim = '|';

type
  TSiteType = (stInjection, stDermal);


var
  // add Witness in sixth column
  VDLColumnTitles: array[TVDLColumnTypes] of string =
  ('Clinic', 'Status', 'Ver', 'Hsm', 'Type',
  // replace Wit with Alert to include MRR icon
{$IFDEF CAS_DDPE_RST}
    'Alert',                            // 'Wit',
{$ELSE}
    'Wit',
{$ENDIF}

    'Active Medication', 'Dosage', 'Route',
{$IFDEF CAS_DDPE_RST}
    'Next Dose Action',                 //'R St.', -- Column Name for ctRemovalStatus column
{$ENDIF}
//    'Admin Time',
//    '',                                 // rpk 6/22/2016
    'Last Action', 'Last Site');
const
(*
{$IFDEF CAS_DDPE_RST}
  VDLColumnHints: array[TVDLColumnTypes] of string =
  ('Clinic', 'Status', 'Ver', 'Hsm', 'Type',
{$IFDEF CAS_DDPE_RST}
    'Alert',
{$ELSE}
    'Witness Required',
{$ENDIF}
    'Active Medication', 'Dosage', 'Route',
    'Removal Status',
    'Administration  Time',
    'Last Action', 'Last Site');
{$ENDIF}
 *)

{$IFDEF CAS_DDPE_RST}
  UDColumnHints: array[TVDLColumnTypes] of string =
  ('Clinic', 'Status', 'Ver', 'Hsm', 'Type',
{$IFDEF CAS_DDPE_RST}
    'Alert',
{$ELSE}
    'Witness Required',
{$ENDIF}
    'Active Medication', 'Dosage', 'Route',
    'Next Dose Action',
//    'Administration  Time',
//    'Admin Time',
    'Last Action', 'Last Site');
{$ENDIF}

  VDLColumnWidths: array[TVDLColumnTypes] of integer =
  (80, 40, 28, 33, 30,
    45,                                 //35 to 45, // increased to suit the fixed position of the RR icon
    245, 120, 80,
{$IFDEF CAS_DDPE_RST}
    105,
{$ENDIF}
//    80,                                 // aan removing Admin Time 80, // increase admin time width to 120  rpk 6/12/2012
    160, 60);

  // add Witness in fifth column
  lstPBColumnTitles: array[lstPBColumnTypes] of string =
  ('Clinic', 'Status', 'Ver', 'Type',
{$IFDEF CAS_DDPE_RST}
    'Alert',
{$ELSE}
    'Wit',                              // 'Witness Required',
{$ENDIF}
    'Medication/Solutions',             // rpk 5/11/2012
    'Infusion Rate', 'Route',
{$IFDEF CAS_DDPE_RST}
    'Next Dose Action',
{$ENDIF}
//    'Admin Time',
//    '',                                 // rpk 6/22/2016
    'Last Action', 'Last Site');

{$IFDEF CAS_DDPE_RST}
  PBColumnHints: array[lstPBColumnTypes] of string =
  ('Clinic', 'Status', 'Ver', 'Type',
{$IFDEF CAS_DDPE_RST}
    'Alert',
{$ELSE}
    'Witness Required',
{$ENDIF}
    'Medication/Solutions',
    'Infusion Rate', 'Route',
    'Next Dose Action',
//    'Admin  Time',
    'Last Action', 'Last Site');
{$ENDIF}

  lstPBColumnWidths: array[lstPBColumnTypes] of integer =
  (80, 40, 35, 30, 35, 240,             // rpk 5/11/2012
    150, 90,
{$IFDEF CAS_DDPE_RST}
    105,
{$ENDIF}
//    80,                           // increase admin time width to 80  rpk 6/12/2012
    160, 60);

  // add Witness in fifth column, Stop Date in tenth column
  lstIVColumnTitles: array[lstIVColumnTypes] of string =
  ('Clinic', 'Status', 'Ver', 'Type',
{$IFDEF CAS_DDPE_RST}
    'Alert',
{$ELSE}
    'Wit',                              // 'Witness Required',
{$ENDIF}
    'Medication/Solutions',             // rpk 5/11/2012
    'Infusion Rate', 'Route',
    'Bag Information', 'Order Stop Date'); // rpk 2/27/2013

{$IFDEF CAS_DDPE_RST}
  IVColumnHints: array[lstIVColumnTypes] of string =
  ('Clinic', 'Status', 'Ver', 'Type',
{$IFDEF CAS_DDPE_RST}
    'Alert',
{$ELSE}
    'Wit',                              // 'Witness Required',
{$ENDIF}
    'Medication/Solutions',
    'Infusion Rate', 'Route',
    'Bag Information', 'Order Stop Date');
{$ENDIF}

  // add Witness in fifth column, Stop Date in tenth column
  lstIVColumnWidths: array[lstIVColumnTypes] of integer =
  (80, 50, 35, 60, 35, 240,
    140, 100, 170, 100);                // rpk 5/11/2012

  lstBagDetailColumnTitles: array[lstBagDetailColumnTypes] of string =
  ('Date/Time', 'Nurse', 'Action', 'Comments');

  lstBagDetailColumnWidths: array[lstBagDetailColumnTypes] of integer =
  (105, 50, 60, 225);

  //Converts columns to tag values for linking the Sort BY column menu options
  //to the actual column on the VDL
  {TVDLColumnTypes = (ctScanStatus, 0
    ctVerifyNurse,                  1
    ctSelfMed,                      2
    ctScheduleType,                 3
    ctActiveMedication,             4
    ctDosage,                       5
    ctRoute,                        6
    ctRemovalStatus,           7
    ctTimeLastGiven,                8
    ctLastSite); // rpk 12/1/2011   9}
  {TSortMnuTagTypes = (stStatus, 0 // rpk 3/7/2012
  stVerifyNurse,                 1
  stHSM,                         2
  stType,                        3
  stActiveMedication,            4
  stDosage,                      5
  stRoute,                       6
  stRemovalStatus,                   7
  stLastAction,                  8
  stMedSoln,                     9
  stInfusionRate,                10
  stBagInfo,                     11
  stLastSite);                   12 }
  // use sort menu tag number enum values
  lstValidUDSortColumns: array[TVDLColumnTypes] of integer =
  (ord(stClinicName),
    ord(stStatus),
    ord(stVerifyingNurse),
    ord(stHospitalSelfMed),
    ord(stType),
    ord(stWitness),                     // rpk 5/11/2012
    ord(stActiveMedication),
    ord(stDosage),
    ord(stRoute),
{$IFDEF CAS_DDPE_RST}
    ord(stRemovalStatus),
{$ENDIF}
//    ord(stAdministrationTime),
    ord(stLastAction),
    ord(stLastSite));

  {lstPBColumnTypes = (pbScanStatus, 0
    pbVerifyNurse, 1
    pbScheduleType, 2
    pbActiveMedication, 3
    pbInfusionRate, 4
    pbRoute, 5
    pbRemovalStatus, 6
    pbLastAction, 7
    pbLastSite);  8}// rpk 2/15/2012
  {TSortMnuTagTypes = (stStatus, 0 // rpk 3/7/2012
  stVerifyNurse,                 1
  stHSM,                         2
  stType,                        3
  stActiveMedication,            4
  stDosage,                      5
  stRoute,                       6
  stAdminTime,                   7
  stLastAction,                  8
  stMedSoln,                     9
  stInfusionRate,                10
  stBagInfo,                     11
  stLastSite);                   12 }
//  use sort menu tag enum values
  lstValidPBSortColumns: array[lstPBColumnTypes] of integer =
  (ord(stClinicName),
    ord(stStatus),
    ord(stVerifyingNurse),
    ord(stType),
    ord(stWitness),                     // rpk 5/11/2012
    ord(stMedicationSolution),
    ord(stInfusionRate),
    ord(stRoute),
{$IFDEF CAS_DDPE_RST}
    ord(stRemovalStatus),
{$ENDIF}
//    ord(stAdministrationTime),
    ord(stLastAction),
    ord(stLastSite));

  { lstIVColumnTypes = (ivOrderStatus,
    ivVerifyNurse,
    ivType,
    ivMedicationSolution,
    ivInfusionRate,
    ivRoute,
    ivBagInformation); }
  {TSortMnuTagTypes = (stStatus, 0 // rpk 3/7/2012
  stVerifyNurse,                 1
  stHSM,                         2
  stType,                        3
  stActiveMedication,            4
  stDosage,                      5
  stRoute,                       6
  stAdminTime,                   7
  stLastAction,                  8
  stMedSoln,                     9
  stInfusionRate,                10
  stBagInfo,                     11
  stLastSite);                   12 }
//  lstValidIVSortColumns: array[lstIVColumnTypes] of integer =
//  (0, 1, 3, 9, 10, 6, 11);
  lstValidIVSortColumns: array[lstIVColumnTypes] of integer =
  (ord(stClinicName),
    ord(stStatus),
    ord(stVerifyingNurse),
    ord(stType),
    ord(stWitness),                     // rpk 5/11/2012
    ord(stMedicationSolution),
    ord(stInfusionRate),
    ord(stRoute),
    ord(stBagInformation),
    ord(stOrderStopDate));              // rpk 5/11/2012

  CloseableForms: array[0..11] of string =
  ('frmPtSelect', 'frmReport', 'frmReportRequest', 'frmPrint',
    'frmPtConfirmation',
    'frmEditMedLogAdminSelect', 'frmInstructor', 'frmScanWristband',
    'frmDspMemo', 'frmLegend',
    'frmPrtClinicSel', 'frmPtSelect');
  CloseableFormsByCaption: array[0..0] of string = (
    'Patient Lookup');
  IconArray: array[0..5] of PChar = (
    IDI_APPLICATION,
    IDI_ASTERISK,
    IDI_EXCLAMATION,
    IDI_HAND,
    IDI_QUESTION,
    IDI_WINLOGO);
  UnableToScanSortParameters: array[0..6] of string = (
    'Patient''s Name',
    'Event Dt/Tm',
    'Location Ward/RmBd',
    'Type',
    'Drug item (ID)',
    'User''s Name',
    'Reason Unable to Scan');

var
  KeyBoardTimerInterval: Integer = 400; {JK 10/10/2008}

  BCMA_Patient: TBCMA_Patient;
  BCMA_UserParameters: TBCMA_UserParameters;
  BCMA_SiteParameters: TBCMA_SiteParameters;
  BCMA_ScannedDrug: TBCMA_DispensedDrug;
  BCMA_Report: TBCMA_Report;
  BCMA_OMScannedMeds: TBCMA_OMScannedMeds;
  BCMA_OMMedOrder: TBCMA_OMMedOrder;
  BCMA_CCOW: TVACCOW;
  BCMA_EditMedLog: TBCMA_EditMedLog;

  VisibleMedList: TList;
  IVHistoryDates: TList;
  ForceRefresh: Boolean;
  EditedAdministration: Boolean;
  //if admin edited via EditMedLog, set to true, will refresh VDL
  cmtUserComments,
    cmtReasonGivenPRN: string;
  IVHistClearing: Boolean;
  WardList: TStringList;
  UnableToScan: Boolean;                //Did the user select the 'unable to scan' menu option?
  KeyBoardTimer: TTimer;
  KeyBoardTimerHandler: TBCMA_TimerHandler;
  KeyedBarCode: Boolean;                //Did they manually type a bar code?

  // NurseVfyState includes NotCalled, Give, or NotGive.  Start a current process
  // with NotCalled.  When CheckNonNurseVfy is first called, prompt or notify
  // depending on Nurse Verify parameter.  Once a choice is made to give or not give,
  // when CheckNonNurseVfy is called again during current process, return the
  // value decided.
  NurseVfyState: ChkNurseVfyReturnValues;

  MOBINFO: TMobInfo;                    // P77

function DisplayVADate(MDateTime: string): string;
(*
 Formats an M DateTime value for display.
*)

//function DisplayVAMDY(MDateTime: string): string;

function DisplayVADateYearTime(MDateTime: string): string;
{*
  Same as DisplayVADate but adds a four digit year.
*}

function DisplayVADateYear(MDateTime: string): string;
{*
  Same as DisplayVADate but adds a four digit year, no time.
*}

function GetComments(patientIen, OrderNum: string; outstrlist: TStringList):
  string;
{
   Get the full set of comments for Special Instructions or Other Info.
   PSB GETORDERTAB returns only the first line of Special Instructions.
}

function DisplayMemoList(Capstr, memStr: string; StrList: TStringList; CancelOn:
  Boolean): Integer;

function ValidMDateTime(var DateTimeText: string): string;
(*
  Uses RPC 'PSB FMDATE' to validate a Date/Time text string.  If the string is
  a valid M DateTime value, the function result returns the value in M
  DateTime format and the argument returns a formated, displayable string.
*)

function DateTimeToMDateTime(vDateTime: TDateTime): string;
(*
  Converts a TDateTime value into an M DateTime value.
*)

function DateToMDate(vDate: TDate): string;
{
  Converts a TDate value to an M Date value
}

function getTextWidth(nChars: integer; curFont: TFont): integer;
(*
  Returns the width, in pixels, of a text string filled with 'X' characters in
  curFont.
*)

function getTextHeight(curFont: TFont): integer;
(*
  Returns the height, in pixels, of an 'X' character in curFont.
*)

function rPos(sub, str: string): integer;
(*
  Finds the position of a substring, searching from the right.
*)

procedure ReAdjustHdr(HdrControl: THeaderControl); // rpk 3/14/2012

function GetLastActivityStatus(StringIn: string): string;

function GetIVType(StringIn: string): string;

function GetOrderStatus(StringIn: string): string;

function getScanStatusID(StringIn: string): TScanStatus;

function SubsetOfDevices(const StartFrom: string; Direction: Integer): TStrings;

procedure CheckMOBDLL;

//procedure InitPainScore(PainScoreList: TStrings);  // 6/11/2012

function SendVitals(Value: string; MDateTime: string = ''): Boolean;

function CloseForms(CloseForm: Boolean): Boolean;

function SameDateTime(const DT1, DT2: TDateTime): Boolean;

function TimeApartInMins(const DT1, DT2: TDateTime): Extended;

function CheckForUnknowns(aMedOrder: TBCMA_MedOrder): Boolean;

function LogUnableToScan(OrderNum, Reason, Comment, UnableToScanString,
  ScanType: string; Method: Integer = 0): Boolean;
{
  Uses RPC 'PSB MAN SCAN FAILURE' to log an 'unable to scan' event. This is
  triggered by the user selecting 'unable to scan' or via a manually entered
  bar code which is caught by a timer even on the edit boxes.
  ScanType can be W for wristband or M for medication.
  The three methods (Method) of entry for the string passed in (UnableToScanString) are:
  0: user selected Unable to Scan
  1: user typed the entry
  2: the string was scanned via a scanner
}

procedure StartKeyboardTimer;

procedure StopKeyboardTimer;

function IsRestricted: Boolean;

procedure PrintReport;

function LogComments(MedLogIEN: string; CommentsIn: TStringList): Boolean;
(*
  New function to log additional comments that we might have. Log order only
  allows for the logging of one comment. This new method will allow for
  the logging of an unlimited number of comments
*)

function DaysHoursMinutesPast(FMDateTimeIn: string): string;

function BuildCommentLine(SystemComment, UserComment: string): string;

// body site flag functions
function isInjectionSite(inSite: string): Boolean;
function isDermalSite(inSite: string): Boolean;
function GetSite(inSite: string): string;
function PopulateSiteList(inList, outList: TStrings; inType: TSiteType;
  inSingle: Boolean): Integer;
function SelectAnatomicalLocation(aDivision, aGroupName: string; inSite:
  TSiteType): string;

//Load the MOBInfo object
//function LoadMOBInfo(const DllName: String): Boolean; // P77
procedure LoadMOBInfo(const DllName: string); // P77


implementation

uses
  StdCtrls,
//  MFunStr,
  BCMA_Startup,
  BCMA_Util,
  Splash,
  VHA_Objects,
  fPrint,
  uOrderMgr,
  Math,
  frmALMap;

function rPos(sub, str: string): integer;
(* Find the position of a substring, searching from the right. *)
var
  ii,
    ls: integer;
begin
  ls := length(sub);
  ii := length(str) - ls + 1;
  while (copy(str, ii, ls) <> sub) and (ii > 0) do
    dec(ii);
  result := ii;
end;

function getTextWidth(nChars: integer; curFont: TFont): integer;
var
  tlbl: TLabel;
begin
  // reworked to check for failures; rpk 1/3/2012
  result := 0;
  tlbl := TLabel.Create(Application);
  if tlbl <> nil then begin
    try                                 // rpk 2/23/2012
      with tlbl do begin
        font.assign(curFont);
        // use assembly routine StringOfChar
        caption := StringofChar('X', nChars); // rpk 1/3/2012
        result := width;
      end;
    finally
      tlbl.free;
    end;
  end;
end;

function getTextHeight(curFont: TFont): integer;
begin
  with TLabel.create(Application) do try
    font.assign(curFont);
    caption := 'X';
    result := height;
  finally
    free;
  end;
end;

function ValidMDateTime(var DateTimeText: string): string;
var
  TempMDateTime: string;
begin
  result := '';
  with BCMA_Broker do
    if CallServer('PSB FMDATE', [DateTimeText], nil) then
      if piece(results[0], '^', 1) = '-1' then
        DefMessageDlg(piece(results[0], '^', 2), mtError, [mbOK], 0)
      else begin
        DateTimeText := piece(results[0], '^', 2);
        //jcs 04/06/04 strip seconds off.  If seconds are someone returned via this call, then the
        //human readable text with the seconds passes through here a second time to be validated
        //seconds are not valid, ie MAR 29, 2004@11:21:37
        DateTimeText := piece(DateTimeText, '@', 1) + '@' +
          pieces(piece(DateTimeText, '@', 2), ':', 1, 2);
        TempMDateTime := piece(results[0], '^', 1);
        result := piece(TempMDateTime, '.', 1) + '.' + copy(piece(TempMDateTime
          +
          '0000', '.', 2), 1, 4)
      end;
end;

function DisplayVADate(MDateTime: string): string;
var
  ss: string;
begin
  result := '';
  if MDateTime <> '' then begin
    ss := MDateTime;
    result := copy(ss, rPos('.', ss) - 4, 2) + '/' +
      copy(ss, rPos('.', ss) - 2, 2) + '@' +
      copy(ss, pos('.', ss) + 1, 99) + '00000';
    result := copy(result, 1, 10);
  end;
end;

{ function DisplayVAMDY(MDateTime: string): string;
var
  ss: string;
begin
  result := '';
  if MDateTime <> '' then begin
    ss := MDateTime;
    result := copy(ss, rPos('.', ss) - 4, 2) + '/' +
      copy(ss, rPos('.', ss) - 2, 2) + '@' +
      copy(ss, pos('.', ss) + 1, 99) + '00000';
    result := copy(result, 1, 10);
  end;
end; }

function DateTimeToMDateTime(vDateTime: TDateTime): string;
var
  ii: integer;
  h, n, s, l: Word;
begin
  //  result := formatDateTime('YYYYMMDD.HHNN', aDateTime);

  DecodeTime(vDateTime, h, n, s, l);
  if (h = 0) and (n = 0) then
    vDateTime := vDateTime - 1;
  result := formatDateTime(DTFORMAT, vDateTime);
  if (h = 0) and (n = 0) then
    Result := StringReplace(Result, '.0000', '.2400', []);
  ii := strToInt(copy(result, 1, 2)) - 17;
  result := intToStr(ii) + copy(result, 3, 999);
end;

function DateToMDate(vDate: TDate): string;
const
  minute = 1 / (24 * 60);
var
  MDateTime: string;
begin
  Result := '';

  MDateTime := DateTimeToMDateTime(vDate + minute);
  if MDateTime <> '' then begin         // rpk 12/21/2012
    MDateTime := piece(MDateTime, '.', 1); // rpk 12/21/2012
    Result := MDateTime;                // rpk 12/21/2012
  end;
end;                                    // DateToMDate

function DisplayVADateYearTime(MDateTime: string): string;
var
  ss,
    tt: string;
  dd: TDate;
  d, m, y: Integer;
begin
  result := '';
  if MDateTime <> '' then begin
    ss := MDateTime + '0000';
    m := StrToInt(copy(ss, rPos('.', ss) - 4, 2));
    d := StrToInt(copy(ss, rPos('.', ss) - 2, 2));
    y := (StrToInt(copy(ss, rPos('.', ss) - 7, 3)) + 1700);

    if copy(ss, pos('.', ss) + 1, 4) = '' then
      tt := '2400'
    else
      tt := copy(ss, pos('.', ss + '0000') + 1, 4);

    try
      begin
        dd := EncodeDate(y, m, d);
        Result := DateToStr(dd) + '@' + tt;
      end;
    except
      Result := 'Error' + '@' + tt;
    end
  end;
end;

function DisplayVADateYear(MDateTime: string): string;
var
  ss: string;
  dd: TDate;
  d, m, y: Integer;
begin
  result := '';
  try
    if MDateTime <> '' then begin
      ss := MDateTime;
      m := StrToInt(copy(ss, rPos('.', ss) - 4, 2));
      d := StrToInt(copy(ss, rPos('.', ss) - 2, 2));
      y := (StrToInt(copy(ss, rPos('.', ss) - 7, 3)) + 1700);

      dd := EncodeDate(y, m, d);
      Result := DateToStr(dd);
    end
    else
      result := 'Error';
  except
    Result := 'Error';
  end;
end;

function GetComments(patientIen, OrderNum: string; outstrlist: TStringList):
  string;
var
  i: Integer;
  cntstr, errstr, resstr: string;
begin
  if outstrlist = nil then
    exit;

  Result := '';
  outstrlist.Clear;
  resstr := '';

  try

    with BCMA_Broker do begin
      if CallServer('PSB GETCOMMENTS', [patientIen, OrderNum], nil) then begin
        // if count = 1, only an END tag is present, no results
        // loop through count - 2 to avoid 'END' string at end of list
        // insert CRLF in front of new results to avoid CRLF after last line.
        if Results.Count > 1 then begin
          cntstr := Results[0];         // rpk 11/3/2011
          errstr := Results[1];
          if piece(errstr, U, 1) <> '-1' then begin
            for I := 1 to Results.Count - 2 do begin // rpk 9/30/2009
              resstr := resstr + CRLF + Results[i]; // rpk 9/30/2009
              outstrlist[i - 1] := Results[i];
            end;                        // rpk 9/30/2009
          end;

        end;
        Result := resstr;
      end;
    end;

  finally
    ;
  end;

end;                                    // GetComments


function DisplayMemoList(Capstr, memStr: string; StrList: TStringList; CancelOn:
  Boolean): Integer;
var
  cancelleft, okleft: Integer;
  fheight, numlines: Integer;
begin
  numlines := 0;

  frmDspMemo := TfrmDspMemo.Create(Application); // rpk 3/14/2012
  try                                   // rpk 2/23/2012
    frmDspMemo.Caption := Capstr;
    cancelleft := frmDspMemo.bbCancel.Left;
    okleft := frmDspMemo.bbOK.Left;
    if CancelOn then begin
      frmDspMemo.bbCancel.Show;
    end
    else begin
      frmDspMemo.bbCancel.Hide;
      frmDspMemo.bbOK.Left := cancelleft;
      frmDspMemo.bbOK.BringToFront;
    end;

    frmDspMemo.Memo1.Clear;

    if (StrList <> nil) and (StrList.Text > '') then begin // rpk 1/6/2012
      numlines := strList.Count;        // rpk 2/6/2012
      frmDspMemo.Memo1.Lines.Assign(StrList);
    end
    else if memstr > '' then begin
      numlines := 1;
      frmDspMemo.Memo1.Text := memStr;
    end;

    frmDspMemo.Memo1.SelStart := 0;     // rpk 3/14/2012

    fheight := getTextHeight(frmDspMemo.Memo1.Font);

    frmDspMemo.ClientHeight := (fheight * (numlines + 2)) +
      frmDspMemo.Panel1.Height;         // rpk 2/8/2012
    frmDspMemo.Height := min(frmDspMemo.Height, Screen.WorkAreaHeight); // rpk 2/6/2012

    if frmDspMemo.Visible then          // rpk 5/13/2009
      frmDspMemo.Hide;
    Result := frmDspMemo.ShowModal;

    if not CancelOn then
      frmDspMemo.bbOK.Left := okleft;
  finally
    frmDspMemo.Release;                 // rpk 6/18/2013
  end;
end;                                    // DisplayMemoList

// NOTE 2/12/2016: use minwidth := 0 and maxwidth := 0 to suppress display of column when appropriate.
// Allow width to be set by user and saved in BCMA_UserParameters.SaveData.
// The widths will also be restored to user preferences in BCMA_UserParameteres.LoadData.
// This allows the column width arrays (e.g., VDLColumnWidths) to save the widths
// and transfer column widths to multiorder form, etc.

procedure ReadjustHdr(HdrControl: THeaderControl);
const
  cminwidth = 30;                       // narrow column minimum width, ~5 characters
  wminwidth = 50;                       // Witness, Alert minimum width
  rminwidth = 115;                      // Remove Status, Next Action maximum width; keep date/time on separate line
  // in rminwidth, allow space for "DETAILS FOR RM"
var
  TotalWidth, TempWidth, minwid: Integer;
  ii: Integer;
  narrowcol: Integer;
begin
  HdrControl.Sections.BeginUpdate;

  // allow the first columns on a VDL tab to use narrower widths
  // use the column for the active medication (medication/solution) as the
  // delimiter.  Starting with this column use the HdrMinWidth set in frmMain.
  case lstCurrentTab of
    ctUD: narrowcol := ord(ctActiveMedication);
    ctPB: narrowcol := ord(pbMedicationSolution);
    ctIV: narrowcol := ord(ivMedicationSolution);
  else
    narrowcol := ord(ctActiveMedication);
  end;


  with HdrControl.Sections do begin
    // In Inpatient mode, suppress display of Clinic Name column
    if (OrderMode = omInpatient) then begin
      items[ord(ctClinicName)].minwidth := 0;
      items[ord(ctClinicName)].maxwidth := 0; // rpk 2/12/2016
//      if lstCurrentTab = ctUD then      // rpk 5/15/2012
//        items[ord(ctSelfMed)].Width := VDLColumnWidths[ctSelfMed];
      case lstCurrentTab of             // rpk 6/27/2012
        ctUD: begin
            items[ord(ctSelfMed)].Width := VDLColumnWidths[ctSelfMed]; // rpk 9/23/2016
            items[ord(ctClinicName)].width := VDLColumnWidths[ctClinicName];
            items[ord(ctRemovalStatus)].width := VDLColumnWidths[ctRemovalStatus]; // rpk 9/23/2016
          end;
        ctPB: begin
            items[ord(pbClinicName)].width := lstPBColumnWidths[pbClinicName];
            items[ord(pbRemovalStatus)].width := lstPBColumnWidths[pbRemovalStatus]; // rpk 9/23/2016
          end;
        ctIV:
          items[ord(ivClinicName)].width := lstIVColumnWidths[ivClinicName];
        ctCS: ;
      end;
    end
    else begin                          // Clinic order mode
      // in ClinicOrder mode, unit dose does not show HSM (self med)
      if lstCurrentTab = ctUD then begin // rpk 5/15/2012
        items[ord(ctSelfMed)].MinWidth := 0;
        items[ord(ctSelfMed)].MaxWidth := 0; // rpk 2/12/2016
      end;
      case lstCurrentTab of             // rpk 6/27/2012
        ctUD: begin
            items[ord(ctClinicName)].width := VDLColumnWidths[ctClinicName];
            items[ord(ctRemovalStatus)].width := VDLColumnWidths[ctRemovalStatus]; // rpk 9/23/2016
          end;
        ctPB: begin
            items[ord(pbClinicName)].width := lstPBColumnWidths[pbClinicName];
            items[ord(pbRemovalStatus)].width := lstPBColumnWidths[pbRemovalStatus]; // rpk 9/23/2016
          end;
        ctIV:
          items[ord(ivClinicName)].width := lstIVColumnWidths[ivClinicName];
        ctCS: ;
      end;
    end;

    {Set the maxwidth so columns can't be scrolled off window}
    TotalWidth := 0;
    for ii := 0 to Count - 1 do begin
      TempWidth := ((Count - (ii + 1)) * HdrMinWidth); // rpk 2/23/2012
      items[ii].maxwidth := HdrControl.width - (TempWidth +
        TotalWidth);
      TotalWidth := TotalWidth + Items[ii].Width;

      if ii = ord(ctClinicName) then begin // rpk 6/20/2012
        if OrderMode = omInpatient then
          minwid := 0
        else
          minwid := min(items[ii].MaxWidth, HdrMinWidth) // 8 characters
      end
      else if ii = ord(ctSelfMed) then begin
        if (OrderMode = omClinic) and (lstCurrentTab = ctUD) then // rpk 5/15/2012
          minwid := 0
        else
          minwid := min(items[ii].MaxWidth, cminwidth) // 5 characters
      end
      // ensure Witness column is wide enough to display Witness and Removal icons
      else if ii = ord(ctWitness) then begin // rpk 7/17/2015
        minwid := min(items[ii].MaxWidth, wminwidth) // rpk 7/17/2015
      end                               // rpk 7/17/2015
{$IFDEF CAS_DDPE_RST}
      else if (lstCurrentTab = ctUD) and (ii = ord(ctRemovalStatus)) then begin // rpk 7/17/2015
        minwid := min(items[ii].MaxWidth, rminwidth); // rpk 8/6/2015
      end                               // rpk 7/17/2015
      else if (lstCurrentTab = ctPB) and (ii = ord(pbRemovalStatus)) then begin // rpk 7/17/2015
        minwid := min(items[ii].MaxWidth, rminwidth); // rpk 8/6/2015
      end                               // rpk 7/17/2015
{$ENDIF}
      else if ii < narrowcol then       // rpk 3/14/2012
        minwid := min(items[ii].MaxWidth, cminwidth) // 5 characters
      else
        minwid := min(items[ii].MaxWidth, HdrMinWidth); // 8 characters


      items[ii].MinWidth := minwid;
      if minwid = 0 then
        items[ii].MaxWidth := 0
      // if minwidth = maxwidth, user cannot change column width;
      // allow user to change width of column
      else if (items[ii].MinWidth > 0) and // rpk 2/12/2016
        (items[ii].MinWidth = items[ii].MaxWidth) then
        items[ii].MaxWidth := items[ii].MinWidth + 1;

    end;                                // for ii

    // In Inpatient mode, suppress display of Clinic Name column
    if (OrderMode = omInpatient) then begin
      if items[ord(ctClinicName)].minwidth <> 0 then
        items[ord(ctClinicName)].minwidth := 0;
      if items[ord(ctClinicName)].maxwidth <> 0 then
        items[ord(ctClinicName)].maxwidth := 0;
    end
    else begin
      // in ClinicOrder mode, unit dose does not show HSM (self med)
      if lstCurrentTab = ctUD then begin // rpk 5/15/2012
        if items[ord(ctSelfMed)].MinWidth <> 0 then
          items[ord(ctSelfMed)].MinWidth := 0;
        if items[ord(ctSelfMed)].MaxWidth <> 0 then
          items[ord(ctSelfMed)].MaxWidth := 0;
      end;
    end;
{$IFDEF CAS_DDPE_RST}
    // NOTE: when pgctrlVirtualDueList is changing, the tab has changed.
    // However, the header columns minwidth and maxwidth of the former tab are
    // still being accessed and reset to 0.
    // For example, when changing from UD to PB, pbAdministrationTime (9)
    // is actually setting the ctRemovalStatus column (9) to 0.
    { if (lstCurrentTab = ctUD) then begin
      items[ord(ctAdministrationTime)].MinWidth := 0;
      items[ord(ctAdministrationTime)].MaxWidth := 0;
    end
    else if (lstCurrentTab = ctPB) then begin
      items[ord(pbAdministrationTime)].MinWidth := 0;
      items[ord(pbAdministrationTime)].MaxWidth := 0;
    end; }
{$ENDIF}

    // In Inpatient mode, suppress display of Clinic Name column
    if (OrderMode = omInpatient) then begin
      items[ord(ctClinicName)].minwidth := 0;
      items[ord(ctClinicName)].maxwidth := 0; // rpk 2/12/2016
      // set widths after minwidth and maxwidth are reset for these columns
      { case lstCurrentTab of             // rpk 6/27/2012
        ctUD: begin
            items[ord(ctSelfMed)].Width := VDLColumnWidths[ctSelfMed]; // rpk 9/23/2016
            items[ord(ctClinicName)].width := VDLColumnWidths[ctClinicName];
            items[ord(ctRemovalStatus)].width := VDLColumnWidths[ctRemovalStatus]; // rpk 9/23/2016
          end;
        ctPB: begin
            items[ord(pbClinicName)].width := lstPBColumnWidths[pbClinicName];
            items[ord(pbRemovalStatus)].width := lstPBColumnWidths[pbRemovalStatus]; // rpk 9/23/2016
          end;
        ctIV:
          items[ord(ivClinicName)].width := lstIVColumnWidths[ivClinicName];
        ctCS: ;
      end; }
    end
    else begin                          // Clinic order mode
      // in ClinicOrder mode, unit dose does not show HSM (self med)
      if lstCurrentTab = ctUD then begin // rpk 5/15/2012
        items[ord(ctSelfMed)].MinWidth := 0;
        items[ord(ctSelfMed)].MaxWidth := 0; // rpk 2/12/2016
      end;
      { case lstCurrentTab of             // rpk 6/27/2012
        ctUD: begin
            items[ord(ctClinicName)].width := VDLColumnWidths[ctClinicName];
            items[ord(ctRemovalStatus)].width := VDLColumnWidths[ctRemovalStatus]; // rpk 9/23/2016
          end;
        ctPB: begin
            items[ord(pbClinicName)].width := lstPBColumnWidths[pbClinicName];
            items[ord(pbRemovalStatus)].width := lstPBColumnWidths[pbRemovalStatus]; // rpk 9/23/2016
          end;
        ctIV:
          items[ord(ivClinicName)].width := lstIVColumnWidths[ivClinicName];
        ctCS: ;
      end; }
    end;

  end;                                  //   with HdrControl.Sections

  HdrControl.Sections.EndUpdate;

end;                                    // ReadjustHdr


function GetLastActivityStatus(StringIn: string): string;
begin
  if StringIn = 'G' then
    Result := 'GIVEN'
  else if StringIn = 'H' then
    Result := 'HELD'
  else if StringIn = 'R' then
    Result := 'REFUSED'
  else if StringIn = 'RM' then
    Result := 'REMOVED'
  else if StringIn = 'M' then
    Result := 'MISSING DOSE'
  else if StringIn = 'I' then
    Result := 'INFUSING'
  else if StringIn = 'S' then
    Result := 'STOPPED'
  else if stringIn = 'C' then
    Result := 'COMPLETED'
  else if stringIn = 'A' then
    Result := 'AVAILABLE'
  else if stringIn = 'N' then
    Result := 'NOT GIVEN'
  else if stringIn = 'U' then
    Result := '*UNKNOWN*'
  else
    Result := StringIn;
end;

function GetIVType(StringIn: string): string;
begin
  if StringIn = 'A' then
    Result := 'Admixture'
  else if StringIn = 'H' then
    Result := 'Hyperal'
  else if StringIn = 'C' then
    Result := 'Chemotherapy'
  else if StringIn = 'S' then
    Result := 'Syringe'
  else
    Result := StringIn;
end;

function GetOrderStatus(StringIn: string): string;
begin
  if StringIn = 'A' then
    Result := 'Active'
  else if
    StringIn = 'D' then
    Result := 'Discontinued'
  else if
    StringIn = 'E' then
    Result := 'Expired'
  else if
    StringIn = 'H' then
    Result := 'Hold'
  else if
    StringIn = 'R' then
    Result := 'Renewed'
  else if
    StringIn = 'RE' then
    Result := 'Reinstated'
  else if
    StringIn = 'DE' then
    Result := 'Discontinued (Edit)'
  else if
    StringIn = 'DR' then
    Result := 'Discontinued (Renewal)'
  else if
    StringIn = 'P' then
    Result := 'Purge'
  else if
    StringIn = 'O' then
    Result := 'On Call'
  else if
    StringIn = 'N' then
    Result := 'Non Verified'
  else if
    StringIn = 'I' then
    Result := 'Incomplete'
  else if
    Stringin = 'U' then
    Result := 'Unreleased'
  else
    Result := StringIn;
end;

function getScanStatusID(StringIn: string): TScanStatus;
var
  id: TScanStatus;
begin
  Result := ssUnknown;                  // rpk 4/6/2009

  for id := low(ScanStatusCodes) to high(ScanStatusCodes) do
    if ScanStatusCodes[id] = StringIn then begin
      result := id;
      break;
    end;
end;

//NOTE: PSB DEVICE returns results in this format:
// 198;INTERMEC2$PRT^INTERMEC2$PRT^Plano^80^66
// IEN and device name are the first piece with a ; separator

function SubsetOfDevices(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of devices (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  Result := nil;                        // rpk 4/23/2009
  with BCMA_Broker do
    if CallServer('PSB DEVICE', [StartFrom, IntToStr(Direction)], nil) then
      Result := BCMA_Broker.Results;
  if Result <> nil then begin           // rpk 4/23/2009
    Result.Delete(0);
    if piece(result[0], '^', 1) = '-1' then
      result.Delete(0);
  end;
end;

procedure CheckMOBDLL;
const
  RegError = 'BCMA was unable to locate registry information for the file '
    +                                   // P77
    '%s.  This may mean either the file was never installed or registered on ' +
    'the client, or the logged on user does not have access to the registry.';

  FileError = 'BCMA requires version %s of the %s.' + #13 +
    'BCMA found that ' +                // P77
    'the version currently installed is %s %s' + #13 + '%s' + #13#13 +
    'Please install the proper version of this DLL.';
  RegFileMsg =
    'and the registry entry for this DLL contains the following path: '; // P77
  FilePathMsg = 'and the DLL was found at the following path: '; // P77
  LastKnownVer = '1.1.0.7';             //Last known DLL version to act as a fail safe if paramater is not found

  procedure DisplayError(InMsg: string); // P77
  var
//    Msg, HelpContact, FileName: string;
    Msg, HelpContact: string;
  begin
    HelpContact :=
      'Please contact your IRM staff to have this problem corrected.';

    if BCMA_Broker.CallServer('PSB PARAMETER', ['GETPAR', 'ALL',
      'PSB HELP DESK TEXT'], nil) then
    begin
      if trim(Piece(BCMA_Broker.Results[0], U, 1)) <> '' then
        HelpContact := Piece(BCMA_Broker.Results[0], U, 1);
    end;

    Msg := 'A problem with the ' + MOBINFO.MOBDLLName + ' file was detected. '
      + HelpContact + #13#13 +
      'The "CPRS Med Order" button on the VDL will be disabled until this problem is resolved.' +
      #13#13 + 'Error Information:' + #13 + InMsg;

    DefMessageDlg(Msg, mtError, [mbOK], 0);
    BCMA_SiteParameters.MedOrderButton := False;
  end;                                  // DisplayError

var
//  Msg: string;
  MOB2Req: Boolean;
begin
  //If no med order then exit
  if BCMA_SiteParameters.MedOrderButton = False then
    exit;

  //Get the DLL required version from the server
  if BCMA_Broker.CallServer('PSB PARAMETER', ['GETPAR', 'ALL',
    'PSB MOB DLL REQUIRED VERSION'], nil) then // P77
  begin
//    if Trim(MOBINFO.MOBRequiredVersion) <> '' then
    if Trim(BCMA_Broker.Results[0]) <> '' then // rpk 3/30/2016
      MOBINFO.MOBRequiredVersion := Piece(BCMA_Broker.Results[0], '^', 1)
    else
      MOBINFO.MOBRequiredVersion := LastKnownVer;
  end;

  //Find out which server version is required
  MOB2Req := not (Copy(MOBINFO.MOBRequiredVersion, 1, 1) = '1');
    //Collect the data about the desired DLL
  if MOB2Req then
    LoadMOBInfo(MOB2DLLName)
  else
    LoadMOBInfo(MOBDLLName);

  //Preset error messages if needed
  if MOBINFO.MOBVersion = '' then
    MOBINFO.MOBVersion := '(file missing, or insufficient security)';

  case MOBINFO.MobType of               // P77
    REGERR: begin
      // issue with registry, if on 2.0 and above then we are missing the file anyways
        if MOB2Req then
          DisplayError(Format(FileError, [MOBINFO.MOBRequiredVersion,
            MOBINFO.MOBDLLName, MOBINFO.MOBVersion, FilePathMsg, MOBINFO.MobPath]))
        else
          DisplayError(Format(RegError, [MOBINFO.MOBDllName]));
      end;
    FILENA:
      begin
        if MOb2Req then
          DisplayError(Format(FileError, [MOBINFO.MOBRequiredVersion,
            MOBINFO.MOBDLLName, MOBINFO.MOBVersion, FilePathMsg, MOBINFO.MobPath]))
        else
          DisplayError(Format(FileError, [MOBINFO.MOBRequiredVersion,
            MOBINFO.MOBDLLName, MOBINFO.MOBVersion, RegFileMsg,
              MOBINFO.MobPath]));
      end;
  else begin
      if MOBINFO.MOBVersion <> MOBINFO.MOBRequiredVersion then
      begin
        if MOb2Req then
          DisplayError(Format(FileError, [MOBINFO.MOBRequiredVersion,
            MOBINFO.MOBDLLName, MOBINFO.MOBVersion, FilePathMsg, MOBINFO.MobPath]))
        else
          DisplayError(Format(FileError, [MOBINFO.MOBRequiredVersion,
            MOBINFO.MOBDLLName, MOBINFO.MOBVersion, RegFileMsg,
              MOBINFO.MobPath]));
      end;
    end;
  end;

end;                                    // CheckMOBDLL

{ procedure InitPainScore(PainScoreList: TStrings);
var
  x: Integer;
begin
  with PainScoreList do begin
    AddObject('0 - No Pain', ptr(0));
    AddObject('1 - Slightly Uncomfortable', ptr(1));
    for x := 2 to 9 do
      AddObject(IntToStr(x), ptr(x));
    AddObject('10 - Worst Imaginable', ptr(10));
    //
    // future enhancement: '88 - Unable to Evaluate'
    //
    //    AddObject('88 - Unable to Evaluate', ptr(88));
    AddObject('99 - Unable to Respond', ptr(99));
  end;
end; }

function SendVitals(Value: string; MDateTime: string = ''): Boolean;
begin
  if Value = '' then begin              // rpk 6/7/2012
    Result := True;
    WriteLogMessageProc('SendVitals: empty input Value', nil);
  end
  else begin
    result := false;
    if (BCMA_Broker <> nil) and
      (BCMA_Patient.MedOrders <> nil) then
      with BCMA_Broker do
        if CallServer('PSB VITAL MEAS FILE', [BCMA_Patient.IEN,
          Value, 'PN', MDateTime], nil) then
          if Results.Count - 1 <> StrToInt(Results[0]) then begin
            DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
          end
          else if (results.Count > 1) and
            (piece(Results[1], '^', 1) = '-1') then begin
            DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0);
          end
          else
            Result := True;
  end;

end;                                    // SendVitals

function CloseForms(CloseForm: Boolean): Boolean;
{This procedure will close a certain number of Modal forms that we allow to be
closed.  Not all forms can be closed forcibly if a transaction is in progress,
as we can't guess as to the current state of the transaction.  This procedure will
be used by CCOW and possibly the automatic timeout feature, any forms left open,
including the main form, will be handled outside of this procedure

However, the forms will only be closed if 'CloseForm' = true.  The procedure doubles
as utility to simply return back whether or not any other modal forms would be
left open.  If some other Modal form would be left open, Result := true
}
var
  x, i: integer;
  CantClose: Boolean;
begin
  Result := False;
  CantClose := True;
  i := 0;
  repeat
    if fsModal in Screen.Forms[i].FormState then begin
      for x := 0 to Length(CloseableForms) - 1 do
        if Screen.Forms[i].Name = CloseableForms[x] then begin
          CantClose := false;
          if CloseForm then
            Screen.Forms[i].ModalResult := mrCancel;
        end;

      for x := 0 to Length(CloseableFormsByCaption) - 1 do
        if Screen.Forms[i].Caption = CloseableFormsByCaption[x] then begin
          CantClose := false;
          if CloseForm then
            Screen.Forms[i].ModalResult := mrCancel;
        end;

      if CantClose = True then begin
        Result := True;
        Break;
      end;
    end;
    Inc(i);
  until (i = Screen.FormCount);
end;

function SameDateTime(const DT1, DT2: TDateTime): Boolean;
const
  OneDTMillisecond = 1 / (24 * 60 * 60 * 1000);
begin
  Result := abs(DT1 - DT2) < OneDTMillisecond;
end;

function TimeApartInMins(const DT1, DT2: TDateTime): Extended;
begin
  if SameDateTime(DT1, DT2) then
    Result := 0
  else
    Result := (DT2 - DT1) * 24 * 60;
end;

function CheckForUnknowns(aMedOrder: TBCMA_MedOrder): Boolean;
//result = if the user selected cancel
var
  msg: string;
begin
  Result := false;
  if (BCMA_Broker <> nil) and (aMedOrder <> nil) then
    with BCMA_Broker do
      if CallServer('PSB UTL XSTATUS SRCH', [BCMA_Patient.IEN + '^' +
        aMedOrder.OrderNumber + '^^FREQ'], nil) then
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0],
          -1)) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if (results.Count > 0) and (piece(Results[1], '^', 1) = '-1') then
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
        else if (results.Count > 0) and (piece(Results[1], '^', 1) = '0') then
          exit
        else
          with aMedOrder do begin
            msg := 'This order contains an administration with an UNKNOWN status as described below:'
              + #13#13;
            msg := msg + 'Patient Name: ' + BCMA_Patient.Name + #13;
            msg := msg + 'Location: ' + piece(Results[1], '^', 1) + #13;
            msg := msg + 'Medication: ' + piece(Results[2], '^', 1) + #13;
            msg := msg + 'Order Number: ' + piece(Results[2], '^', 2) + #13;
            msg := msg + 'Unknown entry created at: ' +
              DisplayVADateYearTime(piece(Results[3], '^', 1)) + #13;

            if piece(Results[4], '^', 1) <> '' then
              msg := msg + 'Scheduled Admin Time: ' +
                DisplayVADateYearTime(piece(Results[4], '^', 1)) + #13;

            msg := msg + #13 +
              'Contact your BCMA Coordinator if you do not know your site''s policy regarding administrations with an UNKNOWN status.' +
              #13#13;

            if aMedOrder.ScanStatus = 'U' then begin
              msg := msg + #13 +
                'Administrations with an UNKNOWN status need to be edited via Edit Med Log. ' +
                #13;
              msg := msg + 'This action will be cancelled' + #13;

              DefMessageDlg(msg, mtInformation, [mbOK], 0);
              Result := True;
            end
            else begin
              msg := msg +
                'Click OK to continue with the administration or Cancel to exit the administration without saving any data.';
              Result := (DefMessageDlg(msg, mtInformation, [mbOK, mbCancel], 0)
                = idCancel);
            end;
            aMedOrder.UnknownMessageDisplayed := True;
          end;
end;


///
/// NOTE: Add Clinic to MultList
///

function LogUnableToScan(OrderNum,
  Reason,
  Comment,
  UnableToScanString,
  ScanType: string;
  Method: Integer = 0): Boolean;
var
  MultList: TStringList;
  tmpcomment: string;
  ilen: Integer;
begin
  Result := True;
  //msf disable - next two lines added
{$IFNDEF MSF_ON}
  exit;
{$ENDIF}

  // if UTS Medication and Clinic Order Mode, skip RPC call
  // if UTS Wristband, allow RPC call even for Clinic Order Mode;  RPC will
  // identify whether patient is admitted and do UTS email / reporting when
  // patient is admitted.
  if (ScanType = 'M') and (OrderMode = omClinic) then // rpk 5/1/2013
    Exit;

  Result := False;                      // rpk 8/20/2012

  frmMain.StatusBar.Panels[0].Text := 'Logging Input Method...';
  frmMain.StatusBar.Repaint;

  ilen := Length(Comment);              // rpk 8/20/2012
  if ilen > 250 then begin              // rpk 8/20/2012
    DefMessageDlg('LogUnableToScan: The "Comment" is longer than 250 characters. '
      +
      'Truncating Comment to 250 characters', mtInformation, [mbOK], 0);
    WriteLogMessageProc('Function LogUnableToScan Error in BCMA_Common.' +
      ' The "Comment": "' + Comment + '" is longer than 250 characters. ' +
      'Truncating Comment to 250 characters', nil);
    ilen := 250;
  end;

  tmpcomment := Copy(Comment, 0, ilen); // rpk 8/20/2012

  MultList := TStringList.Create;
  try                                   // rpk 2/23/2012
    MultList.Add(BCMA_Patient.IEN + '^' + OrderNum +
      '^' + Reason + '^' + tmpComment + '^' + ScanType + '^' +
      IntToStr(Method));
    if UnableToScanString <> '' then
      MultList.Add(UnableToScanString);
    if (BCMA_Broker <> nil) then
      with BCMA_Broker do
        if CallServer('PSB MAN SCAN FAILURE', ['~!#null#~!'], MultList) then
          if (Results.Count = 0) or (Results.Count - 1 <>
            StrToIntDef(Results[0],
            -1)) then
            if OrderNum <> '' then {JK 6/30/2008 - suppress msg because there is
              no patient ID and will naturally return an error
              for logging against a patient but the logging
              for the summary report works correctly.}
              DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
            else if piece(Results[1], '^', 1) = '-1' then begin
              DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0);
              exit;
            end
            else if piece(Results[1], '^', 1) = '1' then
              Result := True;
    frmMain.StatusBar.Panels[0].Text := '';
    frmMain.StatusBar.Repaint;
  finally
    MultList.Free;
  end;
end;

procedure StartKeyboardTimer;
begin
  if KeyBoardTimer <> nil then
    exit;
  KeyboardTimerHandler := TBCMA_TimerHandler.Create;
  KeyboardTimer := TTimer.Create(nil);
  with KeyboardTimer do begin
    Interval := KeyBoardTimerInterval;
    OnTimer := KeyboardTimerHandler.TimerEvent;
    Enabled := True;
  end;
end;

procedure StopKeyboardTimer;
begin
  if Keyboardtimer <> nil then begin
    KeyboardTimer.Enabled := False;
    KeyboardTimer.Free;
    KeyboardTimer := nil;
    KeyboardTimerhandler.free;
  end;
end;

function IsRestricted: Boolean;
begin
  {BCMA_User.IsReadOnly depicts whether or not a user is holding the
  PSB Readonly Key. This key in turn set the global ReadOnly variable.
  This same variable is temporarily toggled to true when the user selects
  the ReadOnly option via the menu. The ReadOnly variable is used
  to disable the Specific Readonly functionality.
  A new Limited Access option will use the ReadOnly functionality with the
  with the expection of specific functions that should be accessible.
  This function will be called to make heads or tales of whether the user should
  have access to whatever is calling this function. The LimitedAccess variable
  WILL ONLY be set to true when the user selects the LimitedAcess menu option.
  This menu option is grayed out when the user has the ReadOnly Key.
  }
  Result := False;

  //User should be able to access the functionality calling this
  //ReadOnly was set to true by the Limited Access Menu since the only
  if ReadOnly and LimitedAccess then
    Result := False

    //The user is a genuine ReadOnly user
  else if ReadOnly then
    Result := True;
end;

procedure PrintReport;
//var
//  zPrinter: String;
//  z: integer;
//   Result: Integer;
//  idx: Integer;
//  savdelim: Char;
begin
//NOTE: PSB DEVICE returns results in this format:
// 198;INTERMEC2$PRT^INTERMEC2$PRT^Plano^80^66
// IEN and device name are the first piece with a ; separator

//  idx := -1;

  with TfrmPrint.create(application) do try
    with cbxDeviceList do begin
      if BCMA_UserParameters.DefaultPrinterName <> '' then begin
        InitLongList(BCMA_UserParameters.DefaultPrinterName);
        //SelectByID(BCMA_UserParameters.DefaultPrinterIEN + ';' + BCMA_UserParameters.DefaultPrinterName);
        if BCMA_UserParameters.DefaultPrinterIEN <> 0 then begin
          SelectByID(IntToStr(BCMA_UserParameters.DefaultPrinterIEN) + ';' +
            BCMA_UserParameters.DefaultPrinterName); // rpk 10/20/2010
//        These other variants do not work due to the mixed-mode delimiters
//        SelectByIEN fails with ^ delimiter with no match on number.  If ; is used,
//        it returns the full result string following the ; not just the printer name.
//
//          if idx < 0 then begin
//            savdelim := Delimiter;
//            Delimiter := ';';
//            idx := SelectByIEN(BCMA_UserParameters.DefaultPrinterIEN);
//            if idx < 0 then
//              idx := SetExactByIEN(BCMA_UserParameters.DefaultPrinterIEN,
//                  BCMA_UserParameters.DefaultPrinterName);
//            Delimiter := savdelim;
//          end;
        end;
      end                               // defaultprintername not blank
      else
        InitLongList('');
      showModal;
//      Result := showModal;  // rpk 9/7/2010

    end
  finally
    Release;                            // rpk 6/18/2013
  end;

  {
  if BCMA_UserParameters.DefaultPrinterIEN = '' then
    zPrinter := SelectFromList('Printer',
    BCMA_SiteParameters.ListDevices)
  else
    zPrinter := SelectFromList('Printer',
    BCMA_SiteParameters.ListDevices, StrToInt(BCMA_UserParameters.DefaultPrinterIEN));

  if zPrinter <> '' then
    Begin
      with BCMA_UserParameters Do
        if BCMA_SiteParameters.ListDevices.Find(zprinter, z) then
          Begin
            DefaultPrinterName := zPrinter;
            DefaultPrinterIEN := IntToStr(Integer(BCMA_SiteParameters.ListDevices.objects[z]));
          end;
      With BCMA_Report Do
        Execute(zPrinter);
    end;
  }
end;

function LogComments(MedLogIEN: string; CommentsIn: TStringList): Boolean;
var
  ii, jj: integer;
  cmdString,
    ResultErrTxt: string;
  MultList: TStringList;
begin
  Result := False;

  if CommentsIn = nil then              // rpk 1/6/2012
    Exit;

  if (MedLogIEN <> '') and (CommentsIn.Count <> 0) then begin
    MultList := TStringList.Create;
    cmdString := MedLogIEN + '^ADD COMMENT';
    for jj := 0 to CommentsIn.Count - 1 do begin
      MultList.Add(CommentsIn[jj]);
      with BCMA_Broker do
        if CallServer('PSB TRANSACTION', [cmdString + '^' +
          BCMA_User.InstructorDUZ], MultList) then
          if piece(results[0], '^', 1) <> '1' then begin
            ResultErrTxt := piece(results[0], '^', 2) + #13;
            for ii := 1 to Results.Count - 1 do
              ResultErrTxt := ResultErrTxt + Results[ii] + #13;
            DefMessageDlg(ResultErrTxt, mtError, [mbOK], 0);
            Result := False;
            Break;
          end
          else begin
            Result := True;
            MultList.Clear;
          end;
    end;
    CommentsIn.Clear;
    MultList.Free;
  end;
end;

function DaysHoursMinutesPast(FMDateTimeIn: string): string;
var
  ActionDateTime: TDateTime;
  SinceMinutes, zDays, zHours, zMinutes: Extended;
begin
  if FMDateTimeIn = '' then
    exit;
  ActionDateTime := FMDateTimeToDateTime(StrToFloat(FMDateTimeIn));
  SinceMinutes := TimeApartInMins(ActionDateTime, Now +
    BCMA_SiteParameters.ServerClockVariance);

  zDays := int(SinceMinutes / 1440);
  SinceMinutes := SinceMinutes - zDays * 1440;

  if (SinceMinutes >= 60) then
    zHours := int(SinceMinutes / 60)
  else
    zHours := 0;

  if SinceMinutes > 60 then
    zMinutes := Round(60 * frac(SinceMinutes / 60))
  else
    zMinutes := Round(SinceMinutes);

  Result := FloatToStr(zDays) + 'd ' + FloatToStr(zHours) + 'h ' +
    FloatToStr(zMinutes) + 'm';
end;

function BuildCommentLine(SystemComment, UserComment: string): string;
var
  S, U: string;
begin
  S := Trim(SystemComment);
  U := Trim(UserComment);

  if (Length(S) <> 0) and (U <> '') then
    S := S + MSF_Report_CR + U
  else if (Length(S) = 0) and (U <> '') then
    S := U
  else if (Length(S) = 0) and (U = '') then
    S := '';

  Result := S;
end;

function isInjectionSite(inSite: string): Boolean;
begin
  Result := False;                      // rpk 6/27/2016
  if inSite > '' then
    Result := Piece(inSite, sitedelim, injpos) = '1';
end;

function isDermalSite(inSite: string): Boolean;
begin
  Result := False;                      // rpk 6/27/2016
  if inSite > '' then
    Result := Piece(inSite, sitedelim, dermpos) = '1';
end;

function GetSite(inSite: string): string;
begin
  Result := '';                         // rpk 6/27/2016
  if inSite > '' then
    Result := Piece(inSite, sitedelim, 1);
end;

// insingle: transfer only first piece of inList to outList

function PopulateSiteList(inList, outList: TStrings; inType: TSiteType;
  inSingle: Boolean): Integer;
var
  i, j: Integer;
  s: string;
begin
  j := 0;
  if assigned(inList) and assigned(outList) then begin
    outList.Clear;
    case inType of
      stInjection: begin
          for I := 0 to inList.Count - 1 do begin
            if isInjectionSite(inList[i]) then begin
              if inSingle then
                s := GetSite(inList[i])
              else
                s := inList[i];
              outList.Add(s);
              inc(j);
            end;
          end;
        end;                            // stInjection
      stDermal: begin
          for I := 0 to inList.Count - 1 do begin
            if isDermalSite(inList[i]) then begin
              if inSingle then
                s := GetSite(inList[i])
              else
                s := inList[i];
              outList.Add(s);
              inc(j);
            end;
          end;
        end;                            // stDermal
    end;                                // case
  end;                                  // if assigned
  Result := j;
end;                                    // PopulateSiteList

function SelectAnatomicalLocation(aDivision, aGroupName: string; inSite:
  TSiteType): string;
const
  pnBodySites = 'PSB LIST BODY SITES';  // duplicate from uCAS_ALUtils
var
  icnt: Integer;
  selectionList: TStringList;
//  tbool: Boolean;
//  savDivision: String;
begin
  Result := '';
  selectionList := TStringList.Create;
  try
    if not Assigned(frmALMapEdit) then begin
      frmALMapEdit := newLocationMap(mmSelect, aDivision);
      if frmALMapEdit = nil then
        exit;
//      tbool := frmALMapEdit.acLoadImageFromVistA.Execute; // rpk 4/25/2016
    end;
    { else begin
      // should never get here; division is set when user logs in to broker
      if frmALMapEdit.Division <> aDivision then begin // rpk 4/25/2016
        frmALMapEdit.Division := aDivision;
//        tbool := frmALMapEdit.acLoadImageFromVistA.Execute; // rpk 4/25/2016
      end;
    end; }

    { case inSite of
      stInjection: frmALMapEdit.ViewMode := mmSelectInjection;
      stDermal: frmALMapEdit.ViewMode := mmSelectDermal;
    end; }
    if aGroupName = '' then
      aGroupName := pnBodySites;
    if BCMA_Broker.CallServer('PSB PARAMETER',
      ['GETLST', aDivision, aGroupName], nil) then begin

      selectionList.Assign(BCMA_Broker.Results);
      if selectionList.Count > 0 then
        selectionList.Delete(0);

      icnt := PopulateSiteList(selectionList, frmALMapEdit.Backup, inSite,
        False);
    end;
  finally
    selectionList.Free;
  end;

  frmALMapEdit.setByList(frmALMapEdit.Backup);
  // move ViewMode set after set up of list, list has to have at least one entry
  // before setting ViewMode.
  case inSite of
    stInjection: begin
        frmALMapEdit.ViewMode := mmSelectInjection;
        case lstCurrentTab of
        // Specify_the_Injection_Site_for_the_Unit_Dose_Medication
          ctUD: frmALMapEdit.HelpContext := 129;
        // Specify_the_IVP_IVPB_Injection_Site
          ctPB: frmALMapEdit.HelpContext := 151;
        else
          frmALMapEdit.HelpContext := 129;
        end;
      end;
    stDermal: begin
        frmALMapEdit.ViewMode := mmSelectDermal;
      // Specify_the_Dermal_Site_for_the_Unit_Dose_Medication
        frmALMapEdit.HelpContext := 145; // rpk 9/30/2016
      end;
  end;

  if frmALMapEdit.ShowModal = mrOK then
    Result := frmALMapEdit.lvWork.Selected.Caption;

  // Can't allow frmALMapEdit to persist. It is released in fSelectInjection
  FreeAndNil(frmALMapEdit);             // rpk 9/30/2016
end;                                    // SelectAnatomicalLocation

(* function LoadMOBInfo(const DllName: String): Boolean; // P77
{
 Used to determine what code is used when dealing with the OrderCom dll

 Function result = DLL exist and is registry error free


 VERSION | DLL     | MOB2 Value
 ______________________________
 1.1.0.7   Old DLL   False
 2.0.0.0   New DLL   True

}
var
  Registry: TRegistry;
  VersionInfo: TVersionInfo;
  clsid: string;
begin
  Result := False;
  //set the DLL Name
  MOBINFO.MOBDllName := DllName;
//  MOBINFO.MobPath := GetProgramFilesPath + SHARE_DIR;
  if MOBINFO.MOBRequiredVersion > '' then
  begin
    If (Copy(MOBINFO.MOBRequiredVersion, 1, 1) = '2') then
    begin
      // Check for hard path first
      MOBINFO.MobPath := GetProgramFilesPath + SHARE_DIR;
    end
    else
      If (Copy(MOBINFO.MOBRequiredVersion, 1, 1) = '1') then
      begin
      //Look to the registry
        Registry := TRegistry.Create(KEY_READ);
        try
        //find the DLL
          with Registry do begin
            RootKey := HKEY_CLASSES_ROOT;
            if OpenKeyReadOnly('BcmaOrderCom.BcmaOrder' + '\CLSID') then
              clsid := ReadString('')
            else begin
              MOBINFO.MobType := REGERR;
              exit;
            end;
            CloseKey;

            if OpenkeyReadOnly('\CLSID\' + clsid + '\InProcServer32') then
              MOBINFO.MobPath := ExtractFilePath(Registry.ReadString(''))
            else begin
              MOBINFO.MobType := REGERR;
              exit;
            end;
            CloseKey;
          end;
        finally
          Registry.Free;
        end;
      end;                              // If (Copy(MOBINFO.MOBRequiredVersion, 1, 1) = '1')
  end                                   // if MOBINFO.MOBRequiredVersion > ''
  else
    MOBINFO.MobPath := GetProgramFilesPath + SHARE_DIR;

  //If no file then set warning and exit
  If not FileExists(MOBINFO.MobPath + MOBINFO.MOBDllName) then
  begin
    MOBINFO.MobType := FILENA;
    Exit;
  end;

  //Collect the version info from the DLL
  //  with TVersionInfo.Create(application) do try
  VersionInfo := TVersionInfo.Create(application);
  try
    with VersionInfo do begin
      FileName := MOBINFO.MobPath + MOBINFO.MOBDllName;
      MOBINFO.MobVersion := FileVersion;
    end;
  finally
    VersionInfo.free;
  end;

 //Now strip the info and set the MOB
  if StrToIntDef(Copy(MOBINFO.MobVersion, 1, 1), 0) >= 2 then
    MOBINFO.MobType := MOB2
  else
    MOBINFO.MobType := MOB1;

  Result := True;

                                  end; *)// LoadMOBInfo

procedure LoadMOBInfo(const DllName: string);
{
 Used to determine what code is used when dealing with the OrderCom dll

 Function result = DLL exist and is registry error free


 VERSION | DLL     | MOB2 Value
 ______________________________
 1.1.0.7   Old DLL   False
 2.0.0.0   New DLL   True

}
var
  Registry: TRegistry;
  clsid: string;
begin
  //set the DLL Name
  MOBINFO.MOBDllName := DllName;
  if not (Copy(MOBINFO.MOBRequiredVersion, 1, 1) = '1') then
  begin
    // Check for hard path first
    MOBINFO.MobPath := GetProgramFilesPath + SHARE_DIR;
  end else begin
    //Look to the registry
    Registry := TRegistry.Create(KEY_READ);
    try
      //find the DLL
      with Registry do begin
        RootKey := HKEY_CLASSES_ROOT;
        if OpenKeyReadOnly('BcmaOrderCom.BcmaOrder' + '\CLSID') then
          clsid := ReadString('')
        else begin
          MOBINFO.MobType := REGERR;
          exit;
        end;
        CloseKey;

        if OpenkeyReadOnly('\CLSID\' + clsid + '\InProcServer32') then
          MOBINFO.MobPath := ExtractFilePath(Registry.ReadString(''))
        else begin
          MOBINFO.MobType := REGERR;
          exit;
        end;
        CloseKey;
      end;
    finally
      Registry.Free;
    end;
  end;


  //If no file then set warning and exit
  if not FileExists(MOBINFO.MobPath + MOBINFO.MOBDllName) then
  begin
    MOBINFO.MobType := FILENA;
    Exit;
  end;

  //Collect the version info from the DLL
  with TVersionInfo.Create(application) do try
    FileName := MOBINFO.MobPath + MOBINFO.MOBDllName;
    MOBINFO.MobVersion := FileVersion;
  finally
    free;
  end;

  //Now strip the info and set the MOB
  if StrToIntDef(Copy(MOBINFO.MobVersion, 1, 1), 0) >= 2 then
    MOBINFO.MobType := MOB2
  else
    MOBINFO.MobType := MOB1;

end;                                    // LoadMOBInfo

end.

