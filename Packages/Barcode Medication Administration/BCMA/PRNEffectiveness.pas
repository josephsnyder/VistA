unit PRNEffectiveness;
{
================================================================================
*	File:  PRNEffectiveness.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 21 $  $Modtime: 5/02/02 2:37p $
*	Description:  This is the form for logging a PRN Effectiveness for a PRN order.
*
*	Notes:
*
* NOTE: in order to view form, mVitals must be loaded before this form is opened.
*
*
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls,
  BCMA_Objects, BCMA_Util, Grids, mVitals, VA508AccessibilityManager,
  VA508AccessibilityRouter;

type
  TPRNListColumnTypes = (
    //													ltMedLogIEN, ltPatientIEN,
    ltLocation,
    ltDivision,
    ltAdministrationTime,
    ltAdministeredBy,
    ltReasonGiven
    );

const
  PRNListColumnTitles: array[TPRNListColumnTypes] of string =
  (
    //											'MedLogIEN', 'PatientIEN',
    'Location', 'Division',
    'Administration Time', 'Administered By', 'Reason Given'
    );

  PRNListColumnWidths: array[TPRNListColumnTypes] of integer =
  (
    //											35, 35,
    100, 100,
    150, 120, 150
    );

type
  TfrmPRNEffectiveness = class(TForm)
    pnlOrderInfo: TPanel;
    mmoSpecialInstructions: TMemo;
    pnlButton: TPanel;
    memAddComment: TMemo;
    btnExit: TButton;
    pnlPRNList: TPanel;
    lstDispensedDrugs: TListBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnMedHistory: TButton;
    lvwPRNList: TListView;
    fraVitals1: TfraVitals;
    grpPainScore: TGroupBox;
    cbxPainScore: TComboBox;
    edtDateTime: TEdit;
    grdPRNList: TStringGrid;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblPainScore: TLabel;
    lblDateTime: TLabel;
    lblDispensedDrug: TLabel;
    lblSpecInstructions: TLabel;
    lblAddComment: TLabel;
    lblPRNList: TLabel;
    lblUnitsGiven: TVA508StaticText;
    VA508ComponentAccessPRNList: TVA508ComponentAccessibility;
    VA508ComponentAccessVitals: TVA508ComponentAccessibility;
    lblActiveMedication: TVA508StaticText;
    lblSelectedAdministration: TLabel;
    pnlScrollDown: TPanel;
    lblScrollDown: TStaticText;
    btnDisplaySIOPI: TButton;
    procedure FormCreate(Sender: TObject);
    (*
      Allocates memory and initializes variables and parameters.
    *)

    procedure FormDestroy(Sender: TObject);
    (*
      Frees allocated memory.
    *)

    procedure FormShow(Sender: TObject);
    (*
      Loads readonly fields with properties from the current MedOrder.  Loads
      a list of the PRN orders that need effectiveness comments.  Sets focus
      to the PRN List.
    *)

    procedure pnlButtonResize(Sender: TObject);
    (*
      Resets the positions of the OK and Cancel buttons whenever the the form
      is resized, to ensure that they will always be visible.
    *)

    procedure btnOKClick(Sender: TObject);
    procedure memAddCommentKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnMedHistoryClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lvwPRNListColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvwPRNListDblClick(Sender: TObject);
    procedure lvwPRNListKeyPress(Sender: TObject; var Key: Char);
    procedure cbxPainScoreChange(Sender: TObject);
    procedure cbxPainScoreKeyPress(Sender: TObject; var Key: Char);
    procedure edtDateTimeExit(Sender: TObject);
    procedure lvwPRNListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure edtDateTimeChange(Sender: TObject);
    procedure grdPRNListDblClick(Sender: TObject);
    procedure grdPRNListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdPRNListClick(Sender: TObject);
    procedure grdPRNListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure VA508ComponentAccessPRNListItemQuery(Sender: TObject;
      var Item: TObject);
    procedure VA508ComponentAccessPRNListValueQuery(Sender: TObject;
      var Text: string);
    procedure VA508ComponentAccessVitalsItemQuery(Sender: TObject;
      var Item: TObject);
    procedure VA508ComponentAccessVitalsValueQuery(Sender: TObject;
      var Text: string);
    procedure fraVitals1grdVitalsSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure lvwPRNListEnter(Sender: TObject);
    procedure lstDispensedDrugsEnter(Sender: TObject);
    procedure fraVitals1Enter(Sender: TObject);
    procedure fraVitals1Exit(Sender: TObject);
    procedure mmoSpecialInstructionsEnter(Sender: TObject);
    procedure btnDisplaySIOPIClick(Sender: TObject);
    (*
      Checks that the Comment memo is not blank, then uses RPC
      'PSB TRANSACTION' to log the user input.
    *)

  private
    { Private declarations }
    procedure RefreshPRNList;
    //    function PRNListCompare(Item1, Item2: pointer): Integer;
    function SelectAdmin(Idx: Integer): Integer;

  public
    { Public declarations }
    MedOrder: TBCMA_MedOrder;           {Pointer to the current MedOrder}
    OrderPRNList: TStringList;          {Pointer to the current PRNList}

    procedure Execute(PatientMedOrder: TBCMA_MedOrder);
    (*
      Creates the form, retrieves the list of PRN's needing Effectiveness
      comments and shows the form modally.  Finally, the form is closed and
      memory is freed.
    *)

  end;

type
  TPRNSortType = (stAscending, stDescending);

var
  frmPRNEffectiveness: TfrmPRNEffectiveness;
  PRNSortCol: lstPRNListColumnTypes;
  PRNSortType: TPRNSortType;
  PainScoreMNowDateTime: string;

implementation
{$R *.DFM}

uses
  Math, BCMA_Startup, BCMA_Common,
//  MFunStr,
  BCMA_Main, ReportRequest;

var
  SelectedX, SelectedY: Integer;
  gIndex: Integer;

function PRNListCompare(Item1, Item2: pointer): Integer;
begin
  result := 1;

  case PRNSortCol of
    ctPRNActiveMedication:
      result := AnsiCompareStr(TBCMA_PRNEffectList(Item1).AdministeredDrug,
        TBCMA_PRNEffectList(Item2).AdministeredDrug);
    ctPRNUnitsGiven:
      result := AnsiCompareStr(TBCMA_PRNEffectList(Item1).UnitsGiven,
        TBCMA_PRNEffectList(Item2).UnitsGiven);
    ctPRNAdminTime:
      result := AnsiCompareStr(TBCMA_PRNEffectList(Item1).AdminDateTime,
        TBCMA_PRNEffectList(Item2).AdminDateTime);
    ctPRNReasonGiven:
      result := AnsiCompareStr(TBCMA_PRNEffectList(Item1).PRNReason,
        TBCMA_PRNEffectList(Item2).PRNReason);
    ctPRNAdministeredBy:
      result := AnsiCompareStr(TBCMA_PRNEffectList(Item1).AdministeredBy,
        TBCMA_PRNEffectList(Item2).AdministeredBy);
    ctPRNLocation:
      result := AnsiCompareStr(TBCMA_PRNEffectList(Item1).PatientLocation,
        TBCMA_PRNEffectList(Item2).PatientLocation);

  end;

  if PRNSortType = stDescending then begin
    if result = 1 then
      result := -1
    else if result = -1 then
      result := 1;
  end;

end;

procedure TfrmPRNEffectiveness.Execute(PatientMedOrder: TBCMA_MedOrder);
begin
  with TfrmPRNEffectiveness.create(application) do try
    MedOrder := PatientMedOrder;

    with BCMA_Patient do begin
      if MedOrder <> nil then
        LoadPRNEffectiveness(MedOrder.OrderNumber);

      if PRNEffectList.Count > 0 then
        ShowModal
      else
        DefMessageDlg('There are no PRN''s needing Effectivenesses!', mtError,
          [mbOK], 0);
    end;
  finally
//    free;
    Release;                            // rpk 6/18/2013
  end;
end;

procedure TfrmPRNEffectiveness.FormCreate(Sender: TObject);
var
  x: integer;
begin
  if isRestricted then begin
    lblPainScore.Enabled := False;
    cbxPainScore.Enabled := False;
    lblDateTime.Enabled := False;
    edtDateTime.Enabled := False;
    lblPRNList.Enabled := False;
    memAddComment.Enabled := False;
  end;

  OrderPRNList := TStringList.create;
  memAddComment.clear;
  gIndex := -1;                         // rpk 3/16/2012

  with cbxPainScore do begin
    AddItem('0 - No Pain', ptr(0));
    AddItem('1 - Slightly Uncomfortable', ptr(1));
    for x := 2 to 9 do
      AddItem(IntToStr(x), ptr(x));
    AddItem('10 - Worst Imaginable', ptr(10));
    AddItem('99 - Unable to Respond', ptr(99));
  end;
//  InitPainScore(cbxPainScore.Items);  // rpk 6/11/2012

  fraVitals1.LoadVitals;
end;

procedure TfrmPRNEffectiveness.FormShow(Sender: TObject);
begin
  PRNSortCol := ctPRNAdminTime;
  PRNSortType := stDescending;

  if OrderMode = omInpatient then       // rpk 5/8/2013
    HelpContext := 51                   // rpk 5/8/2013
  else                                  // rpk 5/8/2013
    HelpContext := 237;                 // last action and PRN / Effectiveness for clinic orders, rpk 5/8/2013

  if ScreenReaderSystemActive then begin // rpk 8/9/2010
    lblPRNList.FocusControl := grdPRNList;
    grdPRNList.TabStop := True;
    lvwPRNList.TabStop := False;
  end
  else begin
    lblPRNList.FocusControl := lvwPRNList;
    lvwPRNList.TabStop := True;
    grdPRNList.TabStop := False;
  end;

  RefreshPRNList;
end;                                    // FormShow

procedure TfrmPRNEffectiveness.fraVitals1Enter(Sender: TObject);
begin
  fraVitals1.FrameEnter(Sender);
end;

procedure TfrmPRNEffectiveness.fraVitals1Exit(Sender: TObject);
begin
//  with mmoSpecialInstructions do begin
//    if CanFocus then
//      SetFocus;
//  end;
end;

procedure TfrmPRNEffectiveness.fraVitals1grdVitalsSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  fraVitals1.SelectedVX := ACol;
  fraVitals1.SelectedVY := ARow;
end;

// moved code from lvwPRNlistSelectItem; RowNum is base 0

function TfrmPRNEffectiveness.SelectAdmin(Idx: Integer): Integer;
var
  x: integer;
  zDatetime: string;
begin
  Result := -1;

  if (Idx < 0) or (Idx >= BCMA_Patient.PRNEffectList.Count) then
    exit;

  // for use by btnSIOPIClick
  gIndex := Idx;                        // rpk 3/16/2012

  if not IsRestricted then begin
    btnCancel.Enabled := True;
    memAddComment.enabled := True;
  end;

  btnMedHistory.Enabled := True;
  memAddComment.Clear;

  with TBCMA_PRNEffectList(BCMA_Patient.PRNEffectList.Items[Idx]) do begin
//    mmoSpecialInstructions.Text := SpecialInstructions;
    SetSIOPIMemo(mmoSpecialInstructions); // rpk 1/6/2012
    mmoSpecialInstructions.SelStart := 0; // rpk 8/31/2010
    pnlScrollDown.Visible := mmoSpecialInstructions.Lines.Count > 6; // 3/14/2012

    lblActiveMedication.caption := 'Active Medication: ' + AdministeredDrug + ' '; // rpk 7/28/2010
    if not IsRestricted then begin
      cbxPainScore.Enabled := (RequirePainScore = 1);
      edtDateTime.Enabled := (RequirePainScore = 1);
    end;
    edtDateTime.Clear;
    cbxPainScore.ItemIndex := -1;
    lstDispensedDrugs.Clear;
    PainScoreMNowDateTime := '';
    for x := 0 to DispensedDrugs.Count - 1 do
      lstDispensedDrugs.AddItem(piece(DispensedDrugs[x], '^', 2), nil);
    for x := 0 to Additives.count - 1 do
      lstDispensedDrugs.AddItem(piece(Additives[x], '^', 2), nil);
    for x := 0 to Solutions.count - 1 do
      lstDispensedDrugs.AddItem(piece(Solutions[x], '^', 2), nil);
    if RequirePainScore = 1 then begin
      Repaint;
      zDateTime := 'N';
      PainScoreMNowDateTime := ValidMDateTime(zDateTime);
      edtDateTime.Text := zDateTime;
//      lblMaxChar.Caption := '(80 Characters Maximum)';
      // rpk 9/9/2010
      lblAddComment.Caption := 'Enter a PRN Effectiveness Co&mment: (80 Characters Maximum)';
      memAddComment.MaxLength := 80;
    end
    else begin
//      lblMaxChar.Caption := '(150 Characters Maximum)';
      // rpk 9/9/2010
      lblAddComment.Caption := 'Enter a PRN Effectiveness Co&mment: (150 Characters Maximum)';
      memAddComment.MaxLength := 150;
    end;
  end;

  Result := 1;

end;                                    // SelectAdmin

procedure TfrmPRNEffectiveness.VA508ComponentAccessVitalsItemQuery(
  Sender: TObject; var Item: TObject);
//var
//  i, j: Integer;
begin
  //  j := Integer(Item);
  //  i := 100 * SelectedY + SelectedX;
  //  Item := TObject(i);
end;

procedure TfrmPRNEffectiveness.VA508ComponentAccessVitalsValueQuery(
  Sender: TObject; var Text: string);
begin
  Text := 'Vital ' + fraVitals1.grdVitals.Cells[0, fraVitals1.SelectedVY] + ', '
    +
    'Column ' + fraVitals1.grdVitals.Cells[fraVitals1.SelectedVX, 0] + ', ' +
    fraVitals1.grdVitals.Cells[fraVitals1.SelectedVX, fraVitals1.SelectedVY];
end;

procedure TfrmPRNEffectiveness.VA508ComponentAccessPRNListItemQuery(
  Sender: TObject; var Item: TObject);
//var
//  i, j: Integer;
begin
  //  j := Integer(Item);
  //  i := 100 * SelectedY + SelectedX;
  //  Item := TObject(i);
end;

procedure TfrmPRNEffectiveness.VA508ComponentAccessPRNListValueQuery(
  Sender: TObject; var Text: string);
begin
  Text := ' Orderable Item ' + grdPRNList.Cells[0, SelectedY] + ' ' +
    'Column ' + grdPRNList.Cells[SelectedX, 0] + ', ' +
    grdPRNList.Cells[SelectedX, SelectedY];
end;

procedure TfrmPRNEffectiveness.grdPRNListClick(Sender: TObject);
var
  iret: Integer;
begin
  if grdPRNList.Tag = 0 then
    exit;

  if (grdPRNList.Row < 1) then begin
    btnOK.Enabled := False;
    btnMedHistory.Enabled := False;
    btnCancel.Enabled := False;
    mmoSpecialInstructions.Clear;
    lblActiveMedication.caption := 'Active Medication:';
    lstDispensedDrugs.Clear;
    memAddComment.Clear;
    memAddComment.enabled := False;
    Exit;
  end;

  iret := SelectAdmin(grdPRNList.Row - 1);

end;                                    // grdPRNListClick

procedure TfrmPRNEffectiveness.grdPRNListDblClick(Sender: TObject);
begin
  //  if grdPRNList.SelCount <> 0 then
  if (grdPRNList.Row > 0) and (grdPRNList.Row <= grdPRNList.RowCount) then
    with BCMA_Patient do
      with TBCMA_PRNEffectList(PRNEffectList.Items[grdPRNList.Row - 1]) do
        DisplayOrder(IEN, OrderNumber);
end;

procedure TfrmPRNEffectiveness.grdPRNListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    grdPRNListDblClick(grdPRNList);
end;

procedure TfrmPRNEffectiveness.grdPRNListSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  SelectedX := ACol;
  SelectedY := ARow;
end;

procedure TfrmPRNEffectiveness.btnOKClick(Sender: TObject);
var
  //  MedLogIEN,
  cmdString, PainInfo: string;
  MultList: TStringList;
begin
  if ScreenReaderSystemActive then begin
    if (grdPRNList.Row < 1) or (grdPRNList.RowCount = 1) or
      (BCMA_Patient.PRNEffectList.Count < 1) then
      exit;

    if (TrimLeft(memAddComment.Text) = '') and
      (TBCMA_PRNEffectList(BCMA_Patient.PRNEffectList.Items[grdPRNList.Row -
      1]).RequirePainScore <> 1) then begin
      DefMessageDlg('You Must Enter a Comment!', mtError, [mbOK], 0);
      memAddComment.setFocus;
    end
    else begin
      cmdString :=
        IntToStr(Integer(grdPRNList.Objects[0, grdPRNList.Row - 1])) +
        '^PRN EFFECTIVENESS';
      if TBCMA_PRNEffectList(BCMA_Patient.PRNEffectList.Items[grdPRNList.Row -
        1]).RequirePainScore = 1 then begin
        PainInfo := 'Pain Score of ' +
          IntToStr(Integer(cbxPainScore.Items.Objects[cbxPainScore.ItemIndex]))
          +
          ' entered into Vitals via BCMA at ' +
          FormatFMDateTime('MM/DD/YYYY@HH:NN',
          StrToFloat(PainScoreMNowDateTime));
        if StripString(memAddComment.Text, False) <> '' then
          PainInfo := ' - ' + PainInfo;
      end;

      MultList := TStringList.create;
      with MultList do try
        add(StripString(memAddComment.Text + PainInfo));
        with BCMA_Broker do
          if CallServer('PSB TRANSACTION', [cmdString + '^' +
            BCMA_User.InstructorDUZ], MultList) then
            if piece(results[0], '^', 1) = '-1' then
              DefMessageDlg(piece(results[0], '^', 2), mtError, [mbOK], 0)
            else
              with BCMA_Patient do begin
                TBCMA_PRNEffectList(PRNEffectList.Items[grdPRNList.Row -
                  1]).Free;
                // keep RowCount at minimum of 2 to allow for FixedRows = 1
//                if grdPRNList.RowCount < 3 then  // rpk 9/13/2010
//                  grdPRNList.RowCount := 3;
                PRNEffectList.Delete(grdPRNList.Row - 1);
              end;

      finally
        free;
      end;
    end                                 // have comment; do update
  end
  else begin                            // not screen reader
    if lvwPRNList.SelCount = 0 then
      exit;
    if (TrimLeft(memAddComment.Text) = '') and
      (TBCMA_PRNEffectList(BCMA_Patient.PRNEffectList.Items[lvwPRNList.ItemIndex]).RequirePainScore <> 1) then begin
      DefMessageDlg('You Must Enter a Comment!', mtError, [mbOK], 0);
      memAddComment.setFocus;
    end
    else begin                          // have a comment
      cmdString :=
        IntToStr(Integer(lvwPRNList.Items[lvwPRNList.Selected.index].data)) +
        '^PRN EFFECTIVENESS';
      if
        TBCMA_PRNEffectList(BCMA_Patient.PRNEffectList.Items[lvwPRNList.ItemIndex]).RequirePainScore = 1 then begin
        PainInfo := 'Pain Score of ' +
          IntToStr(Integer(cbxPainScore.Items.Objects[cbxPainScore.ItemIndex]))
          +
          ' entered into Vitals via BCMA at ' +
          FormatFMDateTime('MM/DD/YYYY@HH:NN',
          StrToFloat(PainScoreMNowDateTime));
        if StripString(memAddComment.Text, False) <> '' then
          PainInfo := ' - ' + PainInfo;
      end;

      MultList := TStringList.create;
      with MultList do try
        add(StripString(memAddComment.Text + PainInfo));
        with BCMA_Broker do
          if CallServer('PSB TRANSACTION', [cmdString + '^' +
            BCMA_User.InstructorDUZ], MultList) then
            if piece(results[0], '^', 1) = '-1' then
              DefMessageDlg(piece(results[0], '^', 2), mtError, [mbOK], 0)
            else
              with BCMA_Patient do begin
                TBCMA_PRNEffectList(PRNEffectList.Items[lvwPRNList.Selected.index]).Free;
                PRNEffectList.Delete(lvwPRNList.Selected.Index);
              end;

      finally
        free;
      end;
    end;
  end;

  if cbxPainScore.ItemIndex <> -1 then
    SendVitals(IntToStr(Integer(cbxPainScore.Items.Objects[cbxPainScore.ItemIndex])),
      PainScoreMNowDateTime);

  RefreshPRNList;
  cbxPainScore.ItemIndex := -1;
  cbxPainScore.Enabled := False;
  edtDateTime.Enabled := False;
  edtDateTime.Clear;
end;                                    // btnOKClick

procedure TfrmPRNEffectiveness.FormDestroy(Sender: TObject);
begin
  OrderPRNList.free;
  fraVitals1.Free;                      // rpk 6/16/2010
end;

procedure TfrmPRNEffectiveness.pnlButtonResize(Sender: TObject);
begin
  //  btnOK.Width := btnCancel.Width;
  //  btnCancel.Left := pnlButton.ClientWidth -
  //    (btnCancel.Width + self.BorderWidth * 2);
  //  btnOK.Left := btnCancel.Left - (btnOK.Width + self.BorderWidth);
end;

procedure TfrmPRNEffectiveness.RefreshPRNList;
var
  x, iret: integer;
begin
  btnOK.Enabled := False;
  btnMedHistory.Enabled := False;
  btnCancel.Enabled := False;
  lvwPRNList.tag := 0;
  //
  // make sure objects are freed first
  //
  // NOTE: don't use sgFree.  objects are not allocated;
  // object address is set to simple integer
  //  sgFree(-1, -1, grdPRNList);
  sgClear(grdPRNList);
  lvwPRNList.Clear;
  grdPRNList.tag := 0;
//  grdPRNList.FixedRows := 1;
//  grdPRNList.RowCount := grdPRNList.FixedRows;
//  SelectedX := 1;
//  SelectedY := 1;
  mmoSpecialInstructions.Clear;
  pnlScrollDown.Hide;                   // rpk 3/16/2012
  gIndex := -1;                         // rpk 3/16/2012

  lblActiveMedication.caption := 'Active Medication:';
  lstDispensedDrugs.Clear;
  memAddComment.Clear;
  memAddComment.enabled := False;

  fraVitals1.RefreshVitals;             // rpk 7/2/2010

  with BCMA_Patient do begin
    if ScreenReaderSystemActive then begin
      ActiveControl := grdPRNList;
      with grdPRNList do begin
        Align := alClient;
        Colwidths[0] := 125;            // rpk 10/8/2009
        Colwidths[1] := 75;             // rpk 10/8/2009
        Colwidths[2] := 100;            // rpk 10/8/2009
        Colwidths[3] := 75;             // rpk 10/8/2009
        Colwidths[4] := 100;            // rpk 10/8/2009
        Colwidths[5] := Width - (Colwidths[0] + Colwidths[1] + Colwidths[2] +
          Colwidths[3] + Colwidths[4]);
      end;
      lvwPRNList.Hide;
      lvwPRNList.SendToBack;
      grdPRNList.BringToFront;
      grdPRNList.Show;
//      grdPRNList.RowCount := PRNEffectList.Count + 1;
//      if PRNEffectList.Count > 0 then begin // rpk 9/9/2010
//        grdPRNList.RowCount := PRNEffectList.Count + 1;
//      end
//      else
//        grdPRNList.RowCount := 2;
//      grdPRNList.FixedRows := 1;
      sgInit(grdPRNList, 1, PRNEffectList.Count); // 9/10/2010
      grdPRNList.Rows[0].CommaText :=
        '"Orderable Item", "Units Given", "Administration Time", "Reason Given", "Administered By", Location';
      for x := 0 to PRNEffectList.Count - 1 do begin
        with TBCMA_PRNEffectList(PRNEffectList.Items[x]) do begin
          //          grdPRNList.Row := x + 1;
          grdPRNList.Rows[x + 1].CommaText :=
            '"' + AdministeredDrug + '", "' +
            UnitsGiven + '", "' +
            DisplayVADateYearTime(AdminDateTime) + '", "' +
            PRNReason + '", "' +
            AdministeredBy + '", "' +
            PatientLocation + '"';
          grdPRNList.Objects[0, x] := Ptr(StrToInt(MedLogIEN));
        end;
      end;
      grdPRNList.Tag := 1;
      grdPRNList.Invalidate;
    end
    else begin
      ActiveControl := lvwPRNList;
      grdPRNList.Hide;
      grdPRNList.SendToBack;
      lvwPRNList.BringToFront;
      lvwPRNList.Show;
      for x := 0 to PRNEffectList.Count - 1 do begin
        with TBCMA_PRNEffectList(PRNEffectList.Items[x]) do
          lvwPRNList.AddItem(AdministeredDrug, Ptr(StrToInt(MedLogIEN)));
        lvwPRNList.Items[x].SubItems.Add(TBCMA_PRNEffectList(PRNEffectList.Items[x]).UnitsGiven);
        lvwPRNList.Items[x].SubItems.Add(DisplayVADateYearTime(TBCMA_PRNEffectList(PRNEffectList.Items[x]).AdminDateTime));
        lvwPRNList.Items[x].SubItems.Add(TBCMA_PRNEffectList(PRNEffectList.Items[x]).PRNReason);
        lvwPRNList.Items[x].SubItems.Add(TBCMA_PRNEffectList(PRNEffectList.Items[x]).AdministeredBy);
        lvwPRNList.Items[x].SubItems.Add(TBCMA_PRNEffectList(PRNEffectList.Items[x]).PatientLocation);
      end;
      lvwPRNList.tag := 1;
      lvwPRNList.Invalidate;
    end;
    if PRNEffectList.Count > 0 then
      iret := SelectAdmin(0);
  end;

end;                                    // RefreshPRNList

procedure TfrmPRNEffectiveness.memAddCommentKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ((memAddComment.Text = '') and (cbxPainScore.Enabled = False) or
    ((cbxPainScore.enabled = true) and
    ((cbxPainScore.ItemIndex = -1) or (edtDateTime.text = '')))) then
    btnOK.Enabled := False
  else
    btnOK.Enabled := True;
end;

procedure TfrmPRNEffectiveness.mmoSpecialInstructionsEnter(Sender: TObject);
begin
  GetScreenReader.Speak(mmoSpecialInstructions.text); // rpk 9/7/2010
end;

procedure TfrmPRNEffectiveness.btnDisplaySIOPIClick(Sender: TObject);
begin
  if (gIndex > -1) and (gIndex < BCMA_Patient.PRNEffectList.Count) then begin
    with TBCMA_PRNEffectList(BCMA_Patient.PRNEffectList.Items[gIndex]) do begin
      DisplayMemoList('Special Instructions / Other Print Info:',
        SpecialInstructions, SIOPIList, False);
    end;
  end;
end;

procedure TfrmPRNEffectiveness.btnMedHistoryClick(Sender: TObject);
begin
  if ScreenReaderSystemActive then begin
    if grdPRNList.Row > 0 then
      with BCMA_Patient do
        with TBCMA_PRNEffectList(PRNEffectList.Items[grdPRNList.Row - 1]) do
          MedicationHistoryReport(BCMA_Patient.IEN, OrderableItemIEN,
            OrderNumber);
  end
  else begin
    if lvwPRNList.SelCount <> 0 then
      with BCMA_Patient do
        with TBCMA_PRNEffectList(PRNEffectList.Items[lvwPRNList.Selected.index])
          do
          MedicationHistoryReport(BCMA_Patient.IEN, OrderableItemIEN,
            OrderNumber);
  end;

end;

procedure TfrmPRNEffectiveness.btnCancelClick(Sender: TObject);
begin
  RefreshPRNList;
  cbxPainScore.ItemIndex := -1;
  cbxPainScore.Enabled := False;

  edtDateTime.Enabled := False;
  edtDateTime.Clear;

  if ScreenReaderSystemActive then begin
    if grdPRNList.CanFocus then
      grdPRNList.SetFocus
  end
  else begin
    if lvwPRNList.CanFocus then
      lvwPRNList.setfocus;
  end;
end;

procedure TfrmPRNEffectiveness.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  msg: string;
begin
  msg := 'The documentation for the selected administration is incomplete and will '
    +
    'not be saved!' + #13#13 +
    'Click OK to close without saving or click the Cancel button to return to the PRN Effectiveness Log.';

  if ((memAddComment.Text <> '') or (cbxPainScore.ItemIndex <> -1)) then
    if DefMessageDlg(msg, mtWarning, [mbOK, mbCancel], 0) = idCancel then
      CanClose := False;
end;

procedure TfrmPRNEffectiveness.lstDispensedDrugsEnter(Sender: TObject);
begin
  with lstDispensedDrugs do begin
    if (ItemIndex < 0) and (Items.Count > 0) then
      ItemIndex := 0;
  end;
end;

procedure TfrmPRNEffectiveness.lvwPRNListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if lstPRNListColumnTypes(Column.Index) = PRNSortCol then
    if PRNSortType = stAscending then
      PRNSortType := stDescending
    else if PRNSortType = stDescending then
      PRNSortType := stAscending;

  PRNSortCol := lstPRNListColumnTypes(Column.Index);

  BCMA_Patient.PRNEffectList.Sort(PRNListCompare);
  RefreshPRNList;
end;                                    // lvwPRNListColumnClick

procedure TfrmPRNEffectiveness.lvwPRNListDblClick(Sender: TObject);
begin
  if lvwPRNList.SelCount <> 0 then
    with BCMA_Patient do
      with TBCMA_PRNEffectList(PRNEffectList.Items[lvwPRNList.Selected.index])
        do
        DisplayOrder(IEN, OrderNumber);
end;

procedure TfrmPRNEffectiveness.lvwPRNListEnter(Sender: TObject);
begin
  if (lvwPRNList.Selected = nil) and (lvwPRNList.Items[0] <> nil) then
    lvwPRNList.Selected := lvwPRNList.Items[0];
end;

procedure TfrmPRNEffectiveness.lvwPRNListKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = chr(VK_RETURN) then
    lvwPRNListDblClick(lvwPRNList);
end;

procedure TfrmPRNEffectiveness.cbxPainScoreChange(Sender: TObject);
begin
  if isRestricted or (edtDateTime.text = '') or ((cbxPainScore.Enabled = True)
    and (cbxPainScore.ItemIndex = -1)) then
    btnOK.Enabled := False
  else
    btnOK.Enabled := True;
end;

procedure TfrmPRNEffectiveness.cbxPainScoreKeyPress(Sender: TObject;
  var Key: Char);
begin
  //Prevent a backspace.  Apparently under W2K, a backspace will set
  //itemindex to -1.
  if Key = #8 then
    Key := #0;
end;

procedure TfrmPRNEffectiveness.edtDateTimeExit(Sender: TObject);
var
  ss,
    MActionDateTime,
    NowMDateTime,
    zNow: string;
  idx: Integer;
begin
  if edtDateTime.text <> '' then begin
    ss := edtDateTime.text;

    MActionDateTime := ValidMDateTime(ss);
    PainScoreMNowDateTime := MActionDateTime;
    zNow := 'N';
    if edtDateTime.text <> zNow then
      NowMDateTime := ValidMDateTime(zNow);

    if NowMDateTime = '' then
      NowMDateTime := MActionDateTIme;

    if MActionDateTime <> '' then begin
      if StrToFloat(MActionDateTime) > StrToFloat(NowMDateTime) then begin
        DefMessageDlg('The action date and time can''t be in the future.',
          mtError, [mbOk], 0);
        edtDateTime.setFocus;
        exit;
      end;

      if ScreenReaderSystemActive then
        idx := grdPRNList.Row - 1
      else
        idx := lvwPRNList.ItemIndex;

      //      if StrToFloat(MActionDateTime) <
      //        StrToFloat(TBCMA_PRNEffectList(BCMA_Patient.PRNEffectList.Items[lvwPRNList.ItemIndex]).AdminDateTime) then
      if (idx > -1) and                 // rpk 9/24/2010
        (StrToFloat(MActionDateTime) <
        StrToFloat(TBCMA_PRNEffectList(BCMA_Patient.PRNEffectList.Items[idx]).AdminDateTime)) then begin
        DefMessageDlg('The action date and time can''t be prior to the administration date and time.', mtError,
          [mbOk], 0);
        edtDateTime.setFocus;
        exit;
      end;

      edtDateTime.text := ss;
    end
    else
      edtDateTime.setFocus;
  end;
end;

procedure TfrmPRNEffectiveness.lvwPRNListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  //  x: Integer;
  iret: integer;
  //  zDatetime: string;
begin
  if lvwPRNList.tag = 0 then
    exit;

  if lvwPRNList.SelCount = 0 then begin
    btnOK.Enabled := False;
    btnMedHistory.Enabled := False;
    btnCancel.Enabled := False;
    mmoSpecialInstructions.Clear;
    lblActiveMedication.caption := 'Active Medication:';
    lstDispensedDrugs.Clear;
    memAddComment.Clear;
    memAddComment.enabled := False;
    Exit;
  end;

  iret := SelectAdmin(Item.Index);

end;

procedure TfrmPRNEffectiveness.edtDateTimeChange(Sender: TObject);
begin
  if isRestricted or (edtDateTime.Text = '') or ((cbxPainScore.Enabled = True)
    and (cbxPainScore.ItemIndex = -1)) then
    btnOK.Enabled := False
  else
    btnOK.Enabled := True;
end;

end.
