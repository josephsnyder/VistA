unit fWitness;

{
================================================================================
*	File:  fWitness.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision:  $  $Modtime: 4/24/2012 $

*	Description:  This is the form for validating a Witness when the User is a
*								nurse.
*
*	Notes:  Add confirmation prompt on Cancel (Are you sure you want to cancel this
*         administration?)
*
***
*** NOTE: Changed FormStyle from fsStayOnTop to fsNormal.  Attempt to eliminate
*** fsStayOnTop competition with DefMessageDlg which is also set to fsStayOnTop.
*** rpk 10/25/2013
***
*
*	$Archive:  $
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  BCMA_Startup, BCMA_Objects, BCMA_Common, BCMA_Util, ExtCtrls,
  TRPCB,
//  MFunStr,
  ComCtrls,
  VA508AccessibilityManager, VA508AccessibilityRouter;

type
  TfrmWitness = class(TForm)
    grpSignon: TGroupBox;
    lblAccess: TLabel;
    lblVerify: TLabel;
    edtAccess: TEdit;
    edtVerify: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    HRHAImage: TImage;
    memComment: TMemo;
    pnlAdminInfo: TPanel;
    bvlAdminInfo: TBevel;
    imgUnitsPerDose: TImage;
    lblDispensedMeds: TLabel;
    lblMedicationCaption: TLabel;
    lblSchedAdminTimeCaption: TLabel;
    lblScheduleTypeCaption: TLabel;
    lblLastActionCaption: TLabel;
    lblBagIDCaption: TLabel;
    lblDosageCaption: TLabel;
    lblUnitsPerDoseCaption: TLabel;
    lblMedRouteCaption: TLabel;
    lblAdminInfo: TLabel;
    lblSpecInstr: TLabel;
    lvwMedications: TListView;
    mmoSpecialInstructions: TMemo;
    lblMedication: TVA508StaticText;
    lblSchedAdminTime: TVA508StaticText;
    lblScheduleType: TVA508StaticText;
    lblLastAction: TVA508StaticText;
    lblBagID: TVA508StaticText;
    lblDosage: TVA508StaticText;
    lblUnitsPerDose: TVA508StaticText;
    lblMedRoute: TVA508StaticText;
    pnlScrollDown: TPanel;
    lblScrollDown: TStaticText;
    btnDisplaySIOPI: TButton;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    cbxAcknowledge: TCheckBox;
    memhdr: TMemo;
    lblComment: TLabel;
    grpQtyEntered: TGroupBox;
    edtQtyEntered: TEdit;
    grpSite: TGroupBox;
    edtBodySite: TEdit;

    (*
      Calls Authenticate to validate a Witness.  If Authenticate returns true,
      ModalResult is set to mrOK otherwise, ModalResult is set
      to mrNone.
    *)
    procedure btnOKClick(Sender: TObject);

    procedure edtAccessChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
//    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure memCommentExit(Sender: TObject);
    procedure cbxAcknowledgeClick(Sender: TObject);
    procedure memhdrEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDisplaySIOPIClick(Sender: TObject);
    procedure edtQtyEnteredEnter(Sender: TObject);
//    procedure memCommentChange(Sender: TObject);
  private
    { Private declarations }
    (*
      Uses RPC 'PSB Witness' to validate a Witness.  If the Witness
      is validated, ModalResult is set to mrOK otherwise, ModalResult is set
      to mrCancel.  In either case the form is closed.
    *)
    function Authenticate(): Boolean;

    function GetQtyEnteredList(inOrder: TBCMA_MedOrder): Boolean;

  public
    { Public declarations }
  end;

function GetWitness(inOrder: TBCMA_MedOrder): Boolean;

var
  frmWitness: TfrmWitness;

implementation
uses
  BCMA_Main, Hash;


type
  eWitness = (eNoWitness, eWitnessAlert, eWitnessRecommended, eWitnessRequired);

var
  inMedOrder: TBCMA_MedOrder;
  noWitness: Boolean;
  WitnessCode: eWitness;

//  Authenticated: Boolean;

{$R *.dfm}

///
/// get new help context numbers for witness form
///

function GetWitness(inOrder: TBCMA_MedOrder): Boolean;
var
  frmWitness: TFrmWitness;
  WitnessName: string;
  x, i: integer;
  IVString: string;
  MyIcon: TIcon;
  TempObject: TObject;

begin
  inMedOrder := inOrder;
//  Result := '';
  Result := False;
  WitnessName := '';
//  WitnessCode := eWitness(ord(inOrder.WitnessFlag[1]));
  i := StrToIntDef(inOrder.WitnessFlag, 0);
  if (ord(eNoWitness) <= i) and (i <= ord(eWitnessRequired)) then
    WitnessCode := eWitness(i);

//  Authenticated := False;

  frmWitness := TfrmWitness.create(application);
  try
    with frmWitness do begin
      // CQ 1525
      case WitnessCode of
        eWitnessRequired:
//          HelpContext := 245; // Witness High Risk/High Alert Drugs When a Witness is Required, rpk 5/9/2013
          grpSignon.HelpContext := 245; // Witness High Risk/High Alert Drugs When a Witness is Required, rpk 5/23/2013
        eWitnessRecommended:
//          HelpContext := 246; // Witness High Risk/High Alert Drugs When a Witness is Recommended and Provided, rpk 5/9/2013
          grpSignon.HelpContext := 246; // Witness High Risk/High Alert Drugs When a Witness is Recommended and Provided, rpk 5/23/2013
      end;

      if WitnessCode = eWitnessRecommended then begin // rpk 12/10/2012
        memhdr.Text :=
          'This drug is a High Risk/High Alert medication that recommends a ' +
          'second signature from licensed personnel for administration.';
      end;
      // copied from fUnableToScan
      lblLastAction.Caption := '';

      with inMedOrder do begin
        lblMedication.Caption := ActiveMedication + ' '; // rpk 7/28/2010

        {retrieve IV specific data}
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
//                HelpContext := 147; // unable to scan (IVP/IVPB) medication; rpk 9/8/2010


                lblScheduleType.Caption := ScheduleTypeTitles[ScheduleTypeID] + ' '; // rpk 7/28/2010
                lblSchedAdmintime.Caption :=
                  DisplayVADateYearTime(AdministrationTime) + ' '; // rpk 7/28/2010
                lblDosage.Caption := Dosage + ' '; // rpk 7/28/2010
                lblMedRoute.Caption := UpperCase(Route) + ' '; // rpk 7/28/2010
                SetSIOPIMemo(mmoSpecialInstructions); // rpk 1/6/2012
                mmoSpecialInstructions.SelStart := 0; // rpk 9/1/2010
                pnlScrollDown.Visible := mmoSpecialInstructions.Lines.Count > 6; // 3/14/2012

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
                { if (frmMain.WorkFlowType = WF_UAS_CreateWardStock) then
                  HelpContext := 168 // unable to scan (IV Ward Stock) medication; rpk 9/8/2010
                else
                  HelpContext := 164; ) // unable to scan (active IV) medication; rpk 9/8/2010
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
                SetSIOPIMemo(mmoSpecialInstructions); // rpk 1/6/2012
                mmoSpecialInstructions.SelStart := 0; // rpk 9/1/2010
                pnlScrollDown.Visible := mmoSpecialInstructions.Lines.Count > 6; // 3/16/2012

              {if ScannedInput is not null, then we are dealing with an existing
              bag so get the additives and solutions from the bag. Else if it
              is null, this is a ward stock and we need to get the additives and
              solutions from the order}

                if ScannedInput = '' then begin
                  TempObject := inMedOrder;
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
//          HelpContext := 108; // unable to scan (unit dose) medication; rpk 8/24/2010

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
          SetSIOPIMemo(mmoSpecialInstructions); // rpk 1/6/2012
          mmoSpecialInstructions.SelStart := 0; // rpk 9/1/2010
          pnlScrollDown.Visible := mmoSpecialInstructions.Lines.Count > 6; // 3/16/2012

          if LastActivityStatus <> '' then
            lblLastAction.Caption := GetLastActivityStatus(LastActivityStatus) +
              ': ' + DisplayVADateYearTime(TimeLastAction) + ' '; // rpk 7/28/2010
          lblBagId.Caption := 'N/A';

          for x := 0 to OrderedDrugCount - 1 do begin
            lvwMedications.AddItem(OrderedDrugs[x].Name, nil);
          end;
        end; // else UD

        grpQtyEntered.Visible := GetQtyEnteredList(inOrder);
        edtBodySite.Text := BodySite;  // rpk 10/16/2015
        grpSite.Visible := edtBodySite.Text > '';  // rpk 10/16/2015
      end;

      ModalResult := ShowModal;

      Result := ModalResult = mrOK;

    end; // with frmWitness
  finally
//    frmWitness.Free;
    frmWitness.Release; // rpk 6/18/2013
  end;

end; // GetWitness

function TfrmWitness.GetQtyEnteredList(inOrder: TBCMA_MedOrder): Boolean;
var
  QtyEnteredStr: TStringList;
  I: Integer;
begin
  Result := False;
  edtQtyEntered.Text := '';
  QtyEnteredStr := TStringList.Create;
  try
    with inOrder do begin
      if AdministrationUnit = '' then begin // AdministrationUnitNeeded
        for I := 0 to OrderedDrugCount - 1 do begin
          if OrderedDrugs[i].QtyEntered > '' then
            QtyEnteredStr.Add(OrderedDrugs[i].QtyEntered);
        end;
        if QtyEnteredStr.Count > 0 then begin
          edtQtyEntered.Text := QtyEnteredStr[0];
          edtQtyEntered.SelStart := 0;
          Result := True;
        end;
      end; // AdministrationUnit = ''
    end;
  finally
    QtyEnteredStr.Free;
  end;
end; // GetQtyEnteredList

function TfrmWitness.Authenticate(): Boolean;
const
  delim = ';';
var
  dPos, apos: integer;
  ss,
    msgstr,
    AccessCode,
    VerifyCode,
    encAccessCode,
    encVerifyCode: string;
begin
  Result := False;
  inMedOrder.WitnessName := '';
  inMedOrder.WitnessDUZ := '';

  with BCMA_Broker do begin
    {
  //    ss := edtAccess.Text + '$';
    // CQ 1628: use semicolon for delimiter between access and verify codes
    // entered on the same line.  // rpk 6/25/2013

    ss := edtAccess.Text + delim;
    edtAccess.Text := '';
//    dPos := pos('$', ss);
    dPos := pos(delim, ss);
    AccessCode := copy(ss, 1, dPos - 1);

    VerifyCode := edtVerify.Text;
    edtVerify.Text := '';
    if VerifyCode = '' then
      VerifyCode := copy(ss, dPos + 1, 999);
    }

    // CQ 1628: use semicolon for delimiter between access and verify codes
    // entered on the same line.  // rpk 6/25/2013

    // also re-wrote code to eliminate a trailing delimiter added to the verify code
    // when access;verify used and edtverify.text was blank

    // case 1: no delimiter in edtAccess.text
    // assign edtAccess.Text to Access code
    // assign edtVerify.Text to Verify code

    // case 2: delimiter is embedded in edtAccess.Text
    // copy section before delimiter to Access code
    // copy second section after delimiter to Verify code if edtVerify.text is empty

    // check for embedded delimiter
    ss := edtAccess.text;
    dpos := Pos(delim, ss);
    if dpos = 0 then begin
      AccessCode := edtAccess.Text;
      VerifyCode := edtVerify.Text;
    end
    else begin
      AccessCode := copy(ss, 1, dPos - 1);
      if edtVerify.Text = '' then
        VerifyCode := copy(ss, dPos + 1, 999)
      else
        VerifyCode := edtVerify.Text;
    end;

    edtAccess.Text := '';
    edtVerify.Text := '';

    encAccessCode := encrypt(AccessCode);
    encVerifyCode := encrypt(VerifyCode);

    if CallServer('PSB WITNESS', [encAccessCode, encVerifyCode], nil) then begin
      if (Results.Count > 0) then begin
        if (StrToInt64Def(piece(Results[0], '^', 1), -1) > 0) then begin
          inMedOrder.WitnessDUZ := piece(Results[0], '^', 1);
          inMedOrder.WitnessName := piece(Results[0], '^', 2);
          if (BCMA_User.InstructorDUZ <> '') and
            (inMedOrder.WitnessDUZ = BCMA_User.InstructorDUZ) then begin
            // CQ 1394; rpk 9/24/2012
            msgstr :=
              'An instructor monitoring a student does not have authority to witness a high risk/high alert medication.';
            writeLogMessageProc(msgstr, nil);
//            DefMessageDlg(msgstr, mtError, [mbok], 0);
            // HelpContext 248:  Error Messages for Witness Validation
            DefMessageDlg(msgstr, mtError, [mbok], 248); // rpk 5/9/2013
            edtAccess.SetFocus;
          end
          else begin
            msgstr := inMedOrder.WitnessName +
              ' Signed on as Witness for ' +
              BCMA_User.UserName;
            writeLogMessageProc(msgstr, nil);
            btnOK.Enabled := True;
            Result := True;
          end;
        end
        else begin
//          DefMessageDlg(piece(Results[0], '^', 2), mtError, [mbok], 0);
          // HelpContext 248:  Error Messages for Witness Validation
          DefMessageDlg(piece(Results[0], '^', 2), mtError, [mbok], 248); // rpk 5/9/2013
          // put user back in Access Code field to try again
          if edtAccess.CanFocus then
            edtAccess.SetFocus;
        end;
      end // Results.Count > 0
      else
//        DefMessageDlg('PSB WITNESS returned no results.', mtError, [mbOK], 0);
        // HelpContext 248:  Error Messages for Witness Validation
        DefMessageDlg('PSB WITNESS returned no results.', mtError, [mbOK], 248); // rpk 5/9/2013
    end;
  end; // if CallServer

end; // Authenticate


procedure TfrmWitness.btnCancelClick(Sender: TObject);
begin
  if DefMessageDlg('Are you sure you want to cancel this administration?',
    mtConfirmation, [mbYes, mbNo], 0) = idNo then begin
    if edtAccess.CanFocus then
      edtAccess.SetFocus;
    Invalidate;
    ModalResult := mrNone;
  end;
end;

procedure TfrmWitness.btnDisplaySIOPIClick(Sender: TObject);
var
  tbool: Boolean;
begin
  if inMedOrder <> nil then begin
    with inMedorder do begin
      tbool := DisplaySIOPI(False); // rpk 11/09/2011
    end;
  end;
end;

procedure TfrmWitness.btnOKClick(Sender: TObject);
begin
  case WitnessCode of
    eWitnessRecommended: begin
        // if both are still empty, we got here after checking acknowledge and
        // filling in the comment
        if (edtAccess.Text = '') and (edtVerify.Text = '') then begin
          if noWitness then begin
            inMedOrder.WitnessComment := memComment.Text;
            inMedOrder.WitnessDUZ := '';
            // we're done, set ModalResult OK
            ModalResult := mrOK;
          end
          else begin
            if DefMessageDlg('You are attempting to administer a High Risk / High Alert drug without the presence of an authorized witness. ' + CRLF + CRLF +
              'Actions taken will be recorded in the audit log. ' + CRLF + CRLF +
              'Do you want to continue WITHOUT A WITNESS?',
              mtConfirmation, [mbYes, mbNo], 0) = idYes then begin
              // switch mode to Screen B; access and verify are disabled.
              // acknowledge is enabled;  (, comment is no longer required)
              // user must check acknowledge in order to // (and enter a comment)
              // have OK enabled.
              noWitness := True;
              lblAccess.Enabled := False;
              edtAccess.Enabled := False;
              edtAccess.Color := clBtnFace;
              lblVerify.Enabled := False;
              edtVerify.Enabled := False;
              edtVerify.Color := clBtnFace;
              cbxAcknowledge.Enabled := True;
              cbxAcknowledge.Show;
              btnOK.Enabled := False;
              memhdr.Font.Color := clBlack;
              if cbxAcknowledge.CanFocus then
                cbxAcknowledge.SetFocus;
              ModalResult := mrNone;
              // Witness High Risk/High Alert Drugs When a
              // Witness is Recommended, and not Provided.
              grpSignon.HelpContext := 247; // rpk 5/23/2013
            end
            else begin
              // user wants to return to access / verify input and sign-in a witness
              noWitness := False;
              if edtAccess.CanFocus then
                edtAccess.SetFocus;
              ModalResult := mrNone;
            end;
          end;
        end // if access and verify are blank
        else begin
          // at least one field is completed, try authentication of witness
          if Authenticate then begin
            inMedOrder.WitnessComment := memComment.Text;
            ModalResult := mrOK;
          end
          else
            ModalResult := mrNone;
        end;
      end; // eWitnessRecommended

    eWitnessRequired: begin
        if (edtAccess.Text = '') and (edtVerify.Text = '') then begin
          DefMessageDlg('An authorized witness must sign on before you are able to administer this High Risk / High Alert medication.',
            mtWarning, [mbOK], 0);
          if edtAccess.CanFocus then
            edtAccess.SetFocus;
          ModalResult := mrNone;
        end
        else begin
          if Authenticate then begin
            inMedOrder.WitnessComment := memComment.Text;
            ModalResult := mrOK;
          end
          else
            ModalResult := mrNone;
        end;
      end; // eWitnessRequired
  end; // case WitnessCode

end; // btnOKClick

procedure TfrmWitness.cbxAcknowledgeClick(Sender: TObject);
begin
  if (WitnessCode = eWitnessRecommended) and noWitness then
    btnOK.Enabled := cbxAcknowledge.Checked; // rpk 10/31/2012
end;

procedure TfrmWitness.edtAccessChange(Sender: TObject);
begin
//  btnWitness.Enabled := (edtAccess.text <> '') and (edtVerify.Text <> '');
//  if WitnessCode = eWitnessRequired then
//    btnOK.Enabled := (edtAccess.text <> '') and (edtVerify.Text <> '');
end;

procedure TfrmWitness.edtQtyEnteredEnter(Sender: TObject);
begin
  edtQtyEntered.SelStart := 0; // rpk 4/13/2013
end;

procedure TfrmWitness.FormActivate(Sender: TObject);
begin
  ForceForegroundWindow(handle);
end;

procedure TfrmWitness.FormCreate(Sender: TObject);
begin
  noWitness := False;
end;

procedure TfrmWitness.FormShow(Sender: TObject);
begin
  if edtAccess.CanFocus then // rpk 11/13/2012
    edtAccess.SetFocus;
end; // FormShow

procedure TfrmWitness.memhdrEnter(Sender: TObject);
begin
  memhdr.SelStart := 0; // rpk 11/8/2012
end;

initialization
  SpecifyFormIsNotADialog(TfrmWitness);
end.

