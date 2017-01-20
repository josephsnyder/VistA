unit oCoverSheet;

interface
uses
  ComCtrls, ExtCtrls, StdCtrls, oInterfaces, Controls, Classes,
  SysUtils, Dialogs, Math, Grids, VHA_Objects, BCMA_Objects, BCMA_Common;

procedure CreateCoverSheetObject;
function LoadCoverSheetOrders(PIEN: string; Hours: string): string;
procedure ClearCoverSheetOrders;
procedure ClearCoverSheetFlags;
procedure CheckForEditedIVs;
procedure GroupExpandCollapse(GroupNum: Integer);
function SeekListBoxArray(ArrayIn: array of TListBox; ControlIn: TObject):
  Integer;

function CompareAdministrationTimes(Item1, Item2: Pointer): Integer;

type
  TCoverSheet = class(TBaseInterfacedObject, I_Anything)
  public
    function MyNameIs: string;
    procedure CreateMe(aWinControl: TWinControl);
    procedure CloseMe;
    procedure RebuildMe;

    //    function EnableDisplayOrdersMenu: Boolean;
    //    function EnableDisplayMedHistory: Boolean;
    //    function EnableDisplayAvailableBags: Boolean;
  end;

  TCoverSheetViews = (csvMedOverview,
    csvPRNAssessment,
    csvIVOverview,
    csvExpiringOrders);

  //MedOverview Group
  TMedOverviewGroups = (moActive,
    moFuture,
    moExpired);

  //MedOverview Level 1 Columns
  { TMedOverviewColTypes = (
    ctNoActionTaken,
    ctStat,
    ctFlag,
    cClinicName, // rpk 5/14/2012
    ctTAB,
    cStatus,
    cVerifyNurse, // rpk 2/4/2011
    cType,
    cWitness, // rpk 9/11/2012
    cMedication,
    cSchedule,
    cDosage,
    cNextAction,
    cSpecialInstructions,
    csStartDate,
    cStopDate); }

  //MedOverview Level 1 Columns
  TMedOverviewColTypes = (
    ctNoActionTaken,
    ctStat,
    ctFlag,
    cClinicName,                        // rpk 5/14/2012
    ctTAB,
    cStatus,
    cVerifyNurse,                       // rpk 2/4/2011
    cType,
    cWitness,                           // rpk 9/11/2012
    cMedication,
    cDosage,                            // rpk 11/14/2012
    cSchedule,                          // rpk 11/14/2012
    cNextAction,
    cSpecialInstructions,
    csStartDate,
    cStopDate);

  //MedOverview Level 2 Columns
  TMedOverviewColTypeslvl2 = (ctBagID,
    cActionBy,
    cAction,
    cPRNReason,
    cPRNEffectiveness);

  //MedOverview Level 3 Columns
  TMedOverviewColTypeslvl3 = (cCommentby,
    cComment);

  //PRN Assessment Groups
  TPRNGroups = (prnActive,
    prnFuture,
    prnExpired);

  //PRN Assessment Level 1 Columns
  TPRNColTypes = (
    ctPRNStat,
    ctPRNFlag,
    ctPRNClinicName,                    // rpk 5/14/2012
    ctPRNTAB,
    ctPRNStatus,
    ctPRNVerifyNurse,                   // rpk 2/4/2011
    ctPRNWitness,                       // rpk 9/11/2012
    ctPRNMedication,
    ctPRNDosage,                        // rpk 11/14/2012
    ctPRNSchedule,                      // rpk 11/14/2012
    ctPRNLastGiven,
    ctPRNSinceLast,
    ctPRNSpecialInstructions,
    ctPRNStartDate,
    ctPRNStopDate);

  //PRN Assessment Level 2 Columns
  TPRNColTypesLvl2 = (cPRNBagId,
    cPRNActionBy,
    cPRNAction,
    cPRNPRNReason,
    cPRNPRNEffectiveness);

  //PRN Assessment Level 3 Columns
  TPRNColTypesLvl3 = (cPRNCommentBy,
    CPRNComment);

  //IV Overview Groups
  TIVGroups = (IVInfusing,
    IVStopped,
    IVAllOther);

  //IV Overview Level 1 Columns
  TIVColTypes = (
    ctIVNoActionTaken,
    ctIVStat,
    ctIVFlag,
    ctIVClinicName,                     // rpk 5/14/2012
    ctIVBagID,
    ctIVOrderStatus,
    ctIVBagStatus,
    ctIVVerifyNurse,                    // rpk 2/4/2011
    ctIVWitness,                        // rpk 9/11/2012
    ctIVMedication,
    ctIVInfusionRate,
    ctIVOtherPrintInfo,
    ctIVBagInfo,
    ctIVStartDate,
    ctIVStopDate);

  TIVColTypesLvl2 = (ctIVActionDateTime,
    ctIVActionBy,
    ctIVAction,
    ctIVComment);

  //Expired/Expiring Groups
  TExpiredGroups = (exExpired,
    exExpiring,
    exExpiringTomorrow);

  //Expired/Expiring Level 1 Columns
  TExpiredColTypes = (
    ctExNoActionTaken,
    ctExStat,
    ctExFlag,
    ctExClinicName,                     // rpk 5/14/2012
    ctExTab,
    ctExStatus,
    ctExVerifyNurse,                    // rpk 2/4/2011
    ctExType,
    ctExWitness,                        // rpk 9/11/2012
    ctExMedication,
    ctExDosage,
    ctExSchedule,                       // rpk 11/27/2012
    ctExNextAction,
    ctExSpecialInstructions,
    ctExStartDate,
    ctExStopDate);

const
  OneDTMinute       = 1 / (24 * 60);

  CoverSheetViewTitles: array[TCoverSheetViews] of string =
    ('Medication Overview', 'PRN Overview', 'IV Overview',
    'Expired/DC''d/Expiring Orders');

  // default sort on ActiveMedication in each of views for SortCoverSheet
  CoverSheetSortColumns: array[TCoverSheetViews] of integer =
    (ord(cMedication), ord(ctPRNMedication), ord(ctIVMedication),
      ord(ctExMedication));               // rpk 7/5/2012

  MedOverviewGroupTitles: array[TMedOverviewGroups] of string =
    ('Active', 'Future', 'Expired/DC''d');

  {These will effectively control the icon state of the top level item in each group.
  0 implies there no items (hide the icon), 1 = collapsed, 2 = expanded}
  MedOverviewGrpExpanded: array[TMedOverviewGroups] of integer =
    (0, 0, 0);

  MedOverviewColTitles: array[TMedOverviewColTypes] of string =
    ('  ', '  ', '  ', 'Clinic', 'VDL Tab',
    'Status', 'Ver', 'Type',
{$IFDEF CAS_DDPE_RST}
    'Alert',
{$ELSE}
    'Wit',
{$ENDIF}

    'Medication',                       // rpk 9/11/2012
    'Dosage, Route', 'Schedule', 'Next Action',
    'Special Instructions', 'Order Start Date',
    'Order Stop Date');                 // rpk 5/21/2012

  MedOverviewColWidths: array[TMedOverviewColTypes] of integer =
    (35, 20, 20, 45, 45,
    47, 28, 35,
{$IFDEF CAS_DDPE_RST}
    60,
{$ELSE}
    30,                                 // Wit original
{$ENDIF}

    180,
    95, 80, 120,
    145, 90,
    90);                                // rpk 11/14/2012

  MedOverviewColTitleslvl2: array[TMedOverviewColTypeslvl2] of string =
    ('Bag ID', 'Action By', 'Action', 'PRN Reason', 'PRN Effectiveness');

  MedOverviewColTitleslvl3: array[TMedOverviewColTypeslvl3] of string =
    ('Comment By', 'Comment');

  MedOverViewItemIndex: array[TMedOverviewGroups] of integer =
    (-1, -1, -1);

  //PRN Assessment Group Titles
  PRNAGroupTitles   : array[TPRNGroups] of string =
    ('Active', 'Future', 'Expired/DC''d');


  //PRN Assessment Level 1 Column Titles
  PRNAColTitlesLvl1 : array[TPRNColTypes] of string =
    ('  ', '  ', 'Clinic', 'VDL Tab', 'Status',
    'Ver', 'Wit', 'Medication', 'Dosage, Route', 'Schedule', // rpk 9/11/2012
    'Last Given', 'Since Last Given',
    'Special Instructions', 'Order Start Date', 'Order Stop Date');

  PRNAColWidths     : array[TPRNColTypes] of integer =
    (35, 20, 45, 45, 47,
    28, 30, 180, 85, 95,                // rpk 11/14/2012
    95, 95, 130, 90, 90);               // rpk 5/14/2012

  //PRN Assessment Level 2 Column Titles
  PRNAColTitlesLvl2 : array[TPRNColTypesLvl2] of string =
    ('Bag ID', 'Action By', 'Action', 'PRN Reason', 'PRN Effectiveness');

  //PRN Assessment Level 3 Column Titles
  PRNAColTitlesLvl3 : array[TPRNColTypesLvl3] of string =
    ('Comment By', 'Comment');

  PRNAGrpExpanded   : array[TPRNGroups] of integer =
    (0, 0, 0);

  //IV Overview Group Titles
  IVOGroupTitles    : array[TIVGroups] of string =
    ('Infusing', 'Stopped', 'All Other');

  //IV Overview Level 1 Column Titles
  IVOColTitlesLvl1  : array[TIVColTypes] of string =
    ('  ', '  ', '  ', 'Clinic', 'Bag ID', // rpk 5/14/2012
    'Order Status', 'Bag Status', 'Ver', ' Wit', 'Medication',
    'Infusion Rate', 'Other Print Info', 'Bag Info', 'Order Start Date',
      'Order Stop Date');

  IVColWidths       : array[TIVColTypes] of integer =
    (35, 20, 20, 45, 75,
    70, 68, 28, 30, 190,                // rpk 9/11/2012
    100, 140, 105, 90, 90);             // rpk 5/14/2012

  IVColTitlesLvl2   : array[TIVColTypesLvl2] of string =
    ('Date/Time', 'By', 'Action', 'Comment');

  IVOGrpExpanded    : array[TIVGroups] of integer =
    (0, 0, 0);

  //Expired/Expiring Group Titles
  ExGroupTitles     : array[TExpiredGroups] of string =
    ('Expired/DC''d within last 24 hours', 'Expiring Today',
    'Expiring within next 72 hours (after Midnight tonight)');

  //Expired/Expiring Level 1 Column Titles
  ExColTitlesLvl1   : array[TExpiredColTypes] of string =
    ('  ', '  ', '  ', 'Clinic', 'VDL Tab',
    'Status', 'Ver', 'Type', 'Wit', 'Medication',
    'Dosage, Route', 'Schedule', 'Next Action',
    'Special Instructions', 'Order Start Date', // rpk 11/27/2012
    'Order Stop Date');                 // rpk 5/21/2012

  ExGrpExpanded     : array[TExpiredGroups] of integer =
    (0, 0, 0);

  ExColWidths       : array[TExpiredColTypes] of integer =
    (35, 20, 20, 45, 45,
    65, 28, 30, 30, 165,                // rpk 9/11/2012
    100, 100, 120, 125, 90,
    90);                                // rpk 5/14/2012

  // allow for possible null value in FTab from PSB COVERSHEET1
  VDLTabText        : array[0..3] of string = ('?', 'UD', 'IVP/IVPB', 'IV');

  PSBSIOPI_WP       = '1';              // rpk 1/10/2012
  CSWITNESS_IDX     = 5;                // rpk 9/11/2012

type
  TCoversheet_Order = class(TObject)
    (*
      Contains information about a Medication Order for a Patient.
    *)
  private
    FRPCBroker: TBCMA_Broker;
{$IFDEF CAS_DDPE_DEBUG}
    FRaw,
{$ENDIF}
{$IFDEF CAS_DDPE_RST}
    FRemovalStatus,
      FRemovalDateTime,
{$ENDIF}
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
      FTimeLastAction,
      FTimeLastGiven,
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
      FNurseIEN, //this is the IEN for the nurse that took the last action
    //on this administration only.
    FWitnessFlag,
      FOrderTransferred,
      FStopDateTime,
      FTab,
      FNextDue,
      FFlaggedText,
      FClinicName,                      // rpk 5/14/2012
      FClinicIEN: string;               // rpk 11/26/2012

    FInjectionSiteNeeded,
      FVariableDose,
      FWardStock,
      FDisplayInstructions,
      FEditedOrder,
      FNoActionTaken,
      FStat,
      FFlagged,
      FOvrIntvent: Boolean; // provider / pharmacist override / intervention rpk 2/4/2011

    {0 = None (do not expand, no Image), 1 = Collapsed, 2 = Expanded}
    FExpanded: Integer;

    FOrderedDrugIENs,
      FOrderedDrugNames,
      FOrderedDrugUnits,
      FUnitsGiven,
      FSolutions,
      FAdditives,
      FUniqueIDs,
      FLastFourActions, //if this is a PRN, this will contain the last four actions when validated.
      FOrderChangedData,
      FSIOPIList: TStringList;          // rpk 1/4/2012

    FAdministrations: TList;            //Pointers to all administrations
    FAdministrationsWithAction: TList;
      //Pointers to all administrations with actions

    FReasonGivenPRN,
      FUserComments,
      FUserComments2,
      FInjectionSite: string;

    FStatus: integer;
    FStatusMessage: string;
    FAction: string;
      //Action user is attempting to take (we won't have this in all cases)

  protected
    function getScheduleTypeID: TScheduleTypes;
    function getNextAdminDateTime: string;
    function getSinceLast: string;
    function getChanged: string;
    procedure setSIOPIList(newValue: TStringList); // rpk 1/4/2012
  public
    property PatientIEN: string read FPatientIEN;

    property OrderNumber: string read FOrderNumber;
    property OrderIEN: string read FOrderIEN;
    property OrderType: string read FOrderType;

    property ScheduleType: string read FScheduleType;
    property Schedule: string read FSchedule;
    property ScheduleTypeID: TScheduleTypes read getScheduleTypeID;

    property SelfMed: string read FSelfMed;

    property ActiveMedication: string read FActiveMedication;
    property Dosage: string read FDosage;
    property Route: string read FRoute;

    property TimeLastGiven: string read FTimeLastGiven;
    property TimeLastAction: string read FTimeLastAction;
    property LastActivityStatus: string read FLastActivityStatus;
    property StartDateTime: string read FStartDateTime;
    property StopDateTime: string read FStopDateTime;
    property OrderStatus: string read FOrderStatus;

    property VerifyNurse: string read FVerifyNurse;
    property MedLogIEN: string read FMedLogIEN;
    property ScanStatus: string read FScanStatus;

    property AdministrationTime: string read FAdministrationTime;

    property OrderableItemIEN: string read FOrderableItemIEN;

    property ClinicName: string read FClinicName; // rpk 5/14/2012
    property ClinicIEN: string read FClinicIEN; // rpk 11/26/2012

    property InjectionSiteNeeded: boolean read FInjectionSiteNeeded;
    property VariableDose: boolean read FVariableDose;
    property WardStock: boolean read FWardStock;
    property DisplayInstructions: boolean read FDisplayInstructions;
    property EditedOrder: Boolean read FEditedOrder;
    property NoActionTaken: Boolean read FNoActionTaken;
    property Stat: Boolean read FStat;
    property Flagged: Boolean read FFlagged;
    property OvrIntvent: Boolean read FOvrIntvent;  // provider / pharmacist override / intervention rpk 2/4/2011

    property Expanded: Integer read FExpanded write FExpanded;
    property AdministrationUnit: string read FAdministrationUnit;

    property SpecialInstructions: string read FSpecialInstructions;
    property SIOPIList: TStringList read FSIOPIList write setSIOPIList;  // rpk 1/4/2012
    property VDLTab: string read FTab;
    property NextDue: string read FNextDue;
    property FlaggedText: string read FFLaggedText;

    property OrderedDrugIENs: TStringList read FOrderedDrugIENs;
    property OrderedDrugNames: TStringList read FOrderedDrugNames;
    property OrderedDrugUnits: TStringList read FOrderedDrugUnits;
    property UnitsGiven: TStringList read FUnitsGiven;

    property Solutions: TStringList read FSolutions;
    property Additives: TStringList read FAdditives;
    property UniqueIDs: TStringList read FUniqueIDs;
    property LastFourActions: TStringList read FLastFourActions;
    property OrderChangedData: TStringList read FOrderChangedData;

    property ReasonGivenPRN: string read FReasonGivenPRN write FReasonGivenPRN;
    property UserComments: string read FUserComments write FUserComments;
    property UserComments2: string read FUserComments2 write FUserComments2;
    property InjectionSite: string read FInjectionSite write FInjectionSite;

    property Status: integer read FStatus;
    property StatusMessage: string read FStatusMessage;
    property Action: string read FAction write FAction;

    property UniqueID: string read FUniqueID;
    property NurseIEN: string read FNurseIEN;
    property WitnessFlag: string read FWitnessFlag write FWitnessFlag;  // rpk 9/11/2012
    property OrderTransferred: string read FOrderTransferred;
    property Administrations: Tlist read FAdministrations;
    property AdministrationsWithAction: Tlist read FAdministrationsWithAction;
    property NextAdminDateTime: string read GetNextAdminDateTime;
    property SinceLast: string read GetSinceLast;
    property Changed: string read GetChanged;

{$IFDEF CAS_DDPE_DEBUG}
    property Raw: string read fRaw;
{$ENDIF}

{$IFDEF CAS_DDPE_RST}
    property RemovalStatus: string read fRemovalStatus;
    property RemovalDateTime: string read FRemovalDateTime;

    function getLastOrderAction: string;
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
    ///
    ///  Display special instructions / other print info found in SpecialInstructions
    ///  string (old format) or SIOPIList (new format - word processing field)
    ///
    function DisplaySIOPI(CancelOn: Boolean): Boolean; // rpk 11/9/2011
    function GetSIOPIText: string;      // rpk 1/4/2012
    procedure SetSIOPIMemo(memo: TMemo); // rpk 1/4/2012

  end;

type
  TCoversheet_Admin = class(TObject)
  private
    FRPCBroker: TBCMA_Broker;

    FAdminDateTime,
      FBagID,
      FMedLogIEN,
      FAction,
      FActionDateTime,
      FActionByInitials,
      FActionByIEN,
      FPRNReason,
      FPRNEffectComment: string;
    FComments: Tlist;

    FExpanded,
      FIVExpanded: Integer;
    //    FOrder: TObject;
    FOrder: TCoverSheet_Order;
    FBagDetail: TStringList;

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    property BagID: string read FBagID;
    property AdminDateTime: string read FAdminDateTime;
    property Action: string read FAction;
    property ActionDateTime: string read FActionDateTime;
    property ActionByInitials: string read FActionByInitials;
    property Comments: Tlist read FComments;

    {0 = None (do not expand, no Image), 1 = Collapsed, 2 = Expanded}
    property Expanded: Integer read FExpanded write FExpanded;
    property IVExpanded: integer read FIVExpanded write FIVExpanded;
    property PRNReason: string read FPRNReason;
    property PRNEffectComment: string read FPRNEffectComment;
    property Order: TCoverSheet_Order read FOrder;
    property BagDetail: TStringList read FBagDetail;

    procedure FetchIVBagDetail;
  end;

  TCoversheet_Comment = class(TObject)
  private
    FRPCBroker: TBCMA_Broker;

    FComment,
      FPRNComment,
      FActionByIEN,
      FActionByInitials,
      FActionDateTime: string;
    //      FScheduledAdmin: string;

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    property Comment: string read FComment;
    property PRNComment: string read FPRNComment;
    property ActionByIEN: string read FActionByIEN;
    property ActionByInitials: string read FActionByInitials;
    property ActionDateTime: string read FActionDateTime;
  end;

var
  pnlMOGroupPanels  : array[0..Length(MedOverviewGroupTitles) - 1] of TPanel;
  hdrMOGroupHeaders : array[0..Length(MedOverviewGroupTitles) - 1] of
    THeaderControl;
  lstMOGroupBoxes   : array[0..Length(MedOverviewGroupTitles) - 1] of TListBox;
  imgMOGroupImages  : array[0..Length(MedOverviewGroupTitles) - 1] of TImage;

  pnlPRNGroupPanels : array[0..Length(PRNAGroupTitles) - 1] of TPanel;
  hdrPRNGroupHeaders: array[0..Length(PRNAGroupTitles) - 1] of THeaderControl;
  lstPRNGroupBoxes  : array[0..Length(PRNAGroupTitles) - 1] of TListBox;
  imgPRNGroupImages : array[0..Length(PRNAGroupTitles) - 1] of TImage;

  pnlIVGroupPanels  : array[0..Length(IVOGroupTitles) - 1] of TPanel;
  hdrIVGroupHeaders : array[0..Length(IVOGroupTitles) - 1] of THeaderControl;
  lstIVGroupBoxes   : array[0..Length(IVOGroupTitles) - 1] of TListBox;
  imgIVGroupImages  : array[0..Length(IVOGroupTitles) - 1] of TImage;

  pnlExGroupPanels  : array[0..Length(ExGroupTitles) - 1] of TPanel;
  hdrExGroupHeaders : array[0..Length(ExGroupTitles) - 1] of THeaderControl;
  lstExGroupBoxes   : array[0..Length(ExGroupTitles) - 1] of TListBox;
  imgExGroupImages  : array[0..Length(ExGroupTitles) - 1] of TImage;

  GroupBoxIndexes   : array[0..Length(CoverSheetViewTitles) - 1] of TList;

  grdCellData       : array[0..2] of TStringGrid;

  lstMOGroupBoxesHeight: array[0..Length(MedOverviewGroupTitles) - 1] of
    Integer;
  lstPRNGroupBoxesHeight: array[0..Length(PRNAGroupTitles) - 1] of Integer;
  lstIVGroupBoxesHeight: array[0..Length(IVOGroupTitles) - 1] of Integer;
  lstExGroupBoxesHeight: array[0..Length(ExGroupTitles) - 1] of Integer;

  BCMA_CoverSheet   : TBaseInterfacedObject;
  PIEN              : string;

implementation

uses
  BCMA_Startup,
  BCMA_Util,
  fCoverSheet,
  BCMA_main,
//  MFunStr,
  DateUtils;

procedure CreateCoverSheetObject;
begin
  BCMA_CoverSheet := TCoverSheet.Create;
end;

procedure ProcessORFRecords(DataIn: string);
begin
  with TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count - 1]) do
  begin
    if Piece(DataIn, '^', 2) = 'NOX' then
      FNoActionTaken := True
    else if Piece(DataIn, '^', 2) = 'CPRS' then
    begin
      FFlaggedText := Piece(DataIn, '^', 3) + ' - ' + Piece(DataIn, '^', 4);
      FFlagged := True;
    end
    else if Piece(DataIn, '^', 2) = 'STAT' then
      FStat := True;
  end
end;

function LoadCoverSheetOrders(PIEN: string; Hours: string): string;
var
  ii                : integer;
  lstidx            : Integer;          // rpk 1/4/2012
  rr, tempPiece     : string;
  resultscnt        : Integer;          // rpk 4/29/2009
  ResultList        : TStringList;      // rpk 4/29/2009
  aCoverSheetOrder  : TCoverSheet_Order; // rpk 1/4/2012
  ordermodestr      : string;           // rpk 5/17/2012
  witness_str       : string;           // rpk 9/11/2012
//  StartDate: TDate;                     // rpk 1/18/2013
//  StopDate: TDate;                      // rpk 1/18/2013
//  TodayDate: TDate;                     // rpk 1/18/2013
//  TodayDateBefore: TDate;               // rpk 1/18/2013
  StartDateTimeDT   : TDateTime;        // rpk 2/1/2013
  StopDateTimeDT    : TDateTime;        // rpk 2/1/2013
  TodayDateTime     : TDateTime;        // rpk 1/18/2013
//  TodayDateTimeMinBefore: TDateTime;    // rpk 1/18/2013
  TodayDateTimeSrvVar: TDateTime;       // rpk 7/11/2016
  todaydtstr, todaydtsvstr, startdtstr, stopdtstr: string;
{$IFDEF CAS_DDPE_DEBUG}
  rrRaw             : string;
{$ENDIF}
begin
  ClearCoverSheetOrders;
  aCoverSheetOrder := nil;              // rpk 3/28/2012
  // Use ResultList and resultscnt for outer list returned by PSB COVERSHEET1.
  // Results will be overwritten by list returned by GetComments
  ResultList := TStringList.Create;

  // OrderMode = 0 for Inpatient; 1 for Clinic
  if OrderMode = omClinic then          // rpk 7/12/2012
    Hours := '';
  ordermodestr := IntToStr(ord(OrderMode)); // rpk 4/25/2012

  frmMain.StatusBar.Panels[0].Text := 'Retrieving Coversheet Data...';
  frmMain.StatusBar.Repaint;

  if (BCMA_Broker <> nil) and (CoverSheetOrders <> nil) then
    with BCMA_Broker do
//      if CallServer('PSB COVERSHEET1', [PIEN, Hours], nil) then
//      if CallServer('PSB COVERSHEET1', [PIEN, Hours, PSBSIOPI_WP], nil) then // rpk 1/10/2012
      if CallServer('PSB COVERSHEET1', [PIEN, Hours, PSBSIOPI_WP, ordermodestr],
        nil) then                         // rpk 5/17/2012
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0],
          -1)) then begin
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
          if Results.Count > 1 then
            BCMA_Patient.setshp(Results[1]); // rpk 7/30/2012
        end
        else if (results.Count > 1) and
          (piece(Results[1], '^', 4) = '-1') then begin
          Result := piece(Results[1], '^', 5);
          BCMA_Patient.setshp(Results[1]); // rpk 7/12/2012
        end
        else
          with CoverSheetOrders do
          begin
{$IFDEF CAS_DDPE_DEBUG}
            rrRaw := '';
{$ENDIF}
            ii := 2;
            resultscnt := Results.Count; // rpk 4/29/2009
            ResultList.Assign(Results); // rpk 4/29/2009

            BCMA_Patient.setshp(Results[1]);
            //            while ii <= results.Count - 1 do
            while ii <= resultscnt - 1 do begin // rpk 4/29/2009
              //              begin
              //                rr := Results[ii];
              rr := ResultList[ii];
{$IFDEF CAS_DDPE_DEBUG}
              rrRaw := rrRaw + rr + #13#10; ;
{$ENDIF}

              tempPiece := UpperCase(piece(rr, '^', 1));
              if tempPiece = 'ORD' then begin
//                add(TCoverSheet_Order.create(BCMA_Broker));
//                with TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count - 1]) do
                lstidx := add(TCoverSheet_Order.create(BCMA_Broker));  // rpk 1/4/2012
                aCoversheetOrder := TCoverSheet_Order(CoversheetOrders[lstidx]);  // rpk 1/4/2012
                with aCoverSheetOrder do begin // rpk 1/4/2012
                  FPatientIEN := piece(rr, '^', 2);
                  FOrderNumber := piece(rr, '^', 3);
                  FOrderIEN := piece(rr, '^', 4);
                  FOrderType := piece(rr, '^', 5);
                  FScheduleType := piece(rr, '^', 6);
                  FSchedule := piece(rr, '^', 7);
                  FSelfMed := piece(rr, '^', 8);

                  ///
                  ///  Debug
                  ///
                  ///  removed RPK 3/1/2013
//                  if FSelfMed = '' then
//                    FSelfMed := 'HSM';

                  FActiveMedication := piece(rr, '^', 9);
                  FDosage := Trim(piece(rr, '^', 10));
                  FRoute := piece(rr, '^', 11);
                  FTimeLastAction := piece(rr, '^', 12);
                  FMedLogIEN := piece(rr, '^', 13);
                  FScanStatus := uppercase(piece(rr, '^', 14));
                  if FScanStatus = 'ML_STATUS' then
                    FScanStatus := '';
                  if ScheduleTypeID = stContinuous then
                    FAdministrationTime := copy(piece(rr, '^', 15) + '0000', 1,
                      12); (* Have to make sure this has 2 decimal places - wlk *)
                  FOrderableItemIEN := piece(rr, '^', 16);
                  FInjectionSiteNeeded := (piece(rr, '^', 17) = '1');
                  FVariableDose := (piece(rr, '^', 18) = '1');
                  FAdministrationUnit := piece(rr, '^', 19);
                  FVerifyNurse := piece(rr, '^', 20);
                  FLastActivityStatus := uppercase(piece(rr, '^', 21));
                  FStartDateTime := piece(rr, '^', 22);
                  FOrderStatus := UpperCase(piece(rr, '^', 23));

                  FUniqueID := piece(rr, '^', 24);
                  FNurseIEN := piece(rr, '^', 25);
                  FOrderTransferred := piece(rr, '^', 26);
                  FStopDateTime := piece(rr, '^', 27);
                  FTimeLastGiven := piece(rr, '^', 28);
                  FTab := piece(rr, '^', 29);
                  // flag for provider / pharmacist override reason or intervention.
//'ORD^742^7U^7^U^C^Q6H^^VERAPAMIL *HIGH ALERT* INJ,SOLN^1.25 mg/0.5 ml ^IV PUSH^3110526.183129^^^^973^1^0^^***^G^3110526.1827^A^^^0^3111231.24^3110526.183129^2^^0'
                  FOvrIntvent := piece(rr, '^', 30) = '1'; // rpk 7/20/2011
                  // ^31 (IVPB tab usage)
                  //^32 Clinic Name if order is a Clinic Order, else null
                  FClinicName := piece(rr, U, 32); // rpk 5/17/2012
                  FClinicIEN := piece(rr, U, 33); // rpk 11/15/2012
{$IFDEF CAS_DDPE_RST}
                  // shift because of "ORD" in pos 1
                  FRemovalStatus := piece(rr, U, 34 + 1);  // per Greg 4/30/2015 2:40PM
                  FRemovalDateTime := piece(rr, U, 35 + 1);  // per Greg 4/30/2015 2:40PM
{$ENDIF}
                  //
                  // DEBUG ONLY
                  //
//                FClinicName := 'TstClinic';

                  if FTab = '3' then
                    FScheduleType := '';

                  FExpanded := 1;

                  { if (FOrderStatus = 'D') or (FOrderStatus = 'E') or
                    (DateTimeToMDateTime(now +
                    BCMA_SiteParameters.ServerClockVariance) >= FStopDateTime)
                    then begin
                    ExpiredCSOrders.add(TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count - 1]));
                    if FScheduleType = 'P' then
                      PRNAGrpExpanded[TPRNGroups(2)] := 2;
                    if FOrderStatus = 'A' then
                      ForderStatus := 'E';

                  end
                  else if ((FOrderStatus = 'A') or (FOrderStatus = 'H') or
                    (FOrderStatus = 'O')) and
                    (FMDateTimeToDateTime(StrToFloat(FStartDateTime)) <= (now +
                    BCMA_SiteParameters.ServerClockVariance +
                    BCMA_SiteParameters.MinutesBefore * OneDTMinute)) then
                  begin
                    ActiveCSOrders.add(TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count - 1]));
                    if FScheduleType = 'P' then
                      PRNAGrpExpanded[TPRNGroups(0)] := 2;
                  end
                  else if FMDateTimeToDateTime(StrToFloat(FStartDateTime)) > (now
                    + BCMA_SiteParameters.ServerClockVariance +
                    BCMA_SiteParameters.MinutesBefore * OneDTMinute) then
                  begin
                    FutureCSOrders.add(TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count - 1]));
                    if FScheduleType = 'P' then
                      PRNAGrpExpanded[TPRNGroups(1)] := 2;
                  end; }

                  if OrderMode = omInpatient then begin
                    // skip clinic order expired patches which were returned by PSB COVERSHEET1
                    { if ((FAdministrationUnit = 'PATCH') and // rpk 2/20/2013
                      (FScanStatus = 'G') and // rpk 2/20/2013
                      (Trim(FClinicName) > '')) then begin // rpk 2/20/2013
//                       continue // rpk 2/20/2013
                      ;                 // rpk 3/1/2013
                    end }
                    // skip clinic order patches and MRRs
                    if (((FAdministrationUnit = 'PATCH') and (FRemovalStatus =
                      '0')) or            // rpk 10/21/2015
                      ((FRemovalStatus <> '') and (FRemovalStatus <> '0'))) and  // MRR
                      (Trim(FClinicName) > '') then begin
                      ;
                    end
                    // discontinued, discontinued edit, discontinued renewal, or expired  rpk 1/25/2016
                    else if (FOrderStatus = 'D') or
                      (FOrderStatus = 'DE') or // rpk 1/25/2016
                      (FOrderStatus = 'DR') or // rpk 1/25/2016
                      (FOrderStatus = 'E') or
                      (DateTimeToMDateTime(now +
                        BCMA_SiteParameters.ServerClockVariance) >=
                      FStopDateTime) then begin
                      ExpiredCSOrders.add(aCoverSheetOrder);
                      if FScheduleType = 'P' then
                        PRNAGrpExpanded[TPRNGroups(2)] := 2;
                      if FOrderStatus = 'A' then
                        ForderStatus := 'E';
                    end
                    // active, provider hold, on call, renewal
{$IFDEF INC984066}
                  //bjr - INC984066 - 6/2/2015 - add renewal orders to coversheet
//                    else if ((FOrderStatus = 'A') or (FOrderStatus = 'H') or
//                      (FOrderStatus = 'O') or (FOrderStatus = 'R')) and
                    // active, provider hold, on call, renewal, reinstated; rpk 1/25/2016
                    else if ((FOrderStatus = 'A') or (FOrderStatus = 'H') or
                      (FOrderStatus = 'O') or (FOrderStatus = 'R') or
                        (FOrderStatus = 'RE')
                      ) and
{$ELSE}
                    else if ((FOrderStatus = 'A') or (FOrderStatus = 'H') or
                      (FOrderStatus = 'O')) and
{$ENDIF}
                    (FMDateTimeToDateTime(StrToFloat(FStartDateTime)) <= (now +
                      BCMA_SiteParameters.ServerClockVariance +
                      BCMA_SiteParameters.MinutesBefore * OneDTMinute)) then
                        begin
                      ActiveCSOrders.add(aCoverSheetOrder);
                      if FScheduleType = 'P' then
                        PRNAGrpExpanded[TPRNGroups(0)] := 2;
                    end
                    // future
                    else if FMDateTimeToDateTime(StrToFloat(FStartDateTime)) >
                      (now
                      + BCMA_SiteParameters.ServerClockVariance +
                      BCMA_SiteParameters.MinutesBefore * OneDTMinute) then begin
                      FutureCSOrders.add(aCoverSheetOrder);
                      if FScheduleType = 'P' then
                        PRNAGrpExpanded[TPRNGroups(1)] := 2;
                    end;
                  end
                  else begin            // clinic order
                // skip inpatient expired patches which were returned by PSB COVERSHEET1
                    { if ((FAdministrationUnit = 'PATCH') and // rpk 2/20/2013
                      (FScanStatus = 'G') and // rpk 2/20/2013
                      (Trim(FClinicName) = '')) then begin // rpk 2/20/2013
                      ;
                    end }
                    // skip inpatient patches and MRRs
                    if (((FAdministrationUnit = 'PATCH') and (FRemovalStatus =
                      '0')) or            // rpk 10/21/2015
                      ((FRemovalStatus <> '') and (FRemovalStatus <> '0'))) and  // MRR
                      (Trim(FClinicName) = '') then begin
                      ;
                    end
                    else begin
                      // convert (adjusted) datetimes to dates
//                      TodayDateTime := now + BCMA_SiteParameters.ServerClockVariance;
                      TodayDateTime := now; // rpk 7/11/2016
//                      TodayDate := DateOf(TodayDateTime);
//                      TodayDateTimeMinBefore := now +
//                        BCMA_SiteParameters.ServerClockVariance +
//                        (BCMA_SiteParameters.MinutesBefore * OneDTMinute);
                      // For clinic orders, ignore minutes before
                      // expired, active, future based on date/time adjusted for server variance
                      TodayDateTimeSrvVar := now +
                        BCMA_SiteParameters.ServerClockVariance;
//                      TodayDateBefore := DateOf(TodayDateTimeMinBefore); // rpk 7/8/2013
//                      TodayDateBefore := DateOf(TodayDateTime); // rpk 10/23/2015
                      StartDateTimeDT :=
                        FMDateTimeToDateTime(StrToFloat(FStartDateTime));
//                      StartDate := DateOf(FMDateTimeToDateTime(StrToFloat(FStartDateTime)));
//                      StartDate := DateOf(StartDateTimeDT);
                      StopDateTimeDT :=
                        FMDateTimeToDateTime(StrToFloat(FStopDateTime));
//                      StopDate := DateOf(FMDateTimeToDateTime(StrToFloat(FStopDateTime)));
//                      StopDate := DateOf(StopDateTimeDT);
                      todaydtstr := DateTimeToStr(TodayDateTime);
                      todaydtsvstr := DateTimeToStr(TodayDateTimeSrvVar);
                      startdtstr := DateTimeToStr(StartDateTimeDT);
                      stopdtstr := DateTimeToStr(StopDateTimeDT);
                      // discontinued, expired
//                      if (FOrderStatus = 'D') or (FOrderStatus = 'E') or
                      // discontinued, discontinued edit, discontinued renewal, or expired  rpk 1/25/2016
                      if (FOrderStatus = 'D') or
                        (FOrderStatus = 'DE') or // rpk 1/25/2016
                        (FOrderStatus = 'DR') or // rpk 1/25/2016
                        (FOrderStatus = 'E') or
  //                      (DateTimeToMDateTime(now +
  //                      BCMA_SiteParameters.ServerClockVariance) >= FStopDateTime)
  //                      (TodayDate >= StopDate) then begin
//                      (TodayDateTime >= StopDateTimeDT) then begin // rpk 2/1/2013
                      (TodayDateTimeSrvVar >= StopDateTimeDT) then begin  // rpk 7/11/2016
                        ExpiredCSOrders.add(aCoverSheetOrder);
                        if FScheduleType = 'P' then
                          PRNAGrpExpanded[TPRNGroups(2)] := 2;
                        if FOrderStatus = 'A' then
                          ForderStatus := 'E';
                      end
                      // active, provider hold, on call, renewal
//                      else if ((FOrderStatus = 'A') or (FOrderStatus = 'H') or
//                        (FOrderStatus = 'O')) and
{$IFDEF INC984066}
                  //bjr - INC984066 - 6/2/2015 - add renewal orders to coversheet
//                      else if ((FOrderStatus = 'A') or (FOrderStatus = 'H') or
//                        (FOrderStatus = 'O') or (FOrderStatus = 'R')) and
                    // active, provider hold, on call, renewal, reinstated; rpk 1/25/2016
                      else if ((FOrderStatus = 'A') or (FOrderStatus = 'H') or
                        (FOrderStatus = 'O') or (FOrderStatus = 'R') or
                          (FOrderStatus = 'RE')
                        ) and
{$ELSE}
                      else if ((FOrderStatus = 'A') or (FOrderStatus = 'H') or
                        (FOrderStatus = 'O')) and
{$ENDIF}
                        { (FMDateTimeToDateTime(StrToFloat(FStartDateTime)) <= (now +
                        BCMA_SiteParameters.ServerClockVariance +
                        BCMA_SiteParameters.MinutesBefore * OneDTMinute)) then begin }
  //                      (StartDate <= TodayDateBefore) then begin
//                      (StartDateTimeDT <= TodayDateTimeMinBefore) then begin // rpk 2/1/2013
                      (StartDateTimeDT <= TodayDateTimeSrvVar) then begin  // rpk 7/11/2016
                        ActiveCSOrders.add(aCoverSheetOrder);
                        if FScheduleType = 'P' then
                          PRNAGrpExpanded[TPRNGroups(0)] := 2;
                      end
                      { else if FMDateTimeToDateTime(StrToFloat(FStartDateTime)) > (now
                        + BCMA_SiteParameters.ServerClockVariance +
                        BCMA_SiteParameters.MinutesBefore * OneDTMinute) then begin }
  //                    else if (StartDate > TodayDateBefore) then begin
                      // future
//                      else if (StartDateTimeDT > TodayDateTimeMinBefore) then begin // rpk 2/1/2013
                      else if (StartDateTimeDT > TodayDateTimeSrvVar) then begin  // rpk 7/11/2016
                        FutureCSOrders.add(aCoverSheetOrder);
                        if FScheduleType = 'P' then
                          PRNAGrpExpanded[TPRNGroups(1)] := 2;
                      end;

                    end;
                  end;                  // clinic order
                end;                    // with aCoverSheetOrder
              end                       // ORD
              else if tempPiece = 'ORC' then
                with TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count -
                  1]) do
                begin
                  if FSpecialInstructions <> '' then
                    FSpecialInstructions := FSpecialInstructions + ' ';
                  //                    if Copy(piece(Results[ii], '^', 2), 1, 1) = '!' then
                  //                      FSpecialInstructions := FSpecialInstructions + Copy(piece(Results[ii], '^', 2), 2, length(piece(Results[ii], '^', 2)) - 1)
                  //                    else
                  //                      FSpecialInstructions := FSpecialInstructions + piece(Results[ii], '^', 2);
                  if Copy(piece(ResultList[ii], '^', 2), 1, 1) = '!' then
                    FSpecialInstructions := FSpecialInstructions +
                      Copy(piece(ResultList[ii], '^', 2), 2,
                      length(piece(ResultList[ii], '^', 2)) - 1)
                  else
                    FSpecialInstructions := FSpecialInstructions +
                      piece(ResultList[ii], '^', 2);

                  { *** Code commented out for Increment 2 pending release of PRE 0.5
                    tmpstr := GetComments(FPatientIEN, FOrderNumber);  // rpk 10/9/2009
                    if tmpstr > '' then
                       FSpecialInstructions := tmpstr; }

                end
              // Special Instructions / Other Print Info word processing text
              else if piece(rr, U, 1) = 'SI' then // rpk 1/4/2012
                aCoverSheetOrder.FSIOPIList.Add(piece(rr, U, 2))
              else if tempPiece = 'DD' then begin
//                witness_str := piece(rr, U, 6); // rpk 9/11/2012
                witness_str := piece(rr, U, 7); // rpk 9/27/2012
//                if witness_str = WITNESS_REQUIRED then // rpk 9/11/2012
                if (witness_str >= WITNESS_RECOMMENDED) and // rpk 10/23/2012
                  (witness_str > aCoverSheetOrder.FWitnessFlag) then  // rpk 10/23/2012
                  aCoverSheetOrder.FWitnessFlag := witness_str; // rpk 9/11/2012
              end
              else if tempPiece = 'SOL' then begin
//                witness_str := piece(rr, U, 6); // rpk 9/11/2012
                witness_str := piece(rr, U, 7); // rpk 9/27/2012
//                if witness_str = WITNESS_REQUIRED then // rpk 9/11/2012
                if (witness_str >= WITNESS_RECOMMENDED) and // rpk 10/23/2012
                  (witness_str > aCoverSheetOrder.FWitnessFlag) then  // rpk 10/23/2012
                  aCoverSheetOrder.FWitnessFlag := witness_str; // rpk 9/11/2012
              end
              else if tempPiece = 'ADD' then begin
//                witness_str := piece(rr, U, 6); // rpk 9/11/2012
                witness_str := piece(rr, U, 7); // rpk 9/27/2012
//                if witness_str = WITNESS_REQUIRED then // rpk 9/11/2012
                if (witness_str >= WITNESS_RECOMMENDED) and // rpk 10/23/2012
                  (witness_str > aCoverSheetOrder.FWitnessFlag) then  // rpk 10/23/2012
                  aCoverSheetOrder.FWitnessFlag := witness_str; // rpk 9/11/2012
              end
              else if tempPiece = 'ID' then
                with TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count -
                  1]) do
                begin
                  AllAdmins.Add(TCoverSheet_Admin.create(BCMA_Broker));
                  FAdministrations.add(TCoverSheet_Admin(AllAdmins[AllAdmins.Count - 1]));
                  with TCoverSheet_Admin(AllAdmins[AllAdmins.count - 1]) do
                  begin
                    FBagID := piece(rr, '^', 2);
                    FOrder := CoverSheetOrders[CoverSheetOrders.count - 1];
                    FAction := 'A';
                    FIVExpanded := 0;
                  end
                end
              else if tempPiece = 'ORF' then
                ProcessORFRecords(rr)
              else if tempPiece = 'ADM' then
              begin
                with TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count -
                  1]) do
                begin
                  AllAdmins.Add(TCoverSheet_Admin.create(BCMA_Broker));
                  FAdministrations.add(TCoverSheet_Admin(AllAdmins[AllAdmins.Count - 1]));
                  with TCoverSheet_Admin(AllAdmins[AllAdmins.count - 1]) do
                  begin
                    FAdminDateTime := piece(rr, '^', 2);
                    FBagID := piece(rr, '^', 3);
                    FMedLogIEN := piece(rr, '^', 4);
                    FAction := piece(rr, '^', 5);
                    FActionDateTime := piece(rr, '^', 6);
                    FActionByInitials := piece(rr, '^', 7);
                    FActionByIEN := piece(rr, '^', 8);
                    FPRNReason := piece(rr, '^', 9);
                    FExpanded := 0;
                    if FAction <> 'A' then
                      FIVExpanded := 1;
                    FOrder := CoverSheetOrders[CoverSheetOrders.count - 1];
                    TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count -
                      1]).FNextDue := piece(rr, '^', 10);
                    if FAction <> '' then
                      FAdministrationsWithAction.add(TCoverSheet_Admin(AllAdmins[AllAdmins.Count - 1]));
                  end;
                end;
                // ii := ii + 1;
                Inc(ii);
                //                  while ii <= results.Count - 1 do
                while ii <= resultscnt - 1 do
                begin                   // rpk 4/29/2009
                  //                    rr := Results[ii];
                  rr := ResultList[ii]; // rpk 4/29/2009
{$IFDEF CAS_DDPE_DEBUG}
                  rrRaw := rrRaw + rr + #13#10; ;
{$ENDIF}

                  if piece(rr, '^', 1) = 'CMT' then
                    with TCoverSheet_Admin(AllAdmins[AllAdmins.count - 1]) do
                    begin
                      if piece(rr, '^', 3) <> '' then
                      begin
                        FPRNEffectComment := piece(rr, '^', 3);
                        // ii := ii + 1
                        Inc(ii);        // rpk 4/30/2009
                      end
                      else
                      begin
                        AllComments.add(TCoverSheet_Comment.Create(BCMA_Broker));
                        FComments.Add(TCoverSheet_Comment(AllComments[AllComments.Count - 1]));
                        Expanded := 1;
                        with TCoverSheet_Comment(AllComments[AllComments.Count -
                          1]) do
                        begin
                          FComment := piece(rr, '^', 2);
                          //FPRNEffectComment := piece(rr, '^', 3);
                          FActionByIEN := piece(rr, '^', 4);
                          FActionByInitials := piece(rr, '^', 5);
                          FActionDateTime := piece(rr, '^', 6);
                          FPRNReason :=
                            TCoverSheet_Admin(AllAdmins[AllAdmins.count -
                            1]).FPRNReason;
                          // ii := ii + 1;
                          Inc(ii);      // rpk 4/30/2009
                        end;
                      end;
                    end
                  else
                  begin
                    //if we bump into anything else, back up one so
                    //the main loop handles it.
                    // ii := ii - 1;
                    Dec(ii);            // rpk 4/30/2009
                    Break;
                  end;
                end;
              end
              else if tempPiece = 'END' then
              begin
                with TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count -
                  1]) do
                  if FAdministrationsWithAction.Count = 0 then
                    Expanded := 0
                  else
                    Expanded := 1;
                with TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count -
                  1]) do
                  if ((FTab = '3') and (FAdministrations.Count = 0)) then
                  begin
                    AllAdmins.Add(TCoverSheet_Admin.create(BCMA_Broker));
                    with TCoverSheet_Admin(AllAdmins[AllAdmins.count - 1]) do
                    begin
                      FOrder := CoverSheetOrders[CoverSheetOrders.count - 1];
                      FIVExpanded := 0;
                    end
                  end;
{$IFDEF CAS_DDPE_DEBUG}
                TCoverSheet_Order(CoverSheetOrders[CoverSheetOrders.count -
                  1]).fRaw := rrRaw;
                rrRaw := '';
{$ENDIF}
              end;
              // ii := ii + 1;
              Inc(ii);                  // rpk 4/30/2009
              //              end; //end with

            end;                        //end while ii <= resultscnt - 1
          end;                          //end with
  frmMain.StatusBar.Panels[0].Text := '';
  frmMain.StatusBar.Repaint;

  ResultList.Free;

end;                                    // LoadCoverSheetOrders

procedure ClearCoverSheetOrders;
var
  ii                : integer;
begin
  if CoverSheetOrders <> nil then
    with CoverSheetOrders do
    begin
      for ii := count - 1 downto 0 do
        TCoverSheet_Order(items[ii]).free;
      clear;
    end;

  if Alladmins <> nil then
    with AllAdmins do
    begin
      for ii := count - 1 downto 0 do
        TCoverSheet_Admin(items[ii]).free;
      clear;
    end;

  if AllComments <> nil then
    with AllComments do
    begin
      for ii := count - 1 downto 0 do
        TCoverSheet_Comment(Items[ii]).Free;
      clear;
    end;

  ExpiredCSOrders.Clear;
  ActiveCSOrders.Clear;
  FutureCSOrders.Clear;

  ClearCoverSheetFlags;
end;

{This is where we will clear flags, values, etc that are stored when data is loaded and the user
interacts with the coversheet. These flags will get either cleared, or reset, when new data is loaded
and when the user changes views}

procedure ClearCoverSheetFlags;
var
  ii                : integer;
begin
  for ii := 0 to Length(PRNAGrpExpanded) - 1 do
    PRNAGrpExpanded[TPRNGroups(ii)] := 0;
  for ii := 0 to Length(MedOverViewGrpExpanded) - 1 do
    MedOverViewGrpExpanded[TMedOverviewGroups(ii)] := 0;
  for ii := 0 to Length(IVOGrpExpanded) - 1 do
    IVOGrpExpanded[TIVGroups(ii)] := 0;
end;

procedure CheckForEditedIVs;
var
  aCoverSheetOrder  : TCoverSheet_Order;
  x                 : Integer;
  tempMultOrders    : TStringList;

  function GetOrder(OrderNum: string): TCoverSheet_Order;
    {Retrieves an Order via the Order Number passed in}
  var
    idxorder,
      ii            : integer;
  begin
    idxorder := -1;
    Result := nil;
    with CoverSheetOrders do
      for ii := 0 to CoverSheetOrders.count - 1 do
        with TCoverSheet_Order(items[ii]) do
          if OrderNumber = OrderNum then
          begin
            if idxorder <> -1 then
            begin
              DefMessageDlg('ERROR: A duplicate order was found on CoverSheet',
                mtError, [mbOk], 0);
              Result := nil;
              Exit;
            end;
            Result := TCoverSheet_Order(Items[ii]);
          end;
  end;

  function MultOrders: TStringList;
  var
    ii              : integer;
    OrderList       : TStringList;
  begin
    OrderList := TStringList.Create;
    with CoverSheetOrders do
      for ii := 0 to count - 1 do
        with TCoverSheet_Order(items[ii]) do
          if VDLTab = '3' then
            OrderList.Add(OrderNumber);
    Result := OrderList;
  end;
begin
  tempMultOrders := MultOrders;
  if tempMultOrders.Count = 0 then
    exit;

  frmMain.StatusBar.Panels[0].Text := 'Checking for Edited IVs...';
  frmMain.StatusBar.Repaint;

  if (BCMA_Broker <> nil) and (CoverSheetOrders <> nil) and
    (BCMA_Patient.IEN <> '') and (CoverSheetOrders.Count > 0) then
    with BCMA_Broker do
      if CallServer('PSB CHECK IV', [BCMA_Patient.IEN], MultOrders) then
        if (Results.Count = 0) or (Results.Count - 1 <> StrToInt(Results[0]))
          then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if (results.Count > 1) and
          (piece(Results[1], '^', 1) = '-1') then
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
        else
        begin
          x := 1;
          while x < Results.Count - 1 do
          begin
            //                aCoverSheetOrder := nil;
            aCoverSheetOrder := GetOrder(piece(Results[x], '^', 5));
            while x <= Results.count - 1 do
            begin
              if aCoverSheetOrder <> nil then
                aCoverSheetOrder.fEditedOrder := True;
              if piece(Results[x], '^', 1) = 'END' then
              begin
                x := x + 1;
                break;
              end;
              x := x + 1
            end;
          end;
        end;
  frmMain.StatusBar.Panels[0].Text := '';
  frmMain.StatusBar.Repaint;
end;

procedure TCoverSheet.CreateMe(aWinControl: TWinControl);
begin
  if frmCoverSheet = nil then
  begin
    frmCoverSheet := TfrmCoverSheet.Create(aWinControl);
    frmCoverSheet.Parent := aWinControl;
    frmCoverSheet.Align := alClient;
  end;

  frmCoverSheet.Show;
end;

procedure TCoverSheet.RebuildMe;
begin
  ClearCoverSheetOrders;
  frmCoverSheet.ReloadCoverSheet(True, False);
end;

procedure TCoverSheet.CloseMe;
begin
  if frmCoverSheet <> nil then
    frmCoverSheet.Close;
  frmCoverSheet := nil;
end;

function TCoverSheet.MyNameIs: string;
begin
  Result := 'Blood Pressure';
end;

procedure TCoverSheet_Order.Clear;
begin
  ;
end;

constructor TCoverSheet_Order.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;
  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;
  FAdministrations := TList.Create;
  FAdministrationsWithAction := TList.Create;
  FSIOPIList := TStringList.Create;     // rpk 1/4/2012
  FNoActionTaken := False;
  FFlagged := False;
  FStat := False;
end;

destructor TCoverSheet_Order.Destroy;
begin
  FRPCBroker := nil;
  FAdministrations.Free;                // rpk 1/4/2012
  FAdministrationsWithAction.Free;      // rpk 1/4/2012
  FSIOPIList.Free;                      // rpk 1/4/2012
  inherited Destroy;
end;

function TCoverSheet_Order.getScheduleTypeID: TScheduleTypes;
var
  id                : TScheduleTypes;
begin
  Result := stNone;                     // rpk 4/7/2009

  if FRPCBroker <> nil then
    for id := low(ScheduleTypeCodes) to high(ScheduleTypeCodes) do
      if ScheduleTypeCodes[id] = FScheduleType then
      begin
        result := id;
        break;
      end;
end;


function TCoverSheet_Order.getNextAdminDateTime: string;
var
  ActionDateTime, RemovalDT: TDateTime;
  //  SinceMinutes: Extended;
  MinAfter          : Extended;
  DisplayDateTime   : string;
  bcheck            : Boolean;
begin
  Result := '';
  RemovalDT := 0.0;
  DisplayDateTime := '';
  bcheck := False;

  if FOrderStatus = 'H' then
    result := 'Provider Hold'
  else begin                            // not provider hold
    // real-time check for expired order
    if (DateTimeToMDateTime(now + BCMA_SiteParameters.ServerClockVariance) >=
      FStopDateTime) then
      if FOrderStatus = 'A' then        // reset "active" to actually expired
        FOrderStatus := 'E';
    // If expired or DC'd and MRR waiting to be removed, include it in processing
    // for next action column.  Otherwise, only active, continuous orders should be processed
    if (FOrderStatus = 'E') or          // expired
      (FOrderStatus = 'DE') or          // discontinued edit; rpk 1/25/2016
      (FOrderStatus = 'DR') or          // discontinued renewal; rpk 1/25/2016
      (FOrderStatus = 'D') then begin   // discontinued
      if (RemovalStatus <> '') and (RemovalStatus <> '0') then begin // MRR
        if (ScanStatus = 'G') then      // given
          bcheck := True;
      end;
    end
    else if (FScheduleType = 'C') then  // continuous, active
      bcheck := True;

    if bcheck then begin
      if Trim(clinicname) = '' then begin // inpatient
        MinAfter := BCMA_SiteParameters.MinutesAfter * OneDTMinute;
        if (RemovalStatus <> '') and (RemovalStatus <> '0') then begin // MRR
          if (ScanStatus = 'G') then begin // given
            FRemovalDateTime := Trim(FRemovalDateTime);
            if RemovalStatus = '1' then begin
              if (RemovalDateTime <> '') then begin
                RemovalDT := FMDateTimeToDateTime(StrToFloat(RemovalDateTime));
                DisplayDateTime := RemovalDateTime;
              end
              else if NextDue <> '' then begin
                RemovalDT := FMDateTimeToDateTime(StrToFloat(NextDue));
                DisplayDateTime := NextDue;
                WriteLogMessageProc('TCoverSheet_Order.getNextAdminDateTime: ActiveMedication='
                  +
                  ActiveMedication + ', inpatient; removalstatus = 1, RemovalDateTime = "", using NextDue="'
                    +
                  NextDue + '"', nil);
              end;
            end
            else if RemovalStatus = '3' then begin
              if (RemovalDateTime = '') then
                WriteLogMessageProc('TCoverSheet_Order.getNextAdminDateTime: ActiveMedication='
                  +
                  ActiveMedication +
                    ', inpatient; removalstatus = 3, RemovalDateTime = "".', nil)
              else begin
                RemovalDT := FMDateTimeToDateTime(StrToFloat(RemovalDateTime));
                DisplayDateTime := RemovalDateTime;
              end
            end;

            if RemovalDT > 0.0 then begin
              if Now > (RemovalDT + MinAfter) then // rpk 7/10/2013
                Result := 'MISSED-RM ' + DisplayVADate(DisplayDateTime)  // rpk 8/12/2015
              else
                Result := 'REMOVE ' + DisplayVADate(DisplayDateTime);
            end
            else begin
              Result := 'REMOVE';
              WriteLogMessageProc('TCoverSheet_Order.getNextAdminDateTime: REMOVE; ActiveMedication='
                +
                ActiveMedication + ', inpatient; removalstatus = ' +
                  RemovalStatus +
                ', RemovalDateTime = "' + RemovalDateTime +
                '", NextDue = "' + NextDue + '"', nil)
            end;
          end                           // given
          else if (NextDue <> '') then begin // not given rpk 12/10/2015
            ActionDateTime := FMDateTimeToDateTime(StrToFloat(NextDue));
            if Now > (ActionDateTime + MinAfter) then // rpk 7/10/2013
              Result := 'MISSED ' + DisplayVADate(NextDue)
            else
              result := 'DUE ' + DisplayVADate(NextDue);
          end                           // not given
        end                             // MRR
        else if (NextDue <> '') then begin // non-MRR
          ActionDateTime := FMDateTimeToDateTime(StrToFloat(NextDue));
          if Now > (ActionDateTime + MinAfter) then // rpk 7/10/2013
            Result := 'MISSED ' + DisplayVADate(NextDue)
          else
            result := 'DUE ' + DisplayVADate(NextDue);
        end                             // nextdue
      end
      else begin                        // clinic
        if (RemovalStatus <> '') and (RemovalStatus <> '0') then begin // MRR
          if (ScanStatus = 'G') then begin // given
            FRemovalDateTime := Trim(FRemovalDateTime);
            if RemovalStatus = '1' then begin
              if (RemovalDateTime <> '') then begin
                RemovalDT := FMDateTimeToDateTime(StrToFloat(RemovalDateTime));
                DisplayDateTime := RemovalDateTime;
              end
              else if NextDue <> '' then begin
                RemovalDT := FMDateTimeToDateTime(StrToFloat(NextDue));
                DisplayDateTime := NextDue;
                WriteLogMessageProc('TCoverSheet_Order.getNextAdminDateTime: ActiveMedication='
                  +
                  ActiveMedication +
                    ', clinic; removalstatus = 1, RemovalDateTime = "", using NextDue.',
                    nil);
              end;
            end
            else if RemovalStatus = '3' then begin
              if (RemovalDateTime = '') then
                WriteLogMessageProc('TCoverSheet_Order.getNextAdminDateTime: ActiveMedication='
                  +
                  ActiveMedication +
                    ', clinic; removalstatus = 3, RemovalDateTime = "".', nil)
              else begin
                RemovalDT := FMDateTimeToDateTime(StrToFloat(RemovalDateTime));
                DisplayDateTime := RemovalDateTime;
              end
            end;

            if RemovalDT > 0.0 then begin
              if Today > DateOf(RemovalDT) then
                Result := 'MISSED-RM ' + DisplayVADate(DisplayDateTime)  // rpk 8/12/2015
              else
                Result := 'REMOVE ' + DisplayVADate(DisplayDateTime);
            end
            else begin
              Result := 'REMOVE';
              WriteLogMessageProc('TCoverSheet_Order.getNextAdminDateTime: REMOVE; ActiveMedication='
                +
                ActiveMedication + ', clinic; removalstatus = ' + RemovalStatus
                  +
                ', RemovalDateTime = "' + RemovalDateTime + '", NextDue = "' +
                  NextDue + '"', nil)
            end;
          end                           // given
          else if (NextDue <> '') then begin // not given rpk 12/10/2015
            ActionDateTime := FMDateTimeToDateTime(StrToFloat(NextDue));
            if Today > DateOf(ActionDateTime) then // rpk 7/10/2013
              Result := 'MISSED ' + DisplayVADate(NextDue)
            else
              result := 'DUE ' + DisplayVADate(NextDue);
          end                           // not given
        end                             // MRR
        else if (NextDue <> '') then begin // non-MRR
          ActionDateTime := FMDateTimeToDateTime(StrToFloat(NextDue));
          if Today > DateOf(ActionDateTime) then // rpk 7/10/2013
            Result := 'MISSED ' + DisplayVADate(NextDue)
          else
            result := 'DUE ' + DisplayVADate(NextDue);
        end;                            // non-MRR
      end;                              // clinic
    end; // schedule type c and not expired and not discontinued
  end;                                  // not provider hold
end;                                    // getNextAdminDateTime

constructor TCoverSheet_Admin.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;
  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;
  FComments := TList.Create;
  FBagDetail := TStringList.Create;
end;

constructor TCoverSheet_Comment.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;
  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;
end;

procedure TCoverSheet_Admin.FetchIVBagDetail;
begin
  frmMain.StatusBar.Panels[0].Text := 'Retrieving Bag Details...';
  frmMain.StatusBar.Repaint;

  if (BCMA_Broker <> nil) and (CoverSheetOrders <> nil) then
    with BCMA_Broker do
      if CallServer('PSB BAG DETAIL', [FBagID,
        TCoverSheet_Order(Order).OrderNumber], nil) then
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0],
          -1)) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if (results.Count > 0) and
          (piece(Results[1], '^', 1) = '-1') then
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
        else
        begin
          FBagDetail.Assign(Results);
          FBagDetail.Delete(0);
        end;
  frmMain.StatusBar.Panels[0].Text := '';
  frmMain.StatusBar.Repaint;
end;

function TCoverSheet_Order.getSinceLast: string;
var
  ActionDateTime    : TDateTime;
  SinceMinutes, zDays, zHours, zMinutes: Extended;
begin
  Result := DaysHoursMinutesPast(TimeLastGiven);
  exit;
  if TimeLastGiven = '' then
    exit;
  ActionDateTime := FMDateTimeToDateTime(StrToFloat(TimeLastGiven));
  SinceMinutes := TimeApartInMins(ActionDateTime, Now +
    BCMA_SiteParameters.ServerClockVariance);

  zDays := int(SinceMinutes / 1440);
  SinceMinutes := SinceMinutes - zDays * 1440;

  if (SinceMinutes >= 60) then
    zHours := int(SinceMinutes / 60)
  else
    zHours := 0;

  if SinceMinutes > 60 then
    zMinutes := Round(60 * frac(SinceMinutes / 60))
  else
    zMinutes := Round(SinceMinutes);

  Result := FloatToStr(zDays) + 'd ' + FloatToStr(zHours) + 'h ' +
    FloatToStr(zMinutes) + 'm';
end;

function TCoverSheet_Order.GetChanged: string;
begin
  if EditedOrder then
    result := 'Changed Order'
  else
    result := '';
end;

procedure TCoverSheet_Order.setSIOPIList(newValue: TStringList);  // rpk 11/09/2011
begin
  if FRPCBroker <> nil then
    if newValue.Text <> FSIOPIList.Text then begin
      FSIOPIList.Assign(newValue);
    end;
end;

function TCoverSheet_Order.DisplaySIOPI(CancelOn: Boolean): Boolean;
var
  mtval             : memoTypes;
  mres              : Integer;
  titlestr          : string;
begin
  if OrderType = 'V' then               // IV, IVP, IVPB
    mtval := mtOtherInfo
  else
    mtval := mtSpecialInstructions;

  titlestr := memoTypeTitles[mtval];
  mres := DisplayMemoList(titlestr, SpecialInstructions, SIOPIList, CancelOn);
  Result := (mres = mrOK);
end;

function TCoverSheet_Order.GetSIOPIText: string;
begin
  if SIOPIList.Text > '' then
    Result := SIOPIList.Text
  else
     // otherwise, use the original string field.
    Result := SpecialInstructions;
end;


procedure TCoverSheet_Order.SetSIOPIMemo(memo: TMemo);
begin
  // if unlimited string list non-empty, use it.
  if SIOPIList.Text > '' then
    memo.Lines.Assign(SIOPIList)
  else
    // otherwise, use the original string field.
    memo.Text := SpecialInstructions;
end;

procedure GroupExpandCollapse(GroupNum: Integer);
begin
  frmCoverSheet.GrpExpCol(GroupNum);
end;

function SeekListBoxArray(ArrayIn: array of TListBox; ControlIn: TObject):
  Integer;
var
  i                 : Integer;
begin
  Result := -1;
  for i := low(ArrayIn) to high(ArrayIn) do
    if ArrayIn[i] = ControlIn then
      Result := i;
end;

{$IFDEF CAS_DDPE_RST}

function CompareAdministrationTimes(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TCoversheet_Admin(Item1).AdminDateTime,
    TCoversheet_Admin(Item2).FAdminDateTime);
end;

function TCoverSheet_Order.getLastOrderAction: string;
var
  i                 : integer;
  ItemAdminTime,
    LastAdminTime   : TDateTime;
  Admin             : TCoversheet_Admin;
  s                 : string;
begin
  s := 'n/a';
  LastAdminTime := -1;
  fAdministrations.Sort(CompareAdministrationTimes);
  for I := 0 to FAdministrations.Count - 1 do
  begin
    Admin := fAdministrations[i];
    ItemAdminTime := MakeFMDateTime(Admin.FAdminDateTime);
    if LastAdminTime < 0 then
      continue
    else
    begin
      if LastAdminTime < itemAdminTime then
      begin
        LastAdminTime := itemAdminTime;
        s := Admin.Action;
      end;
    end;
  end;
  Result := s;

end;

{$ENDIF}


end.

