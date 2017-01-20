unit BCMAParameters;
{
================================================================================
*	File:  BCMAParameters.PAS
*
*	Application:  Bar Code Medication Administration - Site Parameters
*	Revision:     $Revision: 31 $  $Modtime: 1/16/02 6:09p $
*	Description:  This form provides access to the server side BCMA Site
*               Parameters for the application.
*
*	Notes:
*
* lbledtDivPatIdLabel, lbledtSysPatIdLabel, and lbledtAllPatIdLabel are disabled
* and hidden in design mode.  They should only be visible in test mode
* (TEST_ON) for debugging.
* TEST_ON is defined only for debugging.  Delete it and/or replace it with
* TEST_OFF for production.
*
* CAS_DDPE_TEST for anatomic location test
*
*
*
================================================================================
*	$Archive: /BCMA GUI V2/BCMA Parameters/PSB_2_0/BCMAParameters.pas $
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Trpcb, MFunStr, StdCtrls, ExtCtrls, ComCtrls, Menus, BCMA_ParObjects,
  BCMA_Util, Buttons, ehshelprouter, ehsbase, ehswhatsthis, Spin, jpeg, ActnList
  , frmALMap, CheckLst, uCAS_ALUtils, StdActns
  ;

type
//  TListNames = (lnPRN, lnHeld, lnRefused, lnInjection, lnAnatomicLocations);
  TListNames = (lnPRN, lnHeld, lnRefused, lnInjection, lnAnatomicLocations,
    lnBodySites);                       // rpk 10/5/2015
//  TListNames = (lnPRN, lnHeld, lnRefused, lnInjection, lnAnatomicLocations, lnBodySites, lnBodySitesChart); // rpk 12/9/2015

  TfrmBCMAParameters = class(TForm)
    menu: TMainMenu;
    menuHelp: TMenuItem;
    menuHelpAbout: TMenuItem;
    menuFile: TMenuItem;
    menuFileOpen: TMenuItem;
    menuFileClose: TMenuItem;
    N1: TMenuItem;
    menuFileExit: TMenuItem;
    Panel3: TPanel;
    mnLister: TPopupMenu;
    mnListAdd: TMenuItem;
    mnListEdit: TMenuItem;
    mnDeleteItem: TMenuItem;
    menuHelpContents: TMenuItem;
    menuHelpIndex: TMenuItem;
    N2: TMenuItem;
    gbBCMA: TGroupBox;
    lblBlack: TLabel;
    lblSilver: TLabel;
    PageControl1: TPageControl;
    tsFacility: TTabSheet;
    GroupBox5: TGroupBox;
    Label6: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    edtAddressZip: TEdit;
    edtAddressState: TEdit;
    edtAddressCity: TEdit;
    edtAddress2: TEdit;
    edtAddress1: TEdit;
    edtFacName: TEdit;
    GroupBox6: TGroupBox;
    Label21: TLabel;
    cbxOnLine: TCheckBox;
    tsAnswerList: TTabSheet;
    GroupBox3: TGroupBox;
    lblListName: TLabel;
    cbxListName: TComboBox;
    btnSaveList: TButton;
    tbshtIVParameters: TTabSheet;
    pnlIVParLeft: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    pnlIVParRight: TPanel;
    grpIVPrompts: TGroupBox;
    cbxIVParWard: TComboBox;
    Label25: TLabel;
    Label26: TLabel;
    cbxIVParType: TComboBox;
    btnIVParCancel: TButton;
    btnIVParOK: TButton;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    ComboBox13: TComboBox;
    ComboBox14: TComboBox;
    ComboBox15: TComboBox;
    Label42: TLabel;
    lblDivision: TLabel;
    btnReset: TButton;
    lvwDefAnswer: TListView;
    Memo1: TMemo;
    tbshtIHS: TTabSheet;
    lbledtPatIdLabel: TLabeledEdit;
    lbledtDivPatIdLabel: TLabeledEdit;
    lbledtSysPatIdLabel: TLabeledEdit;
    btnIHSOK: TButton;
    tsParameters: TTabSheet;
    pnlLeft: TPanel;
    gbxMissingDosePrinters: TGroupBox;
    gbxMailGroups: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    lblUnabletoScan: TLabel;
    edtMGDLError: TEdit;
    edtMGInpatientMissingDose: TEdit;
    edtMgUnknown: TLabeledEdit;
    edtMGMSF: TEdit;
    grpBarCodeOptions: TGroupBox;
    lblDefaultBarCodeFormat: TLabel;
    lblDefaultBarCodePrefix: TLabel;
    cbxBCFormat: TComboBox;
    edtBCPrefix: TEdit;
    chkRobotRX: TCheckBox;
    grpReports: TGroupBox;
    Label14: TLabel;
    edtMedHistDaysBack: TEdit;
    cbxRptInclComm: TCheckBox;
    grpFiveRights: TGroupBox;
    chk5UnitDose: TCheckBox;
    chk5IV: TCheckBox;
    pnlRight: TPanel;
    gbxVDL: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    cmbxStartTime: TComboBox;
    cmbxStopTime: TComboBox;
    gbxAdministration: TGroupBox;
    cbxESig: TCheckBox;
    chkMultiAdmin: TCheckBox;
    grpMiscOptions: TGroupBox;
    lblPatientTransfer: TLabel;
    Label36: TLabel;
    lblPRNDoc: TLabel;
    lblMRRDisplayDuration: TLabel;
    Label24: TLabel;
    Label8: TLabel;
    edtPatientTransfer: TEdit;
    edtTimeout: TEdit;
    chkCPRSMedOrder: TCheckBox;
    edtPRNDoc: TEdit;
    cbxPatchDuration: TComboBox;
    edtMaximumServerClockVariance: TEdit;
    edtMaxDateRange: TEdit;
    grpIncludeScheduleTypes: TGroupBox;
    cbxCont: TCheckBox;
    cbxPRN: TCheckBox;
    cbxOneTime: TCheckBox;
    cbxOnCall: TCheckBox;
    grpAllowableTime: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    cmbxMinBefore: TComboBox;
    cmbxMinAfter: TComboBox;
    btnIHSCancel: TButton;
    HelpRouter1: THelpRouter;
    WhatsThis1: TWhatsThis;
    lbledtAllPatIdLabel: TLabeledEdit;
    edtPRNEffect: TEdit;
    updnPRNEffect: TUpDown;
    grpNonNurseVfy: TGroupBox;
    rbtnAllow: TRadioButton;
    rbtnAllowWarning: TRadioButton;
    rbtnProhibit: TRadioButton;
    edtInjSiteHistMaxHrs: TEdit;
    lblInjSiteHistMaxHrs: TLabel;
    edtCOMissingDoseReqPrt: TLabeledEdit;
    edtIMMissingDoseReqPrt: TLabeledEdit;
    RPCLog1: TMenuItem;
    mnAL: TPopupMenu;
    alLocations: TActionList;
    acRemove: TAction;
    acRename: TAction;
    acEditMap: TAction;
    acCountShapes: TAction;
    acBackupData: TAction;
    acReloadFromServer: TAction;
    acBackupEdit: TAction;
    acResetMap: TAction;
    acNewBackup: TAction;
    tsAL: TTabSheet;
    grpAL: TGroupBox;
    pnlMasterList: TPanel;
    pnlMasterListAL: TPanel;
    ckbLocations: TCheckListBox;
    splChart: TSplitter;
    pnlChart: TPanel;
    pnlBodyChart: TPanel;
    pnlGroupList: TPanel;
    cmbALList: TComboBox;
    lblGroupName: TLabel;
    lblColumns: TLabel;
    udColumns: TUpDown;
    pnlImageTools: TPanel;
    lblGroupImage: TLabel;
    acImageNew: TAction;
    acImageDelete: TAction;
    acGroupNew: TAction;
    acGroupDelete: TAction;
    acGroupLoadList: TAction;
    acImageLoadList: TAction;
    acGroupSelectAll: TAction;
    acItemAdd: TAction;
    acItemRename: TAction;
    acItemRemove: TAction;
    ckbSelectAll: TCheckBox;
    pnlMasterTool: TPanel;
    acMasterSave: TAction;
    acMasterLoad: TAction;
    btnMasterSave: TSpeedButton;
    btnMasterLoad: TSpeedButton;
    btnItemAdd: TSpeedButton;
    btnItemRename: TSpeedButton;
    btnItemRemove: TSpeedButton;
    cmbALImages: TComboBox;
    acImages: TAction;
    acImageReplace: TAction;
    btnImportImageAL: TButton;
    btnImageNew: TButton;
    btnImageDelete: TButton;
    btnGroupNew: TButton;
    btnGroupDelete: TButton;
    btnGroupSave: TButton;
    acGroupSave: TAction;
    btnEditLayoutAL: TButton;
    btnMasterImport: TSpeedButton;
    acMasterImport: TFileOpen;
    acImageImport: TFileOpen;
    pnlDefaults: TPanel;
    splChartDefault: TSplitter;
    pnlMRR: TPanel;
    pnlMRRTools: TPanel;
    lblDefaultImage: TLabel;
    cmbDefaultImage: TComboBox;
    btnImportImage: TButton;
    btnDefaultImageNew: TButton;
    btnDefaultImageDelete: TButton;
    btnEditLayoutDAL: TButton;
    pnlDefaultTools: TPanel;
    btnDefaultSaveList: TSpeedButton;
    btnDefautlLoadList: TSpeedButton;
    btnDefaultAddItem: TSpeedButton;
    btnEditItem: TSpeedButton;
    btnDeleteItem: TSpeedButton;
    btnImportList: TSpeedButton;
    pnlDefAnswer: TPanel;
    acDefaultAdd: TAction;
    acDefaultRename: TAction;
    acDefaultRemove: TAction;
    acDefaultImport: TAction;
    acDefaultSave: TAction;
    acDefaultLoad: TAction;
    Add1: TMenuItem;
    Rename1: TMenuItem;
    Remove1: TMenuItem;
    N3: TMenuItem;
    ImportList1: TMenuItem;
    btnGroupLoad: TButton;
    acGroupLoad: TAction;
    lbMaster: TListBox;
    mmMaster: TMemo;
    sbMode: TSpeedButton;
    pnlChartDefault: TPanel;
    DEBUG1: TMenuItem;
    ALTab1: TMenuItem;
    lblDermSiteHistMaxDays: TLabel;
    edtDermSiteHistMaxDays: TEdit;
    acMasterExport: TFileSaveAs;
    btnMasterExport: TSpeedButton;

    procedure edtMaxDateRangeExit(Sender: TObject);
    procedure chk5IVClick(Sender: TObject);
    procedure chk5UnitDoseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    (*
      Sets the application OnExcept handler to be method ExceptionHandler.
      Checks to make sure the user has Manager access.  Displays a warning
      message that all changes are immediate.  Initializes variables.
    *)

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    (*
      Calls method menuFileCloseClick.
    *)

    procedure menuFileOpenClick(Sender: TObject);
    (*
      Calls method menuFileCloseClick.  Prompts the user for a division number.
      Uses RPC 'PSB PARAMETER' to retrieve name and address data for the
      entered division.  Uses method GetParameter to download the current
      values of the site parameters.  Fills the list of lists combobox on the
      Answer Lists tabsheet.
    *)

    procedure menuFileCloseClick(Sender: TObject);
    (*
      Sets the PageControl visibilty to False.  Reinitializes variables.
    *)

    procedure menuFileExitClick(Sender: TObject);
    (*
      Calls method menuFileCloseClick and then terminates the application.
    *)

    procedure mnListerPopup(Sender: TObject);
    (*
      Initializes the AnswerList ListBox's popupmenu.
    *)

    procedure cbxOnLineClick(Sender: TObject);
    (*
      Calls method SetParameter to set the ONLINE parameter 'on' or 'off'.  If
      If the new value is 'off', a warning message is displayed and a chance
      to cancel offered.
    *)

    procedure cbxESigClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'Esig Required' parameter 'on' or
      'off'.
    *)

    procedure cbxContClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'Include Continuous Schedule Type'
      parameter on or off.  This is a default setting for new BCMA users.
    *)

    procedure cbxPRNClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'Include PRN Schedule Type'
      parameter on or off.  This is a default setting for new BCMA users.
    *)

    procedure cbxOneTimeClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'Include One-Time Schedule Type'
      parameter on or off.  This is a default setting for new BCMA users.
    *)

    procedure cbxOnCallClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'Include On-Call Schedule Type'
      parameter on or off.  This is a default setting for new BCMA users.
    *)

    procedure cmbxStartTimeClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'VDL StartTime' parameter.  This is
      the decrement from Now for the Virtual Due List display.
    *)

    procedure cmbxStopTimeClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'VDL StopTime' parameter.  This is
      the increment from Now for the Virtual Due List display.
    *)

    procedure cmbxMinBeforeClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'Allowable Time Limit Before the
      Scheduled Administration Time' parameter.
    *)

    procedure cmbxMinAfterClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'Allowable Time Limit After the
      Scheduled Administration Time' parameter.
    *)

//    procedure cmbxPRNEffectClick(Sender: TObject);
    (*
      Calls method SetParameter to set the 'Allowable Time Limit for PRN
      Effectiveness' parameter.
    *)

    procedure edtEnter(Sender: TObject);
    (*
      This method handles the OnEnter events for all of the TEdit fields on the
      form.  It sets the tag property of the sender to 0.
    *)

    procedure edtChange(Sender: TObject);
    (*
      This method handles the OnChange events for all of the TEdit fields on
      the form.  It sets the tag property of the sender to 1.
    *)

    //procedure edtHFSScratchExit(Sender: TObject);   bjr 5/12/10 for BCMA00000425
    (*
      This method handles the OnExit event for this TEdit field. If the tag
      property is not 0, the SetParameter method is used to send the changes
      to the server.  If SetParameter is not successful, GetParameter is used
      to restore the server value.  Finally, the tag property is set back to 0.
    *)

    procedure edtIMMissingDoseRequestPrtExit(Sender: TObject);
    (*
      This method handles the OnExit event for this TEdit field. If the tag
      property is not 0, the SetParameter method is used to send the changes
      to the server.  If SetParameter is not successful, GetParameter is used
      to restore the server value.  Finally, the tag property is set back to 0.
    *)

    procedure edtCOMissingDoseReqPrtExit(Sender: TObject);
    (*
      This method handles the OnExit event for this TEdit field. If the tag
      property is not 0, the SetParameter method is used to send the changes
      to the server.  If SetParameter is not successful, GetParameter is used
      to restore the server value.  Finally, the tag property is set back to 0.
    *)

    procedure edtMGSysErrorExit(Sender: TObject);
    (*
      This method handles the OnExit event for this TEdit field. If the tag
      property is not 0, the SetParameter method is used to send the changes
      to the server.  If SetParameter is not successful, GetParameter is used
      to restore the server value.  Finally, the tag property is set back to 0.
    *)

    procedure edtMGDLErrorExit(Sender: TObject);
    (*
      This method handles the OnExit event for this TEdit field. If the tag
      property is not 0, the SetParameter method is used to send the changes
      to the server.  If SetParameter is not successful, GetParameter is used
      to restore the server value.  Finally, the tag property is set back to 0.
    *)

    procedure edtMGInpatientMissingDoseExit(Sender: TObject);
    (*
      This method handles the OnExit event for this TEdit field. If the tag
      property is not 0, the SetParameter method is used to send the changes
      to the server.  If SetParameter is not successful, GetParameter is used
      to restore the server value.  Finally, the tag property is set back to 0.
    *)

    procedure edtMaximumServerClockVarianceExit(Sender: TObject);
    (*
      This method handles the OnExit event for this TEdit field. If the tag
      property is not 0, the SetParameter method is used to send the changes
      to the server.  If SetParameter is not successful, GetParameter is used
      to restore the server value.  Finally, the tag property is set back to 0.
    *)

    procedure mnListAddClick(Sender: TObject);
    (*
      Prompts for a new item to add to the currently displayed list.
      Sets btnSaveList.Enabled = True.
    *)

    procedure mnDeleteItemClick(Sender: TObject);
    (*
      Deletes the currently highlighted item from the displayed list.
      Sets btnSaveList.Enabled = True.
    *)

    procedure mnListEditClick(Sender: TObject);
    (*
      Presents the currently highlighted item in an InputQuery dialog for
      editing.  Replaces the results into the displayed list.
      Sets btnSaveList.Enabled = True.
    *)

    procedure btnSaveListClick(Sender: TObject);
    (*
      Uses RPC 'PSB PARAMETER' to save the edited list onto the server.
      Sets btnSaveList.Enabled = False.
    *)

    procedure menuHelpAboutClick(Sender: TObject);
    (*
      Displays the About dialog.
    *)

    procedure menuHelpContentsClick(Sender: TObject);
    (*
      Opens the application help file.
    *)

    procedure PageControl1Change(Sender: TObject);
    (*
      Sets the initial focus when changing tabsheets.
    *)

    procedure cbxListNameChange(Sender: TObject);
    {
      Uses RPC 'PSB PARAMETER' to retrieve selection lists from the server.
      The list downloaded depends on the item selected in the ListName
      combobox.  The downloaded list is displayed in the lvwDefAnswer
      listview, ready for editing.
    }

    procedure cbxIVParWardDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);

    procedure cbxIVParWardChange(Sender: TObject);

    procedure cbxIVParTypeDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);

    procedure cbxIVParTypeChange(Sender: TObject);

    procedure cbxBCFormatClick(Sender: TObject);

    procedure edtBCPrefixExit(Sender: TObject);

    procedure chkRobotRXClick(Sender: TObject);

    procedure chkMultiAdminClick(Sender: TObject);

    procedure edtPatientTransferExit(Sender: TObject);

    procedure edtPRNDocExit(Sender: TObject);

    procedure btnIVParOKClick(Sender: TObject);

    procedure btnResetClick(Sender: TObject);

    procedure btnIVParCancelClick(Sender: TObject);

    procedure ComboBox1Change(Sender: TObject);

    procedure edtTimeoutExit(Sender: TObject);

    procedure chkCPRSMedOrderClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbxListNameSelect(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure edtMedHistDaysBackChange(Sender: TObject);
    procedure edtMedHistDaysBackEnter(Sender: TObject);
    procedure edtMedHistDaysBackExit(Sender: TObject);
    procedure cbxRptInclCommClick(Sender: TObject);
    procedure cbxPatchDurationClick(Sender: TObject);
    procedure edtMgUnknownExit(Sender: TObject);
    procedure edtMGMSFExit(Sender: TObject);
    procedure lbledtPatIdLabelExit(Sender: TObject);
    procedure btnIHSOKClick(Sender: TObject);
    procedure btnIHSCancelClick(Sender: TObject);
    procedure menuHelpIndexClick(Sender: TObject);
    {
      Calls method SetParameter to set the 'Allowable Time Limit for PRN
      Effectiveness' parameter.
    }

    procedure WhatsThis1Popup(Sender, HelpItem: TObject; HContext: THelpContext;
      X, Y: Integer; var DoPopup: Boolean);
    procedure edtPRNEffectEnter(Sender: TObject);
    procedure edtPRNEffectExit(Sender: TObject);
    procedure rbtnNonNurseVfyClick(Sender: TObject);
    procedure updnPRNEffectExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    // updnPRNEffectonExit does not work when application is closed.
    // Add up/dn arrow onmouseleave to set focus on edtPRNEffect and make sure
    // edtPRNEffect is updated on server.
    procedure updnPRNEffectMouseLeave(Sender: TObject);
    procedure GroupBox6Enter(Sender: TObject);
    procedure GroupBox6Exit(Sender: TObject);
    procedure gbxMissingDosePrintersEnter(Sender: TObject);
    procedure gbxMissingDosePrintersExit(Sender: TObject);
    procedure gbxMailGroupsEnter(Sender: TObject);
    procedure gbxMailGroupsExit(Sender: TObject);
    procedure grpNonNurseVfyEnter(Sender: TObject);
    procedure grpNonNurseVfyExit(Sender: TObject);
    procedure GroupBox1Enter(Sender: TObject);
    procedure GroupBox1Exit(Sender: TObject);
    procedure GroupBox2Enter(Sender: TObject);
    procedure GroupBox2Exit(Sender: TObject);
    procedure grpIVPromptsEnter(Sender: TObject);
    procedure grpIVPromptsExit(Sender: TObject);
    procedure edtDermSiteHistMaxDaysExit(Sender: TObject);
    procedure edtInjSiteHistMaxHrsExit(Sender: TObject);
    procedure RPCLog1Click(Sender: TObject);
    procedure acRemoveExecute(Sender: TObject);
    procedure acEditMapExecute(Sender: TObject);
    procedure acCountShapesExecute(Sender: TObject);
    procedure acBackupDataExecute(Sender: TObject);
    procedure acReloadFromServerExecute(Sender: TObject);
    procedure acBackupEditExecute(Sender: TObject);
    procedure acResetMapExecute(Sender: TObject);
    procedure acNewBackupExecute(Sender: TObject);
    procedure SpeedButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure udColumnsClick(Sender: TObject; Button: TUDBtnType);
    procedure acImageNewExecute(Sender: TObject);
    procedure acImageDeleteExecute(Sender: TObject);
    procedure acGroupNewExecute(Sender: TObject);
    procedure acGroupDeleteExecute(Sender: TObject);
    procedure acGroupLoadListExecute(Sender: TObject);
    procedure acGroupSelectAllExecute(Sender: TObject);
    procedure acMasterLoadExecute(Sender: TObject);
    procedure cmbALListChange(Sender: TObject);
    procedure acItemAddExecute(Sender: TObject);
    procedure acMasterSaveExecute(Sender: TObject);
    procedure acItemRenameExecute(Sender: TObject);
    procedure acItemRemoveExecute(Sender: TObject);
    procedure acImagesExecute(Sender: TObject);
    procedure acMasterImportAccept(Sender: TObject);
    procedure acGroupSaveExecute(Sender: TObject);
    procedure acImageImportAccept(Sender: TObject);
    procedure acDefaultAddExecute(Sender: TObject);
    procedure acDefaultRemoveExecute(Sender: TObject);
    procedure acDefaultRenameExecute(Sender: TObject);
    procedure lblListNameClick(Sender: TObject);
    procedure ckbLocationsClickCheck(Sender: TObject);
    procedure cmbALImagesChange(Sender: TObject);
    procedure acGroupLoadExecute(Sender: TObject);
    procedure sbModeClick(Sender: TObject);
    procedure ALTab1Click(Sender: TObject);
    procedure cmbALListClick(Sender: TObject);
    procedure lvwDefAnswerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvwDefAnswerChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure lvwDefAnswerCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure acMasterExportAccept(Sender: TObject);
//    procedure grpNonNurseVfyEnter(Sender: TObject);
//    procedure grpNonNurseVfyExit(Sender: TObject);
    {
    Presents the user with a warning if changing default lists without
    saving current changes.

    Call the OnChange Event for cbxListName.
    }

  private
    { Private declarations }
    UpdateMode: Boolean;                // set to false during form load.
    FPRNEffectValue: Integer;
    FNonNurseVfyLvl: Integer;

    function GetParameter(Parameter: string; UpArrowPiece: Integer): string;
    (*
      Uses RPC 'PSB PARAMETER' to get a Site Parameter from the server.
      Returns parameter string if successful.
    *)

    function GetParameterLevel(Parameter: string; Level: string; UpArrowPiece:
      Integer): string;
    (*
      Uses RPC 'PSB PARAMETER' to get a Site Parameter from the server.
      Level should contain either 'DIV' or 'SYS' to specify the level of the
      parameter being retrieved.
      Returns parameter string if successful.
    *)

    function SetParameter(Parameter: string; newValue: string): Boolean;
    (*
      Uses RPC 'PSB PARAMETER' to save a Site Parameter to the server.
      Returns True if successful.
    *)

    function LeaveTsAnswerList: Boolean;
    (*  determine if the current list has been saved. Warn user and return users
    response.

    Returns   TRUE if ok to leave page
              FALSE if NOT
    *)

    procedure ExceptionHandler(Sender: TObject; E: Exception);
    (*
      Handles all OnException events by calling the global BCMA exception
      handler, BCMAExceptionHandler.
    *)


    procedure GetWardList();
    procedure GetIVPar(Value: string);
    procedure ClearAll();
    procedure PutIVPar();
    procedure LoadIHS;
    procedure SaveIHS;
    // For the checked radio button, get the non-nurse verified value.
    function GetNonNurseVfyFrBtn: Integer;
    // For the non-nurse verified value, set the corresponding radio button
    procedure PutNonNurseVfyToBtn;

{$IFDEF CAS_DDPE_TEST}
    procedure setALDivision(aDivision: string);
    procedure SaveAnatomicLocationMapList;
//    procedure setByList(aList: TStringList);
//    procedure setByALList(aList: TStringList);

//    function getWorkItem(ansli: TListItem): TListItem;
{$ENDIF}
    function getWorkItem(ansli: TListItem): TListItem;
    function getALGroupCurrent: TALGroup;
  public
    { Public declarations }
    Mode: string;
    alMRR: TALGroup;
    iChangeCount: Integer;
    ALMaster: TStringList;
    ALBackup: TStringList;
    frmALView: TfrmALMapEdit;
//    frmALDefaultView: TfrmALMapEdit;
    ALGroupList: TALGroupList;

    procedure msg_UM_ALSETUP(var Message: TMessage); message UM_ALSETUP;
    procedure setMasterList(aSL: TStringList);
    property NonNurseVfyLvl: Integer read FNonNurseVfyLvl write FNonNurseVfyLvl;

    property ALGroupCurrent: TALGroup read getALGroupCurrent;
  end;

var
  frmBCMAParameters: TfrmBCMAParameters;

  currentListName,
    Division,
    prevDivision,                       // rpk 4/25/2016
    DivisionIENS,
    SelectedWardIEN: string;
  currentListIndex: integer;
  BCMA_WardList: TBCMA_WardList;
  IVTypeList: TStringList;
  LeaveTsDefaultList_Warning: boolean = true;

implementation

uses
  BCMA_Startup, Debug, FAboutDlg, InputQry, VHA_Objects, fZZ_EventLog,
  uZZ_ChangeLog, fZZ_DebugEdit,
//  uCAS_Messages,
  StrUtils;

{$R *.DFM}

const
  msgImageNew =
    'Automation is Under construction.' + #13#10#13#10 +
    'To MANUALLY create new Image description:' + #13#10 +
    '1. Create WP parameter to hold image data' + #13#10 +
    '2. Add new parameter name to the PSB AL IMAGES parameter';

  msgImageDelete =
    'Automation is Under construction.' + #13#10#13#10 +
    'To MANUALLY delete the Image description:' + #13#10 +
    '1. Remove the name of parameter holding the image data from PSB AL IMAGES' + #13#10
    +
    '2. Delete the parameter' + #13#10;

  msgLocationGroupDelete =
    'Automation is Under construction.' + #13#10#13#10 +
    'To MANUALLY delete the AL Group description:' + #13#10 +
    '1. Remove the name of parameter holding the group data from PSB AL GROUPS' + #13#10
    +
    '2. Delete the parameter' + #13#10;


function ShowApplicationAndFocusOK(anApplication: TApplication):
  boolean;
var
  j: integer;
  Stat2: set of (sWinVisForm, sWinVisApp, sIconized);
  hFGWnd: THandle;
begin
  Stat2 := [];                          {sWinVisForm,sWinVisApp,sIconized}

  if IsWindowVisible(anApplication.MainForm.Handle) then
    Stat2 := Stat2 + [sWinVisForm];

  if IsWindowVisible(anApplication.Handle) then
    Stat2 := Stat2 + [sWinVisApp];

  if IsIconic(anApplication.Handle) then
    Stat2 := Stat2 + [sIconized];

  Result := true;
  if sIconized in Stat2 then
  begin                                 {A}
    j := SendMessage(anApplication.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
    Result := j <> 0;
  end;
  if Stat2 * [sWinVisForm, sIconized] = [] then
  begin                                 {S}
    anApplication.MainForm.Show;
  end;
  if (Stat2 * [sWinVisForm, sIconized] <> []) or
    (sWinVisApp in Stat2) then
  begin                                 {G}
    hFGWnd := GetForegroundWindow;
    try
      AttachThreadInput(
        GetWindowThreadProcessId(hFGWnd, nil),
        GetCurrentThreadId, True);
      Result := SetForegroundWindow(anApplication.Handle);
    finally
      AttachThreadInput(
        GetWindowThreadProcessId(hFGWnd, nil),
        GetCurrentThreadId, False);
    end;
  end;
end;                                    // ShowApplicationAndFocusOK

function StrRight(str: string; ByteRead: integer): string;
begin
  if ByteRead > Length(str) then
    Result := str
  else
    Result := Copy(str, Length(str) - ByteRead + 1, ByteRead);
end;                                    // StrRight

function TfrmBCMAParameters.GetNonNurseVfyFrBtn: Integer;
var
  i: integer;
begin
  i := -1;
  if rbtnAllow.Checked then
    i := 1
  else if rbtnAllowWarning.Checked then
    i := 2
  else if rbtnProhibit.Checked then
    i := 3;

  Result := i;
end;                                    // GetNonNurseVfyFrBtn

procedure TfrmBCMAParameters.PutNonNurseVfyToBtn;
begin
  case FNonNurseVfyLvl of
    1: rbtnAllow.Checked := True;
    2: rbtnAllowWarning.Checked := True;
    3: rbtnProhibit.Checked := True;
  else begin
      rbtnAllow.Checked := False;
      rbtnAllowWarning.Checked := False;
      rbtnProhibit.Checked := False;
    end;
  end;

end;                                    // PutNonNurseVfyToBtn

procedure TfrmBCMAParameters.btnIVParCancelClick(Sender: TObject);
begin
  cbxIVParWardChange(cbxIVParWard);
end;                                    // btnIVParCancelClick

procedure TfrmBCMAParameters.btnIHSCancelClick(Sender: TObject);
begin
  LoadIHS;
end;                                    // btnIHSCancelClick

procedure TfrmBCMAParameters.btnIHSOKClick(Sender: TObject);
begin
  lbledtPatIdLabel.Text := AnsiUpperCase(lbledtPatIdLabel.Text);
  SaveIHS;
end;                                    // btnIHSOKClick

procedure TfrmBCMAParameters.ExceptionHandler(Sender: TObject; E: Exception);
begin
  BCMAExceptionHandler(Sender, E);      (* Uses the BCMA Global exception handler. *)
end;                                    // ExceptionHandler

procedure TfrmBCMAParameters.FormCreate(Sender: TObject);
begin
  ForceForegroundWindow(handle);
  Caption := Application.Title;
  application.OnException := ExceptionHandler;

  UserIsLoggedOn := False;
  FNonNurseVfyLvl := -1;                // set default to undefined.
  LeaveTsDefaultList_Warning := True;   // rpk 4/5/2011
  prevDivision := '';                   // rpk 4/25/2016
  Division := '';                       // rpk 4/25/2016
  if (BCMA_User.IsManager) then
  begin
    MessageDlg('Updates to parameters are immediate!' + #13 + #13 +
      'Use this program with extreme care!',
      mtWarning, [mbOK], 0);

    UpdateMode := False;

    gbBCMA.Top := (self.Height - gbBCMA.Height - 80) div 2;
    gbBCMA.Left := (self.Width - gbBCMA.Width) div 2;
    lblDivision.Top := (gbBCMA.Top + gbBCMA.Height + 20);
    lblDivision.Left := (Self.Width - lblDivision.Width) div 2;

    UserIsLoggedOn := True;
    BCMA_WardList := TBCMA_WardList.Create(BCMA_Broker);

{$IFDEF TEST_ON}
    lblDivision.Caption := 'You are currently logged on to Division IEN: ' +
      BCMA_User.DivisionIEN + CRLF +
      ' Division Number: ' + BCMA_User.DivisionNum + CRLF +
      ' Division Name: ' + BCMA_User.DivisionName + CRLF +
//      ' - SiteIEN: ' + BCMA_User.SiteIEN +
    ' Production Acct.Flag: ' + BoolToStr(BCMA_User.ProductionAccount);
//      ' : Station: ' + BCMA_User.Station;
    DEBUG1.Enabled := True;
    DEBUG1.Visible := True;
{$ELSE}
//    lblDivision.Caption := 'You are currently logged on to Division: ' +
//      BCMA_User.DivisionIEN;
    lblDivision.Caption := 'You are currently logged on to Division: ' +
      BCMA_User.DivisionNum;
    DEBUG1.Enabled := False;
    DEBUG1.Visible := False;
{$ENDIF}                                // for future enhancement rpk 8/6/2010
    // lblDivision.Caption := 'You are currently logged on to Station ' +
    // BCMA_User.Station + ' Division: ' +      BCMA_User.DivisionName;
    cbxIVParType.Enabled := False;
{$IFDEF CAS_DDPE_DEBUG}
    DEBUG1.Enabled := True;
    DEBUG1.Visible := True;
{$ENDIF}

{$IFDEF TEST_ON}
    with lbledtDivPatIdLabel do begin
      Enabled := True;
      Show;
    end;
    with lbledtSysPatIdLabel do begin
      Enabled := True;
      Show;
    end;
    with lbledtAllPatIdLabel do begin
      Enabled := True;
      Show;
    end;
{$ENDIF}
  end
  else
    MessageDlg('No BCMA Manager Access', mtError, [mbok], 0);

{$IFDEF CAS_DDPE_TEST}
//  tsAL.Enabled := True;
//  tsAL.Show;
//  PostMessage(Handle, UM_ALSETUP, 0, 0);
{$ENDIF}

{$IFDEF R960057}                        // hiding the Provider Comments dropdown list
  Label41.Visible := false; ;
  ComboBox15.Visible := False;
{$ENDIF}

end;                                    // FormCreate

procedure TfrmBCMAParameters.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ActiveControl = updnPRNEffect then
    edtPRNEffect.OnClick(Sender);
end;                                    // FormClose

procedure TfrmBCMAParameters.FormCloseQuery(Sender: TObject; var CanClose:
  Boolean);
begin
  //perform page check before closing
  if LeaveTsAnswerList then
  begin
    LeaveTsDefaultList_Warning := false;
    menuFileCloseClick(Sender);
  end
  else
    CanClose := false;
end;

procedure TfrmBCMAParameters.menuFileOpenClick(Sender: TObject);
var
  DefBCFormat: Integer;
  tmpVar: Integer;
  tmpstr: string;
  tmpDivision: string;
begin
  if LeaveTsAnswerList then
  begin
    LeaveTsDefaultList_Warning := false;
    menuFileCloseClick(Sender);
    CurrentListName := '';
//    Division := '';
    tmpDivision := '';
{$IFDEF TEST_ON}
//    Division := BCMA_User.DivisionNum;  // rpk 5/2/2011; for future enhancement
    tmpDivision := BCMA_User.DivisionNum; // rpk 5/2/2011; for future enhancement
{$ENDIF}

{$IFDEF CAS_DDPE_TEST}
//    Division := BCMA_User.DivisionNum;
    tmpDivision := BCMA_User.DivisionNum;
{$ENDIF}
//    if InputQuery('Division Selection', 'Enter Facility Division Number:',
//      Division) then
    if InputQuery('Division Selection', 'Enter Facility Division Number:',
      tmpDivision) then
      with BCMA_Broker do
      begin
        //SaveMode := DebugMode;
        //DebugMode := False;

//        CallServer('PSB PARAMETER', ['GETDIV', Division], nil);
        CallServer('PSB PARAMETER', ['GETDIV', tmpDivision], nil);
        if piece(Results[0], '^', 1) = '-1' then
        begin
          MessageDlg('Error Retrieving Division. Please enter a valid station number. '
            + piece(Results[0], '^', 2),
            mtError, [mbOK], 0);
        end
        else
        begin
          // if Results.Count < 7 then
          // begin
                      //          ShowMessage('Get Division returned less than 7 results = ' +
                      //            IntToStr(Results.Count));
          //            MessageDlg('Internal error. Get Division should return 7 result lines; returned only '
          //              +
          //              IntToStr(Results.Count) + ' results.', mtError, [mbOK], 0);
          //            MessageDlg('Incomplete results returned.  Please enter a valid station number.', mtError, [mbOK], 0);  // rpk 8/6/2010
          //          end
          //          else
          //          begin
          Division := piece(Results[0], '^', 2);
          edtFacName.Text := Results[1];
          edtAddress1.Text := Results[2];
          edtAddress2.Text := Results[3];
          edtAddressCity.Text := Results[4];
          edtAddressState.Text := Results[5];
          edtAddressZip.Text := Results[6];

{ $IFDEF CAS_DDPE_TEST}
//          tsAL.Enabled := True;
//          tsAL.Show;
          PostMessage(Handle, UM_ALSETUP, 0, 0);
{ $ENDIF}

          //          end;
                    //System On-Line
          if GetParameter('PSB ONLINE', 1) <> '1' then
            cbxOnLine.State := cbUnChecked
          else
            cbxOnLine.State := cbChecked;

          //Maximum Server Clock Variance
          edtMaximumServerClockVariance.Text :=
            GetParameter('PSB Server Clock Variance', 2);

          //Require E-Sig to pass meds
          if GetParameter('PSB ADMIN ESIG', 1) <> '1' then
            cbxESig.State := cbUnChecked
          else
            cbxESig.State := cbChecked;

          // Include Continuous
          if GetParameter('PSB VDL INCL CONT', 1) <> '1' then
            cbxCont.State := cbUnChecked
          else
            cbxCont.State := cbChecked;

          // Include PRN
          if GetParameter('PSB VDL INCL PRN', 1) <> '1' then
            cbxPRN.State := cbUnChecked
          else
            cbxPRN.State := cbChecked;

          // Include One-Time
          if GetParameter('PSB VDL INCL ONE-TIME', 1) <> '1' then
            cbxOneTime.State := cbUnChecked
          else
            cbxOneTime.State := cbChecked;

          // Include On-Call
          if GetParameter('PSB VDL INCL ON-CALL', 1) <> '1' then
            cbxOnCall.State := cbUnChecked
          else
            cbxOnCall.State := cbChecked;

          //Using RobotRX
          if GetParameter('PSB ROBOT RX', 1) <> '1' then
            chkRobotRX.State := cbUnChecked
          else
            chkRobotRX.State := cbChecked;

          //Five Rights Unit Dose
          if GetParameter('PSB 5 RIGHTS UNITDOSE', 1) <> '1' then
            chk5UnitDose.State := cbUnChecked
          else
            chk5UnitDose.State := cbChecked;

          //Five Rights IV
          if GetParameter('PSB 5 RIGHTS IV', 1) <> '1' then
            chk5IV.State := cbUnChecked
          else
            chk5IV.State := cbChecked;

          //Rpt Max Range  {JK 5/9/2008}
          edtMaxDateRange.Text := GetParameter('PSB RPT MAX RANGE', 2);

          // Dermal Site History Max Days  // rpk 11/2/2015
//          edtInjSiteHistMaxHrs.Text :=
          edtDermSiteHistMaxDays.Text := // rpk 12/22/2015
            GetParameter('PSB DERMAL SITE MAX DAYS', 2);

          // Injection Site History Max Hours
          edtInjSiteHistMaxHrs.Text :=
            GetParameter('PSB INJECTION SITE MAX HOURS', 2);

          //Allow multiple Admins for On-Call
          if GetParameter('PSB ADMIN MULTIPLE ONCALL', 1) <> '1' then
            chkMultiAdmin.State := cbUnChecked
          else
            chkMultiAdmin.State := cbChecked;

          if GetParameter('PSB HKEY', 1) <> '1' then
            chkCPRSMedOrder.State := cbUnChecked
          else
            chkCPRSMedOrder.State := cbChecked;

          // Minutes Before
          cmbxMinBefore.ItemIndex :=
            StrToIntDef(GetParameter('PSB ADMIN BEFORE', 1), 0) div 10;

          // Minutes After
          cmbxMinAfter.ItemIndex := StrToIntDef(GetParameter('PSB ADMIN AFTER',
            1), 0) div 10;

          // Minutes PRN Effect
//          cmbxPRNEffect.ItemIndex :=
//            StrToIntDef(GetParameter('PSB ADMIN PRN EFFECT', 1), 0) div 10;
          updnPRNEffect.Position :=
            StrToIntDef(GetParameter('PSB ADMIN PRN EFFECT', 1), 0);
//          edtPRNEffect.Text := GetParameter('PSB ADMIN PRN EFFECT', 1);
          FPRNEffectValue := updnPRNEffect.Position;

          // VDL Start Time
          cmbxStartTime.ItemIndex :=
            StrToIntDef(GetParameter('PSB VDL START TIME', 1), 0);

          // VDL Stop Time
          cmbxStopTime.ItemIndex :=
            StrToIntDef(GetParameter('PSB VDL STOP TIME', 1), 0);

          // Default Bar Code Format
          DefBCFormat := StrToIntDef(GetParameter('PSB DEFAULT BARCODE FORMAT',
            1), -1);
          if DefBCFormat <> -1 then
            cbxBCFormat.ItemIndex := DefBCFormat - 1
          else
            cbxBCFormat.ItemIndex := DefBCFormat;

          tmpVar := StrToIntDef(GetParameter('PSB VDL PATCH DAYS', 1), 0);
          if tmpVar > 0 then
            tmpVar := tmpVar - 6
          else
            tmpVar := 0;

          cbxPatchDuration.ItemIndex := tmpVar;

          // Scratch HFS Directory
          //edtHFSScratch.Text := GetParameter('PSB HFS SCRATCH', 1);  bjr 5/12/10 for BCMA00000425

          // Backup HFS Directory
//          edtHFSBackup.Text := GetParameter('PSB PRINTER MISSING DOSE', 2);

          // Missing Dose Request Printers
          // Inpatient
          edtIMMissingDoseReqPrt.Text :=
            GetParameter('PSB PRINTER MISSING DOSE', 2);

          // Clinic
          edtCOMissingDoseReqPrt.Text :=
            GetParameter('PSB PRINTER CO MISSING DOSE', 2);

          // General Error MG
          //edtMGSysError.Text := GetParameter('PSB MG SYSTEM ERROR', 2);

          // Due List Error MG
          edtMGDLError.Text := GetParameter('PSB MG DUE LIST ERROR', 2);

          // Inpatient Missing Dose MG
          edtMGInpatientMissingDose.Text := GetParameter('PSB MG MISSING DOSE',
            2);

          edtMGUnknown.Text := GetParameter('PSB MG ADMIN ERROR', 2);

          edtMGMSF.Text := GetParameter('PSB MG SCANNING FAILURES', 2);
          // Auto Update Mail Group
//            edtMGAutoUpdate.Text := GetParameter('PSB MG AUTOUPDATE', 2);

          //  Default Bar Code Prefix
          edtBCPrefix.Text := GetParameter('PSB DEFAULT BARCODE PREFIX', 2);

          edtPatientTransfer.Text := GetParameter('PSB PATIENT TRANSFER', 2);

          // PRN Documentation
          edtPRNDoc.Text := GetParameter('PSB PRN DOCUMENTATION', 2);

          edtTimeOut.Text := GetParameter('PSB IDLE TIMEOUT', 2);

          // Medication History Days Back
          edtMedHistDaysBack.Text := GetParameter('PSB MED HIST DAYS BACK', 2);

          // Reports include comments checkbox
          if GetParameter('PSB RPT INCL COMMENTS', 1) <> '1' then
            cbxRptInclComm.State := cbUnChecked
          else
            cbxRptInclComm.State := cbChecked;

          // expect Non-Nurse Verified Prompt to have base 1 with max of 3
//          VALUE DATA TYPE: set of codes
//          VALUE DOMAIN:     1: N-Allow Admin No Warning
//                            2: W-Allow Admin after Warning
//                            3: P-Prohibit Administration

          tmpstr := GetParameter('PSB NON-NURSE VERIFIED PROMPT', 1);
          if tmpstr = '' then begin
            MessageDlg('Non-Nurse Verified Prompt Parameter is not set.' + #13 +
              #13 +
              'Reset to default of Allow with No Warning',
              mtWarning, [mbOK], 0);
            tmpstr := '1';
          end;

//          tmpvar := StrToIntDef(GetParameter('PSB NON-NURSE VERIFIED PROMPT', 1));
          tmpvar := StrToIntDef(tmpstr, 1);
          if tmpvar in [1..3] then
            FNonNurseVfyLvl := tmpvar
          else
//            FNonNurseVfyLvl := -1;
            FNonNurseVfyLvl := 1;       // use No Warning as default to avoid error in radio group.

          PutNonNurseVfyToBtn;

          // Get The Lists
          cbxListName.Items.Clear;
          cbxListName.Items.AddObject('Reason Medication Given PRN',
            TObject(lnPRN));
          cbxListName.Items.AddObject('Reason Medication Held',
            TObject(lnHeld));
          cbxListName.Items.AddObject('Reason Medication Refused',
            TObject(lnRefused));
//          cbxListName.Items.AddObject('Injection Sites', TObject(lnInjection));
          cbxListName.Items.AddObject(BodySiteList, TObject(lnBodySites));
{$IFDEF CAS_DDPE_TEST}
//          cbxListName.Items.AddObject(BodySiteChartList, TObject(lnBodySitesChart));
//          cbxListName.Items.AddObject(ALDefaultList, TObject(lnAnatomicLocations));
{$ENDIF}

          // empty the listview of any existing items
          lvwDefAnswer.Clear;

          // IHS tab should show only when running in IHS environment where agency
          // code is equal to I
          tbshtIHS.TabVisible := BCMA_User.AgencyCode = 'I';

          UpdateMode := True;
          PageControl1.Visible := True;

          PageControl1.ActivePage := tsFacility;
          if cbxOnLine.CanFocus then
            cbxOnLine.SetFocus;

        end;                            // else Results[0] not -1
        //DebugMode := SaveMode;
      end;                              // with BCMA_Broker
  end;                                  // if LeaveTsAnswerList
{ $IFNDEF CAS_DDPE_TEST}
  PageControl1.Pages[PageControl1.PageCount - 1].TabVisible := False;
  alTab1.Checked := False;
{ $ENDIF}
end;                                    // menuFileOpenClick

function TfrmBCMAParameters.GetParameter(Parameter: string; UpArrowPiece:
  Integer): string;
begin
  Result := '';
  BCMA_Broker.CallServer('PSB PARAMETER', ['GETPAR', Division,
    uppercase(Parameter)], nil);
  Result := piece(BCMA_Broker.Results[0], '^', UpArrowPiece);
end;

function TfrmBCMAParameters.GetParameterLevel(Parameter: string; Level: string;
  UpArrowPiece: Integer): string;
begin
  Result := '';
  BCMA_Broker.CallServer('PSB PARAMETER', ['GETPAR', Level,
    uppercase(Parameter)], nil);
  Result := piece(BCMA_Broker.Results[0], '^', UpArrowPiece);
end;

function TfrmBCMAParameters.SetParameter(Parameter: string; newValue: string):
  Boolean;
begin
  Result := False;
  if UpdateMode then
  begin
    // CQ 1462; convert empty string to '@' in order to do a Fileman delete of
    // the field contents in Vista
    if newValue = '' then               // rpk 11/5/2012
      newValue := '@';                  // rpk 11/5/2012

    //messagedlg('Update Parameter ' + Parameter + ' to ' + newValue,mtInformation,[mbyes,mbno],0);
    BCMA_Broker.CallServer('PSB PARAMETER', ['SETPAR', Division, Parameter, '1',
      newValue], nil);
    if piece(BCMA_Broker.Results[0], '^', 1) = '-1' then
      messagedlg('Invalid Parameter Value', mtError, [mbok], 0)
    else
      Result := True;
  end;
end;

procedure TfrmBCMAParameters.udColumnsClick(Sender: TObject;
  Button: TUDBtnType);
begin
  lbMaster.Columns := udColumns.Position;
  ckbLocations.Columns := udColumns.Position;
  lblColumns.Caption := format('%d', [udColumns.Position]);
end;

procedure TfrmBCMAParameters.updnPRNEffectExit(Sender: TObject);
begin
  if edtPRNEffect.CanFocus then
    edtPRNEffect.SetFocus;
  edtPRNEffect.OnExit(Sender);
end;

procedure TfrmBCMAParameters.updnPRNEffectMouseLeave(Sender: TObject);
begin
  if edtPRNEffect.CanFocus then
    edtPRNEffect.SetFocus;
end;

procedure TfrmBCMAParameters.WhatsThis1Popup(Sender, HelpItem: TObject;
  HContext: THelpContext; X, Y: Integer; var DoPopup: Boolean);
var
   tmpHC: THelpContext;
   tpopup: Boolean;
begin
  //since the control the user clicked on isn't easily available,
  //we'll use the HContext to determine if this is a control where we want
  //to disable the right click popup 'what's this?'
//  case HContext of
//    30, // the vdl, already has right click options
//    300, //Edit Med Log, grdMedications
//    902, //coversheet, already has right click options.
//    150: //Multiple Drugs CheckListBox
//      DoPopup := false;
//  end;

  tmpHC := HContext;
  tpopup := DoPopup;
end;

procedure TfrmBCMAParameters.menuFileCloseClick(Sender: TObject);
begin
  //perform page check before closing file
  if LeaveTsAnswerList then
  begin
    PageControl1.Visible := False;
    UpdateMode := False;
  end;

//  if Assigned(frmALView) then
//    FreeAndNil(frmALView);  // rpk 4/25/2016
  if assigned(frmALView) and assigned(frmalview.lvWork) then begin // rpk 5/2/2016
    removeShapes(frmALView.lvWork.Items, true);
    frmALView.lvWork.Items.Clear;
  end;

end;

procedure TfrmBCMAParameters.menuFileExitClick(Sender: TObject);
begin
  if LeaveTsAnswerList then
  begin
    LeaveTsDefaultList_Warning := false;
    menuFileCloseClick(Sender);
    LeaveTsDefaultList_Warning := false;
    //  Application.Terminate;
    Close;
  end;
end;

procedure TfrmBCMAParameters.mnListerPopup(Sender: TObject);
begin

  // build popup menu
//  mnLister.Items[0].Caption := '&Add New ...';
//  mnLister.Items[1].Caption := '&Edit ...';
//  mnLister.Items[2].Caption := '&Delete';

  //disable all options if there's no list selected
  if cbxListName.ItemIndex = -1 then
  begin
    mnLister.Items[0].enabled := False;
    mnLister.Items[1].enabled := False;
    mnLister.Items[2].enabled := False;
  end

  else                                  // turn on options

  begin
    //enable Add New
    mnLister.Items[0].enabled := True;

    // enable/disable Edit and Delete if and item is selected
    if cbxListName.Items.Count > 0 then
    begin
      mnLister.Items[1].enabled := (lvwDefAnswer.ItemIndex > -1);
      mnLister.Items[2].enabled := (lvwDefAnswer.ItemIndex > -1);
    end;
  end;
end;

procedure TfrmBCMAParameters.cbxOnLineClick(Sender: TObject);
begin
  if UpdateMode then begin
    if cbxOnLine.State = cbChecked then
      SetParameter('PSB ONLINE', 'Y')
    else if
      messageDlg('You are about to disable BCMA for ALL users in this division!'
      +
      #13#13 +
      'Click OK to continue.',
      mtWarning, [mbOK, mbCancel], 0) = mrOK then
      SetParameter('PSB ONLINE', 'N')
    else
      cbxOnLine.State := cbChecked;
  end;
end;

procedure TfrmBCMAParameters.cbxESigClick(Sender: TObject);
begin
  if cbxESig.State = cbChecked then
    SetParameter('PSB ADMIN ESIG', 'Y')
  else
    SetParameter('PSB ADMIN ESIG', 'N');
end;

procedure TfrmBCMAParameters.cbxContClick(Sender: TObject);
begin
  if cbxCont.State = cbChecked then
    SetParameter('PSB VDL INCL CONT', 'Y')
  else
    SetParameter('PSB VDL INCL CONT', 'N');
end;

procedure TfrmBCMAParameters.cbxPRNClick(Sender: TObject);
begin
  if cbxPRN.State = cbChecked then
    SetParameter('PSB VDL INCL PRN', 'Y')
  else
    SetParameter('PSB VDL INCL PRN', 'N');
end;

procedure TfrmBCMAParameters.cbxOneTimeClick(Sender: TObject);
begin
  if cbxOneTime.State = cbChecked then
    SetParameter('PSB VDL INCL ONE-TIME', 'Y')
  else
    SetParameter('PSB VDL INCL ONE-TIME', 'N');
end;

procedure TfrmBCMAParameters.cbxOnCallClick(Sender: TObject);
begin
  if cbxOnCall.State = cbChecked then
    SetParameter('PSB VDL INCL ON-CALL', 'Y')
  else
    SetParameter('PSB VDL INCL ON-CALL', 'N');
end;

procedure TfrmBCMAParameters.cmbxStartTimeClick(Sender: TObject);
begin
  SetParameter('PSB VDL START TIME', IntToStr(cmbxStartTime.ItemIndex));
end;

procedure TfrmBCMAParameters.cmbxStopTimeClick(Sender: TObject);
begin
  SetParameter('PSB VDL STOP TIME', IntToStr(cmbxStopTime.ItemIndex));
end;

procedure TfrmBCMAParameters.cmbxMinBeforeClick(Sender: TObject);
begin
  SetParameter('PSB ADMIN BEFORE', IntToStr(cmbxMinBefore.ItemIndex * 10));
end;

procedure TfrmBCMAParameters.cmbxMinAfterClick(Sender: TObject);
begin
  SetParameter('PSB ADMIN AFTER', IntToStr(cmbxMinAfter.ItemIndex * 10));
end;

//procedure TfrmBCMAParameters.cmbxPRNEffectClick(Sender: TObject);
//begin
//  SetParameter('PSB ADMIN PRN EFFECT', IntToStr(cmbxPRNEffect.ItemIndex * 10));
//end;

procedure TfrmBCMAParameters.edtEnter(Sender: TObject);
begin
  TEdit(Sender).Tag := 0;
end;

procedure TfrmBCMAParameters.edtChange(Sender: TObject);
begin
  TEdit(Sender).Tag := 1;
end;

procedure TfrmBCMAParameters.edtCOMissingDoseReqPrtExit(Sender: TObject);
begin
  if edtCOMissingDoseReqPrt.Tag <> 0 then
//    if not SetParameter('PSB PRINTER CO MISSING DOSE', edtIMMissingDoseReqPrt.Text) then
// CQ 1357
    if not SetParameter('PSB PRINTER CO MISSING DOSE',
      edtCOMissingDoseReqPrt.Text) then // rpk 8/23/2012
      edtCOMissingDoseReqPrt.Text := GetParameter('PSB PRINTER CO MISSING DOSE',
        2);
  edtCOMissingDoseReqPrt.Tag := 0;
end;

{procedure TfrmBCMAParameters.edtHFSScratchExit(Sender: TObject);
begin
  if edtHFSScratch.Tag <> 0 then
    if not SetParameter('PSB HFS SCRATCH', edtHFSScratch.Text) then
      edtHFSScratch.Text := GetParameter('PSB HFS SCRATCH', 1);
  edtHFSScratch.Tag := 0;
end;  bjr 5/12/10 for BCMA00000425}

{ procedure TfrmBCMAParameters.edtIMMissingDoseRequestPrtExit(Sender: TObject);
begin
  if edtHFSBackup.Tag <> 0 then
    if not SetParameter('PSB PRINTER MISSING DOSE', edtHFSBackup.Text) then
      edtHFSBackup.Text := GetParameter('PSB PRINTER MISSING DOSE', 2);
  edtHFSBackup.Tag := 0;
end; }

procedure TfrmBCMAParameters.edtIMMissingDoseRequestPrtExit(Sender: TObject);
begin
  if edtIMMissingDoseReqPrt.Tag <> 0 then
    if not SetParameter('PSB PRINTER MISSING DOSE', edtIMMissingDoseReqPrt.Text)
      then
      edtIMMissingDoseReqPrt.Text := GetParameter('PSB PRINTER MISSING DOSE',
        2);
  edtIMMissingDoseReqPrt.Tag := 0;
end;

procedure TfrmBCMAParameters.edtDermSiteHistMaxDaysExit(Sender: TObject); // rpk 11/2/2015
const
  // range check 1..99 days
  maxdermsitehistdays = 99;
var
  idays: Integer;
begin
  if edtDermSiteHistMaxDays.Tag <> 0 then begin
    if TryStrToInt(edtDermSiteHistMaxDays.Text, idays) then begin
      if (idays < 1) or (idays > maxdermsitehistdays) then begin
        MessageDlg('Invalid Parameter Value ' +
          edtDermSiteHistMaxDays.Text + '.  Range is 1 - 99 days.', mtError,
          [mbok], 0);
        edtDermSiteHistMaxDays.Text :=
          GetParameter('PSB DERMAL SITE MAX DAYS', 2);
        if edtDermSiteHistMaxDays.CanFocus then
          edtDermSiteHistMaxDays.SetFocus;

        Exit;
      end;

    end;

    if not SetParameter('PSB DERMAL SITE MAX DAYS',
      edtDermSiteHistMaxDays.Text) then begin
      edtDermSiteHistMaxDays.Text :=
        GetParameter('PSB DERMAL SITE MAX DAYS', 2);
      if PageControl1.Visible then
        if edtDermSiteHistMaxDays.CanFocus then
          edtDermSiteHistMaxDays.SetFocus;
    end;
  end;
  edtDermSiteHistMaxDays.Tag := 0;
end;                                    // edtDermSiteHistMaxHrsExit


procedure TfrmBCMAParameters.edtInjSiteHistMaxHrsExit(Sender: TObject);
const
  maxinjsitehisthrs = 72;
var
  ihours: Integer;
begin
  if edtInjSiteHistMaxHrs.Tag <> 0 then begin
    // range check 0..72 hours
    if TryStrToInt(edtInjSiteHistMaxHrs.Text, ihours) then begin
      if (ihours < 1) or (ihours > maxinjsitehisthrs) then begin
        MessageDlg('Invalid Parameter Value ' +
          edtInjSiteHistMaxHrs.Text + '.  Range is 1 - 72 hours.', mtError,
          [mbok], 0);
        edtInjSiteHistMaxHrs.Text :=
          GetParameter('PSB INJECTION SITE MAX HOURS', 2);
        if edtInjSiteHistMaxHrs.CanFocus then
          edtInjSiteHistMaxHrs.SetFocus;

        Exit;
      end;

    end;

    if not SetParameter('PSB INJECTION SITE MAX HOURS',
      edtInjSiteHistMaxHrs.Text) then begin
      edtInjSiteHistMaxHrs.Text :=
        GetParameter('PSB INJECTION SITE MAX HOURS', 2);
      if PageControl1.Visible then
        if edtInjSiteHistMaxHrs.CanFocus then
          edtInjSiteHistMaxHrs.SetFocus;
    end;
  end;
  edtInjSiteHistMaxHrs.Tag := 0;
end;                                    // edtInjSiteHistMaxHrsExit

procedure TfrmBCMAParameters.edtMGSysErrorExit(Sender: TObject);
begin
  //  if edtMGSysError.Tag <> 0 then
  //    if not SetParameter('PSB MG SYSTEM ERROR', edtMGSysError.Text) then
  //      edtMGSysError.Text := GetParameter('PSB MG SYSTEM ERROR', 2);
  //  edtMGSysError.Tag := 0;
end;

procedure TfrmBCMAParameters.edtMGDLErrorExit(Sender: TObject);
begin
  if edtMGDLError.Tag <> 0 then
    if not SetParameter('PSB MG DUE LIST ERROR', edtMGDLError.Text) then
      edtMGDLError.Text := GetParameter('PSB MG DUE LIST ERROR', 2);
  edtMGDLError.Tag := 0;
end;

procedure TfrmBCMAParameters.edtMGInpatientMissingDoseExit(Sender: TObject);
begin
  if edtMGInpatientMissingDose.Tag <> 0 then
    if not SetParameter('PSB MG MISSING DOSE', edtMGInpatientMissingDose.Text)
      then
      edtMGInpatientMissingDose.Text := GetParameter('PSB MG MISSING DOSE', 2);
  edtMGInpatientMissingDose.Tag := 0;
end;

procedure TfrmBCMAParameters.mnListAddClick(Sender: TObject);
var
  newVal: string;                       // holds the value of the item name
  ListItem: TListItem;                  // reference to the current ListView Row
  CheckState: Boolean;                  // holds the state of the inputPrompt() checkbox
  CheckState2: Boolean;                 // holds the state of the second inputPrompt() checkbox
  Attribute: string;                    // holds the value of the items attribute (req pain)
  Attribute2: string;                   // holds the second value of the items attribute
  bfound: Boolean;
  i: integer;
begin
  // set defaults
  CheckState := false;
  CheckState2 := False;
  newVal := '';
  Attribute := '';
  Attribute2 := '';

  // don't allow the user to enter more than 100 items in a list
  if lvwDefAnswer.Items.Count >= 100 then
  begin
    MessageDlg('A maximum of 100 entries have already been entered!',
      mtWarning, [mbOK], 0);
    exit;
  end;

  //prompt user for the new item
  if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnPRN then
  begin                                 // and include pain score checkbox for PRN list
    newVal := inputPrompt('Add New Item', 'Item:', '', 30, false, false,
      CheckState, 'Requires Pain Score');
    // Covert Attribute to text
    if CheckState = true then
      Attribute := 'Requires Pain Score';
  end
  else if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) =
    lnBodySites then
  begin                                 // and include pain score checkbox for PRN list
    newVal := inputPrompt2('Add New Item', 'Item:', '', 30, true, false,
      CheckState, 'Injection Site', CheckState2, 'Dermal Site');
    if CheckState = true then
      Attribute := 'Y';
    if CheckState2 = true then
      Attribute2 := 'Y';
  end
  else begin                            // don't include any check box
    newVal := inputPrompt('Add New Item', 'Item:', '', 30, false, false,
      CheckState, '');
  end;

  //remove leading and trailing spaces before we check for null
  newVal := StripString(newVal, True);
//  newVal := UpperCase(newVal);
  if newVal <> '' then begin
    // don't add if there's no item name or if nothing changed
    // need to check for duplicates
    bfound := False;
    for I := 0 to lvwDefAnswer.items.Count - 1 do
//      if lvwDefAnswer.Items[i].Caption = newVal then begin
      if SameText(lvwDefAnswer.Items[i].Caption, newVal) then begin // rpk 6/14/2016
        bfound := True;
        break;
      end;

    if bfound then begin
      ShowMessage(newVal + ' is already in the list. Not added.');
    end
    else begin
    // add the item to the List view (column 1)
      ListItem := lvwDefAnswer.Items.Add;
      ListItem.Caption := newVal;

    // Convert Attribute to text
//    if CheckState = true then
//      Attribute := 'Requires Pain Score';

      // add the attribute to the ListView (column 2)
      ListItem.SubItems.Add(Attribute);
      // add the attribute to the ListView (column 3)
      ListItem.SubItems.Add(Attribute2);

      btnSaveList.Enabled := True;
    end;
  end;
end;                                    // mnListAddClick

procedure TfrmBCMAParameters.mnDeleteItemClick(Sender: TObject);
begin
  with lvwDefAnswer do
    if ItemIndex > -1 then begin
      if MessageDLG('Remove item ' + Items[ItemIndex].Caption + ' ?', // rpk 1/14/2016
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
        Items.Delete(ItemIndex);
        btnSaveList.Enabled := True;
      end;
    end;
end;

procedure TfrmBCMAParameters.mnListEditClick(Sender: TObject);
var
  newVal: string;                       // the value of the item name
  curVal: string;                       // the existing value of the item
  listItem: TListItem;                  // reference to the current ListVeiw Row
  CheckState: boolean;                  // the state of the inputPrompt() first checkbox
  CheckState2: boolean;                 // the state of the inputPrompt() second checkbox
  curCheckState: boolean;               // the existing state of first cbx
  curCheckState2: boolean;              // the existing state of second cbx
  Attribute: string;                    // the value of the items attribute (req pain)
  Attribute2: string;                   // the value of the items attribute (req pain)
  bfound: Boolean;
  i: Integer;
begin
  curCheckState := false;
  CurCheckState2 := False;
  with lvwDefAnswer do
    if ItemIndex > -1 then begin
      listItem := lvwDefAnswer.Selected; // rpk 1/6/2016
      //preset existing values
      Attribute := '';
      Attribute2 := '';
      newVal := listItem.Caption;       // rpk 1/6/2016
      curVal := newVal;
      CheckState := false;
      CheckState2 := False;
      if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnPRN
        then
      begin;
        if Items[ItemIndex].subitems[0] = 'Requires Pain Score' then
        begin;
          CheckState := true;
          curCheckState := true;
        end;
      end
      else if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) =
        lnBodySites then begin
        if Items[ItemIndex].subitems[0] = 'Y' then
        begin;
          CheckState := true;
          curCheckState := true;
        end;
        if Items[ItemIndex].subitems[1] = 'Y' then
        begin;
          CheckState2 := true;
          curCheckState2 := true;
        end;

      end;

      //prompt user for the new item and only add checkbox for PRN's
      if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnPRN
        then
        // and include pain score checkbox
      begin
        newVal := inputPrompt('Edit Item', 'Item:', newVal, 30, false, false,
          CheckState, 'Requires Pain Score');
      end
      else if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) =
        lnBodySites
        then
        // and include injection site and dermal site checkboxes
      begin
        newVal := inputPrompt2('Edit Item', 'Item:', newVal, 30, true, false,
          CheckState, 'Injection Site', CheckState2, 'Dermal Site');
      end
      else
        // don't include any check box
      begin
        newVal := inputPrompt('Edit Item', 'Item:', newVal, 30, false, false,
          CheckState, '');
      end;

      //strip invalid chars and trailing sp... warn user...
      newVal := StripString(newVal, True);
      // don't add if there's no item name or if nothing changed
      if newVal <> '' then
        if ((newVal <> curVal) or
          (checkState <> curCheckState) or
          (checkState2 <> curCheckState2)) then begin
          if (curVal <> newVal) then begin
            // need to check for duplicates
            bfound := False;
            for I := 0 to lvwDefAnswer.items.Count - 1 do
              if SameText(lvwDefAnswer.Items[i].Caption, newVal) then begin // rpk 6/14/2016
                bfound := True;
                break;
              end;

            if bfound then
              ShowMessage(newVal + ' is already in the list. Not changed.')
            else
              listItem.Caption := newVal;
          end;                          // if (newVal <> '') and (curVal <> newVal)

          // set if checkbox was checked
          if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnPRN
            then begin
            if CheckState = true then
              Attribute := 'Requires Pain Score';
          end
          else if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) =
            lnBodySites then begin
            if CheckState = true then
              Attribute := 'Y';
            if CheckState2 = true then
              Attribute2 := 'Y';
          end;                          // newval <> curval
          btnSaveList.Enabled := True;
          if lvwDefAnswer.Columns.Count < 1 then
            ListItem.SubItems.Add(Attribute);
          if lvwDefAnswer.Columns.Count < 2 then
            ListItem.SubItems.Add(Attribute2);
          if curCheckState <> CheckState then begin
            if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) =
              lnPRN then                // rpk 7/19/2016
              Items[ItemIndex].subitems[0] := Attribute // rpk 7/19/2016
            else                        // rpk 7/19/2016
              Items[ItemIndex].subitems[0] := IfThen(CheckState, 'Y', '');
          end;
          if curCheckState2 <> CheckState2 then
            Items[ItemIndex].subitems[1] := IfThen(CheckState2, 'Y', '');
          Items[ItemIndex].Update;
        end;                            // ((newVal <> curVal) or (checkState <> curCheckState) or (checkState2 <> curCheckState2))
    end;                                //   with lvwDefAnswer do, if ItemIndex > -1 then
end;                                    // mnListEditClick

procedure TfrmBCMAParameters.btnSaveListClick(Sender: TObject);
var
  i: integer;                           // counter for item loop
  Parameter: string;                    // site parameter being saved
  ItemAttrib: string;                   // flag for "requries pain score" in prn list
  tbool: Boolean;
  tmpSL: TStringlist;
begin
  // default Attribute to nothing
  ItemAttrib := '';
  if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnPRN then
    Parameter := 'PSB LIST REASONS GIVEN PRN';
  if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnHeld then
    Parameter := 'PSB LIST REASONS HELD';
  if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnRefused
    then
    Parameter := 'PSB LIST REASONS REFUSED';
  if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnInjection
    then
    Parameter := 'PSB LIST INJECTION SITES';
  if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnBodySites
    then
    Parameter := pnBodySites;
  //delete the entire list before we save the new list
  if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) <> lnBodySites
    then begin
    BCMA_Broker.CallServer('PSB PARAMETER', ['DELLST', Division, Parameter],
      nil);

  //save each item in the current listview
    for i := 0 to lvwDefAnswer.Items.Count - 1 do
    begin
    // add the pain score flag to PRN Reasons
      if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnPRN
        then
      begin
        if lvwDefAnswer.Items[i].SubItems[0] = 'Requires Pain Score' then
          ItemAttrib := '|1'
        else
          ItemAttrib := '|0';
      end;
        // save the parameter
      BCMA_Broker.CallServer('PSB PARAMETER',
        ['SETPAR', Division, Parameter, IntToStr(i + 1),
        lvwDefAnswer.Items[i].Caption + ItemAttrib], nil);

        // warn the user if an Item is not saved.
      if piece(BCMA_Broker.Results[0], '^', 1) = '-1' then
        messagedlg('Invalid Parameter Value [' + lvwDefAnswer.Items[i].Caption +
          '] was not saved.',
          mtError, [mbok], 0);
    end;                                // for i := 0 to lvwDefAnswer.Items.Count - 1
  end;                                  // if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) <> lnBodySites then begin

  if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnBodySites
    then begin
    tmpSL := AnatomicalLocationsToStrings(lvwDefAnswer.Items);
    try
      ALBackup.Assign(tmpSL);
      ALGroupCurrent.setByList(ALBackup);
      ALGroupCurrent.Save(Division);
      // save any additions to group in master list
      // if an item in body site list is missing in master list, add it to master list
      tbool := UpdateMasterList(Division, tmpSL);

    finally
      tmpSL.Free;
    end;
  end;                                  //   if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnBodySites

  //disable the save button and refresh the list
  btnSaveList.Enabled := False;
  cbxListName.OnChange(btnSaveList);
end;                                    // btnSaveListClick

procedure TfrmBCMAParameters.menuHelpAboutClick(Sender: TObject);
begin
  //  messagedlg('BCMA Parameters Setup - Version 1.0',mtinformation,[mbok],0);
  AboutDlg.Execute;
end;

procedure TfrmBCMAParameters.edtMaxDateRangeExit(Sender: TObject);
begin
  if edtMaxDateRange.Tag <> 0 then
    if not SetParameter('PSB RPT MAX RANGE', edtMaxDateRange.Text) then
    begin
      edtMaxDateRange.Text := GetParameter('PSB RPT MAX RANGE', 2);
      if PageControl1.Visible then
        edtMaxDateRange.SetFocus;
    end;
  edtMaxDateRange.Tag := 0;
end;

procedure TfrmBCMAParameters.edtMaximumServerClockVarianceExit(Sender: TObject);
begin
  if edtMaximumServerClockVariance.Tag <> 0 then
    if not SetParameter('PSB SERVER CLOCK VARIANCE',
      edtMaximumServerClockVariance.Text) then
      edtMaximumServerClockVariance.Text :=
        GetParameter('PSB SERVER CLOCK VARIANCE', 2);
  edtMaximumServerClockVariance.Tag := 0;
end;

procedure TfrmBCMAParameters.menuHelpContentsClick(Sender: TObject);
begin
  with Application do
    //	if not HelpCommand(HELP_CONTENTS, 0) then
    if not HelpCommand(HELP_FINDER, 0) then
      messageDlg('Error accessing ' + application.helpfile, mtError, [mbOK], 0);
end;

procedure TfrmBCMAParameters.menuHelpIndexClick(Sender: TObject);
begin
  with Application do
    if not HelpCommand(HELP_INDEX, 0) then
      DefMessageDlg('Error accessing ' + application.helpfile, mtError, [mbOK],
        0);
end;

procedure TfrmBCMAParameters.PageControl1Change(Sender: TObject);
//var
//  i: integer;
begin
  with PageControl1 do
    if ActivePage = tsFacility then begin
      cbxOnLine.SetFocus;
        {else if ActivePage = tsParameters then
edtHFSScratch.setFocus  bjr 5/12/10 for BCMA00000425}
//      tsFacility.HelpContext := 2;
//      cbxOnLine.HelpContext := 2;
    end
    else if ActivePage = tsParameters then begin
      edtIMMissingDoseReqPrt.SetFocus;
    end
    else if ActivePage = tsAnswerList then
    begin
      cbxListName.setFocus;
      cbxListName.ItemIndex := 0;
      cbxListName.OnChange(self);
//      tsAnswerList.HelpContext := 4;
//      cbxListName.HelpContext := 4;
    end
    else if ActivePage = tbshtIVParameters then
    begin
      getwardlist;
      cbxIVParWard.ItemIndex := 0;
      cbxIVParWardChange(cbxIVParWard);
    end
    else if ActivePage = tbshtIHS then
    begin
      LoadIHS;
    end
{$IFDEF CAS_DDPE_TEST}
    { else if ActivePage = tsAL then
    begin
      setALDivision(Division);
      if assigned(frmALView) then
      begin
        removeShapes(frmALView.lvWork.Items, true);
        frmALView.Parent := pnlBodyChart;
        frmALView.bparLvwDefAnswer := lvwDefAnswer;
      end;

      ckbLocations.Items.Assign(ALMaster);
      lbMaster.Items.Assign(ALMaster);
    end; }
{$ENDIF}
      ;
  HelpContext := PageControl1.ActivePage.HelpContext; // rpk 5/4/2011

end;                                    // PageControl1Change

procedure TfrmBCMAParameters.cbxListNameChange(Sender: TObject);
const
  itemwidth = 260;
  injwidth = 90;
  dermwidth = 80;
var
  i: integer;                           //counter to walk thru the broker results
  Parameter: string;                    //parameter list being retrieved by broker
  ListItem, ansli, workli: TListItem;   //item being added to the listview
//  STS: TStrings;
  LItem: TALItem;
  s, sa, sb: string;
  injval, dermval: Integer;
  SL: TStringList;
begin
  lvwDefAnswer.PopupMenu := mnLister;
  btnEditLayoutDAL.Enabled := False;
  lvwDefAnswer.HelpContext := 122;        // rpk 9/7/2016

  s := '';
  // only perform the change if a new list is selected or
  // as a refresh after the save button or
  // the Edit Layout button is clicked.
//  if Sender is TAction then
//    s := TAction(Sender).ActionComponent.Name;
  sa := '';
  sb := '';
  if Sender is TAction then
    sa := TAction(Sender).ActionComponent.Name;
  if Sender is TButton then
    sb := TButton(Sender).Name;

//  if (currentListName <> cbxListName.text) or (Sender = btnSaveList) or
//    (S = btnEditLayoutDAL.Name) then
  if (currentListName <> cbxListName.text) or (Sender = btnSaveList) or
    (sa = btnEditLayoutDAL.Name) then
  begin
    lvwDefAnswer.Items.Clear;           // remove entries from the ListView
    currentListName := cbxListName.text;
    currentListIndex := cbxListName.ItemIndex;
    Parameter := '';

    // adjust the 2nd column based on the list selected
    { if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) <> lnPRN
      then
    begin
      //hide the 2nd column and delete the header caption
      lvwDefAnswer.Columns[1].Caption := '';
      lvwDefAnswer.Columns[1].Width := 0;
      lvwDefAnswer.Columns[0].Width := lvwDefAnswer.Width - 4;
    end
    else
    begin
      //show the 2nd column and set the header caption
      lvwDefAnswer.Columns[1].Caption := 'Attribute';
      lvwDefAnswer.Columns[1].Width := (lvwDefAnswer.Width div 2) - 2;
      lvwDefAnswer.Columns[0].Width := (lvwDefAnswer.Width div 2) - 2;
    end; }

    // adjust the 2nd column based on the list selected
    if (TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) = lnPRN)
      then
    begin
      //show the 2nd column and set the header caption
      if lvwDefAnswer.Columns.Count > 2 then begin
        lvwDefAnswer.Columns[2].Caption := '';
        lvwDefAnswer.Columns[2].Width := 0;
      end;
      lvwDefAnswer.Columns[1].Caption := 'Attribute';
      lvwDefAnswer.Columns[1].Width := (lvwDefAnswer.Width div 2) - 2;
      lvwDefAnswer.Columns[0].Width := (lvwDefAnswer.Width div 2) - 2;
    end
    else if (TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) =
      lnBodySites) then
    begin
      //show the 2nd and 3rd columns and set the header caption
//      lvwDefAnswer.Columns[0].Width := (lvwDefAnswer.Width div 3) - 2;
//      lvwDefAnswer.Columns[0].Width := lvwDefAnswer.ClientWidth - (injwidth + dermwidth);
//      lvwDefAnswer.Columns[1].Width := (lvwDefAnswer.Width div 3) - 2;
//        lvwDefAnswer.Columns[2].Width := (lvwDefAnswer.Width div 3) - 2;
      lvwDefAnswer.Columns[0].Width := itemwidth;
      lvwDefAnswer.Columns[1].Caption := 'Injection Site';
      lvwDefAnswer.Columns[1].Width := injwidth;
      if lvwDefAnswer.Columns.Count > 2 then begin
        lvwDefAnswer.Columns[2].Caption := 'Dermal Site';
        lvwDefAnswer.Columns[2].Width := dermwidth;
      end;
      lvwDefAnswer.HelpContext := 16;   // rpk 9/7/2016
    end
    else
    begin
      //hide the 2nd column and delete the header caption
      if lvwDefAnswer.Columns.Count > 2 then begin
        lvwDefAnswer.Columns[2].Caption := '';
        lvwDefAnswer.Columns[2].Width := 0;
      end;
      lvwDefAnswer.Columns[1].Caption := '';
      lvwDefAnswer.Columns[1].Width := 0;
      lvwDefAnswer.Columns[0].Width := lvwDefAnswer.Width - 4;
    end;

    // prep parameter for the broker call
    if cbxListName.Text <> '' then
      case TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) of
        lnPRN: Parameter := 'PSB LIST REASONS GIVEN PRN';
        lnHeld: Parameter := 'PSB LIST REASONS HELD';
        lnRefused: Parameter := 'PSB LIST REASONS REFUSED';
        lnInjection: Parameter := 'PSB LIST INJECTION SITES';
        lnBodySites: Parameter := pnBodySites;
{$IFDEF CAS_DDPE_V1}
        lnAnatomicLocations: Parameter := pnAnatomicLocationTransdermal;
{$ENDIF}
{ $IFDEF xxxCAS_DDPE_TEST}
{$IFDEF CAS_DDPE_TEST}
        lnAnatomicLocations: Parameter := pnAnatomicLocationMasterList;
//        lnBodySitesChart: Parameter := '';
{$ENDIF}
      else
        exit;
      end;

    // retrieve list values
    if (Parameter <> '') and
      (Parameter <> pnBodySites) and
      (Parameter <> pnAnatomicLocationMasterList) then
      with BCMA_Broker do
      begin
        if CallServer('PSB PARAMETER', ['GETLST', Division, Parameter], nil)
          then
          for i := 1 to BCMA_Broker.Results.Count - 1 do
          begin
            // add item name to column 1 of the list view
            // always use piece to allow additional future to be added w/o impact
            ListItem := lvwDefAnswer.Items.Add;
            ListItem.Caption := piece(BCMA_Broker.Results[i], '|', 1);
//            ListItem.StateIndex := -1;  // set default so that list change does not carry body site stateindex

            //add attribute to column 2 for PRNs
            if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) =
              lnPRN then
            begin
              // attribute as 2nd piece
              if piece(BCMA_Broker.Results[i], '|', 2) = '1' then
                ListItem.SubItems.Add('Requires Pain Score')
              else
                ListItem.SubItems.Add('');
              ListItem.SubItems.Add(''); // add a third empty column to allow for common list
            end
            //add attributes to column 2 and 3 for body sites
            else if TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex])
              =
              lnBodySites then
            begin
              // injection as 2nd piece
              if piece(BCMA_Broker.Results[i], '|', 2) = '1' then
                ListItem.SubItems.Add('Y')
              else
                ListItem.SubItems.Add('');
              // dermal as 3rd piece
              if piece(BCMA_Broker.Results[i], '|', 3) = '1' then
                ListItem.SubItems.Add('Y')
              else
                ListItem.SubItems.Add('');
            end
            else begin
              // add two empty subItems to all other lists
              ListItem.SubItems.Add('');
              ListItem.SubItems.Add('');
            end;
          end;  // for i

        // disable the SAVE LIST button if we've changed lists.
        btnSaveList.Enabled := false;

        pnlMRR.Visible := False;
      end;                              // list changed
{$IFDEF CAS_DDPE_V1}
    splChartDefault.Visible := False;
{$ENDIF}
{ $IFDEF xxxCAS_DDPE_TEST}
{ $IFDEF CAS_DDPE_TEST}
    if Parameter = '' then
//      Parameter := pnAnatomicLocationMasterList
//      Parameter := pnAnatomicLocationMRR
      Parameter := pnBodySites
    else
    begin
      splChartDefault.Align := alTop;
      splChartDefault.Visible := False;
    end;

//    if Parameter = pnAnatomicLocationMasterList then
    {if (Parameter = pnAnatomicLocationMRR) or
      (Parameter = pnAnatomicLocationMasterList) or
      (Parameter = pnBodySites) then
    begin
      if (Parameter = pnAnatomicLocationMRR) or
        (Parameter = pnAnatomicLocationMasterList) then
        lvwDefAnswer.PopupMenu := mnAL; }

    if (Parameter = pnAnatomicLocationMasterList) or // rpk 1/6/2016
      (Parameter = pnBodySites) then
    begin
      if Parameter = pnAnatomicLocationMasterList then
        lvwDefAnswer.PopupMenu := mnAL;
      iChangeCount := 0;

      lvwDefAnswer.Clear;

      alMRR.ClearItems;
      alMRR.GroupName := Parameter;
      alMRR.Load(Division);
      cmbDefaultImage.Text := alMRR.ImageName;

      for i := 0 to alMRR.LocationItems.Count - 1 do
      begin
        ListItem := lvwDefAnswer.Items.Add;
        ListItem.Caption := alMRR.LocationItems[i];
        s := alMRR.LocationItems[i];
        if Parameter = pnBodySites then begin
          LItem := TALItem(alMRR.LocationItems.Objects[i]);
          if Assigned(LItem) then begin
            s := LItem.toString;
            injval := LItem.InjectionFlag;
            dermval := LItem.DermalFlag;
            ListItem.SubItems.Add(IfThen(injval = 1, 'Y', ''));
            ListItem.SubItems.Add(IfThen(dermval = 1, 'Y', ''));
            ListItem.SubItems.Add(IntToStr(LITem.id)); // ID
            ListItem.SubItems.Add(IntToStr(LItem.X)); // X
            ListItem.SubItems.Add(IntToStr(LItem.Y)); // Y
          end;                          // if Assigned(LItem)
        end;                            // if Parameter = pnBodySites
      end;                              // for i

      lvwDefAnswer.Invalidate;
      Application.ProcessMessages;

      SL := alMRR.LocItemsToSL;
      pnlMRR.Visible := True;
      splChartDefault.Visible := True;
      splChartDefault.Align := alBottom;


      try
        ALBackup.Assign(SL);
        ALGroupCurrent.setByList(ALBackup);
      finally
        SL.Free;
      end;

      if assigned(frmALView) then
      begin
        removeShapes(frmALView.lvWork.Items, true);
        frmALView.lvWork.Items.Clear;
        frmALView.Parent := pnlChartDefault;
        frmALView.setByList(ALBackup);
//          frmALView.setByList(ALBackup, pnlChartDefault);  // rpk 5/2/2016
        frmALView.ViewMode := mmView;
        if Assigned(frmALMapEdit) then
          frmALView.imgBody.Picture.Assign(frmALMapEdit.imgBody.Picture);
        frmALView.LocationsRefresh;
//        frmALView.LocationsRefresh(pnlChartDefault);
        frmALView.bparLvwDefAnswer := lvwDefAnswer;
        frmALView.Invalidate;
      end;

      // set lvwDefAnswer.StateIndex to match StateIndex in lvwWork
      for I := 0 to lvwDefAnswer.Items.Count - 1 do begin
        if (Parameter = pnBodySites) then begin
          ansli := lvwDefAnswer.Items[i];
          if assigned(ansli) then begin
            workli := getWorkItem(ansli);
            if Assigned(workli) then
              ansli.StateIndex := workli.StateIndex;
          end;
        end                             // if (Parameter = pnBodySites)
        else
          ansli.StateIndex := -1;
      end;                              // for i
    end;                                // if (Parameter = pnAnatomicLocationMasterList) or (Parameter = pnBodySites) then

    if Parameter = pnBodySites then
      btnEditLayoutDAL.Enabled := True;

    Application.ProcessMessages;
  end;                                  //   if (currentListName <> cbxListName.text) or (Sender = btnSaveList) or (S = btnEditLayoutDAL.Name) then

{ $ENDIF}

end;                                    // cbxListNameChange

procedure TfrmBCMAParameters.getwardlist();
var
  i: Integer;
begin
  with BCMA_WardList do
  begin
    LoadWardData;
    cbxIVParWard.Items.Clear;
    for i := 0 to Wards.Count - 1 do
      cbxIVParWard.Items.Add(TBCMA_WardList(Wards[i]).WardName);
  end;
end;

procedure TfrmBCMAParameters.GroupBox1Enter(Sender: TObject);
begin
  with GroupBox1 do begin
    Font.Style := Font.Style + [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.GroupBox1Exit(Sender: TObject);
begin
  with GroupBox1 do begin
    Font.Style := Font.Style - [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.GroupBox2Enter(Sender: TObject);
begin
  with GroupBox2 do begin
    Font.Style := Font.Style + [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.GroupBox2Exit(Sender: TObject);
begin
  with GroupBox2 do begin
    Font.Style := Font.Style - [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.GroupBox6Enter(Sender: TObject);
begin
  with GroupBox6 do begin
    Font.Style := Font.Style + [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.GroupBox6Exit(Sender: TObject);
begin
  with GroupBox6 do begin
    Font.Style := Font.Style - [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.grpIVPromptsEnter(Sender: TObject);
begin
  with grpIVPrompts do begin
    Font.Style := Font.Style + [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.grpIVPromptsExit(Sender: TObject);
begin
  with grpIVPrompts do begin
    Font.Style := Font.Style - [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.grpNonNurseVfyEnter(Sender: TObject);
begin
  with grpNonNurseVfy do begin
    Font.Style := Font.Style + [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.grpNonNurseVfyExit(Sender: TObject);
begin
  with grpNonNurseVfy do begin
    Font.Style := Font.Style - [fsItalic];
    Invalidate;
  end;
end;


procedure TfrmBCMAParameters.lblListNameClick(Sender: TObject);
begin
{$IFDEF CAS_DDPE_TEST}
  toggleV(btnDefaultImageNew);
  toggleV(btnDefaultImageDelete);
//  toggleV(cmbDefaultImage);
  toggleV(pnlDefaultTools);
{$ENDIF}
end;

procedure TfrmBCMAParameters.lbledtPatIdLabelExit(Sender: TObject);
begin
  lbledtPatIdLabel.Text := AnsiUpperCase(lbledtPatIdLabel.Text);
  SaveIHS;
end;

procedure TfrmBCMAParameters.cbxIVParWardDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ii: Integer;
begin
  with BCMA_WardList do
  begin
    for ii := 0 to Wards.count - 1 do
      if TBCMA_WardList(Wards[ii]).WardName = cbxIVParWard.items[index] then
        if TBCMA_WardList(Wards[ii]).BCMAWard = 1 then
        begin
          cbxIVParWard.canvas.Font.Style := [fsbold, fsunderline];
          //cbxIVParWard.Canvas.Font.Color := clHighlightText;
          Break;
        end;
  end;
  with cbxIVParWard do
  begin
    canvas.fillrect(rect);
    canvas.textout(rect.left, rect.top, items[index]);
  end;
end;

procedure TfrmBCMAParameters.cbxIVParWardChange(Sender: TObject);
var
  ii: Integer;
begin

  cbxIVParWard.hint := cbxIVParWard.text;
  with cbxIVParType do
  begin
    Items.Clear;
    Items.Add('Admixture');
    Items.Add('Chemotherapy');
    Items.Add('Hyperal');
    Items.Add('Piggyback');
    Items.Add('Syringe');
  end;
  cbxIVParType.ItemIndex := 0;
  SelectedWardIEN := '';

  with BCMA_WardList do
  begin
    for ii := 0 to Wards.count - 1 do
      if TBCMA_WardList(Wards[ii]).WardName =
        cbxIVParWard.Items[cbxIVParWard.ItemIndex] then
      begin
        ClearAll;
        SelectedWardIEN := TBCMA_WardList(Wards[ii]).IEN;
        if TBCMA_WardList(Wards[ii]).BCMAWard = 1 then
        begin
          GetIVPar('A');
          btnReset.Enabled := true
        end
        else
          btnReset.Enabled := false;

        Break
      end;
  end;
  cbxIVParType.Enabled := True;
  grpIVPrompts.Enabled := True;
  if cbxIVParWard.ItemIndex = 0 then
    btnReset.Enabled := false
      //  else
//    btnReset.Enabled := True;

end;

procedure TfrmBCMAParameters.cbxIVParTypeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  zbold: Boolean;
  ii: integer;
begin
  zbold := False;
  with BCMA_WardList do
  begin
    for ii := 0 to Wards.count - 1 do
      if TBCMA_WardList(Wards[ii]).WardName =
        cbxIVParWard.Items[cbxIVParWard.ItemIndex] then
      begin
        case Index of
          0:
            if TBCMA_WardList(Wards[ii]).Admixture = 1 then
              zbold := True;
          1:
            if TBCMA_WardList(Wards[ii]).Chemo = 1 then
              zbold := True;
          2:
            if TBCMA_WardList(Wards[ii]).Hyperal = 1 then
              zbold := True;
          3:
            if TBCMA_WardList(Wards[ii]).PiggyBack = 1 then
              zbold := True;
          4:
            if TBCMA_WardList(Wards[ii]).Strings = 1 then
              zbold := True;
        end;
        break;
      end
  end;
  if zbold = True then
  begin
    cbxIVParType.canvas.Font.Style := [fsbold, fsunderline];
    //cbxIVParType.Canvas.Font.Color := clNavy;
  end;
  with cbxIVParType do
  begin
    canvas.fillrect(rect);
    canvas.textout(rect.left, rect.top, items[index]);
  end;

end;

procedure TfrmBCMAParameters.GetIVPar(Value: string);
var
  i: integer;
  zControl: TControl;
begin
  with BCMA_Broker do
    if CallServer('PSB GETIVPAR', [SelectedWardIEN, Value, piece(Division, ';',
        1)], nil) then
      if piece(Results[0], '^', 1) = '-1' then
      begin
        ClearAll;
        btnReset.enabled := False;
        MessageDlg(piece(Results[0], '^', 2), mtWarning, [mbOK], 0)
      end
      else
      begin
        btnReset.enabled := True;
        for i := 0 to grpIVPrompts.ControlCount - 1 do
        begin
          zControl := grpIVPrompts.Controls[i];
          if zControl is TComboBox then
          begin
            TComboBox(zControl).ItemIndex := StrToInt(piece(Results[0], '^',
              grpIVPrompts.Controls[i].Tag)) - 1;
          end;
        end;
      end;

end;

procedure TfrmBCMAParameters.cbxIVParTypeChange(Sender: TObject);
//var
//  ii: integer;
begin
  if SelectedWardIEN <> '' then
  begin
    GetIVPar(Copy(cbxIVParType.Text, 1, 1));
    //btnReset.enabled := False;
  end
  else
    btnReset.enabled := False;
end;

procedure TfrmBCMAParameters.ClearAll();
var
  i: Integer;
begin
  for i := 0 to grpIVPrompts.ControlCount - 1 do
    if grpIVPrompts.Controls[i] is TComboBox then
      TComboBox(grpIVPrompts.Controls[i]).ItemIndex := -1
end;

procedure TfrmBCMAParameters.cbxBCFormatClick(Sender: TObject);
begin
  SetParameter('PSB DEFAULT BARCODE FORMAT', cbxBCFormat.text);
end;

procedure TfrmBCMAParameters.edtBCPrefixExit(Sender: TObject);
begin
  if edtBCPrefix.Tag <> 0 then
    if not SetParameter('PSB DEFAULT BARCODE PREFIX', edtBCPrefix.Text) then
      edtBCPrefix.Text := GetParameter('PSB DEFAULT BARCODE PREFIX', 2);
  edtBCPrefix.Tag := 0;

end;

procedure TfrmBCMAParameters.chkRobotRXClick(Sender: TObject);
begin
  if chkRobotRX.State = cbChecked then
    SetParameter('PSB ROBOT RX', 'Y')
  else
    SetParameter('PSB ROBOT RX', 'N');
end;

procedure TfrmBCMAParameters.ckbLocationsClickCheck(Sender: TObject);
begin
  if ALGroupCurrent = nil then
    MessageDLG('No AL Group Defined :(', mtError, [mbOK], 0)
  else
    ALGroupCurrent.setByCheckList(ckbLocations);
end;

procedure TfrmBCMAParameters.chkMultiAdminClick(Sender: TObject);
begin
  if chkMultiAdmin.State = cbChecked then
    SetParameter('PSB ADMIN MULTIPLE ONCALL', 'Y')
  else
    SetParameter('PSB ADMIN MULTIPLE ONCALL', 'N');
end;

procedure TfrmBCMAParameters.edtPatientTransferExit(Sender: TObject);
begin
  if edtPatientTransfer.Tag <> 0 then
    if not SetParameter('PSB PATIENT TRANSFER', edtPatientTransfer.Text) then
    begin
      edtPatientTransfer.Text := GetParameter('PSB PATIENT TRANSFER', 2);
      if PageControl1.Visible then
        edtPatientTransfer.SetFocus;
    end;
  edtPatientTransfer.Tag := 0;
end;

procedure TfrmBCMAParameters.edtPRNDocExit(Sender: Tobject);
begin
  if edtPRNDoc.Tag <> 0 then
    if not SetParameter('PSB PRN DOCUMENTATION', edtPRNDoc.Text) then
    begin
      edtPRNDoc.Text := GetParameter('PSB PRN DOCUMENTATION', 2);
      if PageControl1.Visible then
        edtPRNDoc.SetFocus;
    end;
  edtPRNDoc.Tag := 0;
end;

procedure TfrmBCMAParameters.edtPRNEffectEnter(Sender: TObject);
begin
  FPRNEffectValue := updnPRNEffect.Position;
end;

procedure TfrmBCMAParameters.edtPRNEffectExit(Sender: TObject);
var
  tbool: Boolean;
begin
  tbool := SetParameter('PSB ADMIN PRN EFFECT', edtPRNEffect.Text);
  if tbool then begin
    updnPRNEffect.Position := StrToIntDef(edtPRNEffect.Text, 0);
    FPRNEffectValue := updnPRNEffect.Position;
  end
  else begin
    updnPRNEffect.Position := FPRNEffectValue;
    edtPRNEffect.Text := IntToStr(FPRNEffectValue);
  end;
end;

procedure TfrmBCMAParameters.PutIVPar();
var
  i: integer;
  Param1, Param2: string;
  zControl: TControl;

begin
  Param1 := '';
  Param2 := '';

  for i := 0 to grpIVPrompts.ControlCount - 1 do
  begin
    zControl := grpIVPrompts.Controls[i];
    if zControl is TComboBox then
{$IFDEF R960057}                        //Remedy # 960057. Until fix 960057 will remove the combo box.
      if (TComboBox(zControl)).Visible then
{$ENDIF}
      begin
        SetPiece(Param2, '^', grpIVPrompts.Controls[i].Tag - 1,
          IntToStr(TComboBox(zControl).ItemIndex + 1));
      end;
  end;

  Param1 := cbxIVParWard.Items[cbxIVParWard.ItemIndex] + '^' + SelectedWardIEN;

  Param2 := Copy(cbxIVParType.Text, 1, 1) + '^' + Param2;

  with BCMA_Broker do
    if CallServer('PSB PUTIVPAR', [Param1, Param2, piece(Division, ';', 1)], nil)
    then

end;

procedure TfrmBCMAParameters.rbtnNonNurseVfyClick(Sender: TObject);
var
  i: Integer;
  tb: Boolean;
begin
//  FNonNurseVfyLvl := GetNonNurseVfyFrBtn;
  i := GetNonNurseVfyFrBtn;
  if (i <> FNonNurseVfyLvl) and (i in [1..3]) then begin
    tb := SetParameter('PSB NON-NURSE VERIFIED PROMPT', IntToStr(i));
    if tb then
      FNonNurseVfyLvl := i;
  end;
end;

procedure TfrmBCMAParameters.btnIVParOKClick(Sender: TObject);
var
  i: integer;
  zControl: TControl;
begin

  for i := 0 to grpIVPrompts.ControlCount - 1 do
  begin
    zControl := grpIVPrompts.Controls[i];
    if zControl is TComboBox then
    begin
      if TComboBox(grpIVPrompts.Controls[i]).ItemIndex = -1 then
      begin
        messageDlg('All IV Prompts must be defined!',
          mtError, [mbOK], 0);
        exit;
      end;
    end;
  end;

  PutIVPar;
  getwardlist;
  cbxIVParWard.ItemIndex := 0;
  cbxIVParWardChange(cbxIVParWard);

end;

procedure TfrmBCMAParameters.btnResetClick(Sender: TObject);
var
  Param1,
    Param2: string;
begin
  if
    messageDlg('Ward settings will revert to the default Division (ALL) settings.'
    + #13#13,
    mtWarning, [mbOK, mbCancel], 0) = mrCancel then
    exit;

  Param1 := cbxIVParWard.Items[cbxIVParWard.ItemIndex] + '^' + SelectedWardIEN;

  Param2 := Copy(cbxIVParType.Text, 1, 1);

  with BCMA_Broker do
    if CallServer('PSB PUTIVPAR', [Param1, Param2, piece(Division, ';', 1)], nil)
    then
      getwardlist;
  cbxIVParWard.ItemIndex := 0;
  cbxIVParWardChange(cbxIVParWard);

end;                                    // btnResetClick

procedure TfrmBCMAParameters.ComboBox1Change(Sender: TObject);
begin
  if (TComboBox(Sender).Tag = 7) or (TComboBox(Sender).Tag = 12) then
  begin
    if TComboBox(Sender).ItemIndex <> 0 then
      messageDlg('The recommended selection for this parameter is "Warning."',
        mtInformation, [mbOK], 0);
  end
  else if TComboBox(Sender).ItemIndex <> 2 then
    messageDlg('The recommended selection for this parameter is "Invalid Bag."',
      mtInformation, [mbOK], 0);
end;

procedure TfrmBCMAParameters.edtTimeoutExit(Sender: TObject);
begin
  if edtTimeout.Tag <> 0 then
    if not SetParameter('PSB IDLE TIMEOUT', edtTimeOut.Text) then
    begin
      edtTimeOut.Text := GetParameter('PSB IDLE TIMEOUT', 2);
      if PageControl1.Visible then
        edtTimeout.SetFocus;
    end;
  edtTimeOut.Tag := 0;
end;

procedure TfrmBCMAParameters.chkCPRSMedOrderClick(Sender: TObject);
begin
  if chkCPRSMedOrder.State = cbChecked then
    SetParameter('PSB HKEY', 'Y')
  else
    SetParameter('PSB HKEY', 'N');

end;

procedure TfrmBCMAParameters.FormDestroy(Sender: TObject);
begin
  alMRR.Free;

  ALMaster.Free;
  ALBackup.Free;
  ALGroupList.Free;

  BCMA_Broker.Free;
  CloseLogFile;                         // rpk 2/3/2012
end;

procedure TfrmBCMAParameters.gbxMissingDosePrintersEnter(Sender: TObject);
begin
  with gbxMissingDosePrinters do begin
    Font.Style := Font.Style + [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.gbxMissingDosePrintersExit(Sender: TObject);
begin
  with gbxMissingDosePrinters do begin
    Font.Style := Font.Style - [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.gbxMailGroupsEnter(Sender: TObject);
begin
  with gbxMailGroups do begin
    Font.Style := Font.Style + [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.gbxMailGroupsExit(Sender: TObject);
begin
  with GbxMailGroups do begin
    Font.Style := Font.Style - [fsItalic];
    Invalidate;
  end;
end;

procedure TfrmBCMAParameters.cbxListNameSelect(Sender: TObject);
begin
  if not LeaveTsAnswerList then
    cbxListName.ItemIndex := currentListIndex;

  //the onSelect event seems to short curcuit the onChange event
  //so we have to continue the process ourselves.
  cbxListName.OnChange(self);
end;

function TfrmBCMAParameters.LeaveTsAnswerList: Boolean;
(*  determine if the current list has been saved. Warn user and return users
    response.

    Returns   TRUE  - if ok to leave page
                    - or if tsAnswerList is not active

              FALSE - if user chooses not to leave.

    Set LeaveTsDefaultList_Warning to False to disable the warning "once"
*)
begin
  Result := True;
  with PageControl1 do
    if (LeaveTsDefaultList_Warning) and (ActivePage = tsAnswerList) then
    begin
      // warn the user if changes have not been saved
      if btnSaveList.Enabled = true then
        { if messageDlg('Changes to the "' + currentListName +
          '" list have not been saved!' + #13#13 +
          'Click OK to continue without saving your changes.',
          mtWarning, [mbOK, mbCancel], 0) = mrCancel then }
        if DefMessageDlg('Changes to the "' + currentListName + // rpk 7/14/2016
          '" list have NOT been saved!' + #13#13 + // rpk 7/14/2016
          'Click OK to continue WITHOUT saving your changes.', // rpk 7/14/2016
          mtWarning, [mbOK, mbCancel], 0) = mrCancel then // rpk 7/14/2016
          //stop the change
        begin
          Result := False;
        end
        else
          // turn off the save button to prevent repeat warnings
          btnSaveList.Enabled := False;

    end;
  //reset warning
  LeaveTsDefaultList_Warning := true;
end;

procedure TfrmBCMAParameters.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  // perform page checks before allowing the change
  with PageControl1 do
    if LeaveTsAnswerList then
      // allow the change
    begin
      // clear the currentListName so the list reloads if the user
      // comes back to this tab.
      currentListName := '';
    end
    else
      // stop page change
    begin
      AllowChange := False;
    end;
end;

procedure TfrmBCMAParameters.edtMedHistDaysBackChange(Sender: TObject);
begin
  TEdit(Sender).Tag := 1;
end;

procedure TfrmBCMAParameters.edtMedHistDaysBackEnter(Sender: TObject);
begin
  TEdit(Sender).Tag := 0;
end;

procedure TfrmBCMAParameters.edtMedHistDaysBackExit(Sender: TObject);
begin
  if edtMedHistDaysBack.Tag <> 0 then
    if not SetParameter('PSB MED HIST DAYS BACK', edtMedHistDaysBack.Text) then
    begin
      edtMedHistDaysBack.Text := GetParameter('PSB MED HIST DAYS BACK', 2);
      if PageControl1.Visible then
        edtMedHistDaysBack.SetFocus;
    end;
  edtMedHistDaysBack.Tag := 0;
end;

procedure TfrmBCMAParameters.cbxRptInclCommClick(Sender: TObject);
begin
  if cbxRptInclComm.State = cbChecked then
    SetParameter('PSB RPT INCL COMMENTS', 'Y')
  else
    SetParameter('PSB RPT INCL COMMENTS', 'N');
end;

procedure TfrmBCMAParameters.chk5UnitDoseClick(Sender: TObject);
begin
  if chk5UnitDose.State = cbChecked then
    SetParameter('PSB 5 RIGHTS UNITDOSE', '1')
  else
    SetParameter('PSB 5 RIGHTS UNITDOSE', '0');
end;

procedure TfrmBCMAParameters.chk5IVClick(Sender: TObject);
begin
  if chk5IV.State = cbChecked then
    SetParameter('PSB 5 RIGHTS IV', '1')
  else
    SetParameter('PSB 5 RIGHTS IV', '0');
end;

procedure TfrmBCMAParameters.cbxPatchDurationClick(Sender: TObject);
//var
//  DayToDisplay: integer;
begin
  if cbxPatchDuration.ItemIndex = 0 then
    SetParameter('PSB VDL PATCH DAYS', '')
  else
    SetParameter('PSB VDL PATCH DAYS', IntToStr(cbxPatchDuration.ItemIndex +
      6));
end;

procedure TfrmBCMAParameters.edtMgUnknownExit(Sender: TObject);
begin
  if edtMGUnknown.Tag <> 0 then
    if not SetParameter('PSB MG ADMIN ERROR', edtMGUnknown.Text) then
    begin
      edtMGUnknown.Text := GetParameter('PSB MG ADMIN ERROR', 2);
      if PageControl1.Visible then
        edtMgUnknown.SetFocus;
    end;
  edtMGUnknown.Tag := 0;

end;

procedure TfrmBCMAParameters.edtMGMSFExit(Sender: TObject);
begin
  if edtMGMSF.Tag <> 0 then
    if not SetParameter('PSB MG SCANNING FAILURES', edtMGMSF.Text) then
    begin
      edtMGMSF.Text := GetParameter('PSB MG SCANNING FAILURES', 2);
      if PageControl1.Visible then
        edtMgMSF.SetFocus;
    end;
  edtMGMSF.Tag := 0;

end;

procedure TfrmBCMAParameters.LoadIHS;
begin
  //  lbledtDivPatIdLabel.Text := GetParameterLevel('PSB PATIENT ID LABEL', 'DIV', 1);
  lbledtDivPatIdLabel.Text := GetParameter('PSB PATIENT ID LABEL', 1);
  lbledtSysPatIdLabel.Text := GetParameterLevel('PSB PATIENT ID LABEL', 'SYS',
    1);
  lbledtAllPatIdLabel.Text := GetParameterLevel('PSB PATIENT ID LABEL', 'ALL',
    1);

  if lbledtDivPatIdLabel.Text <> '' then
    lbledtPatIdLabel.Text := lbledtDivPatIdLabel.Text
  else
    lbledtPatIdLabel.Text := lbledtSysPatIdLabel.Text
end;

function TfrmBCMAParameters.getWorkItem(ansli: TListItem): TListItem;
var
  idx: Integer;
begin
  Result := nil;
//  if not assigned(ansli) then
//    exit;
  if assigned(ansli) and assigned(frmALView) then begin // rpk 7/18/2016
    idx := lvwDefAnswer.Items.IndexOf(ansli);
    Result := frmAlView.lvWork.Items[idx];
  end;
end;                                    // getWorkItem

procedure TfrmBCMAParameters.lvwDefAnswerChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
var
  ansli, workli: TListItem;
begin
  if (Sender is TListView) and
    (cbxListName.ItemIndex >= 0) and
    (TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) =
    lnBodySites) then begin
    ansli := Item;
    if not assigned(ansli) then
      exit;
    workli := getWorkItem(Item);
    if Assigned(workli) then begin
      ansli.StateIndex := workli.StateIndex;
//
// need to clear previously selected shapes
//
      if assigned(workli.Data) then
      try
        TShape(workli.Data).Brush.Color := clAL_MouseLeave;
      except
        on E: Exception do
          ShowMessage(E.Message);
      end;
    end;
  end;
end;

procedure TfrmBCMAParameters.lvwDefAnswerCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  // set row color only for body site list
  if (Item.SubItems.Count > idxX) then begin
    if (Item.SubItems[idxX] <> '') and
      (Item.SubItems[idxX] <> '0') then
      lvwDefAnswer.Canvas.Brush.Color := clCoordinates
    else
      lvwDefAnswer.Canvas.Brush.Color := clNoCoordinates;
  end;
end;

// lvwDefAnswer has item with index that matches item index
// of frmALView.lvWork.  Use list item of lvWork to set shape color
// in frmALView

procedure TfrmBCMAParameters.lvwDefAnswerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ansli, workli: TListItem;
begin
  if (Sender is TListView) and
    (TListNames(cbxListName.Items.Objects[cbxListName.ItemIndex]) =
    lnBodySites) then begin
    ansli := TListView(Sender).GetItemAt(X, Y);
    if assigned(ansli) then begin
      workli := getWorkItem(ansli);
      if Assigned(workli) then begin
        ansli.StateIndex := workli.StateIndex;
  //    if not assigned(li.Data) and ((ViewMode = mmEdit) or (ViewMode = mmDebug)) then
  //      lvWork.BeginDrag(True);

        if assigned(workli.Data) then
          TShape(workli.Data).Brush.Color := clAL_Selected;
      end;
    end;
  end;
end;

procedure TfrmBCMAParameters.SaveIHS;
var
  tpidlbl, updstr: string;
  bres: Boolean;
begin
  // if the user input is the same as the system-level value, we want to delete the
  // division-level value.  Then, the GETPAR ALL in BCMA will fall through and retrieve
  // the system-level value.
  if lbledtPatIdLabel.Text = lbledtSysPatIdLabel.Text then
    tpidlbl := ''
  else
    tpidlbl := lbledtPatIdLabel.Text;

  // if the new desired value is different from the current division-level value,
  // call SETPAR to update the division-level value (or delete it if tpidlbl is
  // an empty string).
  if tpidlbl <> lbledtDivPatIdLabel.Text then
  begin
    // use updstr to preserve possible empty string in tpidlbl.
    // use @ to signal to MUMPS to delete the division-level value.
    if tpidlbl = '' then
      updstr := '@'
    else
      updstr := tpidlbl;
    bres := SetParameter('PSB PATIENT ID LABEL', updstr);
    if bres then
      lbledtDivPatIdLabel.Text := tpidlbl;
  end;

  // run a final test with GETPAR ALL to verify what BCMA will see on its GETPAR
  lbledtAllPatIdLabel.Text := GetParameterLevel('PSB PATIENT ID LABEL', 'ALL',
    1);

end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmBCMAParameters.sbModeClick(Sender: TObject);
begin
  if Mode = '' then
    Mode := 'DEBUG'
  else
    Mode := '';

  lbMaster.Visible := Mode = '';
  ckbLocations.Visible := Mode <> '';
end;

procedure TfrmBCMAParameters.SpeedButton1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (button = mbLeft) and (ssCtrl in Shift) then
  begin
(*
      sbNew.Visible := not sbNew.Visible;
//      sbShapes.Visible := not sbShapes.Visible;
      sbSrvB.Visible := not sbSrvB.Visible;
      sbBSrv.Visible := not sbBSrv.Visible;
      sbMap.Visible := not sbMap.Visible;
      sbEditB.Visible := not sbEditB.Visible;
*)
  end;
end;

procedure TfrmBCMAParameters.RPCLog1Click(Sender: TObject);
begin
{ $IFDEF CAS_DDPE_TEST}
{$IFDEF CAS_DDPE_DEBUG}
  ShowEventLog(False);
  frmEventLog.Height := Application.MainForm.Height;
  Application.MainForm.Left := 50;
  frmEventLog.Left := Application.MainForm.Left + Application.MainForm.Width;
  frmEventLog.Top := Application.MainForm.Top;
  frmEventLog.Width := Screen.Width - frmEventLog.Left - 50;
{$ENDIF}
end;

procedure TfrmBCMAParameters.acBackupDataExecute(Sender: TObject);
var
  i: integer;
begin
  if EditList(ALBackup) = mrOK then
  begin
    BCMA_Broker.CallServer('PSB PARAMETER', ['DELLST', Division,
      AnatomicLocationMapList], nil);
    ALBackup.Assign(frmDebugEdit.mm.Lines);
    for i := 0 to ALBackup.Count - 1 do
      BCMA_Broker.CallServer('PSB PARAMETER',
        ['SETPAR', trim(Division), AnatomicLocationMapList, IntToStr(i + 1),
        ALBackup[i]], nil);
  end;
end;

procedure TfrmBCMAParameters.acBackupEditExecute(Sender: TObject);
begin
  if EditList(ALBackup) = mrOK then
    ALBackup.Assign(frmDebugEdit.mm.Lines);
end;

procedure TfrmBCMAParameters.acCountShapesExecute(Sender: TObject);
begin
//  if assigned(frmALMapEdit) then
  if assigned(frmALMapEdit) and assigned(frmALView) then
    ShowMessage(
      'DEF  count: ' + IntToStr(countShapes(lvwDefAnswer.Items)) + #13#10 +
      'View count: ' + IntToStr(countShapes(frmALView.lvWork.Items)) + #13#10 +
      'Edit count: ' + IntToStr(countShapes(frmALMapEdit.lvWork.Items)) + #13#10
      )
  else if assigned(frmALView) then
    ShowMessage(
      'DEF  count: ' + IntToStr(countShapes(lvwDefAnswer.Items)) + #13#10 +
      'View count: ' + IntToStr(countShapes(frmALView.lvWork.Items)) + #13#10 +
      'Edit count: Not available'
      )
end;

procedure TfrmBCMAParameters.acDefaultAddExecute(Sender: TObject);
var
  indx: Integer;
  newVal: string;
  b: Boolean;
  li: TListItem;
begin
  b := false;
  newVal := inputPrompt('Add New AL Item', 'Item:', '', 30, false, false, b,
    '');
  if trim(NewVal) <> '' then
  begin
    indx := ALMaster.IndexOf(newVal);
    if indx < 0 then
      ALMaster.Add(newVal);

//      indx := ALMaster.Count - 1;
    indx := ALMaster.IndexOf(newVal);
    if alMRR.LocationItems.IndexOf(newVal) < 0 then
      ALMRR.LocationItems.AddObject(newVal,
        TALItem.newALItem(IntToStr(indx) + MapDelimiter + NewVal + MapDelimiter)
        );


    li := lvwDefAnswer.Items.Add;
    li.Caption := NewVal;
    inc(iChangeCount);

    lbMaster.Items.Assign(ALMaster);
  end;
end;

procedure TfrmBCMAParameters.acDefaultRemoveExecute(Sender: TObject);
var
  alItem: TALItem;
  i: Integer;
  s: string;
begin
  if lvwDefAnswer.ItemIndex < 0 then
    exit;
  if MessageDLG('Remove Term "' +
    lvwDefAnswer.Selected.Caption + '"?', mtConfirmation,
    [mbOK, mbCancel], 0) = mrOK then
  begin
    s := lvwDefAnswer.Selected.Caption;

    alItem := alMRR.ItemByName(s);
    if alItem <> nil then
      alItem.Free;
    i := alMRR.LocationItems.IndexOf(s);
    alMRR.LocationItems.Delete(i);

    addTextEvent('DEFAULT List Item Removed', s);
    lvwDefAnswer.Items.Delete(lvwDefAnswer.ItemIndex);
    inc(iChangeCount);

    lbMaster.Items.Assign(ALMaster);
  end;
end;

procedure TfrmBCMAParameters.acDefaultRenameExecute(Sender: TObject);
var
  indx: Integer;
  newVal: string;
  b: Boolean;
  s: string;
begin
  if lvwDefAnswer.Selected = nil then
    exit;
  b := false;
  s := lvwDefAnswer.Selected.Caption;
  newVal := inputPrompt('Rename Item', 'Item:', s, 30, false, false, b, '');
  if trim(NewVal) <> '' then
  begin
    indx := alMRR.LocationItems.IndexOf(newVal);
    if indx >= 0 then
      MessageDLG('Item "' + s +
        '" is used already. Duplicates are not allowed.",' +
        CRLF + 'Please select different name', mtError, [mbOK], 0)
    else
    begin
      alMRR.LocationItems[indx] := newVal;
      TALItem(alMRR.LocationItems.Objects[indx]).Caption := newVal;
      indx := ALMaster.IndexOf(s);
      ALMaster[indx] := newVal;

      lvwDefAnswer.Selected.Caption := NewVal;
      inc(iChangeCount);
    end;
    lbMaster.Items.Assign(ALMaster);
  end;
end;

procedure TfrmBCMAParameters.acEditMapExecute(Sender: TObject);
var
  oldSL, newSL: TStringList;
  s: string;
  tbool: Boolean;
begin
  if not assigned(ALGroupCurrent) then
    exit;
  if not LeaveTsAnswerList then         // rpk 7/12/2016
    exit;
  oldSL := ALGroupCurrent.LocItemsToSL;
  try
    if oldSL.Count < 1 then
      MessageDLG('No Items selected. Please select items from the list to edit the Layout',
        mtInformation, [mbOK], 0)
    else
//    if MessageDLG(SL.Text,mtConfirmation,[mbOK,mbCancel],0) = mrOK then
    begin
      if ALGroupCurrent.ImageName = '' then
        ALGroupCurrent.ImageName := AnatomicLocationsMasterImage;
      if ALGroupCurrent.MasterName = '' then
        ALGroupCurrent.MasterName := pnAnatomicLocationMasterList;
      if LocationMapEdit(
        oldSL,
        Division,                       //frmALView.Division,
        ALGroupCurrent.GroupName,       // cmbALList.Text,
        ALGroupCurrent.MasterName,      // ALGroupList.getListMaster(cmbALList.Text),
        ALGroupCurrent.ImageName        //cmbALImages.Text
        ) > 0 then
      begin
//      SL.Free;
        newSL := AnatomicalLocationsToStrings(frmALMapEdit.lvWork.Items);
        try
          ALBackup.Assign(newSL);
//      FreeAndNil(SL);
//      frmALView.setByList(ALBackup);

//      ALGroupCurrent.restoreFromBackup(ALBackup);
          ALGroupCurrent.setByList(ALBackup);
          ALGroupCurrent.Save(Division);
          // save any additions to group in master list
          tbool := UpdateMasterList(Division, newSL);

//      FreeAndNil(SL);
        finally
          newSL.Free;
        end;

//      frmALView.imgBody.Picture.Assign(frmALMapEdit.imgBody.Picture);
        if assigned(frmALView) then
        begin
          removeShapes(frmALView.lvWork.Items, true);
          frmALView.lvWork.Items.Clear;
          frmALView.Parent := pnlChartDefault;
          frmALView.setByList(ALBackup);
//          frmALView.setByList(ALBackup, pnlChartDefault);  // rpk 5/2/2016
          frmALView.ViewMode := mmView;
          frmALView.imgBody.Picture.Assign(frmALMapEdit.imgBody.Picture);
          frmALView.bparLvwDefAnswer := lvwDefAnswer;
          frmALView.Invalidate;
        end;

//        btnSaveList.Enabled := True;    // rpk 1/15/2016

        Application.ProcessMessages;

//      cbxListNameChange(self);  // rebuild the listview
//        if Sender is TButton then
//          s := TButton(Sender).Name;
//        cbxListName.OnChange(Sender);

      end;                              // if LocationMapEdit > 0
      if Sender is TButton then
        s := TButton(Sender).Name;
      cbxListName.OnChange(Sender);
    end;                                // if SL.Count > 0
  finally
    if oldSL <> nil then
      oldSL.Free;
  end;
end;                                    // acEditMapExecute

procedure TfrmBCMAParameters.acGroupDeleteExecute(Sender: TObject);
begin
  MessageDlg(msgLocationGroupDelete, mtInformation, [mbOK], 0);
end;

procedure TfrmBCMAParameters.acGroupLoadExecute(Sender: TObject);
var
  alItem: TALItem;
  alGroup: TALGroup;
  s: string;
  i, indx: Integer;
begin
  i := cmbALList.ItemIndex;
  s := cmbALList.Items[i];

  if s = pnAnatomicLocationMasterList then
  begin                                 // master list processing
      //acMasterSaveExecute(nil);
  end
  else
  begin
    for indx := 0 to ckbLocations.Count - 1 do
      ckbLocations.Checked[indx] := False;

    alGroup := ALGroupCurrent;
    if alGroup = nil then
    begin
      alGroup := TALGroup.newALGroup;
      alGroup.GroupName := s;
      alGroup.ImageName := cmbALImages.Text;
      alGroup.MasterName := pnAnatomicLocationMasterList;
      cmbALList.Items.Objects[i] := alGroup;
    end
    else
    begin
      s := alGroup.ImageName;
      i := cmbALImages.Items.IndexOf(s);
    end;

    ALGroup.ClearItems;
    ALGroup.Load(Division);

    for i := 0 to ALGroup.LocationItems.Count - 1 do
    begin
      ALItem := TALItem(ALGroup.LocationItems.Objects[i]);
      if assigned(ALItem) then
      begin
        s := ALItem.Caption;
        indx := ckbLocations.Items.IndexOf(s);
        if indx >= 0 then
          ckbLocations.Checked[indx] := True;
      end;
    end;

    s := ALGroup.ImageName;
    indx := cmbALImages.Items.IndexOf(s);
    if indx >= 0 then
      cmbALImages.ItemIndex := indx;

    if assigned(frmALView) then
    begin
      frmALView.bparLvwDefAnswer := lvwDefAnswer;
      frmALView.setByList(ALGroup.LocItemsToSL);
//      frmALView.setByList(ALGroup.LocItemsToSL, pnlBodyChart);  // rpk 5/2/2016
      pnlChart.Height := pnlChart.Height + 1;
      Application.ProcessMessages;
      pnlChart.Height := pnlChart.Height - 1;
    end;
  end;

  Application.ProcessMessages;
end;                                    // acGroupLoadExecute

procedure TfrmBCMAParameters.acGroupLoadListExecute(Sender: TObject);
var
  SS: TSTrings;
begin
  SS := getALGroups(Division);
  if SS <> nil then
    cmbALList.Items.Assign(SS);
end;

procedure TfrmBCMAParameters.acGroupNewExecute(Sender: TObject);
var
  i, icnt: Integer;
  s, serror: string;
begin
//  MessageDlg(msgLocationGroupNew, mtInformation, [mbOK], 0);
  serror := '';
  s := Trim(cmbALList.Text);
  i := cmbALList.Items.IndexOf(s);
  if I = -1 then begin
    icnt := cmbALList.Items.Count;
    BCMA_Broker.CallServer('PSB PARAMETER',
      ['SETPAR', trim(Division), pnAnatomicLocationGroupList, IntToStr(icnt +
        1), s], nil);

     // warn the user if an Item is not saved.
    if piece(BCMA_Broker.Results[0], '^', 1) = '-1' then
      sError := sError +
        'Invalid Parameter [' + IntToStr(i + 1) + '] ' + #13#10 + 'Value [' + s
        +
        '] was not saved.' + CRLF;
  end;

end;

procedure TfrmBCMAParameters.acGroupSaveExecute(Sender: TObject);
var
  alGroup: TALGroup;
  s: string;
  i: Integer;
begin
  i := cmbALList.ItemIndex;
  s := cmbALList.Items[i];

  if s = pnAnatomicLocationMasterList then
  begin                                 // master list processing
    acMasterSaveExecute(nil);
  end
  else
  begin
    alGroup := TAlGroup(cmbALList.Items.Objects[i]);
    if alGroup = nil then
      AddTextEvent('Save Nil ALGroup', 'AL Group: "' + s + '"  Division: "' +
        Division + '"')
    else
      alGroup.Save(Division);
  end;

  Application.ProcessMessages;
end;

procedure TfrmBCMAParameters.acGroupSelectAllExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ckbLocations.Count - 1 do
    ckbLocations.Checked[i] := ckbSelectAll.Checked;
end;

procedure TfrmBCMAParameters.acImageDeleteExecute(Sender: TObject);
begin
  MessageDlg(msgImageDelete, mtInformation, [mbOK], 0);
end;

procedure TfrmBCMAParameters.acImageImportAccept(Sender: TObject);
var
  s: string;
begin
  if not assigned(frmALView) then       // rpk 7/18/2016
    exit;
  frmALView.bparLvwDefAnswer := lvwDefAnswer; // rpk 1/21/2016
  frmALView.imgBody.Picture.LoadFromFile(acImageImport.Dialog.FileName);
  frmALView.setDimensions;

  s := SaveImage(frmALView.ImgBody, Division, cmbALImages.Text);
  if s <> '' then
    MessageDLG(s, mtInformation, [mbOK], 0)
  else
    if assigned(frmALMapEdit) then
    begin
//        frmALMapEdit.imgBody.Picture.LoadFromFile(acImageImport.Dialog.FileName);
      frmALMapEdit.imgBody.Assign(frmALView.ImgBody);
      frmALMapEdit.setDimensions;
    end;
end;

procedure TfrmBCMAParameters.acImageNewExecute(Sender: TObject);
begin
  MessageDlg(msgImageNew, mtInformation, [mbOK], 0);
end;

procedure TfrmBCMAParameters.acImagesExecute(Sender: TObject);
var
  SS: TSTrings;
begin
  SS := getALImages(Division);
  if SS <> nil then
    cmbALImages.Items.Assign(SS);
end;

procedure TfrmBCMAParameters.acItemAddExecute(Sender: TObject);
var
  newVal: string;
  b: Boolean;
begin
  b := false;
  newVal := inputPrompt('Add New AL Item', 'Item:', '', 30, false, false, b,
    '');
  if trim(NewVal) <> '' then
  begin
    ckbLocations.Items.Add(NewVal);
    ALMaster.Add(NewVal);
    lbMaster.Items.Assign(ALMaster);
  end;
end;

procedure TfrmBCMAParameters.acItemRemoveExecute(Sender: TObject);
var
  s: string;
  indx: Integer;
begin
  if ckbLocations.ItemIndex < 0 then
    exit;
  s := ckbLocations.Items[ckbLocations.ItemIndex];
  if MessageDLG('Remove Term "' + s + '"?', mtConfirmation, [mbOK, mbCancel], 0)
    = mrOK then
  begin
    addTextEvent('ALML Item Deleted', s);
    ckbLocations.Items.Delete(ckbLocations.ItemIndex);
    indx := ALMaster.IndexOf(s);
    if indx >= 0 then
      ALMaster.Delete(indx)
    else
      addTextEvent('ALML Item Delete ERROR', 'Item "' + s +
        '" Not found in the ML');
    lbMaster.Items.Assign(ALMaster);
  end;
end;

procedure TfrmBCMAParameters.acItemRenameExecute(Sender: TObject);
var
  i, indx: Integer;
  newVal: string;
  b: Boolean;
  s: string;
begin
  if ckbLocations.ItemIndex < 0 then
    exit;
  b := false;
  s := ckbLocations.Items[ckbLocations.ItemIndex];
  newVal := inputPrompt('Rename AL Item', 'Item:', s, 30, false, false, b, '');
  if trim(NewVal) <> '' then
  begin
    i := ALMaster.IndexOf(NewVal);
    if i >= 0 then
      MessageDLG('Item "' + NewVal + '" already included in the list.',
        mtError, [mbOK], 0)
    else
    begin
      ckbLocations.Items[ckbLocations.ItemIndex] := newVal;
      indx := ALMaster.IndexOf(s);
      if indx >= 0 then
        ALMaster[indx] := newVal;
      lbMaster.Items.Assign(ALMaster);
    end;
  end;
end;

procedure TfrmBCMAParameters.acNewBackupExecute(Sender: TObject);
var
  SL: TStringList;
  i: integer;
begin
  SL := TStringList.Create;
  for i := 0 to lvwDefAnswer.Items.Count - 1 do
    SL.Add(
      IntTostr(i + 1) + MapDelimiter +
      lvwDefAnswer.Items[i].Caption + MapDelimiter +
      '' + MapDelimiter
      );

  ALBackup.Assign(SL);
  FreeAndNil(SL);
end;

procedure TfrmBCMAParameters.acReloadFromServerExecute(Sender: TObject);
begin
  BCMA_Broker.CallServer('PSB PARAMETER',
    ['GETLST', Division, AnatomicLocationMapList], nil);

  ALBackup.Assign(BCMA_Broker.Results);
  if ALBackup.Count > 0 then
    ALBackup.Delete(0);
end;

procedure TfrmBCMAParameters.acRemoveExecute(Sender: TObject);
var
  shp: TShape;
begin
  if sender is TShape then
  begin
    if MessageDLG('Remove?', mtInformation, [mbYes, mbCancel], 0) = mrYes then
    begin
      ShowMessage('Under Construction...');
      exit;
      shp := TShape(Sender);
      shp.Parent := nil;
      freeAndNil(shp);
    end;
  end;
end;


procedure TfrmBCMAParameters.acResetMapExecute(Sender: TObject);
begin
  if assigned(frmALView) then begin     // rpk 7/18/2016
    frmALView.bparLvwDefAnswer := lvwDefAnswer; // rpk 1/21/2016
    frmALView.setByList(ALBackup);
  end;
//  frmALView.setByList(ALBackup, pnlBodyChart);  // rpk 5/2/2016
end;

procedure TfrmBCMAParameters.ALTab1Click(Sender: TObject);
begin
  PageControl1.Pages[PageControl1.PageCount - 1].TabVisible :=
    not PageControl1.Pages[PageControl1.PageCount - 1].TabVisible;
  alTab1.Checked := PageControl1.Pages[PageControl1.PageCount - 1].TabVisible;
end;

procedure TfrmBCMAParameters.setMasterList(aSL: TStringList);
var
  SL: TStringList;
  i: integer;
  alItem: TALItem;
begin
{
  SL := MasterLocations;
  while SL.Count>0 do
    begin
      if assigned(SL.Objects[0]) then
        SL.Objects[0].Free;
      SL.Delete(0);
    end;
}
  SL := TStringList.Create;
  for i := 0 to aSL.Count - 1 do
  begin
    alItem := TALItem.newALItem(aSL[i]);
    SL.AddObject(alItem.Caption, alItem);
  end;

  ckbLocations.Items.Assign(SL);

  if assigned(frmALView) then begin
    frmALView.bparLvwDefAnswer := lvwDefAnswer; // rpk 1/21/2016
//    frmALView.setByALList(SL);
    frmALView.setByALList(SL, pnlBodyChart); // rpk 5/2/2016
  end;

end;                                    // setMasterList

{$IFDEF CAS_DDPE_TEST}

procedure TfrmBCMAParameters.setALDivision(aDivision: string);
var
  i: integer;
  alGroup: TALGroup;
begin
  addTextEvent('Set Division: Start', 'Division "' + aDivision + '"');
  if assigned(frmALView) then           // rpk 7/18/2016
    frmALView.Division := aDivision;
  cmbALList.Items.Clear;
  addTextEvent('--- Division.Load', 'Division "' + aDivision + '"' + CRLF +
    pnAnatomicLocationMasterList);
  cmbALList.AddItem(pnAnatomicLocationMasterList, nil);

  if assigned(ALGroupList) then
  begin
      // will reload Division if different from current;
      // Reloads list of AL Groups;
    ALGroupList.Division := aDivision;
    for i := 0 to ALGroupList.GroupItems.Count - 1 do
    begin
//      alGroup := TALGroup(ALGroupList.GroupItems.Objects[i]);
      cmbALList.AddItem(ALGroupList.GroupItems[i], alGroup);
    end;
  end;

  addTextEvent('--- Division.MasterListLoad', 'Division "' + aDivision + '"');
  acMasterLoadExecute(nil);
  ckbLocations.Items.Assign(ALMaster);

  addTextEvent('--- Division.Image List Load', 'Division "' + aDivision + '"');
  acImagesExecute(nil);                 // setting up the image list

  cmbALList.ItemIndex := 0;
  addTextEvent('--- Division.Image Load', 'Image "' + cmbALList.Text + '"');
//  cmbALListChange(nil);
  cmbALListClick(nil);
(*
  BCMA_Broker.CallServer('PSB PARAMETER',
    ['GETLST', Division, AnatomicLocationMapList], nil);

  ALBackup.Assign(BCMA_Broker.Results);
  if ALBackup.Count > 0 then
    ALBackup.Delete(0);

  setMasterList(ALBackup);
*)
  addTextEvent('Set Division: Stop', 'Division "' + aDivision + '"')

end;
{$ENDIF}

procedure TfrmBCMAParameters.msg_UM_ALSETUP(var Message: TMessage);
var
  tbool: Boolean;
begin
  RPCLog1.Visible := True;
//  Caption := Caption + ' (RPC Log enabled)';
  DeveloperCommentsPar;

  ALBackup := TStringList.Create;
  ALMaster := TStringList.Create;

  ALGroupList := TALGroupList.newALGroupList;
  ALGroupList.ItemsName := pnAnatomicLocationGroupList; // parameter holding Group List

  alMRR := TALGroup.newALGroup;
//  alMRR.GroupName := pnAnatomicLocationTransdermal; // pnAnatomicLocationMRR;
//  alMRR.GroupName := pnAnatomicLocationMRR;
  alMRR.GroupName := pnBodySites;
  alMRR.ImageName := AnatomicLocationsMasterImage;

  { if not assigned(frmALView) then
  begin
//    frmALView := newLocationMap(mmView, Division);
    // do a forced save of builtin body background image for division on startup
    // this ensures that image is up-to-date at the site.
    frmALView := newLocationMap(mmSave, Division);  // rpk 4/26/2016
    frmALView.ViewMode := mmView;                   // rpk 4/26/2016
    setFormParented(frmALView, pnlBodyChart);
    frmALView.bparLvwDefAnswer := lvwDefAnswer; // rpk 1/21/2016
    application.ProcessMessages;
    frmALView.FormResize(nil);
  end; }
  if not assigned(frmALView) then
//    frmALView := newLocationMap(mmView, Division);
    // do a forced save of builtin body background image for division on startup
    // this ensures that image is up-to-date at the site.
    frmALView := newLocationMap(mmSave, Division); // rpk 4/26/2016
  if Assigned(frmALView) then begin
    frmALView.ViewMode := mmView;       // rpk 4/26/2016
    setFormParented(frmALView, pnlBodyChart);
    frmALView.bparLvwDefAnswer := lvwDefAnswer; // rpk 1/21/2016
//    application.ProcessMessages;
    frmALView.FormResize(nil);
    // if division changes, save the default body diagram to that division
    if (prevDivision > '') and (Division <> prevDivision) then begin // rpk 4/25/2016
      tbool := frmALView.acSaveChartToVista.Execute; // rpk 4/25/2016
      frmALView.SetDivision(Division);  // rpk 4/26/2016
//      application.ProcessMessages;        // rpk 4/25/2016
    end;                                // rpk 4/25/2016
    if Assigned(frmALMapEdit) then
      frmALMapEdit.SetDivision(Division); // rpk 4/26/2016
    if (Division <> prevDivision) then
      prevDivision := Division;         // rpk 4/25/2016
  end;

{$IFNDEF CAS_DDPE_TEST}
  PageControl1.Pages[PageControl1.PageCount - 1].TabVisible := False;
{$ENDIF}
  application.ProcessMessages;          // rpk 4/27/2016

end;  // msg_UM_ALSETUP

procedure TfrmBCMAParameters.acMasterExportAccept(Sender: TObject);
begin
  ALMaster.SaveToFile(acMasterExport.Dialog.Filename);
end;

procedure TfrmBCMAParameters.acMasterImportAccept(Sender: TObject);
begin
//  ckbLocations.Items.LoadFromFile(acMasterImport.Dialog.Filename);
  ALMaster.LoadFromFile(acMasterImport.Dialog.Filename);
  lbMaster.Items.Assign(ALMaster);
  ckbLocations.Items.Assign(ALMaster);
end;

procedure TfrmBCMAParameters.acMasterLoadExecute(Sender: TObject);
begin
  ALMaster.Clear;
  ALMaster.Assign(getMasterList(Division));
  ckbLocations.Items.Assign(ALMAster);
  lbMaster.Items.Assign(ALMaster);
end;

procedure TfrmBCMAParameters.acMasterSaveExecute(Sender: TObject);
var
  s: string;
begin
  s := SaveMasterList(Division, ckbLocations.Items);
  if pos('-1^', s) = 1 then
  begin
    s := piece(s, '^', 2);
    MessageDLG(s, mtError, [mbOK], 0);
    addTextEvent('ERROR', s);
  end;
end;

procedure TfrmBCMAParameters.cmbALImagesChange(Sender: TObject);
var
  ALGroup: TALGroup;
  s: string;
begin
  s := cmbALImages.Text;
  ALGroup := getALGroupCurrent;
  if assigned(ALGroup) then
  begin
    ALGroup.ImageName := s;
    if assigned(frmALView) then         // rpk 7/18/2016
      frmALView.getImageFromVistA(s);
  end;
end;

procedure TfrmBCMAParameters.cmbALListChange(Sender: TObject);
var
//  alGroup: TALGroup;
  s: string;
  i: Integer;
begin
  i := cmbALList.ItemIndex;
  s := cmbALList.Items[i];

  pnlMasterTool.Enabled := s = pnAnatomicLocationMasterList;
  btnGroupLoad.Enabled := s <> pnAnatomicLocationMasterList;
  btnGroupNew.Enabled := s <> pnAnatomicLocationMasterList;
  btnGroupDelete.Enabled := s <> pnAnatomicLocationMasterList;
  ckbSelectAll.Enabled := s <> pnAnatomicLocationMasterList;

  pnlChart.Visible := s <> pnAnatomicLocationMasterList;
  lbMaster.Visible := s = pnAnatomicLocationMasterList;
  mmMaster.Visible := s = pnAnatomicLocationMasterList;

  ckbLocations.Visible := (s <> pnAnatomicLocationMasterList)
    or (Mode = 'DEBUG');

  if s = pnAnatomicLocationMasterList then
  begin                                 // master list processing
    ckbSelectAll.Checked := false;
    splChart.Align := alTop;
  end
  else
  begin
    acGroupLoadExecute(nil);
    splChart.Align := alBottom;
  end;

  splChart.Visible := s <> pnAnatomicLocationMasterList;
  Application.ProcessMessages;
end;

procedure TfrmBCMAParameters.cmbALListClick(Sender: TObject);
var
//  alGroup: TALGroup;
  s: string;
  i: Integer;
begin
  i := cmbALList.ItemIndex;
  s := cmbALList.Items[i];

  pnlMasterTool.Enabled := s = pnAnatomicLocationMasterList;
  btnGroupLoad.Enabled := s <> pnAnatomicLocationMasterList;
  btnGroupNew.Enabled := s <> pnAnatomicLocationMasterList;
  btnGroupDelete.Enabled := s <> pnAnatomicLocationMasterList;
  ckbSelectAll.Enabled := s <> pnAnatomicLocationMasterList;

  pnlChart.Visible := s <> pnAnatomicLocationMasterList;
  lbMaster.Visible := s = pnAnatomicLocationMasterList;
  mmMaster.Visible := s = pnAnatomicLocationMasterList;

  ckbLocations.Visible := (s <> pnAnatomicLocationMasterList)
    or (Mode = 'DEBUG');

  if s = pnAnatomicLocationMasterList then
  begin                                 // master list processing
    ckbSelectAll.Checked := false;
    splChart.Align := alTop;
  end
  else
  begin
    acGroupLoadExecute(nil);
    splChart.Align := alBottom;
  end;

  splChart.Visible := s <> pnAnatomicLocationMasterList;
  Application.ProcessMessages;
end;                                    // cmbALListClick

function TfrmBCMAParameters.getALGroupCurrent: TALGroup;
begin
  if PageControl1.ActivePage = tsAnswerList then
    Result := alMRR
  else
  begin
    if cmbALList.ItemIndex < 0 then
      Result := nil
    else
      Result := TAlGroup(cmbALList.Items.Objects[cmbALList.ItemIndex]);
  end;
end;

{$IFDEF CAS_DDPE_TEST}

procedure TfrmBCMAParameters.SaveAnatomicLocationMapList;
var
  i: integer;
  s: string;

begin
// Saving Anatomic Locations Map List //////////////////////////////////////////
  BCMA_Broker.CallServer('PSB PARAMETER', ['DELLST', Division,
    AnatomicLocationMapList], nil);
  for i := 0 to ALBackup.Count - 1 do
  begin
    s := ALBackup[i];
     // save the Location parameter

    BCMA_Broker.CallServer('PSB PARAMETER',
      ['SETPAR', trim(Division), AnatomicLocationMapList, IntToStr(i + 1), s],
      nil);
      // warn the user if an Item is not saved.

    if piece(BCMA_Broker.Results[0], '^', 1) = '-1' then
      messagedlg('Invalid Parameter [' + IntToStr(i + 1) +
        '] ' + #13#10 + 'Value [' + s + '] was not saved.', mtError, [mbok], 0);
  end;
end;


{ procedure TfrmBCMAParameters.setByList(aList: TStringList);
var
  i: integer;

//  procedure setMapItem(aValue: String);
  procedure setMapItem(ii: Integer; aValue: String);
  var
    iLimit,
      idx: Integer;
    li: TListItem;
    j, ID: Integer;
    s: String;
  begin
    iLimit := 0;
    idx := 0;

//    while idx < Length(aValue) do
//      begin
//        if aValue[idx+1]=MapDelimeter then
//          inc(iLimit);
//        inc(idx);
//      end;

    li := lvwDefAnswer.Items.Add;
    s := Piece(aValue, MapDelimiter, 1);
    if TryStrToInt(s, ID) then begin
      li.Caption := piece(aValue, MapDelimiter, 2); // name
      li.SubItems.Add(piece(aValue, MapDelimiter, 1)); // ID
      li.SubItems.Add(piece(aValue, MapDelimiter, 3)); // X
      li.SubItems.Add(piece(aValue, MapDelimiter, 4)); // Y
      li.StateIndex := idxNoCoordinates;
      li.Data := frmALMapEdit.ShapeByItem(nil, pnlBodyChart, li, ID);
    end
    else begin
      li.Caption := piece(aValue, MapDelimiter, 1); // name

      s := piece(AValue, MapDelimiter, 2);
      j := StrToIntDef(s, 0);
      li.SubItems.Add(IfThen(j = 1, 'Y', '')); // injection flag

      s := piece(AValue, MapDelimiter, 3);
      j := StrToIntDef(s, 0);
      li.SubItems.Add(IfThen(j = 1, 'Y', '')); // dermal flag

      li.SubItems.Add(piece(aValue, MapDelimiter, 4)); // ID
      li.SubItems.Add(piece(aValue, MapDelimiter, 5)); // X
      li.SubItems.Add(piece(aValue, MapDelimiter, 6)); // Y
      li.StateIndex := idxNoCoordinates;
//      li.Data := ShapeByItem2(nil, pnlBodyChart, li, i);
      li.Data := frmALMapEdit.ShapeByItem2(nil, pnlBodyChart, li, ii);
    end;
//    li.StateIndex := idxNoCoordinates;
//    if li.SubItems.Count > idxX then
//    li.Data := ShapeByItem(nil, pnlBodyChart, li, i);
  end;                                  // setMapItem

begin
  removeShapes(lvwDefAnswer.Items, True);
  lvwDefAnswer.Items.Clear;
  while lvwDefAnswer.Items.Count > 0 do
  begin
    lvwDefAnswer.Items.Delete(0);
  end;
  for i := 0 to aList.Count - 1 do
//    setMapItem(aList[i]);
    setMapItem(i, aList[i]);
                                  end; }// setByList

{ procedure TfrmBCMAParameters.setByALList(aList: TStringList);
var
  i: integer;

//  procedure setMapItem(anItem: TALItem);
  procedure setMapItem(ii: Integer; anItem: TALItem);
  var
    li: TListItem;
  begin
    li := lvwDefAnswer.Items.Add;
    li.Caption := anItem.Caption;
    li.SubItems.Add(IfThen(anItem.InjectionFlag = 1, 'Y', ''));
    li.SubItems.Add(IfThen(anItem.DermalFlag = 1, 'Y', ''));
    li.SubItems.Add(IntToStr(anItem.ID));
    li.SubItems.Add(IntToStr(anItem.X));
    li.SubItems.Add(IntToStr(anItem.Y));
    li.StateIndex := idxNoCoordinates;

//    li.Data := ShapeByItem(nil, pnlBodyChart, li, i);
    li.Data := frmALMapEdit.ShapeByItem2(nil, pnlBodyChart, li, ii);
  end;

begin
  removeShapes(lvwDefAnswer.Items, True);
  lvwDefAnswer.Items.Clear;
  for i := 0 to aList.Count - 1 do
  begin
    if assigned(aList.Objects[i]) then
      if aList.Objects[i] is TALItem then
//        setMapItem(TALItem(aList.Objects[i]));
        setMapItem(i, TALItem(aList.Objects[i]));
  end;
                                  end; }// setByALList


{$ENDIF}

end.

