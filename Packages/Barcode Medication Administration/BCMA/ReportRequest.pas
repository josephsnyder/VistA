unit ReportRequest;
{
================================================================================
*	File:  ReportRequest.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 26 $  $Modtime: 2/06/02 9:30a $
*
*	Description:  This is the Report Request Form for the application.
*
*	Notes: ResizeForm uses all components whether visible or hidden to calculate
* height.  It does not allow components to be added hidden without affecting the
* height of the form.
*
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, BCMA_Common, BCMA_Objects, Menus, ToolWin,
  BCMA_Util, CommCtrl, ActnList;

procedure DueListReport(PatientIEN: string);
(*
  Uses form frmReportRequest to prompt for user input parameters and then
  display a Due List report for the selected patient.
  Exclusive
*)

procedure MedicationLogReport(PatientIEN: string);
(*
  Uses form frmReportRequest to prompt for user input parameters and then
  display a Medication Log report for the selected patient.
*)

//procedure MedicationsGivenReport(PatientIEN: string);
procedure MedAdminHistoryReport(PatientIEN: string); // rpk 6/1/2012
(*
  Uses form frmReportRequest to prompt for user input parameters and then
  display a Medication Admin History report for the selected patient.
*)

procedure WardAdministrationTimeReport(PatientIEN: string);
(*
  Uses form frmReportRequest to prompt for user input parameters and then
  display a Ward Administration Time report for the selected patient.
  Exclusive
*)

procedure MissedMedicationsReport(PatientIEN: string);
(*
  Uses form frmReportRequest to prompt for user input parameters and then
  display a Due List report for the selected patient.
  Exclusive
*)

procedure MedicationHistoryReport(PatientIEN, OrderableItemIEN, OrderNumberIn:
  string);
(*
  Uses form frmReportRequest to prompt for user inputparameters and then
      uses form frmReport to display a Medication History report for the
  selected patient and orderable item.
*)

procedure PRNEffectivenessListReport(PatientIEN: string);
{
  Uses form frmReportRequest to prompt for user inputparameters and then
  uses form frmReport to display a prnEffectiveness report.
}

procedure DisplayOrder(inPatientIEN, InOrderNumber: string);
(*
  Uses form frmReport to display a complete description of the selected
  patient and order.
*)

procedure MedicationVarianceLog(PatientIEN: string);

procedure VitalsCumulativeReport(PatientIEN: string);

procedure UnknownActionsReport(PatientIEN: string);

procedure DisplayPatientFlags;

procedure UnableToScanDetailedReport;

procedure UnableToScanSummaryReport;

procedure MedOverviewReport;            // Exclusive

procedure PRNOverviewReport;            // Exclusive

procedure IVOverviewReport;             // Exclusive

procedure ExpiredOrdersReport;          // Exclusive

procedure IVBagStatusReport;

procedure MedTherapyReport;

type
  TfrmReportRequest = class(TForm)
    pnlBottom: TPanel;
    pnlBottomButtons: TPanel;
    PageControl: TPageControl;
    tsDueList: TTabSheet;
    tsMedicationLog: TTabSheet;
    tsMedicationsGiven: TTabSheet;
    tsWardAdministrationTimes: TTabSheet;
    btnPreview: TButton;
    btnCancel: TButton;
    tsMissedMedications: TTabSheet;
    grpPrintBy: TGroupBox;
    rbtnPatient: TRadioButton;
    rbtnWard: TRadioButton;
    cbxWards: TComboBox;
    tbshtPRNEffectivenessList: TTabSheet;
    tbshtMedVarianceLog: TTabSheet;
    tbshtVitalsCumulative: TTabSheet;
    tbshtMedHistory: TTabSheet;
    tbshtUnknownActions: TTabSheet;
    tbshtUnableToScanSummary: TTabSheet;
    pnlDateTimeRange: TPanel;
    pnlDateRange: TPanel;
    pnlTimeRange: TPanel;
    grpStartDate: TGroupBox;
    grpStopDate: TGroupBox;
    grpStartTime: TGroupBox;
    grpStopTime: TGroupBox;
    dtpkrStart: TDateTimePicker;
    dtpkrStop: TDateTimePicker;
    cbxStart: TComboBox;
    cbxStop: TComboBox;
    pnlCenterDueList: TPanel;
    grpIncludeScheduleTypes: TGroupBox;
    cbxDLContinuous: TCheckBox;
    cbxDLPRN: TCheckBox;
    cbxDLOnCall: TCheckBox;
    cbxDLOneTime: TCheckBox;
    grpIncludeOrderTypes: TGroupBox;
    cbxIncludeIV: TCheckBox;
    cbxIncludeUD: TCheckBox;
    cbxIncludeFuture: TCheckBox;
    cbxIncludeAddendums: TCheckBox;
    pnlCenterMedLog: TPanel;
    grpInclude: TGroupBox;
    cbComments: TCheckBox;              // MedLog Comments
    cbAudits: TCheckBox;                // MedLog Audits
    pnlCenterMedHistory: TPanel;
    grpIncludeMedHistory: TGroupBox;
    chkMedHistoryComments: TCheckBox;
    tbshtUnableToScanDetailed: TTabSheet;
    pnlCenterUtSDetailed: TPanel;
    grpSortBy: TGroupBox;
    pnlUtSDetailedSortDir: TPanel;
    rbtnAscending: TRadioButton;
    rbtnDescending: TRadioButton;
    tbshtMedicationOverview: TTabSheet;
    tbshtPRNOverview: TTabSheet;
    tbshtIVOverview: TTabSheet;
    tbshtExpiredOrders: TTabSheet;
    tbshtMedTherapy: TTabSheet;
    tbshtIVBagStatus: TTabSheet;
    pnlCenterMM: TPanel;
    grpMMIncludeOrderStatus: TGroupBox;
    chkMMActive: TCheckBox;
    chkMMDCd: TCheckBox;
    chkMMExpired: TCheckBox;
    grpIncludeStatus: TGroupBox;
    chkMMMissingDose: TCheckBox;
    chkMMHeld: TCheckBox;
    chkMMRefused: TCheckBox;
    grpMMInclude: TGroupBox;
    chkMMComments: TCheckBox;
    pnlCenterMO: TPanel;
    grpMOIncludeOrderTypes: TGroupBox;
    chkMOFuture: TCheckBox;
    chkMOActive: TCheckBox;
    chkMOExpired: TCheckBox;
    grpMOIncludeDetail: TGroupBox;
    chkMOActions: TCheckBox;
    chkMOComments: TCheckBox;
    pnlCenterPRN: TPanel;
    grpPRNIncludeOrderTypes: TGroupBox;
    chkPRNFuture: TCheckBox;
    chkPRNActive: TCheckBox;
    chkPRNExpired: TCheckBox;
    grpIncludeDetail: TGroupBox;
    chkPRNActions: TCheckBox;
    chkPRNComments: TCheckBox;
    pnlCenterIVO: TPanel;
    grpIVOIncludeOrderTypes: TGroupBox;
    chkIVOStopped: TCheckBox;
    chkIVOInfusing: TCheckBox;
    chkIVOOthers: TCheckBox;
    grpIVOIncludeDetail: TGroupBox;
    chkIVOActions: TCheckBox;
    chkIVOComments: TCheckBox;
    pnlCenterEX: TPanel;
    grpEXIncludeOrderTypes: TGroupBox;
    chkEXExpiring: TCheckBox;
    chkEXExpired: TCheckBox;
    chkEXExpiringTomorrow: TCheckBox;
    grpEXIncludeDetail: TGroupBox;
    chkEXActions: TCheckBox;
    chkEXComments: TCheckBox;
    pnlCenterIVB: TPanel;
    grpIVBIncludeOrderStatus: TGroupBox;
    chkIVBDCd: TCheckBox;
    chkIVBActive: TCheckBox;
    chkIVBExpired: TCheckBox;
    grpIVBIncludeBagStatus: TGroupBox;
    chkIVBCompleted: TCheckBox;
    chkIVBInfusing: TCheckBox;
    chkIVBStopped: TCheckBox;
    chkIVBMissing: TCheckBox;
    chkIVBHeld: TCheckBox;
    chkIVBRefused: TCheckBox;
    chkIVBNoAction: TCheckBox;
    grpIVBIncludeDetail: TGroupBox;
    chkIVBComments: TCheckBox;
    btnPrint: TButton;
    rgrpWardOptions: TRadioGroup;
    btnSelectPatients: TButton;
    chkExcludeInactiveWards: TCheckBox;
    pnlCenterMedTherapy: TPanel;
    grpMedTherapyIncludeScheduleTypes: TGroupBox;
    grpMedTherapyIncludeDetail: TGroupBox;
    chkMedTherapyComments: TCheckBox;
    chkMedTherapyContinuous: TCheckBox;
    chkMedTherapyPRN: TCheckBox;
    chkMedTherapyOnCall: TCheckBox;
    chkMedTherapyOneTime: TCheckBox;
    grpMedicationSearch: TGroupBox;
    btnSelectMedications: TButton;
    edtMedTherapyMedicationsSelected: TEdit;
    edtPatientsSelected: TEdit;
    grpMSFReason: TGroupBox;
    cbxMSFReasons: TComboBox;
    rgScanFailureType: TRadioGroup;
    cbxUtSDetailedSortBy: TComboBox;
    grpMSFSortBy: TGroupBox;
    grpMSFFor: TGroupBox;
    cbxForSelectWard: TComboBox;
    cbForExcludeInactiveWards: TCheckBox;
    rbForSelectWard: TRadioButton;
    rbForAllWardsPatients: TRadioButton;
    GroupBox2: TGroupBox;
    cbxSort1: TComboBox;
    rbSort1Asc: TRadioButton;
    rbSort1Desc: TRadioButton;
    GroupBox3: TGroupBox;
    cbxSort2: TComboBox;
    rbSort2Asc: TRadioButton;
    rbSort2Desc: TRadioButton;
    GroupBox4: TGroupBox;
    cbxSort3: TComboBox;
    rbSort3Asc: TRadioButton;
    rbSort3Desc: TRadioButton;
    grpUASSummaryFor: TGroupBox;
    rbEntireFacility: TRadioButton;
    rbNurseUnitLocation: TRadioButton;
    cbxUASSummaryWardList: TComboBox;
    cbUASSummaryExcludeInactiveWards: TCheckBox;
    rbUASSummaryWard: TRadioButton;
    cbExcludeMasWards: TCheckBox;
    cbExcludeMasWardsDetailed: TCheckBox;
    chkIVBOtherPrintInfo: TCheckBox;
    chkPRNSpecInstr: TCheckBox;
    chkMOSpecInstr: TCheckBox;
    chkIVOtherPrintInfo: TCheckBox;
    chkEXSpecInstr: TCheckBox;
    pnlPrintByWardOptions: TPanel;
    grpDLInclDetail: TGroupBox;
    chkDLIncludeSpecInstr: TCheckBox;
    rgrpMMOrderMode: TRadioGroup;
    btnSelectClinics: TButton;
    rbtnClinic: TRadioButton;
    lblSelectedClinicsMsg: TStaticText;
    txtBanner: TStaticText;
    rgrpDLOrderMode: TRadioGroup;
    pnlCenterAT: TPanel;
    rgrpATOrderMode: TRadioGroup;
    rgrpMOOrderMode: TRadioGroup;
    rgrpPOOrderMode: TRadioGroup;
    rgrpIVOrderMode: TRadioGroup;
    rgrpEXOrderMode: TRadioGroup;
    procedure cbExcludeMasWardsDetailedClick(Sender: TObject);
    procedure cbExcludeMasWardsClick(Sender: TObject);
    procedure cbUASSummaryExcludeInactiveWardsClick(Sender: TObject);
    procedure rbUASSummaryWardClick(Sender: TObject);
    procedure rbNurseUnitLocationClick(Sender: TObject);
    procedure rbEntireFacilityClick(Sender: TObject);
    procedure cbxSort2DropDown(Sender: TObject);
    procedure cbxSort3DropDown(Sender: TObject);
    procedure tbshtUnableToScanDetailedShow(Sender: TObject);
    procedure cbxSort1Change(Sender: TObject);
    procedure rbSort3DescClick(Sender: TObject);
    procedure rbSort3AscClick(Sender: TObject);
    procedure rbSort2DescClick(Sender: TObject);
    procedure rbSort2AscClick(Sender: TObject);
    procedure cbxSort3Change(Sender: TObject);
    procedure cbxSort2Change(Sender: TObject);
    procedure rbSort1DescClick(Sender: TObject);
    procedure rbSort1AscClick(Sender: TObject);
    procedure cbForExcludeInactiveWardsClick(Sender: TObject);
    procedure rbForAllWardsPatientsClick(Sender: TObject);
    procedure rbForSelectWardClick(Sender: TObject);
    procedure cbxMSFReasonsChange(Sender: TObject);
    procedure rgScanFailureTypeClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    (*
      Closes the form without displaying the report.
    *)

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    (*
      Releases the memory allocated for the form when the form is closed.
    *)

    procedure btnPreviewClick(Sender: TObject);
    (*
      Uses method ExecuteReport to display the desired report, using the
      user's selected options.
    *)

    procedure FormCreate(Sender: TObject);
    (*
      Creates the form then sets the initial visibility of all pagecontrol
      tabs to false.
    *)

    procedure FormShow(Sender: TObject);
    {
     Sets the form caption according to the value of ReportType.
    }

    procedure rbtnPatientClick(Sender: TObject);
    {
      Enabled/disable controls
    }

    function PrepareUnableToScanSummaryReport: Boolean;
    {
      Prepare the MSF Unable To Scan Summary Report
    }

    function PrepareUnableToScanDetailedReport: Boolean;
    {
      Prepare the MSF Unable To Scan Detailed Report
    }

    procedure rbtnWardClick(Sender: TObject);
    procedure cbxUtSDetailedSortByChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnSelectPatientsClick(Sender: TObject);
    procedure rgrpWardOptionsClick(Sender: TObject);
    procedure chkMOActionsClick(Sender: TObject);
    procedure chkPRNActionsClick(Sender: TObject);
    procedure chkIVOActionsClick(Sender: TObject);
    procedure chkEXActionsClick(Sender: TObject);
    procedure chkExcludeInactiveWardsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSelectMedicationsClick(Sender: TObject);
    procedure cbxWardsChange(Sender: TObject);
    procedure btnSelectClinicsClick(Sender: TObject);
    procedure rbtnClinicClick(Sender: TObject);
    procedure rgrpMMOrderModeClick(Sender: TObject);
    procedure cbCommentsClick(Sender: TObject);

    (*
        Eabled/disable controls
    *)

  private
    { Private declarations }
    procedure GetWardList();
    {
      Add the wards to cbxWards
    }

    function GetPatientWard: string;
    {
      Check to see if rbtnPatient is checked and set Result accordingly
    }

    function GetPatientRoomBed: string;
    {
      Check to see if rbtnPrintbyPatient is checked and set Result accordingly
    }

    procedure SetupForm(DateRange, ShowTimes: Boolean; ShowDates: Boolean =
      True; ExclusiveMode: Boolean = False);
    function CheckTimes: Boolean;
    function CheckDates: Boolean;
    procedure SetSelectClinicsCaption;
    procedure SetSelectPatientsCaption;
    procedure SetWardOptions;
    procedure ResizeForm;

    procedure InsertToSortList(S: string);
    procedure RemoveFromSortList(S: string);
    procedure CheckForDateTime(SortItem: Integer);
    procedure InitializeSortLists;
    procedure EnableClinicControls(setVal: Boolean);

    // set default radio button index for ingrp based on OrderMode
    // set prtOrderMode for ingrp based on radio button index
    procedure SetOrderMode(inrgrp: TRadioGroup);

  public
    { Public declarations }
    ReportType: TReportTypes;
  end;

var
  frmReportRequest: TfrmReportRequest;

  //  UserDivision: TBCMA_Division;
  //  DivSiteList: TStringList;
  //  DefaultDivSite: String;

  MedicationList,
    SelectedMedications: TList;
  ClinicList, SelectedClinics: TList;

  CloseFrm: Boolean;

implementation

{$R *.DFM}

uses
  BCMA_Startup, Report, oReport, BCMA_Main, fPrintPtSelect,
  fMedTherapyMedSelection, fPrtClinicSel, Types;
//   MFunStr;

const
//  GoToReportTabSheet: array[TReportTypes] of Integer =
//  (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
//    21);

  //
  // NOTE: starting with rtPatientInquiry, there is no tab on PageControl corresponding
  // to the report type
  //
  GoToReportTabSheet: array[TReportTypes] of Integer =
  (ord(rtDueList),
    ord(rtMedicationLog),
    ord(rtMedicationsGiven),
    ord(rtWardAdministrationTimes),
    ord(rtMissedMedications),
    ord(rtPRNEffectives),
    ord(rtMedicationVarianceLog),
    ord(rtVitalsCumulative),
    ord(rtPatientMedicationHistory),
    ord(rtUnknownActions),
    ord(rtUnableToScanDetailed),
    ord(rtUnableToScanSummary),
    ord(rtMedicationOverview),
    ord(rtPRNOverview),
    ord(rtIVOverview),
    ord(rtExpiredOrders),
    ord(rtMedTherapy),
    ord(rtIVBagStatus),

    ord(rtPatientInquiry),
    ord(rtAllergyReactions),
    ord(rtDisplayOrder),
    ord(rtPatientFlags));
var
  prtOrderMode: TOrderMode;             // rpk 6/6/2012

procedure TfrmReportRequest.FormCreate(Sender: TObject);
var
  ii: integer;
begin
  for ii := 0 to PageControl.PageCount - 1 do
    PageControl.Pages[ii].TabVisible := False;
  GetWardList;
  cbxWards.ItemIndex := -1;
  rbtnPatient.Enabled := frmMain.pnlMainForm.Visible;
  if not rbtnPatient.Enabled then
    rbtnWard.Checked := True;
  BCMA_Report.ReportPatientList.Clear;
  BCMA_Report.TypeReasonParams := '';   {JK 6/4/2008}
  //  BCMA_Report.NurseMasCode  := '';
  BCMA_Report.SiteDivisionCode := '';
  BCMA_Report.SpInOtIn := '';           // rpk 3/25/2009
  txtBanner.Hide;                       // rpk 5/31/2012
  CloseFrm := True;
  MedicationList := TList.Create;
  SelectedMedications := TList.Create;
  ClinicList := TList.Create;           // rpk 5/25/2012
  SelectedClinics := TList.Create;      // rpk 5/25/2012

  prtOrderMode := OrderMode;            // rpk 6/6/2012

  rgrpATOrderMode.ItemIndex := -1;      // rpk 8/22/2012
  rgrpDLOrderMode.ItemIndex := -1;      // rpk 8/22/2012
  rgrpEXOrderMode.ItemIndex := -1;      // rpk 8/22/2012
  rgrpIVOrderMode.ItemIndex := -1;      // rpk 8/22/2012
  rgrpMMOrderMode.ItemIndex := -1;      // rpk 8/22/2012
  rgrpMOOrderMode.ItemIndex := -1;      // rpk 8/22/2012
  rgrpPOOrderMode.ItemIndex := -1;      // rpk 8/22/2012

  //  {JK 7/3/2008 - last minute addition of Division combobox}
  //  UserDivision := TBCMA_Division.Create;
  //  DivSiteList := TStringList.Create;
end;                                    // FormCreate

procedure TfrmReportRequest.FormDestroy(Sender: TObject);
begin
  BCMA_Report.ClearMedicationList;
  BCMA_Report.ClearSelectedMedications;
//  BCMA_Report.ClearClinicList;
//  BCMA_Report.ClearSelectedMedications;
  BCMA_Report.ClearClinicList(ClinicList); // rpk 9/13/2012
  BCMA_Report.ClearClinicList(SelectedClinics); // rpk 9/13/2012

  MedicationList.Free;
  SelectedMedications.Free;
  FreeAndNil(ClinicList);               // rpk 5/25/2012
  FreeAndNil(SelectedClinics);          // rpk 5/25/2012
  //  UserDivision.Free;
  //  DivSiteList.Free;
end;                                    // FormDestroy

procedure TfrmReportRequest.FormResize(Sender: TObject);
begin
  grpStartDate.Width := (pnlDateTimeRange.Width - grpStartDate.Margins.Left * 4)
    div 2;
  grpStartTime.Width := grpStartDate.Width;
end;                                    // FormResize

procedure TfrmReportRequest.FormShow(Sender: TObject);
begin
  self.caption := ReportCaptions[ReportType];
  // Set Help for Form to Help of TabSheet for help for specific report request.
  HelpContext := PageControl.ActivePage.HelpContext; // rpk 9/9/2010
  //ResizeForm;
end;                                    // FormShow

procedure TfrmReportRequest.SetOrderMode(inrgrp: TRadioGroup);
begin
  inrgrp.ItemIndex := ord(OrderMode);

  if ord(inrgrp.ItemIndex) >= 0 then
    if prtOrderMode <> TOrderMode(inrgrp.ItemIndex) then
      prtOrderMode := TOrderMode(inrgrp.ItemIndex);

end;                                    // SetOrderMode


procedure TfrmReportRequest.EnableClinicControls(setVal: Boolean);
begin
  rbtnClinic.Enabled := SetVal;
  btnSelectClinics.Enabled := SetVal;
  lblSelectedClinicsMsg.Enabled := SetVal;
end;                                    // EnableClinicControls

// Exclusive mode

procedure DueListReport(PatientIEN: string);
begin
  frmReportRequest := TfrmReportRequest.Create(Application);
  with frmReportRequest do
  try
    ReportType := rtDueList;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];

    SetOrderMode(rgrpDLOrderMode);      // rpk 8/22/2012
    tsDueList.TabVisible := True;
    ResizeForm;
    pnlCenterDueList.Align := alClient;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // DueListReport

// combined

procedure MedicationLogReport(PatientIEN: string);
begin
//  with TfrmReportRequest.Create(Application) do
  frmReportRequest := TfrmReportRequest.Create(Application);
  with frmReportRequest do
  try
    ReportType := rtMedicationLog;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, True);
    tsMedicationLog.TabVisible := True;
    cbComments.Checked := BCMA_SiteParameters.ReportInclCmt;
    txtBanner.Show;                     // rpk 5/31/2012
    EnableClinicControls(False);        // rpk 5/31/2012
    ResizeForm;
    pnlCenterMedLog.Align := alClient;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // MedicationLogReport

// combined

procedure MedAdminHistoryReport(PatientIEN: string);
begin
//  with TfrmReportRequest.Create(Application) do
  frmReportRequest := TfrmReportRequest.Create(Application);
  with frmReportRequest do
  try
    ReportType := rtMedicationsGiven;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, False);

    //			dtpkrStart.date := date - 6;
    //      dtpkrStop.Date := date;
    dtpkrStart.date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)) - 6;
    //bjr 5/12/10 for BCMA00000425
    dtpkrStop.Date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)); //bjr 5/12/10 for BCMA00000425

    txtBanner.Show;                     // rpk 6/1/2012
    EnableClinicControls(False);        // rpk 6/1/2012
    ResizeForm;
    tsMedicationsGiven.TabVisible := True;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // MedAdminHistoryReport

// Exclusive mode

procedure WardAdministrationTimeReport(PatientIEN: string);
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtWardAdministrationTimes;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
//    SetupForm(True, False);

    SetOrderMode(rgrpATOrderMode);      // rpk 8/22/2012
    { if  rgrpATOrderMode.ItemIndex = ord(OrderMode) then
      SetupForm(True, False, True, True)  // rpk 6/28/2012
    else
      rgrpATOrderMode.ItemIndex := ord(OrderMode); }

    with pnlCenterAT do begin
      bringtofront;
//      align := alClient;
      Show;
    end;

    tsWardAdministrationTimes.TabVisible := True;
    ResizeForm;
    pnlCenterAT.Align := alClient;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // WardAdministrationTimeReport

// Exclusive Mode

procedure MissedMedicationsReport(PatientIEN: string);
begin
//  with TfrmReportRequest.Create(Application) do
  frmReportRequest := TfrmReportRequest.Create(Application);
  with frmReportRequest do
  try
    ReportType := rtMissedMedications;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
//    SetupForm(True, True);

    SetOrderMode(rgrpMMOrderMode);      // rpk 8/22/2012
    { if rgrpMMOrderMode.ItemIndex = ord(OrderMode) then  // rpk 7/3/2012
      SetupForm(True, True, True, True)  // rpk 8/22/2012
    else
      rgrpMMOrderMode.ItemIndex := ord(OrderMode); }

    ResizeForm;
    pnlCenterMM.Align := alClient;
    // disable parameter update of chkMMComments;
    // use Checked True as default for Missed Medications Report
    //    chkMMComments.Checked := BCMA_SiteParameters.ReportInclCmt;

    tsMissedMedications.TabVisible := True;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // MissedMedicationsReport

procedure PRNEffectivenessListReport(PatientIEN: string);
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtPRNEffectives;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, True);
    tbshtPRNEffectivenessList.TabVisible := True;
    txtBanner.Show;                     // rpk 7/6/2012
    EnableClinicControls(False);        // rpk 7/6/2012
    ResizeForm;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // PRNEffectivenessListReport

procedure MedicationHistoryReport(PatientIEN, OrderableItemIEN, OrderNumberIn:
  string);
begin
  with BCMA_Report do
  begin
    Clear;
    OrderNumber := OrderableItemIEN;
    OrderNumber2 := OrderNumberIn;
  end;

  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtPatientMedicationHistory;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, False);

    //			dtpkrStart.date := date - BCMA_SiteParameters.MedHistDaysBack + 1;
    //      dtpkrStop.Date := date;
    dtpkrStart.date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)) -
      BCMA_SiteParameters.MedHistDaysBack + 1; //bjr 5/12/10 for BCMA00000425
    dtpkrStop.Date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)); //bjr 5/12/10 for BCMA00000425

    chkMedHistoryComments.Checked := BCMA_SiteParameters.ReportInclCmt;
    rbtnWard.Enabled := False;
    txtBanner.Show;                     // rpk 5/31/2012
    EnableClinicControls(False);        // rpk 5/31/2012
    ResizeForm;
    pnlCenterMedHistory.Align := alClient;
    tbshtMedHistory.TabVisible := True;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // MedicationHistoryReport

procedure DisplayOrder(inPatientIEN, InOrderNumber: string);
begin
  with BCMA_Report do
  begin
    Clear;
    ReportType := rtDisplayOrder;
    PatientIEN := BCMA_Patient.IEN;
    OrderNumber := InOrderNumber;
    PatientWard := 'P';
    Execute;
  end;
end;                                    // DisplayOrder

procedure MedicationVarianceLog(PatientIEN: string);
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtMedicationVarianceLog;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, True);
    tbshtMedVarianceLog.TabVisible := True;
    ResizeForm;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // MedicationVarianceLog

procedure VitalsCumulativeReport(PatientIEN: string);
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtVitalsCumulative;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, False);
    tbshtVitalsCumulative.TabVisible := True;
    rbtnWard.Enabled := False;
    ResizeForm;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // VitalsCumulativeReport

procedure UnknownActionsReport(PatientIEN: string);
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtUnknownActions;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, False);
    grpPrintBy.Visible := False;

    //			dtpkrStart.date := date - 6;
    dtpkrStart.date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)) - 6;
    //bjr 5/12/10 for BCMA00000425

    tbshtUnknownActions.TabVisible := True;
    rbtnWard.Enabled := False;
    ResizeForm;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // UnknownActionsReport

procedure UnableToScanDetailedReport;
//var
//  x: integer;
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtUnableToScanDetailed;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, True);
    grpPrintBy.Visible := False;

    //			dtpkrStart.date := date - 6;
    dtpkrStart.date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)) - 6;
    //bjr 5/12/10 for BCMA00000425

    grpSortBy.Enabled := False;
    grpSortBy.Visible := False;

    rbtnWard.Enabled := False;
    cbxWards.Enabled := False;
    tbshtUnableToScanDetailed.TabVisible := True;
    with grpMSFSortBy do begin          // rpk 7/30/2010
//      Align := alBottom;  // rpk 7/30/2010
      BringToFront;                     // rpk 7/30/2010
      Show;                             // rpk 7/30/2010
    end;                                // rpk 7/30/2010
    pnlCenterUtSDetailed.Align := alClient;
    pnlCenterUtSDetailed.SendToBack;    // rpk 7/30/2010

    rgScanFailureType.Top := 2 * (grpStartDate.Top + grpStartDate.Height) + 5;
    rgScanFailureType.Left := grpStartDate.Left;
    rgScanFailureType.Width := (pnlDateTimeRange.Width -
      grpStartDate.Margins.Left * 4) div 2;

    grpMSFReason.Top := rgScanFailureType.Top;
    grpMSFReason.Width := rgScanFailureType.Width;

    grpMSFFor.Top := grpMSFReason.Top + grpMSFReason.Height + 5;
    grpMSFFor.Left := grpStartDate.Left;

    grpMSFSortBy.Top := grpMSFFor.Top + grpMSFFor.Height + 5;
    grpMSFSortBy.Left := grpStartDate.Left;

    //      DefaultDivSite := '';
    //      DivSiteList.Clear;
    //      DivSiteList.AddStrings(UserDivision.GetSiteList);
    //      PrepareDivisionList(DivSiteList, DefaultDivSite);
    //      cbxDivisionListMSFDetailed.Clear;
    //      cbxDivisionListMSFDetailed.Items.AddStrings(DivSiteList);
    //      cbxDivisionListMSFDetailed.ItemIndex := cbxDivisionListMSFDetailed.Items.IndexOf(DefaultDivSite);
    //      cbxDivisionListMSFDetailedCloseUp(nil);

    SetWardOptions;

    ShowModal;

  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // UnableToScanDetailedReport

procedure UnableToScanSummaryReport;
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtUnableToScanSummary;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, True);

    grpPrintBy.Visible := False;

    //			dtpkrStart.date := date - 6;
    //      dtpkrStop.date := date;
    dtpkrStart.date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)) - 6;
    //bjr 5/12/10 for BCMA00000425
    dtpkrStop.date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)); //bjr 5/12/10 for BCMA00000425

    tbshtUnableToScanSummary.TabVisible := True;
    rbtnWard.Enabled := False;
    cbxWards.Enabled := False;
    rbtnPatient.Enabled := False;
    rbtnPatient.Checked := False;

    grpUASSummaryFor.Top := 2 * (grpStartDate.Top + grpStartDate.Height) + 5;
    grpUASSummaryFor.Left := grpStartDate.Left;

    ResizeForm;

    //      DefaultDivSite := '';
    //      DivSiteList.Clear;
    //      DivSiteList.AddStrings(UserDivision.GetSiteList);
    //      PrepareDivisionList(DivSiteList, DefaultDivSite);
    //      cbxDivisionListMSFSummary.Clear;
    //      cbxDivisionListMSFSummary.Items.AddStrings(DivSiteList);
    //      cbxDivisionListMSFSummary.ItemIndex := cbxDivisionListMSFSummary.Items.IndexOf(DefaultDivSite);
    //      cbxDivisionListMSFSummaryCloseUp(nil);

    SetWardOptions;

    ShowModal;

  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // UnableToScanSummaryReport

// Exclusive mode

procedure MedOverviewReport;
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtMedicationOverview;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
//    SetupForm(False, False, False);

    SetOrderMode(rgrpMOOrderMode);      // rpk 8/22/2012
    { if  rgrpMOOrderMode.ItemIndex = ord(OrderMode) then  // rpk 7/3/2012
      SetupForm(False, False, False, True)  // rpk 8/22/2012
    else
      rgrpMOOrderMode.ItemIndex := ord(OrderMode); }

    SetWardOptions;
    ResizeForm;
    pnlCenterMO.Align := alClient;
    chkMOComments.Checked := BCMA_SiteParameters.ReportInclCmt;
    grpPrintBy.Visible := True;
    tbshtMedicationOverview.TabVisible := True;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // MedOverviewReport

// Exclusive mode

procedure PRNOverviewReport;
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtPRNOverview;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
//    SetupForm(False, False, False);

    SetOrderMode(rgrpPOOrderMode);      // rpk 8/22/2012
    { if  rgrpPOOrderMode.ItemIndex = ord(OrderMode) then  // rpk 7/3/2012
      SetupForm(False, False, False, True)  // rpk 8/22/2012
    else
      rgrpPOOrderMode.ItemIndex := ord(OrderMode); }

    SetWardOptions;
    ResizeForm;
    pnlCenterPRN.Align := alClient;
    chkPRNComments.Checked := BCMA_SiteParameters.ReportInclCmt;
    grpPrintBy.Visible := True;
    tbshtPRNOverview.TabVisible := True;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // PRNOverviewReport

// Exclusive mode

procedure IVOverviewReport;
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtIVOverview;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
//    SetupForm(False, False, False);

    SetOrderMode(rgrpIVOrderMode);      // rpk 8/22/2012
    { if  rgrpIVOrderMode.ItemIndex = ord(OrderMode) then  // rpk 7/3/2012
      SetupForm(False, False, False, True)  // rpk 8/22/2012
    else
      rgrpIVOrderMode.ItemIndex := ord(OrderMode); }

    SetWardOptions;
    ResizeForm;
    pnlCenterIVO.Align := alClient;
    chkIVOComments.Checked := BCMA_SiteParameters.ReportInclCmt;
    grpPrintBy.Visible := True;
    tbshtIVOverview.TabVisible := True;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // IVOverviewReport

// Exclusive mode

procedure ExpiredOrdersReport;
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtExpiredOrders;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
//    SetupForm(False, False, False);

    SetOrderMode(rgrpEXOrderMode);      // rpk 8/22/2012
    { if  rgrpEXOrderMode.ItemIndex = ord(OrderMode) then  // rpk 8/22/2012
      SetupForm(False, False, False, True)  // rpk 8/22/2012
    else
      rgrpEXOrderMode.ItemIndex := ord(OrderMode); }

    SetWardOptions;
    ResizeForm;
    pnlCenterEX.Align := alClient;
    chkEXComments.Checked := BCMA_SiteParameters.ReportInclCmt;
    grpPrintBy.Visible := True;
    tbshtExpiredOrders.TabVisible := True;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // ExpiredOrdersReport

procedure IVBagStatusReport;
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtIVBagStatus;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, True, True);
    SetWardOptions;

    //      dtpkrStart.date := date - 3;
    dtpkrStart.date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)) - 3;
    //bjr 5/12/10 for BCMA00000425

    txtBanner.Show;                     // rpk 7/6/2012
    EnableClinicControls(False);        // rpk 7/6/2012
    ResizeForm;
    pnlCenterIVB.Align := alClient;
    chkIVBComments.Checked := BCMA_SiteParameters.ReportInclCmt;
    grpPrintBy.Visible := True;
    tbshtIVBagStatus.TabVisible := True;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // IVBagStatusReport

procedure MedTherapyReport;
begin
  with TfrmReportRequest.Create(Application) do
  try
    ReportType := rtMedTherapy;
    PageControl.ActivePageIndex := GoToReportTabSheet[ReportType];
    SetupForm(True, False, True);
    SetWardOptions;

    //      dtpkrStart.date := date - 1;
    dtpkrStart.date := strtodate(FormatDateTime('ddddd', now +
      BCMA_SiteParameters.ServerClockVariance)) - 1;
    //bjr 5/12/10 for BCMA00000425

    txtBanner.Show;                     // rpk 7/6/2012
    EnableClinicControls(False);        // rpk 7/6/2012
    ResizeForm;
    pnlCenterMedTherapy.Align := alClient;
    chkMedTherapyComments.Checked := BCMA_SiteParameters.ReportInclCmt;
    grpPrintBy.Visible := True;
    tbshtMedTherapy.TabVisible := True;
    ShowModal;
  finally
//    Free;
    Release;                            // rpk 6/18/2013
  end;
end;                                    // MedTherapyReport

procedure DisplayPatientFlags;
begin
  with BCMA_Report do
  begin
    Clear;
    ReportType := rtPatientFlags;
    PatientIEN := BCMA_Patient.IEN;
    Execute;
  end;

end;                                    // DisplayPatientFlags

////////////////////////////// TfrmReportRequest Stuff

procedure TfrmReportRequest.btnCancelClick(Sender: TObject);
begin
  CloseFrm := True;
  Close;
end;                                    // btnCancelClick

procedure TfrmReportRequest.FormClose(Sender: TObject; var Action:
  TCloseAction);
begin
  if CloseFrm then
    Action := caFree
  else
  begin
    CloseFrm := True;
    Action := caNone;
    btnPreview.Enabled := True;
    btnPrint.Enabled := True;
  end;

end;                                    // FormClose

procedure TfrmReportRequest.btnPreviewClick(Sender: TObject);
const
  FT_Text: array[boolean] of char = ('0', '1');

var
  dt0,
    dt1,
    DLParamsTmp,
    DLParams2Tmp: string;
begin
  btnPreview.Enabled := False;
  btnPrint.Enabled := False;

  //  if (rgrpWardOptions.ItemIndex = 2) and (rbtnWard.Checked) and (Sender = btnPreview) then
  //  begin
  //    DefMessageDlg('Preview not allowed when selecting multiple patients!', mtError, [mbOK], 0);
  //    CloseFrm := False;
  //    exit;
  //    btnPreview.Enabled := True;
  //  end;

    //if we aren't printing by multiple patients, make sure we clear the list as it
    //will be tested against downstream...
  if (rgrpWardOptions.ItemIndex = 2) and
    (BCMA_Report.ReportPatientList.Count = 0) and
    rbtnWard.Checked then begin
    DefMessageDlg('You must first select some patients on the ward!', mtError,
      [mbOK], 0);
    cbxWards.SetFocus;
    CloseFrm := False;
    btnPreview.Enabled := True;
    btnPrint.Enabled := True;
    exit;
  end;

  if (cbxWards.Enabled and (PageControl.ActivePage <> tbshtUnknownActions)) then
    if (cbxWards.ItemIndex = -1) then
    begin
      DefMessageDlg('You must select a ward when printing by ward!', mtError,
        [mbOK], 0);
      cbxWards.SetFocus;
      CloseFrm := False;
      btnPreview.Enabled := True;
      exit;
    end;
  with PageControl do

    // Due List
    if ActivePage = tsDueList then
    begin
      if CheckTimes then
        exit;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + cbxStart.text;
      dt1 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + cbxStop.text;
      with BCMA_Report do
      begin
        Clear;
        ReportType := rtDueList;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        DLParams := FT_Text[cbxDLContinuous.checked] + '^' +
          FT_Text[cbxDLPRN.checked] + '^' +
          FT_Text[cbxDLOnCall.checked] + '^' +
          FT_Text[cbxDLOneTime.checked];
        PatientWard := GetPatientWard;
        OrderNumber := '';

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';
        if rbtnClinic.Checked and (SelectedClinics.Count = 0) then // rpk 5/31/2012
        begin
          DefMessageDlg('You must select clinics prior to running this report', mtInformation, [mbOK], 0);
          if btnSelectClinics.CanFocus then
            btnSelectClinics.SetFocus;
          CloseFrm := False;
          exit;
        end;
        PatientRoomBed := GetPatientRoomBed;
        DLParams2 := FT_Text[cbxIncludeAddendums.checked] + '^' +
          FT_Text[cbxIncludeIV.checked] + '^' +
          FT_Text[cbxIncludeUD.checked] + '^' +
          FT_Text[cbxIncludeFuture.checked];
        SpInOtIn := FT_Text[chkDLIncludeSpecInstr.checked]; // rpk 3/26/2009

        ItemList.Assign(BuildClinicList);

//        case rgrpDLOrderMode.ItemIndex of
        case prtOrderMode of
//          0: ClinOrd := 'I';
//          1: ClinOrd := 'C';
          omInpatient: ClinOrd := 'I';
          omClinic: ClinOrd := 'C';
        else
          ClinOrd := '';
        end;
                //Execute;
      end;                              // with BCMA_Report
    end

    // Medication Log
    else if ActivePage = tsMedicationLog then
    begin
      if CheckDates then
        exit;
      if CheckTimes then
        Exit;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + cbxStart.text;
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + cbxStop.text;

      with BCMA_Report do
      begin
        Clear;
        ReportType := rtMedicationLog;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        DLParams := '0^0^0^0^' +
          FT_Text[cbcomments.checked] + '^' +
          FT_Text[cbAudits.checked];

        PatientWard := GetPatientWard;
        OrderNumber := '';

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';
        PatientRoomBed := GetPatientRoomBed;
        //Execute;
      end;
    end

    // Medications Given
    else if ActivePage = tsMedicationsGiven then
    begin
      if CheckDates then
        exit;

      if (trunc(dtpkrStop.date) - trunc(dtpkrStart.date)) >=
        BCMA_SiteParameters.MAHMaxDays then
      begin
        DefMessageDlg('The date range cannot exceed ' +
          IntToStr(BCMA_SiteParameters.MAHMaxDays) +
          ' day(s) as defined in the CPRS ''MAXIMUM DAYS BACK'' parameter!',
          mtInformation, [mbOK], 0);
        CloseFrm := False;
        exit;
      end;
      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + '0001';
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + '2400';

      with BCMA_Report do
      begin
        Clear;
        ReportType := rtMedicationsGiven;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        DLParams := '';
        PatientWard := GetPatientWard;
        OrderNumber := '';

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        PatientRoomBed := GetPatientRoomBed;
        //Execute;
      end;
    end

    // ward administration times
    else if ActivePage = tsWardAdministrationTimes then
    begin
      if CheckDates then
        exit;
      if CheckTimes then
        Exit;

      if rbtnClinic.Checked and (SelectedClinics.Count = 0) then // rpk 5/25/2012
      begin
        DefMessageDlg('You must select clinics prior to running this report', mtInformation, [mbOK], 0);
        if btnSelectClinics.CanFocus then
          btnSelectClinics.SetFocus;
        CloseFrm := False;
        exit;
      end;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + '0001';
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + '2400';

      with BCMA_Report do
      begin
        Clear;
        ReportType := rtWardAdministrationTimes;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        DLParams := '';
        PatientWard := GetPatientWard;
        OrderNumber := '';
        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        PatientRoomBed := GetPatientRoomBed;

        ItemList.Assign(BuildClinicList);

        case prtOrderMode of
          omInpatient: ClinOrd := 'I';
          omClinic: ClinOrd := 'C';
        else
          ClinOrd := '';
        end;

        //Execute;
      end;
    end

    // Missed Medications
    else if ActivePage = tsMissedMedications then
    begin
      if CheckDates then
        exit;
      if CheckTimes then
        exit;

      if rbtnClinic.Checked and (SelectedClinics.Count = 0) then // rpk 5/25/2012
      begin
        DefMessageDlg('You must select clinics prior to running this report', mtInformation, [mbOK], 0);
        if btnSelectClinics.CanFocus then
          btnSelectClinics.SetFocus;
        CloseFrm := False;
        exit;
      end;
      if (trunc(dtpkrStop.date) - trunc(dtpkrStart.date)) >=
        BCMA_SiteParameters.MAHMaxDays then
      begin
        DefMessageDlg('The date range cannot exceed ' +
          IntToStr(BCMA_SiteParameters.MAHMaxDays) +
          ' day(s) as defined in the CPRS ''MAXIMUM DAYS BACK'' parameter!',
          mtInformation, [mbOK], 0);
        CloseFrm := False;
        exit;
      end;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + cbxStart.text;
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + cbxStop.text;
      with BCMA_Report do
      begin
        Clear;
        ReportType := rtMissedMedications;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        SetPiece(DLParams2Tmp, '^', 5, FT_Text[chkMMActive.checked]);
        SetPiece(DLParams2Tmp, '^', 8, FT_Text[chkMMDCd.checked]);
        SetPiece(DLParams2Tmp, '^', 7, FT_Text[chkMMExpired.checked]);
        SetPiece(DLParams2Tmp, '^', 16, FT_Text[chkMMMissingDose.checked]);
        SetPiece(DLParams2Tmp, '^', 17, FT_Text[chkMMHeld.checked]);
        SetPiece(DLParams2Tmp, '^', 18, FT_Text[chkMMRefused.checked]);
        DLParams2 := DLParams2Tmp;

        SetPiece(DLParamsTmp, '^', 5, FT_Text[chkMMComments.checked]);
        DLParams := DLParamsTmp;

        PatientWard := GetPatientWard;
        OrderNumber := '';

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        PatientRoomBed := GetPatientRoomBed;
        ItemList.Assign(BuildClinicList);

        case prtOrderMode of
          omInpatient: ClinOrd := 'I';
          omClinic: ClinOrd := 'C';
        else
          ClinOrd := '';
        end;
        //Execute;
      end;
    end

    // PRN Effectiveness
    else if ActivePage = tbshtPRNEffectivenessList then
    begin
      if CheckDates then
        exit;
      if CheckTimes then
        exit;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + cbxStart.text;
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + cbxStop.text;

      with BCMA_Report do
      begin
        Clear;
        ReportType := rtPRNEffectives;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        DLParams := '';
        PatientWard := GetPatientWard;
        OrderNumber := '';

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        PatientRoomBed := GetPatientRoomBed;
        //Execute;
      end;
    end

    // Medication Variance
    else if ActivePage = tbshtMedVarianceLog then
    begin
      if CheckDates then
        exit;
      if CheckTimes then
        exit;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + cbxStart.text;
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + cbxStop.text;

      with BCMA_Report do
      begin
        Clear;
        ReportType := rtMedicationVarianceLog;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        DLParams := '';
        PatientWard := GetPatientWard;
        OrderNumber := '';

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        PatientRoomBed := GetPatientRoomBed;
        //Execute;
      end;
    end

    // Vitals Cumulative
    else if ActivePage = tbshtVitalsCumulative then
    begin
      if CheckDates then
        exit;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + '0001';
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + '2400';

      with BCMA_Report do
      begin
        Clear;
        ReportType := rtVitalsCumulative;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        DLParams := '';
        PatientWard := GetPatientWard;
        OrderNumber := '';

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        PatientRoomBed := GetPatientRoomBed;
        //Execute;
      end;
    end

    // Medication History
    else if ActivePage = tbshtMedHistory then
    begin
      if CheckDates then
        exit;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + '0001';
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + '2400';
      with BCMA_Report do
      begin
        ReportType := rtPatientMedicationHistory;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        DLParams := '0^0^0^0^' +
          FT_Text[chkMedHistoryComments.checked] + '^0';
        PatientWard := 'P';

        Ward := '';

        PatientRoomBed := '';
        //Execute;
      end;
    end

    // Unknown Actions
    else if ActivePage = tbshtUnknownActions then
    begin
      if CheckDates then
        exit;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + '0001';
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + '2400';
      with BCMA_Report do
      begin
        Clear;
        ReportType := rtUnknownActions;
        PatientIEN := '';
        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        DLParams := '';
        PatientWard := '';
        OrderNumber := '';
        Ward := '';
        PatientRoomBed := '';
        //Execute;
      end;
    end

    // Unable to Scan (Detailed)
    else if ActivePage = tbshtUnableToScanDetailed then
    begin
      if not PrepareUnableToScanDetailedReport then
        Exit;
      (*
      if CheckDates then exit;

      if cbxUtSDetailedSortBy.ItemIndex = -1 then
      begin
        DefMessageDlg('You must select a sort type!', mtInformation, [mbOK], 0);
        CloseFrm := False;
        exit;
      end;

   dt0 := FormatDateTime('mmddyyyy',dtpkrStart.date)+'@'+'0001';
  dt1 := FormatDateTime('mmddyyyy',dtpkrStop.date)+'@'+'2400';
      With BCMA_Report Do
        Begin
          Clear;
          ReportType := rtUnableToScanDetailed;
          PatientIEN := '';
          StartTime := ValidMDateTime(dt0);
          StopTime := ValidMDateTime(dt1);

          DLParams := '';
          PatientWard := '';
          PatientWard := IntToStr(Integer(cbxUtSdetailedSortBy.Items.Objects[cbxUtSDetailedSortBy.ItemIndex]) + 1);
          if rbtnDescending.checked then PatientWard := '-' + PatientWard;
          OrderNumber := '';
          Ward := '';
          PatientRoomBed := '';
          //Execute;
        end;
        *)
    end

      ////////////////////////////////////////////////////////////////////////////
      ///  Unable to scan summary report
      ////////////////////////////////////////////////////////////////////////////
    else if ActivePage = tbshtUnableToScanSummary then
    begin
      if not PrepareUnableToScanSummaryReport then
        Exit;
      //        if CheckDates then exit;
      //
      //  			dt0 := FormatDateTime('mmddyyyy',dtpkrStart.date) + '@' + cbxStart.Text;
      //				dt1 := FormatDateTime('mmddyyyy',dtpkrStop.date)  + '@' + cbxStop.Text;
      //
      //        With BCMA_Report Do
      //          Begin
      //            Clear;
      //            ReportType := rtUnableToScanSummary;
      //            PatientIEN := '';
      //            StartTime := ValidMDateTime(dt0);
      //            StopTime := ValidMDateTime(dt1);
      //
      //            PatientWard := GetPatientWard;
      //
      //            if cbxWards.ItemIndex <> -1 then
      //              Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
      //            else
      //              Ward := '';
      //
      //            OrderNumber := '';
      //            PatientRoomBed := GetPatientRoomBed;
      //
      //            //Execute;
      //          end;
    end

    // Medication Overview
    else if ActivePage = tbshtMedicationOverview then
    begin
      with BCMA_Report do
      begin
        Clear;
        ReportType := rtMedicationOverview;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := '';
        StopTime := '';

        if rbtnClinic.Checked and (SelectedClinics.Count = 0) then begin // rpk 5/25/2012
          DefMessageDlg('You must select clinics prior to running this report', mtInformation, [mbOK], 0);
          if btnSelectClinics.CanFocus then
            btnSelectClinics.SetFocus;
          CloseFrm := False;
          exit;
        end;
        SetPiece(DLParamsTmp, '^', 5, FT_Text[chkMOComments.checked]);
        DLParams := DLParamsTmp;

        SetPiece(DLParams2Tmp, '^', 4, FT_Text[chkMOFuture.checked]);
        SetPiece(DLParams2Tmp, '^', 5, FT_Text[chkMOActive.checked]);
        //
        // Same checkbox for 2 different parameters?  Verify params in RPC
        //
        SetPiece(DLParams2Tmp, '^', 7, FT_Text[chkMOExpired.checked]);
        SetPiece(DLParams2Tmp, '^', 8, FT_Text[chkMOExpired.checked]);
        SetPiece(DLParams2Tmp, '^', 11, FT_Text[chkMOActions.checked]);
        DLParams2 := DLParams2Tmp;
        SpInOtIn := FT_Text[chkMOSpecInstr.checked]; // rpk 3/26/2009

        PatientWard := GetPatientWard;

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        OrderNumber := '';
        PatientRoomBed := GetPatientRoomBed;

        ItemList.Assign(BuildClinicList);
        if rbtnClinic.Checked then begin // rpk 9/19/2012
          if not LoadPatientListForClinics(ItemList) then begin // rpk 9/14/2012
            CloseFrm := False;
            exit;
          end;
        end;

        case prtOrderMode of
          omInpatient: ClinOrd := 'I';
          omClinic: ClinOrd := 'C';
        else
          ClinOrd := '';
        end;
      //Execute;
      end;
    end

    // PRN Overview
    else if ActivePage = tbshtPRNOverview then
    begin
      with BCMA_Report do
      begin
        Clear;
        ReportType := rtPRNOverview;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := '';
        StopTime := '';

        if rbtnClinic.Checked and (SelectedClinics.Count = 0) then begin // rpk 5/25/2012
          DefMessageDlg('You must select clinics prior to running this report', mtInformation, [mbOK], 0);
          if btnSelectClinics.CanFocus then
            btnSelectClinics.SetFocus;
          CloseFrm := False;
          exit;
        end;

        SetPiece(DLParamsTmp, '^', 5, FT_Text[chkPRNComments.checked]);
        DLParams := DLParamsTmp;

        SetPiece(DLParams2Tmp, '^', 4, FT_Text[chkPRNFuture.checked]);
        SetPiece(DLParams2Tmp, '^', 5, FT_Text[chkPRNActive.checked]);
        //
        // Same checkbox for 2 different parameters?  Verify params in RPC
        //
        SetPiece(DLParams2Tmp, '^', 7, FT_Text[chkPRNExpired.checked]);
        SetPiece(DLParams2Tmp, '^', 8, FT_Text[chkPRNExpired.checked]);
        SetPiece(DLParams2Tmp, '^', 11, FT_Text[chkPRNActions.checked]);
        DLParams2 := DLParams2Tmp;
        SpInOtIn := FT_Text[chkPRNSpecInstr.checked]; // rpk 3/26/2009

        PatientWard := GetPatientWard;

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        OrderNumber := '';
        PatientRoomBed := GetPatientRoomBed;

        ItemList.Assign(BuildClinicList);
        if rbtnClinic.Checked then begin // rpk 9/19/2012
          if not LoadPatientListForClinics(ItemList) then begin // rpk 9/14/2012
            CloseFrm := False;
            exit;
          end;
        end;

        case prtOrderMode of
          omInpatient: ClinOrd := 'I';
          omClinic: ClinOrd := 'C';
        else
          ClinOrd := '';
        end;
        //Execute;
      end;
    end

    // IV Overview
    else if ActivePage = tbshtIVOverview then
    begin
      with BCMA_Report do
      begin
        Clear;
        ReportType := rtIVOverview;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := '';
        StopTime := '';

        if rbtnClinic.Checked and (SelectedClinics.Count = 0) then begin // rpk 5/25/2012
          DefMessageDlg('You must select clinics prior to running this report', mtInformation, [mbOK], 0);
          if btnSelectClinics.CanFocus then
            btnSelectClinics.SetFocus;
          CloseFrm := False;
          exit;
        end;

        SetPiece(DLParamsTmp, '^', 5, FT_Text[chkIVOComments.checked]);
        DLParams := DLParamsTmp;

        SetPiece(DLParams2Tmp, '^', 11, FT_Text[chkIVOActions.checked]);
        SetPiece(DLParams2Tmp, '^', 12, FT_Text[chkIVOInfusing.checked]);
        SetPiece(DLParams2Tmp, '^', 13, FT_Text[chkIVOStopped.checked]);
        //
        // Same checkbox for multiple different parameters?  Verify params in RPC
        //
        SetPiece(DLParams2Tmp, '^', 14, FT_Text[chkIVOOthers.checked]);
        SetPiece(DLParams2Tmp, '^', 15, FT_Text[chkIVOOthers.checked]);
        SetPiece(DLParams2Tmp, '^', 16, FT_Text[chkIVOOthers.checked]);
        SetPiece(DLParams2Tmp, '^', 17, FT_Text[chkIVOOthers.checked]);
        SetPiece(DLParams2Tmp, '^', 18, FT_Text[chkIVOOthers.checked]);
        DLParams2 := DLParams2Tmp;

        SpInOtIn := FT_Text[chkIVOtherPrintInfo.checked]; // rpk 3/26/2009

        PatientWard := GetPatientWard;

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        OrderNumber := '';
        PatientRoomBed := GetPatientRoomBed;
        ItemList.Assign(BuildClinicList);
        if rbtnClinic.Checked then begin // rpk 9/19/2012
          if not LoadPatientListForClinics(ItemList) then begin // rpk 9/14/2012
            CloseFrm := False;
            exit;
          end;
        end;

        case prtOrderMode of
          omInpatient: ClinOrd := 'I';
          omClinic: ClinOrd := 'C';
        else
          ClinOrd := '';
        end;
        //Execute;
      end;
    end

    // Expired Orders
    else if ActivePage = tbshtExpiredOrders then
    begin
      with BCMA_Report do
      begin
        Clear;
        ReportType := rtExpiredOrders;
        PatientIEN := BCMA_Patient.IEN;
        StartTime := '';
        StopTime := '';

        if rbtnClinic.Checked and (SelectedClinics.Count = 0) then begin // rpk 5/25/2012
          DefMessageDlg('You must select clinics prior to running this report', mtInformation, [mbOK], 0);
          if btnSelectClinics.CanFocus then
            btnSelectClinics.SetFocus;
          CloseFrm := False;
          exit;
        end;

        SetPiece(DLParamsTmp, '^', 5, FT_Text[chkEXComments.checked]);
        DLParams := DLParamsTmp;

        //
        // Same checkbox for 2 different parameters?  Verify params in RPC
        //
        SetPiece(DLParams2Tmp, '^', 7, FT_Text[chkEXExpired.checked]);
        SetPiece(DLParams2Tmp, '^', 8, FT_Text[chkEXExpired.checked]);
        SetPiece(DLParams2Tmp, '^', 9, FT_Text[chkEXExpiring.checked]);
        SetPiece(DLParams2Tmp, '^', 10, FT_Text[chkEXExpiringTomorrow.checked]);
        SetPiece(DLParams2Tmp, '^', 11, FT_Text[chkEXActions.checked]);
        DLParams2 := DLParams2Tmp;

        SpInOtIn := FT_Text[chkEXSpecInstr.checked]; // rpk 3/26/2009

        PatientWard := GetPatientWard;

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        OrderNumber := '';
        PatientRoomBed := GetPatientRoomBed;

        ItemList.Assign(BuildClinicList);
        if rbtnClinic.Checked then begin // rpk 9/19/2012
          if not LoadPatientListForClinics(ItemList) then begin // rpk 9/14/2012
            CloseFrm := False;
            exit;
          end;
        end;

        case prtOrderMode of
          omInpatient: ClinOrd := 'I';
          omClinic: ClinOrd := 'C';
        else
          ClinOrd := '';
        end;
        //Execute;
      end;
    end

    // IV Bag Status
    else if ActivePage = tbshtIVBagStatus then
    begin

      if CheckDates then
        exit;
      if CheckTimes then
        exit;

      if BCMA_SiteParameters.MaxDateRange <> -1 then
        if (trunc(dtpkrStop.date) - trunc(dtpkrStart.date)) >=
          BCMA_SiteParameters.MaxDateRange then
        begin
          DefMessageDlg('The date range cannot exceed ' +
            IntToStr(BCMA_SiteParameters.MaxDateRange) +
            ' day(s) as defined in the BCMA ''PSB RPT MAX RANGE'' parameter!',
            mtInformation, [mbOK], 0);
          CloseFrm := False;
          exit;
        end;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + cbxStart.text;
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + cbxStop.text;

      with BCMA_Report do
      begin
        Clear;
        ReportType := rtIVBagStatus;
        PatientIEN := BCMA_Patient.IEN;

        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        SetPiece(DLParamsTmp, '^', 5, FT_Text[chkIVBComments.checked]);
        DLParams := DLParamsTmp;

        SetPiece(DLParams2Tmp, '^', 5, FT_Text[chkIVBActive.checked]);
        SetPiece(DLParams2Tmp, '^', 7, FT_Text[chkIVBDCd.checked]);
        SetPiece(DLParams2Tmp, '^', 8, FT_Text[chkIVBExpired.checked]);

        SetPiece(DLParams2Tmp, '^', 12, FT_Text[chkIVBInfusing.checked]);
        SetPiece(DLParams2Tmp, '^', 13, FT_Text[chkIVBStopped.checked]);
        SetPiece(DLParams2Tmp, '^', 14, FT_Text[chkIVBCompleted.checked]);
        SetPiece(DLParams2Tmp, '^', 15, FT_Text[chkIVBNoAction.checked]);
        SetPiece(DLParams2Tmp, '^', 16, FT_Text[chkIVBMissing.checked]);
        SetPiece(DLParams2Tmp, '^', 17, FT_Text[chkIVBHeld.checked]);
        SetPiece(DLParams2Tmp, '^', 18, FT_Text[chkIVBRefused.checked]);

        DLParams2 := DLParams2Tmp;

        PatientWard := GetPatientWard;

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        OrderNumber := '';
        PatientRoomBed := GetPatientRoomBed;
        SpInOtIn := FT_Text[chkIVBOtherPrintInfo.checked]; // rpk 3/26/2009
                //Execute;
      end;
    end

    // Medication Therapy
    else if ActivePage = tbshtMedTherapy then
    begin

      if CheckDates then
        exit;
      if SelectedMedications.Count = 0 then
      begin
        DefMessageDlg('You must select medications prior to running this report', mtInformation, [mbOK], 0);
        btnSelectMedications.SetFocus;
        CloseFrm := False;
        exit;
      end;

      if BCMA_SiteParameters.MaxDateRange <> -1 then
        if (trunc(dtpkrStop.date) - trunc(dtpkrStart.date)) >=
          BCMA_SiteParameters.MaxDateRange then
        begin
          DefMessageDlg('The date range cannot exceed ' +
            IntToStr(BCMA_SiteParameters.MaxDateRange) +
            ' day(s) as defined in the BCMA ''PSB RPT MAX RANGE'' parameter!',
            mtInformation, [mbOK], 0);
          CloseFrm := False;
          exit;
        end;

      dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + '0001';
      dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + '2400';

      with BCMA_Report do
      begin
        Clear;
        ReportType := rtMedTherapy;
        PatientIEN := BCMA_Patient.IEN;

        StartTime := ValidMDateTime(dt0);
        StopTime := ValidMDateTime(dt1);

        SetPiece(DLParamsTmp, '^', 1, FT_Text[chkMedTherapyContinuous.checked]);
        SetPiece(DLParamsTmp, '^', 2, FT_Text[chkMedTherapyPRN.checked]);
        SetPiece(DLParamsTmp, '^', 3, FT_Text[chkMedTherapyOnCall.checked]);
        SetPiece(DLParamsTmp, '^', 4, FT_Text[chkMedTherapyOneTime.checked]);
        SetPiece(DLParamsTmp, '^', 5, FT_Text[chkMedTherapyComments.checked]);
        DLParams := DLParamsTmp;

        DLParams2 := '';

        PatientWard := GetPatientWard;

        if cbxWards.ItemIndex <> -1 then
          Ward := IntToStr(Integer(cbxWards.Items.Objects[cbxWards.itemIndex]))
        else
          Ward := '';

        OrderNumber := '';
        PatientRoomBed := GetPatientRoomBed;
        ItemList.Assign(BuildMedTherapyMedList);
      end;
    end;

  if Sender = btnPrint then
    PrintReport
  else
    BCMA_Report.Execute;

end;                                    // btnPreviewClick

procedure TfrmReportRequest.btnSelectPatientsClick(Sender: TObject);
begin
  if cbxWards.ItemIndex = -1 then
  begin
    DefMessageDlg('You must select a ward prior to selecting patients!',
      mtInformation, [mbOK], 0);
    exit;
  end;
  with TfrmPrintPtSelect.create(application) do
  try
    edtWard.Text := cbxWards.Text;
    ModalResult := ShowModal;
  finally
//    free;
    Release;                            // rpk 6/18/2013
  end;
  SetSelectPatientsCaption;
end;                                    // btnSelectPatientsClick

procedure TfrmReportRequest.btnSelectClinicsClick(Sender: TObject);
begin
  rbtnClinic.checked := True;           // rpk 8/28/2012

  frmPrtClinicSel := TfrmPrtClinicSel.create(application);

  with frmPrtClinicSel do
  try
    ModalResult := ShowModal;
  finally
//    free;
    Release;                            // rpk 6/18/2013
  end;

  SetSelectClinicsCaption;

end;                                    // btnSelectClinicsClick

procedure TfrmReportRequest.btnSelectMedicationsClick(Sender: TObject);
begin
  with TfrmMedTherapyMedSelection.create(application) do
  try
    ModalResult := ShowModal;
  finally
//    free;
    Release;                            // rpk 6/18/2013
  end;

  if SelectedMedications.Count <> 0 then
    edtMedTherapyMedicationsSelected.Text := 'Medications Selected'
  else
    edtMedTherapyMedicationsSelected.Text := 'No Medications Selected'

end;                                    // btnSelectMedicationsClick

procedure TfrmReportRequest.cbxMSFReasonsChange(Sender: TObject);
begin
  if cbxMSFReasons.ItemIndex <> 0 then
    RemoveFromSortList('Reason')
  else
    InsertToSortList('Reason');

  InitializeSortLists;
end;                                    // cbxMSFReasonsChange

procedure TfrmReportRequest.cbxSort1Change(Sender: TObject);
begin
  cbxSort2.ItemIndex := 0;
  cbxSort3.ItemIndex := 0;
  cbxSort3.Enabled := False;
  cbxSort3.Color := clBtnFace;

  cbxSort2.Items.Delete(cbxSort2.Items.IndexOf(cbxSort1.Text));
  //cbxSort3.Items.Delete(cbxSort3.Items.IndexOf(cbxSort1.Text));

  CheckForDateTime(1);
  CheckForDateTime(2);
  CheckForDateTime(3);
end;                                    // cbxSort1Change

procedure TfrmReportRequest.CheckForDateTime(SortItem: Integer);
begin
  case SortItem of
    1:
      begin
        if cbxSort1.Text = 'Date/Time of Scanning Failure' then
        begin
          rbSort1Asc.Visible := True;
          rbSort1Asc.Checked := True;
          rbSort1Desc.Visible := True;
          rbSort1Desc.Checked := False;
        end
        else
        begin
          rbSort1Asc.Visible := False;
          rbSort1Asc.Checked := False;
          rbSort1Desc.Visible := False;
          rbSort1Desc.Checked := False;
        end;
      end;
    2:
      begin
        if cbxSort2.Text = 'Date/Time of Scanning Failure' then
        begin
          rbSort2Asc.Visible := True;
          rbSort2Asc.Checked := True;
          rbSort2Desc.Visible := True;
          rbSort2Desc.Checked := False;
        end
        else
        begin
          rbSort2Asc.Visible := False;
          rbSort2Asc.Checked := False;
          rbSort2Desc.Visible := False;
          rbSort2Desc.Checked := False;
        end;
      end;
    3:
      begin
        if cbxSort3.Text = 'Date/Time of Scanning Failure' then
        begin
          rbSort3Asc.Visible := True;
          rbSort3Asc.Checked := True;
          rbSort3Desc.Visible := True;
          rbSort3Desc.Checked := False;
        end
        else
        begin
          rbSort3Asc.Visible := False;
          rbSort3Asc.Checked := False;
          rbSort3Desc.Visible := False;
          rbSort3Desc.Checked := False;
        end;
      end;
  end;
end;                                    // CheckForDateTime

procedure TfrmReportRequest.cbxSort2Change(Sender: TObject);
begin
  CheckForDateTime(2);
  cbxSort3.ItemIndex := cbxSort3.Items.IndexOf('none');

  if cbxSort2.Text <> 'none' then
    cbxSort3.Items.Delete(cbxSort2.Items.IndexOf(cbxSort2.Text));

  if cbxSort2.ItemIndex <= 0 then
  begin
    if cbxSort3.Enabled = True then
    begin
      cbxSort3.Enabled := False;
      cbxSort3.Color := clBtnFace;
      cbxSort3.ItemIndex := 0;
    end;
  end
  else
  begin
    cbxSort3.Enabled := True;
    cbxSort3.ItemIndex := 0;
    cbxSort3.Color := clWhite;
  end;
end;                                    // cbxSort2Change

procedure TfrmReportRequest.cbxSort2DropDown(Sender: TObject);
var
  SaveChoice: string;
begin
  SaveChoice := cbxSort2.Text;
  {Reload sort 2 items}
  cbxSort2.Items.Clear;
  cbxSort2.Items.AddStrings(cbxSort1.Items);
  cbxSort2.Items.Delete(cbxSort2.Items.IndexOf(cbxSort1.Text));
  cbxSort2.ItemIndex := cbxSort2.Items.IndexOf(SaveChoice);

  cbxSort2.Items.Insert(0, 'none');

  if cbxSort2.ItemIndex = -1 then
    cbxSort2.ItemIndex := 0;
end;                                    // cbxSort2DropDown

procedure TfrmReportRequest.cbxSort3Change(Sender: TObject);
begin
  CheckForDateTime(3);
end;                                    // cbxSort3Change

procedure TfrmReportRequest.cbxSort3DropDown(Sender: TObject);
var
  SaveChoice: string;
begin
  SaveChoice := cbxSort3.Text;
  {Reload sort 3 items}
  cbxSort3.Items.Clear;
  cbxSort3.Items.AddStrings(cbxSort2.Items);
  cbxSort3.Items.Delete(cbxSort3.Items.IndexOf(cbxSort2.Text));
  cbxSort3.ItemIndex := cbxSort3.Items.IndexOf(SaveChoice);

  if cbxSort3.ItemIndex = -1 then
    cbxSort3.ItemIndex := 0;

end;                                    // cbxSort3DropDown

procedure TfrmReportRequest.cbxUtSDetailedSortByChange(Sender: TObject);
begin
  if cbxUtSDetailedSortBy.ItemIndex = 1 then
  begin
    rbtnAscending.Enabled := True;
    rbtnDescending.Enabled := True;
    rbtnAscending.Checked := True;
  end
  else
  begin
    rbtnAscending.Enabled := False;
    rbtnDescending.Enabled := False;
    rbtnAscending.Checked := True;
  end;

end;                                    // cbxUtSDetailedSortByChange

procedure TfrmReportRequest.cbxWardsChange(Sender: TObject);
begin
  if rgrpWardOptions.ItemIndex = 2 then
  begin
    BCMA_Report.ReportPatientList.Clear;
    SetSelectPatientsCaption;
  end;

end;                                    // cbxWardsChange

procedure TfrmReportRequest.rbtnClinicClick(Sender: TObject);
begin
  rgrpWardOptions.Enabled := False;
//  BCMA_Report.ReportPatientList.Clear;
  cbxWards.Enabled := False;
  btnSelectPatients.Enabled := False;
  edtPatientsSelected.Enabled := False;
  BCMA_Report.ReportPatientList.Clear;
  SetSelectPatientsCaption;
  btnSelectClinics.Enabled := True;
  lblSelectedClinicsMsg.Enabled := True;
  SetSelectClinicsCaption;
end;                                    // rbtnClinicClick

procedure TfrmReportRequest.rbtnPatientClick(Sender: TObject);
begin
  rgrpWardOptions.Enabled := False;
  BCMA_Report.ReportPatientList.Clear;
  cbxWards.Enabled := False;
  btnSelectPatients.Enabled := False;
  edtPatientsSelected.Enabled := False;
  BCMA_Report.ReportPatientList.Clear;
  SetSelectPatientsCaption;
end;                                    // rbtnPatientClick

procedure TfrmReportRequest.rbtnWardClick(Sender: TObject);
begin
  rgrpWardOptions.Enabled := True;
  cbxWards.Enabled := True;
  SetWardOptions;
end;                                    // rbtnWardClick

procedure TfrmReportRequest.rbUASSummaryWardClick(Sender: TObject);
var
  x: integer;
  SavedChoice: string;
begin
  SavedChoice := cbxUASSummaryWardList.Text;
  cbxUASSummaryWardList.Clear;

  for x := 0 to BCMA_SiteParameters.WardList.Count - 1 do
    if cbUASSummaryExcludeInactiveWards.Checked and
      (piece(BCMA_SiteParameters.WardList[x], '^', 3) = '0') then

    else
    begin
      if cbExcludeMasWards.Checked then
      begin
        if Pos('[MAS WARD]', piece(BCMA_SiteParameters.WardList[x], '^', 2)) = 0
          then
          cbxUASSummaryWardList.Items.AddObject(
            piece(BCMA_SiteParameters.WardList[x], '^', 2),
            Ptr(StrToInt(piece(BCMA_SiteParameters.WardList[x], '^', 1))));

      end
      else
        cbxUASSummaryWardList.Items.AddObject(
          piece(BCMA_SiteParameters.WardList[x], '^', 2),
          Ptr(StrToInt(piece(BCMA_SiteParameters.WardList[x], '^', 1))));
    end;

  rbEntireFacility.Checked := False;
  rbNurseUnitLocation.Checked := False;
  cbxUASSummaryWardList.Enabled := True;
  cbxUASSummaryWardList.Color := clWhite;
  cbxUASSummaryWardList.ItemIndex :=
    cbxUASSummaryWardList.Items.IndexOf(SavedChoice);
end;                                    // rbUASSummaryWardClick

procedure TfrmReportRequest.ResizeForm;
var
  x, tmpHeight: integer;
  tmpRect: TRect;
  ActivePage: TTabSheet;
begin
  tmpHeight := 0;
  ActivePage := PageControl.ActivePage;
  for x := 0 to ActivePage.ControlCount - 1 do
    //    if {(PageControl.Controls[x].Parent = PageControl.ActivePage) and}
    //      (PageControl.ActivePage.Controls[x].ClassType = TPanel) then
    tmpHeight := tmpHeight + ActivePage.Controls[x].Height;
  TabCtrl_GetItemRect(PageControl.Handle, PageControl.TabIndex, tmpRect);

  tmpHeight := tmpHeight + tmpRect.Bottom + 38 + (ActivePage.ControlCount * 6) +
    pnlBottom.Height;

  self.Height := tmpHeight
end;                                    // ResizeForm

procedure TfrmReportRequest.rgrpMMOrderModeClick(Sender: TObject);
var
  rgrpOrdMode: TRadioGroup;
begin
  if Sender is TRadioGroup then begin
    rgrpOrdMode := Sender as TRadioGroup;
    if rgrpOrdMode.ItemIndex > -1 then
      prtOrderMode := TOrderMode(rgrpOrdMode.ItemIndex);
  end;

  // case select for Exclusive mode reports
  case PageControl.ActivePageIndex of
    ord(rtDueList):
      SetupForm(False, True, True, True); // rpk 6/1/2012
    ord(rtMissedMedications):
      SetupForm(True, True, True, True); // rpk 8/22/2012
    ord(rtWardAdministrationTimes):
      SetupForm(True, False, True, True); // rpk 6/28/2012
    ord(rtMedicationOverview):
      SetupForm(False, False, False, True); // rpk 8/22/2012
    ord(rtPRNOverview):
      SetupForm(False, False, False, True); // rpk 8/22/2012
    ord(rtIVOverview):
      SetupForm(False, False, False, True); // rpk 8/22/2012
    ord(rtExpiredOrders):
      SetupForm(False, False, False, True) // rpk 8/22/2012
  else
    SetupForm(True, True);              // rpk 6/6/2012
  end;

  Invalidate;                           // rpk 6/6/2012
end;                                    // rgrpMMOrderModeClick

procedure TfrmReportRequest.rgrpWardOptionsClick(Sender: TObject);
begin
  btnSelectPatients.Enabled := ((rgrpWardOptions.ItemIndex = 2) and
    (rgrpWardOptions.Enabled = true));
  edtPatientsSelected.Enabled := ((rgrpWardOptions.ItemIndex = 2) and
    (rgrpWardOptions.Enabled = true));
  if rgrpWardOptions.ItemIndex <> 2 then
    BCMA_Report.ReportPatientList.Clear;
  SetSelectPatientsCaption;
end;                                    // rgrpWardOptionsClick

procedure TfrmReportRequest.GetWardList();
var
  x: integer;
begin
  cbxWards.Clear;
  for x := 0 to BCMA_SiteParameters.WardList.Count - 1 do
    if chkExcludeInactiveWards.Checked and
      (piece(BCMA_SiteParameters.WardList[x], '^', 3) = '0') then

    else
      cbxWards.Items.AddObject(piece(BCMA_SiteParameters.WardList[x], '^', 2),
        Ptr(StrToInt(piece(BCMA_SiteParameters.WardList[x], '^', 1))));
end;                                    // GetWardList

function TfrmReportRequest.GetPatientWard: string;
begin
  {if (rbtnPatient.Checked) or (rgrpWardOptions.ItemIndex = 2) then
    Result := 'P'
  else
    Result := 'W'; }

  // rpk 9/6/2012
  Result := '';
  if (rbtnPatient.Checked) or (rgrpWardOptions.ItemIndex = 2) then
    Result := 'P'
  else if rbtnWard.Checked then
    Result := 'W'
  else if rbtnClinic.Checked then
    Result := 'C';
end;                                    // GetPatientWard

function TfrmReportRequest.GetPatientRoomBed: string;
begin
  if rgrpWardOptions.ItemIndex = 0 then
    Result := 'P'
  else
    Result := 'B';

end;                                    // GetPatientRoomBed

procedure TfrmReportRequest.SetSelectClinicsCaption;
begin
  if SelectedClinics.Count = 0 then
    lblSelectedClinicsMsg.Caption := 'No Clinics Selected'
  else
    lblSelectedClinicsMsg.Caption := IntToStr(SelectedClinics.Count) +
      ' Clinic(s) Selected';
end;                                    // SetSelectClinicsCaption

procedure TfrmReportRequest.SetSelectPatientsCaption;
begin
  if BCMA_Report.ReportPatientList.Count = 0 then
    //rgrpWardOptions.Items[2] := 'Print Selected Patients on Ward - No Patients Selected'
    edtPatientsSelected.Text := 'No Patients Selected'
  else
    edtPatientsSelected.Text := IntToStr(BCMA_Report.ReportPatientList.Count) +
      ' Patient(s) Selected'
end;                                    // SetSelectPatientsCaption

//procedure TfrmReportRequest.SetupForm(DateRange, ShowTimes: Boolean; ShowDates:
//  Boolean = True);

procedure TfrmReportRequest.SetupForm(DateRange, ShowTimes: Boolean; ShowDates:
  Boolean = True; ExclusiveMode: Boolean = False);
var
  tmpht: Integer;
begin
  pnlDateTimeRange.Parent := PageControl.ActivePage;
  pnlDateTimeRange.TabOrder := 0;
  // use tmpht to accumulate total height for pnlDateTimeReange
  // this allows SetupForm to be called multiple times.
  tmpht := 0;

  if ShowDates then
  begin
    tmpht := pnlDateRange.Height;
    if not DateRange then
    begin
      grpStartDate.Caption := '&Date for Report: ';
      grpStopDate.Visible := False;
    end
  end
  else
  begin
    pnlDateRange.Visible := False;
//    pnlDateTimeRange.Height := pnlDateTimeRange.Height - pnlDateRange.Height;
  end;

  if not ShowTimes then
  begin
    pnlTimeRange.Visible := False;
//    pnlDateTimeRange.Height := pnlDateTimeRange.Height - pnlTimeRange.Height;
  end
  else
    tmpht := tmpht + pnlTimeRange.Height;

  pnlDateTimeRange.Height := tmpht;

  //  dtpkrStart.Date := Date;
  //  dtpkrStop.Date := Date;
  dtpkrStart.Date := strtodate(FormatDateTime('ddddd', now +
    BCMA_SiteParameters.ServerClockVariance)); //bjr 5/12/10 for BCMA00000425
  dtpkrStop.Date := strtodate(FormatDateTime('ddddd', now +
    BCMA_SiteParameters.ServerClockVariance)); //bjr 5/12/10 for BCMA00000425

  cbxStart.ItemIndex := 0;
  cbxStop.ItemIndex := cbxStop.items.count - 1;

  if PageControl.ActivePage <> tbshtUnknownActions then
    grpPrintBy.Parent := PageControl.ActivePage;

  { if BCMA_Patient.IEN = '' then begin  // patient record not open
    rbtnPatient.Enabled := False;
  end
  else begin
    rbtnPatient.Enabled := True;
  end; }
  rbtnPatient.Enabled := BCMA_Patient.IEN <> '';

  if ExclusiveMode then begin           // mutually exclusive reports
    case prtOrderMode of                // rpk 6/6/2012
      omClinic: begin
          rbtnWard.Enabled := False;
          cbxWards.Enabled := False;
          EnableClinicControls(True);
          if BCMA_Patient.IEN = '' then begin
            rbtnClinic.Checked := True;
          end
          else begin
            rbtnPatient.Checked := True;
          end;
          HelpContext := 241;           // mutually exclusive reports overview, rpk 5/8/2013
        end;

      omInpatient: begin
          rbtnWard.Enabled := True;
          EnableClinicControls(False);
          if BCMA_Patient.IEN = '' then begin
            rbtnWard.Checked := True;
          end
          else begin
            rbtnPatient.Checked := True;
          end;
          HelpContext := PageControl.ActivePage.HelpContext; // rpk 5/8/2013
        end;
    end;
  end
  else begin                            // combined reports
    rbtnWard.Enabled := True;
    EnableClinicControls(False);

    if BCMA_Patient.IEN = '' then begin
      rbtnWard.Checked := True;
    end
    else begin
      rbtnPatient.Checked := True;
    end;
    if prtOrderMode = omClinic then
      HelpContext := 243                // Clinic Order Mode / combined reports, rpk 5/8/2013
    else
      HelpContext := PageControl.ActivePage.HelpContext; // rpk 5/8/2013
  end;
end;                                    // SetupForm

function TfrmReportRequest.CheckTimes: Boolean;
begin
  Result := false;

  if (dtpkrStart.date = dtpkrStop.date) and (cbxStart.text > cbxStop.text) then
  begin
    DefMessageDlg('The start time cannot be after the stop time!',
      mtInformation, [mbOK], 0);
    CloseFrm := False;
    Result := True
  end;
end;                                    // CheckTimes

procedure TfrmReportRequest.chkEXActionsClick(Sender: TObject);
begin
  chkEXComments.Enabled := chkEXActions.Checked;
  if not chkEXActions.Checked then
    chkEXComments.Checked := False;

end;                                    // chkEXActionsClick

procedure TfrmReportRequest.chkExcludeInactiveWardsClick(Sender: TObject);
begin
  GetWardList;
end;                                    // chkExcludeInactiveWardsClick

procedure TfrmReportRequest.chkIVOActionsClick(Sender: TObject);
begin
  chkIVOComments.Enabled := chkIVOActions.Checked;
  if not chkIVOActions.Checked then
    chkIVOComments.Checked := False;

end;

procedure TfrmReportRequest.chkMOActionsClick(Sender: TObject);
begin
  chkMOComments.Enabled := chkMOActions.Checked;
  if not chkMOActions.Checked then
    chkMOComments.Checked := False;

end;

procedure TfrmReportRequest.chkPRNActionsClick(Sender: TObject);
begin
  chkPRNComments.Enabled := chkPRNActions.Checked;
  if not chkPRNActions.Checked then
    chkPRNComments.Checked := False;

end;

procedure TfrmReportRequest.SetWardOptions;
begin
  case ReportType of
    rtMedicationOverview,
      rtPRNOverview,
      rtIVOverview,
      rtExpiredOrders,
      rtIVbagStatus,
      rtMedTherapy:
      begin
        (rgrpWardOptions.Components[0] as TRadioButton).Enabled := False;
        (rgrpWardOptions.Components[1] as TRadioButton).Enabled := False;
        rgrpWardOptions.ItemIndex := 2;
      end;
  else begin
      (rgrpWardOptions.Components[0] as TRadioButton).Enabled := true;
      (rgrpWardOptions.Components[1] as TRadioButton).Enabled := true;
      rgrpWardOptions.ItemIndex := 0;
    end;
  end;
  btnSelectPatients.Enabled := ((rgrpWardOptions.ItemIndex = 2) and
    (rgrpWardOptions.Enabled = true));
  edtPatientsSelected.Enabled := ((rgrpWardOptions.ItemIndex = 2) and
    (rgrpWardOptions.Enabled = true));
end;                                    // SetWardOptions

procedure TfrmReportRequest.tbshtUnableToScanDetailedShow(Sender: TObject);
begin
  InitializeSortLists;
  cbxSort3.Enabled := False;
end;

function TfrmReportRequest.CheckDates;
begin
  Result := False;

  if dtpkrStart.date > dtpkrStop.date then
  begin
    DefMessageDlg('The start date cannot be after the stop date!',
      mtInformation,
      [mbOK], 0);
    CloseFrm := False;
    Result := True;
  end;
end;

{JK = 4/3/2008}

procedure TfrmReportRequest.InsertToSortList(S: string);
begin
  if cbxSort1.Items.IndexOf(S) = -1 then
    cbxSort1.Items.Add(S);
  //cbxSort1.Sorted := True;

  if cbxSort2.Items.IndexOf(S) = -1 then
    cbxSort2.Items.Add(S);
  //cbxSort2.Sorted := True;

  if cbxSort3.Items.IndexOf(S) = -1 then
    cbxSort3.Items.Add(S);
  //cbxSort3.Sorted := True;
end;

{JK = 4/3/2008}

procedure TfrmReportRequest.RemoveFromSortList(S: string);
begin
  if cbxSort1.Items.IndexOf(S) <> -1 then
    cbxSort1.Items.Delete(cbxSort1.Items.IndexOf(S));
  //cbxSort1.Sorted := True;

  if cbxSort2.Items.IndexOf(S) <> -1 then
    cbxSort2.Items.Delete(cbxSort2.Items.IndexOf(S));
  //cbxSort2.Sorted := True;

  if cbxSort3.Items.IndexOf(S) <> -1 then
    cbxSort3.Items.Delete(cbxSort3.Items.IndexOf(S));
  //cbxSort3.Sorted := True;
end;

{JK = 4/3/2008}

procedure TfrmReportRequest.rgScanFailureTypeClick(Sender: TObject);
begin
  case rgScanFailureType.ItemIndex of
    0:
      begin
        with cbxMSFReasons.Items do
        begin
          Clear;
          Add('All Reasons');
          Add('Damaged Medication Label');
          Add('Damaged Wristband');
          Add('Dose Discrepancy');
          Add('No Bar Code');
          Add('Scanning Equipment Failure');
          Add('Unable to Determine');
        end;

        InsertToSortList('Type (Wristband or Medication)');

      end;
    1:
      begin
        with cbxMSFReasons.Items do
        begin
          Clear;
          Add('All Medication Reasons');
          Add('Damaged Medication Label');
          Add('Dose Discrepancy');
          Add('No Bar Code');
          Add('Scanning Equipment Failure');
          Add('Unable to Determine');
        end;

        RemoveFromSortList('Type (Wristband or Medication)');

      end;

    2:
      begin
        with cbxMSFReasons.Items do
        begin
          Clear;
          Add('All Wristband Reasons');
          Add('Damaged Wristband');
          Add('Scanning Equipment Failure');
          Add('Unable to Determine');
        end;

        RemoveFromSortList('Type (Wristband or Medication)');

      end;
  end;

  cbxMSFReasons.ItemIndex := 0;
  InsertToSortList('Reason');

  InitializeSortLists;

end;                                    // rgScanFailureTypeClick

procedure TfrmReportRequest.InitializeSortLists;
begin

  cbxSort1.ItemIndex := cbxSort1.Items.IndexOf('Date/Time of Scanning Failure');

  cbxSort2.Items.Clear;
  cbxSort2.Items.Add('none');
  cbxSort2.Items.Add('Date/Time of Scanning Failure');
  cbxSort2.Items.Add('Drug');
  cbxSort2.Items.Add('Location (Ward, Room-Bed)');
  cbxSort2.Items.Add('Patient Name');
  cbxSort2.Items.Add('Reason');
  cbxSort2.Items.Add('Type (Wristband or Medication)');
  cbxSort2.Items.Add('User');

  cbxSort2.ItemIndex := 0;

  cbxSort3.Items.Clear;
  cbxSort3.Items.Add('none');
  cbxSort3.Items.Add('Date/Time of Scanning Failure');
  cbxSort3.Items.Add('Drug');
  cbxSort3.Items.Add('Location (Ward, Room-Bed)');
  cbxSort3.Items.Add('Patient Name');
  cbxSort3.Items.Add('Reason');
  cbxSort3.Items.Add('Type (Wristband or Medication)');
  cbxSort3.Items.Add('User ');

  cbxSort3.ItemIndex := 0;
  cbxSort3.Enabled := False;

  CheckForDateTime(1);
  CheckForDateTime(2);
  CheckForDateTime(3);

end;                                    // InitializeSortLists

{JK = 4/3/2008}

procedure TfrmReportRequest.rbEntireFacilityClick(Sender: TObject);
begin
  rbNurseUnitLocation.Checked := False;
  rbUASSummaryWard.Checked := False;
  cbxUASSummaryWardList.Enabled := False;
  cbxUASSummaryWardList.Color := clBtnFace;
end;

procedure TfrmReportRequest.rbForAllWardsPatientsClick(Sender: TObject);
begin
  rbForSelectWard.Checked := False;
  cbxForSelectWard.Enabled := False;
  cbxForSelectWard.Color := clBtnFace;

  //rbUASSummaryWard.Enabled := False;
  //rbUASSummaryWard.Color := clBtnFace;

end;

{JK = 4/3/2008}

procedure TfrmReportRequest.rbForSelectWardClick(Sender: TObject);
var
  x: integer;
  SavedChoice: string;
begin
  cbxForSelectWard.Enabled := True;
  cbxForSelectWard.Color := clWindow;
  SavedChoice := cbxForSelectWard.Text;
  cbxForSelectWard.Clear;

  for x := 0 to BCMA_SiteParameters.WardList.Count - 1 do
    if cbForExcludeInactiveWards.Checked and
      (piece(BCMA_SiteParameters.WardList[x], '^', 3) = '0') then

    else
    begin
      if cbExcludeMasWardsDetailed.Checked then
      begin
        if Pos('[MAS WARD]', piece(BCMA_SiteParameters.WardList[x], '^', 2)) = 0
          then
          cbxForSelectWard.Items.AddObject(
            piece(BCMA_SiteParameters.WardList[x], '^', 2),
            Ptr(StrToInt(piece(BCMA_SiteParameters.WardList[x], '^', 1))));

      end
      else
        cbxForSelectWard.Items.AddObject(piece(BCMA_SiteParameters.WardList[x],
          '^', 2), Ptr(StrToInt(piece(BCMA_SiteParameters.WardList[x], '^',
          1))));
    end;

  //    //==
  //  if UserDivision.GetWardList.Count > 0 then begin
  //
  //    for x := 0 to BCMA_SiteParameters.WardList.Count - 1 do
  //      if cbForExcludeInactiveWards.Checked and (piece(UserDivision.GetWardList[x],'^', 3) = '0') then
  //
  //      else begin
  //        if cbExcludeMasWardsDetailed.Checked then begin
  //          if Pos('[MAS WARD]', piece(BCMA_SiteParameters.WardList[x],'^', 2)) = 0 then
  //            cbxForSelectWard.Items.AddObject(
  //              piece(UserDivision.GetWardList[x],'^', 2),
  //              Ptr(StrToInt(piece(UserDivision.GetWardList[x],'^', 1))));
  //
  //        end else
  //          cbxForSelectWard.Items.AddObject(
  //            piece(UserDivision.GetWardList[x],'^', 2),
  //            Ptr(StrToInt(piece(UserDivision.GetWardList[x],'^', 1))));
  //      end;
  //
  //  end;
  //    //==

  rbForAllWardsPatients.Checked := False;
  cbxForSelectWard.Enabled := True;
  cbxForSelectWard.Color := clWhite;
  cbxForSelectWard.ItemIndex := cbxForSelectWard.Items.IndexOf(SavedChoice);
end;                                    // rbForSelectWardClick

procedure TfrmReportRequest.rbNurseUnitLocationClick(Sender: TObject);
begin
  rbEntireFacility.Checked := False;
  rbUASSummaryWard.Checked := False;
  cbxUASSummaryWardList.Enabled := False;
  cbxUASSummaryWardList.Color := clBtnFace;
end;

{JK = 4/3/2008}

procedure TfrmReportRequest.rbSort1AscClick(Sender: TObject);
begin
  if rbSort1Asc.Checked then
    rbSort1Desc.Checked := False;
end;

{JK = 4/3/2008}

procedure TfrmReportRequest.rbSort1DescClick(Sender: TObject);
begin
  if rbSort1Desc.Checked then
    rbSort1Asc.Checked := False;
end;

procedure TfrmReportRequest.rbSort2AscClick(Sender: TObject);
begin
  if rbSort2Asc.Checked then
    rbSort2Desc.Checked := False;
end;

procedure TfrmReportRequest.rbSort2DescClick(Sender: TObject);
begin
  if rbSort2Desc.Checked then
    rbSort2Asc.Checked := False;
end;

procedure TfrmReportRequest.rbSort3AscClick(Sender: TObject);
begin
  if rbSort3Asc.Checked then
    rbSort3Desc.Checked := False;
end;

procedure TfrmReportRequest.rbSort3DescClick(Sender: TObject);
begin
  if rbSort3Desc.Checked then
    rbSort3Asc.Checked := False;
end;

{JK = 4/3/2008}

procedure TfrmReportRequest.cbCommentsClick(Sender: TObject);
begin
  if cbComments.Checked then
    HelpContext := 249                  // Witness Information Included in the Med Log Report, rpk 5/9/2013
  else
    HelpContext := PageControl.ActivePage.HelpContext;
end;

procedure TfrmReportRequest.cbExcludeMasWardsClick(Sender: TObject);
begin
  rbUASSummaryWardClick(Self);
  rbUASSummaryWard.Checked := True;
  rbEntireFacility.Checked := False;
  rbNurseUnitLocation.Checked := False;
end;

procedure TfrmReportRequest.cbExcludeMasWardsDetailedClick(Sender: TObject);
begin
  rbForSelectWardClick(Self);
  rbForSelectWard.Checked := True;
  rbForAllWardsPatients.Checked := False;
end;

procedure TfrmReportRequest.cbForExcludeInactiveWardsClick(Sender: TObject);
begin
  rbForSelectWardClick(Self);
  rbForSelectWard.Checked := True;
  rbForAllWardsPatients.Checked := False;
end;

procedure TfrmReportRequest.cbUASSummaryExcludeInactiveWardsClick(
  Sender: TObject);
begin
  rbUASSummaryWardClick(Self);
  rbUASSummaryWard.Checked := True;
  rbEntireFacility.Checked := False;
  rbNurseUnitLocation.Checked := False;
end;

{JK - 4/3/2008}

function TfrmReportRequest.PrepareUnableToScanDetailedReport: Boolean;
const
  FT_Text: array[boolean] of char = ('0', '1');
var
  dt0, dt1: string;
  DLParamsTmp: string;
  PSTSortTmp: string;
  Sort1Code, Sort2Code, Sort3Code: string;
  TypeReasonTmp: string;

  function GetSortItem(S: string): string;
  var
    Str: string;
  begin
    Str := Uppercase(S);

    if Str = 'none' then
      result := ''
    else if Str = 'DATE/TIME OF SCANNING FAILURE' then
      result := '2'
    else if Str = 'PATIENT NAME' then
      result := '1'
    else if Str = 'LOCATION (WARD, ROOM-BED)' then
      result := '3'
    else if Str = 'TYPE (WRISTBAND OR MEDICATION)' then
      result := '4'
    else if Str = 'DRUG' then
      result := '5'
    else if Str = 'USER' then
      result := '6'
    else if Str = 'REASON' then
      result := '7';
  end;

begin
  Result := True;

  if CheckDates then
  begin
    Result := False;
    Exit;
  end;

  if rbForSelectWard.Enabled then
    if rbForSelectWard.Checked and (cbxForSelectWard.ItemIndex = -1) then
    begin
      DefMessageDlg('You must select a ward when printing by ward!', mtError,
        [mbOK], 0);
      cbxForSelectWard.SetFocus;
      CloseFrm := False;
      Result := False;
      Exit;
    end;

  dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + cbxStart.Text;
  dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + cbxStop.Text;

  with BCMA_Report do
  begin
    Clear;
    ReportType := rtUnableToScanDetailed;
    PatientIEN := '';
    StartTime := ValidMDateTime(dt0);
    StopTime := ValidMDateTime(dt1);

    {Set the Scan Failure Type code}
    SetPiece(TypeReasonTmp, '^', 1, IntToStr(rgScanFailureType.ItemIndex));

    {Set the Reason code}
    if (Uppercase(cbxMSFReasons.Text) = 'ALL REASONS') or
      (Uppercase(cbxMSFReasons.Text) = 'ALL WRISTBAND REASONS') or
      (Uppercase(cbxMSFReasons.Text) = 'ALL MEDICATION REASONS') then
      SetPiece(TypeReasonTmp, '^', 2, '0')
    else if Uppercase(cbxMSFReasons.Text) = 'DAMAGED MEDICATION LABEL' then
      SetPiece(TypeReasonTmp, '^', 2, '1')
    else if Uppercase(cbxMSFReasons.Text) = 'DAMAGED WRISTBAND' then
      SetPiece(TypeReasonTmp, '^', 2, '2')
    else if Uppercase(cbxMSFReasons.Text) = 'NO BAR CODE' then
      SetPiece(TypeReasonTmp, '^', 2, '3')
    else if Uppercase(cbxMSFReasons.Text) = 'SCANNING EQUIPMENT FAILURE' then
      SetPiece(TypeReasonTmp, '^', 2, '4')
    else if Uppercase(cbxMSFReasons.Text) = 'UNABLE TO DETERMINE' then
      SetPiece(TypeReasonTmp, '^', 2, '5')
    else if Uppercase(cbxMSFReasons.Text) = 'DOSE DISCREPANCY' then
      SetPiece(TypeReasonTmp, '^', 2, '6');

    TypeReasonParams := TypeReasonTmp;

    {Set the sort order. Sort1Code is the primary, Sort2Code is the
     secondary, and Sort3Code is the tertiary sort field.}

    Sort1Code := GetSortItem(cbxSort1.Text);
    if Sort1Code = '2' then
      if rbSort1Desc.Checked then
        Sort1Code := '-2';

    Sort2Code := GetSortItem(cbxSort2.Text);
    if Sort2Code = '2' then
      if rbSort2Desc.Checked then
        Sort2Code := '-2';

    Sort3Code := GetSortItem(cbxSort3.Text);
    if Sort3Code = '2' then
      if rbSort3Desc.Checked then
        Sort3Code := '-2';

    PSTSortTmp := '';
    SetPiece(PSTSortTmp, '^', 1, Sort1Code);
    SetPiece(PSTSortTmp, '^', 2, Sort2Code);
    SetPiece(PSTSortTmp, '^', 3, Sort3Code);

    PSTSort := PSTSortTmp;

    if cbxForSelectWard.ItemIndex <> -1 then
      Ward :=
        IntToStr(Integer(cbxForSelectWard.Items.Objects[cbxForSelectWard.itemIndex]))
    else
      Ward := '';

    DLParams := DLParamsTmp;

    if rbForAllWardsPatients.Checked then
      PatientWard := 'P'
    else
      PatientWard := 'W';

    if cbForExcludeInactiveWards.Checked and (PatientWard = 'W') then
      PatientWard := '-' + PatientWard;

    OrderNumber := '';

    if cbxForSelectWard.ItemIndex <> -1 then
      Ward :=
        IntToStr(Integer(cbxForSelectWard.Items.Objects[cbxForSelectWard.itemIndex]))
    else
      Ward := '';

    PatientRoomBed := '';

    //    {JK 7/11/2008}
    //    SiteDivisionCode := ExtractSiteCode(cbxDivisionListMSFDetailed.Text);

        //Execute;
  end;
end;                                    // PrepareUnableToScanDetailedReport

{JK - 4/3/2008}

function TfrmReportRequest.PrepareUnableToScanSummaryReport: Boolean;
const
  FT_Text: array[boolean] of char = ('0', '1');
var
  dt0, dt1: string;
  TypeReasonTmp: string;
begin
  Result := True;

  if CheckDates then
  begin
    Result := False;
    Exit;
  end;

  if rbUASSummaryWard.Enabled then
    if rbUASSummaryWard.Checked and (cbxUASSummaryWardList.ItemIndex = -1) then
    begin
      DefMessageDlg('You must select a ward when printing by ward!', mtError,
        [mbOK], 0);
      cbxUASSummaryWardList.SetFocus;
      CloseFrm := False;
      Result := False;
      Exit;
    end;

  dt0 := FormatDateTime('mmddyyyy', dtpkrStart.date) + '@' + cbxStart.Text;
  dt1 := FormatDateTime('mmddyyyy', dtpkrStop.date) + '@' + cbxStop.Text;

  with BCMA_Report do
  begin
    Clear;
    ReportType := rtUnableToScanSummary;
    PatientIEN := '';
    StartTime := ValidMDateTime(dt0);
    StopTime := ValidMDateTime(dt1);

    if rbUASSummaryWard.Checked then
      if cbxUASSummaryWardList.ItemIndex <> -1 then
        Ward :=
          IntToStr(Integer(cbxUASSummaryWardList.Items.Objects[cbxUASSummaryWardList.ItemIndex]))
      else
        Ward := '';

    {Set the Scan Failure Type code}
    SetPiece(TypeReasonTmp, '^', 1, FT_Text[rbEntireFacility.Checked]);
    SetPiece(TypeReasonTmp, '^', 2, FT_Text[rbNurseUnitLocation.Checked]);
    SetPiece(TypeReasonTmp, '^', 3, FT_Text[rbUASSummaryWard.Checked]);

    TypeReasonParams := TypeReasonTmp;
    {Reusing the type reason param from the MSF Detailed Report}

  {if Pos('[', cbxUASSummaryWardList.Text) > 0 then begin

    NurseMasCode := Copy(cbxUASSummaryWardList.Text,
                         Pos('[', cbxUASSummaryWardList.Text)+1,
                         Pos(']', cbxUASSummaryWardList.Text)-1
                         );

    if Pos('NURS', NurseMasCode) > 0  then
      NurseMasCode := 'N'
    else if Pos('MAS', NurseMasCode) > 0  then
      NurseMasCode := 'M'
    else
      NurseMasCode := '';
  end else
    NurseMasCode := '';}

    //showmessage('NurseMasCode = ' + NurseMasCode);

//    {JK 7/11/2008}
//    SiteDivisionCode := ExtractSiteCode(cbxDivisionListMSFSummary.Text);

  //Execute;
  end;
end;                                    // PrepareUnableToScanSummaryReport

end.
