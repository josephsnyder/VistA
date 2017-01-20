unit fPrintPtSelect;

///
///  NOTE: restored pnlPatientList to visible to fix missing patient list.
///

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, BCMA_Startup, BCMA_Objects,
//  BCMA_Util,
  VHA_Objects, VA508AccessibilityManager, Grids,
  VA508AccessibilityRouter;

type

  TPtSelectSortType = (stAscending, stDescending);

  PtSelectColumnTypes = (ctPtName,
    ctPtSSN,
    ctPtDOB,
    ctPtRmBed,
    ctPtWard);

  TfrmPrintPtSelect = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    tmrPtSelect: TTimer;
    grpPtName: TGroupBox;
    edtWard: TEdit;
    grpPtList: TGroupBox;
    pnlPatientList: TPanel;
    lvwPtList: TListView;
    sgPtList: TStringGrid;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    stPtList: TVA508StaticText;
    procedure tmrPtSelectTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lvwPtListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure edtWardKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvwPtListEnter(Sender: TObject);
    procedure lvwPtListColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvwPtListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgPtListEnter(Sender: TObject);
    procedure sgPtListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure VA508ComponentAccessibility1ItemQuery(Sender: TObject;
      var Item: TObject);
    procedure VA508ComponentAccessibility1ValueQuery(Sender: TObject;
      var Text: string);

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

    //    procedure ClearPatients;
  end;

var
  frmPrintPtSelect: TfrmPrintPtSelect;
  PatientList: TList;
  PtSelectSortCol: PtSelectColumnTypes;
  PtSelectSortType: TPtSelectSortType;

implementation

{$R *.dfm}

uses
  BCMA_Common, BCMA_Main, BCMA_Util;
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

procedure TfrmPrintPtSelect.RefreshPtList;
var
  x, y: integer;
begin
  lvwPtList.Clear;
  //  sgClear(5, 2, sgPtList);
  if PatientList.Count > 0 then begin
    stPtList.TabStop := False; // rpk 9/8/2010
    if ScreenReaderSystemActive then begin
      // show string grid for screen reader
      lvwPtList.SendToBack;
      lvwPtList.Hide;
      lvwPtList.TabStop := False;
      sgInit(sgPtList, 1, PatientList.Count); // rpk 9/10/2010
      sgPtList.ColCount := 5;
//      sgPtList.Rows[0].CommaText := 'Name, SSN, DOB, Rm-Bd, Ward';
      sgPtList.Rows[0].CommaText := 'Name, ' +
        BCMA_SiteParameters.PatientIDLabel + ', DOB, Rm-Bd, Ward';  // rpk 6/9/2010
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
//      sgPtList.SetFocus;
      sgPtList.Invalidate;
    end
    else begin
      // show listview for normal users
      sgPtList.SendToBack;
      sgPtList.TabStop := False;
      sgPtList.Hide;

      // do columns get cleared on listview clear?
      lvwPtList.Column[1].Caption := BCMA_SiteParameters.PatientIDLabel;
      // rpk 6/9/2010

      if PatientList.Count > 0 then
        for x := 0 to PatientList.Count - 1 do
          with lvwPtList do begin
            AddItem(TBCMA_Patients(PatientList[x]).fName, nil);
            Items[x].SubItems.Add(TBCMA_Patients(PatientList[x]).fSSNforDisplay);
            Items[x].SubItems.Add(TBCMA_Patients(PatientList[x]).fDOBforDisplay);
            Items[x].SubItems.Add(TBCMA_Patients(PatientList[x]).fRmBed);
            Items[x].SubItems.Add(TBCMA_Patients(PatientList[x]).fWard);
            //        visible := True;
          end;
      lvwPtList.Align := alClient;
      lvwPtList.BringToFront;
      lvwPtList.TabStop := True;
      lvwPtList.Show;
//      lvwPtList.SetFocus;
      lvwPtList.Invalidate;
    end; // not ScreenReaderSystemActive

    Update;
  end
  else
    stPtList.TabStop := True;

end; // RefreshPtList

procedure TfrmPrintPtSelect.sgPtListEnter(Sender: TObject);
begin
  btnOK.Enabled := True;
end;

procedure TfrmPrintPtSelect.sgPtListSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  SelectedX := ACol;
  SelectedY := ARow;
  btnOK.Enabled := True;
end;

procedure TfrmPrintPtSelect.tmrPtSelectTimer(Sender: TObject);
//var
//  MultList: TStringList;
//  x: integer;

begin
  tmrPtSelect.Enabled := False;
  //  MultList := TStringList.Create;

  //  lvwPtList.Clear;

  //  with MultList do
  //  begin
  //    Add('PTLKUP');
  //    Add(edtPtName.text);
  //  end;

  //  lvwPtList.Repaint;

  if ScreenReaderSystemActive then begin
    sgClear(sgPtlist);
    sgInit(sgPtList, 1, PatientList.Count); // rpk 9/10/2010
    sgPtList.Repaint;
  end
  else begin
    lvwPtList.Clear;
    lvwPtList.Repaint;
  end;

  frmMain.StatusBar.Panels[0].Text := 'Retrieving Patients...';
  frmMain.StatusBar.Repaint;
  frmMain.StatusBar.SetFocus; // rpk 9/8/2010

  LoadPatients(edtWard.Text);

  if (PatientList.Count = 0) or
    (TBCMA_Patients(PatientList[0]).fIEN = '-1') then begin
    stPtList.TabStop := True; // rpk 9/8/2010
    if ScreenReaderSystemActive then begin
      sgPtList.Hide;
      sgPtList.SendToBack;
      if PatientList.Count = 0 then
        stPtList.Caption := 'No Patients Found on Selected Ward'
      else
        stPtList.Caption := TBCMA_Patients(PatientList[0]).fName;
      stPtList.BringToFront;
      stPtList.Show;
      edtWard.Text := '';
      if edtWard.CanFocus then
        edtWard.SetFocus;
      if stPtList.CanFocus then
        stPtList.SetFocus;
    end
    else begin
      lvwPtList.Hide;
      if PatientList.Count = 0 then
        pnlPatientList.Caption := 'No Patients Found on Selected Ward'
      else
        pnlPatientList.Caption := TBCMA_Patients(PatientList[0]).fName;
      //    frmMain.StatusBar.Panels[0].Text := '';
      //    exit;
    end;
  end
  else begin
    stPtList.TabStop := False; // rpk 9/8/2010
    // found patients
    if ScreenReaderSystemActive then begin
      stPtList.Caption := '';
      stPtList.Hide;
    end;
    PatientList.Sort(PtSelectSort);
    RefreshPtList;
  end;

  //  PatientList.Sort(PtSelectSort);
  //  RefreshPtList;
  frmMain.StatusBar.Panels[0].Text := '';
  frmMain.StatusBar.Repaint;

end; // tmrPtSelectTimer

procedure TfrmPrintPtSelect.VA508ComponentAccessibility1ItemQuery(
  Sender: TObject; var Item: TObject);
var
  i: Integer;
begin
  i := 100 * SelectedY + SelectedX;
  Item := TObject(i);
end;

procedure TfrmPrintPtSelect.VA508ComponentAccessibility1ValueQuery(
  Sender: TObject; var Text: string);
begin
  Text := ' Name ' + sgPtList.Cells[0, SelectedY] + ' ' +
    'Column ' + sgPtList.Cells[SelectedX, 0] + ', ' +
    sgPtList.Cells[SelectedX, SelectedY];
end;


procedure TfrmPrintPtSelect.FormCreate(Sender: TObject);
begin
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
end;

procedure TfrmPrintPtSelect.FormDestroy(Sender: TObject);
begin
  PatientList.Free;
end;

procedure TfrmPrintPtSelect.FormActivate(Sender: TObject);
begin
  //  edtPtName.SetFocus;
  if ScreenReaderSystemActive then begin
    if sgPtList.CanFocus then
      sgPtList.SetFocus
  end
  else begin
    if lvwPtList.CanFocus then
      lvwPtList.SetFocus;
  end;
end;

procedure TfrmPrintPtSelect.lvwPtListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  btnOK.Enabled := True;
end;

procedure TfrmPrintPtSelect.btnOKClick(Sender: TObject);
var
  idx, x: integer;
begin
  if ScreenReaderSystemActive then begin
    if sgPtList.RowCount < 2 then
      Exit;
  end
  else begin
    if lvwPtList.ItemIndex = -1 then
      exit;
  end;

  if ScreenReaderSystemActive then
    idx := sgPtList.Row - 1
  else
    idx := lvwPtList.ItemIndex;

  if idx >= 0 then begin
    BCMA_Report.ReportPatientList.Clear;
    if ScreenReaderSystemActive then begin
      for x := 0 to sgPtList.RowCount - 1 do begin
        if (sgPtList.Selection.Top <= x) and
          (x <= sgPtList.Selection.Bottom) and
          (Trim(sgPtList.Cells[1, x]) > '') then
          BCMA_Report.ReportPatientList.Add(TBCMA_Patients(PatientList[x -
            1]).FIEN);
      end;
    end
    else begin
      for x := 0 to lvwPtList.Items.Count - 1 do
        if lvwPtList.Items[x].Selected then
          BCMA_Report.ReportPatientList.Add(TBCMA_Patients(PatientList[x]).FIEN);
    end;

    //  if lvwPtList.ItemIndex = -1 then exit;

    //  BCMA_Patient.ScanPatient(TBCMA_Patients(PatientList[lvwPtList.ItemIndex]).fSSN, 1);
    //  if BCMA_Patient.IEN <> '' then modalResult := mrOK;
  end;

end;

procedure TfrmPrintPtSelect.edtWardKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  tmrPtSelect.Enabled := False;
//  if (Key <> 9) then
//    tmrPtSelect.Enabled := Length(edtWard.Text) >= 2;
end;

procedure TfrmPrintPtSelect.lvwPtListEnter(Sender: TObject);
begin
  with lvwPtList do
    if (ItemIndex = -1) and (items.Count > 0) then
      lvwPtList.ItemIndex := 0;
end;

procedure TfrmPrintPtSelect.lvwPtListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Ord('A')) and (ssCtrl in Shift) then begin
    TListView(Sender).SelectAll;
    Key := 0;
  end;
end;

procedure TfrmPrintPtSelect.LoadPatients(SearchString: string);
var
  MultList: TStringList;
  x: integer;
begin
  MultList := nil;
//  try
    MultList := TStringList.Create;
  try  // rpk 2/23/2012
    with MultList do begin
      Add('PTLKUP');
      Add(SearchString);
    end;
    ClearPatients;
    if (BCMA_Broker <> nil) then
      with BCMA_Broker do
        if CallServer('PSB MED LOG LOOKUP', ['~!#null#~!'], MultList) then begin
          if (Results.Count = 0) or (Results.Count - 1 <> StrToInt(Results[0]))
            then
            DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
          else if (piece(Results[1], '^', 1) = '-1') then
            with PatientList do begin
              add(TBCMA_Patients.Create(BCMA_Broker));
              with TBCMA_Patients(PatientList[PatientList.Count - 1]) do begin
                FIEN := '-1';
                FName := piece(Results[1], '^', 2);
              end;
            end
          else
            with PatientList do
              for x := 1 to Results.Count - 1 do
                //            begin
              {//if piece(Results[x], '^', 6) = edtWard.Text then}begin
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

procedure TfrmPrintPtSelect.ClearPatients;
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

procedure TfrmPrintPtSelect.lvwPtListColumnClick(Sender: TObject;
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

procedure TfrmPrintPtSelect.FormShow(Sender: TObject);
begin
  tmrPtSelect.Enabled := True;
  //  edtPtName.SetFocus;
  stPtList.Hide; // rpk 6/11/2010
  stPtList.TabStop := False; // rpk 9/21/2010

  if ScreenReaderSystemActive then begin
    // show string grid for screen reader
    lvwPtList.SendToBack;
    lvwPtList.Hide;
    lvwPtList.TabStop := False;
    sgInit(sgPtList, 1, PatientList.Count); // rpk 9/10/2010
    sgPtList.ColCount := 5;
    //      sgPtList.Rows[0].CommaText := 'Name, SSN, DOB, Rm-Bd, Ward';
    sgPtList.Rows[0].CommaText := 'Name, ' +
      BCMA_SiteParameters.PatientIDLabel + ', DOB, Rm-Bd, Ward';
    // rpk 6/9/2010
    sgPtList.Align := alClient;
    sgPtList.BringToFront;
    sgPtList.TabStop := True;
    sgPtList.Show;
    if sgPtList.CanFocus then
      sgPtList.SetFocus;
    sgPtList.Invalidate;
  end
  else begin
    // show listview for normal users
    sgPtList.SendToBack;
    sgPtList.TabStop := False;
    sgPtList.Hide;

    // do columns get cleared on listview clear?
    lvwPtList.Column[1].Caption := BCMA_SiteParameters.PatientIDLabel;
    // rpk 6/9/2010
    lvwPtList.Align := alClient;
    lvwPtList.BringToFront;
    lvwPtList.TabStop := True;
    lvwPtList.Show;
    if lvwPtList.CanFocus then
      lvwPtList.SetFocus;
    lvwPtList.Invalidate;
  end; // not ScreenReaderSystemActive

  Update;
  ForceForegroundWindow(handle)
end;

initialization
  SpecifyFormIsNotADialog(TfrmPrintPtSelect);

end.

