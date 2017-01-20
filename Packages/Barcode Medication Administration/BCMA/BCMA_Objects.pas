unit BCMA_Objects;
{
================================================================================
*	File:  BCMA_Objects.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 110 $  $Modtime: 5/22/02 2:16p $
*
*	Description:  This is a unit which contains global Objects developed for the
*               application.
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VHA_Objects, BCMA_Util, Splash, StdVcl, StdCtrls, ComCtrls;

type
  TUASLogAction = (LA_OkToLog, LA_AlreadyLogged, LA_Cancelled);

  //MOB Type
  TMobTypes = (MOB2, MOB1, REGERR, FILENA); // P77

  //MOB Info
  TMobInfo = record                     // P77
    MobType: TMobTypes;
    MobPath: string;
    MobDLLName: string;                 // rpk 3/8/2016
    MobVersion: string;
    MOBRequiredVersion: string;
  end;

  // WF_Admin_Cancelled added to support graceful exit from cancel prompts with
  // display of "Order Administration Cancelled" at end of process or function.
  // Avoid exit calls on Cancel.
  TWorkFlowType = (WF_Reset, WF_Normal_Multiple_UnitDose,
    WF_Normal_Single_UnitDose, WF_UAS_Wristband,
    WF_UAS_Medication, WF_UAS_CreateWardStock,
    WF_TakeActionOnBag, WF_FiveRights,
    WF_TakeActionOnWS,                  // rpk 4/6/2011
    WF_Admin_Cancelled);                // rpk 6/30/2011

  TScanStatus = (ssInfusing,
    ssStopped,
    ssComplete,
    ssHeld,
    ssRefused,
    ssMissed,
    ssRemoved,
    ssAvailable,
    ssNotGiven,
    ssGiven,
    ssUnknown);

  TIVActionTypes = (atScan,
    atHeld,
    atRefused,
    atMissingDose);

  TMedLogTypes = (mtNone,
    mtMedPass,
    mtStatusUpdate,
    mtAddComment,
    mtPRNEffectiveness);

  TOrderMode = (omInpatient,
    omClinic);

  TOrderTypes = (otNone,
    otIV,
    otUnitDose,
    otPending);

  TReportTypes = (rtDueList,
    rtMedicationLog,
    rtMedicationsGiven,
    rtWardAdministrationTimes,
    rtMissedMedications,
    rtPRNEffectives,
    rtMedicationVarianceLog,
    rtVitalsCumulative,
    rtPatientMedicationHistory,
    rtUnknownActions,
    rtUnableToScanDetailed,
    rtUnableToScanSummary,
    rtMedicationOverview,
    rtPRNOverview,
    rtIVOverview,
    rtExpiredOrders,
    rtMedTherapy,
    rtIVBagStatus,
    rtPatientInquiry,
    rtAllergyReactions,
    rtDisplayOrder,
    rtPatientFlags
    );

  TScheduleTypes = (stNone,
    stContinuous,
    stPRN,
    stOneTime,
    stOnCall);

  ///
  ///  NOTE: The ordinal values of these enums must match the sort by action item
  ///  tag values.
  ///
  TSortMnuTagTypes = (stStatus,         // 0  rpk 3/7/2012
    stVerifyingNurse,                   // 1
    stHospitalSelfMed,                  // 2
    stType,                             // 3
    stActiveMedication,                 // 4
    stDosage,                           // 5
    stRoute,                            // 6
//    stAdministrationTime,               // 7
    stLastAction,                       // 8
    stMedicationSolution,               // 9
    stInfusionRate,                     // 10
    stBagInformation,                   // 11
    stLastSite,                         // 12
    stClinicName,                       // 13
    stWitness,                          // 14  rpk 5/11/2012
    stOrderStopDate                     // 15  rpk 5/11/2012
{$IFDEF CAS_DDPE_RST}
    , stRemovalStatus                   // 16
{$ENDIF}
    );

  TVDLColumnTypes = (ctClinicName,      // rpk 4/19/2012
    ctScanStatus,
    ctVerifyNurse,
    ctSelfMed,
    ctScheduleType,
    ctWitness,                          // rpk 5/11/2012
    ctActiveMedication,
    ctDosage,
    ctRoute,
{$IFDEF CAS_DDPE_RST}
    ctRemovalStatus,                    // note the VDL column name is "Next Dose Action"
{$ENDIF}
//    ctAdministrationTime,
    ctTimeLastGiven,       // last action
    ctLastSite);                        // 11; rpk 12/1/2011

  lstPBColumnTypes = (pbClinicName,     // rpk 4/19/2012
    pbScanStatus,
    pbVerifyNurse,
    pbScheduleType,
    pbWitness,                          // rpk 5/11/2012
    pbMedicationSolution,
    pbInfusionRate,
    pbRoute,
{$IFDEF CAS_DDPE_RST}
    pbRemovalStatus,
{$ENDIF}
//    pbAdministrationTime,
    pbLastAction,
    pbLastSite);                        // 10; rpk 2/15/2012

  lstIVColumnTypes = (ivClinicName,     // rpk 4/19/2012
    ivOrderStatus,
    ivVerifyNurse,
    ivType,
    ivWitness,
    ivMedicationSolution,
    ivInfusionRate,
    ivRoute,
    ivBagInformation,
    ivOrderStopDate);                   // 9  rpk 5/11/2012

  lstBagDetailColumnTypes = (bdDateTime,
    bdNurse,
    bdAction,
    bdComment);

  lstTabs = (ctCS, ctUD, ctPB, ctIV{$IFDEF CAS_DDPE_TEST}, ctLog{$ENDIF});

  TIVHistoryStatusTypes = (iaAction1,
    iaAction2,
    iaAction3,
    iaAction4,
    iaAction5,
    iaAction6,
    iaAction7,
    iaAction8);

  lstPRNListColumnTypes = (ctPRNActiveMedication,
    ctPRNUnitsGiven,
    ctPRNAdminTime,
    ctPRNReasonGiven,
    ctPRNAdministeredBy,
    ctPRNLocation);

  memoTypes = (mtSpecialInstructions, mtOtherInfo); // rpk 3/18/2009

  // rpk 2/8/2011
  NonNurseVfyTypes = (nvInvalid = -1, nvZero, nvNoWarning, nvWarning,
    nvProhibit);
  ChkNurseVfyReturnValues = (cnvNotCalled, cnvGive, cnvDoNotGive);

const
  OrderTypeCodes: array[TOrderTypes] of string[1] = ('', 'V', 'U', 'P');
  ScheduleTypeCodes: array[TScheduleTypes] of string[2] = ('',
    'C',
    'P',
    'O',
    'OC');

  ScheduleTypeTitles: array[TScheduleTypes] of string = ('',
    'Continuous',
    'PRN',
    'One-Time',
    'On-Call');

  MemoTypeTitles: array[memoTypes] of string = (
    'Special Instructions',
    'Other Print Info');

  lstUnitDoseCurrentTab: array[lstTabs] of string = ('CSTAB', 'UDTAB', 'PBTAB',
    'IVTAB'{$IFDEF CAS_DDPE_TEST}, 'LOGTAB'{$ENDIF});
  IVHistorySortOrder: array[TIVHistoryStatusTypes] of string = ('I',
    'A',
    'N',
    'M',
    'C',
    'S',
    'H',
    'R');
  FalseTrue: array[Boolean] of string = ('False', 'True');

  // pass 1 to PSB GETORDERTAB to request SI/OPI word-processing text.
  PSBSIOPI_WP = '1';                    // rpk 1/10/2012
  WITNESS_RECOMMENDED = '2';            // rpk 10/10/2012
  WITNESS_REQUIRED = '3';               // rpk 10/10/2012
  WITNESS_IDX = 3;                      // rpk 5/23/2012

type
  EMarkRemovedError = class(Exception)
  end;

  TBCMA_DispensedDrug = class(TObject)
    (*
      Contains information about a dispense drug.
    *)
  private
    FRPCBroker: TBCMA_Broker;

    FIEN: string;
    FName: string;
    FDose: string;
    FResultString: string;

    FQtyOrdered: string;
    FQtyScanned: integer;
    //this will be equivlent to the number of scans, or units scanned
    FQtyEntered: string;
    //This will contain the actual units given when prompted for (non TAB, CAP, PATCH)
    FQtyScannedText: string;            //in the case of a fractional Dose.
    FWitnessCode: string;               // rpk 10/17/2012
    FisValidDrug: boolean;

  protected
    function getQtyOrdered: integer;

  public
    property IEN: string read FIEN;
    property Name: string read FName;
    property Dose: string read FDose;
    property ResultString: string read FResultString;

    property QtyOrderedText: string read FQtyOrdered;
    property QtyOrdered: integer read getQtyOrdered;
    property QtyScanned: integer read FQtyScanned write FQtyScanned;
    property QtyScannedText: string read FQtyScannedText write FQtyScannedText;
    property QtyEntered: string read FQtyEntered write FQtyEntered;
    property WitnessCode: string read FWitnessCode write FWitnessCode; // rpk 10/17/2012

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil;
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

    function isValidDrug(var scanIEN: string): boolean;
    (*
      Uses RPC 'PSB SCANMED' to validate drug 'scanIEN'.  'scanIEN' may
      contain a drug IEN code or a known synonym upon input.  It's value will
      be set to the actual drug IEN on return.
    *)

    function MapIEN(scanIEN: string): string;
    (*
      JK - 8/20/2008 - needed to return the IEN if a synonym is entered.
      Uses RPC 'PSB SCANMED' to validate drug 'scanIEN'.  'scanIEN' may
      contain a drug IEN code or a known synonym upon input.  It's value will
      be set to the actual drug IEN on return.
    *)

  end;

  TBCMA_IVBags = class(TObject)

  private
    FRPCBroker: TBCMA_Broker;

    FOrderNumber,
      FUniqueID,
      FTimeLastGiven,
      FScanStatus,
      FMedLogIEN,
      FInjectionSite: string;
    FAdditives,
      FSolutions,
      FBagDetails: TStringList;
    FDisplayedMessage: Boolean;

  protected

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;

    destructor Destroy; override;

    procedure Clear;
    property TimeLastGiven: string read FTimeLastGiven;
    property UniqueID: string read FUniqueID write FUniqueID;
    property ScanStatus: string read FScanStatus;
    property Solutions: TStringList read FSolutions write FSolutions;
    property Additives: TStringList read FAdditives write FAdditives;
    property BagDetails: TStringList read FBagDetails;
    property OrderNumber: string read FOrderNumber;
    property InjectionSite: string read FInjectionSite;

    function GetBagDetails(StringIn: string; OrderNumIn: string): string;

  end;

  TBCMA_UserParameters = class(TObject)
    {Contains information about the User Parameters for this user.}
  private
    FRPCBroker: TBCMA_Broker;

    FDUZ,
      FDefaultPrinterName: string;
    FDefaultPrinterIEN: Integer;
    FContinuousChecked: boolean;
    FPRNChecked: boolean;
    FOneTimeChecked: boolean;
    FOnCallChecked: boolean;

    FMainFormTop: integer;
    FMainFormLeft: integer;
    FMainFormHeight: integer;
    FMainFormWidth: integer;

    FMainFormPosition: TPosition;
    FMainFormState: TWindowState;
    FCurrentTab: lstTabs;

    FUDSortColumn: TVDLColumnTypes;
    FPBSortColumn: lstPBColumnTypes;
    FIVSortColumn: lstIVColumnTypes;

    FCSMOSortColumn,
      FCSPRNSortColumn,
      FCSIVSortColumn,
      FCSExSortColumn: Integer;

    FStartTime,
      FStopTime: string;

    FChanged: boolean;
    // User parameter saved order mode.  Will be used in LoadData as default
    // order mode if no patient is selected.
    FUPOrderMode: TOrderMode;           // rpk 5/30/2012
    FClinSrchPrefix, FClinSrchText: string; // rpk 5/30/2012

  protected
    procedure setContinuousChecked(newValue: boolean);
    procedure setPRNChecked(newValue: boolean);
    procedure setOneTimeChecked(newValue: boolean);
    procedure setOnCallChecked(newValue: boolean);

    procedure setMainFormTop(newValue: integer);
    procedure setMainFormLeft(newValue: integer);
    procedure setMainFormHeight(newValue: integer);
    procedure setMainFormWidth(newValue: integer);

    procedure setMainFormPosition(newValue: TPosition);
    procedure setMainFormState(newValue: TWindowState);
    procedure setCurrentTab(newValue: lstTabs);

    procedure setStartTime(newValue: string);
    procedure setStopTime(newValue: string);
    procedure setDefaultPrinterIEN(newValue: Integer);

    procedure setUDSortColumn(newValue: TVDLColumnTypes);
    procedure setPBSortColumn(newValue: lstPBColumnTypes);
    procedure setIVSortColumn(newValue: lstIVColumnTypes);

    procedure setFChanged(newValue: Boolean);

  public
    property DUZ: string read FDUZ;

    property ContinuousChecked: boolean read FContinuousChecked write
      setContinuousChecked;
    property PRNChecked: boolean read FPRNChecked write setPRNChecked;
    property OneTimeChecked: boolean read FOneTimeChecked write
      setOneTimeChecked;
    property OnCallChecked: boolean read FOnCallChecked write setOnCallChecked;

    property MainFormTop: integer read FMainFormTop write setMainFormTop;
    property MainFormLeft: integer read FMainFormLeft write setMainFormLeft;
    property MainFormHeight: integer read FMainFormHeight write
      setMainFormHeight;
    property MainFormWidth: integer read FMainFormWidth write setMainFormWidth;

    property MainFormPosition: TPosition read FMainFormPosition write
      setMainFormPosition;
    property MainFormState: TWindowState read FMainFormState write
      setMainFormState;
    property CurrentTab: lstTabs read FCurrentTab write setCurrentTab;

    property StartTime: string read FStartTime write setStartTime;
    property StopTime: string read FStopTime write setStopTime;

    property UDSortColumn: TVDLColumnTypes read FUDSortColumn write
      setUDSortColumn;
    property PBSortColumn: lstPBColumnTypes read FPBSortColumn write
      setPBSortColumn;
    property IVSortColumn: lstIVColumnTypes read FIVSortColumn write
      setIVSortColumn;

    property CSMOSortColumn: integer read FCSMOSortColumn write FCSMOSortColumn;
    property CSPRNSortColumn: integer read FCSPRNSortColumn write
      FCSPRNSortColumn;
    property CSIVSortColumn: integer read FCSIVSortColumn write FCSIVSortColumn;
    property CSExSortColumn: integer read FCSExSortColumn write FCSExSortColumn;

    property DefaultPrinterIEN: Integer read FDefaultPrinterIEN write
      setDefaultPrinterIEN;
    property DefaultPrinterName: string read FDefaultPrinterName write
      FDefaultPrinterName;
    property Changed: Boolean write SetFChanged;
    property UPOrderMode: TOrderMode read FUPOrderMode write FUPOrderMode; // rpk 5/30/2012
    property ClinSrchPrefix: string read FClinSrchPrefix write FClinSrchPrefix; // rpk 5/30/2012
    property ClinSrchText: string read FClinSrchText write FClinSrchText; // rpk 5/30/2012

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil.  Calls method SaveData
      to save any changes in the User's Parameter values.
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

    function LoadData: boolean;
    (*
      Uses RPC 'PSB USERLOAD' to retrieve all saved User Parameters.
    *)

    procedure SaveData;
    (*
      If any of the User Parameters have changed, RPC 'PSB USERSAVE' is used
      to save the changes on the server for use the next time the User logs
      into the application.
    *)

  end;

  TBCMA_SiteParameters = class(TObject)
    {Contains information about the Site Parameters for this site.}
  private
    FRPCBroker: TBCMA_Broker;

    FContinuousChecked,
      FPRNChecked,
      FOneTimeChecked,
      FOnCallChecked,
      FMedOrderButton,
      FReportInclCmt: boolean;

    FMinutesBefore,
      FMinutesAfter,
      FMinutesPRNEffect,
      FVDLStartTime,
      FVDLStopTime,
      FIdleTimeout,
      FMAHMaxDays,
      FMedHistDaysBack,
      FMaxDateRange,
      // Value read from PSB NON-NURSE VERIFIED PROMPT
    FNonNurseVfyLvl: integer;

    FServerClockVariance,
      FMaximumServerClockVariance: integer;

    FHFSBackup,
      FMGSysError,
      FMGDLError,
      FMGMissingDose,
      FAutoUpdateServer,
      FMGAutoUpdate,
      FUDID,
      FIVID,
      FUNITDOSE_DIALOG,
      FIV_DIALOG,
      // Holds the value stored in PSB PATIENT ID LABEL parameter.  rpk 8/6/2009
    FPatIDLabel,
      FInjSiteHistMaxHrs,
      FDermSiteHistMaxDays: string;

    FListReasonsGivenPRN,
      FListReasonsHeld,
      FListReasonsRefused,
      FListInjectionSites,
      FListBodySites,
      FListDevices,
      FWardList,
      FProviderList,
      FToolsApps: TStringList;

    FChanged: boolean;
    FFiveRightsUnitDose: Boolean;
    FFiveRightsIV: Boolean;

  protected
    function getServerClockVariance: real;
    function getMaximumServerClockVariance: real;
    function GetParameter(Parameter: string; UpArrowPiece: Integer): string;
    function SetParameter(DivisionID, Parameter: string; newValue: string):
      Boolean;
{$IFDEF CAS_DDPE_RST}
    function getServerTime: TDateTime;
{$ENDIF}
  public
    property ContinuousChecked: boolean read FContinuousChecked;
    property PRNChecked: boolean read FPRNChecked;
    property OneTimeChecked: boolean read FOneTimeChecked;
    property OnCallChecked: boolean read FOnCallChecked;
    property MedOrderButton: boolean read FMedOrderButton write FMedOrderButton;
    property ReportInclCmt: boolean read FReportInclCmt;

    property MinutesBefore: integer read FMinutesBefore;
    property MinutesAfter: integer read FMinutesAfter;
    property MinutesPRNEffect: integer read FMinutesPRNEffect;
    property VDLStartTime: integer read FVDLStartTime;
    property VDLStopTime: integer read FVDLStopTime;
    property IdleTimeout: integer read FIdleTimeout;
    property MAHMaxDays: integer read FMAHMaxDays;
    property MedHistDaysBack: integer read FMedHistDaysBack;
    property MaxDateRange: integer read FMaxDateRange;
    property NonNurseVfyLvl: integer read FNonNurseVfyLvl; // rpk 1/21/2011
    property ServerClockVariance: real read getServerClockVariance;
    property MaximumServerClockVariance: real read
      getMaximumServerClockVariance;

    property HFSBackup: string read FHFSBackup;
    property MGSysError: string read FMGSysError;
    property MGDLError: string read FMGDLError;
    property MGMissingDose: string read FMGMissingDose;
    property AutoUpdateServer: string read FAutoUpdateServer;
    property MGAutoUpdate: string read FMGAutoUpdate;
    property UDID: string read FUDID;
    property IVID: string read FIVID;
    property UNITDOSE_DIALOG: string read FUNITDOSE_DIALOG;
    property IV_DIALOG: string read FIV_DIALOG;
    property PatientIDLabel: string read FPatIDLabel; // rpk 8/6/2009
    property InjSiteHistMaxHrs: string read FInjSiteHistMaxHrs write
      FInjSiteHistMaxHrs;               // rpk 2/6/2012
    property DermSiteHistMaxDays: string read FDermSiteHistMaxDays write
      FDermSiteHistMaxDays;             // rpk 11/5/2015
    property ListReasonsGivenPRN: TStringList read FListReasonsGivenPRN;
    property ListReasonsHeld: TStringList read FListReasonsHeld;
    property ListReasonsRefused: TStringList read FListReasonsRefused;
    property ListInjectionSites: TStringList read FListInjectionSites;
    property ListBodySites: TStringList read FListBodySites;
    property ListDevices: TStringList read FListDevices;
    property WardList: TStringList read FWardList;
    property ProviderList: TStringList read FProviderList;
    property ToolsApps: TStringList read FToolsApps;

    property FiveRightsUnitDose: Boolean read FFiveRightsUnitDose;
    property FiveRightsIV: Boolean read FFiveRightsIV;
{$IFDEF CAS_DDPE_RST}
    property ServerTime: TDateTime read getServerTime;
{$ENDIF}
    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil;
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

    function LoadData: boolean;
    (*
      Uses RPC's 'PSB SERVER CLOCK VARIANCE' and 'PSB PARAMETER' to download
      application Site Parameters.
    *)

  end;

  TBCMA_MedOrder = class(TObject)
    (*
      Contains information about a Medication Order for a Patient.
    *)
  private
    FRPCBroker: TBCMA_Broker;

    FPatientIEN,
      FOrderNumber,
      FOrderIEN,
      FOrderType,
      FScheduleType,
      FSchedule,
      FSelfMed,
      FActiveMedication,
      FDosage,
      FRoute,
{$IFDEF CAS_DDPE_RST}
    FRemovalStatus,
      FRemovalDateTime,
{$ENDIF}
{$IFDEF CAS_DDPE_DEBUG}
    fRaw,
{$ENDIF}
    FTimeLastAction,                    //Date and time the last action occured for any action on any order that has the same orderable item
      FLastGivenDateTime,
      FMedLogIEN,
      FScanStatus,
      FAdministrationTime,
      FOrderableItemIEN,
      FAdministrationUnit,
      FLastActivityStatus,
      FVerifyNurse,
      FSpecialInstructions,
      FStartDateTime,
      FOrderStatus,
      FUniqueID,
      FNurseIEN,                        //this is the IEN for the nurse that took the last action
    //on this administration only.
    FWitnessFlag,                       // rpk 5/11/2012
      FWitnessDUZ,                      // DUZ of witness for High Risk/High Alert drugs
      FWitnessName,
      FWitnessComment,                  // rpk 6/15/2012
      FOrderTransferred,
      FStopDateTime,                    // Date and Time the last action occured for this administration only
      FClinicName,                      // rpk 4/19/2012
      FClinicIEN: string;               // rpk 11/15/2012

    FInjectionSiteNeeded,
      FVariableDose,
      FWardStock,
      FDisplayInstructions,
      FUnknownMessageDisplayed,
      FOrderTooTall,
      FInjOnPB: boolean;                // rpk 2/15/2012

    FOrderedDrugIENs,
      FOrderedDrugNames,
      FOrderedDrugUnits,
      FUnitsGiven,
      FSolutions,
      FAdditives,
      FPRNList,
      FUniqueIDs,
      FLastFourActions,                 //if this is a PRN, this will contain the last four actions when validated.
      FOrderChangedData,
      FAdditionalComments,
      FSIOPIList: TStringList;          // rpk 11/09/2011

    FOrderedDrugs: TList;

    FReasonGivenPRN,
      FUserComments,
      FUserComments2,
      FInjectionSite,
      FDermalSite,                      // rpk 10/19/2015
      FBodySite,
      FLastSite: string;                // rpk 2/6/2012

    FStatus: integer;
    FStatusMessage: string;
    FValidOrder: boolean;
    FAction: string;                    //Action user is attempting to take (we won't have this in all cases)

    FChanged: boolean;
    // Flag which indicates presence of provider and/or pharmacist override comments / interventions
    FOvrIntvent: Boolean;               // rpk 1/14/2011

  protected
    procedure setOrderNumber(newValue: string);
    procedure setOrderType(newValue: string);
    procedure setMedLogIEN(newValue: string);
    procedure setOrderableItemIEN(newValue: string);

    procedure setScanStatus(newValue: string);
    procedure setSelfMed(newValue: string);
    procedure setScheduleType(newValue: string);

    procedure setSchedule(newValue: string);

    procedure setActiveMedication(newValue: string);
    procedure setDosage(newValue: string);
    procedure setRoute(newValue: string);
{$IFDEF CAS_DDPE_RST}
    procedure setRemovalStatus(newValue: string);
    procedure setRemovalDateTime(newValue: string);
{$ENDIF}
    procedure setAdministrationTime(newValue: string);
    procedure setTimeLastAction(newValue: string);
    procedure setLastActivityStatus(newValue: string);
    procedure setSpecialInstructions(newValue: string);
    procedure setSIOPIList(newValue: TStringList); // rpk 1/4/2012
    procedure setVerifyNurse(newValue: string);
    procedure setStartDateTime(newValue: string);
    procedure setOrderStatus(newValue: string);
    function getOrderTypeID: TOrderTypes;
    function getScheduleTypeID: TScheduleTypes;
    function getPRNList: TStringList;

    function getValidOrder: boolean;
    function getOrderedDrugs(index: integer): TBCMA_DispensedDrug;
    function getCanMarkNG: boolean;
    function getIsPatch: Boolean;

    procedure FillMultList(MultList: TStringlist; newStatus: string; IVBag:
      TBCMA_IVBags);

{$IFDEF CAS_DDPE_RST}
    function getTextNextActionTime: string;
    function getRemovalIsAllowed: Boolean;
    function getUndoIsAllowed: Boolean;
    function getRemovalDueTime: TDateTime;
    function getNextActionFMTime: string;
{$ENDIF}

  public
    property PatientIEN: string read FPatientIEN;

    property OrderNumber: string read FOrderNumber write setOrderNumber;
    property OrderIEN: string read FOrderIEN;
    property OrderType: string read FOrderType write setOrderType;
    property OrderTypeID: TOrderTypes read getOrderTypeID;

    property ScheduleType: string read FScheduleType write setScheduleType;
    property Schedule: string read FSchedule write setSchedule;
    property ScheduleTypeID: TScheduleTypes read getScheduleTypeID;

    property SelfMed: string read FSelfMed write setSelfMed;

    property ActiveMedication: string read FActiveMedication write
      setActiveMedication;
    property Dosage: string read FDosage write setDosage;
    property Route: string read FRoute write setRoute;

{$IFDEF CAS_DDPE_RST}
    property RemovalStatus: string read FRemovalStatus write setRemovalStatus;
    property RemovalDateTime: string read FRemovalDateTime write
      setRemovalDateTime;
    property TextNextActionTime: string read getTextNextActionTime;
    property RemovalIsAllowed: Boolean read getRemovalIsAllowed;
    property UndoIsAllowed: Boolean read getUndoIsAllowed;
    property RemovalDueTime: TDateTime read getRemovalDueTime;

{$ENDIF}
{$IFDEF CAS_DDPE_DEBUG}
    property Raw: string read FRaw;
{$ENDIF}

    property TimeLastAction: string read FTimeLastAction write
      setTimeLastAction;
    property LastGivenDateTime: string read FLastGivenDateTime write
      FLastGivenDateTime;
    property LastActivityStatus: string read FLastActivityStatus write
      setLastActivityStatus;
    property StartDateTime: string read FStartDateTime write setStartDateTime;
    property StopDateTime: string read FStopDateTime;
    property OrderStatus: string read FOrderStatus write setOrderStatus;

    property VerifyNurse: string read FVerifyNurse write setVerifyNurse;
    property MedLogIEN: string read FMedLogIEN write setMedLogIEN;
    property ScanStatus: string read FScanStatus write setScanStatus;

    property AdministrationTime: string read FAdministrationTime write
      setAdministrationTime;

    property OrderableItemIEN: string read FOrderableItemIEN write
      setOrderableItemIEN;

    property InjectionSiteNeeded: boolean read FInjectionSiteNeeded;
    property VariableDose: boolean read FVariableDose;
    property WardStock: boolean read FWardStock write FWardStock;
    property DisplayInstructions: boolean read FDisplayInstructions;

    property OrderTooTall: boolean read FOrderTooTall write FOrderTooTall;
    property InjOnPB: Boolean read FInjOnPB write FInjOnPB; // rpk 2/15/2012

    property UnknownMessageDisplayed: boolean read FUnknownMessageDisplayed write
      FUnknownMessageDisplayed;
    property AdministrationUnit: string read FAdministrationUnit write
      FAdministrationUnit;

    property SpecialInstructions: string read FSpecialInstructions write
      setSpecialInstructions;
    property SIOPIList: TStringList read FSIOPIList write setSIOPIList; // rpk 11/09/2011

    property OrderedDrugs[index: integer]: TBCMA_DispensedDrug read
    getOrderedDrugs;

    property OrderedDrugIENs: TStringList read FOrderedDrugIENs;
    property OrderedDrugNames: TStringList read FOrderedDrugNames;
    property OrderedDrugUnits: TStringList read FOrderedDrugUnits;
    property UnitsGiven: TStringList read FUnitsGiven;

    property Solutions: TStringList read FSolutions;
    property Additives: TStringList read FAdditives;
    property UniqueIDs: TStringList read FUniqueIDs;
    property LastFourActions: TStringList read FLastFourActions;
    property OrderChangedData: TStringList read FOrderChangedData;
    property AdditionalComments: TStringList read FAdditionalComments write
      FAdditionalComments;

    property ReasonGivenPRN: string read FReasonGivenPRN write FReasonGivenPRN;
    property UserComments: string read FUserComments write FUserComments;
    property UserComments2: string read FUserComments2 write FUserComments2;
    property InjectionSite: string read FInjectionSite write FInjectionSite;
    property DermalSite: string read FDermalSite write FDermalSite;
    property BodySite: string read FBodySite write FBodySite;
    property LastSite: string read FLastSite write FLastSite;

    property Status: integer read FStatus write FStatus; // rpk 3/25/2011
    property StatusMessage: string read FStatusMessage write FStatusMessage; // rpk 3/22/2011
    property ValidOrder: boolean read getValidOrder write FValidOrder;
    property Action: string read FAction write FAction;

    property PRNList: TStringList read getPRNList;
    property UniqueID: string read FUniqueID;
    property NurseIEN: string read FNurseIEN;
    property WitnessFlag: string read FWitnessFlag write FWitnessFlag; // rpk 5/11/2012
    property WitnessDUZ: string read FWitnessDUZ write FWitnessDUZ; // rpk 4/24/2012
    property WitnessName: string read FWitnessName write FWitnessName; // rpk 4/24/2012
    property WitnessComment: string read FWitnessComment write FWitnessComment; // rpk 6/15/2012
    property CanMarkNG: Boolean read getCanMarkNG;
    property OrderTransferred: string read FOrderTransferred;
    property OvrIntvent: Boolean read FOvrIntvent; // rpk 1/14/2011
    property ClinicName: string read FClinicName write FClinicName; // rpk 4/19/2012
    property ClinicIEN: string read FClinicIEN write FClinicIEN; // rpk 11/15/2012

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil;
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

    function SelectOrderedDrugID(inList: TList): Integer; // rpk 12/13/2012
    (*
      Uses TfrmMultipleOrderedDrugs to display a list of the OrderedDrugs
      for the order.
      returns the index of the selected drugs
    *)

    function indexOf(value: string): integer;
    (*
      Given an input drug IEN code, this function returns the index of the
      correponding Ordered Drug in the OrderedDrugs TList.
    *)

    function OrderedDrugCount: integer;
    (*
      Returns the value of OrderedDrugs.count.
    *)

    function SolutionCount: integer;
    (*
      Returns the value of Solutions.count.
    *)

    function AdditiveCount: integer;
    (*
      Returns the value of Additives.count.
    *)

    function UniqueIDCount: Integer;

    function LogOrder(MedLogType: TMedLogTypes; newStatus: string; IVBag:
      TBCMA_IVBags): boolean;
    (*
      Uses RPC 'PSB TRANSACTION' to log all transactions against the order.
      Processes 'MEDPASS', 'UPDATE STATUS' and 'ADD COMMENT' transactions.
    *)
    procedure ClearDispensedDrugsEnteredData;
    function CheckQtyEntered: Boolean;
    procedure ClearAdminInfo;

    // Per RSD 2.6.1, If an order has not been verified by a nurse (*** in Ver column),
    // check site parameter NonNurseVfyLvl and do the following:
    // If level is No Warning, return Give.
    // If level is Warning, prompt nurse that order has not been verified and return
    // Give on OK only.
    // If level is Prohibit, display error message and return DoNotGive.
    // (If it was nurse verified, return Give.)

  // ChkNurseVfyReturnValues includes NotCalled, Give, or NotGive.  Start a current process
  // with NotCalled.  When CheckNonNurseVfy is first called, prompt or notify
  // depending on Nurse Verify parameter.  Once a choice is made to give or not give,
  // when CheckNonNurseVfy is called again during current process, return the
  // value decided.
    function CheckNonNurseVfy: ChkNurseVfyReturnValues; // rpk 3/18/2011

    ///
    ///  Display special instructions / other print info found in SpecialInstructions
    ///  string (old format) or SIOPIList (new format - word processing field)
    ///
    function DisplaySIOPI(CancelOn: Boolean): Boolean; // rpk 11/9/2011
    function GetSIOPIText: string;      // rpk 1/4/2012
    procedure SetSIOPIMemo(memo: TMemo); // rpk 1/4/2012
    function getTextNextActionYearDateTime: string;
    function isMRR: Boolean;

  end;                                  // TBCMA_MedOrder

  TBCMA_Patient = class(TObject)
    (*
      Contains information about a Patient.
    *)
  private
    FRPCBroker: TBCMA_Broker;

    FIEN: string;
    FName: string;
    FSSN: string;
    FDOB: Double;
    FSex: string;
    FAge: string;                       // rpk 8/6/2009
    FWard: string;
    FWardIEN: string;
    FHospitalLocation: string;
    FHospitalLocationIEN: string;
    FRmBed: string;
    FHeight: string;
    FWeight: string;
    FICN,
      FAdminMessage: string;
    FReactions: boolean;
    FOMMedOrders: TList;
    FMedOrders,
      FIVBags,
      FPRNEffectList,
      FGivenExpiredPatches: TList;
    FOMMedOrdersOrderID,
      FPatientRecordFlags: TStringList;

    FMeans: boolean;                    //Means test required
    FMeans1: string;                    //Means test message one
    FMeans2: string;                    //Means test message two
    FLocked,
      FChanged,
      FActiveUDOrders,
      FActivePBOrders,
      FActiveIVOrders,
      FHasClinicOrders,                 // rpk 4/26/2012
      FHasInpatientOrders,              // rpk 4/26/2012
      FHasInfusingIVs,                  // rpk 8/10/2012
      FHasStoppedIVs,                   // rpk 9/5/2012
      FHasPatches: Boolean;             // rpk 8/10/2012
    FTransferred: boolean;

    FAllergies,
      FADRs: string;
    FTransferredMovementType: string;
    FTransferredTransactionType: string;
    FAdmitStatus: string;               // rpk 5/9/2012

  protected
    procedure SetName(newValue: string);
    procedure SetSSN(newValue: string);
    function getSSN: string;

    procedure SetDOB(newValue: Double);
    function GetDOB: string;
    procedure SetMDOB(newValue: string);

    procedure SetSex(newValue: string);

    function getAge: integer;

    procedure SetWard(newValue: string);
    procedure SetRmBed(newValue: string);
    procedure SetHeight(newValue: string);
    procedure SetWeight(newValue: string);
    procedure SetReactions(newValue: boolean);

    procedure SetMeans(newValue: boolean);
    procedure SetMeans1(newValue: string);
    procedure SetMeans2(newValue: string);

    procedure SetMedOrders(newValue: TList);
    procedure ClearMedOrders;
    procedure ClearIVBags;
    function GetAllergies: string;
    procedure ClearPRNEffectiveness;

  public
    property IEN: string read FIEN {write FIEN};
    property Name: string read FName write SetName;
    property SSN: string read getSSN write SetSSN;
    property DOB: string read GetDOB {write SetDOB};
    property Sex: string read FSex write SetSex;

    property Age: string read FAge;
    property Ward: string read FWard write SetWard;
    property WardIEN: string read FWardIEN write FWardIEN;
    property HospitalLocation: string read FHospitalLocation;
    property HospitalLocationIEN: string read FHospitalLocationIEN;
    property RmBed: string read FRmBed write SetRmBed;
    property Height: string read FHeight write SetHeight;
    property Weight: string read FWeight write SetWeight;
    property Reactions: boolean read FReactions write SetReactions;
    property Allergies: string read FAllergies;
    property ADRs: string read FADRs;
    property TransferredTransactionType: string read
      FTransferredTransactionType;
    property TransferredMovementType: string read FTransferredMovementType;
    property ICN: string read FICN;
    property AdminMessage: string read FAdminMessage;
    property AdmitStatus: string read FAdmitStatus; // rpk 5/9/2012
    property PatientRecordFlags: TStringList read FPatientRecordFlags;

    property Transferred: Boolean read FTransferred default False;

    property MedOrders: TList read FMedOrders { write setMedOrders};
    property PRNEffectList: TList read FPRNEffectList;
    property OMMedOrders: TList read FOMMedOrders;
    property GivenExpiredPatches: TList read FGivenExpiredPatches;
    property IVBags: TList read FIVBags;
    property Locked: boolean read FLocked;

    property Means: boolean read FMeans write SetMeans;
    property Means1: string read FMeans1 write SetMeans1;
    property Means2: string read FMeans2 write SetMeans2;
    property ActiveUDOrders: Boolean read FActiveUDOrders;
    property ActivePBOrders: Boolean read FActivePBOrders;
    property ActiveIVOrders: Boolean read FActiveIVOrders;
    property HasClinicOrders: Boolean read FHasClinicOrders; // rpk 4/26/2012
    property HasInpatientOrders: Boolean read FHasInpatientOrders; // rpk 4/26/2012
    property HasInfusingIVs: Boolean read FHasInfusingIVs; // rpk 8/10/2012
    property HasStoppedIVs: Boolean read FHasStoppedIVs; // rpk 9/5/2012
    property HasPatches: Boolean read FHasPatches; // rpk 8/10/2012

    property OMMedOrdersOrderID: TStringList read FOMMedOrdersOrderID write
      FOMMedOrdersOrderID;

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil;
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

    function ScanPatient(newIEN: string; PatientLookup: Integer;
      CCOWOpenPatientType: string = 'SS'): Boolean;
    (*
      Uses RPC 'PSB SCANPT' to validate a Patient IEN and retrieve Patient
      information.  RPC 'PSB LOCK' attempts to lock the Patient's server
      data.  If the IEN is found and the lock succeeds, the Patient data is
      saved and the function Result := True.  PatientLookup, 1 if looking up
      via patient lookup, 0 if scanned via vdl.
    *)

    procedure LoadMedOrders;
    (*
      Uses RPC 'PSB GETORDERTAB' to load all active medication orders for
      the patient.  If special instructions field is populated, calls GetComments.
      GetComments returns full text for special instructions / other print info which
      is stored in FSpecialInstructions.  PSB GETORDERTAB was modified to pass all
      patches from both order modes.  This allowed the expired patches for both
      modes to be included in the popup for expired, not removed patches.
    *)

    procedure InitOMMedOrder();
    function LoadIVBags(OrderNum: string): string;
    function GetIVBagFromUniqueID(UniqueIDIn: string): TBCMA_IVBags;

    function Unlock: boolean;
    (*
      Uses RPC 'PSB LOCK' to unlock the Patient's server data.
    *)
    procedure ClearOMMedOrders();
    procedure SendOMMedOrders(OrderIDString: WideString);
    procedure CancelOMMedOrders();

    procedure LoadPRNEffectiveness(OrderNumber: string);
    (*
      Uses RPC PSB GETPRNs to load administrations that require PRN Effectiveness
      documented.
    *)

    function CheckSensitive(var Status: integer; var msg: string): Boolean;
    //    function LogSensitive: Boolean;
   { setshp parses Results[1] from PSB GETORDERTAB to set indicator flags
   for VDL tabs, inpatient / clinic orders, IVs present, Patches present

   Results[1] =  ^1      Data for the Unit Dose tab (0=no, 1=yes)
                 ^2      Data for the Piggy Back tab (0=no, 1=yes)
                 ^3      Data for the IV tab (0=no, 1=yes)
                 ^4      Transfer type if there was a patient movement
                 ^5      Movement type if there was a patient movement
                 ^6      Count of Inpatient Orders for this patient
                 ^7      Count of Clinic Orders for this patient
                 ^8      IV's still infusing indicator light
                 ^9      Patch still on indicator light }
//                 ^10     Stopped IVs?

    procedure SetShp(StringIn: string);
    procedure LoadGivenExpiredMRRList;

    // calls PSB MEDS ON PATIENT to retrieve current status of meds on patient flags
    function GetMedsOnPatient: Boolean;

  end;                                  // TBCMA_Patient

  TmDateTime = class(TObject)
    (*
      A data structure for working with M server datetime values.
    *)
  private
    FmDateTime: string;
  protected
    function getDisplayText: string;
  public
    property mDateTime: string read FmDateTime write FmDateTime;
    property DisplayText: string read getDisplayText;
  end;

  TBCMA_OMScannedMeds = class(TObject)

  private
    FRPCBroker: TBCMA_Broker;

    FScannedDrugIEN,
      FScannedDrugName,
      FScannedDrugType,
      FOrderableItemIEN,
      FOrderableItemName,
      FAdditiveIEN,
      FSolutionIEN,
      FVolume: string;
    FUnitsPerDose: Integer;

  protected

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;

    destructor Destroy; override;

    procedure Clear;
    property ScannedDrugName: string read FScannedDrugName;
    property ScannedDrugIEN: string read FScannedDrugIEN;
    property ScannedDrugType: string read FScannedDrugType;
    property OrderableItemIEN: string read FOrderableItemIEN;
    property OrderableItemName: string read FOrderableItemName;
    property AdditiveIEN: string read FAdditiveIEN;
    property SolutionIEN: string read FSolutionIEN;
    property Volume: string read FVolume;

    property UnitsPerDose: Integer read FUnitsPerDose;
  end;

  TBCMA_OMMedOrder = class(TObject)

  private
    FRPCBroker: TBCMA_Broker;

    FScannedMeds: Tlist;
    FProviderIEN,
      FInjectionSite,
      FDermalSite,
      FBodySite,
      FAdminDateTime,
      FOrderType,
      FIVType,
      FIntSyringe,
      FSchedule: string;
    FOrderID: WideString;

  protected

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;

    destructor Destroy; override;

    procedure ClearScannedMeds;
    function isValidProvider(var StringIn: string): string;
    function isValidMedSolution(ScannedDrugIENString, OrderTypeIn: string):
      Boolean;

    property ScannedMeds: TList read FScannedMeds;
    property ProviderIEN: string read FProviderIEN write FProviderIEN;
    property AdminDateTime: string read FAdminDateTime write FAdminDateTime;
    property InjectionSite: string read FInjectionSite write FInjectionSite;
    property DermalSite: string read FDermalSite write FDermalSite;
    property BodySite: string read FBodySite write FBodySite;
    property OrderType: string read FOrderType write FOrderType;
    property IVType: string read FIVType write FIVType;
    property IntSyringe: string read FIntSyringe write FIntSyringe;
    property OrderID: WideString read FOrderID write FOrderID;
    property Schedule: string read FSchedule write FSchedule;

    procedure SendOrder(OrderIDin: string);
    procedure GetSolAddStr(var SolutionList, AdditiveList: WideString);
  end;

  TBCMA_PRNEffectList = class(TObject)

  private
    FRPCBroker: TBCMA_Broker;
    FMedLogIEN,
      FPatientLocation,
      FAdminDateTime,
      FAdministeredBy,
      FAdministeredMed,
      FPRNReason,
      FUnitsGiven,
      FSpecialInstructions,
      FOrderableItemIEN,
      FOrderNumber: string;
    FRequirePainScore: Integer;

    FDispensedDrugs,
      FAdditives,
      FSolutions,
      FSIOPIList: TStringList;          // rpk 11/09/2011
  protected
    procedure setSIOPIList(newValue: TStringList); // rpk 1/6/2012

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    destructor Destroy; override;
    property MedLogIEN: string read FMedLogIEN;
    property PatientLocation: string read FPatientLocation;
    property AdminDateTime: string read FAdminDateTime;
    property AdministeredBy: string read FAdministeredBy;
    property AdministeredDrug: string read FAdministeredMed;
    property PRNReason: string read FPRNReason;
    property SpecialInstructions: string read FSpecialInstructions;
    property SIOPIList: TStringList read FSIOPIList write setSIOPIList; // rpk 1/6/2012
    property UnitsGiven: string read FUnitsGiven;
    property OrderableItemIEN: string read FOrderableItemIEN;
    property OrderNumber: string read FOrderNumber;
    property RequirePainScore: Integer read FRequirePainScore;

    property DispensedDrugs: TStringList read FDispensedDrugs;
    property Additives: TStringList read FAdditives;
    property Solutions: TStringList read FSolutions;
    procedure Clear;
    procedure SetSIOPIMemo(memo: TMemo); // rpk 1/6/2012

  end;

  TBCMA_EditMedLog = class(TObject)
  private
    FRPCBroker: TBCMA_Broker;
    FMLIEN,
      FPatientIEN,
      FPatientName,
      FSSN,
      FOrderableItem,
      FOrderableItemIEN,
      FBagID,
      FScanStatus,
      FOriginalScanStatus,
      FAdminDateTime,
      FMAdminDateTime,
      FInjectionSite,
      FDermalSite,
      FBodySite,
      FPRNReason,
      FPRNEffectiveness,
      FScheduleType,
      FOrderStatus,
      FOrderNumber,
      FComment,
      FTab: string;

    FDispensedDrugs,
      FAdditives,
      FSolutions:
    TStringList;
    FPatchBag: Boolean;                 //is a patch or bag currently administered or infusing?
    fIsMrr: Boolean;
    FRemovalStatus: string;             // rpk 3/7/2016
  protected

    function getScheduleTypeID: TScheduleTypes;
    function getAdminStatusID: TScanStatus;
    function getIsPatch: Boolean;
    function getIsMRR: Boolean;
  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    destructor Destroy; override;

    procedure Clear;
    procedure LoadAdministration(MLIEN: string);
    procedure LogEditedOrder;

    property MLIEN: string read FMLIEN;
    property PatientName: string read FPatientName;
    property SSN: string read FSSN;
    property Medication: string read FOrderableItem;
    property PRNReason: string read FPRNReason write FPRNReason;
    property PRNEffectiveness: string read FPRNEffectiveness write
      FPRNEffectiveness;
    property AdminDateTime: string read FAdminDateTime;
    property MAdminDateTime: string read FMAdminDateTime write FMAdminDateTime;
    property ScanStatus: string read FScanStatus write FScanStatus;
    property OriginalScanStatus: string read FOriginalScanStatus;
    property ScanStatusID: TScanStatus read getAdminStatusID;
    property AdminStatusID: TScanStatus read getAdminStatusID;
    property InjectionSite: string read FInjectionSite write FInjectionSite;
    property DermalSite: string read FDermalSite write FDermalSite;
    property BodySite: string read FBodySite write FBodySite;
    property RemovalStatus: string read FRemovalStatus; // rpk 3/7/2016
    property DispensedDrugs: TStringList read FDispensedDrugs write
      FDispensedDrugs;
    property Additives: TStringList read FAdditives;
    property Solutions: TStringList read FSolutions;
    property Comment: string read FComment write FComment;
    property ScheduleType: string read FScheduleType;
    property OrderNumber: string read FOrderNumber;
    property PatchBagActive: Boolean read FPatchBag;
    property Tab: string read FTab;
    property ScheduleTypeID: TScheduleTypes read getScheduleTypeID;
    property IsPatch: Boolean read getIsPatch;
    property IsMRRSite: Boolean read getIsMrr; // rpk 3/7/2016
    property OrderableItemIEN: string read FOrderableItemIEN;
    property BagID: string read FBagID;
    property OrderStatus: string read FOrderStatus;
  end;

  TBCMA_TimerHandler = class(TObject)
  public
    procedure TimerEvent(Sender: TObject);
  end;

implementation

uses
  Math,
//  MFunStr,
  Debug,
  BCMA_Startup,
  BCMA_Common,
  MultipleOrderedDrugs,
  SelectReason, fSelectInjection,
  BCMA_Main,
  Report,
  AxCtrls,
  WardStock,
  uCCOW,
  fPtConfirmation,
  fWitness,                             // rpk 5/17/2012
  oCoverSheet,
  strUtils,
  uCAS_Utils;


////////////////////////////////////////// TmDateTime Stuff
// Note: getDisplayText uses code similar to BCMA_Common.DisplayVADate
// this could be modified to call DisplayVADate(FmDateTime)

function TmDateTime.getDisplayText: string;
var
  ss: string;
begin
  result := '';
  if FmDateTime <> '' then begin
    ss := FmDateTime;
    result := copy(ss, rPos('.', ss) - 4, 2) + '/' +
      copy(ss, rPos('.', ss) - 2, 2) + '@' +
      copy(ss, pos('.', ss) + 1, 99) + '00000';
    result := copy(result, 1, 10);
  end;
end;

/////////////// TBCMA_Patient Object ////////////////////////

constructor TBCMA_Patient.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then begin
    FRPCBroker := RPCBroker;
    FMedOrders := TList.Create;
    FOMMedOrders := TList.Create;
    FIVBags := TList.Create;
    FOMMedOrdersOrderID := TStringList.Create;
    FPatientRecordFlags := TStringList.Create;
    FPRNEffectList := TList.Create;
    FGivenExpiredPatches := TList.Create
  end;

  Clear;
end;

destructor TBCMA_Patient.Destroy;
begin
  Clear;
  FMedOrders.Free;
  FOMMedOrders.Free;
  FIVBags.Free;
  FOMMedOrdersOrderID.Free;
  FPRNEffectList.Free;
  FPatientRecordFlags.Free;
  FGivenExpiredPatches.Free;
  FRPCBroker := nil;

  inherited Destroy;
end;

procedure TBCMA_Patient.Clear;
begin
  if FIEN <> '' then begin
    ClearMedOrders;
    ClearPRNEffectiveness;
  end;

  FIEN := '';
  FName := '';
  FSSN := '';
  FDOB := 0;
  FSex := '';
  FAge := '';                           // rpk 8/6/2009
  FWard := '';
  FWardIEN := '';
  FHospitalLocation := '';
  FHospitalLocationIEN := '';
  FRmBed := '';
  FHeight := '';
  FWeight := '';
  FReactions := False;
  FMeans := False;
  FMeans1 := '';
  FMeans2 := '';
  FLocked := False;
  FAllergies := '';
  FADRs := '';
  FTransferredMovementType := '';
  FTransferredTransactionType := '';
  FTransferred := False;
  FICN := '';
  FAdminMessage := '';
  FChanged := False;
  FPatientRecordFlags.Clear;
  FActivePBOrders := False;
  FHasClinicOrders := False;            // rpk 6/19/2012
  FHasInpatientOrders := False;         // rpk 6/19/2012
end;

function TBCMA_Patient.GetMedsOnPatient: Boolean;
var
  IVCnt, StoppedCnt, PatchCnt: Integer;
begin
  Result := False;                      // rpk 12/7/2012
  if (FRPCBroker <> nil) then begin
    with FRPCBroker do begin
      if CallServer('PSB MEDS ON PATIENT', [FIEN], nil) then begin // rpk 10/1/2012
        if (Results.Count = 0) or (Results.Count - 1 <> StrToInt(Results[0]))
          then begin
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
          FHasInfusingIVs := False;
          FHasStoppedIVs := False;
          FHasPatches := False;
        end
        else if (Results.Count > 1) and
          (Results[0] = '1') then begin
          IVCnt := StrToIntDef(piece(Results[1], U, 1), 0); // rpk 10/1/2012
          StoppedCnt := StrToIntDef(piece(Results[1], U, 2), 0); // rpk 10/1/2012
          PatchCnt := StrToIntDef(piece(Results[1], U, 3), 0); // rpk 10/1/2012
          fHasInfusingIVs := IVCnt > 0; // rpk 10/1/2012
          fHasStoppedIVs := StoppedCnt > 0; // rpk 10/1/2012
          fHasPatches := PatchCnt > 0;  // rpk 10/1/2012
          Result := True;               // rpk 12/7/2012
        end;                            // results[1]
      end;
    end;
  end;
end;                                    // GetMedsOnPatient

procedure TBCMA_Patient.SetName(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FName then begin
      FName := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetShp(StringIn: string);
var
  IMCnt, COCnt, IVCnt, StoppedCnt, PatchCnt: Integer;
begin
  with BCMA_Patient do begin
    fActiveUDOrders := (piece(StringIn, '^', 1) = '1');
    fActivePBOrders := (piece(StringIn, '^', 2) = '1');
    fActiveIVOrders := (piece(StringIn, '^', 3) = '1');
    // expect ADMISSION or DISCHARGE
    fAdmitStatus := piece(StringIn, U, 4); // rpk 5/9/2012
    // Piece 5?
    IMCnt := StrToIntDef(piece(StringIn, U, 6), 0); // rpk 4/26/2012
    COCnt := StrToIntDef(piece(StringIn, U, 7), 0); // rpk 4/26/2012
    fHasInpatientOrders := IMCnt > 0;   // rpk 4/26/2012
    fHasClinicOrders := COCnt > 0;      // rpk 4/26/2012
    IVCnt := StrToIntDef(piece(StringIn, U, 8), 0); // rpk 8/10/2012
    StoppedCnt := StrToIntDef(piece(StringIn, U, 9), 0); // rpk 9/5/2012
    PatchCnt := StrToIntDef(piece(StringIn, U, 10), 0); // rpk 8/10/2012
    fHasInfusingIVs := IVCnt > 0;       // rpk 8/10/2012
    fHasStoppedIVs := StoppedCnt > 0;   // rpk 9/5/2012
    fHasPatches := PatchCnt > 0;        // rpk 8/10/2012
  end;
end;                                    // setshp

procedure TBCMA_Patient.SetSSN(newValue: string);
var
  ss: string;
begin
  ss := newValue;
  while pos('-', ss) > 0 do
    ss := copy(ss, 1, pos('-', ss) - 1) + copy(ss, pos('-', ss) + 1, 99);

  if FRPCBroker <> nil then
    if ss <> FSSN then begin
      FSSN := ss;
      FChanged := True;
    end;
end;

function TBCMA_Patient.getSSN: string;
begin
  result := '';
  if FRPCBroker <> nil then
    if FSSN <> '' then
      result := ifThen(BCMA_USER.AgencyCode = 'I', // IHS rpk 8/6/2009
        FSSN,
        copy(FSSN, 1, 3) + '-' + copy(FSSN, 4, 2) + '-' + copy(FSSN, 6, 4));
end;

procedure TBCMA_Patient.SetDOB(newValue: Double);
begin
  if FRPCBroker <> nil then
    if newValue <> FDOB then begin
      FDOB := newValue;
      FChanged := True;
    end;
end;

function TBCMA_Patient.GetDOB: string;
begin
  try
    //if we have a valid date, let Delphi handle the date format according
    //to user's regional settings
    result := DateToStr(FMDateTimeToDateTime(FDOB))
  except
    //if not a valid date, attempt to piece the date together according to the
    //user's regional settings
    result := FormatFMDateTime(shortdateformat, FDOB);
  end;
end;

procedure TBCMA_Patient.SetMDOB(newValue: string);
var
  tempDate: Double;
begin

  if FRPCBroker <> nil then begin
    tempDate := MakeFMDateTime(newValue);

    if tempDate <> FDOB then begin
      FDOB := tempDate;
      FChanged := True;
    end;
  end;
end;

procedure TBCMA_Patient.SetSex(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FSex then begin
      FSex := newValue;
      FChanged := True;
    end;
end;

function TBCMA_Patient.getAge: integer;
var
  y2, y1,
    m2, m1,
    d2, d1: word;
begin

  result := 0;
  if FRPCBroker <> nil then begin
    if FDOB > 0 then begin
      decodeDate(date, y2, m2, d2);
      decodeDate(FDOB, y1, m1, d1);
      result := y2 - y1;
      if m2 < m1 then
        result := result - 1
      else if d2 < d1 then
        result := result - 1;
    end;
  end;
end;

procedure TBCMA_Patient.SetWard(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FWard then begin
      FWard := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetRmBed(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FRmBed then begin
      FRmBed := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetHeight(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FHeight then begin
      FHeight := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetWeight(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FWeight then begin
      FWeight := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetReactions(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FReactions then begin
      FReactions := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetMedOrders(newValue: TList);
var
  ii: integer;
begin
  if FRPCBroker <> nil then
    if newValue <> nil then begin
      ClearMedOrders;
      for ii := 0 to newValue.count - 1 do
        FMedOrders.add(newValue.items[ii]);

      FChanged := True;
    end;
end;

procedure TBCMA_Patient.ClearMedOrders;
var
  ii: integer;
begin
  if FMedOrders <> nil then
    with FMedOrders do begin
      for ii := count - 1 downto 0 do
        TBCMA_MedOrder(items[ii]).free;
      clear;
    end;
  FGivenExpiredPatches.Clear;
end;

procedure TBCMA_Patient.ClearIVBags;
var
  ii: integer;
  ptr: Pointer;
begin
  if FIVBags <> nil then begin
    with FIVBags do begin
      for ii := count - 1 downto 0 do begin
        ptr := items[ii];               // rpk 9/23/2010
        if ptr <> nil then begin        // rpk 9/23/2010
          TBCMA_IVBags(ptr).Free;       // rpk 9/23/2010
          items[ii] := nil;             // rpk 2/17/2011
        end;
      end;
      clear;
    end;

//    FIVBags := nil;  // rpk 2/17/2011
  end;

end;                                    // ClearIVBags

function TBCMA_Patient.Unlock: boolean;
begin
  FLocked := False;
  if (FRPCBroker <> nil) and (FIEN <> '') then
    with FRPCBroker do
      if CallServer('PSB LOCK', [FIEN, '-1'], nil) then
      (* 1 to Lock, -1 to Unlock *)begin
        FLocked := not (piece(Results[0], '^', 1) = '1');
        (* -1 = failure, 1 = success *)
        if FLocked then
          DefMessageDlg(piece(Results[0], '^', 2), mtError, [mbOK], 0);
      end;

  result := not FLocked;
end;

procedure TBCMA_Patient.SetMeans(newValue: Boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FMeans then begin
      FMeans := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetMeans1(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FMeans1 then begin
      FMeans1 := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetMeans2(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FMeans2 then begin
      FMeans2 := newValue;
      FChanged := True;
    end;
end;

function TBCMA_Patient.CheckSensitive(var Status: integer; var msg: string):
  Boolean;
begin
  Result := False;
  if FRPCBroker <> nil then
    with FRPCBroker do begin
      if CallServer('DG SENSITIVE RECORD ACCESS', [FIEN], nil) then begin
        if (Results.Count = 0) or (StrToIntDef(Results[0], -1) = -1) then begin
          Msg := Msg + #13 + 'Sensitive Record Check Failed!';
          Status := -1;
        end
        else begin
          Status := StrToIntDef(Results[0], -1);
          Results.Delete(0);
          if Results.Count > 0 then
            msg := Results.Text;
        end;
      end;
    end;
end;

function TBCMA_Patient.GetAllergies: string;
var
  x: integer;
  Allergies,
    ADR: string;
begin
  if FRPCBroker <> nil then
    with FRPCBroker do begin
      if CallServer('PSB ALLERGY', [FIEN], nil) then
        if StrToInt(results[0]) <> results.count - 1 then
          Result := 'Error in Data'
        else if piece(results[1], '^', 1) = '-1' then begin
          FAllergies := piece(results[1], '^', 2);
          FADRs := piece(results[1], '^', 2);
        end
        else if piece(results[1], '^', 1) = '0' then begin
          FAllergies := 'No allergies on file';
          FADRs := 'No ADRs on file';
        end
        else begin
          for x := 1 to Results.count - 1 do
            if piece(results[x], '^', 1) = 'ALL' then begin
              if allergies = '' then
                allergies := piece(results[x], '^', 2)
              else
                allergies := allergies + ', ' + piece(results[x], '^', 2);
            end
            else if piece(results[x], '^', 1) = 'ADR' then begin
              if adr = '' then
                adr := piece(results[x], '^', 2)
              else
                adr := adr + ', ' + piece(results[x], '^', 2);
            end;

          allergies := LowerCase(allergies);
          adr := LowerCase(adr);

          if allergies = '' then
            allergies := 'No allergies on file';
          if adr = '' then
            adr := 'No ADRs on file';

          FAllergies := Allergies;
          FADRs := ADR;
        end
      else
        FAllergies := 'Error obtaining allergy information.';
    end;
end;                                    // GetAllergies


function TBCMA_Patient.ScanPatient(newIEN: string; PatientLookup: Integer;
  CCOWOpenPatientType: string = 'SS'): Boolean;
var
  CCOWPatientName: string;
  x: integer;
begin
  Result := False;
  frmMain.Repaint;
  if FRPCBroker <> nil then
    with FRPCBroker do begin
      Clear;                            // Clear out the current patient first!
      if CallServer('PSB SCANPT', [newIEN + '^' + IntToStr(PatientLookup) + '^'
        + CCOWOpenPatientType], nil) then begin
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0],
          -1)) then begin
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
          exit;
        end
        else if piece(Results[1], '^', 1) = '-1' then begin
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0);
          exit;
        end
        else if UnableToScan and (piece(Results[21], '^', 1) <> '') then begin
          DefMessageDlg(piece(Results[21], '^', 1), mtError, [mbOK], 0);
          exit;
        end
        else begin
          FIEN := Results[1];           // Patient IEN
          FName := Results[2];
          FSSN := piece(Results[3], '^', 1);
          SetMDOB(piece(Results[4], '^', 1));
          FSex := piece(Results[6], '^', 2);
          FWard := piece(Results[9], '^', 2);
          FWardIEN := piece(Results[9], '^', 1);
          FHospitalLocation := piece(Results[9], '^', 4);
          FHospitalLocationIEN := piece(Results[9], '^', 3);
          FRmBed := piece(Results[10], '^', 2);
          FHeight := Results[16];
          FWeight := Results[17];
          FReactions := (Results[18] = '1');
          FAge := piece(Results[5], '^', 1); // rpk 8/6/2009
          FMeans := (piece(Results[19], '^', 1) = '1');
          FMeans1 := piece(Results[19], '^', 2);
          FMeans2 := piece(Results[19], '^', 3);
          FICN := piece(piece(Results[20], '^', 1), 'V', 1);
          FAdminMessage := piece(Results[21], '^', 1);
          for x := 22 to Results.Count - 1 do
            if uppercase(piece(Results[x], '^', 1)) = 'PATFLG' then
              FPatientRecordFlags.Add(piece(Results[x], '^', 2));

          GetAllergies;

          if ((CCOWOpenPatientType = 'SS') and
            (ConfirmPatient <> True)) then begin
            Result := False;
            Clear;
          end
          else begin
            Result := True;

            //The following was added for CCOW
            Screen.Cursor := crHourglass;
            CCOWPatientName := piece(BCMA_Patient.Name, ',', 1) + '^' +
              piece(BCMA_Patient.Name, ',', 2) + '^^^^';

            frmMain.StatusBar.Panels[0].Text := 'Talking to CCOW Vault...';
            frmMain.StatusBar.Repaint;
            //if this open patient was triggered by CCOW, thus, not an SSN lookup then
            //don't attempt to set the patient context, as we are already changing patients
            //because CCOW told us to.
            if (VACCOW <> nil) and (CCOWOpenPatientType = 'SS') then // rpk 7/25/2013
              if not VACCOW.SetNewPatientContext(BCMA_Patient.IEN,
                BCMA_Patient.ICN,
                CCOWPatientName, BCMA_User.SiteIEN, BCMA_User.ProductionAccount)
                and VACCOW.CCOWEnabled then begin
                Clear;
                Result := False;
              end;
          end;
          Screen.Cursor := crDefault;
          //end of CCOW changes
        end;                            // else patient found
      end;                              // if CallServer
    end;
  frmMain.StatusBar.Panels[0].Text := '';
end;                                    // ScanPatient

procedure TBCMA_Patient.LoadMedOrders;
const
  ORDERRESULTSCOUNT = 5;
  minute = 1 / (24 * 60);
var
  ii: Integer;
  rr: string;
  resultscnt: Integer;                  // rpk 4/29/2009
  orderstr, tmpstr: string;             // rpk 4/28/2009
  ResultList: TStringList;
  OIList: TStringList;
  aMedOrder: TBCMA_MedOrder;
  lstidx: Integer;
  injsiteneededstr: string;
  durstr: string;
  ordermodestr: string;
  tmpDate: TDate;
  OrderDate: string;
  witness_str: string;
begin
  rr := '';
  orderstr := '';
  tmpstr := '';
  durstr := '9999999';
  OrderDate := '';                      // rpk 12/21/2012
  // Use ResultList and resultscnt for outer list returned by PSB GETORDERTAB.
  // Results will be overwritten by list returned by GetComments
  ResultList := TStringList.Create;
  OIList := TStringList.Create;

  // OrderMode = 0 for Inpatient; 1 for Clinic
  ordermodestr := IntToStr(ord(OrderMode)); // rpk 4/25/2012

  if (FRPCBroker <> nil) and
    (FMedOrders <> nil) and
    (ResultList <> nil) and
    (OIList <> nil) and
    (FIEN <> '') then
    with FRPCBroker do begin
      OrderDate := '';                  // rpk 1/18/2013
      if OrderMode = OMClinic then begin
        if lstCurrentTab = ctIV then
          OrderDate := ''
        else begin                      // rpk 7/16/2012
          // convert Delphi date to FileMan date and truncate fractional time to pass just the date.
          tmpDate := frmMain.dtpkrClinicOrders.Date;
          OrderDate := DateToMDate(tmpDate); // rpk 1/18/2013
        end;
      end
      else
        OrderDate := '';

      if CallServer('PSB GETORDERTAB', [FIEN,
        lstUnitDoseCurrentTab[lstCurrentTab],
          OrderDate, PSBSIOPI_WP, ordermodestr, ClinicDateSearch], nil) then // rpk 7/13/2012
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0],
          0))                           // rpk 2/12/2016
          then begin
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
          ClearMedOrders;
          ClearIVBags;
          if Results.Count = 0 then
            setshp('0^0^0^^^0^0^0^0')   // rpk 9/5/2012
          else
            setshp(Results[1]);         // rpk 8/22/2012
          with frmMain do begin
            setControlsEnable(grpStartStopTime, False); // rpk 5/24/2012
            setControlsEnable(grpSchedTypes, False); // rpk 5/24/2012
            setControlsEnable(grpClinicDate, False); // rpk 5/24/2012

            SetVDLMessage(ErrIncompleteData);
            BCMA_Patient.FTransferred := False;
          end;
        end
        else if (results.Count > 1) and // rpk 8/22/2012
          (piece(Results[1], '^', 4) = '-1') then begin
          ClearMedOrders;
          ClearIVBags;
          setshp(Results[1]);
          with frmMain do begin
            setControlsEnable(grpStartStopTime, False); // rpk 5/24/2012
            setControlsEnable(grpSchedTypes, False); // rpk 5/24/2012
            setControlsEnable(grpClinicDate, False); // rpk 5/24/2012

            SetVDLMessage(piece(Results[1], '^', 5));
            BCMA_Patient.FTransferred := False;
          end;
        end
        else begin
          resultscnt := Results.Count;  // rpk 4/29/2009
          ResultList.Assign(Results);   // rpk 4/29/2009
          ClearMedOrders;
          ClearIVBags;
          if Results.Count > 1 then     // rpk 2/12/2016
            setshp(Results[1]);
          BCMA_Patient.FTransferredTransactionType := piece(Results[1], '^', 4);
          BCMA_Patient.FTransferredMovementType := piece(Results[1], '^', 5);
          BCMA_Patient.FTransferred := False;
          with frmMain do
            case lstCurrentTab of
              ctIV, ctCS: begin
                  setControlsEnable(grpStartStopTime, False); // rpk 5/24/2012
                  setControlsEnable(grpSchedTypes, False); // rpk 5/24/2012
                  setControlsEnable(grpClinicDate, False); // rpk 5/24/2012
                end
            else begin
                setControlsEnable(grpStartStopTime, True); // rpk 5/24/2012
                setControlsEnable(grpSchedTypes, True); // rpk 5/24/2012
                setControlsEnable(grpClinicDate, True); // rpk 5/24/2012
              end;
            end;

          with FMedOrders do begin
            ii := 2;
            while ii < resultscnt - 1 do begin // rpk 4/29/2009
              rr := ResultList[ii];

              lstidx := add(TBCMA_MedOrder.create(FRPCBroker)); // rpk 6/29/2011
              aMedOrder := TBCMA_MedOrder(FMedOrders[lstidx]); // rpk 6/29/2011
              with aMedOrder do begin
{$IFDEF CAS_DDPE_DEBUG}
                fRaw := rr + #13#10;    // raw data from RPC
{$ENDIF}
                FStatus := 0;           // rpk 3/24/2011

                FPatientIEN := piece(rr, '^', 1);

                FOrderNumber := piece(rr, '^', 2);
                FOrderIEN := piece(rr, '^', 3);
                FOrderType := piece(rr, '^', 4);

                FScheduleType := piece(rr, '^', 5);
                FSchedule := piece(rr, '^', 6);

                FSelfMed := piece(rr, '^', 7);

                FActiveMedication := piece(rr, '^', 8); // drug name
                FDosage := piece(rr, '^', 9);
                FRoute := piece(rr, '^', 10);

                FTimeLastAction := piece(rr, '^', 11);

                FMedLogIEN := piece(rr, '^', 12);

                FScanStatus := uppercase(piece(rr, '^', 13));

                if FScanStatus = 'ML_STATUS' then
                  FScanStatus := '';

                if ScheduleTypeID = stContinuous then
                  (* Have to make sure this has 2 decimal places - wlk *)
                  FAdministrationTime := copy(piece(rr, '^', 14) + '0000', 1,
                    12);

                FOrderableItemIEN := piece(rr, '^', 15);

                injsiteneededstr := piece(rr, '^', 16);
                FInjectionSiteNeeded := (piece(rr, '^', 16) = '1');
                FVariableDose := (piece(rr, '^', 17) = '1');

                FAdministrationUnit := piece(rr, '^', 18);
                FVerifyNurse := piece(rr, '^', 19);
                FLastActivityStatus := uppercase(piece(rr, '^', 20));
                FStartDateTime := piece(rr, '^', 21);
                FOrderStatus := piece(rr, '^', 22);
                FUniqueID := piece(rr, '^', 23);
                FNurseIEN := piece(rr, '^', 24);
                FOrderTransferred := piece(rr, '^', 25);
                if FOrderTransferred = '1' then
                  BCMA_Patient.FTransferred := True;
                FStopDateTime := piece(rr, '^', 26);
                FLastGivenDateTime := piece(rr, '^', 27);
                // piece 28: Given Patch (1 = yes; defined in patch description)
                // piece 29: flag for provider / pharmacist override reason or intervention.
                FOvrIntvent := piece(rr, '^', 29) = '1';
                FLastSite := piece(rr, U, 30);
                FInjOnPB := piece(rr, U, 31) = '1'; // rpk 2/15/2012
                FClinicName := piece(rr, U, 32); // rpk 4/19/2012
                FClinicIEN := piece(rr, U, 33); // rpk 11/15/2012
{$IFDEF CAS_DDPE_RST}
                FRemovalStatus := piece(rr, U, 34); // per Greg 4/30/2015 2:40PM
                FRemovalDateTime := piece(rr, U, 35); // per Greg 4/30/2015 2:40PM
//                FBodySite := FLastSite;  // commmented out RPK 4/6/2016
{$ENDIF}
                Inc(ii);

                rr := ResultList[ii];
{$IFDEF CAS_DDPE_DEBUG}
                fRaw := fRaw + rr + #13#10; // raw data from RPC
{$ENDIF}

                FSpecialInstructions := piece(rr, '^', 1);

                if Copy(FSpecialInstructions, 1, 1) = '!' then begin
                  FDisplayInstructions := True;
                  FSpecialInstructions := Copy(SpecialInstructions, 2,
                    length(SpecialInstructions) - 1);
                end;

                FSIOPIList.Clear;       // rpk 11/09/2011

                FUnknownMessageDisplayed := false;

                Inc(ii);
                while ii < resultscnt - 1 do begin // rpk 4/29/2009
                  rr := ResultList[ii];
{$IFDEF CAS_DDPE_DEBUG}
                  fRaw := fRaw + rr + #13#10; // raw data from RPC
{$ENDIF}
                  if rr = 'END' then begin
                    Inc(ii);
                    Break;
                  end;

                  //Dispensed Drug
                  if piece(rr, '^', 1) = 'DD' then begin
                    FOrderedDrugs.add(TBCMA_DispensedDrug.create(FRPCBroker));
                    with
                      TBCMA_DispensedDrug(FOrderedDrugs.items[FOrderedDrugs.count
                      - 1]) do begin
                      FIEN := piece(rr, '^', 2);
                      FName := piece(rr, '^', 3);
                      FQtyOrdered := piece(rr, '^', 4);
                      witness_str := piece(rr, U, 7); // rpk 9/27/2012
                      FWitnessCode := witness_str;
                    end;

                    FOrderedDrugIENs.add(piece(rr, '^', 2));
                    FOrderedDrugNames.add(piece(rr, '^', 3));
                    FOrderedDrugUnits.add(piece(rr, '^', 4));

                    FUnitsGiven.add('0');
                    if (witness_str >= WITNESS_RECOMMENDED) and // rpk 10/15/2012
                      (witness_str > aMedOrder.FWitnessFlag) then // rpk 10/15/2012
                      aMedOrder.FWitnessFlag := witness_str;
                  end

                  //Solution
                  else if piece(rr, '^', 1) = 'SOL' then begin
                    with FSolutions do
                      add(rr);
                    witness_str := piece(rr, U, 7); // rpk 9/27/2012
                    if (witness_str >= WITNESS_RECOMMENDED) and // rpk 10/15/2012
                      (witness_str > aMedOrder.FWitnessFlag) then // rpk 10/15/2012
                      aMedOrder.FWitnessFlag := witness_str;
                  end

                  //Additive
                  else if piece(rr, '^', 1) = 'ADD' then begin
                    with FAdditives do
                      add(rr);
                    witness_str := piece(rr, U, 7); // rpk 9/27/2012
                    if (witness_str >= WITNESS_RECOMMENDED) and // rpk 10/15/2012
                      (witness_str > aMedOrder.FWitnessFlag) then // rpk 10/15/2012
                      aMedOrder.FWitnessFlag := witness_str;
                  end

                  //Unique ID's
                  else if piece(rr, '^', 1) = 'ID' then begin
                    with FUniqueIDs do
                      Add(piece(rr, '^', 2) + '^' +
                        piece(rr, '^', 3));
                  end
                  // Special Instructions / Other Print Info word processing text
                  else if piece(rr, U, 1) = 'SI' then begin // rpk 11/09/2011
                    FSIOPIList.Add(piece(rr, U, 2));
                  end;

                  Inc(ii);
                end;                    // inner while ii

              end;                      // with TBCMA_MedOrder
            end;                        // outer while ii
          end;

          LoadGivenExpiredMRRList;
        end;

      ResultList.Free;
      OIList.Free;
    end;                                // with fRPCBroker
end;                                    // LoadMedOrders

///////////////////////////// TBCMA_MedOrder

procedure TBCMA_Patient.InitOMMedOrder();
begin
  with FOMMedOrders do
    add(TBCMA_OMMedOrder.Create(FRPCBroker));
end;

procedure TBCMA_Patient.LoadGivenExpiredMRRList;
var
  x: integer;
  anOrder: TBCMA_MedOrder;
begin
  FGivenExpiredPatches.Clear;
  for x := 0 to MedOrders.Count - 1 do begin
    anOrder := TBCMA_MedOrder(MedOrders[x]);
    with anOrder do begin
      if RemovalIsAllowed then begin
        if ((FOrderStatus = 'D') or     // discontinued
          (FOrderStatus = 'DE')) then   // discontinued (edit)
//          (FOrderStatus = 'DR')) then   // discontinued (renewal)  // rpk 1/25/2016
          FGivenExpiredPatches.Add(TBCMA_MedOrder(FMedOrders[x]));
      end;                              // if RemovalIsAllowed
    end;                                // with
  end;                                  // for
end;                                    // LoadGivenExpiredMRRList

function TBCMA_Patient.LoadIVBags(OrderNum: string): string;
var
  ii: integer;
  rr: string;
  lstidx: Integer;
  aIVBag: TBCMA_IVBags;
begin
  if OrderNum = '' then begin
    DefMessageDlg('LoadIVBags: OrderNum is empty', mtError, [mbOk], 0);
    Result := '';
  end;
  ClearIVBags;
  Result := '';                         // rpk 8/30/2012

  if (FRPCBroker <> nil) and
    (FMedOrders <> nil) and
    (FIEN <> '') then
    with FRPCBroker do
      if CallServer('PSB IV ORDER HISTORY', [FIEN, OrderNum], nil) then
        if (results.Count > 0) and
          (piece(Results[1], '^', 1) = '-1') then begin
          ClearIVBags;
          Result := Results[1];
        end
        else
          with FIVBags do begin
            Result := '1';
            ClearIVBags;
            ii := 1;
            while ii < results.Count - 1 do begin
              if Results[ii] = 'END' then begin
                Inc(ii);                // rpk 2/7/2012
                break;                  // rpk 8/30/2012
              end;

              lstidx := add(TBCMA_IVBags.create(FRPCBroker)); // rpk 6/29/2011
              aIVBag := TBCMA_IVBags(FIVBags[lstidx]); // rpk 6/29/2011
              with aIVBag do begin
                rr := Results[ii];

                FOrderNumber := piece(rr, '^', 1);
                FUniqueID := piece(rr, '^', 2);
                FMedLogIEN := piece(rr, '^', 3);
                FTimeLastGiven := piece(rr, '^', 4);
                if Pos('.', FTimeLastGiven) = 0 then
                  FTimeLastGiven := FTimeLastGiven + '.';

                FScanStatus := piece(rr, '^', 5);
                FInjectionSite := piece(rr, '^', 6);

                Inc(ii);                // rpk 2/7/2012
                while ii < results.Count - 1 do begin
                  rr := Results[ii];

                  if rr = 'END' then begin
                    Inc(ii);            // rpk 2/7/2012
                    Break;
                  end;

                  //Solution
                  if piece(rr, '^', 1) = 'SOL' then begin
                    with FSolutions do
                      add(rr);
                  end

                    //Additive
                  else if piece(rr, '^', 1) = 'ADD' then begin
                    with FAdditives do
                      add(rr);
                  end;

                  Inc(ii);              // rpk 2/7/2012
                end;
              end;
            end;
          end;
end;                                    // LoadIVBags

function TBCMA_Patient.GetIVBagFromUniqueID(UniqueIDIn: string): TBCMA_IVBags;
var
  x: integer;
begin
  Result := nil;                        // rpk 4/6/2009

  for x := 0 to IVBags.Count - 1 do
    if TBCMA_IVBags(IVBags[x]).UniqueID = UniqueIDIn then begin
      Result := TBCMA_IVBags(IVBags[x]);
      exit;
    end;
end;

procedure TBCMA_Patient.LoadPRNEffectiveness(OrderNumber: string);

var
  ii: integer;
  resultscnt: Integer;                  // rpk 10/8/2009
  rr: string;
  ResultList: TStringList;              // rpk 10/8/2009
begin
  // Use ResultList and resultscnt for outer list returned by PSB GETPRNS.
  // Results will be overwritten by list returned by GetComments
  ResultList := TStringList.Create;     // rpk 10/8/2009
  try
    frmMain.StatusBar.Panels[0].Text := 'Retrieving PRN Effect Count...';
    frmMain.StatusBar.Repaint;
    ClearPRNEffectiveness;
    if (FRPCBroker <> nil) and
      (FMedOrders <> nil) and
      (FIEN <> '') then
      with FRPCBroker do
        if CallServer('PSB GETPRNS', [FIEN, OrderNumber, PSBSIOPI_WP], nil) then // rpk 1/10/2012
          if Results.Count - 1 <> StrToInt(Results[0]) then begin
            DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
          end
          else if (results.Count > 1) and
            (piece(Results[1], '^', 1) = '-1') then begin
            DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0);
          end
          else begin
            if Results.count > 1 then begin
              resultscnt := Results.Count; // rpk 10/8/2009
              ResultList.Assign(Results); // rpk 10/8/2009
              with FPRNEffectList do begin
                ii := 1;
                while ii < resultscnt - 1 do {// rpk 10/8/2009} begin
                  add(TBCMA_PRNEffectList.create(FRPCBroker));
                  with TBCMA_PRNEffectList(FPRNEffectList[FPRNEffectList.count -
                    1]) do begin
                    rr := Resultlist[ii]; // 10/8/2009
                    FMedLogIEN := piece(rr, '^', 1);
                  //
                  // for clinic orders, expect clinic name in Patient Location?
                  //
                    FPatientLocation := piece(rr, '^', 3);
                    FAdminDateTime := copy(piece(rr, '^', 4) + '0000', 1, 12);
                    FAdministeredBy := piece(rr, '^', 5);
                    FAdministeredMed := piece(rr, '^', 6);
                    FPRNReason := piece(rr, '^', 7);
                    FOrderableItemIEN := piece(rr, '^', 8);
                    FOrderNumber := piece(rr, '^', 9);
                    FRequirePainScore := StrToIntDef(piece(rr, '^', 10), 0);

                    Inc(ii);            // rpk 10/8/2009
                    FSpecialInstructions := ResultList[ii]; // rpk 10/8/2009
                    if Copy(FSpecialInstructions, 1, 1) = '!' then
                      FSpecialInstructions := Copy(FSpecialInstructions, 2,
                        length(FSpecialInstructions) - 1);

                    Inc(ii);            // rpk 10/8/2009
                    while ii < resultscnt - 1 do {// rpk 10/8/2009} begin
                      rr := Resultlist[ii]; // rpk 10/8/2009

                      if rr = 'END' then begin
                        Inc(ii);        // rpk 10/8/2009
                        Break;
                      end
                      else if piece(rr, '^', 1) = 'DD' then
                        with FDispensedDrugs do
                          add(rr)
                      else if piece(rr, '^', 1) = 'ADD' then
                        with FAdditives do
                          add(rr)
                      else if piece(rr, '^', 1) = 'SOL' then
                        with FSolutions do
                          add(rr)
                    // Special Instructions / Other Print Info word processing text
                      else if piece(rr, U, 1) = 'SI' then begin // rpk 1/6/2012
                        FSIOPIList.Add(piece(rr, U, 2));
                      end
                      else
                        DefMessageDlg('Unknown Data Type received from PSB GETPRNS', mtError, [mbOK], 0);

                      Inc(ii);
                    end;
                    if FDispensedDrugs.Count = 1 then
                      FUnitsGiven := piece(FDispensedDrugs[0], '^', 3);
                    if (FAdditives.count > 0) or (FSolutions.count > 0) then
                      FUnitsGiven := 'N/A'
                  end;
                end;
              end;
            end;                        // results.count > 1
          end;                          // else results[0] <> -1

    frmMain.StatusBar.Panels[0].Text := '';
  finally
    ResultList.Free;
  end;
end;                                    // LoadPRNEffectiveness

procedure TBCMA_Patient.ClearPRNEffectiveness;
var
  ii: integer;
begin
  if FPRNEffectList <> nil then
    with FPRNEffectList do begin
      for ii := count - 1 downto 0 do
        TBCMA_PRNEffectList(items[ii]).free;
      clear;
    end;
end;

constructor TBCMA_MedOrder.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  FOrderedDrugs := TList.Create;

  FOrderedDrugIENs := TStringList.Create;
  FOrderedDrugNames := TStringList.Create;
  FOrderedDrugUnits := TStringList.Create;

  FUnitsGiven := TStringList.Create;

  FSolutions := TStringList.Create;
  FAdditives := TStringList.Create;
  FUniqueIDs := TStringList.Create;
  FSIOPIList := TStringList.Create;
  FLastFourActions := TStringList.Create;
  FOrderChangedData := TStringList.Create;
  FAdditionalComments := TStringList.Create;

  FPRNList := TStringList.create;
  FPRNList.Sorted := True;
//  FStatus := 0; // rpk 3/24/2011

  Clear;
end;

destructor TBCMA_MedOrder.Destroy;
begin
  //	SaveData;
  FOrderedDrugs.free;

  FOrderedDrugIENs.free;
  FOrderedDrugNames.free;
  FOrderedDrugUnits.free;

  FUnitsGiven.free;

  FSolutions.free;
  FAdditives.free;
  FUniqueIDs.Free;
  FSIOPIList.Free;

  FPRNList.free;
  FLastFourActions.free;
  FOrderChangedData.free;
  FAdditionalComments.free;

  FRPCBroker := nil;

  inherited Destroy;
end;

procedure TBCMA_MedOrder.Clear;
var
  ii: integer;
begin
  FPatientIEN := '';
  FMedLogIEN := '';
  FOrderableItemIEN := '';

  FScanStatus := '';
  FSelfMed := '';
  FScheduleType := '';

  FSchedule := '';

  FActiveMedication := '';
  FDosage := '';
  FRoute := '';

  FOrderNumber := '';
  FOrderIEN := '';
  FOrderType := '';

  FAdministrationTime := '';
  FTimeLastAction := '';
  FLastGivenDateTime := '';

  FInjectionSiteNeeded := False;
  FVariableDose := False;
  FWardStock := False;
  FDisplayInstructions := False;
  FUnknownMessageDisplayed := False;

  FAdministrationUnit := '';
  FLastActivityStatus := '';
  FSpecialInstructions := '';
  FVerifyNurse := '';
  FStartDateTime := '';
  FStopDateTime := '';
  FOrderStatus := '';
  FUniqueID := '';
  FAction := '';
  FNurseIEN := '';
  FOrderTransferred := '';

  with FOrderedDrugs do
    for ii := count - 1 downto 0 do
      TBCMA_DispensedDrug(items[ii]).free;

  FOrderedDrugs.clear;

  FOrderedDrugIENs.clear;
  FOrderedDrugNames.clear;
  FOrderedDrugUnits.clear;

  FUnitsGiven.Clear;

  FSolutions.clear;
  FAdditives.clear;
  FUniqueIDs.Clear;
  FPRNList.clear;
  FLastFourActions.Clear;
  FOrderChangedData.Clear;
  FAdditionalComments.Clear;
  FSIOPIList.Clear;                     // rpk 1/6/2012


  FReasonGivenPRN := '';
  FUserComments := '';
  FUserComments2 := '';
  FInjectionSite := '';
  FDermalSite := '';
  FBodySite := '';
  FLastSite := '';

  FStatus := -1;
  FStatusMessage := '';
  FValidOrder := False;
  FChanged := False;
  FOvrIntvent := False;                 // rpk 1/14/2011
  FInjOnPB := False;                    // rpk 3/27/2012
  FWitnessDUZ := '';                    // rpk 5/15/2012
  FWitnessName := '';                   // rpk 5/15/2012
  FWitnessFlag := '';                   // rpk 5/15/2012
  FClinicName := '';                    // rpk 2/27/2013
  FClinicIEN := '';                     // rpk 2/27/2013

end;                                    // Clear

procedure TBCMA_MedOrder.ClearAdminInfo;
begin
  ClearDispensedDrugsEnteredData;
  FUserComments := '';
  FUserComments2 := '';
  FAdditionalComments.Clear;
end;

// Called from the Missing dose request form only

function TBCMA_MedOrder.SelectOrderedDrugID(inList: TList): Integer; // rpk 12/13/2012
var
  ii: integer;
  icnt, idx: Integer;
  frmMultOrdDrugs: TfrmMultipleOrderedDrugs;
begin
  Result := -1;
  if inList = nil then
    Exit;

  icnt := 0;
  if (inList <> nil) and (FOrderIEN <> '') then begin // rpk 12/7/2012
    frmMultOrdDrugs := TfrmMultipleOrderedDrugs.create(application); // rpk 12/7/2012
    try                                 // rpk 12/7/2012
      with frmMultOrdDrugs do begin     // rpk 12/7/2012
        lbxSelectList.MultiSelect := True;
        lblSelectDrug.Caption := 'Please Select One or More Ordered Drug(s)!'; // rpk 11/8/2012
        lbxSelectList.Hint :=
          'To select more then one ordered drug, hold down the CTRL key while selecting the drugs';
        for ii := 0 to FOrderedDrugIENs.count - 1 do
                {JK 7/30/2008}
          lbxSelectList.items.addObject(
            FOrderedDrugNames[ii] + '  ' +
            FOrderedDrugUnits[ii], ptr(ii));

        ii := showModal;
        if ii <> mrCancel then
          for ii := 0 to lbxSelectList.Items.Count - 1 do
            if lbxSelectList.Selected[ii] then begin
              idx := Integer(lbxSelectList.Items.Objects[ii]);
              inList.Add(Ptr(idx));
              Inc(icnt);
            end;
      end;                              // with
    finally
      frmMultOrdDrugs.Release;          // rpk 6/18/2013
    end;

    Result := icnt;

  end;                                  // if

end;                                    // SelectOrderedDrugID


function TBCMA_MedOrder.CheckNonNurseVfy: ChkNurseVfyReturnValues;
var
  msg: string;
  boolval: Boolean;
  WitnessStr: string;
begin
  Result := cnvNotCalled;
  boolval := False;
  WitnessStr := '';

  // if called by take action on bag or take action on ws, suppress non-nurse
  // verify checks by setting state to give.
  if (frmMain.WorkFlowType = WF_TakeActionOnBag) or
    (frmMain.WorkFlowType = WF_TakeActionOnWS) then begin // rpk 4/6/2011
    NurseVfyState := cnvGive;
    Result := NurseVfyState;
  end
  else if NurseVfyState <> cnvNotCalled then // rpk 2/28/2011
    // CheckNonNurseVfy has already been called during the current action
    // Continue to return the original response to subsequent calls during the same
    // action.
    Result := NurseVfyState             // rpk 3/18/2011
  else begin                            // rpk 2/28/2011
    if (FAction = '') or
      (FAction = 'G') or                // give
      (FAction = 'I') or                // infuse
      (FAction = 'H') or                // hold
      (FAction = 'R') or                // refuse
      (FAction = 'M') then begin        // missing dose

      if FVerifyNurse = '***' then begin

        case BCMA_SiteParameters.NonNurseVfyLvl of
          ord(nvNoWarning):
            boolval := True;

          ord(nvWarning): begin
              msg := 'Order NOT Nurse-Verified. ' + #13 +
                'Do you want to continue?';
              boolval := (DefMessageDlg(msg, mtWarning, [mbOK, mbCancel], 0)
                = idOK);
            end;                        // with Warning

          ord(nvProhibit): begin
              if (FAction = 'H') or
                (FAction = 'R') then begin
                msg := 'Order NOT Nurse-Verified. ' + #13 +
                  'Do you want to continue?';
                boolval := (DefMessageDlg(msg, mtWarning, [mbOK, mbCancel], 0)
                  = idOK);
              end
              else if (FAction = 'M') then begin
                msg := 'Order NOT Nurse-Verified. ' + #13 +
                  'Action unavailable until verified.';
                DefMessageDlg(msg, mtError, [mbOK], 0); // rpk 6/15/2011
                boolval := False;
              end
              else begin
                msg := 'Order NOT Nurse-Verified. ' + #13 +
                  'DO NOT GIVE!';
                DefMessageDlg(msg, mtError, [mbOK], 0);
                boolval := False;
              end;
            end;                        // Prohibit

        else
          boolval := False;

        end;                            // case NonNurseVfyLvl

      end
      else                              // Nurse did verify order
        boolval := True;

      if boolval then
        Result := cnvGive
      else
        Result := cnvDoNotGive;

    end;                                // if action

    NurseVfyState := Result;            // rpk 3/22/2011
  end;                                  // else check Action

  if Result = cnvDoNotGive then begin
    if FStatus <> -1 then begin
      FStatus := -1;                    // do not give
      if FStatusMessage > '' then
        FStatusMessage := '';
    end;
  end;

end;                                    // CheckNonNurseVfy

function TBCMA_MedOrder.DisplaySIOPI(CancelOn: Boolean): Boolean;
var
  mtval: memoTypes;
  mres: Integer;
  titlestr: string;
begin
  if OrderType = 'V' then               // IV, IVP, IVPB
    mtval := mtOtherInfo
  else
    mtval := mtSpecialInstructions;

  titlestr := memoTypeTitles[mtval];
  mres := DisplayMemoList(titlestr, SpecialInstructions, SIOPIList, CancelOn);
  Result := (mres = mrOK);
end;

function TBCMA_MedOrder.GetSIOPIText: string; // rpk 1/4/2012
begin
  if SIOPIList.Text > '' then
    Result := SIOPIList.Text
  else
    // otherwise, use the original string field.
    Result := SpecialInstructions;
end;


procedure TBCMA_Medorder.SetSIOPIMemo(memo: TMemo);
begin
  // if unlimited string list is non-empty, use it.
  if SIOPIList.Text > '' then
    memo.Lines.Assign(SIOPIList)
  else
    // otherwise, use the original string field.
    memo.Text := SpecialInstructions;

  memo.SelStart := 0;                   // rpk 3/16/2012
end;

function TBCMA_MedOrder.getValidOrder: boolean;
var
  ii: integer;
  CurrentScanStatus: string;
  InfoMsg,
    TempStr: string;
  IVBagID: string;
  ActionTime: string;

// Insert CR-LF in-between lines so that last line does not end with a CR-LF.
// This is needed for combined message (positive status followed by negative status)
// to avoid a dangling quote mark in the message dialog.
// Using the same process for all status message appends.
  procedure AppendStatusMsg(instr: string);
  begin
    if instr > '' then begin
      if FStatusMessage > '' then
        FStatusMessage := FStatusMessage + #13#10 + instr
      else
        FStatusMessage := instr;
    end;
  end;

begin
  {   Possible results for FStatus:
      -10 - User cancelled following unknown status message in CheckForUnknowns,
          take no further action
      -3 - stop, suppress "Could NOT validate this order" message
      -2 - Force refresh, either orderstatus or scanstatus out of sync
      -1 - Stop
      0 - ok
      1 - Confirmation (variance)
      2 - display message before proceeding
      3 - last four PRN administrations
      4 - last given date time
      5 - highlight message in red
  }

{ $IFDEF CAS_DDPE_RST}
// for v. 3.0.83.21 we
{ $ELSE}
// checking old-style patches only
  if FValidOrder and (lstCurrentTab <> ctIV) and (AdministrationUnit = 'PATCH')
    then begin
    result := FValidOrder;
    exit;
  end;
{ $ENDIF}

  // Crash: In Wardstock mode, fWardstock is False (???), CurrentBagID is nil

  IVBagID := '';
  if (lstCurrentTab = ctIV) and (fWardStock = false) then begin
    if CurrentBagID = nil then begin    // rpk 10/25/2010
      result := False;
      Exit;
    end
    else begin
      CurrentScanStatus := TBCMA_IVBags(CurrentBagID).FScanStatus;
      IVBagID := TBCMA_IVBags(CurrentBagID).UniqueID;
    end;
  end
  else
    CurrentScanstatus := FScanStatus;

  if (lstCurrentTab = ctIV) then begin
    if (IVBagID <> '') and (IVBagID <> ScannedInput) then // debug test breakpoint
      IVBagID := ScannedInput;
    if (IVBagID = '') then
      IVBagID := ScannedInput;
  end;

  FStatusMessage := '';
  FLastFourActions.Clear;
  FStatus := -1;                        // rpk 4/1/2011

{$IFDEF CAS_DDPE_RST}                   // v.3.0.83.21 // aan - 20150708
  if Action = 'RM' then
    ActionTime := RemovalDateTime
  else
    ActionTime := '';
{$ENDIF}
  with FRPCBroker do
    if CallServer('PSB VALIDATE ORDER', [FPatientIEN, FOrderIEN, FOrderType,
      FAdministrationTime,
        lstUnitDoseCurrentTab[lstCurrentTab], ScannedInput, CurrentScanStatus,
        FOrderStatus, FAction
{$IFDEF CAS_DDPE_RST}
      , ActionTime                      // as of v.3.0.83.21 this parameter is not blank for REMOVAL only
{$ENDIF}
      ], nil) then begin
      TempStr := piece(Results[1], '^', 1);
      if Results.Count - 1 <> StrToInt(Results[0]) then
        DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
      // -2 - Force refresh, either orderstatus or scanstatus out of sync
      // -1 - Stop
      else if (TempStr = '-2') or (TempStr = '-1') then begin
        FStatus := strToInt(piece(Results[1], '^', 1));
        FStatusMessage := piece(Results[1], '^', 2);
      end
      else begin
        for ii := 1 to results.count - 1 do
          if piece(results[ii], '^', 1) = '0' then begin // 0 - ok
            if FStatus <> 1 then
              FStatus := 0;
          end                           // 0
          else if piece(results[ii], '^', 1) = '1' then begin // 1 - confirmation, variance
            FStatus := 1;
            tempstr := piece(results[ii], '^', 2);
            // avoid adding CR-LF to blank line
            { if tempstr > '' then
              FStatusMessage := FStatusMessage + tempstr;
            if FStatusMessage > '' then
              FStatusMessage := FStatusMessage + #13#10; }
            { if tempstr > '' then begin
               if FStatusMessage > '' then
                  FStatusMessage := FStatusMessage + #13#10 + tempstr
               else
                  FStatusMessage := tempstr;
            end; }
            if tempstr > '' then
              AppendStatusMsg(tempstr);
          end                           // 1
          else if piece(results[ii], '^', 1) = '2' then begin // 2 - display message before proceeding
            if FStatus <> 1 then
              FStatus := 0;
            // avoid adding CR-LF to blank line
            tempstr := piece(results[ii], '^', 2);
            if tempstr > '' then
              InfoMsg := InfoMsg + tempstr;
            if InfoMsg > '' then
              InfoMsg := InfoMsg + #13#10;
          end                           // 2
          else if piece(results[ii], '^', 1) = '3' then begin // 3 - last four PRN administrations
            FStatus := 1;
            FLastFourActions.Add(Pieces(results[ii], '^', 2, 8));
          end                           // 3
          // redundant? already checking for 0 near the top of the loop
          { else if piece(results[ii], '^', 1) = '0' then begin  // 0 - success? restored from bcma_msf
            if FStatus <> 1 then
              FStatus := 0;
          end }
          else if piece(results[ii], '^', 1) = '4' then begin // 4 - last given date time
            FLastGivenDateTime := piece(Results[ii], '^', 2);
          end                           // 4
          // 5 means highlight status message in red; rpk 5/2016
          else if piece(results[ii], '^', 1) = '5' then begin
            FStatus := strToInt(piece(Results[ii], '^', 1));
//            FStatusMessage := piece(Results[ii], '^', 2);
            tempstr := piece(results[ii], '^', 2);
            // avoid adding CR-LF to blank line
            { if tempstr > '' then
              FStatusMessage := FStatusMessage + tempstr;
            if FStatusMessage > '' then
              FStatusMessage := FStatusMessage + #13#10; }
            if tempstr > '' then
              AppendStatusMsg(tempstr);
//            break;
          end                           // 5
          // rpk 5/23/2016
          // -1 : Stop; Do Not Give; expect this at the end of Results
          // set status to -3 - stop, suppress "Could NOT validate this order" message
          // this may occur in a combination set of results with a 1 in the first
          // line followed by a -1 in the second line as part of a scenario
          // where the user is given additional information before a hard stop
          // e.g. dose would be given early, however, there is already an MRR
          // on the patient, do not give
          // negative error codes leave loop immediately with a break
          else if piece(results[ii], '^', 1) = '-1' then begin
//            FStatus := strToInt(piece(Results[ii], '^', 1));
            FStatus := -3;              // stop, suppress "Could NOT validate this order" message
            tempstr := piece(results[ii], '^', 2);
            // avoid adding CR-LF to blank line
            { if tempstr > '' then
              FStatusMessage := FStatusMessage + tempstr;
            if FStatusMessage > '' then
              FStatusMessage := FStatusMessage + #13#10; }
            if tempstr > '' then
              AppendStatusMsg(tempstr);
            break;
          end                           // -1 : Stop; Do Not Give
          // checking each result ii > 0 which may also have a -2
          // -2 - Force refresh, either orderstatus or scanstatus out of sync
          else if piece(results[ii], '^', 1) = '-2' then begin
            FStatus := strToInt(piece(Results[ii], '^', 1));
            FStatusMessage := piece(Results[ii], '^', 2);
            break;
          end                           // additional lines with -2
          // moved this section of positive codes up above the negative code group
          { else if piece(results[ii], '^', 1) = '4' then begin  // 4 - last given date time
            FLastGivenDateTime := piece(Results[ii], '^', 2);
          end                           // 4
          // 5 means highlight status message in red
          else if piece(results[ii], '^', 1) = '5' then begin
            FStatus := strToInt(piece(Results[ii], '^', 1));
//            FStatusMessage := piece(Results[ii], '^', 2);
            tempstr := piece(results[ii], '^', 2);
            // avoid adding CR-LF to blank line
            if tempstr > '' then
              FStatusMessage := FStatusMessage + tempstr;
            if FStatusMessage > '' then
              FStatusMessage := FStatusMessage + #13#10;
//            break;
          end }// 5
          else begin
            FStatus := -1;
            FStatusMessage := 'Unknown status received in PSB VALIDATE ORDER';
            break;
          end;
      end;

      FValidOrder := (FStatus > -1);

      if FValidOrder and not UnknownMessageDisplayed then
        if CheckForUnknowns(Self) then begin
          FStatus := -10;
          FValidOrder := False;
          FStatusMessage := '';
        end;

      {in theory, if this is the first time thru here on this order,
      this should be false.  If we have already been thru here, for this IV order, don't
      display any messages during the second pass.  You'll notice for a UD or
      PB order, if we bail out right away if we already validated this order}

      if (lstCurrentTab = ctIV) and (fWardStock = false) and
        (TBCMA_IVBags(CurrentBagID) <> nil) and
        (infoMsg <> '') and (TBCMA_IVBags(CurrentBagID).FDisplayedMessage =
        False) then begin
        DefMessageDlg(InfoMsg, mtWarning, [mbOK], 0);
        TBCMA_IVBags(CurrentBagID).FDisplayedMessage := True;
      end;
    end;

  // If CheckNonNurseVfy has been called, clear the action;
  // Previously, it was always cleared.
  if NurseVfyState <> cnvNotCalled then // rpk 4/6/2011
    FAction := '';

  result := FValidOrder;
end;                                    // getValidOrder

function TBCMA_MedOrder.getPRNList: TstringList;
var
  ii: integer;
begin
  with FRPCBroker do
    if CallServer('PSB GETPRNS', [FPatientIEN, FOrderNumber], nil) then
      if piece(results[0], '^', 1) = '-1' then
        DefMessageDlg(piece(results[0], '^', 2), mtError, [mbOK], 0)
      else begin
        FPRNList.clear;
        with FPRNList do
          for ii := 1 to strToInt(results[0]) do
            add(
              piece(results[ii], '^', 1) + '^' +
              piece(results[ii], '^', 2) + '^' +
              piece(results[ii], '^', 3) + '^' +
              piece(results[ii], '^', 4) + '^' +
              piece(results[ii], '^', 5) + '^' +
              piece(results[ii], '^', 6) + '^' +
              piece(results[ii], '^', 8)
              );
      end;

  result := FPRNList;
end;

function TBCMA_MedOrder.getOrderedDrugs(index: integer): TBCMA_DispensedDrug;
begin
  if (index > -1) and (index < FOrderedDrugs.count) then
    result := FOrderedDrugs.items[index]
  else
    result := nil;
end;

function TBCMA_MedOrder.indexOf(value: string): integer;
var
  ii: integer;
begin
  result := -1;
  for ii := 0 to FOrderedDrugIENs.count - 1 do
    if FOrderedDrugIENs[ii] = value then begin
      result := ii;
      break;
    end;
end;

function TBCMA_MedOrder.OrderedDrugCount: integer;
begin
  result := FOrderedDrugs.count;
end;

function TBCMA_MedOrder.SolutionCount: integer;
begin
  result := FSolutions.count;
end;

function TBCMA_MedOrder.AdditiveCount: integer;
begin
  result := FAdditives.count;
end;

function TBCMA_MedOrder.UniqueIDCount: integer;
begin
  Result := FUniqueIDs.Count;
end;

procedure TBCMA_MedOrder.FillMultList(MultList: TStringlist; newStatus: string;
  IVBag: TBCMA_IVBags);
var
  DDrg,
    QtyScannedText2,
    AdminUnit: string;
  ii: integer;
begin
  with MultList do begin
    Clear;                              // rpk 9/23/2010
    add(FPatientIEN);
    add(FOrderNumber + U + FClinicName); // rpk 7/9/2012
    add(FScheduleType);
    add(newStatus);
    add(FOrderableItemIEN);

    // revert to original code; rpk 10/16/2012
    add(FAdministrationTime);
    add(FReasonGivenPRN);               //ReasonGivenPRN
    add(StripString(FUserComments));    //UserComments

    if ((newStatus = 'G') and (RemovalStatus <> '') and (RemovalStatus <> '0'))
      then begin
      FDermalSite := SelectFromDermalList(Self, 'Dermal Site Needed!',
        BCMA_SiteParameters.ListBodySites);
      if FDermalSite = '' then
        Exit;
      FBodySite := FDermalSite;
    end
    else if (lstCurrentTab <> ctIV) or (WardStock = True) then begin
      if ((newStatus = 'G') or ((newStatus = 'I') and (FWardStock = True))) and
        FInjectionSiteNeeded then begin
        if ((lstCurrentTab = ctUD) or
          ((lstCurrentTab = ctPB) and FInjOnPb)) then // rpk 2/15/2012
          FInjectionSite := SelectFromInjectionList(Self,
            'Injection Site Needed!',
            BCMA_SiteParameters.ListBodySites)
        else
          FInjectionSite := SelectFromList('Injection Site Needed!',
            BCMA_SiteParameters.ListBodySites);
        if FInjectionSite = '' then
          Exit;
        FBodySite := FInjectionSite;
      end;                              // if ( (newstatus = G) or ((newstatus = I) and WardStock)) and InjectionSiteNeeded
    end;

    // use pipe delimiter | and flag to identify type of site;
    // D: Dermal; I: Injection
    // List(8)
    if FDermalSite > '' then            // rpk 10/16/2015
      add(FDermalSite + '|D')           // rpk 10/16/2015
    else if FInjectionSite > '' then    // rpk 10/16/2015
      add(FInjectionSite + '|I')        // rpk 10/16/2015
    else
      add('');

    if (FWardStock <> True) and (OrderTypeID = otIV) then begin
      if IVBag <> nil then begin
        // use UniqueID instead?
        if ScannedInput = IVBag.UniqueID then
          Add(lstUnitDoseCurrentTab[lstCurrentTab] + '^' + ScannedInput)
        else                            // debug test for breakpoint
          Add(lstUnitDoseCurrentTab[lstCurrentTab] + '^' + IVBag.UniqueID) // rpk 10/27/2010
      end
      else
        Add(lstUnitDoseCurrentTab[lstCurrentTab] + '^' + ScannedInput);
    end
    else
      Add(lstUnitDoseCurrentTab[lstCurrentTab] + '^');

    add(RemovalDateTime);               // aan 20150619 v.3.0.83.17

    case OrderTypeID of
      otUnitDose: begin
          for ii := 0 to OrderedDrugCount - 1 do begin
            if OrderedDrugs[ii].QtyScanned >
              strToFloat(OrderedDrugs[ii].QtyOrderedText) then
              QtyScannedText2 := OrderedDrugs[ii].QtyOrderedText
            else if (pos('.', OrderedDrugs[ii].QtyOrderedText) <> 0) then
              QtyScannedText2 := OrderedDrugs[ii].QtyScannedText
            else
              QtyScannedText2 := intToStr(OrderedDrugs[ii].QtyScanned);

            if OrderedDrugs[ii].QtyEntered <> '' then
              AdminUnit := OrderedDrugs[ii].QtyEntered
            else
              AdminUnit := FAdministrationUnit;

            DDrg := 'DD^' + OrderedDrugs[ii].IEN + '^' +
              OrderedDrugs[ii].QtyOrderedText + '^' +
              QtyScannedText2 + '^' +
              AdminUnit + U + U +
              OrderedDrugs[ii].FWitnessCode //; // piece 7; rpk 10/17/2012
{$IFDEF CAS_DDPE_RST}
            + U + RemovalStatus         // aan 20150619 v.3.0.83.16
{$ENDIF}
            ;
            add(DDrg);

          end;
        end;

      otIV:
        case lstCurrentTab of
          ctIV: begin
              if IVBag <> nil then begin // rpk 10/16/2012
                for ii := 0 to IVBag.FSolutions.count - 1 do begin
                  add(IVBag.FSolutions[ii]);
                end;

                for ii := 0 to IVBag.FAdditives.count - 1 do begin
                  add(IVBag.FAdditives[ii]);
                end;
              end;
            end;
          ctPB: begin
              for ii := 0 to FAdditives.Count - 1 do
                Add(FAdditives[ii]);
              for ii := 0 to FSolutions.Count - 1 do
                Add(FSolutions[ii]);
            end;
        end;
      otPending: begin
        end;

    end;
  end;
end;                                    // FillMultList

function TBCMA_MedOrder.LogOrder(MedLogType: TMedLogTypes; newStatus: string;
  IVBag: TBCMA_IVBags): Boolean;
var
  MultList: TStringlist;
  ResultErrTxt: string;
  ii: integer;
  cmdString,
    zMedLogIEN,
    DDrg,
    QtyScannedText2,
    AdminUnit: string;
  OKToContinue: Boolean;
  bodystr: string;
begin
  //possible return values from PSB TRANSACTION CALL:
  //1 - Filed successfully
  //-1 - Error condition and message
  Result := False;
  MultList := nil;                      // rpk 9/23/2010
  OKToContinue := True;                 // rpk 6/15/2012
  if BodySite > '' then begin
    bodystr := BodySite;                // trace
    BodySite := '';
  end;


  if BCMA_Broker.Connected = False then
    Exit;

  case lstCurrentTab of
    ctIV:
      if IVBag = nil then
        exit
      else
        zMedLogIEN := IVBag.FMedLogIEN;
    {JK - There is a bag number and chronology associated with the IV tab}
    ctPB, ctUD:
      zMedLogIEN := FMedLogIEN;
  end;

  if (FOrderType = 'V') or
    (MedLogType = mtAddComment) or (FValidOrder) or
    (FOrderStatus = 'H') or (newStatus = 'N') or (newStatus = 'RM') then begin
    MultList := TStringlist.create;
    try                                 // rpk 2/23/2012
      with MultList do
        case MedLogType of
          mtMedPass: begin
              if zMedLogIEN = '' then begin
                cmdString := '+1^MEDPASS';
                FillMultList(MultList, newStatus, IVBag);
                if (newStatus = 'G') or ((newStatus = 'I') and (FWardStock =
                  True)) then begin
                  if isMRR then begin   // rpk 3/7/2016
                    if (FDermalSite = '') then begin
                      Result := False;  {JK 9/17/2008}
                      OKToContinue := False; // rpk 6/15/2012
                      Exit;
                    end;
                    if FInjectionSiteNeeded then begin
                      if useDebugLog then
                        WriteLogMessageProc('MRR and InjectionSiteNeeded are both set to True.  InjectionSiteNeeded is set to False. (zmedlogien empty)', nil);
                      FInjectionSiteNeeded := False;
                    end;
                  end                   // isMRR
                  else begin
                    if FInjectionSiteNeeded and (FInjectionSite = '') then begin
                      Result := False;  {JK 9/17/2008}
                      OKToContinue := False; // rpk 6/15/2012
                      Exit;
                    end;
                  end;
                end;
              end                       //  if zMedLogIEN = ''
              // else zMedLogIEN <> ''
              else if newStatus = 'N' then begin // undo
                cmdString := zMedLogIEN + '^UPDATE STATUS';
                Add(newStatus);
                Add('');
              end
              else if newStatus = 'RM' then begin // remove
                cmdString := zMedLogIEN + '^UPDATE STATUS';
                Add(newStatus);
                Add(StripString(FUserComments));
              end
              else begin
                cmdString := zMedLogIEN + '^UPDATE STATUS';
                add(newStatus);
                add(StripString(FUserComments));

                if ((newStatus = 'G') and (RemovalStatus <> '') and
                  (RemovalStatus <> '0')) then begin
                  FDermalSite := SelectFromDermalList(Self,
                    'Dermal Site Needed!',
                    BCMA_SiteParameters.ListBodySites);
                  if isMRR then begin   // rpk 3/7/2016
                    if (FDermalSite = '') then
                      Exit;
                    if FInjectionSiteNeeded then begin
                      if useDebugLog then
                        WriteLogMessageProc('MRR and InjectionSiteNeeded are both set to True.  InjectionSiteNeeded is set to False. (zmedlogien filled)', nil);
                      FInjectionSiteNeeded := False;
                    end;
                  end;                  // isMRR
                  FBodySite := FDermalSite;
                end
                else if (FInjectionSiteNeeded and (FInjectionSite = '')) and
                  ((newStatus <> 'H') and (newStatus <> 'R') and (newStatus <>
                  'M')) then begin
                  if ((lstCurrentTab = ctUD) or
                    ((lstCurrentTab = ctPB) and FInjOnPb)) then // rpk 2/15/2012
                    FInjectionSite := SelectFromInjectionList(Self,
                      'Injection Site Needed!',
                      BCMA_SiteParameters.ListBodySites)
                  else
                    FInjectionSite := SelectFromList('Injection Site Needed!',
                      BCMA_SiteParameters.ListBodySites);
                  // on injection site cancel, exit LogOrder
                  if (FInjectionSiteNeeded and (FInjectionSite = '')) then
                    exit;
                  FBodySite := FInjectionSite;
                end;

                if IVBag <> nil then begin
                  if FInjectionSite > '' then // rpk 11/17/2015
                    add(FInjectionSite + '|I') // rpk 11/17/2015    List(2)
                  else
                    add('');
                  if WardStock <> True then //bjr 10/20/10 for BCMA00000571
                    add(IVBag.UniqueID) //  rpk 10/27/2010
                  else                  //bjr 10/20/10 for BCMA00000571
                    add('');            //bjr 10/20/10 for BCMA00000571
                end
                else begin              // IVBag is nil
                  if FDermalSite > '' then // rpk 10/16/2015
                    add(FDermalSite + '|D') // rpk 10/16/2015
                  else if FInjectionSite > '' then // rpk 10/16/2015
                    add(FInjectionSite + '|I') // rpk 10/16/2015
                  else
                    add('');
                  if (OrderTypeID = otIV) and
                    (WardStock <> True) and
                    (newStatus = 'G') then
                    add(ScannedInput)
                  else
                    add('');
                end;                    // else IVBag = nil

                case OrderTypeID of
                  otUnitDose: begin
                      for ii := 0 to OrderedDrugCount - 1 do begin
                        if OrderedDrugs[ii].QtyScanned >
                          strToFloat(OrderedDrugs[ii].QtyOrderedText) then
                          QtyScannedText2 := OrderedDrugs[ii].QtyOrderedText
                        else if (pos('.', OrderedDrugs[ii].QtyOrderedText) <> 0)
                          then
                          QtyScannedText2 := OrderedDrugs[ii].QtyScannedText
                        else
                          QtyScannedText2 :=
                            intToStr(OrderedDrugs[ii].QtyScanned);

                        if OrderedDrugs[ii].QtyEntered <> '' then
                          AdminUnit := OrderedDrugs[ii].QtyEntered
                        else
                          AdminUnit := FAdministrationUnit;

                        DDrg := 'DD^' + OrderedDrugs[ii].IEN + '^' +
                          OrderedDrugs[ii].QtyOrderedText + '^' +
                          QtyScannedText2 + '^' +
                          AdminUnit + U + U +
                          OrderedDrugs[ii].FWitnessCode {;} // piece 7; rpk 10/17/2012
                          + U + RemovalStatus; // v.3.0.83.15 aan 20150619
                        add(DDrg);
                      end;              // for
                    end;                // otUnitDose

                  otIV: begin
                    // added newStatus = 'I'  rpk 2/10/2011
                      if ((newStatus = 'G') or (newStatus = 'I')) and
                        (IVBag <> nil) then
                      {//bjr 5/12/10 for BCMA00000425, modified 8/3/10}begin
                        for ii := 0 to IVBag.FAdditives.count - 1 do
                          add(IVBag.FAdditives[ii]);
                        for ii := 0 to IVBag.FSolutions.count - 1 do
                          add(IVBag.FSolutions[ii]);
                      end;              // if
                    end;                // otIV
                end;                    // with MultList / case OrderTypeID

              end;                      // else newStatus not N or RM  and zMedLogIEN <> ''

              // check for Witness Required
              if OKToContinue and (WitnessFlag = WITNESS_REQUIRED) then begin
                if (newStatus = 'G') or (newStatus = 'I') then begin
                  if not GetWitness(Self) then
                    OKToContinue := False;
                end;                    // Give or Infuse
              end;

              // check for Witness Recommended
              if OKToContinue and (WitnessFlag = WITNESS_RECOMMENDED) then begin
                if (newStatus = 'G') or (newStatus = 'I') then begin
                  if not GetWitness(Self) then
                    OKToContinue := False;
                end;                    // Give or Infuse
              end;

              if OKToContinue then begin
                with BCMA_Broker do begin
                  if CallServer('PSB TRANSACTION', [cmdString + U +
                    BCMA_User.InstructorDUZ + U + WitnessDUZ + U +
                      WitnessComment + U + WitnessFlag], MultList) then // rpk 10/16/2012
                    if (Results.Count = 0) or (Results.Count - 1 <>
                      StrToIntDef(Results[0], -1)) then
                      DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
                    else if piece(Results[1], '^', 1) = '-1' then begin
                      ResultErrTxt := piece(results[1], '^', 2) + #13;
                      for ii := 2 to Results.Count - 1 do
                        ResultErrTxt := ResultErrTxt + Results[ii] + #13;
                      DefMessageDlg(ResultErrTxt, mtError, [mbOK], 0);
                    end
                    else if piece(results[1], '^', 1) = '1' then begin
                      FScanStatus := newStatus;
                      FNurseIEN := BCMA_User.DUZ;
                      if (lstCurrentTab = ctPB) and (OrderTypeID <> otUnitDose)
                        then
                        FUniqueID := ScannedInput;
                      if piece(cmdString, '^', 1) = '+1' then
                        FMedLogIEN := piece(results[1], '^', 3);
                      Result := True;
                      LogComments(FMedLogIEN, FAdditionalComments);
                    end
                    else if piece(results[1], '^', 1) = '-2' then begin
                      ForceRefresh := True;
                      ResultErrTxt := piece(results[1], '^', 2) + #13;
                      for ii := 2 to Results.Count - 1 do
                        ResultErrTxt := ResultErrTxt + Results[ii] + #13;
                      DefMessageDlg(ResultErrTxt, mtError, [mbOK], 0);
                    end
                    else begin
                      ResultErrTxt := piece(results[1], '^', 2) + #13;
                      for ii := 2 to Results.Count - 1 do
                        ResultErrTxt := ResultErrTxt + Results[ii] + #13;
                      DefMessageDlg(ResultErrTxt, mtError, [mbOK], 0);
                    end;
                end;                    // with BCMA_Broker
              end;                      // if OKToContinue
            end;                        // case mtMedPass

          mtAddComment:
            if zMedLogIEN <> '' then begin
              cmdString := zMedLogIEN + '^ADD COMMENT';
              add(StripString(FUserComments));

              with BCMA_Broker do
                if CallServer('PSB TRANSACTION', [cmdString + '^' +
                  BCMA_User.InstructorDUZ], MultList) then
                  if piece(results[0], '^', 1) <> '1' then begin
                    ResultErrTxt := piece(results[0], '^', 2) + #13;
                    for ii := 1 to Results.Count - 1 do
                      ResultErrTxt := ResultErrTxt + Results[ii] + #13;
                    DefMessageDlg(ResultErrTxt, mtError, [mbOK], 0);
                  end
                  else
                    Result := True;
            end;
        end;                            // with MultiList, case MedLogType
    finally
      MultList.free;                    // rpk 9/23/2010
    end;

    if OKToContinue then begin          // rpk 10/1/2012
      if (uppercase(ScheduleType) = 'P') then begin
        frmMain.pnlMainForm.Repaint;
        BCMA_Patient.LoadPRNEffectiveness('');

        if frmmain.lvwReminders.Items[0] = nil then begin //JK 2/7/2008
          frmMain.lvwReminders.AddItem(IntToStr(BCMA_Patient.PRNEffectList.Count),
            nil);
          frmMain.lvwReminders.Items[0].SubItems.Add('PRN Effectiveness');
          // rpk 7/22/2009
        end
        else begin
          frmmain.lvwReminders.Items[0].Caption :=
            IntToStr(BCMA_Patient.PRNEffectList.Count);
          frmMain.lvwReminders.Items[0].SubItems[0] := 'PRN Effectiveness';
          // rpk 7/22/2009
        end;

        frmmain.lvwReminders.Repaint;
      end;                              // if PRN
    end;
  end;
end;                                    // LogOrder

procedure TBCMA_MedOrder.setOrderNumber(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FOrderNumber then begin
      FOrderNumber := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setOrderType(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FOrderType then begin
      FOrderType := newValue;
      FChanged := True;
    end;
end;

function TBCMA_MedOrder.getOrderTypeID: TOrderTypes;
var
  id: TOrderTypes;
begin
  result := otNone;
  if (FRPCBroker <> nil) then
    for id := low(OrderTypeCodes) to high(OrderTypeCodes) do
      if OrderTypeCodes[id] = FOrderType then begin
        result := id;
        break;
      end;
end;

procedure TBCMA_MedOrder.setMedLogIEN(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FMedLogIEN then begin
      FMedLogIEN := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setOrderableItemIEN(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FOrderableItemIEN then begin
      FOrderableItemIEN := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setScanStatus(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FScanStatus then begin
      FScanStatus := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setSelfMed(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FSelfMed then begin
      FSelfMed := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setScheduleType(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FScheduleType then begin
      FScheduleType := newValue;
      FChanged := True;
    end;
end;

function TBCMA_MedOrder.getScheduleTypeID: TScheduleTypes;
var
  id: TScheduleTypes;
begin
  Result := stNone;                     // rpk 4/6/2009

  if FRPCBroker <> nil then
    for id := low(ScheduleTypeCodes) to high(ScheduleTypeCodes) do
      if ScheduleTypeCodes[id] = FScheduleType then begin
        result := id;
        break;
      end;
end;

procedure TBCMA_MedOrder.setSchedule(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FSchedule then begin
      FSchedule := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setActiveMedication(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FActiveMedication then begin
      FActiveMedication := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setDosage(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FDosage then begin
      FDosage := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setRoute(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FRoute then begin
      FRoute := newValue;
      FChanged := True;
    end;
end;

{$IFDEF CAS_DDPE_RST}

procedure TBCMA_MedOrder.setRemovalStatus(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FRemovalStatus then begin
      FRemovalStatus := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setRemovalDateTime(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FRemovalDateTime then begin
      FRemovalDateTime := newValue;
      FChanged := True;
    end;
end;

function TBCMA_MedOrder.getTextNextActionTime: string;
begin
  if ((RemovalStatus <> '') and (RemovalStatus <> '0')) then // MRR
  begin
    if (ScanStatus = 'G') then
      Result := DisplayVADate(RemovalDateTime)
    else
      Result := DisplayVADate(AdministrationTime);
  end
  else
    Result := DisplayVADate(AdministrationTime);
end;

// use for debugging times > 1 year

function TBCMA_MedOrder.getTextNextActionYearDateTime: string;
var
  latemins, yearmins: TDateTime;
  datestr: string;
begin
  Result := '';
  yearmins := 365.0 * 24. * 60.;

  if ((RemovalStatus <> '') and (RemovalStatus <> '0')) then // MRR
  begin
    if (ScanStatus = 'G') then
      datestr := RemovalDateTime
    else
      datestr := AdministrationTime;
  end
  else
    datestr := AdministrationTime;

  latemins := DateTimeLate(self);
  if Abs(LateMins) < yearmins then
    Result := DisplayVADate(datestr)
  else
    Result := DisplayVADateYearTime(datestr);
end;                                    // getTextNextActionYearDateTime

function TBCMA_MedOrder.getNextActionFMTime: string;
begin
  if ((RemovalStatus <> '') and (RemovalStatus <> '0')) then // MRR
  begin
    if (ScanStatus = 'G') then
      Result := RemovalDateTime
    else
      Result := AdministrationTime;
  end
  else
    Result := AdministrationTime;
end;

function TBCMA_MedOrder.getRemovalIsAllowed: Boolean;
begin
  Result := ((AdministrationUnit = 'PATCH') and (ScanStatus = 'G'))
    or                                  // v. 3.0.83.17
    ((RemovalStatus <> '') and (RemovalStatus <> '0') and (ScanStatus = 'G'))
    ;
end;

function TBCMA_MedOrder.getUndoIsAllowed: Boolean;
begin
  Result :=                             // v. 3.0.83.17
    ((RemovalStatus <> '') and (RemovalStatus <> '0') and (ScanStatus = 'RM'))
    ;
end;

function TBCMA_MedOrder.getRemovalDueTime: TDateTime;
var
  dt: TDateTime;
begin
  Result := -1;
  if IsFMDateTime(RemovalDateTime) then
  begin
    dt := MakeFMDateTime(RemovalDateTime);
    Result := FMDateTimeToDateTime(dt);
  end;
end;

function TBCMA_MedOrder.isMRR: Boolean;
begin
  Result := ((RemovalStatus <> '') and (RemovalStatus <> '0'));
end;


{$ENDIF}

procedure TBCMA_MedOrder.setAdministrationTime(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FAdministrationTime then begin
      FAdministrationTime := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setTimeLastAction(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FTimeLastAction then begin
      FTimeLastAction := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setLastActivityStatus(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FLastActivityStatus then begin
      FLastActivityStatus := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setStartDateTime(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FStartDateTime then begin
      FStartDateTime := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setOrderStatus(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FOrderStatus then begin
      FOrderStatus := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setVerifyNurse(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FVerifyNurse then begin
      FVerifyNurse := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setSpecialInstructions(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FSpecialInstructions then begin
      FSpecialInstructions := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setSIOPIList(newValue: TStringList); // rpk 11/09/2011
begin
//  if FRPCBroker <> nil then
  if (FRPCBroker <> nil) and (FSIOPIList <> nil) then // rpk 1/6/2012
    if newValue.Text <> FSIOPIList.Text then begin
      FSIOPIList.Assign(newValue);
      FChanged := True;
    end;
end;

function TBCMA_MedOrder.getCanMarkNG: boolean;
begin
  if BCMA_User.IsManager then
    Result := True
  else if NurseIEN = BCMA_User.DUZ then
    Result := True
  else
    Result := False;
end;

function TBCMA_MedOrder.getIsPatch: Boolean;
begin
  result := false;
  if FAdministrationUnit = 'PATCH' then
    result := true;
end;

procedure TBCMA_MedOrder.ClearDispensedDrugsEnteredData;
var
  ii: integer;
begin
  for ii := 0 to OrderedDrugCount - 1 do begin
    OrderedDrugs[ii].QtyEntered := '';
    OrderedDrugs[ii].QtyScanned := 0;
    OrderedDrugs[ii].QtyScannedText := '';
  end;
end;

function TBCMA_MedOrder.CheckQtyEntered: Boolean;
var
  ii: integer;
begin
  result := True;
  for ii := 0 to OrderedDrugCount - 1 do
    if TrimLeft(OrderedDrugs[ii].QtyEntered) = '' then begin
      result := False;
      exit;
    end;
end;

///////////////////////////// TBCMA_DispensedDrug

constructor TBCMA_DispensedDrug.create(RPCBroker: TBCMA_Broker);
begin
  inherited create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  clear;
end;

destructor TBCMA_DispensedDrug.Destroy;
begin
  FRPCBroker := nil;

  inherited Destroy;
end;

procedure TBCMA_DispensedDrug.Clear;
begin
  FIEN := '';
  FName := '';
  FDose := '';
  FResultString := '';

  FQtyOrdered := '';
  FQtyScanned := 0;
  FQtyEntered := '';
  FisValidDrug := False;
  FQtyScannedText := '';
end;

function TBCMA_DispensedDrug.isValidDrug(var scanIEN: string): boolean;
var
  ii, jj, kk, Rslt: integer;
  AddList, SolList, DDList, NewResults, Add2List, Sol2List, DD2List:
  TStringList;
  Dlg: TForm;
  tmpString: string;
begin
  Clear;
  Add2List := nil;                      // rpk 4/6/2009
  Sol2List := nil;                      // rpk 4/6/2009
  DD2List := nil;                       // rpk 4/6/2009

  AddList := TStringList.Create;
  SolList := TStringList.Create;
  DDList := TStringList.Create;
  NewResults := TStringList.create;

  if FRPCBroker <> nil then
    with FRPCBroker do
      if CallServer('PSB SCANMED', [scanIEN,
        lstUnitDoseCurrentTab[lstCurrentTab]], nil) then
        if Results.Count - 1 <> StrToInt(Results[0]) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if piece(Results[1], '^', 1) = '-1' then
          DefMessageDlg(piece(Results[1], '^', 2) + #13#13 + 'DO NOT GIVE!!',
            mtError, [mbOK], 0
{$IFDEF R1224198}                       //bjr - INC1224198 - 6/2/2015
            , '', True
{$ENDIF}
            )
        else if StrToInt(Results[0]) > 0 then begin

          {rule out any drugs returned that aren't on current tab}
          //get all add, sol, dd's from VisibleMedList
          with VisibleMedList do
            for jj := 0 to VisibleMedList.count - 1 do
              with TBCMA_MedOrder(VisibleMedList[jj]) do begin
                for kk := 0 to FOrderedDrugIENs.count - 1 do
                  DDList.Add(FOrderedDrugIENs[kk]);
                for kk := 0 to FSolutions.Count - 1 do
                  SolList.Add(piece(FSolutions[kk], '^', 2));
                for kk := 0 to FAdditives.count - 1 do
                  AddList.Add(piece(Additives[kk], '^', 2));
              end;

          //loop thru all returned drugs and
          //see if they are contained in any orders.
          Add2List := TStringList.Create;
          Sol2List := TStringList.Create;
          DD2List := TStringList.Create;
          for ii := 1 to Results.Count - 1 do begin
            tmpString := Piece(Results[ii], '^', 1);
            if tmpString = 'DD' then
              if DDlist.IndexOf(piece(Results[ii], '^', 2)) > -1 then
                DD2List.Add(Results[ii]);

            if tmpString = 'SOL' then
              if SOLlist.IndexOf(piece(Results[ii], '^', 2)) > -1 then
                SOL2List.Add(Results[ii]);

            if tmpString = 'ADD' then
              if ADDlist.IndexOf(piece(Results[ii], '^', 2)) > -1 then
                Add2List.Add(Results[ii]);
          end;

          AddList.free;
          SolList.free;
          DDList.free;

          //if we find that UD drugs and IV drugs are returned, the user must decide whether this
          //administration will be a unit dose or PB adminstration

          if (
            (DD2List.Count > 0) and
            (
            (Add2List.Count > 0) or
            (Sol2List.Count > 0)
            )
            ) then begin
            {if a wardstock order is in process, skip the following and ignore the Unit Dose drugs (DD's)}
            if frmMain.WardStockInProc = false then begin
              Dlg :=
                CreateMessageDialog('The medication scanned matches a Unit Dose and an IV Piggyback order.'
                + #13#13 +
                'Do you wish to administer the Unit Dose medication or create a ward stock entry?',
                mtConfirmation, [mbYes, mbNo]);

              TButton(Dlg.FindComponent('Yes')).Caption := '&Unit Dose';
              TButton(Dlg.FindComponent('No')).Caption := '&Ward Stock';

              Rslt := Dlg.ShowModal;
            end
            else
              Rslt := mrNo;             // rpk 8/27/2010

            case Rslt of
              mrYes:                    {Treat as Unit Dose}
                NewResults.Assign(DD2List);
              mrNo: {Treat as Piggyback Ward Stock} begin
                  NewResults.Assign(SOL2List);
                  NewResults.AddStrings(ADD2List);
                end
            end;
          end
          else begin
            NewResults.Assign(DD2List);
            NewResults.AddStrings(Add2List);
            NewResults.AddStrings(SOL2List);
          end;

          if NewResults.Count = 0 then begin // rpk 12/11/2008
            // rpk 12/11/2008
            // Fix for CQ 102 to show DO NOT GIVE message when isValidDrug called
            // from uFiveRights Submit or other Unable to Scan conditions.
            if UnableToScan then        // rpk 12/11/2008
              DefMessageDlg('Invalid medication lookup.' + #13#10#13#10 +
                'DO NOT GIVE!', mtError, [mbOK], 0
{$IFDEF R1224198}                       //bjr - INC1224198 - 6/2/2015
                , '', True
{$ENDIF})                               // rpk 12/11/2008
            else                        // rpk 12/11/2008
              DefMessageDlg('Scanned Drug Not Found in Virtual Due List or' + #13
                +
                'It Has Already Been Given!', mtError, [mbOK], 0
{$IFDEF R1224198}                       //bjr - INC1224198 - 6/2/2015
                , '', True
{$ENDIF}
                );
            // rpk 12/11/2008
          end;                          // rpk 12/11/2008

          if NewResults.Count = 1 then begin
            FIEN := piece(Newresults[0], '^', 2);
            FName := piece(Newresults[0], '^', 3);
            FDose := piece(Newresults[0], '^', 4);
            FResultString := NewResults[0];
            scanIEN := FIEN;
            FisValidDrug := True;
          end
          else if NewResults.Count > 1 then
// change to try, frm := create, with frm do, finally, free frm
            with TfrmMultipleOrderedDrugs.create(application) do try
              for ii := 0 to NewResults.Count - 1 do
                lbxSelectList.items.addObject(piece(NewResults[ii], '^', 3) +
                  ', ' + piece(NewResults[ii], '^', 4), ptr(ii));
              ii := showModal;
              if ii <> mrCancel then begin
                jj := ii - 100;
                FIEN := piece(NewResults[jj], '^', 2);
                FName := piece(NewResults[jj], '^', 3);
                FDose := piece(NewResults[jj], '^', 4);
                FResultString := NewResults[jj];
                scanIEN := FIEN;
                FisValidDrug := True;
              end;
            finally
              Release;                  // rpk 6/18/2013
            end;
        end;
  result := FisValidDrug;
  Add2List.free;
  Sol2List.free;
  DD2List.free;
  NewResults.free;

end;                                    // isValidDrug

function TBCMA_DispensedDrug.getQtyOrdered: integer;
var
  rValue: real;
begin
  rValue := strToFloat(FQtyOrdered);
  result := trunc(rValue);
  if (rValue - result) > 0 then
    inc(result);

end;

///////////////////////////// TBCMA_UserParameters

constructor TBCMA_UserParameters.create(RPCBroker: TBCMA_Broker);
begin
  inherited create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  Clear;
end;

destructor TBCMA_UserParameters.destroy;
begin
  SaveData;

  FRPCBroker := nil;

  inherited destroy;
end;

procedure TBCMA_UserParameters.Clear;
begin
  FDUZ := '';

  FContinuousChecked := False;
  FPRNChecked := False;
  FOneTimeChecked := False;
  FOnCallChecked := False;

  // change default to new BCRO values
  FMainFormHeight := 768;               // rpk 6/13/2012
  FMainFormWidth := 1024;               // rpk 6/13/2012

  FMainFormPosition := poScreenCenter;  // rpk 9/27/2012
  FMainFormState := wsNormal;

  FUDSortColumn := ctActiveMedication;
  FPBSortColumn := PBMedicationSolution;
  FIVSortColumn := IVMedicationSolution;
  FChanged := False;
  FUPOrderMode := omInpatient;          // rpk 6/26/2012
  FClinSrchPrefix := '';                // rpk 6/26/2012
  FClinSrchText := '';                  // rpk 6/26/2012
end;

function TBCMA_UserParameters.LoadData: boolean;
var
  ii: Integer;
  pcnt, colcnt: Integer;
begin
  result := False;

  Clear;                                // rpk 8/25/2009
  if useUserDefaults then begin         // rpk 8/25/2009
    Result := True;
    Exit;
  end;

  if FRPCBroker <> nil then
    with FRPCBroker do begin
      if CallServer('PSB USERLOAD', [''], nil) then
        if piece(FRPCBroker.Results[0], '^', 1) = '-1' then
          DefMessageDlg('Error in loading user parameters', mtError, [mbok], 0)
        else begin
          begin
            FMainFormTop := StrToIntDef(piece(Results[5], '/', 1), 0);
            FMainFormLeft := StrToIntDef(piece(Results[5], '/', 2), 0);
            FMainFormWidth := StrToIntDef(piece(Results[5], '/', 3), 1024);
            FMainFormHeight := StrToIntDef(piece(Results[5], '/', 4), 768);

            FMainFormState := TWindowState(StrToIntDef(piece(Results[5], '/',
              5), integer(wsNormal)));

            //Removed this functionality, now always default to ctUD
            FCurrentTab := ctUD;
            lstCurrentTab := FCurrentTab;
          end;

          if piece(Results[6], '^', 1) = '' then begin
            FUDSortColumn := ctActiveMedication;
            FPBSortColumn := PBMedicationSolution;
            FIVSortColumn := IVMedicationSolution;
          end
          else begin
            FUDSortColumn := TVDLColumnTypes(StrToIntDef((piece(Results[6], '/',
              5)), integer(ctActiveMedication)));
            FPBSortColumn := lstPBColumnTypes(StrToIntDef((piece(Results[6],
              '/', 6)), integer(PBMedicationSolution)));
            FIVSortColumn := lstIVColumnTypes(StrToIntDef((piece(Results[6],
              '/', 7)), integer(IVMedicationSolution)));
          end;

          // change StrToInt to StrToIntDef;  StrToInt fails if a column is added.
          // On a column add, the initial value is '' and fails to convert.
          if Results[12] <> '' then begin
            pcnt := PieceCnt(Results[12], '/');
            colcnt := Length(VDLColumnTitles);
            if pcnt = colcnt then begin // rpk 6/11/2012
              for ii := 0 to length(VDLColumnTitles) - 1 do begin
                VDLColumnWidths[TVDLColumnTypes(ii)] :=
                  StrToIntDef(piece(Results[12], '/', ii + 1), HdrMinWidth); // rpk 3/13/2012
              end;
            end;
          end;

          if Results[14] <> '' then begin
            pcnt := PieceCnt(Results[14], '/');
            colcnt := Length(lstPBColumnTitles);
            if pcnt = colcnt then begin // rpk 6/11/2012
              for ii := 0 to length(lstPBColumnTitles) - 1 do begin
                lstPBColumnWidths[lstPBColumnTypes(ii)] :=
                  StrToIntDef(piece(Results[14], '/', ii + 1), HdrMinWidth); // rpk 3/13/2012
              end;
            end;
          end;

          if Results[15] <> '' then begin
            pcnt := PieceCnt(Results[15], '/');
            colcnt := Length(lstIVColumnTitles);
            if pcnt = colcnt then begin // rpk 6/11/2012
              for ii := 0 to length(lstIVColumnTitles) - 1 do begin
                lstIVColumnWidths[lstIVColumnTypes(ii)] :=
                  StrToIntDef(piece(Results[15], '/', ii + 1), HdrMinWidth); // rpk 3/13/2012
              end;
            end;
          end;

          FDefaultPrinterIEN := StrToIntDef(piece(Results[17], '/', 1), 0);
          FDefaultPrinterName := piece(Results[17], '/', 2);

          if Results[19] <> '' then begin
            CSMOSortColumn := StrToIntDef(piece(Results[19], '/', 1), 3);
            CSPRNSortColumn := StrToIntDef(piece(Results[19], '/', 2), 2);
            CSIVSortColumn := StrToIntDef(piece(Results[19], '/', 3), 3);
            CSExSortColumn := StrToIntDef(piece(Results[19], '/', 4), 3);
          end;

          if Results[20] <> '' then begin
            pcnt := PieceCnt(Results[20], '/');
            colcnt := Length(lstIVColumnTitles);
            if pcnt = colcnt then begin // rpk 6/20/2012
              if (Results[20] <> '') and (piece(Results[20], '/',
                (Length(MedOverviewColTitles) - 1)) <> '') then
                for ii := 0 to Length(MedOverviewColTitles) - 1 do
                  MedOverviewColWidths[TMedOverviewColTypes(ii)] :=
                    StrToIntDef(piece(Results[20], '/', ii + 1), 75);
            end;
          end;

          if Results[21] <> '' then begin
            pcnt := PieceCnt(Results[21], '/');
            colcnt := Length(lstIVColumnTitles);
            if pcnt = colcnt then begin // rpk 6/20/2012
              if (Results[21] <> '') and (piece(Results[21], '/',
                (Length(PRNAColTitlesLvl1) - 1)) <> '') then
                for ii := 0 to Length(PRNAColTitlesLvl1) - 1 do
                  PRNAColWidths[TPRNColTypes(ii)] :=
                    StrToIntDef(piece(Results[21],
                    '/', ii + 1), 75);
            end;
          end;

          if Results[22] <> '' then begin
            pcnt := PieceCnt(Results[22], '/');
            colcnt := Length(lstIVColumnTitles);
            if pcnt = colcnt then begin // rpk 6/20/2012
              if (Results[22] <> '') and (piece(Results[22], '/',
                (Length(IVOColTitlesLvl1) - 1)) <> '') then
                for ii := 0 to Length(IVOColTitlesLvl1) - 1 do
                  IVColWidths[TIVColTypes(ii)] := StrToIntDef(piece(Results[22],
                    '/', ii + 1), 75);
            end;
          end;

          if Results[23] <> '' then begin
            pcnt := PieceCnt(Results[23], '/');
            colcnt := Length(lstIVColumnTitles);
            if pcnt = colcnt then begin // rpk 6/20/2012
              if (Results[23] <> '') and (piece(Results[23], '/',
                (Length(ExColTitlesLvl1) - 1)) <> '') then
                for ii := 0 to Length(ExColTitlesLvl1) - 1 do
                  EXColWidths[TExpiredColTypes(ii)] :=
                    StrToIntDef(piece(Results[23],
                    '/', ii + 1), 75);
            end;
          end;

          if Results.Count > 28 then
            FUPOrderMode := TOrderMode(StrToIntDef((piece(Results[28], '/', 1)),
              ord(omInpatient)));       // rpk 5/30/2012
          if Results.Count > 29 then begin
            FClinSrchPrefix := piece(Results[29], '/', 1); // rpk 5/30/2012
            FClinSrchText := piece(Results[29], '/', 2); // rpk 5/30/2012
          end;

          FChanged := False;

          result := True;
        end;
    end;
end;                                    // LoadData

procedure TBCMA_UserParameters.SaveData;
var
  p1,
    p2,
    p3,
    p4,
    p5,
    CoverSheetSortColumns,
    CoverSheetMOColWidths,
    CoverSheetPRNColWidths,
    CoverSheetIVColWidths,
    CoverSheetExColWidths: string;
  ii: Integer;
begin
  if (FRPCBroker <> nil) and (not ShutDown) then
    if FChanged then
      with FRPCBroker do begin
        if (FMainFormWidth < 100) or (FMainFormHeight < 100) then
          p1 := ''
        else begin
          p1 := IntToStr(max(0, FMainFormTop)) + '/' +
            IntToStr(max(0, FMainFormLeft)) + '/' +
            IntToStr(FMainFormWidth) + '/' +
            IntToStr(FMainFormHeight) + '/' +
            IntToStr(integer(FMainFormState));
        end;

        p2 := FalseTrue[FContinuousChecked] + '/' +
          FalseTrue[FPRNChecked] + '/' +
          FalseTrue[FOneTimeChecked] + '/' +
          FalseTrue[FOnCallChecked] + '/' +
          IntToStr(integer(FUDSortColumn)) + '/' +
          IntToStr(integer(FPBSortColumn)) + '/' +
          IntToStr(integer(FIVSortColumn));

        for ii := 0 to length(VDLColumnTitles) - 1 do begin
          p3 := p3 + IntToStr(VDLColumnWidths[TVDLColumnTypes(ii)]);
          if ii < length(VDLColumnTitles) - 1 then
            p3 := p3 + '/';
        end;

        for ii := 0 to Length(lstPBColumnTitles) - 1 do begin
          p4 := p4 + IntToStr(lstPBColumnWidths[lstPBColumnTypes(ii)]);
          if ii < Length(lstPBColumnTitles) - 1 then
            p4 := p4 + '/';
        end;

        for ii := 0 to Length(lstIVColumnTitles) - 1 do begin
          p5 := p5 + IntToStr(lstIVColumnWidths[lstIVColumnTypes(ii)]);
          if ii < Length(lstIVColumnTitles) - 1 then
            p5 := p5 + '/';
        end;

        CoverSheetSortColumns := IntToStr(CSMOSortColumn) + '/' +
          IntToStr(CSPRNSortColumn) + '/' +
          IntToStr(CSIVSortColumn) + '/' +
          IntToStr(CSExSortColumn);

        for ii := 0 to Length(MedOverviewColTitles) - 1 do begin
          CoverSheetMOColWidths := CoverSheetMOColWidths +
            IntToStr(MedOverviewColWidths[TMedOverviewColTypes(ii)]);
          if ii < Length(MedOverviewColTitles) - 1 then
            CoverSheetMOColWidths := CoverSheetMOColWidths + '/';
        end;

        for ii := 0 to Length(PRNAColTitlesLvl1) - 1 do begin
          CoverSheetPRNColWidths := CoverSheetPRNColWidths +
            IntToStr(PRNAColWidths[TPRNColTypes(ii)]);
          if ii < Length(PRNAColTitlesLvl1) - 1 then
            CoverSheetPRNColWidths := CoverSheetPRNColWidths + '/';
        end;

        for ii := 0 to Length(IVOColTitlesLvl1) - 1 do begin
          CoverSheetIVColWidths := CoverSheetIVColWidths +
            IntToStr(IVColWidths[TIVColTypes(ii)]);
          if ii < Length(IVOColTitlesLvl1) - 1 then
            CoverSheetIVColWidths := CoverSheetIVColWidths + '/';
        end;

        for ii := 0 to Length(EXColTitlesLvl1) - 1 do begin
          CoverSheetEXColWidths := CoverSheetEXColWidths +
            IntToStr(EXColWidths[TExpiredColTypes(ii)]);
          if ii < Length(EXColTitlesLvl1) - 1 then
            CoverSheetEXColWidths := CoverSheetEXColWidths + '/';
        end;

        if CallServer('PSB USERSAVE', [p1, p2, p3, p4, p5,
          IntToStr(FDefaultPrinterIEN) + '/' + FDefaultPrinterName,
            CoverSheetSortColumns, CoverSheetMOColWidths,
            CoverSheetPRNColWidths,
            CoverSheetIVColWidths, CoverSheetExColWidths,
            IntToStr(ord(OrderMode)), ClinSrchPrefix + '/' + ClinSrchText], nil)
          then begin                    // rpk 5/30/2012
          DefMessageDlg(piece(results[0], '^', 2), mtInformation, [mbOK], 0);
          FChanged := (piece(Results[0], '^', 1) <> '1');
        end;
      end;
end;                                    // SaveData

procedure TBCMA_UserParameters.setContinuousChecked(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FContinuousChecked then begin
      FContinuousChecked := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setPRNChecked(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FPRNChecked then begin
      FPRNChecked := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setOneTimeChecked(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FOneTimeChecked then begin
      FOneTimeChecked := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setOnCallChecked(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FOnCallChecked then begin
      FOnCallChecked := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormTop(newValue: integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormTop then begin
      FMainFormTop := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormLeft(newValue: integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormLeft then begin
      FMainFormLeft := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormHeight(newValue: integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormHeight then begin
      FMainFormHeight := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormWidth(newValue: integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormWidth then begin
      FMainFormWidth := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormPosition(newValue: TPosition);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormPosition then begin
      FMainFormPosition := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormState(newValue: TWindowState);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormState then begin
      FMainFormState := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setCurrentTab(newValue: lstTabs);
begin
  if FRPCBroker <> nil then
    if newValue <> FCurrentTab then begin
      FCurrentTab := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setStartTime(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FStartTime then begin
      FStartTime := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setStopTime(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FStopTime then begin
      FStopTime := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setUDSortColumn(newValue: TVDLColumnTypes);
begin
  if FRPCBroker <> nil then
    if newValue <> FUDSortColumn then begin
      FUDSortColumn := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setPBSortColumn(newValue: lstPBColumnTypes);
begin
  if FRPCBroker <> nil then
    if newValue <> FPBSortColumn then begin
      FPBSortColumn := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setIVSortColumn(newValue: lstIVColumnTypes);
begin
  if FRPCBroker <> nil then
    if newValue <> FIVSortColumn then begin
      FIVSortColumn := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setDefaultPrinterIEN(newValue: Integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FDefaultPrinterIEN then begin
      FDefaultPrinterIEN := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setFChanged(newvalue: Boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FChanged then begin
      FChanged := newValue;
    end;
end;


///////////////////////////// TBCMA_SiteParameters

constructor TBCMA_SiteParameters.create(RPCBroker: TBCMA_Broker);
begin
  inherited create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  FListReasonsGivenPRN := TStringList.Create;
  FListReasonsHeld := TStringList.Create;
  FListReasonsRefused := TStringList.create;
  FListInjectionSites := TStringList.create;
  FListBodySites := TStringList.create;
  FListDevices := TStringList.Create;
  FWardList := TStringList.Create;
  FProviderList := TStringList.Create;
  FToolsApps := TStringList.Create;
  Clear;
end;

destructor TBCMA_SiteParameters.destroy;
begin
  FListReasonsGivenPRN.Free;
  FListReasonsHeld.Free;
  FListReasonsRefused.Free;
  FListInjectionSites.Free;
  FListBodySites.Free;
  FListDevices.Free;
  FWardList.Free;
  FProviderList.Free;
  FToolsApps.Free;
  FRPCBroker := nil;

  inherited destroy;
end;

procedure TBCMA_SiteParameters.Clear;
begin
  FContinuousChecked := False;
  FPRNChecked := False;
  FOneTimeChecked := False;
  FOnCallChecked := False;
  FMedOrderButton := False;
  FReportInclCmt := False;

  FMinutesBefore := 0;
  FMinutesAfter := 0;
  FMinutesPRNEffect := 0;
  FVDLStartTime := 0;
  FVDLStopTime := 0;
  FIdleTimeout := 0;
  FMAHMaxDays := 0;
  FMedHistDaysBack := 0;
  FMaxDateRange := 0;
  FNonNurseVfyLvl := -1;                // default unassigned value

  FServerClockVariance := 0;
  FMaximumServerClockVariance := 0;

  //  FHFSScratch := '';
  FHFSBackup := '';
  FMGSysError := '';
  FMGDLError := '';
  FMGMissingDose := '';
  FAutoUpdateServer := '';
  FMGAutoUpdate := '';
  FUDID := '';
  FIVID := '';
  FUNITDOSE_DIALOG := '';
  FIV_DIALOG := '';
  FPatIDLabel := '';                    // rpk 8/6/2009

  {JK - 4/7/2008}
  FFiveRightsUnitDose := False;
  FFiveRightsIV := False;

  FListReasonsGivenPRN.Clear;
  FListReasonsHeld.Clear;
  FListReasonsRefused.Clear;
  FListInjectionSites.clear;
  FListBodySites.Clear;
  FListDevices.Clear;
  FWardList.Clear;
  FProviderList.Clear;

  FChanged := False;
end;

function TBCMA_SiteParameters.getServerClockVariance: real;
begin
  result := 0.0;
  if FRPCBroker <> nil then
    result := FServerClockVariance / 1440;
end;

function TBCMA_SiteParameters.getMaximumServerClockVariance: real;
begin
  result := 0.0;
  if FRPCBroker <> nil then
    result := FMaximumServerClockVariance / 1440;
end;

function TBCMA_SiteParameters.getServerTime: TDateTime;
begin
  result := Now;
  if FRPCBroker <> nil then
    result := Now + FServerClockVariance / 1440;
end;

function TBCMA_SiteParameters.GetParameter(Parameter: string; UpArrowPiece:
  Integer): string;
begin
  Result := '';
  with FRPCBroker do
    if CallServer('PSB PARAMETER', ['GETPAR', 'ALL', Parameter], nil) then
      Result := piece(Results[0], '^', UpArrowPiece);
end;

function TBCMA_SiteParameters.SetParameter(DivisionID, Parameter: string;
  newValue: string): Boolean;
begin
  Result := False;
  with FRPCBroker do
    if CallServer('PSB PARAMETER', ['SETPAR', DivisionID, Parameter, '1',
      newValue], nil) then
      if piece(Results[0], '^', 1) = '-1' then
        DefMessageDlg('Invalid Parameter Value', mtError, [mbok], 0)
      else
        Result := True;
end;

function TBCMA_SiteParameters.LoadData: boolean;
var
  SaveDebugMode: boolean;
  RequiredServerPatch: string;          //Minimun patch required on server
  ScanFailuresMG: string;
  x: integer;
begin
  result := False;
  if FRPCBroker <> nil then
    with FRPCBroker do begin

      Clear;

      SaveDebugMode := DebugMode;
      RequiredServerPatch := RequiredPatch;
      FrmSplash.WriteStatus('Checking VistA/PC Clock Variance...');
      // rpk 6/9/2009
      // Maximum Server Clock Variance
      FMaximumServerClockVariance :=
        StrToIntDef(GetParameter('PSB SERVER CLOCK VARIANCE', 1), 0);

      if CallServer('PSB SERVER CLOCK VARIANCE', [FormatDateTime('mmddyyyy', now)
        + '@' + FormatDateTime('hhmm', now)], nil) then begin
        result := (piece(Results[0], '^', 1) = '1');
        if AppFileVersion > '0.9.4' then begin
          if result then
            FServerClockVariance := -strToInt(piece(Results[0], '^', 2))
          else begin
            FServerClockVariance := -strToInt(piece(Results[0], '^', 2));
            result :=
              (DefMessageDlg('The time difference between the Client PC and the Server exceeds ' +
              intToStr(FMaximumServerClockVariance) + ' minutes!' + #13#13 +
              'Do you wish to continue?',
              mtWarning, [mbYes, mbNo], 0) = mrYes);
          end
        end
        else begin
          if result then
            FServerClockVariance := -strToInt(piece(Results[0], '^', 2))
          else
            DefMessageDlg(piece(Results[0], '^', 2), mtError, [mbOK], 0);
        end;
      end;

      with frmSplash do begin
        WriteStatus('Loading Site Parameters...'); // rpk 6/9/2009
        // prgbrSplashScreen.Max := 23;
        // added a step for read of unable to scan mail group
        // prgbrSplashScreen.Max := 24;
        // added step for get of PSB NON-NURSE VERIFIED PROMPT; re-counted position increments
        prgbrSplashScreen.Position := 0; // rpk 1/21/2011
        prgbrSplashScreen.Max := 30;    // rpk 11/5/2015
        prgbrSplashScreen.Visible := True;
      end;
      if result then begin
      //need to come up with a better way of looping thru all the following stuff!
        // Include Continuous
        FContinuousChecked := (GetParameter('PSB VDL INCL CONT', 1) = '1');
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Include PRN
        FPRNChecked := (GetParameter('PSB VDL INCL PRN', 1) = '1');
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Include One-Time
        FOneTimeChecked := (GetParameter('PSB VDL INCL ONE-TIME', 1) = '1');
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Include On-Call
        FOnCallChecked := (GetParameter('PSB VDL INCL ON-CALL', 1) = '1');
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        FMedOrderButton := (GetParameter('PSB HKEY', 1) = '1');
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        //Default Include Comments to checked
        FReportInclCmt := (GetParameter('PSB RPT INCL COMMENTS', 1) = '1');
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Minutes Before
        //FMinutesBefore := StrToIntDef(GetParameter('PSB ADMIN BEFORE', 1), 0) div 10;
        FMinutesBefore := StrToIntDef(GetParameter('PSB ADMIN BEFORE', 1), 0);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Minutes After
        //FMinutesAfter := StrToIntDef(GetParameter('PSB ADMIN AFTER', 1), 0) div 10;
        FMinutesAfter := StrToIntDef(GetParameter('PSB ADMIN AFTER', 1), 0);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Minutes PRN Effect
        FMinutesPRNEffect := StrToIntDef(GetParameter('PSB ADMIN PRN EFFECT',
          1), 0) div 10;
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // VDL Start Time
        FVDLStartTime := StrToIntDef(GetParameter('PSB VDL START TIME', 1), 1);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // VDL Stop Time
        FVDLStopTime := StrToIntDef(GetParameter('PSB VDL STOP TIME', 1), 1);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        FIdleTimeout := StrToIntDef(GetParameter('PSB IDLE TIMEOUT', 1), 30);
        if FIdleTimeout = 0 then
          FIdleTimeout := 30;
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        FMedHistDaysBack := StrToIntDef(GetParameter('PSB MED HIST DAYS BACK',
          2), 30);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Backup HFS Directory
        FHFSBackup := GetParameter('PSB HFS BACKUP', 1);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // General Error MG
        FMGSysError := GetParameter('PSB MG SYSTEM ERROR', 2);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Due List Error MG
        FMGDLError := GetParameter('PSB MG DUE LIST ERROR', 2);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Missing Dose MG
        FMGMissingDose := GetParameter('PSB MG MISSING DOSE', 2);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        ScanFailuresMG := GetParameter('PSB MG SCANNING FAILURES', 2);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // AutoUpdate Server
        FAutoUpdateServer := GetParameter('PSB AUTOUPDATE SERVER', 2);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // AutoUpdate MG
        FMGAutoUpdate := GetParameter('PSB MG AUTOUPDATE', 2);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        if CallServer('ORBCMA5 GETUDID', [''], nil, True) then
          FUNITDOSE_DIALOG := Results[0];
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        if CallServer('ORBCMA5 GETIVID', [''], nil, True) then
          FIV_DIALOG := Results[0];
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        if CallServer('PSB MAXDAYS', [''], nil) then
          FMAHMaxdays := StrToIntDef(Results[0], 7);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        FMaxDateRange := StrToIntDef(GetParameter('PSB RPT MAX RANGE', 2), -1);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        {JK - 4/7/2008}
        FFiveRightsUnitDose := (GetParameter('PSB 5 RIGHTS UNITDOSE', 1) = '1');
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;
        FFiveRightsIV := (GetParameter('PSB 5 RIGHTS IV', 1) = '1');
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        FPatIDLabel := GetParameter('PSB PATIENT ID LABEL', 1); // rpk 8/6/2009
        if Length(Trim(FPatIDLabel)) = 0 then // rpk 8/6/2009
          FPatIDLabel := 'PtID';        // rpk 8/6/2009
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // rpk 1/21/2011
        x := StrToIntDef(GetParameter('PSB NON-NURSE VERIFIED PROMPT', 1), -1);
//        if x in [1..3] then
//
// DEBUG: override parameter input; use Allow with Warning.  rpk 4/12/2011
//
//
//        x := 2;
//
        if x in [ord(nvNoWarning)..ord(nvProhibit)] then
          FNonNurseVfyLvl := x
        else
          FNonNurseVfyLvl := ord(nvNoWarning); /// TEMPORARY FIX for UCIs that have no value defined.
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Injection Site History Max Hours
        FInjSiteHistMaxHrs := GetParameter('PSB INJECTION SITE MAX HOURS', 2); // rpk 2/6/2012
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        // Dermal Site History Max Days
        FDermSiteHistMaxDays := GetParameter('PSB DERMAL SITE MAX DAYS', 2); // rpk 11/5/2015
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        with frmSplash do begin
          WriteStatus('Loading Default Answer Lists...'); // rpk 6/9/2009
          prgbrSplashScreen.Position := 0;
          prgbrSplashScreen.Max := 5;   // rpk 10/13/2015
        end;

        if CallServer('PSB PARAMETER', ['GETLST', 'ALL',
          'PSB LIST REASONS GIVEN PRN'], nil) then
          for x := 0 to Results.Count - 1 do
            if piece(Results[x], '|', 2) = '' then
              FListReasonsGivenPRN.Add(Results[x] + '|0')
            else
              FListReasonsGivenPRN.Add(Results[x]);

        FListReasonsGivenPRN.delete(0);
        FListReasonsGivenPRN.Sorted := True;
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        if CallServer('PSB PARAMETER', ['GETLST', 'ALL',
          'PSB LIST REASONS HELD'], nil) then
          FListReasonsHeld.Assign(Results);
        FListReasonsHeld.delete(0);
        FListReasonsHeld.Sorted := True;
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        if CallServer('PSB PARAMETER', ['GETLST', 'ALL',
          'PSB LIST REASONS REFUSED'], nil) then
          FListReasonsRefused.Assign(Results);
        FListReasonsRefused.delete(0);
        FListReasonsRefused.Sorted := True;
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        if CallServer('PSB PARAMETER', ['GETLST', 'ALL',
          'PSB LIST INJECTION SITES'], nil) then
          FListInjectionSites.Assign(Results);
        FListInjectionSites.delete(0);
        FListInjectionSites.Sorted := True;
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        if CallServer('PSB PARAMETER', ['GETLST', 'ALL', // rpk 10/13/2015
          'PSB LIST BODY SITES'], nil) then
          FListBodySites.Assign(Results);
        FListBodySites.delete(0);
        FListBodySites.Sorted := True;
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        if CallServer('PSB PARAMETER', ['GETLST', 'ALL', 'PSB TOOLS MENU'], nil)
          then
          FToolsApps.Assign(Results);
        FToolsApps.delete(0);
        frmSplash.prgbrSplashScreen.Position :=
          frmSplash.prgbrSplashScreen.Position + 1;

        with frmSplash do begin
          WriteStatus('Loading Ward List...'); // rpk 6/9/2009
          prgbrSplashScreen.visible := False;
        end;

        if CallServer('PSB NURS WARDLIST', [''], nil) then
          for x := 1 to Results.Count - 1 do
            WardList.Add(Results[x]);

        result := True;
      end;
      DebugMode := SaveDebugMode;
    end;

  if result = False then
    DefMessageDlg('Could Not Load Required Site Parameters!', mtError, [mbOK],
      0);
end;

constructor TBCMA_IVBags.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  FSolutions := TStringList.Create;
  FAdditives := TStringList.Create;
  FBagDetails := TStringList.Create;
  Clear;

end;

destructor TBCMA_IVBags.Destroy;
begin

  FSolutions.Free;
  FAdditives.Free;
  FBagDetails.Free;
  FRPCBroker := nil;

  inherited Destroy;

end;

procedure TBCMA_IVBags.Clear;

begin
  FOrderNumber := '';
  FUniqueID := '';
  FTimeLastGiven := '';
  FScanStatus := '';
  FMedLogIEN := '';
  FInjectionSite := '';

  FSolutions.Clear;
  FAdditives.Clear;
  FBagDetails.Clear;

  FDisplayedMessage := False;

end;

function TBCMA_IVBags.GetBagDetails(StringIn: string; OrderNumIn: string):
  string;
var
  x: integer;
begin
  FBagDetails.Clear;
  if (FRPCBroker <> nil) then
    with FRPCBroker do
      if CallServer('PSB BAG DETAIL', [StringIn, OrderNumIn], nil) then
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0],
          -1)) then begin
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
          exit;
        end
        else if piece(Results[1], '^', 1) = '-1' then
          Result := Results[1]
        else begin
          for x := 1 to Results.Count - 1 do
            FBagDetails.Add(Results[x]);
          Result := '1';
        end;

end;                                    // GetBagDetails

function TBCMA_OMMedOrder.isValidMedSolution(ScannedDrugIENString, OrderTypeIn:
  string): boolean;
var
  ii, jj: integer;

  function AddDrug(StringIn: string): Boolean;
  var
    x: integer;
  begin
    Result := True;
    with TBCMA_OMMedOrder(BCMA_Patient.OMMedOrders[BCMA_Patient.OMMedOrders.count
      - 1]) do
      with FScannedMeds do begin
        if OrderTypeIn = 'UD' then begin
          if FScannedMeds.Count > 0 then
            if TBCMA_OMScannedMeds(FScannedMeds[0]).FOrderableItemIEN <>
              Piece(StringIn, '^', 6) then begin
              DefMessageDlg('Scanned medication must have the same orderable item as the first scanned Medication!', mtError, [mbOK], 0);
              Result := False;
              exit;
            end;

          for x := 0 to FScannedMeds.count - 1 do
            if TBCMA_OMScannedMeds(FScannedMeds[x]).FScannedDrugIEN =
              Piece(StringIn, '^', 2) then begin
              TBCMA_OMScannedMeds(FScannedMeds[x]).FUnitsPerDose :=
                TBCMA_OMScannedMeds(FScannedMeds[x]).FUnitsPerDose + 1;
              exit;
            end;
        end;

        add(TBCMA_OMScannedMeds.create(FRPCBroker));
        with TBCMA_OMScannedMeds(FScannedMeds[FScannedMeds.count - 1]) do begin
          FScannedDrugType := Piece(StringIn, '^', 1);
          FOrderableItemIEN := Piece(StringIn, '^', 6);
          FOrderableItemName := Piece(StringIn, '^', 7);
          FScannedDrugIEN := Piece(StringIn, '^', 2);
          FUnitsPerDose := 1;

          if ScannedDrugType = 'ADD' then begin
            FAdditiveIEN := Piece(StringIn, '^', 8);
            FScannedDrugName := piece(StringIn, '^', 9) + ' ' + piece(StringIn,
              '^', 10);
          end
          else if ScannedDrugType = 'SOL' then begin
            FSolutionIEN := Piece(StringIn, '^', 8);
            FScannedDrugName := piece(StringIn, '^', 9) + ' ' + piece(StringIn,
              '^', 10);
          end
          else if ScannedDrugType = 'DD' then
            FScannedDrugName := Piece(StringIn, '^', 3);

          FVolume := Piece(StringIn, '^', 10);
        end;
      end;
  end;

begin
  result := False;
  if FRPCBroker <> nil then
    with FRPCBroker do
      if CallServer('PSB MOB DRUG LIST', [ScannedDrugIENString, OrderTypeIn],
        nil) then
        with TfrmMultipleOrderedDrugs.create(application) do
          if Results.Count - 1 <> StrToInt(Results[0]) then begin
            DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
          end
          else if piece(Results[1], '^', 1) = '-1' then
            DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
          else if piece(Results[1], '^', 1) = '-2' then
            DefMessageDlg('Too many results returned!' + #13 +
              'Please enter more criteria.', mtInformation, [mbOK], 0)
          else if StrToInt(Results[0]) = 1 then begin
            Result := AddDrug(Results[1]);
          end
          else if StrToInt(Results[0]) > 1 then begin
            with TfrmMultipleOrderedDrugs.create(application) do try
              for ii := 1 to Results.Count - 1 do
                if OrderTypeIn = 'UD' then
                  lbxSelectList.items.addObject(piece(Results[ii], '^', 3),
                    ptr(ii))
                else
                  lbxSelectList.items.addObject(piece(Results[ii], '^', 9) + ' '
                    + piece(Results[ii], '^', 10), ptr(ii));
              ii := showModal;
              if ii <> mrCancel then begin
                jj := ii - 100;
                Result := AddDrug(Results[jj]);
              end;
            finally
              Release;                  // rpk 6/18/2013
            end;
          end
          else
            Result := False;
end;

function TBCMA_OMMedOrder.isValidProvider(var StringIn: string): string;
var
  ii, jj: Integer;
begin
  Result := '-1';
  if FRPCBroker <> nil then
    with FRPCBroker do
      if CallServer('PSB GETPROVIDER', [StringIn], nil) then
        if Results.Count - 1 <> StrToInt(Results[0]) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if piece(Results[1], '^', 1) = '-1' then
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
        else if piece(Results[1], '^', 1) = '-2' then
          DefMessageDlg('Please narrow down your search!', mtInformation,
            [mbOK], 0)
        else if StrToInt(Results[0]) > 1 then begin
          with TfrmMultipleOrderedDrugs.create(application) do try
            caption := 'Provider';
            Repaint;
            lblSelectDrug.Caption := 'Please select a provider:'; // rpk 11/8/2012
            for ii := 1 to Results.Count - 1 do
              lbxSelectList.items.addObject(piece(Results[ii], '^', 2),
                ptr(ii));
            ii := showModal;
            if ii <> mrCancel then begin
              jj := ii - 100;
              StringIn := piece(Results[jj], '^', 2);
              Result := piece(Results[jj], '^', 1);
            end;
          finally
            Release;                    // rpk 6/18/2013
          end;

        end
        else begin
          StringIn := piece(Results[1], '^', 2);
          Result := piece(Results[1], '^', 1);
        end;

end;

constructor TBCMA_OMScannedMeds.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then begin
    FRPCBroker := RPCBroker;
  end;

  Clear;
end;

destructor TBCMA_OMScannedMeds.Destroy;
begin
  Clear;

  FRPCBroker := nil;

  inherited Destroy;
end;

constructor TBCMA_OMMedOrder.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then begin
    FRPCBroker := RPCBroker;
    FScannedMeds := TList.Create;
  end;
end;

destructor TBCMA_OMMedOrder.Destroy;
begin
  ClearScannedMeds;
  FScannedMeds.free;
  FRPCBroker := nil;

  inherited Destroy;
end;

procedure TBCMA_OMMedOrder.ClearScannedMeds;
var
  i: integer;
begin
  if FScannedMeds <> nil then
    with FScannedMeds do begin
      for i := count - 1 downto 0 do
        TBCMA_OMScannedMeds(items[i]).free;
      clear;
    end;
end;

procedure TBCMA_OMScannedMeds.Clear;
begin

  FOrderableItemIEN := '';
  FOrderableItemName := '';
  FScannedDrugIEN := '';
  FScannedDrugName := '';
  FScannedDrugType := '';
  FVolume := '';

end;

procedure TBCMA_Patient.ClearOMMedOrders;
var
  i: integer;
begin
  if FOMMedorders <> nil then
    with FOMMedorders do begin
      for i := count - 1 downto 0 do begin
        TBCMA_OMMedOrder(items[i]).ClearScannedMeds;
        TBCMA_OMMedorder(items[i]).free;
      end;
      clear;
    end;
  FOMMedOrdersOrderID.Clear;

end;

procedure TBCMA_Patient.CancelOMMedOrders();
begin
end;

procedure TBCMA_Patient.SendOMMedOrders(OrderIDString: WideString);
var
  x: integer;
  zOrderID: string;
begin
  for x := 0 to FOMMedOrders.Count - 2 do
    with TBCMA_OMMedOrder(FOMMedOrders[x]) do begin
      zOrderID := Piece(OrderIDString, '^', x + 1);
      zOrderID := Piece(zOrderID, ';', 1);
      if zOrderID <> '-1' then begin
        SendOrder(zOrderID);
      end;
    end
end;

procedure TBCMA_OMMedOrder.SendOrder(OrderIDIn: string);
var
  index,
    x,
    ddCount,
    addCOunt,
    solCount: integer;
  MultList: TStringList;
  CmdString,
    DDString, ADDString, SOLString: string;
begin
  MultList := TStringList.Create;
  ddCount := 0;
  addCount := 0;
  solCount := 0;
  with BCMA_Patient do
    if OMMedOrdersOrderID.Find(OrderIDIn, Index) then begin
      with TBCMA_OMMedOrder(FOMMedOrders[index]) do begin
        CmdString := BCMA_Patient.FIEN + '^' + piece(FOrderID, ';', 1) +
          '^' + UpperCase(FSchedule);
        with MultList do begin
          add(FIVType);
          add(FIntSyringe);
          add(FAdminDateTime);

          for x := 0 to FScannedMeds.Count - 1 do
            with TBCMA_OMScannedMeds(FScannedMeds[x]) do begin
              if FScannedDrugType = 'DD' then begin
                ddCount := ddCount + 1;
                if DDString = '' then
                  DDString := FScannedDrugIEN + '^' + IntToStr(FUnitsPerDose)
                else
                  DDString := DDString + '^' + FScannedDrugIEN + '^' +
                    IntToStr(FUnitsPerDose);
              end;

              if FScannedDrugType = 'ADD' then begin
                addCount := addCount + 1;
                if ADDString = '' then
                  ADDString := FAdditiveIEN
                else
                  ADDString := ADDString + '^' + FAdditiveIEN;
              end;
              if FScannedDrugType = 'SOL' then begin
                solCount := solCount + 1;
                if SOLString = '' then
                  SOLString := FSolutionIEN
                else
                  SOLString := SOLString + '^' + FSolutionIEN;
              end;
            end;

          add(IntToStr(ddCount));
          add(DDString);
          add(IntToStr(addCount));
          add(ADDString);
          add(IntToStr(solCount));
          add(SOLString);
          add(FInjectionSite);
//          add(FBodySite); ????
          add(BCMA_User.InstructorDUZ);
        end;
      end;
    end;
  if (FRPCBroker <> nil) then
    with FRPCBroker do
      if CallServer('PSB CPRS ORDER', [CmdString], MultList) then
        if Results[0] = '-1' then

end;

procedure TBCMA_OMMedOrder.GetSolAddStr(var SolutionList, AdditiveList:
  WideString);
var
  Solutions,
    Additives: WideString;
  x: integer;
begin
  Solutions := '';
  Additives := '';
  AdditiveList := '';
  SolutionList := '';
  for x := 0 to FScannedMeds.Count - 1 do begin
    if TBCMA_OMScannedMeds(FScannedMeds[x]).FScannedDrugType = 'ADD' then
      if AdditiveList = '' then
        AdditiveList := TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN
      else
        AdditiveList := AdditiveList + '^' +
          TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN
    else if TBCMA_OMScannedMeds(FScannedMeds[x]).FScannedDrugType = 'SOL' then
      if SolutionList = '' then
        SolutionList := TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN +
          ';' + piece(TBCMA_OMScannedMeds(FScannedMeds[x]).FVolume, ' ', 1)
      else
        SolutionList := SolutionList + '^' +
          TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN +
          ';' + piece(TBCMA_OMScannedMeds(FScannedMeds[x]).FVolume, ' ', 1)
  end;
end;

constructor TBCMA_PRNEffectList.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;
  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;
  FDispensedDrugs := TStringList.Create;
  FAdditives := TStringList.Create;
  FSolutions := TStringList.Create;
  FSIOPIList := TStringList.Create;     // rpk 1/6/2012
  Clear;
end;

destructor TBCMA_PRNEffectList.Destroy;
begin
  FRPCBroker := nil;
  Clear;
  FDispensedDrugs.Free;
  FAdditives.Free;
  FSolutions.Free;
  FSIOPIList.Free;                      // rpk 1/6/2012

  inherited Destroy;
end;

procedure TBCMA_PRNEffectList.Clear;
begin
  FMedLogIEN := '';
  FPatientLocation := '';
  FAdminDateTime := '';
  FAdministeredBy := '';
  FAdministeredMed := '';
  FPRNReason := '';
  FUnitsGiven := '';
  FSpecialInstructions := '';
  FOrderableItemIEN := '';
  FOrderNumber := '';
  FRequirePainScore := 0;

  FDispensedDrugs.Clear;
  FAdditives.Clear;
  FSolutions.Clear;
  FSIOPIList.Clear;                     // rpk 1/6/2012
end;

procedure TBCMA_PRNEFFectList.setSIOPIList(newValue: TStringList); // rpk 11/09/2011
begin
  if (FRPCBroker <> nil) and (FSIOPIList <> nil) then // rpk 1/6/2012
    if newValue.Text <> FSIOPIList.Text then begin
      FSIOPIList.Assign(newValue);
    end;
end;

procedure TBCMA_PRNEffectList.SetSIOPIMemo(memo: TMemo);
begin
  // if unlimited string list is non-empty, use it.
  if SIOPIList.Text > '' then
    memo.Lines.Assign(SIOPIList)
  else
    // otherwise, use the original string field.
    memo.Text := SpecialInstructions;
end;

procedure TBCMA_EditMedLog.LoadAdministration(MLIEN: string);
var
  MultList: TStringList;
  x: integer;
  bodystr, bodysitestr, bodycodestr: string;
begin
  MultList := TStringList.Create;
  with MultList do begin
    Add('SELECTAD');
    Add(MLIEN);
  end;
  frmMain.StatusBar.Panels[0].Text := 'Retrieving Administrations...';
  frmMain.StatusBar.Repaint;

  if (BCMA_Broker <> nil) then
    with BCMA_Broker do
      if CallServer('PSB MED LOG LOOKUP', ['~!#null#~!'], MultList) then
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0],
          -1)) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if piece(Results[1], '^', 1) = '-1' then
          DefMessageDlg(piece(Results[1], '^', 2), mtInformation, [mbOK], 0)
        else begin
          x := 1;
          while x <= results.Count - 1 do
            with BCMA_EditMedLog do begin
              Clear;
              FMLIEN := piece(Results[x], '^', 1);
              FPatientIEN := piece(Results[x], '^', 2);
              FPatientName := piece(Results[x], '^', 3);
              FSSN := piece(Results[x], '^', 4);
              FOrderableItem := piece(piece(Results[x], '^', 5), '~', 2);
              FOrderableItemIEN := piece(piece(Results[x], '^', 5), '~', 1);
              FBagID := piece(Results[x], '^', 6);
              FScanStatus := piece(Results[x], '^', 7);
              FOriginalScanStatus := FScanStatus;
              FAdminDateTime := piece(Results[x], '^', 8);
              FMAdminDateTime := piece(Results[x], '^', 9);
              bodystr := piece(Results[x], '^', 10);
              bodysitestr := piece(bodystr, '|', 1);
              bodycodestr := piece(bodystr, '|', 2);
              if bodycodestr = 'I' then
                FInjectionSite := bodysitestr
              else if bodycodestr = 'D' then begin
                FDermalSite := bodysitestr;
                fIsMrr := True;
              end;
              FBodySite := bodysitestr;
              FTab := piece(Results[x], '^', 11);
              //FPRNEffectiveness := piece(Results[x], '^', 12);
              FScheduleType := piece(Results[x], '^', 13);
              FOrderStatus := UpperCase(piece(Results[x], '^', 14));
              FOrderNumber := piece(Results[x], '^', 15);
              FPatchBag := (piece(Results[x], '^', 16) = '1');
              inc(x);

              FPRNReason := piece(Results[x], '^', 1);
              FPRNEffectiveness := piece(Results[x], '^', 2);
              inc(x);
              while x <= results.Count - 1 do begin
                if piece(results[x], '^', 1) = 'DD' then
                  FDispensedDrugs.Add(results[x])
                else if piece(results[x], '^', 1) = 'SOL' then
                  FSolutions.Add(results[x])
                else if piece(results[x], '^', 1) = 'ADD' then
                  FAdditives.Add(results[x]);
                inc(x);
              end;
            end;
        end;
  frmMain.StatusBar.Panels[0].Text := '';
end;

destructor TBCMA_EditMedLog.Destroy;
begin
  clear;
  FRPCBroker := nil;
  FDispensedDrugs.Free;
  FSolutions.Free;
  FAdditives.Free;
  inherited Destroy;
end;

constructor TBCMA_EditMedLog.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;
  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;
  FDispensedDrugs := TStringList.Create;
  FAdditives := TStringList.Create;
  FSolutions := TStringList.Create;

end;

procedure TBCMA_EditMedLog.Clear;
begin
  FMLIEN := '';
  FPatientIEN := '';
  FPatientName := '';
  FSSN := '';
  FOrderableItem := '';
  FOrderableItemIEN := '';
  FBagID := '';
  FScanStatus := '';
  FOriginalScanStatus := '';
  FAdminDateTime := '';
  FMAdminDateTime := '';
  FInjectionSite := '';
  FDermalSite := '';
  FBodySite := '';
  FPRNReason := '';
  FPRNEffectiveness := '';
  FScheduleType := '';
  FOrderStatus := '';
  FOrderNumber := '';
  FPatchBag := False;
  fIsMrr := False;
  FDispensedDrugs.Clear;
  FSolutions.Clear;
  FAdditives.Clear;
  FComment := '';
  FTab := '';
end;

procedure TBCMA_EditMedLog.LogEditedOrder;
var
  MultList: TStringlist;
  cmdString: string;
  x: integer;
begin
  MultList := TStringList.Create;
  cmdString := FMLIEN + '^EDIT';
  with MultList do begin
    Add(FScanStatus);
    Add(FPatientIEN);
    if FDermalSite > '' then            // rpk 11/19/2015
      add(FDermalSite + '|D')           // rpk 11/19/2015
    else if FInjectionSite > '' then    // rpk 11/19/2015
      add(FInjectionSite + '|I')        // rpk 11/19/2015
    else
      add('');
    Add(FBagID);
    Add(FMAdminDateTime);
    Add(FPRNReason);
    Add(StripString(FPRNEffectiveness));
    Add(StripString(FComment));

    // Dispensed drug pieces:
    // 1: DD
    // 2: IEN
    // 3: Name
    // 4: Units Ordered
    // 5: Units Given
    // 6: Units
    // 7: Witness
    // 8: Removal Status
    for x := 0 to FDispensedDrugs.Count - 1 do
      // was: DD, IEN, Units ordered, Units given, Units
//      Add(pieces(FDispensedDrugs[x], '^', 1, 2) + '^' +
//        pieces(FDispensedDrugs[x], '^', 4, 6));
      // now all pieces: DD, IEN, Drug Name, Units ordered, Units given, Units, Witness, Removal Status
//      Add(FDispensedDrugs[x]);          // rpk 3/10/2016
      // now all pieces except Drug Name: DD, IEN, Units ordered, Units given, Units, Witness, Removal Status
      Add(pieces(FDispensedDrugs[x], '^', 1, 2) + '^' +
        pieces(FDispensedDrugs[x], '^', 4, 8)); // rpk 4/18/2016

    for x := 0 to FAdditives.Count - 1 do
      Add(pieces(FAdditives[x], '^', 1, 2) + '^' + pieces(FAdditives[x], '^', 4,
        6));

    for x := 0 to FSolutions.Count - 1 do
      Add(pieces(FSolutions[x], '^', 1, 2) + '^' + pieces(FSolutions[x], '^', 4,
        6));

    if FRPCBroker <> nil then
      with FRPCBroker do
        if CallServer('PSB TRANSACTION', [cmdString + '^' +
          BCMA_User.InstructorDUZ], MultList) then begin
          if (Results.Count = 0) or (Results.Count - 1 <>
            StrToIntDef(Results[0],
            -1)) then
            DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
          else if piece(Results[1], '^', 1) = '-1' then
            DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
          else
            //showmessage('filed it');
        end;
  end;
end;                                    // LogEditedOrder

function TBCMA_EditMedLog.getScheduleTypeID: TScheduleTypes;
var
  id: TScheduleTypes;
begin
  Result := stNone;                     // rpk 4/6/2009

  if FRPCBroker <> nil then
    for id := low(ScheduleTypeCodes) to high(ScheduleTypeCodes) do
      if ScheduleTypeCodes[id] = FScheduleType then begin
        result := id;
        break;
      end;
end;

function TBCMA_EditMedLog.getAdminStatusID: TScanStatus;
var
  id: TScanStatus;
begin
  Result := ssUnknown;                  // rpk 4/6/2009

  for id := low(ScanStatusCodes) to high(ScanStatusCodes) do
    if ScanStatusCodes[id] = ScanStatus then begin
      result := id;
      break;
    end;
end;

function TBCMA_EditMedLog.getIsPatch: Boolean;
var
  x: integer;
begin
  Result := False;
  if FDispensedDrugs.Count = 0 then
    exit;
  for x := 0 to FDispensedDrugs.Count - 1 do
    if piece(FDispensedDrugs[x], '^', 6) = 'PATCH' then begin
      Result := True;
      exit;
    end;
end;

function TBCMA_EditMedLog.getIsMRR: Boolean;
begin
  Result := fisMRR or ((RemovalStatus <> '') and (RemovalStatus <> '0'));
end;

procedure TBCMA_TimerHandler.TimerEvent(Sender: TObject);
begin
  KeyedBarCode := True;
  KeyBoardTimer.Enabled := False;
end;

/////////////// TBCMA_Patient Object ////////////////////////


function TBCMA_DispensedDrug.MapIEN(scanIEN: string): string;
var
  ii, jj, kk, Rslt: integer;
  AddList, SolList, DDList, NewResults, Add2List, Sol2List, DD2List:
  TStringList;
  Dlg: TForm;
  tmpString: string;
begin
  Clear;
  Add2List := nil;                      // rpk 4/6/2009
  Sol2List := nil;                      // rpk 4/6/2009
  DD2List := nil;                       // rpk 4/6/2009

  AddList := TStringList.Create;
  SolList := TStringList.Create;
  DDList := TStringList.Create;
  NewResults := TStringList.create;

  if FRPCBroker <> nil then
    with FRPCBroker do
      if CallServer('PSB SCANMED', [scanIEN,
        lstUnitDoseCurrentTab[lstCurrentTab]], nil) then
        if Results.Count - 1 <> StrToInt(Results[0]) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if piece(Results[1], '^', 1) = '-1' then
          DefMessageDlg(piece(Results[1], '^', 2) + #13#13 + 'DO NOT GIVE!!',
            mtError, [mbOK], 0
{$IFDEF R1224198}                       //bjr - INC1224198 - 6/2/2015
            , '', True
{$ENDIF}
            )
        else if StrToInt(Results[0]) > 0 then begin

          {rule out any drugs returned that aren't on current tab}

          //get all add, sol, dd's from VisibleMedList
          with VisibleMedList do
            for jj := 0 to VisibleMedList.count - 1 do
              with TBCMA_MedOrder(VisibleMedList[jj]) do begin
                for kk := 0 to FOrderedDrugIENs.count - 1 do
                  DDList.Add(FOrderedDrugIENs[kk]);
                for kk := 0 to FSolutions.Count - 1 do
                  SolList.Add(piece(FSolutions[kk], '^', 2));
                for kk := 0 to FAdditives.count - 1 do
                  AddList.Add(piece(Additives[kk], '^', 2));
              end;

          //loop thru all returned drugs and
          //see if they are contained in any orders.
          Add2List := TStringList.Create;
          Sol2List := TStringList.Create;
          DD2List := TStringList.Create;
          for ii := 1 to Results.Count - 1 do begin
            tmpString := Piece(Results[ii], '^', 1);
            if tmpString = 'DD' then
              if DDlist.IndexOf(piece(Results[ii], '^', 2)) > -1 then
                DD2List.Add(Results[ii]);

            if tmpString = 'SOL' then
              if SOLlist.IndexOf(piece(Results[ii], '^', 2)) > -1 then
                SOL2List.Add(Results[ii]);

            if tmpString = 'ADD' then
              if ADDlist.IndexOf(piece(Results[ii], '^', 2)) > -1 then
                Add2List.Add(Results[ii]);
          end;

          AddList.free;
          SolList.free;
          DDList.free;

          if ((DD2List.Count > 0) and ((Add2List.Count > 0) or (Sol2List.Count >
            0))) then begin
            {if a wardstock order is in process, skip the following and ignore the Unit Dose drugs (DD's)}
            if frmMain.WardStockInProc = false then begin
              Dlg :=
                CreateMessageDialog('The medication scanned matches a Unit Dose and an IV Piggyback order.'
                + #13#13 +
                'Do you wish to administer the Unit Dose medication or create a ward stock entry?',
                mtConfirmation, [mbYes, mbNo]);

              TButton(Dlg.FindComponent('Yes')).Caption := '&Unit Dose';
              TButton(Dlg.FindComponent('No')).Caption := '&Ward Stock';

              Rslt := Dlg.ShowModal;
            end
            else
              Rslt := 7;

            case Rslt of
              mrYes:                    {Treat as Unit Dose}
                NewResults.Assign(DD2List);
              mrNo: {Treat as Piggyback Ward Stock} begin
                  NewResults.Assign(SOL2List);
                  NewResults.AddStrings(ADD2List);
                end
            end;
          end
          else begin
            NewResults.Assign(DD2List);
            NewResults.AddStrings(Add2List);
            NewResults.AddStrings(SOL2List);
          end;

          if NewResults.Count = 0 then
            {JK 7/8/2008 - CQ #102}
            DefMessageDlg('Invalid medication lookup.' + #13#10#13#10 +
              'DO NOT GIVE!', mtError, [mbOK], 0
{$IFDEF R1224198}                       //bjr - INC1224198 - 6/2/2015
              , '', True
{$ENDIF}
              );

          if NewResults.Count = 1 then begin
            FIEN := piece(Newresults[0], '^', 2);
            FName := piece(Newresults[0], '^', 3);
            FDose := piece(Newresults[0], '^', 4);
            FResultString := NewResults[0];
            scanIEN := FIEN;
            FisValidDrug := True;

          end
          else if NewResults.Count > 1 then

            with TfrmMultipleOrderedDrugs.create(application) do try

              for ii := 0 to NewResults.Count - 1 do
                lbxSelectList.items.addObject(piece(NewResults[ii], '^', 3) +
                  ', ' + piece(NewResults[ii], '^', 4), ptr(ii));

              ii := ShowModal;

              if ii <> mrCancel then begin
                jj := ii - 100;
                FIEN := piece(NewResults[jj], '^', 2);
                FName := piece(NewResults[jj], '^', 3);
                FDose := piece(NewResults[jj], '^', 4);
                FResultString := NewResults[jj];
                scanIEN := FIEN;
                FisValidDrug := True;
              end;

            finally
              Release;                  // rpk 6/18/2013
            end;
        end;
  Add2List.free;
  Sol2List.free;
  DD2List.free;
  NewResults.free;

  Result := FIEN;

end;

end.

