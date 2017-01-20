 {
   Prototype 
 }
unit fCAS_Log;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, DB, DBClient, StdCtrls, DBCtrls, ValEdit,
  Buttons, ComCtrls;

type
  TfrmCAS_Log = class(TForm)
    pnlCalendar: TPanel;
    pnlOrdersComments: TPanel;
    splCalendar: TSplitter;
    pnlCalHeader: TPanel;
    pnlComments: TPanel;
    pnlCommentsHeader: TPanel;
    splDateComment: TSplitter;
    pnlMedLog: TPanel;
    pnlMedLogHdr: TPanel;
    dbgCalendar: TDBGrid;
    dsCalendar: TDataSource;
    cdsCalendar: TClientDataSet;
    cdsMedLog: TClientDataSet;
    dsMedLog: TDataSource;
    dbgMedLog: TDBGrid;
    mmDetails: TMemo;
    dbtDate: TDBText;
    vleMedLogRecord: TValueListEditor;
    cdsComments: TClientDataSet;
    dsComments: TDataSource;
    dbgComments: TDBGrid;
    spbAddComment: TSpeedButton;
    spbGrid: TSpeedButton;
    spbData: TSpeedButton;
    dtpkrHigh: TDateTimePicker;
    pnlCalFooter: TPanel;
    pnlDate: TPanel;
    spbBack: TSpeedButton;
    spbForward: TSpeedButton;
    btnRefresh: TSpeedButton;
    edEnd: TEdit;
    spbNow: TSpeedButton;
    cmbSpan: TComboBox;
    pnlCommentsFooter: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure dsCalendarDataChange(Sender: TObject; Field: TField);
    procedure dbgCalendarDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dsMedLogDataChange(Sender: TObject; Field: TField);
    procedure spbDataClick(Sender: TObject);
    procedure spbAddCommentClick(Sender: TObject);
    procedure dtpkrHighChange(Sender: TObject);
    procedure spbBackClick(Sender: TObject);
    procedure spbForwardClick(Sender: TObject);
    procedure spbNowClick(Sender: TObject);
    procedure cmbSpanChange(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    fMedIEN :String;
    bIgnoreDetails: Boolean;
    procedure setFieldsCalendar;
    procedure setFieldsLog;
    procedure setFieldsLogComments;
    function getMedIEN:String;
    procedure setMedIEN(anIEN:String);
    procedure setEndTime;
  public
    { Public declarations }
    ptDFN: String;
    property MedIEN: String read getMedIEN write setMedIEN;
    procedure setCalendar(aStart:TDateTime; Days: String);
    procedure UpdateComments;
  end;

var
  frmCAS_Log: TfrmCAS_Log;

function newCas_Log: TfrmCAS_Log;

implementation

uses uCAS_Utils, uCASC_Log, BCMA_Common
  , VAUtils
  , fEditMedLog, fZZ_EventLog;

{$R *.dfm}
const
  fmtDate = 'dd/mm/yyyy';
  fnDate = 'Date';
  fnDOW = 'DOW';

  Dow: array[1..7] of string = ('Su','M','T','W','Th','Fr','Sa');

  CalendarMax = 3650.0;
  CalendarDefault = 365.0;

function newCas_Log: TfrmCAS_Log;
begin
  Application.CreateForm(TfrmCAS_Log,Result);
  addTextEvent('CAS_Log CREATED','TfrmCAS_Log: CREATED');
end;

procedure TfrmCas_Log.setFieldsCalendar;
var
  sf: TStringField;
  df: TDateTimeField;
begin
  if cdsCalendar.Active then
    cdsCalendar.Active := False;
  df := NewDateTimeField(cdsCalendar,fnDate,fnDate);
  sf := NewStringField(cdsCalendar,fnDoW,fnDoW,10,10);
  cdsCalendar.CreateDataSet;
  cdsCalendar.Active := True;
  cdsCalendar.LogChanges := False;
  with cdsCalendar.IndexDefs.AddIndexDef do
  begin
    Name := 'DateIdx';
    Fields := fnDate;
    Options := [ixDescending,ixCaseInSensitive];
  end;
  cdsCalendar.IndexName := 'DateIdx';

end;

const
  fnRAW = 'Source';
  fnDFN = 'DFN';
  fnDOA = 'DateOfActivity';
  fnOI  = 'OrderableItem';
  fnDosage = 'Dosage';
  fnForm = 'Form';
  fnIVID = 'IVUniqueID';
  fnAS = 'ActionStatus';
  fnST = 'ScheduleType';
  fnActionDate = 'ActionDate';
  fnActionBy = 'ActionBy';
  fnPRNR = 'PRNReason';
  fnPRNE = 'PRNEffectiveness';

  fnID = 'ID';
  fnComment = 'Comment';
  fnMadeBy = 'MadeBy';
  fnMadeOn = 'MadeOn';

procedure TfrmCAS_Log.setFieldsLog;
var
  cds: TClientDataSet;
  sf: TStringField;
  df: TDateTimeField;
begin
  cds := cdsMedLog;
  if cds.Active then
    cds.Active := False;

  sf := NewStringField(cds,fnDFN,fnDFN,10,10);

  sf := NewStringField(cds,fnST,fnST,20,40);
  sf := NewStringField(cds,fnOI,fnOI,40,200);
  sf := NewStringField(cds,fnAS,fnAS,20,40);
  sf := NewStringField(cds,fnActionDate,fnActionDate,20,20);
  sf := NewStringField(cds,fnActionBy,fnActionBy,20,40);

  sf := NewStringField(cds,fnDOA,fnDOA,20,20);
  sf := NewStringField(cds,fnDosage,fnDosage,20,20);
  sf := NewStringField(cds,fnForm,fnForm,40,40);
  sf := NewStringField(cds,fnIVID,fnIVID,20,20);
  sf := NewStringField(cds,fnPRNR,fnPRNR,20,80);
  sf := NewStringField(cds,fnPRNE,fnPRNE,20,80);
  sf := NewStringField(cds,fnRaw,fnRaw,40,200);
  sf.Visible := False;

  cds.CreateDataSet;
  cds.Active := True;
  cds.LogChanges := False;
end;

procedure TfrmCAS_Log.setFieldsLogComments;
var
  cds: TClientDataSet;
  sf: TStringField;
//  df: TDateTimeField;
begin
  cds := cdsComments;
  if cds.Active then
    cds.Active := False;

  sf := NewStringField(cds,fnID,fnID,20,40);
  sf.Visible := False;
  sf := NewStringField(cds,fnMadeOn,fnMadeOn,20,40);
  sf := NewStringField(cds,fnComment,fnComment,150,150);
  sf := NewStringField(cds,fnMadeBy,fnMadeBy,20,40);

  cds.CreateDataSet;
  cds.Active := True;
  cds.LogChanges := False;
  with cds.IndexDefs.AddIndexDef do
  begin
    Name := 'TimeIdx';
    Fields := fnID;
    Options := [ixDescending,ixCaseInSensitive];
  end;
  cds.IndexName := 'TimeIdx';

end;

function TfrmCAS_log.getMedIEN;
begin
  Result := fMedIEN;
end;

procedure TfrmCAS_Log.setMedIEN(anIEN: string);
begin
  fMedIEN := anIEN;
  spbAddComment.Enabled := anIEN <> '';
end;

procedure TfrmCAS_Log.spbDataClick(Sender: TObject);
begin
  dbgComments.Visible := spbGrid.Down;
//  vleMedLogRecord.Visible := spbData.Down;
  mmDetails.Visible := spbData.Down;
end;

procedure TfrmCAS_Log.spbBackClick(Sender: TObject);
var
  dt: TDateTime;
begin
  { dt := dtpkrHigh.Date + StrToIntDef(cmbSpan.Text,30);
  if dt > dtpkrHigh.MaxDate  then
    dtpkrHigh.Date := dtpkrHigh.MaxDate
  else
    dtpkrHigh.Date := dt;

  setEndTime; }

  dt := dtpkrHigh.Date - StrToIntDef(edEnd.Text,30);
  if dt < dtpkrHigh.MinDate  then
    dtpkrHigh.Date := dtpkrHigh.MinDate
  else
    dtpkrHigh.Date := dt;

  setEndTime;
end;

procedure TfrmCAS_Log.spbForwardClick(Sender: TObject);
var
  dt: TDateTime;
begin
  { dt := dtpkrHigh.Date - StrToIntDef(edEnd.Text,30);
  if dt < dtpkrHigh.MinDate  then
    dtpkrHigh.Date := dtpkrHigh.MinDate
  else
    dtpkrHigh.Date := dt;

  setEndTime; }

  dt := dtpkrHigh.Date + StrToIntDef(cmbSpan.Text,30);
  if dt > dtpkrHigh.MaxDate  then
    dtpkrHigh.Date := dtpkrHigh.MaxDate
  else
    dtpkrHigh.Date := dt;

  setEndTime;
end;

procedure TfrmCAS_Log.btnRefreshClick(Sender: TObject);
begin
  setCalendar(dtpkrHigh.Date,cmbSpan.Text);
  spbData.Click;
end;

procedure TfrmCAS_Log.spbNowClick(Sender: TObject);
begin
  dtpkrHigh.Date := Now;
  setEndTime;
end;

procedure TfrmCAS_Log.spbAddCommentClick(Sender: TObject);
begin
  EditMedLogExecute(MedIEN);
  UpdateComments;
end;

procedure TfrmCAS_Log.cmbSpanChange(Sender: TObject);
begin
  setEndTime;
  
end;

procedure TfrmCAS_Log.dbgCalendarDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  field: TField;
  dataset: TDataSet;
  risk: String;
begin
  if (gdSelected in State) or (gdFocused in State) then
    begin
      with Sender as TDBGrid do
        DefaultDrawColumnCell(Rect,DataCol, Column, State);
      exit;
    end;
   dataset := dbgCalendar.DataSource.DataSet;
   field := dataset.FieldByName(fnDoW);
   risk := field.AsString;
   if (risk = Dow[1]) or (risk = Dow[7]) then
     begin
       dbgCalendar.Canvas.font.color := clWindowText;
       dbgCalendar.Canvas.Brush.color := $00DFFCDA; //clMoneyGreen;
     end
   else
     begin
       dbgCalendar.Canvas.font.color := clWindowText;
       dbgCalendar.Canvas.Brush.color := clCream;
     end;

  with Sender as TDBGrid do
    DefaultDrawColumnCell(Rect,DataCol, Column, State);
end;

procedure TfrmCAS_Log.dsCalendarDataChange(Sender: TObject; Field: TField);
var
  SL: TStringList;
  s: String;
  i: Integer;

  procedure ProcessRecord(aText:String);
  begin
    cdsMedLog.Insert;
    cdsMedLog.FieldByName(fnRaw).AsString := aText;
    cdsMedLog.FieldByName(fnDFN).AsString := piece(aText,'^',1);
    cdsMedLog.FieldByName(fnDOA).AsString := piece(aText,'^',2);
    cdsMedLog.FieldByName(fnOI).AsString := piece(aText,'^',3);
    cdsMedLog.FieldByName(fnDosage).AsString := piece(piece(aText,'^',3),' ',1);
    cdsMedLog.FieldByName(fnForm).AsString := piece(piece(aText,'^',3),' ',2);
    cdsMedLog.FieldByName(fnIVID).AsString := piece(aText,'^',4);
    cdsMedLog.FieldByName(fnAS).AsString := piece(aText,'^',5);
    cdsMedLog.FieldByName(fnST).AsString := piece(aText,'^',6);
    cdsMedLog.FieldByName(fnActionDate).AsString := piece(aText,'^',7);
    cdsMedLog.FieldByName(fnActionBy).AsString := piece(aText,'^',8);
    cdsMedLog.FieldByName(fnPRNR).AsString := piece(aText,'^',9);
    cdsMedLog.FieldByName(fnPRNE).AsString := piece(aText,'^',10);
    cdsMedLog.Post;
  end;

begin
  mmDetails.Lines.Clear;
  vleMedLogRecord.Strings.Clear;
  if cdsComments.Active then
    cdsComments.EmptyDataSet;

  if not cdsMedLog.Active then
    Exit;
  s := CalendarDateToMDate(cdsCalendar.FieldByName(fnDate).AsString);
  if s = '' then
    exit;
  cdsMedLog.DisableControls;
  bIgnoreDetails := true;
  try
    SL := getAdministrations(BCMA_Patient.IEN,s);
    cdsMedLog.EmptyDataSet;
    if (SL.Count > 0) and (Pos('Error',SL[0])<>1) then
      for i := 0 to SL.Count - 1 do
        ProcessRecord(SL[i]);
  except
  end;
  cdsMedLog.EnableControls;
  FormatGrid(dbgMedLog);
  bIgnoreDetails := false;
  SL.Free;
  cdsMedLog.First;
end;

procedure TfrmCAS_Log.UpdateComments;
var
  SL: TStringList;
  i: integer;

  procedure ProcessRecord(aText:String);
  begin
    if pos('[BEGIN_',aText)=1 then
      Exit;
    if pos('[END_',aText)=1 then
      Exit;

    cdsComments.Insert;
    cdsComments.FieldByName(fnID).AsString := piece(aText,'^',1);
    cdsComments.FieldByName(fnMadeBy).AsString := piece(aText,'^',3);
    cdsComments.FieldByName(fnMadeOn).AsString := piece(aText,'^',4);
    cdsComments.FieldByName(fnComment).AsString := piece(aText,'^',2);
    cdsComments.Post;
  end;

begin
  cdsComments.EmptyDataSet;
  SL := getMedLogComments(MedIEN);
  mmDetails.Text := mmDetails.Text + #13#10 + SL.Text;
  if SL.Count > 1 then
    begin
      for i := 1 to SL.Count - 1 do
        ProcessRecord(SL[i]);
      formatGrid(dbgComments);
    end;
  SL.Free;
end;

procedure TfrmCAS_Log.dsMedLogDataChange(Sender: TObject; Field: TField);
var
  SL: TStringList;
//  i: integer;

  procedure ProcessMedLogRecord(aSL: TSTringList);
  var
    s,sHead,sCurr: String;
    ii,i,iLen,iVle: integer;
  begin
    iVle := 1;
    mmDetails.Lines.Assign(SL);
    vleMedLogRecord.Strings.Clear;
    for ii  := 0 to SL.Count - 1 do
      begin
        sHead := '';
        s := SL[ii];
        i := 1;
        repeat
          sCurr := piece(s,'^',i);
          vleMedLogRecord.Values[IntToStr(iVle)] := sCurr;
          inc(iVle);
          iLen := Length(sHead + sCurr + '^');
          sHead := sHead + sCurr + '^';
          inc(i)
        until iLen >= Length(s);
      end;

  end;


begin
  if bIgnoreDetails then
    Exit;
  if not cdsMedLog.Active then
    Exit;

  MedIEN := cdsMedLog.FieldByName(fnDFN).AsString;
  if MedIEN = '' then
    exit;
  SL := getAdministrationDetail(MedIEN);
  ProcessMedLogRecord(SL);
  SL.Free;

  updateComments;

end;

procedure TfrmCAS_Log.dtpkrHighChange(Sender: TObject);
begin
  setEndTime;
end;

procedure TfrmCAS_Log.FormCreate(Sender: TObject);

  procedure setDTPKR;
  var
    dt: TDateTime;
  begin
    dt := Now;

    edEnd.text := FormatDateTime(fmtDate,dt);

    dtpkrHigh.Enabled := False;

    dtpkrHigh.MaxDate := dt;
    dtpkrHigh.Date := dt;
    dtpkrHigh.MinDate := dt - CalendarMax;

    dtpkrHigh.Enabled := True;

    dtpkrHighChange(nil);
  end;

begin
  setFieldsLogComments;
  setFieldsLog;

  setFieldsCalendar;

  dbtDate.DataField := fnDate;

  setDTPKR;

  spbData.Click;
end;

procedure TfrmCAS_Log.setCalendar(aStart:TDateTime; Days:String);
var
  s, sDoW: String;
  dt,aStop: TDateTime;
//  i: integer;
//  BM: TBookmark;
begin
  dt := aStart- StrToIntDef(Days,30);
  aStop := aStart;

  cdsCalendar.DisableControls;
  cdsCalendar.EmptyDataSet;
  while dt <= aStop do
    begin
      s := FormatDateTime('mm/dd/yyyy',dt);
      if not cdsCalendar.Locate(fnDate,VarArrayOf([s]),[]) then
        try
          cdsCalendar.Insert;
          cdsCalendar.FieldByName(fnDate).AsString := s;
          cdsCalendar.FieldByName(fnDoW).AsString := DoW[DayOfWeek(dt)];
          cdsCalendar.Post;
        except
        end;
      dt := dt + 1.0;
    end;
  cdsCalendar.EnableControls;
end;

procedure TfrmCAS_Log.setEndTime;
begin
  edEnd.Text := FormatDateTime(fmtDate, dtpkrHigh.Date - StrToIntDef(cmbSpan.Text,30));
end;

end.
