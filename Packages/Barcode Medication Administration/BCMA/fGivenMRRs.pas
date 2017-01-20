unit fGivenMRRs;
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, BCMA_Objects, BCMA_Util,
  VA508AccessibilityManager, VA508AccessibilityRouter;

function ProcessGivenExpiredMRRs: Boolean; // rpk 11/3/2015

type
  TfrmGivenMRRs = class(TForm)
    pnlAdminInfo: TPanel;
    pnlButtons: TPanel;
    bvlAdminInfo: TBevel;
    lvwMedications: TListView;
    bvlPatchNumber: TBevel;
    lblAdminInfo: TVA508StaticText;
    lblNextDoseAction: TVA508StaticText;
    lblScheduleType: TVA508StaticText;
    lblLastAction: TVA508StaticText;
    lblOrderStatus: TVA508StaticText;
    lblOrderStopDateTime: TVA508StaticText;
    lblPatchNumber: TVA508StaticText;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblDispensedMeds: TLabel;
    lblNextDoseActionCaption: TLabel;
    lblScheduleTypeCaption: TLabel;
    lblLastActionCaption: TLabel;
    lblOrderStatusCaption: TLabel;
    lblOrderStopDateTimeCaption: TLabel;
    lblLocationCaption: TLabel;
    lblLocation: TVA508StaticText;
    btnCancel: TButton;
    lblLastSiteCaption: TLabel;
    lblLastSite: TVA508StaticText;
    memNotice: TMemo;
    btnOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lvwMedicationsEnter(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    CurrentMedOrder: TBCMA_MedOrder;
    CurrentIteration: integer;
    procedure PopulateForm;
    procedure ProcessNextPatch;
  public
    { Public declarations }
  end;

var
  frmGivenMRRs      : TfrmGivenMRRs;

implementation
uses
  BCMA_Common, BCMA_Main, uCAS_Utils;

{$R *.dfm}


var
  patchRemoved      : Boolean;
  isLate            : Boolean;

function ProcessGivenExpiredMRRs: Boolean; // rpk 11/3/2015
var
  ErrString         : string;
  lfrmGivenMRRs     : TfrmGivenMRRs;
begin
  Result := False;

  if BCMA_Patient.GivenExpiredPatches.Count = 0 then
    exit;

  patchRemoved := False;                // rpk 12/10/2012

  try
//    with TfrmGivenMRRs.Create(Application) do
    lfrmGivenMRRs := TfrmGivenMRRs.Create(Application);
    with lfrmGivenMRRs do
    try
      ProcessNextPatch;
      ShowModal;
    finally
      Release;                          // rpk 6/18/2013
    end;
  except
    on e: EMarkRemovedError do
    begin
      ErrString := e.Message;
      { ErrString := ErrString + #13 + 'The VDL may have been refreshed to reflect'
        +
        ' the most current information. The process of checking for GIVEN patches on ' +
        'EXPIRED or DC''d orders has been aborted. ' + #13 +
        'Please check the order status of all ' +
        'orders on the VDL that have a patch at a GIVEN status'; }
      ErrString := ErrString + #13 + 'The VDL may have been refreshed to reflect'
        +
        ' the most current information. The process of checking for GIVEN patches on ' +
        'DC''d orders has been aborted. ' + #13 + // rpk 7/5/2016
        'Please check the order status of all ' +
        'orders on the VDL that have a patch at a GIVEN status';
      DefMessageDlg('Error accessing ', mtError, [mbOK], 0);
    end;
  end;

  Result := patchRemoved;               // rpk 12/10/2012

end;                                    // ProcessGivenExpiredMRRs


procedure TfrmGivenMRRs.btnOKClick(Sender: TObject);
begin
  ProcessNextPatch;
end;

procedure TfrmGivenMRRs.FormCreate(Sender: TObject);
begin
  CurrentIteration := -1;
  if OrderMode = omClinic then
    HelpContext := 240 // patch administrations expired or discontinued, rpk 5/9/2013
  else
    HelpContext := 128;
end;

procedure TfrmGivenMRRs.FormShow(Sender: TObject);
begin
  btnCancel.Visible := BCMA_Patient.GivenExpiredPatches.Count > 1;

  if btnOK.CanFocus then
    btnOK.SetFocus;
end;

procedure TfrmGivenMRRs.lvwMedicationsEnter(Sender: TObject);
begin
  with lvwMedications do begin
    if ItemIndex < 0 then
      ItemIndex := 0;
    if (Selected = nil) and (Items[0] <> nil) then
      Selected := Items[0];
  end;
end;

procedure TfrmGivenMRRs.PopulateForm;
//const
//  fmtRemovalConfirmation =
//    'REMOVE is <<%d>> minutes AFTER the scheduled Removal Time for this Medical Order.';
//    'REMOVE is <<%d>> minutes AFTER the scheduled Removal Time for this Medication Order.';  // rpk 5/13/2016
//  fmtRemovalConfirmation =
//  'REMOVE is %d minutes AFTER the scheduled Removal Time for this Medication Order.';  // rpk 5/13/2016
var
  x                 : integer;
  location          : string;
  NextAction, NextDT, aMessage, tmpstr: string;
  datetimestr       : string;
  aMinutes          : Extended;
  aDateTime         : TDateTime;
begin
  with CurrentMedOrder do
  begin
    // Discontinued orders are bolded
    if (OrderStatus = 'D') or
      (OrderStatus = 'DE') then begin   // discontinued edit
//      (OrderStatus = 'DR') then begin           // discontinued renewal, rpk 1/25/2016
//      (OrderStatus = 'E') then begin
      lblOrderStatusCaption.Font.Style := [fsBold];
      lblOrderStatus.Font.Style := [fsBold];
      lblOrderStopDateTimeCaption.Font.Style := [fsBold];
      lblOrderStopDateTime.Font.Style := [fsBold];
    end
    else begin
      lblOrderStatusCaption.Font.Style := [];
      lblOrderStatus.Font.Style := [];
      lblOrderStopDateTimeCaption.Font.Style := [];
      lblOrderStopDateTime.Font.Style := [];
    end;

    // pad VA508StaticText fields with trailing blank to allow for re-size.
    if ClinicName > '' then             // rpk 9/10/2012
      Location := ClinicName
    else
      Location := 'Inpatient';
    lblLocation.Caption := UpperCase(Location) + ' ';
    lblScheduleType.Caption := ScheduleTypeTitles[ScheduleTypeID] + ' ';

    tmpstr := getOrderNextAction(CurrentMedOrder,
      frmmain.acNextActionWithDate.Checked,
      NextAction, NextDT, isLate);
    lblNextDoseAction.Caption := tmpstr + ' ';
    lblLastSiteCaption.Show;
    lblLastSite.Show;
    lblLastSite.Caption := LastSite + ' ';
    { if isLate then begin
            // check Late
      aDateTime := RemovalDueTime + (BCMA_Siteparameters.MinutesAfter / 1440);
      datetimestr := DateTimeToStr(aDateTime);
      if (BCMA_SiteParameters.ServerTime > aDateTime) then begin
        aMinutes := (BCMA_SiteParameters.ServerTime - aDateTime) * 1440;
        aMessage := Format(fmtRemovalConfirmation, [round(aMinutes)]);
      end;                              // if Servertime > aDateTime
    end; }// if isLate

    if LastActivityStatus <> '' then
      lblLastAction.Caption := GetLastActivityStatus(LastActivityStatus) + ': '
        + DisplayVADateYearTime(TimeLastAction) + ' ';
    lvwMedications.Clear;
    for x := 0 to OrderedDrugCount - 1 do
      lvwMedications.AddItem(OrderedDrugs[x].Name + ' (' +
        OrderedDrugs[x].QtyOrderedText + ')', nil);

    lblOrderStatus.Caption := GetOrderStatus(OrderStatus) + ' ';
    lblOrderStopDateTime.caption := DisplayVADateYearTime(StopDateTime) + ' ';
  end;                                  // CurrentMedOrder
end;                                    // PopulateForm

procedure TfrmGivenMRRs.ProcessNextPatch;
begin
  isLate := False;                      // rpk 11/5/2015

  Inc(CurrentIteration);
  if CurrentIteration > BCMA_Patient.GivenExpiredPatches.Count - 1 then
  begin
    ModalResult := mrOk;
    exit;
  end;

  CurrentMedOrder :=
    TBCMA_MedOrder(BCMA_Patient.GivenExpiredPatches[CurrentIteration]);
  PopulateForm;

  bvlPatchNumber.Width := 239;
  lblPatchNumber.Left := 274;

  lblPatchNumber.Caption := 'Meds Requiring Removal ' +
    intToStr(CurrentIteration + 1) + ' of '  +
    IntToStr(BCMA_Patient.GivenExpiredPatches.Count) + ' ';

  if self.Visible and btnOK.CanFocus then
    btnOK.SetFocus;
end;                                    // ProcessNextPatch

initialization
  SpecifyFormIsNotADialog(TfrmGivenMRRs);

end.

