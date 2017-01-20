unit ScanIV;



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BCMA_Objects, BCMA_Common, BCMA_Util, ComCtrls,
  VA508AccessibilityManager, VA508AccessibilityRouter, ExtCtrls;

const
  ActToStr: array[0..2] of string = ('Infusing', 'Stopped', 'Completed');

type
  TfrmScanIV = class(TForm)
    grpBagInformation: TGroupBox;
    lstMedicationSolutions: TListBox;
    grpOrderChanges: TGroupBox;
    GroupBox1: TGroupBox;
    memComment: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    cbxAction: TComboBox;
    cbxInjectionSite: TComboBox;
    memOrderChanges: TRichEdit;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblMedsSolns: TLabel;
    lblEnterComment: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lblRouteText: TVA508StaticText;
    lblCurBagStatusCaption: TLabel;
    lblIVBagNumberCaption: TLabel;
    lblRouteCaption: TLabel;
    lblScanStatus: TVA508StaticText;
    lblBagNumber: TVA508StaticText;
    memOtherPrintInfo: TMemo;
    lblOtherPrintInfo: TLabel;
    pnlScrollDown: TPanel;
    lblScrollDown: TStaticText;
    btnDisplaySIOPI: TButton;
    procedure FormShow(Sender: TObject);
    {
      Sets all the captions with the proper information, fills the list boxes
      with data, calls method setCBXs;
    }

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    {
      Checks to see if we can close the form which involves calling method
      CanCloseCheck
    }

    procedure cbxActionChange(Sender: TObject);
    procedure memOrderChangesEnter(Sender: TObject);
    procedure cbxActionEnter(Sender: TObject);
    procedure cbxInjectionSiteEnter(Sender: TObject);
    procedure btnDisplaySIOPIClick(Sender: TObject);

  private
    { Private declarations }
    FActionOverride: Integer;

    procedure setCBXs();
    {
      Based the bag status and the action being taken, adds the appropriate items
      to the combo boxes.
    }

  public
    { Public declarations }
    MedOrder: TBCMA_MedOrder;
    IVBag: TBCMA_IVBags;
    IVActionType: TIVActionTypes;
    MultInfusingBags: Boolean;
    function CanCloseCheck: Boolean;
    {
      Checks to make sure all the required fields have data.
    }

    property ActionOverride: integer read FActionOverride write FActionOverride;
  end;

var
  frmScanIV: TfrmScanIV;
  //ivAction: TScanStatus;
implementation

{$R *.DFM}
uses
  uIVUtilities;
//   MFunStr;

procedure TfrmScanIV.FormShow(Sender: TObject);
var
  ii: integer;
  BoldedMsg, ChangedMsg, HoldMsg: string;
begin
  with MedOrder do begin
    if OrderStatus = 'H' then {//bjr 5/17/10 for BCMA00000425} begin
      HoldMsg := 'This order is on Provider Hold!';
      memOrderChanges.Text := HoldMsg + #13#10#13#10;
      memOrderChanges.SelStart := 0; // rpk 8/31/2010
    end;

    if OrderChangedData.Count > 0 then begin
      ChangedMsg := FormatDisplayMessage(MedOrder, IVBag.UniqueID, False);
      if ChangedMsg <> '' then begin
        //        BoldedMsg := 'and the associated order has been changed';
        //        memOrderChanges.Text := 'IV Bag ' + IVBag.UniqueID + ' is currently ' +
        //          GetLastActivityStatus(IVBag.ScanStatus) +
        //          ', ' + BoldedMsg + '. The order changes are listed below.' +
        //            #13#13#13;

        memOrderChanges.SelAttributes.Style := []; //bjr 5/12/10 for BCMA00000425
        BoldedMsg := 'and the associated order has been changed';
        memOrderChanges.Text := memOrderChanges.Text + 'IV Bag ' + IVBag.UniqueID
          + ' is currently ' + GetLastActivityStatus(IVBag.ScanStatus) +
          ', ' + BoldedMsg + '. The order changes are listed below.' +
          #13#13#13; //bjr 5/12/10 for BCMA00000425

        with memOrderChanges do begin
          SelStart := FindText(BoldedMsg, 0, length(Text), [stWholeWord]);
          SelLength := Length(BoldedMsg);
        end;
        memOrderChanges.SelAttributes.Style := [fsBold];

        //The following line caused some errors with Specific versions
        //of the RichEdit DLLS, one some, but not all NT 4.0 boxes
        //memOrderChanges.Lines.Append(#13 + ChangedMsg);
        memOrderChanges.SelStart := memOrderChanges.GetTextLen;
        memOrderChanges.SelText := ChangedMsg;
      end;
    end;

    if OrderStatus = 'H' then {//bjr 5/17/10 for BCMA00000425} begin
      memOrderChanges.SelStart := 0;
      memOrderChanges.SelLength := Length(HoldMsg);
      memOrderChanges.SelAttributes.Style := [fsBold];
    end;

    with IVBag do begin
      lblBagNumber.Caption := UniqueID;
      lblScanStatus.Caption := GetLastActivityStatus(IVBag.ScanStatus) + ' ';
        // rpk 7/28/2010
      lblRouteText.Caption := Route + ' '; // rpk 7/28/2010
      for ii := 0 to Additives.Count - 1 do
        lstMedicationSolutions.Items.Add(piece(Additives[ii], '^', 3) + ' ' +
          piece(Additives[ii], '^', 4));

      for ii := 0 to Solutions.Count - 1 do
        lstMedicationSolutions.Items.Add('   ' + piece(Solutions[ii], '^', 3) +
          ' ' + piece(Solutions[ii], '^', 4));
    end;

    SetSIOPIMemo(memOtherPrintInfo);  // rpk 1/31/2012
    memOtherPrintInfo.SelStart := 0;  // rpk 3/16/2012
    pnlScrollDown.Visible := memOtherPrintInfo.Lines.Count > 6;  // 3/14/2012

    case IVActionType of
      atScan: begin
          Label11.Caption := 'Select an &Action:';
          Label12.Caption := 'Select an &Injection Site:';
        end;
      atHeld, atRefused: begin
          Label11.Caption := 'Select an &Action:';
          Label12.Caption := 'Select a &Reason:';
          memComment.Enabled := False;
          lblEnterComment.Enabled := False;
//          lbl150Char.Enabled := False;
        end;
      atMissingDose: begin
          Label11.Caption := '&Date@Time Needed:';
          Label12.Caption := 'Select a &Reason:';
        end;
    end;
    setCBXs;

  end;
end;

procedure TfrmScanIV.memOrderChangesEnter(Sender: TObject);
begin
  GetScreenReader.Speak(memOrderChanges.text); // rpk 9/7/2010
end;

procedure TfrmScanIV.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  canClose := (modalResult = mrCancel) or CanCloseCheck;
  //if not CanClose then
end;

procedure TfrmScanIV.btnDisplaySIOPIClick(Sender: TObject);
var
  tbool: Boolean;
begin
  if MedOrder <> nil then begin
    with Medorder do begin
      tbool := DisplaySIOPI(False); // rpk 11/09/2011
    end;
  end;
end;

function TfrmScanIV.CanCloseCheck: Boolean;
var
  Msg: string;
begin
  Result := False;

  //  if cbxAction.ItemIndex = -1 then
  if cbxAction.ItemIndex <= -1 then begin
    case IVActionType of
      atScan, atHeld, atRefused:
        Msg := 'You must select an Action!';
      atMissingDose:
        Msg := 'You must enter a date and time!';
    end;
    DefMessageDlg(Msg, mtError, [mbOK], 0);
    cbxAction.SetFocus;
    exit;
  end;

  //  if cbxInjectionSite.ItemIndex = -1 then
  if cbxInjectionSite.ItemIndex <= -1 then begin
    case IVActionType of
      atScan:
        Msg := 'You must select an injection site!';
      atHeld, atRefused, atMissingDose:
        Msg := 'You must select a reason!';
    end;

    DefMessageDlg(Msg, mtError, [mbOK], 0);
    cbxInjectionSite.SetFocus;
    exit;
  end;

//  if integer(cbxAction.Items.Objects[cbxAction.ItemIndex]) = 1 then
  if (cbxAction.Items.Objects[cbxAction.ItemIndex] <> nil) and
    (integer(cbxAction.Items.Objects[cbxAction.ItemIndex]) = 1) then
    if Trim(memComment.Text) = '' then {// rpk 8/19/2010} begin
      DefMessageDlg('You must enter a comment when stopping an IV!', mtError,
        [mbOK], 0);
      memComment.SetFocus;
      exit;
    end;

//  if (integer(cbxAction.Items.Objects[cbxAction.ItemIndex]) = 0) and
  if (cbxAction.Items.Objects[cbxAction.ItemIndex] <> nil) and
    (integer(cbxAction.Items.Objects[cbxAction.ItemIndex]) = 0) and
    MultInfusingBags then begin
    DefMessageDlg('You cannot mark this bag infusing while another bag is currently infusing. '
      +
      'Please either complete this bag, or the other bag(s) that may be marked as infusing.',
      mtError, [mbOK], 0);
    exit
  end;

  Result := True;
end;

procedure TfrmScanIV.cbxActionChange(Sender: TObject);
begin
  //ivAction := TScanStatus(cbxAction.Items.Objects[cbxAction.ItemIndex]);
end;

procedure TfrmScanIV.cbxActionEnter(Sender: TObject);
begin
  GetScreenReader.Speak(Label11.Caption);  // rpk 8/23/2011
end;

procedure TfrmScanIV.cbxInjectionSiteEnter(Sender: TObject);
begin
  GetScreenReader.Speak(Label12.Caption);  // rpk 8/23/2011
end;

// Act: 0=Infusing, 1=Stopped, 2=Completed

procedure TfrmScanIV.setCBXs();
var
  x: integer;
  idx: Integer;
  icnt: Integer;
begin
  cbxAction.ItemIndex := -1; // set default to show no action; rpk 8/9/2010

  case IVActionType of
    atScan: begin
        with cbxAction do begin
          Clear;
          ItemIndex := -1;
          SetFocus;
        end;

        if ActionOverride = -1 then begin
          with MedOrder do
            if (OrderStatus = 'A') or (OrderStatus = 'R') or
              (OrderStatus = 'O') then
              with IVBag do begin
                if ScanStatus = 'I' then
                  with cbxAction.Items do begin
                    AddObject(ActToStr[1], Ptr(1)); // stopped
                    AddObject(ActToStr[2], Ptr(2)); // completed
                  end
                else if ScanStatus = 'S' then
                  with cbxAction.Items do begin
                    AddObject(ActToStr[0], Ptr(0));  // infusing
                    AddObject(ActToStr[2], Ptr(2));  // completed
                  end
                else if (ScanStatus = 'A') or (ScanStatus = 'H') or
                  (ScanStatus = 'R') or (ScanStatus = 'M') then begin
                  with cbxAction.Items do
                    AddObject(ActToStr[0], Ptr(0));  // infusing
                  cbxAction.ItemIndex := 0;
                end;
              end
            else if OrderStatus = 'H' then begin
              with IVBag do
                if ScanStatus = 'I' then
                  with cbxAction.Items do begin
                    AddObject(ActToStr[1], Ptr(1));  // stopped
                    AddObject(ActToStr[2], Ptr(2));  // completed
                  end
                else if ScanStatus = 'S' then
                  with cbxAction.Items do begin
                    //                    AddObject(ActToStr[0], Ptr(0));        bjr 5/17/2010
                    AddObject(ActToStr[2], Ptr(2));  // completed
                    cbxAction.ItemIndex := 0; // rpk 8/9/2010
                  end;
            end
            else
              with cbxAction.Items do
                AddObject('Completed', Ptr(2))
        end
        else
          case ActionOverride of
            2:  // set item selected to Completed?
              with cbxAction.Items do begin
                AddObject(ActToStr[2], Ptr(2));
                cbxAction.ItemIndex := 0;
              end;
          end;

        with cbxInjectionSite do begin
//          Items.assign(BCMA_SiteParameters.ListInjectionSites);
          icnt := PopulateSiteList(BCMA_SiteParameters.ListBodySites, Items, stInjection, True);  // rpk 11/17/2015
//          if Items.IndexOf(IVBag.InjectionSite) > -1 then
//            ItemIndex := Items.IndexOf(IVBag.InjectionSite)
          idx := Items.IndexOf(IVBag.InjectionSite);
          if idx > -1 then
            ItemIndex := idx
          else
            ItemIndex := -1;
        end;
      end;

    atHeld: begin
        with cbxAction do begin
          Items.AddObject('Held', Ptr(3));
          ItemIndex := 0;
        end;
        with cbxInjectionSite do begin
          for x := 0 to BCMA_SiteParameters.ListReasonsHeld.Count - 1 do
            Items.Add(BCMA_SiteParameters.ListReasonsHeld[x]);
          ItemIndex := -1;
          SetFocus;
        end;
      end;

    atRefused: begin
        with cbxAction do begin
          Items.AddObject('Refused', Ptr(4));
          ItemIndex := 0;
        end;

        with cbxInjectionSite do begin
          for x := 0 to BCMA_SiteParameters.ListReasonsRefused.Count - 1 do
            Items.Add(BCMA_SiteParameters.ListReasonsRefused[x]);
          ItemIndex := -1;
          SetFocus;
        end;
      end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmScanIV);

end.

