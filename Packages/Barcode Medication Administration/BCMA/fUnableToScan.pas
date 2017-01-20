unit fUnableToScan;

///
///  Any changes to Administration Info panel component assignments should also
///  be applied to fWitness which copied Administration Info.  rpk 6/15/2012
///
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, BCMA_Objects, BCMA_Util, Grids,
  VA508AccessibilityRouter, VA508AccessibilityManager;

procedure UnableToScanExecute(
  ScanType: Integer;
  inWorkflowType: TWorkFlowType; // rpk 7/19/2011
  {JK 4/28/2008 - needed to aid in determining what workflow route is occurring}
  BagList: TStringList;
  {JK 4/28/2008 - added to move bag list deeper into the screen hierarchy}
  aMedOrder: TBCMA_MedOrder;
  var ReasonText: string;
  var CommentText: string;
  var ReturnValue: Boolean;
  var PRNVitalsInfo: string;
  {JK 8/25/2008 - needed to track PRN info if it is a PRN schedule}
  var PRNPainInfo: string;
  {JK 8/25/2008 - needed to track PRN info if it is a PRN schedule}
  DispensedDrug: TBCMA_DispensedDrug = nil);

const
  WristBandReasons: array[0..2] of string = (
    'Damaged Wristband',
    'Scanning Equipment Failure',
    'Unable to Determine'
    );
  AdminReasons: array[0..4] of string = (
    'Damaged Medication Label',
    'Dose Discrepancy',
    'No Bar Code',
    'Scanning Equipment Failure',
    'Unable to Determine'
    );

type
  TfrmUnableToScan = class(TForm)
    pnlAdminInfo: TPanel;
    pnlUserInput: TPanel;
    pnlButtons: TPanel;
    bvlAdminInfo: TBevel;
    bvlUnableToScanReason: TBevel;
    Bevel1: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    lvwMedications: TListView;
    cbxReasons: TComboBox;
    memComment: TMemo;
    imgIcon: TImage;
    imgUnitsPerDose: TImage;
    mmoSpecialInstructions: TMemo;
    lblMedication: TVA508StaticText;
    lblSchedAdminTime: TVA508StaticText;
    lblScheduleType: TVA508StaticText;
    lblLastAction: TVA508StaticText;
    lblBagID: TVA508StaticText;
    lblDosage: TVA508StaticText;
    lblUnitsPerDose: TVA508StaticText;
    lblMedRoute: TVA508StaticText;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblDispensedMeds: TLabel;
    lblMedicationCaption: TLabel;
    lblSchedAdminTimeCaption: TLabel;
    lblScheduleTypeCaption: TLabel;
    lblLastActionCaption: TLabel;
    lblBagIDCaption: TLabel;
    lblDosageCaption: TLabel;
    lblUnitsPerDoseCaption: TLabel;
    lblMedRouteCaption: TLabel;
    lblReason: TLabel;
    lblEnterAComment: TLabel;
    lblClickOK: TLabel;
    mmoMessage: TMemo;
    lblUnableToScanReason: TLabel;
    lblAdminInfo: TLabel;
    lblSpecInstr: TLabel;
    pnlScrollDown: TPanel;
    lblScrollDown: TStaticText;
    btnDisplaySIOPI: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbxReasonsChange(Sender: TObject);
    procedure lvwMedicationsEnter(Sender: TObject);
    procedure mmoSpecialInstructionsEnter(Sender: TObject);
    procedure memCommentEnter(Sender: TObject);
    procedure mmoMessageEnter(Sender: TObject);
    procedure cbxReasonsEnter(Sender: TObject);
    procedure btnDisplaySIOPIClick(Sender: TObject);
  private
    { Private declarations }
    tmpPRNVitalsInfo: string;
    tmpPRNPainInfo: string;
  public
    { Public declarations }
    UAS_LogState: TUASLogAction; {JK 4/27/2008}
    FiveRights_WorkFlow: TWorkFlowType; {JK 5/23/2008}
    WorkFlowType: TWorkFlowType; {JK 4/28/2008}
    UASBagList: TStringList; {JK 4/28/2008}
  end;

var
  frmUnableToScan: TfrmUnableToScan;
  CurrentMedOrder: TBCMA_MedOrder;
  ScannedBagID: string;
  Dispensed_Drug_IEN: string; {JK 7/2/2008}

  isPRNCancelled: Boolean;

implementation

{$R *.dfm}
uses
  fPtSelect,
  BCMA_Main,
  BCMA_Common,
  uFiveRights;
//  MFunStr;

procedure UnableToScanExecute(
  ScanType: Integer;
  inWorkflowType: TWorkFlowType; // rpk 7/19/2011
  BagList: TStringList;
  aMedOrder: TBCMA_MedOrder;
  var ReasonText: string;
  var CommentText: string;
  var ReturnValue: Boolean;
  var PRNVitalsInfo: string;
  var PRNPainInfo: string;
  DispensedDrug: TBCMA_DispensedDrug = nil);
{
ScanTypes:
  0 = wristband
  1 = Administration
}
var
  x, i: integer;
  IVString: string;
  MyIcon: TIcon;
  TempObject: TObject;
  UASScreen: TfrmUnableToScan;
  RouteText: string;

begin

  ReasonText := '';
  CommentText := '';
  ReturnValue := False;

  CurrentMedOrder := aMedOrder;

  if DispensedDrug <> nil then
    Dispensed_Drug_IEN := DispensedDrug.IEN
  else
    Dispensed_Drug_IEN := '';

  UASScreen := TfrmUnableToScan.Create(Application);

  UASScreen.WorkFlowType := inWorkFlowType; // rpk 7/19/2011

  with UASScreen do try

    {User selected unable to scan when scanning wristband}
    if ScanType = 0 then begin
      pnlAdminInfo.Visible := False;
      Height := Height - pnlAdminInfo.Height;
      for x := low(WristBandReasons) to high(WristBandReasons) do
        cbxReasons.AddItem(WristBandReasons[x], nil);
      imgicon.Visible := False;
      mmoMessage.Hide;
{$IFDEF CAS_DDPE_DEBUG}
      if UASScreen.cbxReasons.Items.Count > 0 then
        begin
          UASScreen.cbxReasons.ItemIndex := UASScreen.cbxReasons.Items.Count - 1;
          btnOK.Enabled := True;
        end;
{$ENDIF}
      HelpContext := 33; // open patient record; rpk 8/24/2010
    end
    else begin
      {user had issue scanning medication}

      if DispensedDrug <> nil then begin
        //        lblMessage.Caption :=
        mmoMessage.Text :=
          'NOTICE: Unable to Scan was selected for dispensed drug ' +
          DispensedDrug.Name; // rpk 7/1/2010
//        mmoMessage.SelStart := 0;  // rpk 9/1/2010
        mmoMessage.TabStop := True; // rpk 7/1/2010
        imgIcon.Visible := True;
      end
      else begin
        mmoMessage.Text := ''; // rpk 7/1/2010
        mmoMessage.TabStop := False; // rpk 7/1/2010
      end;

      for x := low(AdminReasons) to high(AdminReasons) do
        cbxReasons.AddItem(AdminReasons[x], nil);
      lblLastAction.Caption := '';

//      mmoSpecialInstructions.TabStop := ScreenReaderSystemActive; // rpk 7/1/2010

      with aMedOrder do begin

        lblMedication.Caption := ActiveMedication + ' '; // rpk 7/28/2010

        {retreive IV specific data}
        if OrderTypeID = otIV then

          case lstCurrentTab of

            ctPB: begin

                {If this is an UAS situation for an IVPB with "n" bags, the exact bag
                 has not yet been specified (hence the variable scannedinput is blank.)
                 However we must first do a PRN screen to allow the nurse to determine if
                 it is time to administer the PRN IVPB bag and enter pain information. Then
                 I have to push this information down to the Verify Medication screen so eventually
                 the pain score (if given) is recorded on the server if the UTS is successfully
                 completed.  JK 8/22/2008}

                {if a IVPB IV bag, call the PRN Effectiveness screen first}
                HelpContext := 147; // unable to scan (IVP/IVPB) medication; rpk 9/8/2010

                isPRNCancelled := False;

                if aMedOrder.ScheduleTypeID = stPRN then
                  frmMain.ProcessPRNS(aMedOrder, isPRNCancelled, PRNVitalsInfo,
                    PRNPainInfo);

                if isPRNCancelled then begin
                  DefMessageDlg('Order Administration Cancelled!', mtWarning,
                    [mbOK], 0);
                  UAS_LogState := LA_Cancelled;
                  PRNVitalsInfo := '';
                  PRNPainInfo := '';
                  Exit;
                end;

                lblScheduleType.Caption := ScheduleTypeTitles[ScheduleTypeID] + ' '; // rpk 7/28/2010
                lblSchedAdmintime.Caption :=
                  DisplayVADateYearTime(AdministrationTime) + ' '; // rpk 7/28/2010
                lblDosage.Caption := Dosage + ' '; // rpk 7/28/2010
                lblMedRoute.Caption := UpperCase(Route) + ' '; // rpk 7/28/2010
                //lblSpecialInstructions.Caption := aMedOrder.SpecialInstructions;
//                lblSpecInstr.Caption := '&Other Print Info:';
                // change keyboard shortcut to P to avoid conflict with OK
//                lblSpecInstr.Caption := 'Other &Print Info:'; // rpk 4/8/2011
                //                mmoSpecialInstructions.Lines.Add(aMedOrder.SpecialInstructions);  {JK 8/13/2008}
//                mmoSpecialInstructions.text := aMedOrder.SpecialInstructions;
                // rpk 10/8/2009
                SetSIOPIMemo(mmoSpecialInstructions); // rpk 1/6/2012
                mmoSpecialInstructions.SelStart := 0; // rpk 9/1/2010
                pnlScrollDown.Visible := mmoSpecialInstructions.Lines.Count > 6;  // 3/14/2012

                lblUnitsPerDose.Caption := 'N/A';

                if LastActivityStatus <> '' then
                  lblLastAction.Caption :=
                    GetLastActivityStatus(LastActivityStatus) + ': ' +
                    DisplayVADateYearTime(TimeLastAction) + ' '; // rpk 7/28/2010

                if ScannedInput = '' then
                  lblBagID.Caption := 'N/A'
                else
                  lblBagID.Caption := ScannedInput + ' '; // rpk 7/28/2010

                for x := 0 to AdditiveCount - 1 do begin
                  IVString := piece(Additives[x], '^', 3) +
                    ' ' + piece(Additives[x], '^', 4) + ' ' +
                    piece(Additives[x], '^', 5);
                  with lvwMedications do begin
                    AddItem(IVString, nil);
                    Items[Items.Count - 1].SubItems.Add('N/A');
                  end;
                end;

                for x := 0 to SolutionCount - 1 do begin
                  IVString := piece(Solutions[x], '^', 3) +
                    ' ' + piece(Solutions[x], '^', 4) + ' ' +
                    piece(Solutions[x], '^', 5);
                  with lvwMedications do begin
                    AddItem(IVString, nil);
                    Items[Items.Count - 1].SubItems.Add('N/A');
                  end;
                end;
              end; {case of ctPB}

            {IV Administration workflow when unable to scan medication}
            ctIV: begin
                if (WorkFlowType = WF_UAS_CreateWardStock) then
                  HelpContext := 168 // unable to scan (IV Ward Stock) medication; rpk 9/8/2010
                else
                  HelpContext := 164; // unable to scan (active IV) medication; rpk 9/8/2010
                {Set up the display items}
                lblDosage.Caption := Dosage + ' '; // rpk 7/28/2010
                lblUnitsPerDose.Caption := 'N/A';
                lblSchedAdmintime.Caption := 'N/A';
                lblScheduleType.Caption := 'N/A';

                if ScannedInput = '' then
                  lblBagID.Caption := 'N/A'
                else
                  lblBagID.Caption := ScannedInput + ' '; // rpk 7/28/2010

                {JK - 7/25/2008 - CQ #149}
                if ScannedInput <> '' then
                  for i := 0 to IVHistoryDates.Count - 1 do begin
                    if TBCMA_IVBags(IVHistoryDates.Items[i]).UniqueID =
                      ScannedInput then
                      if TBCMA_IVBags(IVHistoryDates.Items[i]).ScanStatus = 'C'
                        then begin
                        lblBagID.Caption := 'N/A';
                        Break;
                      end;
                  end;

                lblLastAction.Caption :=
                  '*** - See Bag Information Column on the VDL ';
                lblMedRoute.Caption := UpperCase(Route) + ' '; // rpk 7/28/2010
                //lblSpecialInstructions.Caption := aMedOrder.SpecialInstructions;
//                lblSpecInstr.Caption := '&Other Print Info:';
                // change keyboard shortcut to P to avoid conflict with OK
//                lblSpecInstr.Caption := 'Other &Print Info:'; // rpk 4/8/2011
                //                mmoSpecialInstructions.Lines.Add(aMedOrder.SpecialInstructions); {JK 8/13/2008}
//                mmoSpecialInstructions.text := aMedOrder.SpecialInstructions;
                // rpk 10/8/2009
                SetSIOPIMemo(mmoSpecialInstructions); // rpk 1/6/2012
                mmoSpecialInstructions.SelStart := 0; // rpk 9/1/2010
                pnlScrollDown.Visible := mmoSpecialInstructions.Lines.Count > 6;  // 3/16/2012

              {if ScannedInput is not null, then we are dealing with an existing
              bag so get the additives and solutions from the bag. Else if it
              is null, this is a ward stock and we need to get the additives and
              solutions from the order}

                if ScannedInput = '' then begin
                  TempObject := aMedOrder;
                end
                else
                  TempObject := BCMA_Patient.GetIVBagFromUniqueID(ScannedInput);

                with tempObject do
                  for x := 0 to Additives.count - 1 do begin
                    IVString := piece(Additives[x], '^', 3) +
                      ' ' + piece(Additives[x], '^', 4) + ' ' +
                      piece(Additives[x], '^', 5);
                    with lvwMedications do begin
                      AddItem(IVString, nil);
                      Items[Items.Count - 1].SubItems.Add('N/A');
                    end;
                  end; // with, for x

                for x := 0 to Solutions.count - 1 do begin
                  IVString := piece(Solutions[x], '^', 3) +
                    ' ' + piece(Solutions[x], '^', 4) + ' ' +
                    piece(Solutions[x], '^', 5);
                  with lvwMedications do begin
                    AddItem(IVString, nil);
                    Items[Items.Count - 1].SubItems.Add('N/A');
                  end;
                end; // for x
              end; // ctIV
          end // if ordertype = otIV, case lstcurrenttab

        {retrieve UD specific Data}
        else begin
          HelpContext := 108; // unable to scan (unit dose) medication; rpk 8/24/2010

          if OrderedDrugCount = 1 then
            lblUnitsPerDose.Caption := OrderedDrugs[0].QtyOrderedText + ' ' // rpk 7/28/2010
          else
            lblUnitsPerDose.Caption := '***Multiple Dispensed Drugs:';

          if (OrderedDrugCount <> 1) or
            (OrderedDrugs[0].QtyOrdered <> 1) or
            (pos('.', OrderedDrugs[0].QtyOrderedText) <> 0) then begin
            MyIcon := TIcon.Create;
            MyIcon.Handle := CopyIcon(LoadIcon(0, IconArray[2]));
            imgUnitsPerDose.Picture.Bitmap := IconToBitMap(MyIcon);
            lblUnitsPerDoseCaption.Font.Style := [fsBold];
            lblUnitsPerDose.Font.Style := [fsBold];
          end;

          lblScheduleType.Caption := ScheduleTypeTitles[ScheduleTypeID] + ' '; // rpk 7/28/2010
          lblSchedAdmintime.Caption :=
            DisplayVADateYearTime(AdministrationTime) + ' '; // rpk 7/28/2010
          lblDosage.Caption := Dosage + ' '; // rpk 7/28/2010
          lblMedRoute.Caption := UpperCase(Route) + ' '; // rpk 7/28/2010
          //lblSpecialInstructions.Caption := aMedOrder.SpecialInstructions;
//          lblSpecInstr.Caption := '&Special Instructions:';
          //          mmoSpecialInstructions.Lines.Add(aMedOrder.SpecialInstructions); {Jk 8/13/2008}
//          mmoSpecialInstructions.text := aMedOrder.SpecialInstructions;
          // rpk 10/8/2009
          SetSIOPIMemo(mmoSpecialInstructions); // rpk 1/6/2012
          mmoSpecialInstructions.SelStart := 0; // rpk 9/1/2010
          pnlScrollDown.Visible := mmoSpecialInstructions.Lines.Count > 6;  // 3/16/2012

          if LastActivityStatus <> '' then
            lblLastAction.Caption := GetLastActivityStatus(LastActivityStatus) +
              ': ' + DisplayVADateYearTime(TimeLastAction) + ' '; // rpk 7/28/2010
          lblBagId.Caption := 'N/A';

          for x := 0 to OrderedDrugCount - 1 do begin
            lvwMedications.AddItem(OrderedDrugs[x].Name, nil);
            //lvwMedications.Items[x].SubItems.Add(OrderedDrugs[x].ien) {removed by jk 4/9/2008}
          end;
        end;
      end;
    end; // else scan medication

    imgIcon.Picture.Icon.Handle := LoadIcon(0, IconArray[2]);

    {Bring up the UAS screen}

    // UASScreen.UASBagList := BagList;
    // copy the strings from BagList to UASBagList
    if BagList <> nil then // rpk 6/24/2011
      UASScreen.UASBagList.Assign(BagList); // rpk 6/22/2011

    ReturnValue := (UASScreen.ShowModal = mrOK);

    if UASScreen.UAS_LogState = LA_OkToLog then begin

      memComment.Text := StripString(memComment.Text);

      if WorkFlowType <> WF_UAS_Wristband then begin
        {JK 8/14/2008}
        if aMedOrder.Route = 'IV PUSH' then
          RouteText := 'IVP'
        else if aMedOrder.Route = 'IV PIGGYBACK' then
          RouteText := 'IVPB'
        else
          RouteText := '';
      end;

      {JK 5/20/2008 - return back this value}
      if FiveRights_WorkFlow = WF_FIVERIGHTS then begin
        if RouteText <> '' then
          CommentText := BuildCommentLine('[' + RouteText +
            ' - Verify Five Rights Override Selected]', memComment.Text)
        else
          CommentText :=
            BuildCommentLine('[Verify Five Rights Override Selected]',
            memComment.Text);
      end
      else if RouteText <> '' then
        CommentText := BuildCommentLine('[' + RouteText + ']', memComment.Text)
      else
        CommentText := memComment.Text;

      ReasonText := cbxReasons.Text; {JK 5/20/2008 - return back this value}

      IsUnableToScan := True;

      // User selected unable to scan when scanning wristband and UAS screen returned OK
      if (ScanType = 0) and ReturnValue then begin
        with TfrmPtSelect.create(application) do try
          ShowModal;
        finally
//          Free;
          Release; // rpk 6/18/2013
        end;
        if BCMA_Patient.IEN <> '' then begin
          LogUnableToScan('', cbxReasons.Text, memComment.Text, '', 'W');
          UAS_LogState := LA_AlreadyLogged;
        end;
      end
      else if (ScanType = 1) and ReturnValue then begin
        //-if WorkFlowType = WF_UAS_CREATEWARDSTOCK then showmessage('WF_UAS_CREATEWARDSTOCK');

//        with aMedOrder do
//          if OrderTypeID = otIV then
//            UnableToScanString := 'ID^' + ScannedInput
//          else
//          begin
//            if DispensedDrug <> nil then UnableToScanString := 'DD^' + DispensedDrug.IEN
//            else  UnableToScanString := 'DD^' + OrderedDrugs[0].IEN;
//          end;
//        LogUnableToScan(aMedOrder.OrderNumber, cbxReasons.Text, memComment.Text, UnableToScanString, 'M');
//        UAS_LogState := LA_AlreadyLogged;
      end;

    end
    else begin // UAS_LogState <> LA_OkToLog
      ReasonText := '';
      CommentText := '';
      PRNVitalsInfo := '';
      PRNPainInfo := '';
      // allow LA_AlreadyLogged to return ReturnValue = True; incorrect action
      // UAS_LogState = LA_AlreadyLogged implies no further action needed on return
      // from UnableToScanExecute
////// invalid:      if UASScreen.UAS_LogState = LA_Cancelled then // rpk 6/30/2011
      ReturnValue := False;

      //      {JK 9/17/2008 CQ #241}
      //      if (lstCurrentTab = ctPB) and (WorkFlowType = WF_Normal_Single_UnitDose) then
      //        DefMessageDlg('Order Administration Cancelled!', mtWarning, [mbOK], 0);

    end; // else UASScreen.UAS_LogState <> LA_OkToLog  {if not USAScreenAlreadyLogged}

  finally
    tmpPRNVitalsInfo := PRNVitalsInfo;
    tmpPRNPainInfo := PRNPainInfo;
//    UASScreen.Free; // rpk 6/30/2011
    UASScreen.Release;  // rpk 6/18/2013
  end;

end; {Function UnableToScanExecute}

procedure TfrmUnableToScan.FormCreate(Sender: TObject);
begin
  UAS_LogState := LA_OkToLog; {JK 4/27/2008}
  UASBagList := TStringList.Create;
  mmoSpecialInstructions.Clear;
end;

procedure TfrmUnableToScan.lvwMedicationsEnter(Sender: TObject);
begin
  if (lvwMedications.Selected = nil) and (lvwMedications.Items[0] <> nil)
    then
    lvwMedications.Selected := lvwMedications.Items[0];
end;

procedure TfrmUnableToScan.memCommentEnter(Sender: TObject);
begin
  GetScreenReader.Speak(memComment.text); // rpk 9/7/2010
end;

procedure TfrmUnableToScan.mmoMessageEnter(Sender: TObject);
begin
  GetScreenReader.Speak(mmoMessage.text); // rpk 9/7/2010
end;

procedure TfrmUnableToScan.mmoSpecialInstructionsEnter(Sender: TObject);
begin
  GetScreenReader.Speak(mmoSpecialInstructions.text); // rpk 9/7/2010
end;

procedure TfrmUnableToScan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UASBagList.Free;
end;

procedure TfrmUnableToScan.btnCancelClick(Sender: TObject);
begin
  if (WorkflowType <> WF_UAS_Wristband) and
    (WorkflowType <> WF_Normal_Multiple_UnitDose) and
    (WorkflowType <> WF_Normal_Single_UnitDose) then
    DefMessageDlg('Order Administration Cancelled!', mtWarning, [mbOK], 0);
  UAS_LogState := LA_Cancelled;
  ModalResult := mrCancel;
end;

procedure TfrmUnableToScan.btnDisplaySIOPIClick(Sender: TObject);
var
  tbool: Boolean;
begin
  if CurrentMedOrder <> nil then begin
    with CurrentMedorder do begin
      tbool := DisplaySIOPI(False); // rpk 11/09/2011
    end;
  end;
end;

procedure TfrmUnableToScan.btnOKClick(Sender: TObject);
begin
  if (WorkFlowType <> WF_UAS_CreateWardStock) and
    (WorkFlowType <> WF_UAS_Wristband) then begin

    frmFiveRights := TfrmFiveRights.Create(self);

    try
      frmFiveRights.MedOrder := CurrentMedOrder;
      frmFiveRights.SelectedMultiDoseItemIEN := Dispensed_Drug_IEN;
      frmFiveRights.UASReason := cbxReasons.Text;
      frmFiveRights.MemComment := StripString(memComment.Text);
      memComment.Text := frmFiveRights.MemComment;
      frmFiveRights.BagList := UASBagList;

      {JK 8/22/2008 - Pass in PRN info if this is a PRN IVPB}
      if (CurrentMedOrder.Route = 'IV PIGGYBACK') and
        (CurrentMedOrder.ScheduleTypeID = stPRN) then begin
        frmFiveRights.VitalsInfo := tmpPRNVitalsInfo;
        frmFiveRights.PainInfo := tmpPRNPainInfo;
      end
      else begin
        frmFiveRights.VitalsInfo := '';
        frmFiveRights.PainInfo := '';
      end;

      if frmFiveRights.ShowModal <> mrOK then begin
        UAS_LogState := LA_Cancelled;
        btnCancelClick(self);
      end;
    finally
      UAS_LogState := frmFiveRights.UAS_LogState;
      FiveRights_WorkFlow := frmFiveRights.UAS_WorkFlow;
//      frmFiveRights.Free;
      frmFiveRights.Release; // rpk 6/18/2013
    end;

  end;

end; // btnOKClick

procedure TfrmUnableToScan.cbxReasonsChange(Sender: TObject);
begin
  btnOK.Enabled := True;
end;

procedure TfrmUnableToScan.cbxReasonsEnter(Sender: TObject);
begin
  GetScreenReader.Speak(lblReason.Caption); // rpk 8/25/2011
end;

initialization
  SpecifyFormIsNotADialog(TfrmUnableToScan);

end.

