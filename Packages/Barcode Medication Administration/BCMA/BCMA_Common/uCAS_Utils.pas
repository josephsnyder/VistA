unit uCAS_Utils;

interface
uses
  Forms
  , Classes
  , Controls
  , DBClient
  , DBCtrls
  , DB
  , DBGrids
  , Dialogs
//  , oCoverSheet
  , BCMA_Objects
  ;

const
  CRLF = #13#10;

  fwDateTime = 12;

  gMDK_DateFMT = 'mm/dd/yyyy';
  gMDK_TimeFMT = 'hh:nn:ss';
  gMDK_DateTimeFMT = 'mm/dd/yyyy hh:nn:ss';
  gMDK_DebugTimeFMT = 'hh:MM:ss.zzz';

  al: TAlignment = taLeftJustify;

  CRREMOVAL_IDX = 3;
  CRREMOVAL_DONE = 0;
  CRREMOVAL_REFUSED = 2;
  CRREMOVAL_GIVEN = 6;                  // was 1;
  CRREMOVAL_UNKNOWN = 4;

  CSRequiresRemoval = 'Requires Removal';
  CSRequiresRemovalRefused = 'Requires Removal:REFUSED';
  CSRequiresRemovalDone = 'Requires Removal:REMOVED';
  CSRequiresRemovalGiven = 'Requires Removal:GIVEN';

  DEFAULT_ACTION = 'DUE';               // default action name
  LATE_ACTION = 'LATE';
  LATE_RM_ACTION = 'LATE-RM';
  REMOVE_ACTION = 'REMOVE';
  SEE_ORDER = 'SEE ORDER';
  CAS_naDelim = ' ';                    //#13#10; // delimiter of the Action and DateTime in "Next Action" column
  MINUTES_DAY = 1440;
                     // "-" in v.3.0.83.18
                     // " " in v.3.0.83.19



function CalendarDateToMDate(sDate: string): string;
function DateTimeLate(MO: TBCMA_MedOrder): Extended;
//procedure DumpProps(anObject:TObject;aList: TStringList);
procedure FormatGrid(aDBG: TDBGrid; ScrollUp: Boolean = True);
function getOrderAlertText(anOrder: TBCMA_MedOrder; aMode: Boolean): string;

//function getOrderNextAction(anOrder:TBCMA_MedOrder;aMode:Boolean):String;
//function getOrderNextAction(anOrder: TBCMA_MedOrder; aMode: Boolean; var NextAction: String; var NextDT: String): String; // rpk 8/4/2015
function getOrderNextAction(anOrder: TBCMA_MedOrder; aMode: Boolean; var NextAction: string;
  var NextDT: string; var isLate: Boolean): string; // rpk 8/4/2015
//function getOrderNextAction(anOrder: TBCMA_MedOrder; aMode: Boolean; var NextAction: String;
//  var NextDT: String): String;                             // rpk 8/4/2015

//function getRRStatus(aMO:TCoverSheet_Order): Integer;   // v.3.0.83.18 commented out aan 20150629
//function getRemovableStatusHint(aStatus: Integer): String; overload;
//function getRemovableStatusHint(aStatus: String): String; overload;
function getRemovableOrderHint(aMO: TBCMA_MedOrder): string;
function getVDLColumnTitle(aColumn: Integer): string;
// check for late orders that are not yet completed
//function isLateOrder(anOrder: TBCMA_MedOrder): Boolean;
function IsRemovalRequiredByRoute(aRoute: string): Boolean;
function IsRemovalRequiredByStatus(aStatus: string): Boolean;
function IsRemovalRequiredByOrder(aMO: TBCMA_MedOrder): Boolean;
function NewStringField(aCDS: TClientDataSet; aFieldName, aLabel: string;
  aWidth: Integer; aSize: Integer): TStringField;
function NewDateTimeField(aCDS: TClientDataSet; aFieldName, aLabel: string;
  aWidth: Integer = fwDateTime;
  aDisplayFMT: string = gMDK_DateFMT): TDateTimeField;
//function NextActionTextByStatus(anOrder: TBCMA_MedOrder): String;
function NextActionTextByStatus(anOrder: TBCMA_MedOrder; var isLate: Boolean): string;
//function Piece(const S: string; Delim: char; PieceNum: Integer): string;
//function RemovalConfirmed(anOrder:TBCMA_MedOrder;aSite: TBCMA_SiteParameters): Boolean;

//function RemovalImageIndexByStatus(aStatus: String): Integer;
//function RemovalActionTextByImageIndex(anIndex: Integer): String;
//function RemovalNextActionTextByImageIndex(anIndex: Integer): String;
//function RemovalNextActionTextByStatus(aStatus: String): String;
//function RemovalNextActionTextByStatus(anOrder: TBCMA_MedOrder): String;

procedure setFormParented(aForm: TForm; aParent: TWinControl; anAlign: TAlign = alClient);

var
  slVDLTitles: TStringList;

implementation
uses
  SysUtils, VAUtils, BCMA_Common, BCMA_Util, DateUtils, BCMA_Startup;

// copied of BCMA_Util.pas from BCMAPar project (missing in BCMA application)

(* function Piece(const S: string; Delim: char; PieceNum: Integer): string;
{ returns the Nth piece (PieceNum) of a string delimited by Delim }
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(S);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then
    Next := StrEnd(Strt);
  if i < PieceNum then
    Result := ''
  else
    SetString(Result, Strt, Next - Strt);
end; *)

function CalendarDateToMDate(sDate: string): string;
var
  sDay, sMonth, sYear: string;
begin
  Result := '';
  if sDate = '' then
    Exit;

  sDay := piece(sDate, '/', 2);
  sMonth := piece(sDate, '/', 1);
  sYear := piece(sDate, '/', 3);

  while Length(sDay) < 2 do
    sDay := '0' + sDay;
  while Length(sMonth) < 2 do
    sMonth := '0' + sMonth;

  sYear := IntToStr(StrToInt(sYear) - 1700);
  Result := sYear + sMonth + sDay;
end;

//procedure setFormParented;

procedure setFormParented(aForm: TForm; aParent: TWinControl; anAlign: TAlign = alClient);
begin
  if aForm.Parent <> aParent then
  begin
    aForm.BorderStyle := bsNone;
    aForm.Parent := aParent;
    aForm.Align := anAlign;
    aForm.Menu := nil;
    aForm.Show;
  end;
end;

function NewStringField(aCDS: TClientDataSet; aFieldName, aLabel: string;
  aWidth: Integer; aSize: Integer): TStringField;
var
  fS: TStringField;
begin
  aCDS.Close;
  fS := TStringField.Create(aCDS);
  fS.FieldName := aFieldName;
  fS.Name := aCDS.Name + fS.FieldName;
  fS.Index := aCDS.FieldCount;
  fS.DataSet := aCDS;
  fs.Size := aSize;
  fs.DisplayLabel := aLabel;
  fs.DisplayWidth := aWidth;

  fs.Alignment := al;

  Result := fS;
end;

function NewDateTimeField(aCDS: TClientDataSet; aFieldName, aLabel: string;
  aWidth: Integer = fwDateTime;
  aDisplayFMT: string = gMDK_DateFMT): TDateTimeField;
var
  fDT: TDateTimeField;
begin
  aCDS.Close;
  fDT := TDateTimeField.Create(aCDS);
  fDT.FieldName := aFieldName;
  fDT.Name := aCDS.Name + fDT.FieldName;
  fDT.Index := aCDS.FieldCount;
  fDT.DataSet := aCDS;
  fDT.DisplayLabel := aLabel;
  fDT.DisplayWidth := aWidth;
  fDT.DisplayFormat := aDisplayFMT;

  fDT.Alignment := al;

  Result := fDT;
end;

function CdsReady(aCds: TclientDataSet): Boolean;
begin
  Result := assigned(aCds) and aCds.Active and (aCds.RecordCount > 0);
end;

procedure FormatGrid(aDBG: TDBGrid; ScrollUp: Boolean = True);
var
  ii,
    iLen: Integer;
  iCurr: Integer;
  i: integer;
  s: string;
  BM: TBookmark;
  cds: TClientDataSet;
  dbg_RightSpace: Integer;

begin
  dbg_RightSpace := 24;
  cds := TClientDataSet(aDBG.DataSource.DataSet);
  if not CdsReady(cds) then
    Exit;
  ii := 0;
  iLen := 16;
  try
    for i := 0 to adbg.Columns.Count - 1 do
    begin
      if not aDBG.Columns[i].Visible then
        continue;
      iCurr := adbg.Columns[i].Width;
//      iLen := adbg.Canvas.TextWidth(adbg.Columns[i].Title.Caption);
      if iCurr > iLen then
        adbg.Columns[i].Width := iLen;
    end;
  except
    on E: Exception do
      ShowMessage('DBG: SetHeader' + #13#10 + E.Message);
  end;

  BM := cds.GetBookmark;
  cds.DisableControls;
  if ScrollUp then
    cds.First;
  while not cds.EOF do
  begin
    inc(ii);
    try
      for i := 0 to adbg.Columns.Count - 1 do
      begin
        if not aDBG.Columns[i].Visible then
          continue;
        iCurr := adbg.Columns[i].Width;
        try
          s := cds.FieldByName(adbg.Columns[i].FieldName).AsString;
        except
          s := '';
        end;
        if trim(s) = '' then
          continue;
        iLen := adbg.Canvas.TextWidth(s);
        if iCurr < iLen + dbg_RightSpace then
          adbg.Columns[i].Width := iLen + dbg_RightSpace;
      end;
    except
      on E: Exception do
        ShowMessage('DBG: Width' + #13#10 +
          'Record #: ' + IntToStr(ii) + #13#10 +
          'Column #: ' + IntToStr(i) + #13#10 +
          'Field Name: "' + adbg.Columns[i].FieldName + '"' + #13#10 +
          'Field 0 Name: "' + adbg.Columns[0].FieldName + '"' + #13#10 +
          'Field 0 Value: "' + cds.FieldByName(adbg.Columns[0].FieldName).AsString + '"' + #13#10 +
          E.Message);
    end;
    cds.Next;
  end;
  cds.EnableControls;
  cds.GotoBookmark(BM);
  cds.FreeBookmark(BM);
end;

{ function getRRStatus(aMO: TCoverSheet_Order): Integer;
var
  i: Integer;
  s: String;
begin
  Result := CRREMOVAL_IDX;
  with aMO do
  begin
    if AdministrationsWithAction.Count < 1 then
      exit;
    for i := 0 to AdministrationsWithAction.Count - 1 do
    begin
      s := TCoverSheet_Admin(AdministrationsWithAction[i]).Action;
      if s = 'RM' then
        Result := CRREMOVAL_DONE
      else if s = 'R' then
        Result := CRREMOVAL_REFUSED
      else if s = 'G' then
        Result := CRREMOVAL_GIVEN;

      if Result <> CRREMOVAL_IDX then
        break;
    end;
  end;
end; }

{ function getRemovableStatusHint(aStatus: Integer): String;
begin
  Result := 'Unknown status';
  case aStatus of
    CRREMOVAL_IDX: Result := CSRequiresRemoval;
    CRREMOVAL_DONE: Result := CSRequiresRemovalDone;
    CRREMOVAL_GIVEN: Result := CSRequiresRemovalGiven;
    CRREMOVAL_REFUSED: Result := CSRequiresRemovalRefused;
  end;
end;

function getRemovableStatusHint(aStatus: String): String;
begin
  Result := CSRequiresRemoval;
  if aStatus = 'RM' then
    Result := CSRequiresRemovalDone
  else if aStatus = 'R' then
    Result := CSRequiresRemovalRefused
  else if aStatus = 'G' then
    Result := CSRequiresRemovalGiven;
end; }

function NextActionTextByStatus(anOrder: TBCMA_MedOrder; var isLate: Boolean): string;
var
  nextactiondtstr: string;
begin
  Result := ' ';
  if Assigned(anOrder) then begin
    with anOrder do begin
      if (ScheduleType = 'P') or
        (ScheduleType = 'OC') then      // PRN or OnCall
        Result := ' '                   // no action
      else begin
        // if order is on provider hold, do not show a dose as late
        if (OrderStatus = 'H') then
          isLate := False
        // administration is Held or Refused
        else if (Trim(ScanStatus) = 'H') or (Trim(ScanStatus) = 'R') then begin
          Result := ' ';                // action completed, no next action pending; rpk 12/2/2015
          isLate := False;
        end
        else if ((RemovalStatus <> '') and (RemovalStatus <> '0')) then begin // MRR only
          if IsRemovalRequiredByStatus(ScanStatus) then begin
            nextactiondtstr := TextNextActionTime; // rpk 9/21/2016
            if (nextactiondtstr = '') then begin // rpk 9/21/2016
              Result := SEE_ORDER;
              isLate := True;
            end
            else if isLate then
              Result := LATE_RM_ACTION
            else
              Result := REMOVE_ACTION
          end
          // MRR has been removed
          else if Trim(ScanStatus) = 'RM' then begin
            Result := ' ';              // action completed, no next action pending; rpk 8/31/2015
            isLate := False;
          end
          else begin                    // not given or removed
            if (ScheduleType = 'O') then begin // one-time will be highlighted in red; rpk 8/16/2016
              isLate := True;
              Result := DEFAULT_ACTION
            end
            else if isLate then
              Result := LATE_ACTION
            else
              Result := DEFAULT_ACTION
          end;
        end                             // MRR
        else begin                      // non-MRR
          // administration is given
          if trim(ScanStatus) = 'G' then begin // rpk 8/26/2015
            Result := ' ';              // action completed, no next action pending; rpk 8/26/2015
            isLate := False;            // rpk 8/28/2015
          end
          else if (ScheduleType = 'O') then begin // one-time will be highlighted in red;  rpk 8/16/2016
            isLate := True;
            Result := DEFAULT_ACTION;
          end
          else begin
            if isLate then
              Result := LATE_ACTION
            else
              Result := DEFAULT_ACTION; // should be clarified
          end;
          //// DEBUG ONLY
{$IFDEF CAS_DDPE_TEST}
//          if AdministrationUnit = 'PATCH' then
//            Result := Result + ' : non-MRR';
{$ENDIF}
        end;                            // non-MRR
      end;                              // else continuous or onetime schedule
    end;                                // with anOrder
  end;                                  // if Assigned(anOrder)
end;                                    // NextActionTextByStatus

function getRemovableOrderHint(aMO: TBCMA_MedOrder): string;
var
//  OutText: string;
  LateMinutes: TDateTime;
  isLate: Boolean;
//  nextactiondtstr: String;
  NextAction, NextDT: String;
begin
  Result := '?';
  if Assigned(aMO) then
    with aMO do begin
      LateMinutes := DateTimeLate(aMO);
      isLate := LateMinutes > 0.0;
//      OutText := NextActionTextByStatus(aMO, isLate);
//      Result := OutText + '  ' + aMO.TextNextActionTime; // rpk 8/31/2015
      { nextactiondtstr := TextNextActionTime; // rpk 9/21/2016
      if isMRR and
        ((ScheduleType <> 'P') and
        (ScheduleType <> 'OC')) and   // PRN or OnCall
        (nextactiondtstr = '') then   // rpk 9/21/2016
        nextactiondtstr := 'DETAILS FOR RM'; // rpk 9/23/2016
      Result := OutText + CAS_naDelim + nextactiondtstr; } // rpk 9/21/2016
      Result := getOrderNextAction(aMO, true, NextAction, NextDT, isLate); // rpk 9/23/2016
    end;
end;


function IsRemovalRequiredByRoute(aRoute: string): Boolean;
begin
  Result := pos('TRANSDERMAL', aRoute) > 0;
end;

function IsRemovalRequiredByStatus(aStatus: string): Boolean;
begin
  Result := aStatus = 'G';
end;


{ function RemovalImageIndexByStatus(aStatus: String): Integer;
begin
(*
  if pos('REMOVED',aStatus)>0 then
    Result := CRREMOVAL_DONE
  else if pos('GIVEN',aStatus)>0 then
    Result :=  CRREMOVAL_GIVEN
  else if pos('REFUSED',aStatus)>0 then
    Result :=  CRREMOVAL_REFUSED
  else
    Result := CRREMOVAL_IDX;
*)
// so far ALL items that require removal should be labeled with the same icon
  Result := CRREMOVAL_GIVEN;
end; }

{ function RemovalActionTextByImageIndex(anIndex: Integer): String;
begin
  case anIndex of
    CRREMOVAL_DONE: Result := 'REMOVED';
    CRREMOVAL_GIVEN: Result := 'GIVEN';
    CRREMOVAL_REFUSED: Result := 'REFUSED';
  else
    Result := 'DUE';
  end;
end; }

{ function RemovalNextActionTextByImageIndex(anIndex: Integer): String;
begin
  case anIndex of
    CRREMOVAL_DONE: Result := '';
    CRREMOVAL_GIVEN: Result := 'REMOVE';
    CRREMOVAL_REFUSED: Result := '';
  else
    Result := '';
  end;
end; }

function getVDLColumnTitle(aColumn: Integer): string;
begin
  if (aColumn < slVDLTitles.Count) and (aColumn >= 0) then
    Result := slVDLTitles[aColumn]
  else
    Result := '';
end;

procedure setup;
var
  i: integer;
begin
  slVDLTitles := TStringList.Create;
  for I := 0 to length(VDLColumnTitles) - 1 do
    slVDLTitles.Add(VDLColumnTitles[TVDLColumnTypes(i)]);

end;

function IsRemovalRequiredByOrder(aMO: TBCMA_MedOrder): Boolean;
begin
  with aMO do
    Result :=
      (
      IsRemovalRequiredByStatus(ScanStatus) and
      (RemovalStatus <> '') and (RemovalStatus <> '0')
      )
end;

{ function IsRemovalRequiredByCSOrder(aMO: TCoversheet_Order): Boolean;
begin
  with aMO do
    Result :=
      (
      IsRemovalRequiredByStatus(ScanStatus) and
      (RemovalStatus <> '') and (RemovalStatus <> '0')
      )
end; }

{ function RemovalConfirmed(anOrder:TBCMA_MedOrder;aSite: TBCMA_SiteParameters): Boolean;
begin
  Result := False;

end; }

// get late time for orders that are not yet completed

function DateTimeLate(MO: TBCMA_MedOrder): Extended;
//function DateTimeLate(MO: TBCMA_MedOrder): TDateTime;
var
  OrderDueTime: TDateTime;
//  OrderDueDate: TDate;
  SinceMinutes, TimeLimit, LateMinutes: Extended;
  fmAdminTime: TFMDateTime;
  tbool, iscomplete: Boolean;
  removalduestr, admindtstr: string;
begin
  iscomplete := False;
  Result := 0.0;
  LateMinutes := 0.0;
  OrderDueTime := 0.0;
  SinceMinutes := 0.0;
  if assigned(MO) then begin
    if Trim(MO.ClinicName) > '' then    // clinic is never late; rpk 2/16/2016
      exit;

    removalduestr := DateTimeToStr(MO.RemovalDueTime);
    admindtstr := DisplayVADateYearTime(MO.AdministrationTime);
    // if order is on provider hold, do not show a dose as late
    if (MO.OrderStatus <> 'H') then begin
      if ((MO.RemovalStatus = '') or (MO.RemovalStatus = '0')) then begin // non-MRR only
        if (Trim(MO.ScanStatus) = 'G') then // completed
          iscomplete := True;           // never late
      end
      else begin                        // MRR
        if (Trim(MO.ScanStatus) = 'RM') then // completed
          iscomplete := True;           // never late
      end;

      if not iscomplete then begin
        if MO.RemovalIsAllowed then
          OrderDueTime := MO.RemovalDueTime
        else if MO.AdministrationTime > '' then begin
          tbool := TryStrToFloat(MO.AdministrationTime, fmAdminTime);
          if tbool then
            OrderDueTime := FMDateTimeToDateTime(fmAdminTime);
        end;

        // if clinic order and administrationdate/removaldate is today, not late  // rpk 1/22/2016
        { if Trim(MO.ClinicName) > '' then begin
          OrderDueDate := DateOf(OrderDueTime);
          if OrderDueDate = Today then begin
            Result := 0.0;
            exit;
          end;
        end; }

        if OrderdueTime > 0.0 then
          // SinceMinutes is positive if orderduetime > server time
          SinceMinutes := TimeApartInMins(OrderDueTime, BCMA_SiteParameters.ServerTime);
        TimeLimit := BCMA_SiteParameters.MinutesAfter;
//        if SinceMinutes > TimeLimit then
        Result := SinceMinutes - TimeLimit;
      end;                              // not complete

    end;                                // not on Provider Hold
  end;                                  // MO is assigned

//  if ((MO.RemovalStatus = '') or (MO.RemovalStatus = '0')) and                  // non-MRR only
//    (MO.ScanStatus = 'G') then                                                  // and given
//    Result := 0.0;                                                              // never late
  { if ((MO.RemovalStatus = '') or (MO.RemovalStatus = '0')) then begin           // non-MRR only
    if (MO.ScanStatus = 'G') then                                               // completed
      Result := 0.0;                                                            // never late
  end
  else begin                                                                    // MRR
    if (MO.ScanStatus = 'RM') then                                              // completed
      Result := 0.0;
  end; }

end;                                    // DateTimeLate

// check for late orders that are not yet completed
{ function isLateOrder(anOrder: TBCMA_MedOrder): Boolean;                         // rpk 9/10/2015
var
  LateMinutes: TDateTime;
  isLate: Boolean;
begin
  LateMinutes := DateTimeLate(anOrder);
  isLate := LateMinutes > 0.0;
  if Assigned(anOrder) then begin
    with anOrder do begin
      if ((RemovalStatus <> '') and (RemovalStatus <> '0')) then begin          // MRR only
        if Trim(ScanStatus) = 'RM' then
          // completed; no further action needed
          isLate := False;
      end
      else begin                                                                // non-MRR
        if trim(ScanStatus) = 'G' then                                          // rpk 8/26/2015
          // completed; no further action needed
          isLate := False;                                                      // rpk 8/28/2015
      end;
    end;
  end;

  Result := isLate;

                                                                          end; }// isLateOrder

//function getOrderNextAction(anOrder:TBCMA_MedOrder; aMode:Boolean):String;

function getOrderNextAction(anOrder: TBCMA_MedOrder; aMode: Boolean;
  var NextAction: string; var NextDT: string; var isLate: Boolean): string; // rpk 8/4/2015
var
  OutText: string;
  LateMinutes: TDateTime;
  nextactiondtstr: string;
  yearminutes: Double;
begin
  OutText := '';
  NextAction := '';
  NextDT := '';
  LateMinutes := 0;
  isLate := False;
  yearminutes := 366.0 * 24. * 60.;
  nextactiondtstr := '';

  if anOrder <> nil then
    with anOrder do
    begin
      LateMinutes := DateTimeLate(anOrder);
      isLate := LateMinutes > 0.0;

      OutText := NextActionTextByStatus(anOrder, isLate);
      NextAction := OutText;
      // debug, check for admin / removal times greater than one year
      if Abs(LateMinutes) > yearminutes then begin
        nextactiondtstr := anOrder.getTextNextActionYearDateTime;
        WriteLogMessageProc('getOrderNextAction: nextactiondtstr="' + nextactiondtstr + '"', nil);
      end;
      if aMode then begin
//        OutText := OutText + CAS_naDelim + TextNextActionTime; //DisplayVADate(AdministrationTime)
//        NextDT := TextNextActionTime;   // rpk 8/4/2015
        nextactiondtstr := TextNextActionTime; // rpk 9/21/2016
        if isMRR and
          ((ScheduleType <> 'P') and  // PRN
          (ScheduleType <> 'O') and   // One Time
          (ScheduleType <> 'OC')) and   // OnCall
          (nextactiondtstr = '') then   // rpk 9/21/2016
          nextactiondtstr := 'DETAILS FOR RM'; // rpk 9/23/2016
        OutText := OutText + CAS_naDelim + nextactiondtstr; // rpk 9/21/2016
        NextDT := nextactiondtstr;      // rpk 9/21/2016
      end;
    end;                                // with anOrder
  Result := OutText;
end;                                    // getOrderNextAction

function getOrderAlertText(anOrder: TBCMA_MedOrder; aMode: Boolean): string;
var
  OutText: string;
begin
  OutText := '';
  if anOrder <> nil then
    with anOrder do
    begin
      if WitnessFlag = WITNESS_REQUIRED then
        OutText := 'Witness Required'
      else if WitnessFlag = WITNESS_RECOMMENDED then
        OutText := 'Witness Recommended';

      if aMode                          // if TRUE include RR text
        and ((RemovalStatus <> '') and (RemovalStatus <> '0')) // MRR only
        and IsRemovalRequiredByStatus(ScanStatus) then // by Status
        if OutText <> '' then
          OutText := OutText + ', Removal Required '
        else
          OutText := OutText + ' Removal Required ';
    end;
  Result := OutText;
end;                                    // getOrderAlertText


initialization
  setup;

end.

