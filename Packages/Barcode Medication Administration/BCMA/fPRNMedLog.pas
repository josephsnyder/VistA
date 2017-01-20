unit fPRNMedLog;

//
// NOTE: in order to view form, mVitals must be loaded before this form is opened.
//

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, BCMA_Objects, BCMA_Common, BCMA_Util,
  mVitals, Grids, VA508AccessibilityManager, VA508AccessibilityRouter;

type
  TfrmPRNMedLog = class(TForm)
    pnlData: TPanel;
    memSpecialInstructions: TMemo;
    lstDispensedDrugs: TListBox;
    fraVitals1: TfraVitals;
    cbxPainScore: TComboBox;
    bvlLine1: TBevel;
    grpAcknowledge: TGroupBox;
    imgIcon: TImage;
    chkAck: TCheckBox;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblUnitsGivenMessage: TVA508StaticText;
    lblScheduleCaption: TLabel;
    lblLastActionCaption: TLabel;
    lblActiveMed: TLabel;
    lblDispensedDrug: TLabel;
    lblSpecialInstructions: TLabel;
    lblSelectReason: TLabel;
    lblPainScore: TLabel;
    VA508ComponentAccessLFA: TVA508ComponentAccessibility;
    pnlLastFourActions: TPanel;
    lvwLastFourActions: TListView;
    grdLastFourActions: TStringGrid;
    lblLastFourActions: TLabel;
    lblActiveMedicationName: TVA508StaticText;
    VA508ComponentAccessVitals: TVA508ComponentAccessibility;
    btnOK: TButton;
    btnCancel: TButton;
    btnMedHistory: TButton;
    cbxReason: TComboBox;
    lblSchedule: TVA508StaticText;
    lblLastActionSinceLast: TVA508StaticText;
    lblLastActionDateTime: TVA508StaticText;
    pnlScrollDown: TPanel;
    lblScrollDown: TStaticText;
    btnDisplaySIOPI: TButton;
    procedure FormShow(Sender: TObject);
    procedure cbxReason_OldChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnMedHistoryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxPainScoreChange(Sender: TObject);
    procedure cbxReason_OldKeyPress(Sender: TObject; var Key: Char);
    procedure cbxPainScoreKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure VA508ComponentAccessLFAItemQuery(Sender: TObject;
      var Item: TObject);
    procedure grdLastFourActionsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure VA508ComponentAccessLFAValueQuery(Sender: TObject;
      var Text: string);
    procedure fraVitals1grdVitalsSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure VA508ComponentAccessVitalsValueQuery(Sender: TObject;
      var Text: string);
    procedure VA508ComponentAccessVitalsItemQuery(Sender: TObject;
      var Item: TObject);
    procedure lvwLastFourActionsEnter(Sender: TObject);
    procedure cbxPainScoreExit(Sender: TObject);
    procedure fraVitals1Enter(Sender: TObject);
    procedure fraVitals1Exit(Sender: TObject);
    procedure grdLastFourActionsEnter(Sender: TObject);
    procedure memSpecialInstructionsEnter(Sender: TObject);
    procedure cbxReasonKeyPress(Sender: TObject; var Key: Char);
    procedure cbxReasonChange(Sender: TObject);
    procedure cbxReasonEnter(Sender: TObject);
    procedure cbxPainScoreEnter(Sender: TObject);
    procedure btnDisplaySIOPIClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MedOrder: TBCMA_MedOrder;
  end;

var
  frmPRNMedLog: TfrmPRNMedLog;

implementation

{$R *.dfm}

uses BCMA_main, ReportRequest;
//MFunStr;

var
  SelectedX, SelectedY: Integer;

procedure TfrmPRNMedLog.FormShow(Sender: TObject);
var
  x: integer;
begin
  fraVitals1.RefreshVitals; // rpk 7/2/2010

  if OrderMode = omInpatient then  // rpk 5/8/2013
    HelpContext := 44  // rpk 5/8/2013
  else  // rpk 5/8/2013
    HelpContext := 237;  // rpk 5/8/2013

  with MedOrder do
  begin
    lblActiveMedicationName.Caption := ActiveMedication;
//    memSpecialInstructions.text := SpecialInstructions;
    SetSIOPIMemo(memSpecialInstructions);  // rpk 1/6/2012
    memSpecialInstructions.SelStart := 0;  // rpk 8/31/2010
    pnlScrollDown.Visible := memSpecialInstructions.Lines.Count > 6;  // 3/12/2012

    with BCMA_SiteParameters do
      for x := 0 to ListReasonsGivenPRN.Count - 1 do
        cbxReason.AddItem(piece(ListReasonsGivenPRN[x], '|', 1),
          ptr(StrToInt(piece(ListReasonsGivenPRN[x], '|', 2))));
    //cbxReason.Items.Assign(BCMA_SiteParameters.ListReasonsGivenPRN);

    with cbxPainScore do
    begin
      AddItem('0 - No Pain', ptr(0));
      AddItem('1 - Slightly Uncomfortable', ptr(1));
      for x := 2 to 9 do
        AddItem(IntToStr(x), ptr(x));
      AddItem('10 - Worst Imaginable', ptr(10));
      AddItem('99 - Unable to Respond', ptr(99));
    end;

//    InitPainScore(cbxPainScore.Items);  // rpk 6/11/2012

    if OrderTypeID = otUnitDose then
      lstDispensedDrugs.items.Assign(OrderedDrugNames)
    else
    begin
      for x := 0 to Additives.Count - 1 do
        lstDispensedDrugs.AddItem(piece(Additives[x], '^', 3) + ' ' +
          piece(Additives[x], '^', 4), nil);
      for x := 0 to Solutions.Count - 1 do
        lstDispensedDrugs.AddItem('  ' + piece(Solutions[x], '^', 3) + ' ' +
          piece(Solutions[x], '^', 4), nil);
    end;

    if ScreenReaderSystemActive then
    begin
      lblLastFourActions.FocusControl := grdLastFourActions;
      with grdLastFourActions do
      begin
        Align := alClient;
        Colwidths[0] := 125; // rpk 10/8/2009
        Colwidths[1] := 75; // rpk 10/8/2009
        Colwidths[2] := 75; // rpk 10/8/2009
        Colwidths[3] := 75; // rpk 10/8/2009
        Colwidths[4] := Width - (Colwidths[0] + Colwidths[1] + Colwidths[2] +
          Colwidths[3]);
      end;
      grdLastFourActions.BringToFront;
      grdLastFourActions.Show;
      lvwLastFourActions.Hide;
      lvwLastFourActions.SendToBack;
//      grdLastFourActions.RowCount := LastFourActions.Count + 2;
//      grdLastFourActions.FixedRows := 1; // rpk 9/1/2010
      sgInit(grdLastFourActions, 1, LastFourActions.Count);  // rpk 9/10/2010
      grdLastFourActions.Rows[0].CommaText :=
        'Date/Time, Action, Type, Reason, "Units Given"';
      for x := 0 to LastFourActions.Count - 1 do
      begin
        grdLastFourActions.Rows[x + 1].CommaText :=
          '"' + DisplayVADateYearTime(piece(LastFourActions.Strings[x], '^', 1))
          + '", "'
          +
          piece(LastFourActions.Strings[x], '^', 2) + '", "' +
          piece(LastFourActions.Strings[x], '^', 3) + '", "' +
          piece(LastFourActions.Strings[x], '^', 4) + '", "' +
          piece(LastFourActions.Strings[x], '^', 6) + '"';
      end;
      lblSchedule.TabStop := True;
      lblLastActionSinceLast.TabStop := True;
      lblLastActionDateTime.TabStop := True;
      grdLastFourActions.Invalidate;
    end
    else
    begin
      lblLastFourActions.FocusControl := lvwLastFourActions;
      lvwLastFourActions.Align := alClient;
      lvwLastFourActions.BringToFront;
      lvwLastFourActions.Show;
      grdLastFourActions.Hide;
      grdLastFourActions.SendToBack;
      for x := 0 to LastFourActions.Count - 1 do
      begin
        lvwLastFourActions.AddItem(DisplayVADateYearTime(piece(LastFourActions.Strings[x], '^', 1)), nil);
        lvwLastFourActions.Items[x].SubItems.Add(piece(LastFourActions.Strings[x], '^', 2));
        lvwLastFourActions.Items[x].SubItems.Add(piece(LastFourActions.Strings[x], '^', 3));
        lvwLastFourActions.Items[x].SubItems.Add(piece(LastFourActions.Strings[x], '^', 4));
        //if piece(LastFourActions.Strings[x], '^' , 7) <> '' then
        //  lvwLastFourActions.Items[x].SubItems.Add(piece(LastFourActions.Strings[x], '^' ,7))
        //else
        lvwLastFourActions.Items[x].SubItems.Add(piece(LastFourActions.Strings[x], '^', 6))
      end;
      lblSchedule.TabStop := False;
      lblLastActionSinceLast.TabStop := False;
      lblLastActionDateTime.TabStop := False;
      lvwLastFourActions.Invalidate;
    end; // else not screen reader

    imgIcon.Picture.Icon.Handle := LoadIcon(0, IconArray[2]);
    lblSchedule.Caption := Schedule;
    if LastGivenDateTime <> '' then
    begin
      lblLastActionSinceLast.Caption := DaysHoursMinutesPast(LastGivenDateTime)
        +
        ' ago on';
      lblLastActionDateTime.Caption := DisplayVADateYearTime(LastGivenDateTime);
    end
    else
    begin
      lblLastActionSinceLast.Caption := '';
      lblLastActionDateTime.Caption := '';
    end;

  end;

  VA508AccessibilityManager1.RefreshComponents; // rpk 9/28/2010
  
end;

procedure TfrmPRNMedLog.fraVitals1Enter(Sender: TObject);
begin
  fraVitals1.FrameEnter(Sender);
end;

procedure TfrmPRNMedLog.fraVitals1Exit(Sender: TObject);
begin
//  with memSpecialInstructions do begin
//    if CanFocus then
//      SetFocus;
//  end;
end;

procedure TfrmPRNMedLog.fraVitals1grdVitalsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  fraVitals1.SelectedVX := ACol;
  fraVitals1.SelectedVY := ARow;
end;

procedure TfrmPRNMedLog.grdLastFourActionsEnter(Sender: TObject);
var
  CanSelect: Boolean;
begin
  with grdLastFourActions do
    grdLastFourActionsSelectCell(Sender, Col, Row, CanSelect);
end;

procedure TfrmPRNMedLog.grdLastFourActionsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  SelectedX := ACol;
  SelectedY := ARow;
end;

procedure TfrmPRNMedLog.lvwLastFourActionsEnter(Sender: TObject);
begin
  if (lvwLastFourActions.Selected = nil) and (lvwLastFourActions.Items[0] <> nil)
    then
    lvwLastFourActions.Selected := lvwLastFourActions.Items[0];
end;

procedure TfrmPRNMedLog.memSpecialInstructionsEnter(Sender: TObject);
begin
  GetScreenReader.Speak(memSpecialInstructions.text);  // rpk 9/7/2010
end;

procedure TfrmPRNMedLog.VA508ComponentAccessLFAItemQuery(Sender: TObject;
  var Item: TObject);
//var
//  i, j: Integer;
begin
  //  j := Integer(Item);
  //  i := 100 * SelectedY + SelectedX;
  //  Item := TObject(i);
end;

procedure TfrmPRNMedLog.VA508ComponentAccessLFAValueQuery(Sender: TObject;
  var Text: string);
begin
  Text := ' Date/Time ' + grdLastFourActions.Cells[0, SelectedY] + ' ' +
    'Column ' + grdLastFourActions.Cells[SelectedX, 0] + ', ' +
    grdLastFourActions.Cells[SelectedX, SelectedY];
end;

procedure TfrmPRNMedLog.VA508ComponentAccessVitalsItemQuery(Sender: TObject;
  var Item: TObject);
//var
//  i, j: Integer;
begin
  //  j := Integer(Item);
  //  i := 100 * fraVitals1.SelectedVY + fraVitals1.SelectedVX;
  //  Item := TObject(i);
end;

procedure TfrmPRNMedLog.VA508ComponentAccessVitalsValueQuery(Sender: TObject;
  var Text: string);
begin
  Text := 'Vital ' + fraVitals1.grdVitals.Cells[0, fraVitals1.SelectedVY] + ', '
    +
    'Column ' + fraVitals1.grdVitals.Cells[fraVitals1.SelectedVX, 0] + ', ' +
    fraVitals1.grdVitals.Cells[fraVitals1.SelectedVX, fraVitals1.SelectedVY];
end;

procedure TfrmPRNMedLog.cbxReasonChange(Sender: TObject);
begin
  cbxPainScore.ItemIndex := -1;
  if (Integer(cbxReason.Items.Objects[cbxReason.ItemIndex]) = 0) and
    (cbxReason.ItemIndex <> -1) then
  begin
    //btnOK.Enabled := True;
    cbxPainScore.Enabled := False
  end
  else
  begin
    cbxPainScore.Enabled := True;
    //btnOk.Enabled := False;
  end;
end;

procedure TfrmPRNMedLog.cbxReasonEnter(Sender: TObject);
begin
  GetScreenReader.Speak(lblSelectReason.Caption);  // rpk 5/5/2011
end;

procedure TfrmPRNMedLog.cbxReasonKeyPress(Sender: TObject; var Key: Char);
begin
  //Prevent a backspace.  Apparently under W2K, a backspace will set
  //itemindex to -1.
  if Key = #8 then
    Key := #0;
end;

procedure TfrmPRNMedLog.cbxReason_OldChange(Sender: TObject);
begin
  cbxPainScore.ItemIndex := -1;
  if (Integer(cbxReason.Items.Objects[cbxReason.ItemIndex]) = 0) and
    (cbxReason.ItemIndex <> -1) then
  begin
    //btnOK.Enabled := True;
    cbxPainScore.Enabled := False
  end
  else
  begin
    cbxPainScore.Enabled := True;
    //btnOk.Enabled := False;
  end;
end;

procedure TfrmPRNMedLog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrCancel then
  begin
    canClose := true;
    exit;
  end;

  if cbxReason.itemIndex = -1 then
  begin
    DefMessageDlg('You must select a reason!', mtInformation, [mbOK], 0);
    CanClose := False;
    exit;
  end;

  if cbxPainScore.Enabled and (cbxPainScore.itemIndex = -1) then
  begin
    DefMessageDlg('You must select a pain score!', mtInformation, [mbOK], 0);
    CanClose := False;
    exit;
  end;

  if not chkAck.Checked then
  begin
    DefMessageDlg('You must check the checkbox in order to complete the documentation of this administration', mtInformation, [mbOK], 0);
    CanClose := False;
    exit;
  end;

  //  canClose := (modalResult = mrCancel) or (cbxReason.itemIndex <> -1);
  if canClose = true then
    cmtReasonGivenPRN := cbxReason.Items[cbxReason.itemIndex];
end;

procedure TfrmPRNMedLog.btnDisplaySIOPIClick(Sender: TObject);
var
  tbool: Boolean;
begin
  if MedOrder <> nil then begin
    with Medorder do begin
      tbool := DisplaySIOPI(False); // rpk 11/09/2011
    end;
  end;
end;

procedure TfrmPRNMedLog.btnMedHistoryClick(Sender: TObject);
begin
  with MedOrder do
    MedicationHistoryReport(PatientIEN, OrderableItemIEN, OrderNumber);
end;

procedure TfrmPRNMedLog.FormCreate(Sender: TObject);
begin
  fraVitals1.LoadVitals;
  memSpecialInstructions.Clear;
end;

procedure TfrmPRNMedLog.FormDestroy(Sender: TObject);
begin
  fraVitals1.Free; // rpk 6/16/2010
end;

procedure TfrmPRNMedLog.cbxPainScoreChange(Sender: TObject);
begin
  if cbxPainScore.ItemIndex <> -1 then
    btnOk.Enabled := True;
end;

procedure TfrmPRNMedLog.cbxPainScoreEnter(Sender: TObject);
begin
  GetScreenReader.Speak(lblPainScore.Caption);  // rpk 5/5/2011
end;

procedure TfrmPRNMedLog.cbxPainScoreExit(Sender: TObject);
begin
//  btnOK.SetFocus;
end;

procedure TfrmPRNMedLog.cbxReason_OldKeyPress(Sender: TObject; var Key: Char);
begin
  //Prevent a backspace.  Apparently under W2K, a backspace will set
  //itemindex to -1.
  if Key = #8 then
    Key := #0;
end;

procedure TfrmPRNMedLog.cbxPainScoreKeyPress(Sender: TObject;
  var Key: Char);
begin
  //Prevent a backspace.  Apparently under W2K, a backspace will set
  //itemindex to -1.
  if Key = #8 then
    Key := #0;
end;

initialization
  SpecifyFormIsNotADialog(TfrmPRNMedLog);

end.
