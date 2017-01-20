unit MultipleDrugs;
{
================================================================================
*	File:  MultipleDrugs.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 28 $  $Modtime: 12/11/01 4:55p $
*
*	Description:  This is a form for displaying multiple ordered drugs for a
*               MedOrder.  This form is used to display additional drugs,
*               after the first was scanned on the main form.
*
*	Notes:
*
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, BCMA_Objects, CheckLst, Menus, Buttons,
  VA508AccessibilityManager, VA508AccessibilityRouter;

type

  TMultiDoseType = (mdtSingleFractionalDose,
    mdtSingleDose,
    mdtMultipleDose);                   {JK 9/11/2008}

  TfrmMultipleDrugs = class(TForm)
    (*
      This is a form for scanning multiple ordered drugs for a MedOrder.
    *)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlScannerStatus: TPanel;
    pnlScannerIndicator: TPanel;
    btnCancel: TButton;
    btnDone: TButton;
    Panel4: TPanel;
    pnlDoses: TPanel;
    clbxDoses: TCheckListBox;
    pnlComments: TPanel;
    mmoComments: TMemo;
    pnlScannerInput: TPanel;
    edtScannerInput: TEdit;
    btnEnableScanner: TButton;
    Panel5: TPanel;
    mmoSpecialInstructions: TMemo;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblScannerStatusCaption: TLabel;
    Label6: TLabel;
    lblActiveMedicationCaption: TLabel;
    lblSpecInstr: TLabel;
    lblDosageUnits: TLabel;
    lblDosageOrderedCaption: TLabel;
    lblEnterComment: TLabel;
    txtActiveMedication: TVA508StaticText;
    txtDosage: TVA508StaticText;
    lblScannerStatus: TVA508StaticText;
    pnlScrollDown: TPanel;
    lblScrollDown: TStaticText;
    btnDisplaySIOPI: TButton;

    procedure BitBtn1Click(Sender: TObject);
    {JK 5/20/2008 - holds up to 100 queued unable to scan records per med order}

    procedure clbxDosesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    (*
      Allocates memory and initializes variables.
    *)

    procedure FormDestroy(Sender: TObject);
    (*
      Frees memory allocated.
    *)

    procedure FormShow(Sender: TObject);
    (*
      Fills the form's fields with property values from the current
      Medication Order, fills the listbox with the Ordered Drugs to be
      scanned and marks the first scanned drug as given.  Focus is then set
      to the edtScannerInput field.
    *)

    procedure MD_ButtonClick(Sender: TObject);
    (*
      JK 4/15/2008  Event handler for the button in the CheckListBox
    *)

    procedure edtScannerInputEnter(Sender: TObject);
    (*
      Sets pnlScannerIndicator.Color to clLime and sets
      lblScannerStatusReady.Caption to 'Ready', indicating that the scanner
      is ready to receive input.
    *)

    procedure edtScannerInputExit(Sender: TObject);
    (*
      Sets pnlScannerIndicator.Color to clRed and sets
      lblScannerStatusReady.Caption to 'Not Ready', indicating that the
      scanner is not ready to receive input.
    *)

    procedure edtScannerInputKeyPress(Sender: TObject; var Key: Char);
    (*
      Waits for an <Enter> key, then calls method MarkDrugAsGiven to validate
      the edtScannerInput.text value.
    *)

    procedure pnlScannerIndicatorClick(Sender: TObject);
    (*
      Sets focus to field edtScannerInput.
    *)

    procedure mmoSpecialInstructionsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    (*
      Resets focus back to field edtScannerInput.
    *)

    procedure clbxDosesEnter(Sender: TObject);
    (*
      Resets focus back to field edtScannerInput.
    *)

    procedure clbxDosesClickCheck(Sender: TObject);
    (*
      Reverses all check events, preventing the use of the mouse to check or
      uncheck list items.
    *)

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    {
      Checks sets CanClose = CloseFrm, then sets CloseFrm = True
    }

    procedure btnDoneClick(Sender: TObject);
    {
      Sets CloseFrm = True, checks to see edtScannerInput has data in it,
      if not null, then call method MarkDrugAsGiven
    }

    function QueueLogUnableToScan(
      MedOrderNumber,
      ResultTxt,
      CommentTxt,
      UnableToScanString,
      UASType: string): Boolean;

    procedure btnCancelClick(Sender: TObject);
    procedure btnEnableScannerClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure mnuUnableToScanClick(Sender: TObject);
    procedure clbxDosesContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure mnuRightClickMenuPopup(Sender: TObject);
    procedure edtScannerInputKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtScannerInputKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mmoSpecialInstructionsEnter(Sender: TObject);
    procedure mmoCommentsEnter(Sender: TObject);
    procedure btnDisplaySIOPIClick(Sender: TObject);
    {
      set CloseFrm = True
    }

  private
    { Private declarations }
    ScanCount: integer;

    MOrderedDrugList: TList;            {JK 4/15/2008}

    arrQueuedUAS: array[1..100, 1..5] of string;
    {JK 5/20/2008 - queue UAS actions until the end of processing}

    procedure LogQueuedUAS;
    (*
       JK 5/20/2008 - writes queued UAS items
    *)

    function MarkDrugAsGiven(Idx: Integer; scanIEN: string): Boolean;
    (*
      Uses method BCMA_ScannedDrug.isValidDrug to ensure that scanIEN is a
      valid drug.  The Ordered Drug list is then searched for an unchecked
      drug with the same IEN.  If found, the count of the unchecked list
      items is decremented.  If the number of unchecked list items becomes
      zero, ModalResult is set to mrOK, closing the form.
      The IDX param indicates which item in the list of drugs is being
      marked as given.
    *)

    function CheckFractional: Boolean;

    function FindFirstUngivenDrug(IEN: string): Integer; {JK 4/18/2008}

    procedure InsertComment;            {JK 9/9/2008}

    function isFracSingleDoseAdministrationNeeded: Boolean; {JK 9/12/2008}

    function isPartialAdministrationGiven(i: Integer): Boolean; //bjr 8/3/2012

  public
    { Public declarations }
    MedOrder: TBCMA_MedOrder;
    Drugidx: integer;
  end;

var
  frmMultipleDrugs: TfrmMultipleDrugs;
  Mult_ScannedDrug: TBCMA_DispensedDrug;
  CloseFrm: Boolean;
  CancelBtn: Boolean;
  MultiDoseType: TMultiDoseType;
//  ScanComplete: Boolean;  //bjr 8/3/2012
//  lastdrugi: Integer;  //bjr 8/3/2012

implementation

{$R *.DFM}
uses
  BCMA_Startup,
  BCMA_Common,
//  MFunStr,
  fFractional,
  inputQry,
  BCMA_Util,
  fUnableToScan;

var
  ScanComplete: Boolean;                // rpk 2/11/2013
  lastdrugi: Integer;                   // rpk 2/11/2013

procedure TfrmMultipleDrugs.FormCreate(Sender: TObject);
var
  i, j: Integer;
begin
  Mult_ScannedDrug := TBCMA_DispensedDrug.create(BCMA_Broker);
  clbxDoses.Clear;
  ScanCount := 0;
  CloseFrm := True;
  MOrderedDrugList := TList.Create;     {JK 4/15/2008}
  i := 0;                               // rpk 4/23/2009
  j := 0;                               // rpk 4/23/2009

  lastdrugi := 0;                       // rpk 4/30/2013

  {JK 5/20/2008 - initialize the queued UAS array}
  try
    for i := 1 to High(arrQueuedUAS) do
      for j := 1 to 5 do
        arrQueuedUAS[i, j] := '';
  except
    on E: Exception do
      DefMessageDlg('MultipleDrugs Error: i = ' +
        IntToStr(i) + ', j = ' + IntToStr(j) + ' Msg = ' + E.Message,
        mtError, [mbOK], 0);
  end;

end;

procedure TfrmMultipleDrugs.FormDestroy(Sender: TObject);
begin
  Mult_ScannedDrug.free;
  MOrderedDrugList.Free;                {JK 4/15/2008}
end;

procedure TfrmMultipleDrugs.FormShow(Sender: TObject);
var
  iiDrugs,
    jjUnits,
    x,
    ii: integer;
  MD_Btn: TButton;                      {Multiple Drug Button}
  UD_Cnt: Integer;
begin
  //if tag = 1, then we have already been through here, so don't execute this code
  //again, or we'll mark a unit as given.

  if tag <> 1 then
    with MedOrder do
    begin
      tag := 1;

      //clear out any entered data
      for ii := 0 to OrderedDrugCount - 1 do
      begin
        OrderedDrugs[ii].QtyScanned := 0;
        OrderedDrugs[ii].QtyScannedText := '';
      end;

      CancelBtn := false;
      txtActiveMedication.caption := ActiveMedication + ' '; // rpk 7/28/2010
      //bjr 5/12/10 for BCMA00000425
      txtDosage.caption := Dosage + ' '; // rpk 7/28/2010

      //      mmoSpecialInstructions.Lines.Add(SpecialInstructions);
//      mmoSpecialInstructions.Text := SpecialInstructions; // rpk 10/2/2009
      SetSIOPIMemo(mmoSpecialInstructions); // rpk 1/4/2012
      mmoSpecialInstructions.SelStart := 0; // rpk 8/31/2010
      pnlScrollDown.Visible := mmoSpecialInstructions.Lines.Count > 6; // 3/12/2012

      //in case an early/late message was displayed prior to this screen, and comments
      //were entered, pick them up here.
      //mmoComments.Text := UserComments;

      UserComments2 := '';

      MultiDoseType := mdtMultipleDose; {JK 9/11/2008}

      {JK 9/11/2008}
      if (OrderedDrugCount = 1) and
        (strToFloat(OrderedDrugs[0].QtyOrderedText) < 1) then
        MultiDoseType := mdtSingleFractionalDose;

      if (OrderedDrugCount = 1) and
        (strToFloat(OrderedDrugs[0].QtyOrderedText) < 1) and not
        UnableToScan then
      begin
        Caption := 'Fractional Dose';
        pnlDoses.Visible := False;
        Height := Height - PnlDoses.Height;
        edtScannerInput.Enabled := False;

      end
      else

        for iiDrugs := 0 to OrderedDrugCount - 1 do
          if Pos('.', OrderedDrugs[iiDrugs].QtyOrderedText) <> 0 then
          begin
            Caption := 'Multiple/Fractional Dose';
            Break
          end;

      if OrderedDrugCount = 1 then
        lblDosageUnits.Caption := 'Dosage: ' + Dosage +
          '  Units per Dose: ' + OrderedDrugs[0].QtyOrderedText
      else
        lblDosageUnits.Caption := '***Multiple Dispensed Drugs:';

      UD_Cnt := 0;

      with clbxDoses do

        for iiDrugs := 0 to OrderedDrugCount - 1 do

          for jjUnits := 0 to OrderedDrugs[iiDrugs].QtyOrdered - 1 do

            if (jjUnits = OrderedDrugs[iiDrugs].QtyOrdered - 1) and
              (pos('.', OrderedDrugs[iiDrugs].QtyOrderedText) <> 0) then
            begin

              //-items.addObject('[Partial] ' + OrderedDrugs[iiDrugs].Name, OrderedDrugs[iiDrugs])
//              MOrderedDrugList.Insert(jjUnits, OrderedDrugs[iiDrugs]); {Store the ordered drugs object in a list
//                                                                        now that a button object is being stored
//                                                                        in the checklist box JK 4/15/2008}
              // (does this happen in practice?)
              if UD_Cnt >= MOrderedDrugList.Count then // rpk 2/5/2013
                ii := MOrderedDrugList.Add(OrderedDrugs[iiDrugs]) // rpk 2/5/2013
              else                      // rpk 2/5/2013
                MOrderedDrugList.Insert(UD_Cnt, OrderedDrugs[iiDrugs]);
              {Store the ordered drugs object in a list
            now that a button object is being stored
            in the checklist box JK 4/15/2008}
              MD_Btn := TButton.Create(Self);
              with MD_Btn do
              begin
                Parent := clbxDoses;
//                Left := 325;
                Left := 425;
                Height := clbxDoses.ItemHeight;
                Width := 100;
                Top := UD_Cnt * clbxDoses.ItemHeight;
                //jjUnits * clbxDoses.ItemHeight;
                Tag := UD_Cnt;          //jjUnits;
                OnClick := MD_ButtonClick;
                //-Name := 'btnMO_' + inttostr(jjUnits);
                Name := 'btnMO_' + inttostr(UD_Cnt);
                Enabled := False;
                Caption := 'Unable to Scan'; // + '-' + IntToStr(UD_Cnt);

                //-clbxDoses.items.InsertObject(jjUnits, '[Partial] ' + OrderedDrugs[iiDrugs].Name, MD_Btn);
                if UD_Cnt >= clbxDoses.items.Count then // rpk 2/5/2013
                  ii := clbxDoses.items.AddObject('[Partial] ' + // rpk 2/5/2013
                    OrderedDrugs[iiDrugs].Name, MD_Btn)
                else                    // rpk 2/5/2013
                  clbxDoses.items.InsertObject(UD_Cnt, '[Partial] ' +
                    OrderedDrugs[iiDrugs].Name, MD_Btn);
              end;
              Inc(UD_Cnt);

            end
            else
            begin

              MOrderedDrugList.Add(OrderedDrugs[iiDrugs]);

              MD_Btn := TButton.Create(Self);
              with MD_Btn do
              begin
                Parent := clbxDoses;
//                Left := 325;
                Left := 425;
                Height := clbxDoses.ItemHeight;
                Width := 100;
                Top := UD_Cnt * clbxDoses.ItemHeight;
                Tag := UD_Cnt;
                Name := 'btnMO_' + IntToStr(UD_Cnt);
                OnClick := MD_ButtonClick;
                Enabled := False;
                Caption := 'Unable to Scan'; // + '-' + IntToStr(UD_Cnt);
                if UD_Cnt >= clbxDoses.items.Count then // rpk 2/5/2013
                  ii := clbxDoses.items.AddObject(OrderedDrugs[iiDrugs].Name, MD_Btn) // rpk 2/5/2013
                else                    // rpk 2/5/2013
                  clbxDoses.items.InsertObject(UD_Cnt, OrderedDrugs[iiDrugs].Name,
                    MD_Btn);
              end;

              Inc(UD_Cnt);

            end;

      ScanCount := clbxDoses.items.count;

      if ScanCount > 1 then
        MultiDoseType := mdtMultipleDose; {JK 9/11/2008}

      for x := 0 to ScanCount - 1 do
        clbxDoses.ItemEnabled[x] := False;

      if not UnableToScan then
      begin
        //MarkDrugAsGiven(x, OrderedDrugIENs[Drugidx]); {Removed, JK 4/25/2008}
        MarkDrugAsGiven(Drugidx, OrderedDrugIENs[Drugidx]);
        if ModalResult = mrCancel then
        begin
          CloseFrm := True;
          btnDone.Enabled := False;
          mmoComments.Enabled := False;
          mmoComments.Color := clBtnFace;
          Exit;
        end;
      end;

      {JK 4/15/2008}
      for x := 0 to clbxDoses.items.count - 1 do
        if not clbxDoses.Checked[x] then
          TButton(clbxDoses.Items.Objects[x]).Enabled := True;

      {If we came in here via an Unable to Scan (or regardless), set to false after we marked it}
 //-     UnableToScan := False;    {removed 9/19/2008 JK}
    end;

  if edtScannerInput.Enabled then
    edtScannerInput.setFocus;
end;

procedure tfrmMultipleDrugs.MD_ButtonClick(Sender: TObject);
var
  ButtonIndex: Integer;
  ResultTxt, CommentTxt: string;
  ReturnVal: Boolean;
  UnableToScanString: string;
  PRNVitalsInfo: string;
  PRNPainInfo: string;
begin
  UnableToScan := True;

  PRNVitalsInfo := '';                  {JK 8/25/2008}
  PRNPainInfo := '';                    {JK 8/25/2008}

  if Sender is TButton then
  begin
    ButtonIndex := TButton(Sender).Tag;

    //if UnableToScanExecute(1, MedOrder, TBCMA_DispensedDrug(clbxDoses.items.objects[clbxDoses.ItemIndex])) then
    {JK 4/15/2008}
    UnableToScanExecute(1,
      WF_Normal_Multiple_UnitDose,
      nil,
      MedOrder,
      ResultTxt,
      CommentTxt,
      ReturnVal,
      PRNVitalsInfo,
      PRNPainInfo,
      TBCMA_DispensedDrug(MOrderedDrugList[ButtonIndex]));
    if ReturnVal then
    begin

      {JK 4/15/2008}
      if MarkDrugAsGiven(ButtonIndex,
        TBCMA_DispensedDrug(MOrderedDrugList[ButtonIndex]).IEN) then
      begin

        if MultiDoseType = mdtSingleFractionalDose then
          if not isFracSingleDoseAdministrationNeeded then
          begin
            ModalResult := mrCancel;
            //-btnCancelClick(self);
            Exit;
          end;

        {JK 5/20/2008}
        UnableToScanString := 'DD^' +
          TBCMA_DispensedDrug(MOrderedDrugList[ButtonIndex]).IEN;

        QueueLogUnableToScan(MedOrder.OrderNumber,
          ResultTxt,
          CommentTxt,
          UnableToScanString,
          'M');

        TButton(Sender).Enabled := False;
      end;
    end
    else
    begin
      if (MultiDoseType = mdtSingleFractionalDose) or (MultiDoseType =
        mdtSingleDose) then
      begin
        ModalResult := mrCancel;
        //btnCancelClick(self);
        Exit;
      end;
    end;
  end
  else
    Exception.Create('MultipleDrugs Error. Sender is not a TButton');

  UnableToScan := False;
end;

procedure TfrmMultipleDrugs.edtScannerInputEnter(Sender: TObject);
begin
  edtScannerInput.Clear;
  if edtScannerInput.Enabled then
    edtScannerInput.SetFocus;
  pnlScannerIndicator.Color := clLime;
//  lblScannerStatusReady.Caption := 'Ready';
  lblScannerStatus.Caption := 'Ready';
  //msf disasble
{$IFDEF MSF_ON}
  btnEnableScanner.Enabled := False;
{$ENDIF}
  StopKeyboardTimer;
end;

procedure TfrmMultipleDrugs.edtScannerInputExit(Sender: TObject);
begin
  pnlScannerIndicator.Color := clRed;
//  lblScannerStatusReady.Caption := 'Not Ready';
  lblScannerStatus.Caption := 'Not Ready';
  //msf disable
{$IFDEF MSF_ON}
  btnEnableScanner.Enabled := True;
{$ENDIF}
end;

function TfrmMultipleDrugs.FindFirstUngivenDrug(IEN: string): Integer;
var
  i: Integer;
  MappedIEN: string;
  DoseFound: Boolean;                   //bjr 1/11/2012, BCMA00000944
begin
  Result := -1;
  DoseFound := false;                   //bjr 1/11/2012, BCMA00000944

  {JK 8/20/2008}
  MappedIEN := BCMA_ScannedDrug.MapIEN(IEN);

  with clbxDoses do
    for i := 0 to items.count - 1 do
    begin
      if IEN = '' then
      begin
        if not checked[i] then
        begin
          Result := i;
          DoseFound := true;            //bjr 1/11/2012, BCMA00000944
          Exit;
        end;
      end
      else
      begin
        if (not checked[i]) and
          (TBCMA_MedOrder(mordereddruglist[i]).PatientIEN = MappedIEN) then
        begin                           {JK 8/20/2008 - in case a synonym is present, look it up to get the IEN. If an IEN is present, it will return the same IEN}
          Result := i;
          DoseFound := true;            //bjr 1/11/2012, BCMA00000944
          Exit;
        end;
      end;
    end;
//      if not DoseFound then begin  //bjr 1/11/2012, BCMA00000944
    // The user scanned a valid drug which is not found on the dispensed drug list
    // for this order.  Show invalid lookup message.
  if (not DoseFound) and (MappedIEN <> '') then begin // bjr 4/16/2012, BCMA00000944
    DefMessageDlg('Invalid medication lookup.' + #13#10#13#10 + 'DO NOT GIVE!', mtError, [mbOK], 0
{$IFDEF R1224198}
      , '', True
{$ENDIF}
      );                                //bjr 1/11/2012, BCMA00000944
 //bjr - INC1224198 - 6/2/2015
  end;
end;

function TfrmMultipleDrugs.MarkDrugAsGiven(Idx: Integer; scanIEN: string):
  Boolean;                              {JK 4/18/2008 added IDX param}
var
  AdministrationUnitNeeded, CheckState: Boolean;

  function AreAllDrugsGiven: Boolean;
  var
    i: Integer;
  begin
    Result := True;
    for i := 0 to clbxDoses.Count - 1 do
      if not clbxDoses.Checked[i] then
        if i <> clbxDoses.Count - 1 then
          Result := False;

  end;

  {JK 4/18/2008. Added this to replace the older logic.  Older logic used
   the right click popup menu and always marked the first unchecked drug
   in the list. This logic uses the button position to mark off a drug.}
  function CheckMarkItAsScanned(Idx: Integer; aDrugIEN: string): integer;
  var
    i, ii: integer;
    OkToContinue: Boolean;
  begin
    Result := -1;
    i := -1;                            // rpk 4/23/2009

    {JK 7/23/2008 - The drug aDrugIEN passed in may have come from a specific user
     choice on the screen in which the index is [absolute], or it may have
     come from a scanned entry in which I have to scroll down the list
     of drugs and see what index it is [relative]}
    OkToContinue := False;
    with TBCMA_DispensedDrug(MOrderedDrugList[idx]) do
      if (IEN = aDrugIEN) then
      begin
        i := idx;                       {absolute index - user checked a specific checkbox}
        OkToContinue := True;
      end
      else
      begin
        for ii := 0 to MOrderedDrugList.Count - 1 do
          if (TBCMA_DispensedDrug(MOrderedDrugList[ii]).IEN = aDrugIEN) and
            not clbxDoses.Checked[ii] then
          begin
            i := ii;                    {relative index from a scanned input IEN}
            OkToContinue := True;
            Break;
          end;
      end;

    {JK 4/15/2008}
    if OkToContinue and (MultiDoseType <> mdtSingleFractionalDose) then
    begin

      if i > -1 then
      begin                             // rpk 4/23/2009

        with TBCMA_DispensedDrug(MOrderedDrugList[i]) do
        begin

          if (IEN = aDrugIEN) then
          begin
            lastdrugi := i;             //bjr - 8/3/2012
//            if AreAllDrugsGiven then
            if AreAllDrugsGiven or ScanComplete then //bjr - 8/3/2012
            begin

              AdministrationUnitNeeded := (MedOrder.AdministrationUnit = '');

              if AdministrationUnitNeeded then

                {JK 4/15/2008}
                with TBCMA_DispensedDrug(MOrderedDrugList[i]) do
                  if QtyEntered = '' then
//                    QtyEntered := inputPrompt(Name,
//                      'Enter Quantity and Units (ie., 30 ml):',
//                      '', 40, True, False, CheckState, '');
                    QtyEntered := inputPrompt(Name, // rpk 3/23/2011
//                      'Enter Quantity and Units (ie., 30 ml):',
                      'Enter Quantity and Units (ie., 30 mg):',
                      '', 40, True, False, MedOrder.OrderTypeID, CheckState, '');

              if AdministrationUnitNeeded and (TrimLeft(QtyEntered) = '') then
              begin
                QtyEntered := '';
                Result := -2;
                DefMessageDlg('Quantity and Units are required and cannot be null or a space. '
                  +
                  'The scanned medication has been cancelled.', mtWarning,
                  [mbOK], 0);
                ModalResult := mrCancel; {JK 9/13/2008}
                Exit;
              end
              else
              begin
                QtyScanned := QtyScanned + 1;
                clbxDoses.Checked[i] := True;
                Result := i;
              end;
            end
            else
            begin
              QtyScanned := QtyScanned + 1;
              clbxDoses.Checked[i] := True;
              Result := i;
            end;                        {areAllDrugsGiven}
          end;                          // if IEN = aDrugIEN
        end;                            // with TBCMA_DispensedDrug(MOrderedDrugList[i])
      end;                              // if i > -1
    end;                                {if OkToContinue}

    if OkToContinue and (MultiDoseType = mdtSingleFractionalDose) then
    begin
      with TBCMA_DispensedDrug(MOrderedDrugList[i]) do
        if (IEN = aDrugIEN) then
        begin
          QtyScanned := QtyScanned + 1;
          clbxDoses.Checked[i] := True;
          Result := i;
        end;
    end;

    if Result = -1 then
      DefMessageDlg('Scanned Drug has already been given or,' + #13 +
        'is Not on the Doses To Scan List!' + #13#13 + 'DO NOT GIVE!',
        mtError, [mbOK], 0
{$IFDEF R1224198}                       //bjr 6/2/2015
        , '', True
{$ENDIF}
        );
  end;

begin                                   // MarkDrugAsGiven
  Result := False;
  with BCMA_ScannedDrug do
    if isValidDrug(scanIEN) then
    begin
      {jk 4/21/2008}
      if (CheckMarkItAsScanned(Idx, scanIEN) > -1) then
      begin
        dec(ScanCount);
        Result := True;
      end
      else if (MultiDoseType <> mdtMultipleDose) and (ModalResult <> mrOK) then
      begin                             {JK 9/13/2008}
        CloseFrm := True;
        Exit;
      end
      else
        CloseFrm := False;
    end
    else
      CloseFrm := False;

  edtScannerInput.clear;
  if edtScannerInput.Enabled then
    edtScannerInput.setFocus;

  if ScanCount = 0 then
  begin
    ModalResult := mrOK;
    CloseFrm := True;
  end;
end;                                    // MarkDrugAsGiven

procedure TfrmMultipleDrugs.edtScannerInputKeyPress(Sender: TObject;
  var Key: Char);
var
  DrugPositionIndex: Integer;
begin
  {disable Cut and Past}
  if key = #22 then
    key := #0;

  if edtScannerInput.text <> '' then
    if key = chr(VK_RETURN) then
    begin
      StopKeyboardTimer;

      DrugPositionIndex := FindFirstUngivenDrug(edtScannerInput.Text);

      if DrugPositionIndex >= 0 then
      begin
        if MarkDrugAsGiven(DrugPositionIndex, edtScannerInput.Text) then
          TButton(clbxDoses.items.objects[DrugPositionIndex]).Enabled := False;

        //Logic Added to Deal with Keyed Bar Codes
        if KeyedBarCode then
        begin
          LogUnableToScan('', '', '', '', 'M', 1);
          KeyedBarCode := False;
        end
        else
          LogUnableToScan('', '', '', '', 'M', 2);
      end
      else
        edtScannerInput.Clear;          {JK 7/25/2008 CQ #148}

    end;

end;

procedure TfrmMultipleDrugs.pnlScannerIndicatorClick(Sender: TObject);
begin
  if edtScannerInput.Enabled then
    edtScannerInput.SetFocus;
end;

procedure TfrmMultipleDrugs.mmoCommentsEnter(Sender: TObject);
begin
  GetScreenReader.Speak(mmoComments.text); // rpk 9/7/2010
end;

procedure TfrmMultipleDrugs.mmoSpecialInstructionsEnter(Sender: TObject);
begin
  GetScreenReader.Speak(mmoSpecialInstructions.text); // rpk 9/7/2010
end;

procedure TfrmMultipleDrugs.mmoSpecialInstructionsMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if edtScannerInput.Enabled then
    edtScannerInput.SetFocus;
end;

procedure TfrmMultipleDrugs.clbxDosesEnter(Sender: TObject);
begin
  {Removed 4/11/2008 JK. Interfered with cbxlDoses button}
    //if edtScannerInput.Enabled then
    //  edtScannerInput.SetFocus;
end;

procedure TfrmMultipleDrugs.clbxDosesClickCheck(Sender: TObject);
begin
  with clbxDoses do
    checked[itemIndex] := not checked[itemIndex];
end;

procedure TfrmMultipleDrugs.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (CancelBtn = True) or (ModalResult = mrIgnore) then
    CanClose := True
  else
  begin
    CanClose := CloseFrm;

    if CanClose then
      CanClose := CheckFractional;

    if CanClose then
    begin
      InsertComment;                    {JK 9/9/2008 CQ# 230}
      LogQueuedUAS;                     {JK 5/20/2008}
    end;

    CloseFrm := True;
  end;
end;

procedure TfrmMultipleDrugs.InsertComment;
var
  CommentText: string;
begin
  CommentText := StripString(mmoComments.Text);
  if CommentText <> '' then
    with MedOrder do
    begin
      AdditionalComments.Add(CommentText);
      LogComments(MedLogIEN, AdditionalComments);
    end;
end;

function TfrmMultipleDrugs.isFracSingleDoseAdministrationNeeded: Boolean;
var
  AdministrationUnitNeeded: Boolean;
  CheckState: Boolean;
begin
  {JK 9/12/2008}
  Result := True;
  if MultiDoseType = mdtSingleFractionalDose then
  begin

    with TBCMA_DispensedDrug(MOrderedDrugList[0]) do
      AdministrationUnitNeeded := (MedOrder.AdministrationUnit = '');

    if AdministrationUnitNeeded then

      {JK 4/15/2008}
      with TBCMA_DispensedDrug(MOrderedDrugList[0]) do
      begin
        if QtyEntered = '' then
//          QtyEntered := inputPrompt(Name,
//            'Enter Quantity and Units (ie., 30 ml):', '', 40, True, False,
//            CheckState, '');
          QtyEntered := inputPrompt(Name,
//            'Enter Quantity and Units (ie., 30 ml):', '', 40, True, False,
            'Enter Quantity and Units (ie., 30 mg):', '', 40, True, False,
            MedOrder.OrderTypeID, CheckState, ''); // rpk 3/23/2011

        if AdministrationUnitNeeded and (TrimLeft(QtyEntered) = '') then
        begin
          QtyEntered := '';
          Result := False;
          DefMessageDlg('Quantity and Units are required and cannot be null or a space. '
            +
            'The scanned medication has been cancelled.', mtWarning, [mbOK], 0);
          Exit;
        end;
      end;
  end;
end;

procedure TfrmMultipleDrugs.btnDisplaySIOPIClick(Sender: TObject);
var
  tbool: Boolean;
begin
  if MedOrder <> nil then begin
    with Medorder do begin
      tbool := DisplaySIOPI(False);     // rpk 3/14/2012
    end;
  end;
end;

procedure TfrmMultipleDrugs.btnDoneClick(Sender: TObject);
var
  i: integer;
  DrugScanned, AllScanned: Boolean;
  //  CommentText: String;
begin
  mmoComments.Text := StripString(mmoComments.Text); //bjr 8/3/2012
  if (MultiDoseType = mdtSingleFractionalDose) then
    if not UnableToScan then
    begin                               {JK 9/19/2008}
      if not isFracSingleDoseAdministrationNeeded then
      begin
        ModalResult := mrCancel;
        btnCancelClick(self);
        Exit;
      end;
    end;

  DrugScanned := False;
  AllScanned := True;
  if edtScannerInput.Text <> '' then
    MarkDrugAsGiven(FindFirstUngivenDrug(''), edtScannerInput.text);

  with MedOrder do
    for i := 0 to OrderedDrugCount - 1 do
      if OrderedDrugs[i].QtyScanned > 0 then
        DrugScanned := True
      else
        AllScanned := False;

  {JK - preview code for Donna Calliari's issue to replace above -- maybe 9/21/2008}
//    for i := 0 to clbxDoses.Items.Count - 1 do
//      if clbxDoses.Checked[i] = False then
//        AllScanned := False
//      else
//        DrugScanned := True;

  if DrugScanned and AllScanned then
    CloseFrm := True
  else if not DrugScanned then
  begin
    DefMessageDlg('No medications have been scanned or the scanned medication has been cancelled!', mtInformation, [mbOK], 0);
    if edtScannerInput.Enabled then
      edtScannerInput.setFocus;
    CloseFrm := False;
  end
  else
  begin
    if
      DefMessageDlg('Not all of the dispensed drugs have been scanned, do you wish to continue?',
      mtConfirmation, [mbYes, mbNo], 0) = idNo then
    begin
      if edtScannerInput.Enabled then
        edtScannerInput.setFocus;
      CloseFrm := False;
    end                                 {if DefMessageDlg}
    else
      CloseFrm := True;

  end;
end;

procedure TfrmMultipleDrugs.BitBtn1Click(Sender: TObject);
begin
  CancelBtn := True;
end;

procedure TfrmMultipleDrugs.btnCancelClick(Sender: TObject);
//var
//  ii: integer;
begin
  CancelBtn := True;
  //  if (MultiDoseType = mdtMultipleDose) and
  //     ((MedOrder.Route = 'IV PUSH') or (MedOrder.Route = 'IV PIGGYBACK')) then

  //  if (MedOrder.Route = 'IV PUSH') or (MedOrder.Route = 'IV PIGGYBACK') then
  //    DefMessageDlg('Order Administration Cancelled!', mtWarning, [mbOK], 0);
end;

function TfrmMultipleDrugs.isPartialAdministrationGiven(i: Integer): Boolean; //bjr 8/3/2012
var
  AdministrationUnitNeeded, CheckState: Boolean;
//x : integer;
  mcnt: Integer;
begin
  Result := False;                      // rpk 4/30/2013
//  flag := False;

  mcnt := MOrderedDrugList.Count;       // rpk 4/30/2012
  if i > (mcnt - 1) then begin          // check for out-of-bounds index and exit on error. rpk 4/30/2012
    WriteLogMessageProc('TfrmMultipleDrugs.isPartialAdministrationGiven: i is out of bounds; i=' +
      IntToStr(i) + ', MOrderedDrugList.Count=' + IntToStr(mcnt), nil);
//    i := mcnt - 1;
    DefMessageDlg('MultipleDrugs/FractionalDose: Internal error; index out of bounds. ' +
      'The scanned medication has been cancelled.', mtWarning, [mbOK], 0);
    ModalResult := mrCancel;
    exit;
  end;

//  begin
  AdministrationUnitNeeded := (MedOrder.AdministrationUnit = '');
    { if AdministrationUnitNeeded then
     with TBCMA_DispensedDrug(MOrderedDrugList[i]) do
      if QtyEntered = '' then
        QtyEntered := inputPrompt(Name, // rpk 3/23/2011
          'Enter Quantity and Units (ie., 30 mg):',
            '', 40, True, False, MedOrder.OrderTypeID, CheckState, '');
      with TBCMA_DispensedDrug(MOrderedDrugList[i]) do
        if AdministrationUnitNeeded and (TrimLeft(QtyEntered) = '') then
              begin
                QtyEntered := '';
                DefMessageDlg('Quantity and Units are required and cannot be null or a space. '
                  +
                  'The scanned medication has been canceled.', mtWarning,
                  [mbOK], 0);
                ModalResult := mrCancel; // JK 9/13/2008
                Exit;
              end; }

  if AdministrationUnitNeeded then begin
    with TBCMA_DispensedDrug(MOrderedDrugList[i]) do begin
      if QtyEntered = '' then
        QtyEntered := inputPrompt(Name, // rpk 3/23/2011
          'Enter Quantity and Units (ie., 30 mg):',
          '', 40, True, False, MedOrder.OrderTypeID, CheckState, '');
//      with TBCMA_DispensedDrug(MOrderedDrugList[i]) do
      if (TrimLeft(QtyEntered) = '') then begin
        QtyEntered := '';
        DefMessageDlg('Quantity and Units are required and cannot be null or a space. '
          +
          'The scanned medication has been cancelled.', mtWarning,
          [mbOK], 0);
        ModalResult := mrCancel;        // JK 9/13/2008
//                Exit;
      end;
    end;
  end;

//  end;
end;                                    // isPartialAdministrationGiven

function TfrmMultipleDrugs.CheckFractional: Boolean;
var
  i, xx: Integer;
  BaseUnit: Real;
//  drugcont: Boolean;  //bjr 8/3/2012
begin
  Result := False;                      // rpk 4/23/2009

  with MedOrder do
  begin
    for i := 0 to OrderedDrugCount - 1 do
      if (OrderedDrugs[i].QtyScanned < OrderedDrugs[i].QtyOrdered) and
        //(pos('.', OrderedDrugs[i].QtyOrderedText) <> 0) and
      (OrderedDrugs[i].QtyScanned > 0) then
      begin
        Visible := False;
        with TfrmFractional.create(application) do
        try
          if pos('.', OrderedDrugs[i].QtyOrderedText) = 0 then
          begin
            btnPartial.ModalResult := mrOK;
//            btnPartial.Caption := 'OK';
            btnPartial.Caption := '&OK'; // add keyboard shortcut at run-time update;  rpk 9/29/2010
            //            lblInfo3.Caption := 'Click the OK button if you completed scanning '
            //              +
            //              'the necessary units.'
//            lblInfo3a.Caption := 'Click the OK button if you completed';
//            lblInfo3b.Caption := 'scanning the necessary units.';
            memInfo2.Text := 'Click the OK button if you completed scanning '
              + 'the necessary units.'
          end;
          lblDispensedDrugName.caption := OrderedDrugs[i].Name;
          lblUnitsPerDose.Caption := OrderedDrugs[i].QtyOrderedText;

          BaseUnit := StrToFloat(OrderedDrugs[i].QtyOrderedText) -
            trunc(StrToFloat(OrderedDrugs[i].QtyOrderedText));

          CheckBox1.Caption := FloatToStr(OrderedDrugs[i].QtyScanned - 1 +
            BaseUnit);
          CheckBox2.Caption := FloatToStr(OrderedDrugs[i].QtyScanned) + '.0';

          result := (showModal = mrOK);

          if Result = True then
          begin
            if pos('.', OrderedDrugs[i].QtyOrderedText) = 0 then
              OrderedDrugs[i].QtyScannedText :=
                FloatToStr(OrderedDrugs[i].QtyScanned) + '.0';
            for xx := 0 to pnlUnits.ControlCount - 1 do
              if pnlUnits.Controls[xx] is TCheckBox then
                if (pnlUnits.Controls[xx] as TCheckBox).State = cbChecked then
                  OrderedDrugs[i].QtyScannedText := (pnlUnits.Controls[xx] as
                    TCheckBox).Caption;
          end
          else
          begin
            break;
          end;
        finally
//          free;
          Release;                      // rpk 6/18/2013
        end;
      end
      else
        Result := True;
    Visible := True;
  end;
//  if Result = True then
  if Result then                        // rpk 2/11/2013
    isPartialAdministrationGiven(lastdrugi); //bjr 8/3/2012
end;

procedure TfrmMultipleDrugs.btnEnableScannerClick(Sender: TObject);
begin
  edtScannerInput.SetFocus;
end;

procedure TfrmMultipleDrugs.FormDeactivate(Sender: TObject);
begin
  edtScannerInputExit(edtScannerInput);
end;

procedure TfrmMultipleDrugs.FormActivate(Sender: TObject);
begin
  edtScannerInputEnter(self);
end;

procedure TfrmMultipleDrugs.mnuUnableToScanClick(Sender: TObject);
var
  ResultTxt, CommentTxt: string;
  ReturnVal: Boolean;
  PRNVitalsInfo: string;                {JK 8/25/2008}
  PRNPainInfo: string;                  {JK 8/25/2008}
begin
  UnableToScan := True;

  PRNVitalsInfo := '';
  PRNPainInfo := '';

  //if UnableToScanExecute(1, MedOrder, TBCMA_DispensedDrug(clbxDoses.items.objects[clbxDoses.ItemIndex])) then
  {JK 4/15/2008}
  UnableToScanExecute(1,
    WF_UAS_MEDICATION,
    nil,
    MedOrder,
    ResultTxt,
    CommentTxt,
    ReturnVal,
    PRNVitalsInfo,
    PRNPainInfo,
    TBCMA_DispensedDrug(MOrderedDrugList[clbxDoses.ItemIndex]));
  if ReturnVal then
  begin
    //MarkDrugAsGiven(TBCMA_DispensedDrug(clbxDoses.items.objects[clbxDoses.ItemIndex]).IEN);
    {JK 4/15/2008}
    MarkDrugAsGiven(clbxDoses.ItemIndex,
      TBCMA_DispensedDrug(MOrderedDrugList[clbxDoses.ItemIndex]).IEN);
  end;
  UnableToScan := False;
end;

procedure TfrmMultipleDrugs.clbxDosesContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  with clbxDoses do
    if ItemAtPos(MousePos, True) <> -1 then
      Selected[ItemAtPos(MousePos, True)] := True
    else
      clbxDoses.ItemIndex := -1;
end;

procedure TfrmMultipleDrugs.clbxDosesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin

  {JK 9/1/2008 CodeCR 224 - Recompute the button "top" coordinate in
   case the origin moved or the buttons scrolled off screen.}
  TButton(clbxdoses.Items.Objects[index]).Top := Rect.Top;

  {JK 4/16/2008}
  DrawText(TCheckListBox(Control).Canvas.Handle,
    PChar(clbxDoses.Items[Index]),
    Length(clbxDoses.Items[Index]),
    Rect, DT_VCENTER + DT_SINGLELINE);

  //  DrawText(TCheckListBox(Control).Canvas.Handle,
  //           PChar(clbxDoses.Items[Index] + '-' + IntToStr(Index)),
  //           Length(clbxDoses.Items[Index] +'   '),
  //           Rect, DT_VCENTER + DT_SINGLELINE );

end;

procedure TfrmMultipleDrugs.mnuRightClickMenuPopup(Sender: TObject);
begin
  //  with clbxDoses do
  //    if ItemIndex <> -1 then
  //      mnuUnableToScan.Enabled := Not Checked[ItemIndex]
  //    else
  //      mnuUnableToScan.Enabled := False;
end;

procedure TfrmMultipleDrugs.edtScannerInputKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  {disable cut and paste}
  if key = VK_Insert then
    key := 0;
end;

procedure TfrmMultipleDrugs.edtScannerInputKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if edtScannerInput.Text <> '' then
  begin
    if (KeyBoardTimer = nil) or (KeyedBarCode = False) then
      StartKeyboardTimer;
  end
  else
  begin
    StopKeyboardTimer;
    KeyedBarCode := False;
  end;
end;

function TfrmMultipleDrugs.QueueLogUnableToScan(
  MedOrderNumber,
  ResultTxt,
  CommentTxt,
  UnableToScanString,
  UASType: string): Boolean;
var
  i, j: Integer;
begin
  i := -1;                              // rpk 4/23/2009
  Result := False;                      // rpk 4/23/2009

  try
    for j := 1 to High(arrQueuedUAS) do
      if arrQueuedUAS[j, 1] = '' then
      begin
        i := j;
        Break;
      end;

    if i > -1 then
    begin                               // rpk 4/23/2009
      arrQueuedUAS[i, 1] := MedOrderNumber;
      arrQueuedUAS[i, 2] := ResultTxt;
      arrQueuedUAS[i, 3] := CommentTxt;
      arrQueuedUAS[i, 4] := UnableToScanString;
      arrQueuedUAS[i, 5] := UASType;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

procedure TfrmMultipleDrugs.LogQueuedUAS;
var
  i, j: Integer;
begin
  try
    for j := 1 to High(arrQueuedUAS) do
      if arrQueuedUAS[j, 1] = '' then
      begin
        i := j;                         // i not used?; rpk 4/22/2010
        Break;
      end;
    { TODO -oBob -cReview : Check handling of i as subscript of array. }
    for i := 1 to j - 1 do
      LogUnableToScan(arrQueuedUAS[i, 1],
        arrQueuedUAS[i, 2],
        arrQueuedUAS[i, 3],
        arrQueuedUAS[i, 4],
        arrQueuedUAS[i, 5]);

  except
    on E: Exception do
      DefMessageDlg('TfrmMultipleDrugs.LogQueuedUAS error. Msg = ' + E.Message,
        mtError, [mbOK], 0);
  end;

end;

initialization
  SpecifyFormIsNotADialog(TfrmMultipleDrugs);

end.
