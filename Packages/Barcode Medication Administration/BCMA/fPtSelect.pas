unit fPtSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, BCMA_Startup, BCMA_Objects,
  BCMA_Util, VHA_Objects, VA508AccessibilityManager, Grids,
  VA508AccessibilityRouter;

type

  TPtSelectSortType = (stAscending, stDescending);

  PtSelectColumnTypes = (ctPtName,
    ctPtSSN,
    ctPtDOB,
    ctPtRmBed,
    ctPtWard);

  TfrmPtSelect = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    tmrPtSelect: TTimer;
    grpPtName: TGroupBox;
    edtPtName: TEdit;
    pnlPatientList: TPanel;
    stPtList: TStaticText;
    sgPtList: TStringGrid;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lvwPtList: TListView;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    procedure tmrPtSelectTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lvwPtListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure edtPtNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvwPtListColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormShow(Sender: TObject);
    procedure sgPtListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure VA508ComponentAccessibility1ItemQuery(Sender: TObject;
      var Item: TObject);
    procedure VA508ComponentAccessibility1ValueQuery(Sender: TObject;
      var Text: string);
    procedure lvwPtListEnter(Sender: TObject);
    procedure sgPtListEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtPtNameChange(Sender: TObject);
    procedure sgPtListExit(Sender: TObject);
    procedure lvwPtListExit(Sender: TObject);
    procedure edtPtNameEnter(Sender: TObject);
    procedure edtPtNameExit(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }//    property PatientList: TList read FPatientlist;
    procedure LoadPatients(SearchString: string);
    procedure ClearPatients;
    procedure RefreshPtList;
  end;

  TBCMA_Patients = class(TObject)
    (*
      Contains information about a Patient.
    *)
  private
    FRPCBroker: TBCMA_Broker;
    fIEN,
      fName,
      fSex,
      fDOB,
      fSSN,
      fWard,
      fRmBed,
      fDOBforDisplay,
      fSSNforDisplay: string;
  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    destructor Destroy; override;
  end;

var
  frmPtSelect: TfrmPtSelect;
  PatientList: TList;
  PtSelectSortCol: PtSelectColumnTypes;
  PtSelectSortType: TPtSelectSortType;

implementation

{$R *.dfm}

uses
  BCMA_Common, BCMA_Main;
//  MFunStr;

var
  SelectedX: integer;
  SelectedY: integer;

function PtSelectSort(Item1, Item2: pointer): Integer;
var
  str1, str2: string;
begin
  result := 1;

  case PtSelectSortCol of
    ctPtName:
      result := AnsiCompareStr(TBCMA_Patients(Item1).fName,
        TBCMA_Patients(Item2).fName);
    ctPtSSN:
      result := AnsiCompareStr(TBCMA_Patients(Item1).fSSNForDisplay,
        TBCMA_Patients(Item2).fSSNForDisplay);
    ctPtDOB: begin
        str1 := format('%s|%s', [TBCMA_Patients(Item1).fDOBforDisplay,
          TBCMA_Patients(Item1).fName]);
        str2 := format('%s|%s', [TBCMA_Patients(Item2).fDOBforDisplay,
          TBCMA_Patients(Item2).fName]);
        result := AnsiCompareStr(str1, str2);
      end;
    ctPtRmBed:
      result := AnsiCompareStr(TBCMA_Patients(Item1).fRmBed,
        TBCMA_Patients(Item2).fRmBed);
    ctPtWard: begin
        str1 := format('%s|%s', [TBCMA_Patients(Item1).fWard,
          TBCMA_Patients(Item1).fName]);
        str2 := format('%s|%s', [TBCMA_Patients(Item2).fWard,
          TBCMA_Patients(Item2).fName]);
        result := AnsiCompareStr(str1, str2);
      end;
  end;
  if PtSelectSortType = stDescending then begin
    if result = 1 then
      result := -1
    else if result = -1 then
      result := 1;
  end;
end;

procedure TfrmPtSelect.RefreshPtList;
var
  x, y: integer;
begin
  lvwPtList.Clear;

  if PatientList.Count > 0 then begin
    if ScreenReaderSystemActive then begin
      // show string grid for screen reader
      lvwPtList.SendToBack;
      lvwPtList.Hide;
      lvwPtList.TabStop := False;
      sgPtList.ColCount := 5;
      sgInit(sgPtList, 1, PatientList.Count); // rpk 9/10/2010
      //      sgPtList.Rows[0].CommaText := 'Name, SSN, DOB, Rm-Bd, Ward';
      sgPtList.Rows[0].CommaText := 'Name, "' +
        BCMA_SiteParameters.PatientIDLabel + '", DOB, Rm-Bd, Ward';
      // rpk 6/9/2010
      for x := 0 to PatientList.Count - 1 do begin
        y := x + 1;
        with sgPtList do begin
          Cells[0, y] := TBCMA_Patients(PatientList[x]).fName;
          Cells[1, y] := TBCMA_Patients(PatientList[x]).fSSNforDisplay;
          Cells[2, y] := TBCMA_Patients(PatientList[x]).fDOBforDisplay;
          Cells[3, y] := TBCMA_Patients(PatientList[x]).fRmBed;
          Cells[4, y] := TBCMA_Patients(PatientList[x]).fWard;
        end;
      end; // for
      sgPtList.Align := alClient;
      sgPtList.BringToFront;
      sgPtList.TabStop := True;
      sgPtList.Show;
//      if sgPtList.CanFocus then // rpk 9/7/2010
//        sgPtList.SetFocus;
//      sgPtList.Invalidate;
    end
    else begin
      // show listview for normal users
      sgPtList.SendToBack;
      sgPtList.TabStop := False;
      sgPtList.Hide;

      // do columns get cleared on listview clear?
      lvwPtList.Column[1].Caption := BCMA_SiteParameters.PatientIDLabel; // rpk 6/9/2010

      for x := 0 to PatientList.Count - 1 do begin
        with lvwPtList do begin
          AddItem(TBCMA_Patients(PatientList[x]).fName, nil);
          Items[x].SubItems.Add(TBCMA_Patients(PatientList[x]).fSSNforDisplay);
          Items[x].SubItems.Add(TBCMA_Patients(PatientList[x]).fDOBforDisplay);
          Items[x].SubItems.Add(TBCMA_Patients(PatientList[x]).fRmBed);
          Items[x].SubItems.Add(TBCMA_Patients(PatientList[x]).fWard);
        end;
      end;
      lvwPtList.Align := alClient;
      lvwPtList.BringToFront;
      lvwPtList.TabStop := True;
      lvwPtList.Show;
//      if lvwPtList.CanFocus then // rpk 9/7/2010
//        lvwPtList.SetFocus;
//      lvwPtList.Invalidate;
    end;
//    Update;
    Refresh;
  end;
end; // RefreshPtList

procedure TfrmPtSelect.tmrPtSelectTimer(Sender: TObject);
begin
  tmrPtSelect.Enabled := False;
  btnOK.Enabled := False;
  if ScreenReaderSystemActive then begin
    sgClear(sgPtlist);
//    sgInit(sgPtList, 1, PatientList.Count); // rpk 9/10/2010
    sgInit(sgPtList, 1, 0); // rpk 10/6/2010
    sgPtList.Repaint;
  end
  else begin
    lvwPtList.Clear;
    lvwPtList.Repaint;
  end;
  frmMain.StatusBar.Panels[0].Text := 'Retrieving Patients...';
  frmMain.StatusBar.Repaint;

  LoadPatients(edtptName.Text);

  if (PatientList.Count = 0) or
    //  if TBCMA_Patients(PatientList[0]).fIEN = '-1' then
  (TBCMA_Patients(PatientList[0]).fIEN = '-1') then begin
    if ScreenReaderSystemActive then begin
      sgPtList.Hide;
      sgPtList.SendToBack;
      stPtList.Caption := TBCMA_Patients(PatientList[0]).fName;
      stPtList.BringToFront;
      stPtList.Show;
      stPtList.TabStop := True; // rpk 9/21/2010
      edtptName.Text := '';
      edtptName.SetFocus;
      if stPtList.CanFocus then // 9/7/2010
        stPtList.SetFocus;
    end
    else begin
      lvwPtList.Hide;
      pnlPatientList.Caption := TBCMA_Patients(PatientList[0]).fName;
      pnlPatientList.Show;
    end;
    exit;
  end
  else begin
    // found patient
    stPtList.TabStop := False; // rpk 9/21/2010
    if ScreenReaderSystemActive then begin
      stPtList.Caption := '';
      stPtList.Hide;
    end;
    PatientList.Sort(PtSelectSort);
    RefreshPtList;
  end;

  frmMain.StatusBar.Panels[0].Text := '';
//  frmMain.StatusBar.Repaint;
  frmMain.StatusBar.Invalidate; // rpk 10/6/2010
end; // tmrPtSelectTimer

procedure TfrmPtSelect.VA508ComponentAccessibility1ItemQuery(Sender: TObject;
  var Item: TObject);
//var
//  i: Integer;
begin
  //  i := 100 * SelectedY + SelectedX;
  //  Item := TObject(i);
end; // VA508ComponentAccessibility1ItemQuery

procedure TfrmPtSelect.VA508ComponentAccessibility1ValueQuery(Sender: TObject;
  var Text: string);
begin
  Text := ' Name ' + sgPtList.Cells[0, SelectedY] + ' ' +
    'Column ' + sgPtList.Cells[SelectedX, 0] + ', ' +
    sgPtList.Cells[SelectedX, SelectedY];
end; // VA508ComponentAccessibility1ValueQuery

procedure TfrmPtSelect.FormCreate(Sender: TObject);
begin
  grpPtName.Caption := 'Patient Name (Last, First or ' +
    BCMA_SiteParameters.PatientIDLabel + ', Rm-Bd, or Ward)'; // rpk 8/7/2009

  if ScreenReaderSystemActive then begin
    sgPtList.ColCount := 5;
    //    sgPtList.ColWidths[0] := trunc(sgPtList.Width * 0.34);
    sgPtList.ColWidths[0] := trunc(sgPtList.Width * 0.33);
    sgPtList.ColWidths[1] := trunc(sgPtList.Width * 0.12);
    sgPtList.ColWidths[2] := trunc(sgPtList.Width * 0.12);
    sgPtList.ColWidths[3] := trunc(sgPtList.Width * 0.12);
    //    sgPtList.ColWidths[4] := trunc(sgPtList.Width * 0.27);
    sgPtList.ColWidths[4] := trunc(sgPtList.Width * 0.28);
  end
  else begin
    lvwPtList.Column[1].Caption := BCMA_SiteParameters.PatientIDLabel;
    // rpk 6/9/2010
    lvwPtList.Column[0].Width := trunc(lvwPtList.Width * 0.33);
    lvwPtList.Column[1].Width := trunc(lvwPtList.Width * 0.12);
    lvwPtList.Column[2].Width := trunc(lvwPtList.Width * 0.12);
    lvwPtList.Column[3].Width := trunc(lvwPtList.Width * 0.12);
    lvwPtList.Column[4].Width := trunc(lvwPtList.Width * 0.28);
  end;

  PatientList := TList.Create;

  PtSelectSortCol := ctPtName;
  PtSelectSortType := stAscending;

{$IFDEF CAS_DDPE_DEBUG}
//  edtPtName.Text := 'IMAT';
{$ENDIF}
end;

procedure TfrmPtSelect.FormDestroy(Sender: TObject);
begin
  PatientList.Free;
end;

procedure TfrmPtSelect.FormActivate(Sender: TObject);
begin
  edtPtName.SetFocus;
{$IFDEF CAS_DDPE_DEBUG}
  tmrPtSelect.Interval := 500;
  tmrPtSelect.Enabled := True;
{$ENDIF}
end;

procedure TfrmPtSelect.lvwPtListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  btnOK.Enabled := True;
end;

procedure TfrmPtSelect.btnOKClick(Sender: TObject);
var
  idx: Integer;
begin
  if ScreenReaderSystemActive then begin
    if sgPtList.RowCount < 2 then
      Exit;
  end
  else begin
    if lvwPtList.ItemIndex = -1 then
      exit;
  end;

  {JK 7/12/2008 CQ #125}
//  if ReadOnly or LimitedAccess or EditMedLog then
//    BCMA_Patient.ScanPatient(TBCMA_Patients(PatientList[lvwPtList.ItemIndex]).fSSN, 1)
//  else
//    BCMA_Patient.ScanPatient(TBCMA_Patients(PatientList[lvwPtList.ItemIndex]).fSSN, 0);

  if ScreenReaderSystemActive then
    idx := sgPtList.Row - 1
  else
    idx := lvwPtList.ItemIndex;

  if idx >= 0 then begin
    if ReadOnly or LimitedAccess or EditMedLog then
      BCMA_Patient.ScanPatient(TBCMA_Patients(PatientList[idx]).fSSN, 1)
    else
      BCMA_Patient.ScanPatient(TBCMA_Patients(PatientList[idx]).fSSN, 0);

    if BCMA_Patient.IEN <> '' then
      ModalResult := mrOK;
  end;
end;

procedure TfrmPtSelect.edtPtNameChange(Sender: TObject);
begin
//  tmrPtSelect.Enabled := False;
//  if (Key <> 9) then
//  tmrPtSelect.Enabled := Length(edtPtName.Text) >= 2;
end;

procedure TfrmPtSelect.edtPtNameEnter(Sender: TObject);
begin
  tmrPtSelect.Enabled := False; // rpk 9/21/2010
end;

procedure TfrmPtSelect.edtPtNameExit(Sender: TObject);
begin
//  tmrPtSelect.Enabled := True;  // rpk 10/6/2010
end;

procedure TfrmPtSelect.edtPtNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  tmrPtSelect.Enabled := False;
  if (Key <> 9) then
    tmrPtSelect.Enabled := Length(edtPtName.Text) >= 2;
end;

procedure TfrmPtSelect.sgPtListEnter(Sender: TObject);
var
  CanSelect: Boolean;
begin
  tmrPtSelect.Enabled := False; // rpk 9/11/2010
  btnOK.Enabled := True;
  with sgPtList do begin
    // if in header row, reset to row 1
    if (Row < 1) and (RowCount > 1) then
      Row := 1;
    sgPtListSelectCell(Sender, Col, Row, CanSelect);
  end;
end;

procedure TfrmPtSelect.sgPtListExit(Sender: TObject);
begin
  tmrPtSelect.Enabled := False;
end;

procedure TfrmPtSelect.sgPtListSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  SelectedX := ACol;
  SelectedY := ARow;
  btnOK.Enabled := True;
end;

procedure TfrmPtSelect.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // only in FormDestroy
  //  PatientList.Free;
end;

procedure TfrmPtSelect.LoadPatients(SearchString: string);
var
  MultList: TStringList;
  x: integer;
begin
  MultList := nil;
//  try
  MultList := TStringList.Create;
  try // rpk 2/23/2012
    with MultList do begin
      Add('PTLKUP');
      Add(SearchString);
    end;
    ClearPatients;
    if (BCMA_Broker <> nil) then begin
      with BCMA_Broker do begin
        if CallServer('PSB MED LOG LOOKUP', ['~!#null#~!'], MultList) then begin
          if (Results.Count = 0) or (Results.Count - 1 <> StrToInt(Results[0]))
            then
            DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
          else if (piece(Results[1], '^', 1) = '-1') then begin
            with PatientList do begin
              add(TBCMA_Patients.Create(BCMA_Broker));
              with TBCMA_Patients(PatientList[PatientList.Count - 1]) do begin
                FIEN := '-1';
                FName := piece(Results[1], '^', 2);
              end;
            end
          end
          else begin
            with PatientList do begin
              for x := 1 to Results.Count - 1 do begin
                add(TBCMA_Patients.Create(BCMA_Broker));
                with TBCMA_Patients(PatientList[PatientList.Count - 1]) do begin
                  fIEN := piece(Results[x], '^', 1);
                  fName := piece(Results[x], '^', 2);
                  fSex := piece(Results[x], '^', 3);
                  fDOB := piece(Results[x], '^', 4);
                  fSSN := piece(Results[x], '^', 5);
                  fWard := piece(Results[x], '^', 6);
                  fRmBed := piece(Results[x], '^', 7);
                  fDOBforDisplay := piece(Results[x], '^', 10);
                  fSSNforDisplay := piece(Results[x], '^', 11);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    MultList.Free;
  end;
end;

constructor TBCMA_Patients.Create(RPCBroker: TBCMA_Broker);
begin
  inherited create;
  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;
end;

destructor TBCMA_Patients.Destroy;
begin
  FRPCBroker := nil;
  inherited Destroy;
end;

procedure TfrmPtSelect.ClearPatients;
var
  ii: integer;
begin
  if PatientList <> nil then
    with PatientList do begin
      for ii := count - 1 downto 0 do
        TBCMA_Patients(items[ii]).free;
      clear;
    end;
end;

procedure TfrmPtSelect.lvwPtListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if PtSelectColumnTypes(Column.Index) = PtSelectSortCol then
    if PtSelectSortType = stAscending then
      PtSelectSortType := stDescending
    else if PtSelectSortType = stDescending then
      PtSelectSortType := stAscending;

  PtSelectSortCol := PtSelectColumnTypes(Column.Index);
  PatientList.Sort(PtSelectSort);
  RefreshPtList;
end;

procedure TfrmPtSelect.lvwPtListEnter(Sender: TObject);
begin
  tmrPtSelect.Enabled := False; // rpk 9/11/2010
  with lvwPtList do
    if (ItemIndex = -1) and (items.Count > 0) then
      lvwPtList.ItemIndex := 0;
end;

procedure TfrmPtSelect.lvwPtListExit(Sender: TObject);
begin
  tmrPtSelect.Enabled := False; // rpk 9/21/2010
end;

procedure TfrmPtSelect.FormShow(Sender: TObject);
begin
  stPtList.Hide;
  stPtList.TabStop := False; // rpk 9/21/2010
  if ScreenReaderSystemActive then begin
    lvwPtList.SendToBack;
    lvwPtList.Hide;
    lvwPtList.TabStop := False;
    sgPtList.TabStop := True;
    sgPtList.Align := alClient;
    sgPtList.BringToFront;
    sgPtList.Show;
    sgPtList.Invalidate;
  end
  else begin
    sgPtList.SendToBack;
    sgPtList.Hide;
    sgPtList.TabStop := False;
    lvwPtList.TabStop := True;
    lvwPtList.Align := alClient;
    lvwPtList.BringToFront;
    lvwPtList.Show;
    lvwPtList.Invalidate;
  end;
  edtPtName.SetFocus;

  Update; // rpk 9/18/2009
  ForceForegroundWindow(handle);

end;

initialization
  SpecifyFormIsNotADialog(TfrmPtSelect);

end.

