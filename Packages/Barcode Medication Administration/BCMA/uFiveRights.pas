unit uFiveRights;

{
================================================================================
*	File:  uFiveRights.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 28 $  $Modtime: 05/11/08 4:55p $
*
*	Description:  This is the medication verification screen that includes
*               the new five rights override method per MSF SRS 2.0
*
*	Notes:
*
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, BCMA_Objects, BCMA_Common, uIVUtilities,
  BCMA_Util, fPtSelect, fUnableToScan, BCMA_Startup, WardStock,
  VA508AccessibilityManager, VA508AccessibilityRouter;

type
  TfrmFiveRights = class(TForm)
    rbVerifyMedication: TRadioButton;
    rbVerifyFiveRights: TRadioButton;
    pnlVerifyMedication: TPanel;
    edEnterBarCode: TEdit;
    btnSubmit: TButton;
    pnlFiveRights: TPanel;
    cbRightPatient: TCheckBox;
    cbRightMedication: TCheckBox;
    cbRightDose: TCheckBox;
    cbRightRoute: TCheckBox;
    cbRightTime: TCheckBox;
    btnCancel: TButton;
    btnOK: TButton;
    mmoDrugInfo: TMemo;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblEnterBarCode: TLabel;
    procedure edEnterBarCodeKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbRightTimeClick(Sender: TObject);
    procedure cbRightRouteClick(Sender: TObject);
    procedure cbRightDoseClick(Sender: TObject);
    procedure cbRightMedicationClick(Sender: TObject);
    procedure cbRightPatientClick(Sender: TObject);
    procedure btnSubmitClick(Sender: TObject);
    procedure rbVerifyFiveRightsClick(Sender: TObject);
    procedure rbVerifyMedicationClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mmoDrugInfoEnter(Sender: TObject);
  private
    procedure InitScreen;
    function FiveRightsCheck: Boolean;
    procedure TurnOnFiveRights;
    procedure TurnOffFiveRights;
    procedure TurnOnManualEntry;
    procedure TurnOffManualEntry;
    procedure CanOKBtnBeEnabled;
    function BuildBagInfoForDisplay(IVBag: TBCMA_IVBags; aMedOrder:
      TBCMA_MedOrder): string;
    function BuildBagInfoAsString(IVBag: TBCMA_IVBags; aMedOrder:
      TBCMA_MedOrder): string;
    function UASExecute(ScanType: Integer; aMedOrder: TBCMA_MedOrder;
      EnteredNum: string;
      DispensedDrug: TBCMA_DispensedDrug = nil): Boolean;
    procedure ProcessIV;
    procedure ProcessPiggyback(IEN: string);
    function CheckIfValidBag(IVBag: TBCMA_IVBags): Boolean;
//    function ProcessViaFiveRightsLogic(MedOrder: TBCMA_MedOrder): Boolean;
    function ProcessViaFiveRightsLogic(inMedOrder: TBCMA_MedOrder): Boolean;
    function ScanDrug(ScanIEN: string; AlreadyValid: Boolean): Boolean;
    function ParseIEN(IEN: string): string;

    //    procedure CreateWardStockForFiveRightsOverride(ScannedDrugIEN: string; var CurFlowUID: string; var
    //      toBeWardStock: Pointer);
    //    {
    //      Uses method GetWardStockOrder to accumulate all the scanned additives and
    //      solutions and locate the orders that match the items scanned.  If the
    //      additives and solutions match more then order, the user will need to select
    //      the order they wish to give the wardstock item against.  Then checks to
    //      see if there is already a bag infusing, if so they are prompted to complete
    //      it.  Then the wardstock bag is marked infusing.
    //    }
  public
    //-OrderType: BCMA_Objects.TOrderTypes;   .OrderTypeID;
    MedOrder: TBCMA_MedOrder;
    SelectedMultiDoseItemIEN: string; {JK 7/2/2008}
    UASReason: string;
    MemComment: string;
    BagList: TStringList;

    VitalsInfo: string;
    PainInfo: string;

    UAS_LogState: TUASLogAction;
    UAS_WorkFlow: TWorkFlowType;
  end;

var
  frmFiveRights: TfrmFiveRights;

implementation

uses BCMA_Main;
//MFunStr;

var
  CurrentMedOrder: TBCMA_MedOrder;
  IVOkToProcess: Boolean;
  PiggyBackOkToProcess: Boolean;
  ManuallyEnteredDrugIEN: string;
  aIVBag: TBCMA_IVBags;
  CurFlowUID: string;
  toBeWardStock, //pointer to an order that correlates to the wardstock bag the user is trying to give
    nilPointer: Pointer;

  DispensedDrug: TBCMA_DispensedDrug = nil;
  {Added 4/27/2008 to support five rights override}
//  Mult_ScannedDrug: TBCMA_DispensedDrug; {Added 4/27/2008 to support five rights override}

{$R *.dfm}

procedure TfrmFiveRights.FormShow(Sender: TObject);
begin
  InitScreen;
  UAS_LogState := LA_OkToLog;
  UAS_WorkFlow := WF_UAS_Medication;
  IVOkToProcess := False;
  PiggyBackOkToProcess := False;
  edEnterBarCode.SetFocus;
end;

procedure TfrmFiveRights.InitScreen;
begin

  if not FiveRightsCheck then begin
    rbVerifyFiveRights.Enabled := False;
    rbVerifyFiveRights.Checked := False;
  end;

  TurnOffFiveRights;

  //-lblReturnedMedName.Caption := '';
  //-lblReturnedDosage.Caption := '';
  mmoDrugInfo.Clear; {JK 6/9/2008}
end;

procedure TfrmFiveRights.mmoDrugInfoEnter(Sender: TObject);
begin
  GetScreenReader.Speak(mmoDrugInfo.text); // rpk 9/7/2010
end;

procedure TfrmFiveRights.rbVerifyFiveRightsClick(Sender: TObject);
begin
  if rbVerifyFiveRights.Checked then begin
    TurnOffManualEntry;
    TurnOnFiveRights;
  end
  else begin
    TurnOnManualEntry;
    TurnOffFiveRights;
  end;
  btnOK.Enabled := False;
end;

procedure TfrmFiveRights.rbVerifyMedicationClick(Sender: TObject);
begin
  if rbVerifyMedication.Checked then begin
    TurnOnManualEntry;
    TurnOffFiveRights;
    if not ScreenReaderSystemActive then // rpk 9/2/2010
      edEnterBarCode.SetFocus;
  end
  else begin
    TurnOffManualEntry;
    TurnOnFiveRights;
  end;
  btnOK.Enabled := False;
end;

procedure TfrmFiveRights.btnCancelClick(Sender: TObject);
begin
  //  DefMessageDlg('Order Administration Cancelled!', mtWarning, [mbOK], 0); {JK 5/12/2008}
end;

procedure TfrmFiveRights.btnOKClick(Sender: TObject);
begin
  if rbVerifyMedication.Checked then begin
    case lstCurrentTab of
      ctPB: begin
          if PiggybackOKToProcess then
            ProcessPiggyback(ManuallyEnteredDrugIEN);
        end;
      ctIV: begin
          if IVOkToProcess then
            ProcessIV;
        end;
    end;
  end;

  if rbVerifyFiveRights.Checked then begin
    //if not ProcessViaFiveRightsLogic(MedOrder) then
    //  DefMessageDlg('Five Rights Override has been cancelled', mtInformation, [mbOK], 0);
    ProcessViaFiveRightsLogic(MedOrder);
    UAS_WorkFlow := WF_FIVERIGHTS;
  end;

end; // btnOKClick

function TfrmFiveRights.ParseIEN(IEN: string): string;
var
  i, Val: Integer;
  NonNumeric: Boolean;
begin
  NonNumeric := False;

  for i := 1 to Length(IEN) do try
    Val := StrToInt(IEN[i]);
  except
    on EConvertError do
      NonNumeric := True;
  end;

  if NonNumeric then
    Result := ''
  else
    Result := IEN;

end;

procedure TfrmFiveRights.btnSubmitClick(Sender: TObject);
var
  i: Integer;
  //  tempIVBag: TBCMA_IVBags;
  tempstr: string;
  isScannedDrugValid: Boolean;
begin

  mmoDrugInfo.Clear;

  if MedOrder.OrderTypeID = otUnitDose then begin

    ManuallyEnteredDrugIEN := ParseIEN(Trim(edEnterBarCode.Text));

    if ManuallyEnteredDrugIEN = '' then begin
      DefMessageDlg('When typing a bar code, enter numeric values only (omit non-numeric characters).',
        mtWarning, [mbOK], 0);
      edEnterBarCode.Enabled := True;
      edEnterBarCode.SetFocus;
      Exit;
    end
    else begin

      mmoDrugInfo.Visible := True; {JK 6/9/2008}
      isScannedDrugValid :=
        BCMA_ScannedDrug.isValidDrug(ManuallyEnteredDrugIEN);
      if isScannedDrugValid and
        ((MedOrder.OrderedDrugIENS[0] = ManuallyEnteredDrugIEN) or
        (SelectedMultiDoseItemIEN = ManuallyEnteredDrugIEN)) then begin

        {JK 7/24/2008 - CQ #137 & #147}
        if SelectedMultiDoseItemIEN <> '' then
          if SelectedMultiDoseItemIEN <> ManuallyEnteredDrugIEN then begin

            DefMessageDlg('Invalid Medication Lookup.' + #13#10#13#10 +
              'DO NOT GIVE!', mtError, [mbOK], 0
{$IFDEF R1224198}
              , '', True
{$ENDIF}              
              );
            mmoDrugInfo.Lines.Add('Invalid Medication Lookup. DO NOT GIVE!');

            PiggyBackOkToProcess := False;
            btnOK.Enabled := False;
            edEnterBarCode.Enabled := True;
            edEnterBarCode.SetFocus;
            Exit;
          end;

        btnOK.Enabled := True;
        edEnterBarCode.Enabled := False;
        btnSubmit.Enabled := False;
        rbVerifyFiveRights.Enabled := False;

        with mmoDrugInfo.Lines do begin
          Add(bcma_scanneddrug.Name); {JK 6/9/2008}
          Add('');
          Add('Dosage: ' + MedOrder.Dosage);
          if MedOrder.OrderedDrugCount = 1 then
            Add('Units/Dose: ' + MedOrder.OrderedDrugs[0].QtyOrderedText)
          else
            Add('Units/Dose: ***Multiple Dispensed Drugs:');
          Add('Route: ' + MedOrder.Route);
//          Add('Special Instructions: ' + MedOrder.SpecialInstructions);
          tempstr := MedOrder.GetSIOPIText; // rpk 1/19/2012
          Add('Special Instructions: ' + tempstr); // rpk 1/19/2012
        end;
        mmoDrugInfo.Perform(WM_VSCROLL, SB_TOP, 0);
        //Put the list back up to the top
        mmoDrugInfo.SelStart := 0; // rpk 9/2/2010

        if ScreenReaderSystemActive then
          mmoDrugInfo.SetFocus
        else
          btnOK.SetFocus;

      end
      else begin

        if isScannedDrugValid and
          ((MedOrder.OrderedDrugIENS[0] <> ManuallyEnteredDrugIEN) or
          (SelectedMultiDoseItemIEN <> ManuallyEnteredDrugIEN)) then
          DefMessageDlg('Invalid medication lookup.' + #13#10#13#10 +
            'DO NOT GIVE!', mtError, [mbOK], 0
{$IFDEF R1224198}
              , '', True
{$ENDIF}              
            );

        mmoDrugInfo.Lines.Add('Invalid Medication Lookup. DO NOT GIVE!');
        btnOK.Enabled := False;
        edEnterBarCode.Enabled := True;
        edEnterBarCode.SetFocus;
      end;
    end;

  end
  else if MedOrder.OrderTypeID = otIV then begin

    ManuallyEnteredDrugIEN := Trim(edEnterBarCode.Text);

    case lstCurrentTab of
      ctPB: begin
          aIVBag := nil;

          for i := 0 to MedOrder.UniqueIDs.Count - 1 do
            if ManuallyEnteredDrugIEN = piece(MedOrder.UniqueIDs[i], '^', 1)
              then begin
              tempstr := BCMA_Patient.LoadIVBags(MedOrder.OrderNumber);
// NOTE: include test on ResultStr returned
// from RebuildIVOrderHistory:
//    if piece(ResultStr, '^', 1) = '-1' then
//      FraIV1.lblIVHistory.Caption := piece(ResultStr, '^', 2)
//    else
//      IVHistoryDates := IVBags;
              aIVBag :=
                BCMA_Patient.GetIVBagFromUniqueID(ManuallyEnteredDrugIEN);
              Break;
            end;

          if aIVBag <> nil then begin
            if CheckIfValidBag(aIVBag) then begin
              ScannedInput := ManuallyEnteredDrugIEN;
              {JK 5/1/2008 - had to fill a global variable (not a smart way to code but this was inherited)}
              PiggyBackOkToProcess := True;
              btnOK.Enabled := True;
              edEnterBarCode.Enabled := False;
              btnSubmit.Enabled := False;
              rbVerifyFiveRights.Enabled := False;

              with mmoDrugInfo.Lines do begin {6/9/2008}
                mmoDrugInfo.Clear;
                mmoDrugInfo.Visible := True;
                Add('IV Piggyback Bag: ' + ManuallyEnteredDrugIEN); {JK 6/9/2008}
                Add('');
                Add('Infusion Rate: ' + MedOrder.Dosage);
                Add(BuildBagInfoAsString(aIVBag, MedOrder));

//                Add('Other Print Info: ' + MedOrder.SpecialInstructions);
                tempstr := MedOrder.GetSIOPIText; // rpk 2/29/2012
                Add('Other Print Info: ' + tempstr); // rpk 2/29/2012

              end;

              mmoDrugInfo.Perform(WM_VSCROLL, SB_TOP, 0);
              //Put the list back up to the top
              mmoDrugInfo.SelStart := 0; // rpk 9/2/2010
//              GetScreenReader.Speak(mmoDrugInfo.text);  // rpk 9/6/2010

              btnOK.SetFocus;
            end
            else begin
              edEnterBarCode.Enabled := True;
              edEnterBarCode.SetFocus;
            end;

          end
          else begin
            //DefMessageDlg('Could NOT validate IVP/IVPB: ' +
            //     ManuallyEnteredDrugIEN + #13#13 +
            //     'DO NOT GIVE!', mtError, [mbOK], 0);

            DefMessageDlg('Invalid Medication Lookup.' + #13#10#13#10 +
              'DO NOT GIVE!', mtError, [mbOK], 0
{$IFDEF R1224198}
              , '', True
{$ENDIF}              
              );
            mmoDrugInfo.Lines.Add('Invalid Medication Lookup. DO NOT GIVE!');

            PiggyBackOkToProcess := False;
            btnOK.Enabled := False;
            edEnterBarCode.Enabled := True;
            edEnterBarCode.SetFocus;
          end; {if aIVBag = nil}
        end;

      ctIV: begin
          aIVBag := GetIVBagFromHistory(ManuallyEnteredDrugIEN);

          if CheckIfValidBag(aIVBag) then begin
            IVOkToProcess := True;
            btnOK.Enabled := True;
            edEnterBarCode.Enabled := False;
            btnSubmit.Enabled := False;
            rbVerifyFiveRights.Enabled := False;

            with mmoDrugInfo.Lines do begin {6/9/2008}
              mmoDrugInfo.Clear;
              mmoDrugInfo.Visible := True;
              Add('IV Bag: ' + aIVBag.UniqueID); {JK 6/9/2008}
              Add('');
              Add('Infusion Rate: ' + MedOrder.Dosage);
              Add(BuildBagInfoAsString(aIVBag, MedOrder));
//              Add('Other Print Info: ' + MedOrder.SpecialInstructions);
              tempstr := MedOrder.GetSIOPIText; // rpk 2/29/2012
              Add('Other Print Info: ' + tempstr); // rpk 2/29/2012
            end;
            mmoDrugInfo.Perform(WM_VSCROLL, SB_TOP, 0);
            //Put the list back up to the top
            mmoDrugInfo.SelStart := 0; // rpk 9/2/2010
//            GetScreenReader.Speak(mmoDrugInfo.text);  // rpk 9/6/2010

            btnOK.SetFocus;

          end
          else begin
            if aIVBag <> nil then begin
              if (aIVBag.ScanStatus = 'H') or
                (aIVBag.ScanStatus = 'R') or
                (aIVBag.ScanStatus = 'M') then begin {JK 7/31/2008 'M' item = CQ #168}
                {JK 7/10/2008 CQ Ticket #109}
                IVOkToProcess := True;
                btnOK.Click;
              end
              else begin
                IVOkToProcess := False;
                btnOK.Enabled := False;
                edEnterBarCode.Enabled := True;
                edEnterBarCode.SetFocus;
              end;
            end
            else begin
              IVOkToProcess := False;
              btnOK.Enabled := False;
              edEnterBarCode.Enabled := True;
              edEnterBarCode.SetFocus;

            end;
          end;
        end;
    end;
  end;
end;

function TfrmFiveRights.BuildBagInfoForDisplay(IVBag: TBCMA_IVBags; aMedOrder:
  TBCMA_MedOrder): string;
var
  i: Integer;
begin
  Result := 'IV Bag Number: ' + IVBag.UniqueID + #13#10#13#10;
  Result := Result + 'Route: ' + aMedOrder.Route + #13#10#13#10;
  Result := Result + 'Is the following list of additives and solutions correct? '
    + #13#10 +
    'Click Yes if correct or No to cancel' + #13#10#13#10;
  Result := Result + 'Additives: ' + #13#10;

  for i := 0 to IVBag.Additives.Count - 1 do
    Result := Result + piece(IVBag.Additives[i], '^', 3) + ', ' +
      piece(IVBag.Additives[i], '^', 4) + ', ' +
      piece(IVBag.Additives[i], '^', 5) + #13#10;

  Result := Result + #13#10 + 'Solutions:' + #13#10;

  for i := 0 to IVBag.Solutions.Count - 1 do
    Result := Result + piece(IVBag.Solutions[i], '^', 3) + ', ' +
      piece(IVBag.Solutions[i], '^', 4) + #13#10;
end;

function TfrmFiveRights.BuildBagInfoAsString(IVBag: TBCMA_IVBags; aMedOrder:
  TBCMA_MedOrder): string;
var
  i: Integer;
begin
  Result := 'Route: ' + aMedOrder.Route + #13#10;
  Result := Result + 'Additives: ';

  for i := 0 to IVBag.Additives.Count - 1 do
    Result := Result + piece(IVBag.Additives[i], '^', 3) + ', ' +
      piece(IVBag.Additives[i], '^', 4) + ', ' +
      piece(IVBag.Additives[i], '^', 5) + #13#10;

  Result := Result + 'Solutions: ';

  for i := 0 to IVBag.Solutions.Count - 1 do
    Result := Result + piece(IVBag.Solutions[i], '^', 3) + ', ' +
      piece(IVBag.Solutions[i], '^', 4) + #13#10;
end;

procedure TfrmFiveRights.cbRightDoseClick(Sender: TObject);
begin
  CanOKBtnBeEnabled;
end;

procedure TfrmFiveRights.cbRightMedicationClick(Sender: TObject);
begin
  CanOKBtnBeEnabled;
end;

procedure TfrmFiveRights.cbRightPatientClick(Sender: TObject);
begin
  CanOKBtnBeEnabled;
end;

procedure TfrmFiveRights.cbRightRouteClick(Sender: TObject);
begin
  CanOKBtnBeEnabled;
end;

procedure TfrmFiveRights.cbRightTimeClick(Sender: TObject);
begin
  CanOKBtnBeEnabled;
end;

function TfrmFiveRights.FiveRightsCheck: Boolean;
begin
  Result := False; // rpk 4/23/2009

  if MedOrder.OrderTypeID = otUnitDose then
    Result := BCMA_Common.BCMA_SiteParameters.FiveRightsUnitDose
  else if MedOrder.OrderTypeID = otIV then
    Result := BCMA_Common.BCMA_SiteParameters.FiveRightsIV;

end;

procedure TfrmFiveRights.TurnOnFiveRights;
begin
  cbRightPatient.Enabled := True;
  cbRightMedication.Enabled := True;
  cbRightDose.Enabled := True;
  cbRightRoute.Enabled := True;
  cbRightTime.Enabled := True;

  pnlFiveRights.Enabled := True;

end;

procedure TfrmFiveRights.TurnOffFiveRights;
begin
  cbRightPatient.Enabled := False;
  cbRightPatient.Checked := False;

  cbRightMedication.Enabled := False;
  cbRightMedication.Checked := False;

  cbRightDose.Enabled := False;
  cbRightDose.Checked := False;

  cbRightRoute.Enabled := False;
  cbRightRoute.Checked := False;

  cbRightTime.Enabled := False;
  cbRightTime.Checked := False;

  pnlFiveRights.Enabled := False;
end;

procedure TfrmFiveRights.TurnOnManualEntry;
begin
  pnlVerifyMedication.Enabled := True;
  edEnterBarCode.Enabled := True;
  edEnterBarCode.Text := '';
  edEnterBarCode.Color := clWhite;
  btnSubmit.Enabled := True;

  //-lblReturnedMedName.Enabled := True;
  //-lblReturnedMedName.Caption := '';
  //-lblReturnedDosage.Enabled  := True; {JK 6/9/2008}
  //-lblReturnedDosage.Caption := '';
//  lblLine1.Enabled := True;
//  lblLine2.Enabled := True;
  lblEnterBarCode.Enabled := True;
  //-lblLine3.Enabled := True;
  mmoDrugInfo.Visible := True; {JK 6/9/2008}
  mmoDrugInfo.Clear;

  rbVerifyFiveRights.Checked := False;
end;

procedure TfrmFiveRights.TurnOffManualEntry;
begin
  pnlVerifyMedication.Enabled := False;
  edEnterBarCode.Enabled := False;
  edEnterBarCode.Text := '';
  edEnterBarCode.Color := clbtnFace;
  btnSubmit.Enabled := False;

  //-lblReturnedMedName.Enabled := False;
  //-lblReturnedMedName.Caption := '';

  //-lblReturnedDosage.Enabled := False;  {JK 6/9/2008}
  //-lblReturnedDosage.Caption := '';

  mmoDrugInfo.Visible := False; {JK 6/9/2008}
  mmoDrugInfo.Clear;

  //  lblLine1.Enabled := False;
  //  lblLine2.Enabled := False;
    //-lblLine3.Enabled := False;
  lblEnterBarCode.Enabled := False;

  rbVerifyFiveRights.Checked := True;

end;

procedure TfrmFiveRights.CanOKBtnBeEnabled;
var
  cnt: Integer;
begin
  cnt := 0;

  if cbRightPatient.Checked then
    Inc(Cnt);
  if cbRightMedication.Checked then
    Inc(Cnt);
  if cbRightDose.Checked then
    Inc(Cnt);
  if cbRightRoute.Checked then
    Inc(Cnt);
  if cbRightTime.Checked then
    Inc(Cnt);

  if Cnt = 5 then
    btnOK.Enabled := True
  else
    btnOK.Enabled := False;

end;

function TfrmFiveRights.UASExecute(ScanType: Integer; aMedOrder: TBCMA_MedOrder;
  EnteredNum: string;
  DispensedDrug: TBCMA_DispensedDrug = nil): Boolean;
{
ScanTypes:
  0 = wristband
  1 = Administration
}
var
  //  x: integer;
  //  IVString,
  UnableToScanString: string;
  //  KeyStroke: Char;
  //  tempIVBag: TBCMA_IVBags;
  //  MyIcon: TIcon;
  //  TempObject: TObject;
begin
  CurrentMedOrder := aMedOrder;
  Result := False; // rpk 4/23/2009

  with aMedOrder do begin
    {retreive IV specific data}
    if OrderTypeID = otIV then
      case lstCurrentTab of
        ctPB: begin
            if frmMain.isValidScannedDrug(ScannedInput, False, False, '', '')
              then
              frmMain.RebuildVirtualDueList(False);
          end;
        ctIV: begin
            ScannedInput := EnteredNum; //jk 4/23/2008
          end;
      end {case}

        {retrieve UD specific Data}
    else begin

      if (OrderedDrugCount <> 1) or
        (OrderedDrugs[0].QtyOrdered <> 1) or
        (pos('.', OrderedDrugs[0].QtyOrderedText) <> 0) then begin
        ;
      end;
    end;
  end;

  //  if (ScanType = 0) and Result then begin
  if (ScanType = 0) then begin // Result was not set prior to this statement
    with TfrmPtSelect.create(application) do try
      ShowModal;
    finally
//      free;
      Release; // rpk 6/18/2013
    end;
    if BCMA_Patient.IEN <> '' then begin
      if rbVerifyFiveRights.Checked then
        LogUnableToScan('', UASReason,
          BuildCommentLine('[Verify Five Rights Selected]', memComment), '', 'W')
      else
        LogUnableToScan('', UASReason, memComment, '', 'W');
      UAS_LogState := LA_AlreadyLogged;
    end;
  end
  else if (ScanType = 1) then begin
    with aMedOrder do
      if OrderTypeID = otIV then
        UnableToScanString := 'ID^' + ScannedInput
      else begin
        if DispensedDrug <> nil then
          UnableToScanString := 'DD^' + DispensedDrug.IEN
        else
          UnableToScanString := 'DD^' + OrderedDrugs[0].IEN;
      end;

    if rbVerifyFiveRights.Checked then
      BCMA_Common.LogUnableToScan(aMedOrder.OrderNumber, UASReason,
        '[Verify Five Rights Override Selected]' + MSF_Report_CR + memComment,
        UnableToScanString, 'M')
    else
      BCMA_Common.LogUnableToScan(aMedOrder.OrderNumber, UASReason, memComment,
        UnableToScanString, 'M');

    UAS_LogState := LA_AlreadyLogged;
  end;
  Result := True;
end; // UASExecute

procedure TfrmFiveRights.ProcessIV;
var
  scanivret: Boolean;
begin
  scanivret := False;
  if UASExecute(1, MedOrder, ManuallyEnteredDrugIEN) then begin

    toBeWardStock := nil;

    if aIVBag <> nil then begin

      if frmMain.ScanIV(ManuallyEnteredDrugIEN, atScan, CurFlowUID,
        toBeWardStock) then begin
        // both main unable-to-scan routines check for and complete a currently
        // infusing bag before calling UnableToScanExecute.  The following code
        // may not be executed.  rpk 7/6/2011

        scanivret := True; // rpk 6/30/2011


        {If a Unique ID (CurFlowUID) is returned, or a pointer to
         an order (toBeWardStock) is returned, then the first scan encountered a bag already
         infusing.

         If CurFlowUID is not null, then this contains the unigue id of the currently
         infusing bag.

         If CurFlowUID is not null, and the first scan was a wardstock bag,
         AND a bag is currently infusing, toBeWardStock will contain a pointer
         to the order that matches the scanned additives and solutions.

         ScannedInput will hold the Unique ID the original scan, if it wasn't a ward stock}

        if (CurFlowUID <> '') or (toBeWardStock <> nil) then begin

          {second scan, scan the currently infusing bag}
          if frmMain.ScanIV(CurFlowUID, atScan, CurFlowUID, nilPointer) then begin
            scanivret := True; // rpk 6/30/2011
            {afterwards, go back and scan the original bag via the Unique ID}
            if toBeWardStock = nil then
              scanivret := frmMain.ScanIV(ManuallyEnteredDrugIEN, atScan, CurFlowUID,
                toBeWardStock)
            else
              scanivret := frmMain.ScanIV('', atScan, CurFlowUID, toBeWardStock);
          end
          else
            scanivret := False; // rpk 6/30/2011
        end;

        Self.Repaint;
        frmMain.RebuildVirtualDueList(False);

        //-UASExecute(1, MedOrder, ManuallyEnteredDrugIEN);
        if not scanivret then
          UAS_LogState := LA_CANCELLED; // rpk 6/30/2011

      end
      else begin
        // ScanIV will display admin cancelled message
//        DefMessageDlg('Order Administration Cancelled!', mtWarning, [mbOK], 0);
        {JK 5/12/2008}
        UAS_LogState := LA_CANCELLED;
        btnOK.Enabled := False;
      end;
    end;
  end;
end; // ProcessIV

procedure TfrmFiveRights.ProcessPiggyback(IEN: string);
begin
  if frmMain.isValidScannedDrug(IEN, True, isPRNCancelled, VitalsInfo, PainInfo)
    then begin
    frmMain.RebuildVirtualDueList(False);
    UAS_LogState := LA_OkToLog;
  end
  else begin
    DefMessageDlg('Order Administration Cancelled!', mtWarning, [mbOK], 0);
    {JK 5/12/2008}{JK added back 11/4/2008}
    UAS_LogState := LA_CANCELLED;
    btnOK.Enabled := False;
  end;
end; // ProcessPiggyback


function TfrmFiveRights.CheckIfValidBag(IVBag: TBCMA_IVBags): Boolean;
begin
  Result := False;

  if IVBag <> nil then begin

    if IVBag.ScanStatus = 'I' then
      frmMain.ScanIV(IVBag.UniqueID, atScan, CurFlowUID, toBeWardStock)

    else if IVBag.ScanStatus = 'S' then
      frmMain.ScanIV(IVBag.UniqueID, atScan, CurFlowUID, toBeWardStock)

    else if IVBag.ScanStatus = 'C' then
      DefMessageDlg('IV BAG ' + IVBag.UniqueID + ' HAS COMPLETED', mtWarning,
        [mbOK], 0)

    else if IVBag.ScanStatus = 'A' then
      if DefMessageDlg(BuildBagInfoForDisplay(IVBag, MedOrder), mtConfirmation,
        [mbYes, mbNo], 0) = mrYes then
        Result := True;

  end
  else begin
    //-lblReturnedMedName.Caption := '';
    //-lblReturnedDosage.Caption  := '';  {JK 6/9/2008}
    mmoDrugInfo.Clear; {JK 6/9/2008}
    btnOK.Enabled := False;
    DefMessageDlg('INVALID IV BAG - DO NOT GIVE', mtWarning, [mbOK], 0
{$IFDEF R1224198}
      , '', True
{$ENDIF}              
      );
  end;

end; // CheckIfValidBag

procedure TfrmFiveRights.edEnterBarCodeKeyPress(Sender: TObject; var Key: Char);
begin
  {disable Cut and Past}
  if key = #22 then
    key := #0;

  if edEnterBarCode.Text <> '' then
    if key = chr(VK_RETURN) then begin
      edEnterBarCode.Enabled := False;
      btnSubmit.Click;
    end
    else
      edEnterBarCode.Enabled := True;

end;

//
// NOTE: rename input parameter MedOrder to something different from public MedOrder
//

function TfrmFiveRights.ProcessViaFiveRightsLogic(inMedOrder: TBCMA_MedOrder):
  boolean;
const
  CRLF = #13#10;
var
  AdditiveList: string;
  SolutionList: string;
  DisplayList: string;
  i: Integer;
  UnableToScanString: string;
  //  CurFlowUID: String;
  //  toBeWardStock: Pointer;
  WardStockBagName: string;
  RouteText: string;
begin
  with inMedOrder do begin
    if OrderTypeID = otUnitDose then begin
      {SRS 3.2.2.2, 6.b.iii}
      { If the new BCMA "5 Rights Override" site parameter for Unit Dose
        medications is checked, and override mechanism will allow the nurse to
        document that the five rights of medication administration have been
        physically verified (right patient, right mediciation, right dose,
        right route, right time) and continue with the medication administration
        within the existing workflow -- without entering a matching bar code
        number of the medication. [per CCB ruling on CR#4] }
      Result := True;
    end
    else begin

      {SRS 3.2.2.3, 6.b.iii}

      { 1) Automatically build a list of IV bag components, based on the additives
           and solutions in the selected order. }

      { 2) Display the IV bag component list and prompt the user with a
           confirmation message. }

      { 3) Create and log the WS number in the med log and post an automatic
           comment to the file, such as "Bag built during Unable to scan event". }

      Result := False;

      AdditiveList := 'Additives:' + CRLF;

      for i := 0 to inMedOrder.Additives.Count - 1 do begin
        AdditiveList := AdditiveList + '  ' + piece(inMedOrder.Additives[i], '^',
          3) + ' ' +
          piece(inMedOrder.Additives[i], '^', 4) + CRLF;
        ScanDrug(piece(inMedOrder.Additives[i], '^', 1), True);
      end;

      SolutionList := 'Solutions:' + CRLF;

      for i := 0 to inMedOrder.Solutions.Count - 1 do begin
        SolutionList := SolutionList + '  ' + piece(inMedOrder.Solutions[i], '^',
          3) +
          piece(inMedOrder.Solutions[i], '^', 4) + CRLF;
        ScanDrug(piece(inMedOrder.Solutions[i], '^', 1), True);
      end;

      DisplayList := 'IV Bag Components' + CRLF + CRLF +
        AdditiveList + CRLF +
        SolutionList + CRLF + CRLF +
        'Click Yes to confirm.';

      if DefMessageDlg(DisplayList, mtConfirmation, [mbYes, mbCancel], 0) = mrYes
        then begin

        frmMain.CreateWardStockForFiveRightsOverride(inMedOrder, WardStockBagName,
          UAS_LogState, VitalsInfo, PainInfo);

        //-        if (WardStockBagName = '') and (lstCurrentTab = ctIV) then begin

                  //-UAS_LogState := LA_Cancelled;
        //-          Result := False;

        //-        end else begin
        if UAS_LogState = LA_OkToLog then begin

          {try
            UnableToScanString := 'ID^' +
              TBCMA_IVBAGS(IVHistoryDates.Items[0]).UniqueID;
          except
            // 5 Rights Override on a non-iv item
            if MedOrder.AdministrationUnit = 'P' then
              UnableToScanString := 'ID^'
            else
              UnableToScanString := 'ID^' + WardStockBagName;
          end;}

          // modified above code to avoid exception on empty IVHistoryDates
          // rpk 2/25/2011
          try
            if IVHistoryDates.Count > 0 then
              UnableToScanString := 'ID^' +
                TBCMA_IVBAGS(IVHistoryDates.Items[0]).UniqueID
            else begin
              {5 Rights Override on a non-iv item}
              if inMedOrder.AdministrationUnit = 'P' then
                UnableToScanString := 'ID^'
              else
                UnableToScanString := 'ID^' + WardStockBagName;
            end;
          except
            {5 Rights Override on a non-iv item}
            if inMedOrder.AdministrationUnit = 'P' then
              UnableToScanString := 'ID^'
            else
              UnableToScanString := 'ID^' + WardStockBagName;
          end;
          //            LogUnableToScan(MedOrder.OrderNumber,
          //                            UASReason,
          //                            'IV Bag ' + WardStockBagName + ' built during Unable To Scan event (Verify Five Rights Override Selected)',
          //                            UnableToScanString,
          //                            'M');

                      {JK 8/14/2008}
          if inMedOrder.Route = 'IV PIGGYBACK' then
            RouteText := 'IVPB'
          else
            RouteText := 'IV';

          {JK 7/23/2008 - Get the newly added WS order from the ivHistoryDates list.  It is always
           item zero.}
          {try
            LogUnableToScan(MedOrder.OrderNumber,
              UASReason,
              BCMA_Common.BuildCommentLine('[' + RouteText + ' Bag ' +
              TBCMA_IVBAGS(IVHistoryDates.Items[0]).UniqueID +
              ' built during UTS - Verify 5 Rights Override]', MemComment),
              UnableToScanString,
              'M');
          except
            LogUnableToScan(MedOrder.OrderNumber,
              UASReason,
              BuildCommentLine('[' + RouteText +
              ' Bag built during UTS - Verify 5 Rights Override]', MemComment),
              UnableToScanString,
              'M');
          end;}

          // modified above code to avoid exception on empty IVHistoryDates
          // rpk 2/25/2011
          try
            if IVHistoryDates.Count > 0 then
              LogUnableToScan(inMedOrder.OrderNumber, UASReason,
                BCMA_Common.BuildCommentLine('[' + RouteText + ' Bag ' +
                TBCMA_IVBAGS(IVHistoryDates.Items[0]).UniqueID +
                ' built during UTS - Verify 5 Rights Override]', MemComment),
                UnableToScanString, 'M')
            else
              LogUnableToScan(inMedOrder.OrderNumber, UASReason,
                BuildCommentLine('[' + RouteText +
                ' Bag built during UTS - Verify 5 Rights Override]', MemComment),
                UnableToScanString, 'M');
          except
            LogUnableToScan(inMedOrder.OrderNumber,
              UASReason,
              BuildCommentLine('[' + RouteText +
              ' Bag built during UTS - Verify 5 Rights Override]', MemComment),
              UnableToScanString, 'M');
          end;
          UAS_LogState := LA_AlreadyLogged;
          Result := True;
        end
        else
          Result := False;
        //-        end;

      end
      else begin
        DefMessageDlg('Order Administration Cancelled!', mtWarning, [mbOK], 0);
        {JK 5/12/2008}
        UAS_LogState := LA_CANCELLED;
        btnOK.Enabled := False;
      end;
    end;
  end;
end; // ProcessFiveRightsLogic

function TfrmFiveRights.ScanDrug(ScanIEN: string; AlreadyValid: Boolean):
  Boolean;
var
  zAdditives, zSolutions: TStringList;
begin
  zAdditives := TStringList.Create;
  zSolutions := TStringList.Create;
  try

    with BCMA_ScannedDrug do begin
      if AlreadyValid = False then
        if not isValidDrug(ScanIEN) then begin
          Result := False;
          Exit
        end;
      if piece(ResultString, '^', 1) = 'ADD' then
        zAdditives.Add(ResultString)
      else if
        piece(ResultString, '^', 1) = 'SOL' then
        zSolutions.Add(ResultString);

      //-lstWardStock.Items.Add(BCMA_ScannedDrug.Name + ', ' + Dose);
      Result := True;

    end;

  finally
    zAdditives.Free;
    zSolutions.Free;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmFiveRights);

end.

