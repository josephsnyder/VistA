unit fCoverSheet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Math,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ImgList, grids, BCMA_Util, oCoverSheet,
  oInterfaces,
  XPStyleActnCtrls, ActnList, ActnMan, Menus, stabSort, DateUtils, StrUtils,
  BCMA_Objects, VA508AccessibilityManager;
const
  SelectedItems: array[0..2] of integer = (-1, -1, -1);

  CSMouseOverTextStat = 'Stat Order';
  CSMouseOverTextOrderFlag = 'Order Flag';
  CSMouseOverTextNoAction = 'IV Order -  No action taken yet';
  CSMouseOverTextOvrIntvent = 'Override/Intervention reasons'; // rpk 5/18/2011
//  CSMouseOverTextWitness = 'High Risk / High Alert - Witness Required'; // rpk 9/11/2012
  CSMouseOverTextWitness = 'High Risk / High Alert - Witness Required/Recommended'; // rpk 11/15/2012
  CSTooMuchInfo = 'Too much information to display. Use right-click menu to display full text.';

type
  TfrmCoverSheet = class(TForm)
    pnlView: TPanel;
    lblView: TLabel;
    cbxView: TComboBox;
    sbxCoverSheet: TScrollBox;
    ImageList1: TImageList;
    //Image1: TImage;
    lblCoverSheet: TLabel;
    ActionManagerCoverSheet: TActionManager;
    ActionCSAvailableBags: TAction;
    ActionCSDisplayOrder: TAction;
    ActionCSMedHistory: TAction;
    chkGridLines: TCheckBox;
    ActionCSWhatsThis: TAction;
    PABarCoverSheet: TPopupMenu;
    AvailableBags2: TMenuItem;
    DisplayOrder2: TMenuItem;
    MedHistory2: TMenuItem;
    N2: TMenuItem;
    AvailableBags3: TMenuItem;
    pnlEXHours: TPanel;
    cbxExpired: TComboBox;
    ActionCSDisplayFlag: TAction;
    mnuCSOrderFlag: TMenuItem;
    lblExpiredCaption: TLabel;
    lblExpiring: TLabel;
    cbxExpiring: TComboBox;
    ActionCSDisplaySI: TAction;
    DisplaySpecialInstructions1: TMenuItem;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    N1: TMenuItem;
    acRawOrder: TAction;
    DEBUGRawOrder1: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbxViewChange(Sender: TObject);
    procedure ActionCSDisplayOrderExecute(Sender: TObject);
    procedure ActionCSMedHistoryExecute(Sender: TObject);
    procedure ActionCSAvailableBagsExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GrpExpCol(GroupNum: Integer);
    procedure chkGridLinesClick(Sender: TObject);
    procedure sbxCoverSheetMouseWheelUp(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure ActionCSWhatsThisExecute(Sender: TObject);
    procedure cbxExpiredChange(Sender: TObject);
    procedure ActionCSDisplayFlagExecute(Sender: TObject);
    procedure ActionCSDisplayFlagUpdate(Sender: TObject);
    procedure cbxExpiringChange(Sender: TObject);
    procedure ActionCSDisplaySIExecute(Sender: TObject);
    procedure ActionCSDisplaySIUpdate(Sender: TObject);
    procedure ActionCSAvailableBagsUpdate(Sender: TObject);
    procedure acRawOrderExecute(Sender: TObject);
    {
     Calls DisplaySOMemo to retrieve and display the full text of the special
     instructions or other print info.
    }

  private
    { Private declarations }
    CurrentView: TCoverSheetViews;

    procedure PopulateView(View: TCoverSheetViews);
    procedure BuildMOGroup(MOListBox: TListBox);
    procedure BuildPRNGroup(PRNListBox: TListBox);
    procedure BuildIVGroup(IVListBox: TListBox);
    procedure BuildExGroup(ExListBox: TListBox);

    {Create Med Overview Group Headers}
    procedure CreateMOGroupHeaders(GroupIn: Integer);
    procedure CreateMOGroupData(GroupIn: Integer);
    procedure CreatePRNGroupHeaders(GroupIn: Integer);
    procedure CreatePRNGroupData(GroupIn: Integer);
    procedure CreateIVGroupHeaders(GroupIn: Integer);
    procedure CreateIVGroupData(GroupIn: Integer);
    procedure CreateExGroupHeaders(GroupIn: Integer);
    procedure CreateExGroupData(GroupIn: Integer);

    procedure SetHeaderMaxWidth(tempHeaderControl: THeaderControl);

    procedure hdrCoversheetSectionResize(HeaderControl: THeaderControl; Section:
      THeaderSection);
    procedure hdrCoverSheetSectionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hdrCoverSheetSectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);

    procedure GroupImageClick(Sender: TObject);

    procedure lstMOGroupBoxesDoseDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lstGroupBoxesMeasureItem(Control: TWinControl;
      Index: Integer; var Height: Integer);

    procedure lstPRNGroupBoxesDoseDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lstIVGroupBoxesDoseDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lstExGroupBoxesDoseDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);

    procedure lstGroupBoxesContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);

    procedure lstGroupBoxesClick(Sender: TObject);
    procedure lstGroupBoxesMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lstGroupBoxesMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lstGroupBoxesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lstGroupBoxesCustomClick(Sender: Tobject);
    procedure lstGroupBoxesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstGroupBoxesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstGroupBoxesExit(Sender: TObject);
    procedure lstGroupBoxesEnter(Sender: TObject);
    //    procedure lstGroupBoxesDoubleClick(Sender: TObject);

    procedure pnlGroupClick(Sender: TObject);
    //    procedure edtPnlGroupEnter(Sender: TObject);
    //    procedure edtPnlGroupExit(Sender: TObject);
    //    procedure edtPnlKeyUp(Sender: TObject; var Key: Word;
    //      Shift: TShiftState);

    procedure RepaintCoverSheet;
    //    function GetIndexOfListBox(ListBoxIn: TListBox): Integer;
        //    function SortCoverSheet(Item1, Item2: pointer): Integer;
    procedure SetExpiredSectionCaptions;
    {
     Calls StripLB to replace CR-LF line breaks with spaces.
     Limits instr to 180 characters and adds ellipsis to end if longer.
    }
    function TrimSpecInstr(instr: string): string; // rpk 4/23/2009

    // modify lists in cbxExpired and cbxExpiring for Inpatient or Clinic mode
    procedure SetExCbx;                 // rpk 7/11/2012

  public
    { Public declarations }
    procedure RebuildGroups;
    procedure ReloadCoverSheet(ReLoad, Rebuild: Boolean; Hours: string = '24';
      RebuildComplete: Boolean = false);
  end;
type
  TSortType = (stAscending, stDescending);
  //  SortCoverSheet = function (Item1, Item2: Pointer): Integer;

var
  frmCoverSheet: TfrmCoverSheet;
  pnlCoversheet: TPanel;

  CoverSheetOrders,                     //All Orders
    ExpiredCSOrders,                    //Expired Orders
    ActiveCSOrders,                     //Active Orders
    FutureCSOrders,                     //Future Orders
    AllAdmins: Tlist;
  AllComments: Tlist;
  SelectedOrder: TCoverSheet_Order;
  SelectedItemIndex: Integer;
  CSSortType: TSortType;
  ScrollBarPosition: Integer;
  HintLastCell: TPoint;

implementation
uses BCMA_Common, BCMA_Main, ReportRequest,
//MFunStr,
uCAS_Utils;

{$R *.dfm}

var
  CurrentCSItem: Integer;

function SortCoverSheet(Item1, Item2: pointer): Integer;
//var
//  i: Integer;
begin
  result := 1;
//  i := CoverSheetSortColumns[TCoverSheetViews(frmCoverSheet.cbxView.ItemIndex)];

  // inserted Verify Nurse column in all three views; rpk 4/19/2011
  try
    case frmCoverSheet.cbxView.ItemIndex of
//      0, 3: // medoverview, expired
      ord(csvMedOverview), ord(csvExpiringOrders):
        case
          CoverSheetSortColumns[TCoverSheetViews(frmCoverSheet.cbxView.ItemIndex)]
          of
//          0..2:
          ord(ctNoActionTaken)..ord(ctFlag):
            result := 0;

//          3:
          ord(cClinicName):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).ClinicName,
              TCoverSheet_Order(Item2).ClinicName);

          // 3:
          ord(ctTab):
            result :=
              AnsiCompareStr(VDLTabText[StrToInt(TCoverSheet_Order(Item1).VDLTab)],
              VDLTabText[StrToInt(TCoverSheet_Order(Item2).VDLTab)]);

          // 4:
          ord(cStatus):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).OrderStatus,
              TCoverSheet_Order(Item2).OrderStatus);

          // 5:
          ord(cVerifyNurse):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).VerifyNurse,
              TCoverSheet_Order(Item2).VerifyNurse); // rpk 4/19/2011

          // 6:
          ord(cType):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).ScheduleType,
              TCoverSheet_Order(Item2).ScheduleType);

          ord(cWitness):                // rpk 9/11/2012
            result := AnsiCompareStr(TCoverSheet_Order(Item1).WitnessFlag,
              TCoverSheet_Order(Item2).WitnessFlag);

          // 7:
          ord(cMedication):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).ActiveMedication,
              TCoverSheet_Order(Item2).ActiveMedication);

          // 8:
          ord(cSchedule):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).Schedule,
              TCoverSheet_Order(Item2).Schedule);

          // 9:
          ord(cDosage):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).Dosage,
              TCoverSheet_Order(Item2).Dosage);

          // 10:
          ord(cNextAction):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).NextAdminDateTime,
              TCoverSheet_Order(Item2).NextAdminDateTime);

          // 11:
          ord(cSpecialInstructions):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).SpecialInstructions,
              TCoverSheet_Order(Item2).SpecialInstructions);

          // 12:
          ord(csStartDate):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).StartDateTime,
              TCoverSheet_Order(Item2).StartDateTime);

          // 13:
          ord(cStopDate):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).StopDateTime,
              TCoverSheet_Order(Item2).StopDateTime);

        end;
//      1: // PRN Assessment
      ord(csvPRNAssessment):
        case
          CoverSheetSortColumns[TCoverSheetViews(frmCoverSheet.cbxView.ItemIndex)]
          of
          // 0..1:
          ord(ctPRNStat)..ord(ctPRNFlag):
            result := 0;
          ord(ctPRNClinicName):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).ClinicName,
              TCoverSheet_Order(Item2).ClinicName);
          // 2:
          ord(ctPRNTab):
            result :=
              AnsiCompareStr(VDLTabText[StrToInt(TCoverSheet_Order(Item1).VDLTab)],
              VDLTabText[StrToInt(TCoverSheet_Order(Item2).VDLTab)]);
          // 3:
          ord(ctPRNStatus):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).OrderStatus,
              TCoverSheet_Order(Item2).OrderStatus);
          // 4:
          ord(ctPRNVerifyNurse):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).VerifyNurse,
              TCoverSheet_Order(Item2).VerifyNurse); // rpk 4/19/2011
          // 5:
          ord(ctPRNMedication):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).ActiveMedication,
              TCoverSheet_Order(Item2).ActiveMedication);
          // 6:
          ord(ctPRNSchedule):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).Schedule,
              TCoverSheet_Order(Item2).Schedule);
          // 7:
          ord(ctPRNDosage):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).Dosage,
              TCoverSheet_Order(Item2).Dosage);
          // 8:
          ord(ctPRNLastGiven):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).TimeLastGiven,
              TCoverSheet_Order(Item2).TimeLastGiven);
          // 9:
          ord(ctPRNSinceLast):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).SinceLast,
              TCoverSheet_Order(Item2).SinceLast);
          // 10:
          ord(ctPRNSpecialInstructions):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).SpecialInstructions,
              TCoverSheet_Order(Item2).SpecialInstructions);
          // 11:
          ord(ctPRNStartDate):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).StartDateTime,
              TCoverSheet_Order(Item2).StartDateTime);
          // 12:
          ord(ctPRNStopDate):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).StopDateTime,
              TCoverSheet_Order(Item2).StopDateTime);
        end;

  { TIVColTypes = (
    ctIVNoActionTaken,
    ctIVStat,
    ctIVFlag,
    ctIVClinicName,  // rpk 5/14/2012
    ctIVBagID,
    ctIVOrderStatus,
    ctIVBagStatus,
    ctIVVerifyNurse, // rpk 2/4/2011
    ctIVMedication,
    ctIVInfusionRate,
    ctIVOtherPrintInfo,
    ctIVBagInfo,
    ctIVStartDate,
    ctIVStopDate); }
//      2: // IV Overview
      ord(csvIVOverview):
        case
          CoverSheetSortColumns[TCoverSheetViews(frmCoverSheet.cbxView.ItemIndex)]
          of
          // 0..2:
          ord(ctIVNoActionTaken)..ord(ctIVFlag):
            result := 0;
          ord(ctIVClinicName):
            result :=
              AnsiCompareStr(TCoverSheet_Order(TCoverSheet_Admin(Item1).Order).ClinicName,
              TCoverSheet_Order(TCoverSheet_Admin(Item2).Order).ClinicName);
          // 3:
          ord(ctIVBagID):
            result := AnsiCompareStr(TCoverSheet_Admin(Item1).BagID,
              TCoverSheet_Admin(Item2).BagID);
          // 4:
          ord(ctIVOrderStatus):
            result :=
              AnsiCompareStr(TCoverSheet_Order(TCoverSheet_Admin(Item1).Order).OrderStatus,
              TCoverSheet_Order(TCoverSheet_Admin(Item2).Order).OrderStatus);
          // 5:
          ord(ctIVBagStatus):
            result := AnsiCompareStr(TCoverSheet_Admin(Item1).Action,
              TCoverSheet_Admin(Item2).Action);
          // 6:
          ord(ctIVVerifyNurse):
            result := AnsiCompareStr(TCoverSheet_Order(Item1).VerifyNurse,
              TCoverSheet_Order(Item2).VerifyNurse); // rpk 4/19/2011
          // 7:
          ord(ctIVMedication):
            result :=
              AnsiCompareStr(TCoverSheet_Order(TCoverSheet_Admin(Item1).Order).ActiveMedication,
              TCoverSheet_Order(TCoverSheet_Admin(Item2).Order).ActiveMedication);
          // 8:
          ord(ctIVInfusionRate):
            result :=
              AnsiCompareStr(TCoverSheet_Order(TCoverSheet_Admin(Item1).Order).Dosage,
              TCoverSheet_Order(TCoverSheet_Admin(Item2).Order).Dosage);
          // 9:
          ord(ctIVOtherPrintInfo):
            result :=
              AnsiCompareStr(TCoverSheet_Order(TCoverSheet_Admin(Item1).Order).SpecialInstructions,
              TCoverSheet_Order(TCoverSheet_Admin(Item2).Order).SpecialInstructions);
          // 10:
          ord(ctIVBagInfo):
            result :=
              AnsiCompareStr(TCoverSheet_Order(TCoverSheet_Admin(Item1).Order).Changed,
              TCoverSheet_Order(TCoverSheet_Admin(Item2).Order).Changed);
          // 11:
          ord(ctIVStartDate):
            result :=
              AnsiCompareStr(TCoverSheet_Order(TCoverSheet_Admin(Item1).Order).StartDateTime,
              TCoverSheet_Order(TCoverSheet_Admin(Item2).Order).StartDateTime);
          // 12:
          ord(ctIVStopDate):
            result :=
              AnsiCompareStr(TCoverSheet_Order(TCoverSheet_Admin(Item1).Order).StopDateTime,
              TCoverSheet_Order(TCoverSheet_Admin(Item2).Order).StopDateTime);
        end;

    end;

  finally
    if CSSortType = stDescending then
    begin
      if result = 1 then
        result := -1
      else if result = -1 then
        result := 1;
    end;
  end;

end;

function TfrmCoverSheet.TrimSpecInstr(inStr: string): string; // rpk 4/23/2009
var
  outstr: string;
begin
  instr := StripLB(instr);
  //  tmpstr := instr;
  if Length(instr) > 180 then
//    outstr := Copy(instr, 1, 180) + '...'
    outstr := CSTooMuchInfo             // rpk 1/4/2012
  else
    outstr := instr;
  Result := outstr;
end;                                    // TrimSpecInstr

procedure TfrmCoverSheet.SetExCbx;
var
  idx: Integer;
begin
  idx := -1;                            // rpk 7/25/2012

  with cbxExpired do begin
    if OrderMode = omClinic then begin
      if Items.Count = 3 then
        AddItem(' 7 Days', ptr(168));   // rpk 7/11/2012
      ItemIndex := 3;                   // 7 days
      Enabled := False;
    end
    else begin                          // inpatient order mode
      idx := ItemIndex;                 // rpk 7/20/2012
      if idx > 2 then
        idx := 2;                       // 72 hours
      if Items.Count = 4 then
        Items.Delete(3);                // rpk 7/11/2012
      if ItemIndex < 0 then
        ItemIndex := idx;               // rpk 7/20/2012
      Enabled := True;
    end;
  end;

  with cbxExpiring do begin
    if OrderMode = omClinic then begin
      if Items.Count = 3 then
        AddItem(' 7 Days', ptr(7));     // rpk 7/13/2012
      ItemIndex := 3;                   // 7 days
      Enabled := False;
    end
    else begin                          // inpatient order mode
      idx := ItemIndex;                 // rpk 7/20/2012
      if idx > 2 then
        idx := 2;                       // 72 hours
      if Items.Count = 4 then
        Items.Delete(3);                // rpk 7/11/2012
      if ItemIndex < 0 then
        ItemIndex := idx;               // rpk 7/20/2012
      Enabled := True;
    end;
  end;

end;                                    // SetExCbx

procedure TfrmCoverSheet.FormCreate(Sender: TObject);
var
  x: integer;
begin
  with cbxExpired do
  begin
    Clear;
    AddItem('24 Hours', ptr(24));
    AddItem('48 Hours', ptr(48));
    AddItem('72 Hours', ptr(72));
    if OrderMode = omClinic then
      AddItem(' 7 Days', ptr(168));     // rpk 7/11/2012
  end;

  with cbxExpiring do
  begin
    Clear;
    AddItem('24 Hours', ptr(1));
    AddItem('48 Hours', ptr(2));
    AddItem('72 Hours', ptr(3));
    if OrderMode = omClinic then
      AddItem(' 7 Days', ptr(7));       // rpk 7/13/2012
    ItemIndex := 0;
  end;

//  CurrentView := TCoverSheetViews(0);
  CurrentView := TCoverSheetViews(csvMedOverview); // rpk 7/12/2012
  CoverSheetOrders := TList.Create;
  ExpiredCSOrders := TList.Create;
  ActiveCSOrders := TList.Create;
  FutureCSOrders := TList.Create;
  AllAdmins := TList.Create;
  AllComments := TList.Create;
  for x := 0 to Length(CoverSheetViewTitles) - 1 do
    cbxView.AddItem(CoverSheetViewTitles[TCoverSheetViews(x)], nil);
  cbxView.ItemIndex := 0;
  for x := 0 to Length(grdCellData) - 1 do
    grdCellData[x] := TStringGrid.Create(Application);
  with BCMA_UserParameters do
  begin
    CoverSheetSortColumns[TCoverSheetViews(csvMedOverview)] := CSMOSortColumn;
    CoverSheetSortColumns[TCoverSheetViews(csvPRNAssessment)] :=
      CSPRNSortColumn;
    CoverSheetSortColumns[TCoverSheetViews(csvIVOverview)] := CSIVSortColumn;
    CoverSheetSortColumns[TCoverSheetViews(csvExpiringOrders)] :=
      CSExSortColumn;
  end;

  HelpContext := 904;                   // rpk 9/15/2010

  CurrentCSItem := -1;                  // rpk 11/27/2012

{$IFDEF CAS_DDPE_DEBUG}
  N1.Visible := True;
  DEBUGRawOrder1.Visible := True;
{$ENDIF}
end;

procedure TfrmCoverSheet.FormShow(Sender: TObject);
begin
  //the scrollbox is aligned to the top of the parent, so in theory the width
  //should be the same size, but for some reason it isn't, so make it the same
  sbxCoverSheet.Width := Parent.Width;
  SelectedOrder := nil;                 // rpk 4/6/2012
  pnlExHours.Hide;                      // rpk 7/24/2012
  ReloadCoverSheet(True, False);

//  ShowCtrlName('frmCoverSheetFormShow', ActiveControl);
end;

procedure TfrmCoverSheet.cbxExpiredChange(Sender: TObject);
begin
  ClearCoverSheetOrders;
  SetExpiredSectionCaptions;
  ReloadCoverSheet(True, false,
    IntToStr(Integer(cbxExpired.Items.Objects[cbxExpired.ItemIndex])));
end;

procedure TfrmCoverSheet.cbxExpiringChange(Sender: TObject);
begin
  SetExpiredSectionCaptions;
  ReloadCoverSheet(False, False, '', True);
end;

procedure TfrmCoverSheet.cbxViewChange(Sender: TObject);
begin
//  pnlExHours.Visible := (cbxView.ItemIndex = 3);
  pnlExHours.Visible := (cbxView.ItemIndex = ord(csvExpiringOrders));
//  if (CurrentView = TCoverSheetViews(3)) and (cbxExpired.ItemIndex <> 0) and
//    (cbxView.ItemIndex <> 3) then
//  if (CurrentView = TCoverSheetViews(ord(csvExpiringOrders))) and
  if (CurrentView = csvExpiringOrders) and
    (cbxExpired.ItemIndex <> ord(exExpired)) and
    (cbxView.ItemIndex <> ord(csvExpiringOrders)) then
  begin
    CurrentView := TCoverSheetViews(cbxView.ItemIndex);
    ClearCoverSheetOrders;
    ReloadCoverSheet(True, False);
    exit;
  end;

  SetExCbx;                             // rpk 7/12/2012

  if not pnlExHours.Visible then
  begin
    cbxExpired.ItemIndex := 0;
    cbxExpiring.ItemIndex := 0;
    SetExpiredSectionCaptions;
  end;

  sbxCoverSheet.Visible := False;
  {Remove any existing controls}
  if sbxCoverSheet.ControlCount > 1 then
    repeat
      sbxCoverSheet.Controls[sbxCoverSheet.ControlCount - 1].Free;
    until sbxCoverSheet.ControlCount = 0;
  //  ClearCoverSheetFlags;
  PopulateView(TCoverSheetViews(cbxView.ItemIndex));

  sbxCoverSheet.Realign;
  sbxCoverSheet.Visible := True;
  CurrentView := TCoverSheetViews(cbxView.ItemIndex);
  RepaintCoverSheet;

//  ShowCtrlName('frmCoverSheetcbxViewChg', ActiveControl);
end;                                    // cbxViewChange

procedure TfrmCoverSheet.PopulateView(View: TCoverSheetViews);
var
  x: integer;
  procedure SetupPanel(pnlTemp: TPanel; GroupNum: Integer);
  begin
    with pnlTemp do
    begin
      BevelInner := bvNone;
      BevelOuter := bvNone;
      Color := clWhite;
      Font.Style := [fsBold];
      Height := 17;
      Left := 100;
      Alignment := taLeftJustify;
      Parent := sbxCoverSheet;
      Top := 5000;
      Align := alTop;
      OnClick := pnlGroupClick;
      Tag := GroupNum;
      {
            tmpEdit := TEdit.Create(self);
            with tmpEdit do
            begin
              parent := pnlTemp;
              width := 0;
              height := 0;
              left := 100;
              ReadOnly := true;
              OnEnter := edtPnlGroupEnter;
              OnExit := edtPnlGroupExit;
              OnKeyDown := edtPnlKeyUp;
            end;
      }
    end;
  end;                                  // SetupPanel

begin
  case View of
    csvMedOverview:                     //Med Overview
      {loop through each group on the view and add the group title}
      for x := 0 to Length(MedOverviewGroupTitles) - 1 do
      begin
        pnlMOGroupPanels[x] := TPanel.Create(Self);
        SetupPanel(pnlMOGroupPanels[x], x);
        //        with pnlMOGroupPanels[x] do
        //        begin
        //          Tag := x;
        //          OnClick := pnlGroupClick;
        //        end;

        imgMOGroupImages[x] := TImage.Create(Self);
        with imgMOGroupImages[x] do
        begin
          Parent := pnlMOGroupPanels[x];
          Top := 1;
          Height := 17;
          Width := 17;
          Tag := x;
          OnClick := GroupImageClick;
          Align := alLeft;
        end;

        //        if MedOverviewGrpExpanded[TMedOverviewGroups(x)] > 0 then
        //          ImageList1.Draw(imgMOGroupImages[x].Canvas, 0, 0, 0);

                {Create and Populate the THeaderControl}
        CreateMOGroupHeaders(x);

        {Create and populate the TListBox with the Orders}
        CreateMOGroupData(X);
      end;
    csvPRNAssessment:                   //PRN Assessment
      {loop through each group in the view and add the group title}
      for x := 0 to Length(PRNAGroupTitles) - 1 do
      begin
        pnlPRNGroupPanels[x] := TPanel.Create(Self);
        SetupPanel(pnlPRNGroupPanels[x], x);
        //        with pnlPRNGroupPanels[x] do
        //        begin
        //          Tag := x;
        //          OnClick := pnlGroupClick;
        //        end;

        imgPRNGroupImages[x] := TIMage.Create(Self);
        with imgPRNGroupImages[x] do
        begin
          Parent := pnlPRNGroupPanels[x];
          Top := 1;
          Height := 17;
          Width := 17;
          Tag := x;
          OnClick := GroupImageClick;
        end;

        if PRNAGrpExpanded[TPRNGroups(x)] > 0 then
          ImageList1.Draw(imgPRNGroupImages[x].Canvas, 0, 0, 0);

        {Create and Populate the THeaderControl}
        CreatePRNGroupHeaders(x);

        {Create and populate the TListBox with the Orders}
        CreatePRNGroupData(X);
      end;
    csvIVOverview:                      //IV Overview
      {loop through each group in the view and add the group title}
//      for x := 0 to Length(ExGroupTitles) - 1 do  // incorrect for IV overview?
      for x := 0 to Length(IVOGroupTitles) - 1 do // rpk 7/11/2012
      begin
        pnlIVGroupPanels[x] := TPanel.Create(Self);
        SetupPanel(pnlIVGroupPanels[x], x);

        imgIVGroupImages[x] := TIMage.Create(Self);
        with imgIVGroupImages[x] do
        begin
          Parent := pnlIVGroupPanels[x];
          Top := 1;
          Height := 17;
          Width := 17;
          Tag := x;
          OnClick := GroupImageClick;
        end;

        //        if IVOGrpExpanded[TIVGroups(x)] > 0 then
        //          ImageList1.Draw(imgIVGroupImages[x].Canvas, 0, 0, 0);

                {Create and Populate the THeaderControl}
        CreateIVGroupHeaders(x);

        {Create and populate the TListBox with the Orders}
        CreateIVGroupData(X);
      end;
    csvExpiringOrders:                  // Expired/DC'd/Expiring Orders view
      {loop through each group in the view and add the group title}
      for x := 0 to Length(ExGroupTitles) - 1 do
      begin
        pnlExGroupPanels[x] := TPanel.Create(Self);
        SetupPanel(pnlExGroupPanels[x], x);

        imgExGroupImages[x] := TImage.Create(Self);
        with imgExGroupImages[x] do
        begin
          Parent := pnlExGroupPanels[x];
          Top := 1;
          Height := 17;
          Width := 17;
          Tag := x;
          OnClick := GroupImageClick;
        end;

        //        if ExGrpExpanded[TExpiredGroups(x)] > 0 then
        //          ImageList1.Draw(imgExGroupImages[x].Canvas, 0, 0, 0);

        {Create and Populate the THeaderControl}
        CreateExGroupHeaders(x);

        {Create and populate the TListBox with the Orders}
        CreateExGroupData(X);
      end;

  end;                                  {end case ViewIndex}
end;                                    // PopulateView

procedure TfrmCoverSheet.CreateMOGroupHeaders(GroupIn: Integer);
var
  HeaderSection: THeaderSection;
  x: integer;
begin
  hdrMOGroupHeaders[GroupIn] := THeaderControl.Create(self);
  with hdrMOGroupHeaders[GroupIn] do
  begin
    Parent := sbxCoverSheet;
    Top := 5000;
    Align := alTop;
    //Style := hsFlat;
    OnSectionResize := hdrCoversheetSectionResize;
    OnMouseUp := hdrCoverSheetSectionMouseUp;
    OnSectionClick := hdrCoverSheetSectionClick;
    ReDrawSuspend(hdrMOGroupHeaders[GroupIn].Handle);
    for x := 0 to Length(MedOverviewColTitles) - 1 do
    begin
      HeaderSection := Sections.Add;
      HeaderSection.Text := MedOverviewColTitles[TMedOverviewColTypes(x)];
      HeaderSection.Width := MedOverviewColWidths[TMedOverViewColTypes(x)];
    end;
  end;
  SetHeaderMaxWidth(hdrMOGroupHeaders[GroupIn]);
  ReDrawActivate(hdrMOGroupHeaders[GroupIn].Handle);
  hdrMOGroupHeaders[GroupIn].Repaint;
  with hdrMOGroupHeaders[GroupIn] do
    tag := height;
end;                                    // CreateMOGroupHeaders

procedure TfrmCoverSheet.CreatePRNGroupHeaders(GroupIn: Integer);
var
  HeaderSection: THeaderSection;
  x: integer;
begin
  hdrPRNGroupHeaders[GroupIn] := THeaderControl.Create(self);
  with hdrPRNGroupHeaders[GroupIn] do
  begin
    Parent := sbxCoverSheet;
    Top := 5000;
    Align := alTop;
    //    Style := hsFlat;
    OnSectionResize := hdrCoversheetSectionResize;
    OnMouseUp := hdrCoverSheetSectionMouseUp;
    OnSectionClick := hdrCoverSheetSectionClick;
    ReDrawSuspend(hdrPRNGroupHeaders[GroupIn].Handle);
    for x := 0 to Length(PRNAColTitlesLvl1) - 1 do
    begin
      HeaderSection := Sections.Add;
      HeaderSection.Text := PRNAColTitlesLvl1[TPRNColTypes(x)];
      HeaderSection.Width := PRNAColWidths[TPRNColTypes(x)];
    end;

  end;

  SetHeaderMaxWidth(hdrPRNGroupHeaders[GroupIn]); // rpk 5/22/2012
  ReDrawActivate(hdrPRNGroupHeaders[GroupIn].Handle);
end;

procedure TfrmCoverSheet.CreateIVGroupHeaders(GroupIn: Integer);
var
  HeaderSection: THeaderSection;
  x: integer;
begin
  hdrIVGroupHeaders[GroupIn] := THeaderControl.Create(self);
  with hdrIVGroupHeaders[GroupIn] do
  begin
    Parent := sbxCoverSheet;
    Top := 5000;
    Align := alTop;
    //    Style := hsFlat;
    OnSectionResize := hdrCoversheetSectionResize;
    OnMouseUp := hdrCoverSheetSectionMouseUp;
    OnSectionClick := hdrCoverSheetSectionClick;
    ReDrawSuspend(hdrIVGroupHeaders[GroupIn].Handle);
    for x := 0 to Length(IVOColTitlesLvl1) - 1 do
    begin
      HeaderSection := Sections.Add;
      HeaderSection.Text := IVOColTitlesLvl1[TIVColTypes(x)];
      HeaderSection.Width := IVColWidths[TIVColTypes(x)];
    end;

  end;

  SetHeaderMaxWidth(hdrIVGroupHeaders[GroupIn]); // rpk 5/22/2012
  ReDrawActivate(hdrIVGroupHeaders[GroupIn].Handle);
end;

procedure TfrmCoverSheet.CreateExGroupHeaders(GroupIn: Integer);
var
  HeaderSection: THeaderSection;
  x: integer;
begin
  hdrExGroupHeaders[GroupIn] := THeaderControl.Create(self);
  with hdrExGroupHeaders[GroupIn] do
  begin
    Parent := sbxCoverSheet;
    Top := 5000;
    Align := alTop;
    //    Style := hsFlat;
    OnSectionResize := hdrCoversheetSectionResize;
    OnMouseUp := hdrCoverSheetSectionMouseUp;
    OnSectionClick := hdrCoverSheetSectionClick;

    for x := 0 to Length(ExColTitlesLvl1) - 1 do
    begin
      HeaderSection := Sections.Add;
      HeaderSection.Text := ExColTitlesLvl1[TExpiredColTypes(x)];
      HeaderSection.Width := ExColWidths[TExpiredColTypes(x)];
    end;

  end;

  SetHeaderMaxWidth(hdrEXGroupHeaders[GroupIn]); // rpk 5/22/2012
end;

procedure TfrmCoverSheet.CreateMOGroupData(GroupIn: Integer);
begin
  lstMOGroupBoxes[GroupIn] := TListBox.Create(self);
  with lstMOGroupBoxes[GroupIn] do
  begin
    //    GroupBoxIndexes[GroupIn].Add(lstMOGroupBoxes[GroupIn]);
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    Style := lbOwnerDrawVariable;
    OnDrawItem := lstMOGroupBoxesDoseDrawItem;
    OnMeasureItem := lstGroupBoxesMeasureItem;
    OnClick := lstGroupBoxesClick;
    OnMouseUp := lstGroupBoxesMouseUp;
    OnMouseDown := lstGroupBoxesMouseDown;
    OnMouseMove := lstGroupBoxesMouseMove;
    ShowHint := True;
    OnKeyDown := lstGroupBoxesKeyDown;
    OnKeyUp := lstGroupBoxesKeyUp;
    OnExit := lstGroupBoxesExit;
    OnEnter := lstGroupBoxesEnter;
    PopupMenu := PABarCoverSheet;
    OnContextPopup := lstGroupBoxesContextPopup;
    Parent := sbxCoverSheet;
    //    MedOverViewItemIndex[TMedOverviewGroups(GroupIn)] := ItemIndex;
    Height := 0;
    Tag := GroupIn;
    //set top to a rediculous number so that they align properly in creation order.
    Top := 5000;
    Align := alTop;
    BuildMOGroup(lstMOGroupBoxes[GroupIn]);
  end;
end;

procedure TfrmCoverSheet.SetExpiredSectionCaptions;
begin
  ExGroupTitles[exExpired] := 'Expired/DC''d within last ' + cbxExpired.Text;
  ExGroupTitles[exExpiringTomorrow] := 'Expiring within next ' +
    cbxExpiring.Text + ' (after Midnight tonight)';
end;

procedure TfrmCoverSheet.SetHeaderMaxWidth(tempHeaderControl: THeaderControl);
const
  cminwidth = 30;
  clinwidth = 45;
  witnesswidth = 60;                    // rpk 7/17/2015
  nextactionwidth = 140;                // rpk 7/28/2015
var
  ii, minwid, TotalWidth, TempWidth: integer;
  clinicidx, witnessidx, nextactionidx: Integer;
begin
  TotalWidth := 0;
  clinicidx := -1;                      // rpk 11/26/2012
  witnessidx := -1;                     // rpk 7/17/2015
  nextactionidx := -1;                  // rpk 7/28/2015

  with tempHeaderControl.Sections do begin
    for ii := 0 to Count - 1 do begin
      // CQ 1330
      // rearranged code to set clinic column to 0 width in inpatient mode before
      // maxwidth calculations are done.
      case cbxView.ItemIndex of         // rpk 7/5/2012
        ord(csvMedOverview): begin
            clinicidx := ord(cClinicName);
            witnessidx := ord(cWitness); // rpk7/17/2015
            nextactionidx := ord(cNextAction); // rpk 7/28/2015
          end;
        ord(csvPRNAssessment): begin
            clinicidx := ord(ctPRNClinicName);
            witnessidx := ord(ctPRNWitness); // rpk7/17/2015
          end;
        ord(csvIVOverview): begin
            clinicidx := ord(ctIVClinicName);
            witnessidx := ord(ctIVWitness); // rpk7/17/2015
          end;
        ord(csvExpiringOrders): begin
            clinicidx := ord(ctExClinicName);
            witnessidx := ord(ctExWitness); // rpk7/17/2015
            nextactionidx := ord(ctExNextAction); // rpk 7/28/2015
          end;
      end;

      if (ii = clinicidx) and (OrderMode = omInpatient) then begin // rpk 6/20/2012
        items[ii].MinWidth := 0;
        items[ii].Width := 0;
      end;

      TempWidth := ((Count - (ii + 1)) * HdrMinWidth);
      items[ii].maxwidth := tempHeaderControl.width - (TempWidth +
        TotalWidth);
      TotalWidth := TotalWidth + Items[ii].Width;

      if ii = clinicidx then begin      // rpk 6/20/2012
        if OrderMode = omInpatient then begin
          minwid := 0;
        end
        else
          minwid := min(items[ii].MaxWidth, clinwidth)
      end
      else if ii = witnessidx then      // rpk 7/17/2015
        minwid := min(items[ii].MaxWidth, witnesswidth) // rpk 7/17/2015
      else if ii = nextactionidx then   // rpk 7/28/2015
        minwid := min(items[ii].MaxWidth, nextactionwidth) // rpk 7/28/2015
      else
        minwid := min(items[ii].MaxWidth, cminwidth);


      items[ii].MinWidth := minwid;
      if minwid = 0 then
//        items[ii].Width := 0
        items[ii].MaxWidth := 0
      // if minwidth = maxwidth, user cannot change column width;
      // allow user to change width of column
      else if items[ii].MinWidth = items[ii].MaxWidth then
        items[ii].MaxWidth := items[ii].MinWidth + 1;

    end;

  end;


  if (OrderMode = omInpatient) then begin // rpk 5/22/2012
    case cbxView.ItemIndex of
      ord(csvMedOverview): begin
          if tempHeaderControl.Sections.Items[ord(cClinicName)].minwidth <> 0 then
            tempHeaderControl.Sections.Items[ord(cClinicName)].minwidth := 0;
          if tempHeaderControl.Sections.Items[ord(cClinicName)].width <> 0 then
            tempHeaderControl.Sections.items[ord(cClinicName)].width := 0;
        end;

      ord(csvPRNAssessment): begin
          if tempHeaderControl.Sections.Items[ord(ctPRNClinicName)].minwidth <> 0 then
            tempHeaderControl.Sections.Items[ord(ctPRNClinicName)].minwidth := 0;
          if tempHeaderControl.Sections.Items[ord(ctPRNClinicName)].width <> 0 then
            tempHeaderControl.Sections.items[ord(ctPRNClinicName)].width := 0;
        end;

      ord(csvIVOverview): begin
          if tempHeaderControl.Sections.Items[ord(ctIVClinicName)].minwidth <> 0 then
            tempHeaderControl.Sections.Items[ord(ctIVClinicName)].minwidth := 0;
          if tempHeaderControl.Sections.Items[ord(ctIVClinicName)].width <> 0 then
            tempHeaderControl.Sections.items[ord(ctIVClinicName)].width := 0;
        end;

      ord(csvExpiringOrders): begin
          if tempHeaderControl.Sections.Items[ord(ctExClinicName)].minwidth <> 0 then
            tempHeaderControl.Sections.Items[ord(ctExClinicName)].minwidth := 0;
          if tempHeaderControl.Sections.Items[ord(ctExClinicName)].width <> 0 then
            tempHeaderControl.Sections.items[ord(ctExClinicName)].width := 0;
        end;

    end;                                // case cbxView.ItemIndex

  end;                                  // if (OrderMode = omInpatient)

end;                                    // SetHeaderMaxWidth

procedure TfrmCoverSheet.hdrCoversheetSectionResize(HeaderControl:
  THeaderControl;
  Section: THeaderSection);
var
  i, x: Integer;
begin
  HeaderControl.Sections.BeginUpdate;   // rpk 5/22/2012

  case cbxView.ItemIndex of
    0: begin                            // csvMedOverview
      { Patch 70:
      for x := 0 to length(hdrMOGroupHeaders) - 1 do
        begin
          MedOverviewColWidths[TMedOverviewColTypes(section.Index)] :=
            Section.Width;

        //set the new column width on the other headers on the coversheet
        //so all the headers are in sync.
          if HeaderControl <> hdrMOGroupHeaders[x] then
            hdrMOGroupHeaders[x].Sections[section.Index].Width :=
              MedOverviewColWidths[TMedOverviewColTypes(section.Index)];

          SetHeaderMaxWidth(hdrMoGroupHeaders[x]);
        end;

      end; }


        MedOverviewColWidths[TMedOverviewColTypes(section.Index)] :=
          Section.Width;
        for x := 0 to length(hdrMOGroupHeaders) - 1 do begin
//          MedOverviewColWidths[TMedOverviewColTypes(section.Index)] :=
//            Section.Width;
          if HeaderControl = hdrMOGroupHeaders[x] then begin // rpk 9/24/2015
            SetHeaderMaxWidth(hdrMoGroupHeaders[x]); // rpk 9/23/2015
            // after re-adjusting hdrMoGroupHeaders[x] column widths,
            // copy new column widths to MedOverviewColWidths for use in CreateMOGroupHeaders
            for I := 0 to hdrMOGroupHeaders[x].Sections.Count - 1 do
              MedOverviewColWidths[TMedOverviewColTypes(i)] := // rpk 9/24/2015
                hdrMOGroupHeaders[x].Sections[i].Width; // rpk 9/24/2015
          end;
        end;                            // for x

        for x := 0 to length(hdrMOGroupHeaders) - 1 do begin
          //set the new column width on the other headers on the coversheet
          //so all the headers are in sync.
          if HeaderControl <> hdrMOGroupHeaders[x] then
            hdrMOGroupHeaders[x].Sections[section.Index].Width :=
              MedOverviewColWidths[TMedOverviewColTypes(section.Index)];
        end;                            // for x
      end;                              // 0

    1: begin                            // csvPRNAssessment
        PRNAColWidths[TPRNColTypes(section.Index)] :=
          Section.Width;
        for x := 0 to length(hdrPRNGroupHeaders) - 1 do begin
//          PRNAColWidths[TPRNColTypes(section.Index)] :=
//            Section.Width;

          if HeaderControl = hdrPRNGroupHeaders[x] then begin // rpk 9/25/2015
            hdrPRNGroupHeaders[x].Sections[section.Index].Width :=
              Section.Width;
            SetHeaderMaxWidth(hdrPRNGroupHeaders[x]); // rpk 9/25/2015
            // after re-adjusting hdrMoGroupHeaders[x] column widths,
            // copy new column widths to MedOverviewColWidths for use in CreateMOGroupHeaders
            for I := 0 to hdrPRNGroupHeaders[x].Sections.Count - 1 do // rpk 9/25/2015
              PRNAColWidths[TPRNColTypes(i)] := // rpk 9/25/2015
                hdrPRNGroupHeaders[x].Sections[i].Width; // rpk 9/25/2015
          end;
        end;                            // for x

        for x := 0 to length(hdrPRNGroupHeaders) - 1 do begin
          //set the new column width on the other headers on the coversheet
          //so all the headers are in sync.
          if HeaderControl <> hdrPRNGroupHeaders[x] then
            hdrPRNGroupHeaders[x].Sections[section.Index].Width :=
              PRNAColWidths[TPRNColTypes(section.Index)];
        end;                            // for x
      end;                              // 1

    2: begin                            // csvIVOverview
        IVColWidths[TIVColTypes(section.Index)] :=
          Section.Width;
        for x := 0 to length(hdrIVGroupHeaders) - 1 do begin
//        IVColWidths[TIVColTypes(section.Index)] :=
//          Section.Width;

          if HeaderControl = hdrIVGroupHeaders[x] then begin // rpk 9/25/2015
            hdrIVGroupHeaders[x].Sections[section.Index].Width :=
              Section.Width;
            SetHeaderMaxWidth(hdrIVGroupHeaders[x]); // rpk 9/25/2015
            // after re-adjusting hdrMoGroupHeaders[x] column widths,
            // copy new column widths to MedOverviewColWidths for use in CreateMOGroupHeaders
            for I := 0 to hdrIVGroupHeaders[x].Sections.Count - 1 do
              IVColWidths[TIVColTypes(i)] := // rpk 9/25/2015
                hdrIVGroupHeaders[x].Sections[i].Width; // rpk 9/25/2015
          end;
        end;                            // for x

        for x := 0 to length(hdrIVGroupHeaders) - 1 do begin
          //set the new column width on the other headers on the coversheet
          //so all the headers are in sync.
          if HeaderControl <> hdrIVGroupHeaders[x] then
            hdrIVGroupHeaders[x].Sections[section.Index].Width :=
              IVColWidths[TIVColTypes(section.Index)];
        end;                            // for x
      end;                              // 2

    3: begin                            // csvExpiringOrders
        ExColWidths[TExpiredColTypes(section.Index)] :=
          Section.Width;
        for x := 0 to length(hdrExGroupHeaders) - 1 do begin
//          ExColWidths[TExpiredColTypes(section.Index)] :=
//            Section.Width;

          if HeaderControl = hdrExGroupHeaders[x] then begin // rpk 9/25/2015
            hdrExGroupHeaders[x].Sections[section.Index].Width :=
              Section.Width;
            SetHeaderMaxWidth(hdrExGroupHeaders[x]); // rpk 9/25/2015
            // after re-adjusting hdrMoGroupHeaders[x] column widths,
            // copy new column widths to MedOverviewColWidths for use in CreateMOGroupHeaders
            for I := 0 to hdrExGroupHeaders[x].Sections.Count - 1 do
              ExColWidths[TExpiredColTypes(i)] := // rpk 9/25/2015
                hdrExGroupHeaders[x].Sections[i].Width; // rpk 9/25/2015
          end;
        end;                            // for x

        for x := 0 to length(hdrExGroupHeaders) - 1 do begin
        //set the new column width on the other headers on the coversheet
        //so all the headers are in sync.
          if HeaderControl <> hdrExGroupHeaders[x] then
            hdrExGroupHeaders[x].Sections[section.Index].Width :=
              ExColWidths[TExpiredColTypes(section.Index)];
        end;                            // for x
      end;                              // 3

  end;                                  // case ItemIndex

  HeaderControl.Sections.EndUpdate;     // rpk 5/22/2012
end;                                    // hdrCoversheetSectionResize

procedure TfrmCoverSheet.hdrCoverSheetSectionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ii, jj: integer;
begin
  case cbxView.ItemIndex of
    0:
      for ii := 0 to Length(hdrMOGroupHeaders) - 1 do
      begin
        with hdrMOGroupHeaders[ii] do
        begin
          RedrawSuspend(Handle);
          for jj := 0 to Length(MedOverviewColTitles) - 1 do
            Sections[jj].Width :=
              MedOverviewColWidths[TMedOverViewColTypes(jj)];
          SetHeaderMaxWidth(hdrMoGroupHeaders[ii]);
          ReDrawActivate(Handle);
        end;
      end;
    1:
      for ii := 0 to Length(hdrPRNGroupHeaders) - 1 do
      begin
        with hdrPRNGroupHeaders[ii] do
        begin
          RedrawSuspend(Handle);
          for jj := 0 to Length(PRNAColTitlesLvl1) - 1 do
            Sections[jj].Width := PRNAColWidths[TPRNColTypes(jj)];
          SetHeaderMaxWidth(hdrPRNGroupHeaders[ii]);
          ReDrawActivate(Handle);
        end;
      end;
    2:
      for ii := 0 to Length(hdrIVGroupHeaders) - 1 do
      begin
        with hdrIVGroupHeaders[ii] do
        begin
          RedrawSuspend(Handle);
          for jj := 0 to Length(IVOColTitlesLvl1) - 1 do
            Sections[jj].Width := IVColWidths[TIVColTypes(jj)];
          SetHeaderMaxWidth(hdrIVGroupHeaders[ii]);
          ReDrawActivate(Handle);
        end;
      end;
    3:
      for ii := 0 to Length(hdrExGroupHeaders) - 1 do
      begin
        with hdrExGroupHeaders[ii] do
        begin
          RedrawSuspend(Handle);
          for jj := 0 to Length(ExColTitlesLvl1) - 1 do
            Sections[jj].Width := ExColWidths[TExpiredColTypes(jj)];
          SetHeaderMaxWidth(hdrExGroupHeaders[ii]);
          ReDrawActivate(Handle);
        end;
      end;
  end;
  SelectedItemIndex := -1;
  ReloadCoverSheet(False, True);
end;                                    // hdrCoverSheetSectionMouseUp

procedure TfrmCoverSheet.RebuildGroups;
var
  x: integer;
begin
  case cbxView.ItemIndex of
    0:
      begin
        for x := 0 to Length(MedOverviewGroupTitles) - 1 do
          if MedOverviewGrpExpanded[TMedOverviewGroups(x)] = 2 then
            BuildMOGroup(lstMOGroupBoxes[x]);
      end;
    1:
      begin
        for x := 0 to Length(PRNAGroupTitles) - 1 do
          if PRNAGrpExpanded[TPRNGroups(x)] = 2 then
            BuildPRNGroup(lstPRNGroupBoxes[x]);
      end;
    2:
      begin
        for x := 0 to Length(IVOGroupTitles) - 1 do
          if IVOGrpExpanded[TIVGroups(x)] = 2 then
            BuildIVGroup(lstIVGroupBoxes[x]);
      end;
  end;
end;

procedure TfrmCoverSheet.GroupImageClick(Sender: TObject);
begin
  with TImage(Sender) do
    case TCoverSheetViews(cbxView.ItemIndex) of
      csvMedOverview:
        begin
          if MedOverviewGrpExpanded[TMedOverviewGroups(tag)] = 0 then
            exit;
          if MedOverviewGrpExpanded[TMedOverviewGroups(tag)] = 2 then
          begin
            MedOverviewGrpExpanded[TMedOverviewGroups(tag)] := 1;
            ImageList1.Draw(TImage(Sender).Canvas, 0, 0, 1);
            Repaint;
            //lstMOGroupBoxes[tag].tag := lstMOGroupBoxes[tag].height;
            lstMOGroupBoxesHeight[tag] := lstMOGroupBoxes[tag].height;
            lstMOGroupBoxes[tag].height := 0;

            hdrMOGroupHeaders[tag].tag := hdrMOGroupHeaders[tag].height;
            hdrMOGroupHeaders[tag].height := 0;
          end
          else
          begin
            MedOverviewGrpExpanded[TMedOverviewGroups(tag)] := 2;
            ImageList1.Draw(Canvas, 0, 0, 0);
            Repaint;
            hdrMOGroupHeaders[tag].height := hdrMOGroupHeaders[tag].tag;
            //lstMOGroupBoxes[tag].height := lstMOGroupBoxes[tag].tag;
            lstMOGroupBoxes[tag].height := lstMOGroupBoxesHeight[tag];
          end;
          lstMOGroupBoxes[tag].TabStop := (lstMOGroupBoxes[tag].Height > 0);
        end;
      csvPRNAssessment:
        begin
          if PRNAGrpExpanded[TPRNGroups(tag)] = 0 then
            exit;
          if PRNAGrpExpanded[TPRNGroups(tag)] = 2 then
          begin
            PRNAGrpExpanded[TPRNGroups(tag)] := 1;
            ImageList1.Draw(TImage(Sender).Canvas, 0, 0, 1);
            Repaint;
            //lstPRNGroupBoxes[tag].tag := lstPRNGroupBoxes[tag].height;
            lstPRNGroupBoxesHeight[tag] := lstPRNGroupBoxes[tag].height;
            lstPRNGroupBoxes[tag].height := 0;

            hdrPRNGroupHeaders[tag].tag := hdrPRNGroupHeaders[tag].height;
            hdrPRNGroupHeaders[tag].height := 0;
          end
          else
          begin
            PRNAGrpExpanded[TPRNGroups(tag)] := 2;
            ImageList1.Draw(Canvas, 0, 0, 0);
            Repaint;
            hdrPRNGroupHeaders[tag].height := hdrPRNGroupHeaders[tag].tag;
            //            lstPRNGroupBoxes[tag].height := lstPRNGroupBoxes[tag].tag;
            lstPRNGroupBoxes[tag].height := lstPRNGroupBoxesHeight[tag];
          end;
          lstPRNGroupBoxes[tag].TabStop := (lstPRNGroupBoxes[tag].Height > 0);
        end;
      csvIVOverView:
        begin
          if IVOGrpExpanded[TIVGroups(tag)] = 0 then
            exit;
          if IVOGrpExpanded[TIVGroups(tag)] = 2 then
          begin
            IVOGrpExpanded[TIVGroups(tag)] := 1;
            ImageList1.Draw(TImage(Sender).Canvas, 0, 0, 1);
            Repaint;
            //lstIVGroupBoxes[tag].tag := lstIVGroupBoxes[tag].height;
            lstIVGroupBoxesHeight[tag] := lstIVGroupBoxes[tag].height;
            lstIVGroupBoxes[tag].Height := 0;

            hdrIVGroupHeaders[tag].tag := hdrIVGroupHeaders[tag].height;
            hdrIVgroupHeaders[tag].height := 0;
          end
          else
          begin
            IVOGrpExpanded[TIVGroups(tag)] := 2;
            ImageList1.Draw(Canvas, 0, 0, 0);
            Repaint;
            hdrIVGroupHeaders[tag].Height := hdrIVGroupHeaders[tag].tag;
            //lstIVGroupBoxes[tag].Height := lstIVGroupBoxes[tag].Tag;
            lstIVGroupBoxes[tag].Height := lstIVGroupBoxesHeight[tag];
          end;
          lstIVGroupBoxes[tag].TabStop := (lstIVGroupBoxes[tag].Height > 0);
        end;
      csvExpiringOrders:
        begin
          if ExGrpExpanded[TExpiredGroups(tag)] = 0 then
//          if ExGrpExpanded[TExpiredGroups(tag)] = ord(exExpired) then
            exit;
          if ExGrpExpanded[TExpiredGroups(tag)] = 2 then
//          if ExGrpExpanded[TExpiredGroups(tag)] = ord(exExpiringTomorrow) then
          begin
            ExGrpExpanded[TExpiredGroups(tag)] := 1;
//            ExGrpExpanded[TExpiredGroups(tag)] := ord(exExpiring);
            ImageList1.Draw(TImage(Sender).Canvas, 0, 0, 1);
            Repaint;
            //lstExGroupBoxes[tag].tag := lstExGroupBoxes[tag].height;
            lstExGroupBoxesHeight[tag] := lstExGroupBoxes[tag].height;
            lstExGroupBoxes[tag].height := 0;

            hdrExGroupHeaders[tag].tag := hdrExGroupHeaders[tag].height;
            hdrExGroupHeaders[tag].height := 0;
          end
          else
          begin
            ExGrpExpanded[TExpiredGroups(tag)] := 2;
//            ExGrpExpanded[TExpiredGroups(tag)] := ord(exExpiringTomorrow);
            ImageList1.Draw(Canvas, 0, 0, 0);
            Repaint;
            hdrExGroupHeaders[tag].height := hdrExGroupHeaders[tag].tag;
            //lstExGroupBoxes[tag].height := lstExGroupBoxes[tag].tag;
            lstExGroupBoxes[tag].height := lstExGroupBoxesHeight[tag];
          end;
          lstExGroupBoxes[tag].TabStop := (lstExGroupBoxes[tag].Height > 0);
        end;
    end;
end;

procedure TfrmCoverSheet.lstGroupBoxesMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
var
  TextString: string;
  CellHeight: Integer;
  ARect: TRect;
  //  RowIndex: integer;
  //  HeaderRow: Boolean;
  //  CSOrder: TCoverSheet_Order;
  //  sistr: String;
  //  bassn: Boolean;
begin
  if (Control as TListBox).Count = 0 then
    Exit;
  TextString := ' ';
  //  sistr := '';

  with (Control as TListBox) do
  begin
    ARect := ItemRect(Index);
    ARect.Left := 0;
    ARect.Top := 0;
    ARect.Bottom := 0;
    //    RowIndex := StrToInt(Piece(Items[index], '^', 1));
    //    HeaderRow := Piece(Items[index], '^', 3) = '1';
    //
    //    if (RowIndex = 1) and not HeaderRow then begin
    //      if Index > -1 then begin
    //         bassn := Assigned(Control);
    //         bassn := Assigned(Control As TListBox);
    //         bassn := Assigned(TCoverSheet_Order((Control as TListBox).Items[Index]));
    //         if TCoverSheet_Order((Control as TListBox).Items[Index]) <> nil then begin
    //            CSOrder := TCoverSheet_Order((Control as TListBox).Items[Index]);
    //            bassn := Assigned(CSOrder);
    //            if CSOrder <> nil then
    //               sistr := CSOrder.SpecialInstructions;
    //           if TCoverSheet_Order((Control as TListBox).Items.Objects[Index]) <> nil then begin
    //              with TCoverSheet_Order((Control as TListBox).Items.Objects[index]) do begin
    //                TextString := SpecialInstructions;
    //              end;
    //           end;
    //             TextString := sistr;
    //         end;
    //      end;
    //    end;
    //    CellHeight := DrawText(Canvas.Handle, PChar(TextString),
    //      Length(TextString),ARect,
    //      DT_END_ELLIPSIS or DT_NOPREFIX);
    CellHeight := DrawText(Canvas.Handle, PChar(TextString),
      Length(TextString), ARect,
      DT_CALCRECT or DT_END_ELLIPSIS or DT_NOPREFIX);
    //    CellHeight := DrawText(Canvas.Handle, PChar(TextString),
    //      Length(TextString), ARect,
    //      DT_CALCRECT or DT_WORD_ELLIPSIS or DT_NOPREFIX or
    //      DT_EDITCONTROL or DT_WORDBREAK);

    ARect.Left := 0;
    ARect.Top := 0;
    ARect.Bottom := 0;

  end;
  Height := CellHeight + 4;
  ///
  /// unnecessary ???
  ///
  (Control as TListBox).Height := (Control as TListBox).Height + Height;
end;

procedure TfrmCoverSheet.lstGroupBoxesClick(Sender: TObject);
begin
end;

procedure TfrmCoverSheet.pnlGroupClick(Sender: TObject);
var
  ii: integer;
begin
  case TCoverSheetViews(cbxView.ItemIndex) of
    csvMedOverview:
      for ii := 0 to Length(MedOverviewGroupTitles) - 1 do
        if Sender = pnlMOGroupPanels[ii] then
          GroupImageClick(imgMOGroupImages[ii]);
    csvPRNAssessment:
      for ii := 0 to Length(PRNAGroupTitles) - 1 do
        if Sender = pnlPRNGroupPanels[ii] then
          GroupImageClick(imgPRNGroupImages[ii]);
    csvIVOverView:
      for ii := 0 to Length(IVOGroupTitles) - 1 do
        if Sender = pnlIVGroupPanels[ii] then
          GroupImageClick(imgIVGroupImages[ii]);
    csvExpiringOrders:
      for ii := 0 to Length(ExGroupTitles) - 1 do
        if Sender = pnlExGroupPanels[ii] then
          GroupImageClick(imgExGroupImages[ii]);
  end;
end;

procedure TfrmCoverSheet.CreatePRNGroupData(GroupIn: Integer);
begin
  lstPRNGroupBoxes[GroupIn] := TListBox.Create(self);
  with lstPRNGroupBoxes[GroupIn] do
  begin
    //    GroupBoxIndexes[GroupIn].Add(lstPRNGroupBoxes[GroupIn]);
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    Style := lbOwnerDrawVariable;
    OnDrawItem := lstPRNGroupBoxesDoseDrawItem;
    OnMeasureItem := lstGroupBoxesMeasureItem;
    OnClick := lstGroupBoxesClick;
    OnMouseUp := lstGroupBoxesMouseUp;
    OnMouseDown := lstGroupBoxesMouseDown;
    OnMouseMove := lstGroupBoxesMouseMove;
    ShowHint := True;
    OnKeyDown := lstGroupBoxesKeyDown;
    OnKeyUp := lstGroupBoxesKeyUp;
    OnExit := lstGroupBoxesExit;
    OnEnter := lstGroupBoxesEnter;
    PopupMenu := PABarCoverSheet;
    OnContextPopup := lstGroupBoxesContextPopup;
    Parent := sbxCoverSheet;
    Height := 0;
    Tag := GroupIn;
    //set top to a rediculous number so that they align properly in creation order.
    Top := 5000;
    Align := alTop;
    BuildPRNGroup(lstPRNGroupBoxes[GroupIn]);
  end;
end;

procedure TfrmCoverSheet.CreateIVGroupData(GroupIn: Integer);
begin
  lstIVGroupBoxes[GroupIn] := TListBox.Create(self);
  with lstIVGroupBoxes[GroupIn] do
  begin
    //    GroupBoxIndexes[GroupIn].Add(lstIVGroupBoxes[GroupIn]);
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    Style := lbOwnerDrawVariable;
    OnDrawItem := lstIVGroupBoxesDoseDrawItem;
    OnMeasureItem := lstGroupBoxesMeasureItem;
    OnClick := lstGroupBoxesClick;
    OnMouseUp := lstGroupBoxesMouseUp;
    OnMouseDown := lstGroupBoxesMouseDown;
    OnMouseMove := lstGroupBoxesMouseMove;
    ShowHint := True;
    OnKeyDown := lstGroupBoxesKeyDown;
    OnKeyUp := lstGroupBoxesKeyUp;
    OnExit := lstGroupBoxesExit;
    OnEnter := lstGroupBoxesEnter;
    PopupMenu := PABarCoverSheet;
    OnContextPopup := lstGroupBoxesContextPopup;

    Parent := sbxCoverSheet;
    Height := 0;
    Tag := GroupIn;
    //set top to a rediculous number so that they align properly in creation order.
    Top := 5000;
    Align := alTop;
    BuildIVGroup(lstIVGroupBoxes[GroupIn]);
  end;
end;

procedure TfrmCoverSheet.CreateExGroupData(GroupIn: Integer);
begin
  lstExGroupBoxes[GroupIn] := TListBox.Create(self);
  with lstExGroupBoxes[GroupIn] do
  begin
    //    GroupBoxIndexes[GroupIn].Add(lstExGroupBoxes[GroupIn]);
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    Style := lbOwnerDrawVariable;
    OnDrawItem := lstExGroupBoxesDoseDrawItem;
    OnMeasureItem := lstGroupBoxesMeasureItem;
    OnClick := lstGroupBoxesClick;
    OnMouseUp := lstGroupBoxesMouseUp;
    OnMouseDown := lstGroupBoxesMouseDown;
    OnMouseMove := lstGroupBoxesMouseMove;
    ShowHint := True;
    OnKeyDown := lstGroupBoxesKeyDown;
    OnKeyUp := lstGroupBoxesKeyUp;
    OnExit := lstGroupBoxesExit;
    OnEnter := lstGroupBoxesEnter;
    PopupMenu := PABarCoverSheet;
    OnContextPopup := lstGroupBoxesContextPopup;
    Parent := sbxCoverSheet;
    Height := 0;
    Tag := GroupIn;
    //set top to a ridiculous number so that they align properly in creation order.
    Top := 5000;
    Align := alTop;
    BuildExGroup(lstExGroupBoxes[GroupIn]);
  end;
end;

procedure TfrmCoverSheet.lstMOGroupBoxesDoseDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x,
    ii,
    CellRight,
    TitleCount,
    RowIndex: integer;
  TextString,
    MouseOverText: string;
  ARect,
    TempARect: TRect;
  //  zSpecialInstructions: string;
  outText: string;
  HeaderRow: Boolean;
  BrushColor: TColor;
  CurrentFontColor: TColor;
  OvrRect: TRect;                       // rpk 1/14/2011

{$IFDEF CAS_DDPE_RST}
  iRR: Integer;
  CSOrder: TCoverSheet_Order;
  csadmin: TCoverSheet_Admin;
{$ENDIF}
begin
  with Control as TListBox do
  begin
    ARect := Rect;
    CurrentFontColor := Canvas.Font.Color; // rpk 5/25/2011
    if odd(StrToInt(piece((Control as TListBox).Items[index], '^', 2))) then
      Canvas.Brush.Color := RGB(245, 245, 220)
    else
      Canvas.Brush.Color := clCream;

    with Canvas do
    begin
      if odSelected in State then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
      end;

      FillRect(ARect);
      BrushColor := Canvas.Brush.Color;

      if (Piece((Control as TListBox).Items[index], '^', 1) = '1') and
        chkGridLines.Checked then
      begin
        Pen.Color := clSilver;
        MoveTo(ARect.Left, ARect.Top - 1);
        LineTo(ARect.Right, ARect.Top - 1);
      end;
    end;

    CellRight := -3;
    RowIndex := StrToInt(Piece((Control as TListBox).Items[index], '^', 1));
    HeaderRow := Piece((Control as TListBox).Items[index], '^', 3) = '1';
    TitleCount := Length(MedOverviewColTitles);

    if (RowIndex <> 0) and chkGridLines.Checked then
      with Canvas do
        for x := 0 to TitleCount - 1 do
        begin
          Pen.Color := clSilver;
          CellRight := CellRight + hdrMOGroupHeaders[0].Sections[x].Width;
          MoveTo(CellRight + 1, ARect.Bottom - 1);
          LineTo(CellRight + 1, ARect.Top);
        end;

    for x := 0 to TitleCount - 1 do
    begin
      if x > 0 then
        ARect.Left := ARect.Right + 2
      else
        ARect.Left := 2;

      ARect.Right := ARect.Left + hdrMOGroupHeaders[0].Sections[x].Width - 6;

      TextString := '';
      OutText := '';
      MouseOverText := '';              // rpk 9/11/2012
      //level 1 data
      if (RowIndex = 1) and not HeaderRow then
        with TCoverSheet_Order((Control as TListBox).Items.Objects[index]) do
          case x of
//            0:
            ord(ctNoActionTaken):       // rpk 2/4/2011
              begin
                if AdministrationsWithAction.Count > 0 then
                  if Expanded = 2 then
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Left -
                      2, ARect.Top, 0)  // -
                  else
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Left -
                      2, ARect.Top, 1); // +

                TempARect := ARect;
                TempARect.Left := TempARect.Left + 15;
                if NoActionTaken then
                begin
                  ImageList1.Draw((Control as TListBox).Canvas, TempARect.Left -
                    2, ARect.Top, 3);
                  MouseOverText := CSMouseOverTextNoAction;
                end;
              end;
//            1:
            ord(ctStat):                // rpk 2/4/2011
              if Stat then
              begin
                ImageList1.Draw((Control as TListBox).Canvas, ARect.Left - 2,
                  ARect.Top, 4);
                MouseOverText := CSMouseOverTextStat;
              end;
//            2:
            ord(ctFlag):                // rpk 2/4/2011
              if Flagged then
              begin
                Canvas.Brush.Color := clRed;
                TempARect := ARect;
                TempARect.Left := TempARect.Left - 3;
                TempARect.Right := TempARect.Right + 2;
                Canvas.FillRect(TempARect);
                Canvas.Brush.Color := BrushColor;
                //ImageList1.Draw((Control as TListBox).Canvas, ARect.Left - 2, ARect.Top, 2);
                MouseOverText := CSMouseOverTextOrderFlag;
              end;

            ord(cClinicName):           // rpk 5/14/2012
              OutText := ClinicName;

//            3:
            ord(ctTAB):                 // rpk 2/4/2011
              OutText := VDLTabText[StrToInt(VDLTab)];

//            4:
            ord(cStatus):               // rpk 2/4/2011
              OutText := GetOrderStatus(OrderStatus);

            ord(cVerifyNurse): begin    // rpk 2/4/2011
                if OvrIntvent then begin
                  OvrRect := aRect;
              // adjust sides to fill to edge of cell.
                  OvrRect.Left := OvrRect.Left - 2;
                  OvrRect.Right := OvrRect.Right + 1;
                  OvrRect.Bottom := OvrRect.Bottom - 1;

                  with Canvas do begin
                    Brush.Color := $00FFFF; // bright yellow
                    Font.Color := clWindowText;
                    Brush.Style := bsSolid;
                    FillRect(OvrRect);
                  end;                  // with Canvas

                  MouseOverText := CSMouseOverTextOvrIntvent; // rpk 5/18/2011
                end;                    // if OvrIntvent

                if VerifyNurse = '***' then begin
                  Canvas.Font.Style := [fsBold];
                end;

                OutText := VerifyNurse; // rpk 2/4/2011
              end;
//            5:
            ord(cType):                 // rpk 2/4/2011
              OutText := ScheduleType;

            ord(cWitness):
//              if WitnessFlag = WITNESS_REQUIRED then begin // rpk 9/11/2012
//                ImageList1.Draw(Canvas, ARect.Left - 2, ARect.Top, CSWITNESS_IDX);
{$IFDEF CAS_DDPE_RST}
              begin
                MouseOverText := '';
                if WitnessFlag >= WITNESS_RECOMMENDED then begin
                  ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, CSWITNESS_IDX);
                  MouseOverText := CSMouseOverTextWitness;
                end;
                CSOrder := TCoverSheet_Order((Control as TListBox).Items.Objects[index]);
//                if (CSOrder.getLastOrderAction = 'G')
//                  and (CSOrder.RemovalStatus<>'') and (CSOrder.RemovalStatus<>'0') // aan v. 3.0.083.17
                if CSOrder.AdministrationsWithAction.Count > 0 then
                  csadmin := TCoverSheet_Admin(AllAdmins[AllAdmins.count - 1]);
                if (CSOrder.ScanStatus = 'G') and
//                if (CSOrder.LastActivityStatus = 'G') and
                (CSOrder.RemovalStatus <> '') and
                  (CSOrder.RemovalStatus <> '0') then // rpk 7/17/2015
                begin
                  iRR := frmMain.CAS_Icon;
                  frmMain.ilCAS_DDPE.Draw(Canvas, ARect.Left + 5 + 28, ARect.Top, iRR);
                  if MouseOverText <> '' then
                    MouseOverText := MouseOverText + #13#10#13#10;
                  MouseOverText := MouseOverText + CSRequiresRemoval;
                  // getRemovableOrderHint(TCoverSheet_Order((Control as TListBox).Items.Objects[index]));
                end;
              end;
{$ELSE}
              if WitnessFlag >= WITNESS_RECOMMENDED then begin // rpk 10/23/2012
                ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, CSWITNESS_IDX); // rpk 9/17/2012
                MouseOverText := CSMouseOverTextWitness; // rpk 9/11/2012
              end;
{$ENDIF}
//            6:
            ord(cMedication):
              OutText := ActiveMedication;
//            7:
//            ord(cSchedule): // rpk 2/4/2011
//              OutText := Schedule;
//            8:
            ord(cDosage):               // rpk 2/4/2011
              OutText := Trim(Dosage) + ', ' + Route;

            ord(cSchedule):             // rpk 11/14/2012
              OutText := Schedule;
//            9:
            ord(cNextAction):           // rpk 2/4/2011
              OutText := NextAdminDateTime;
//            10:
            ord(cSpecialInstructions):  // rpk 2/4/2011
              begin
                //              OutText := SpecialInstructions;
//                OutText := TrimSpecInstr(SpecialInstructions);
                OutText := GetSIOPIText; // rpk 1/4/2012
                OutText := TrimSpecInstr(OutText); // rpk 1/4/2012
              end;
{$IFDEF CAS_DDPE_RST}                   // Removed on 2015-05-07
(*
            ord(cRequiresRemoval):
              if IsRemovalRequiredByStatus(ScanStatus) then
              begin // rpk 10/23/2012
//                iRR := getRRStatus(TCoverSheet_Order((Control as TListBox).Items.Objects[index]));
                iRR := frmMain.CAS_Icon;
                frmMain.ilCAS_DDPE.Draw(Canvas, ARect.Left + 5, ARect.Top,iRR);
                MouseOverText := getRemovableStatusHint(iRR);
              end;
*)
{$ENDIF}
//            11:
            ord(csStartDate):           // rpk 2/4/2011
              OutText := DisplayVADate(StartDateTime);
//            12:
            ord(cStopDate):             // rpk 2/4/2011
              OutText := DisplayVADate(StopDateTime);
          end

            //level 2 header
      else if (RowIndex = 2) and HeaderRow then
      begin
        if TCoverSheet_Order((Control as
          TListBox).Items.Objects[index]).OrderType = 'V' then
//          ii := 5
//          ii := ord(cType) // rpk 11/14/2012
          ii := ord(cWitness)           // rpk 11/27/2012
        else
//          ii := 6;
          ii := ord(cMedication);       // rpk 11/14/2012

        if x > ii then
        begin
          TempARect := ARect;
          TempARect.Left := TempARect.Left - 3;

          with Canvas do
            if not (odSelected in State) then
            begin
              Canvas.Brush.Color := clBtnFace;
              Canvas.FillRect(TempARect);
            end;
        end;

        case x of
//          0..5:
          ord(ctNoActionTaken)..ord(cWitness): // rpk 11/14/2012
            OutText := '';
          // 6:
          ord(cMedication):             // rpk 11/14/2012
            if TCoverSheet_Order((Control as
              TListBox).Items.Objects[index]).OrderType = 'V' then
//              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(0)];
              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(ctBagID))]; // rpk 11/14/2012
          // 7:
          ord(cDosage):                 // rpk 11/14/2012
//            OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(1)];
            OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(cActionBy))]; // rpk 11/14/2012
          // 8:
          ord(cSchedule):               // rpk 11/14/2012
//            OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(2)];
            OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(cAction))]; // rpk 11/14/2012
          // 9:
          ord(cNextAction):             // rpk 11/14/2012
            if TCoverSheet_Order((Control as
              TListBox).Items.Objects[index]).ScheduleType = 'P' then
//              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(3)];
              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(cPRNReason))]; // rpk 11/14/2012
          // 10:
          ord(cSpecialInstructions):    // rpk 11/14/2012
            if TCoverSheet_Order((Control as
              TListBox).Items.Objects[index]).ScheduleType = 'P' then
//              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(4)];
              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(cPRNEffectiveness))]; // rpk 11/14/2012
          // 11..12:
          ord(csStartDate)..ord(cStopDate): // rpk 11/14/2012
            OutText := '';
        end;
      end

        //level 2 Data
      else if (RowIndex = 2) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Admin((Control as TListBox).Items.Objects[index]) do
        begin
          case x of
//            0..4:
            ord(ctNoActionTaken)..ord(cType): // rpk 11/14/2012
              OutText := '';
//            5:
            ord(cWitness):              // rpk 11/14/2012
              begin
                if (Comments.Count > 0) and (BagID <> '') then
                  if Expanded = 2 then
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                      15, ARect.Top, 0)
                  else
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                      15, ARect.Top, 1);
              end;
//            6:
            ord(cMedication):           // rpk 11/14/2012
              if BagID <> '' then
                OutText := BagID
              else if Comments.Count > 0 then
                if Expanded = 2 then
                  ImageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                    15, ARect.Top, 0)
                else
                  imageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                    15, ARect.Top, 1);

//            7:
            ord(cDosage):               // rpk 11/14/2012
              OutText := ActionByInitials + ' ' + DisplayVADate(ActionDateTime);
            // 8:
            ord(cSchedule):             // rpk 11/14/2012
              OutText := GetLastActivityStatus(Action);
            // 9:
            ord(cNextAction):           // rpk 11/14/2012
              OutText := PRNReason;
            // 10:
            ord(cSpecialInstructions):  // rpk 11/14/2012
              OutText := PRNEffectComment;
            // 11..12:
            ord(csStartDate)..ord(cStopDate): // rpk 11/14/2012
              OutText := '';
          end;
        end
      //level 3 Header
      else if (RowIndex = 3) and HeaderRow then
      begin
//        if x > 8 then
        if x > ord(cSchedule) then      // rpk 11/27/2012
        begin
          TempARect := ARect;
          TempARect.Left := TempARect.Left - 3;
          with Canvas do
            if not (odSelected in State) then
            begin
              Brush.Color := clBtnFace;
              FillRect(TempARect);
            end;
        end;
        case x of
          // 0..8:
          ord(ctNoActionTaken)..ord(cSchedule): // rpk 11/15/2012
            OutText := '';
          // 9:
          ord(cNextAction):             // rpk 11/15/2012
//            OutText := MedOverviewColTitleslvl3[TMedOverviewColTypeslvl3(0)];
            OutText := MedOverviewColTitleslvl3[TMedOverviewColTypeslvl3(ord(cCommentBy))]; // rpk 11/15/2012
          // 10:
          ord(cSpecialInstructions):    // rpk 11/15/2012
//            OutText := MedOverviewColTitleslvl3[TMedOverviewColTypeslvl3(1)];
            OutText := MedOverviewColTitleslvl3[TMedOverviewColTypeslvl3(ord(cComment))]; // rpk 11/15/2012
          // 11..12:
          ord(csStartDate)..ord(cStopDate): // rpk 11/15/2012
            OutText := '';
        end;
      end
      //level 3 Data
      else if (RowIndex = 3) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Comment((Control as TListBox).Items.Objects[index]) do
        begin
          case x of
            // 0..8:
            ord(ctNoActionTaken)..ord(cSchedule): // rpk 11/15/2012
              OutText := '';
//            9:
            ord(cNextAction):           // rpk 11/15/2012
              OutText := ActionByInitials + ' ' + DisplayVADate(ActionDateTime);
//            10:
            ord(cSpecialInstructions):  // rpk 11/15/2012
              OutText := Comment;
//            11..12:
            ord(csStartDate)..ord(cStopDate): // rpk 11/15/2012
              OutText := '';
          end;
        end;

      if MouseOverText = '' then
        grdCellData[(Control as TlistBox).Tag].Cells[x, Index] := OutText
      else
        grdCellData[(Control as TlistBox).Tag].Cells[x, Index] := MouseOverText;

      if ((RowIndex = 1) and (x = 0)) then
        //do nothing
      else
        //        DrawText(Canvas.Handle, PChar(OutText), Length(OutText),
        //        ARect, DT_END_ELLIPSIS or DT_NOPREFIX);
        //        DrawText(Canvas.Handle, PChar(OutText), Length(OutText),
        //        ARect, DT_WORD_ELLIPSIS or DT_NOPREFIX or DT_EDITCONTROL);
        DrawText(Canvas.Handle, PChar(OutText), Length(OutText), ARect,
          //        DT_END_ELLIPSIS or DT_NOPREFIX or DT_WORDBREAK or DT_EDITCONTROL);
          DT_SINGLELINE or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS);
            // rpk 4/29/2009
      //Canvas.Font.Color := CurrentFontColor;
      ARect.Right := ARect.Right + 4;
      MouseOverText := '';
      Canvas.Brush.Color := BrushColor; // rpk 2/4/2011
      Canvas.Font.Color := CurrentFontColor;
      Canvas.Font.Style := [];          // rpk 2/4/2011
    end;
  end;
end;                                    // lstMOGroupBoxesDoseDrawItem

procedure TfrmCoverSheet.lstPRNGroupBoxesDoseDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x,
    ii,
    CellRight,
    TitleCount,
    RowIndex: integer;
  TextString,
    MouseOverText: string;
  ARect,
    TempARect: TRect;
  //  zSpecialInstructions: string;
  outText: string;
  HeaderRow: Boolean;
  BrushColor: TColor;
  CurrentFontColor: TColor;             // rpk 5/25/2011
  OvrRect: TRect;                       // rpk 1/14/2011
begin
  with Control as TListBox do
  begin
    ARect := Rect;
    CurrentFontColor := Canvas.Font.Color; // rpk 5/25/2011
    with Canvas do
    begin
      if odd(StrToInt(piece((Control as TListBox).Items[index], '^', 2))) then
        Brush.Color := RGB(245, 245, 220)
      else
        Brush.Color := clCream;

      if odSelected in State then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
      end;
      FillRect(ARect);

      BrushColor := Canvas.Brush.Color;

      if (Piece((Control as TListBox).Items[index], '^', 1) = '1') and
        chkGridLines.Checked then
      begin
        Pen.Color := clSilver;
        MoveTo(ARect.Left, ARect.Top - 1);
        LineTo(ARect.Right, ARect.Top - 1);
      end;
    end;

    CellRight := -3;
    TitleCount := Length(PRNAColTitlesLvl1);
    RowIndex := StrToInt(Piece((Control as TListBox).Items[index], '^', 1));
    HeaderRow := Piece((Control as TListBox).Items[index], '^', 3) = '1';

    if (RowIndex <> 0) and chkGridLines.Checked then
      with Canvas do
        for x := 0 to TitleCount - 1 do
        begin
          Pen.Color := clSilver;
          CellRight := CellRight + hdrPRNGroupHeaders[0].Sections[x].Width;
          MoveTo(CellRight + 1, ARect.Bottom - 1);
          LineTo(CellRight + 1, ARect.Top);
        end;

    for x := 0 to TitleCount - 1 do
    begin
      if x > 0 then
        ARect.Left := ARect.Right + 2
      else
        ARect.Left := 2;

      ARect.Right := ARect.Left + hdrPRNGroupHeaders[0].Sections[x].Width - 6;

      TextString := '';
      OutText := '';
      //level 1 data
      if (RowIndex = 1) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Order((Control as TListBox).Items.Objects[index]) do
          case x of
//            0:
            ord(ctPRNStat):             // rpk 2/4/2011
              begin
                if AdministrationsWithAction.Count > 0 then
                  if Expanded = 2 then
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Left -
                      2, ARect.Top, 0)
                  else
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Left -
                      2, ARect.Top, 1);

                TempARect := ARect;
                TempARect.Left := TempARect.Left + 15;
                if Stat then
                begin
                  ImageList1.Draw((Control as TListBox).Canvas, TempARect.Left -
                    2, ARect.Top, 4);
                  MouseOverText := CSMouseOverTextStat;
                end;
              end;
//            1:
            ord(ctPRNFlag):             // rpk 2/4/2011
              if Flagged then
              begin
                Canvas.Brush.Color := clRed;
                TempARect := ARect;
                TempARect.Left := TempARect.Left - 3;
                TempARect.Right := TempARect.Right + 2;
                Canvas.FillRect(TempARect);
                Canvas.Brush.Color := BrushColor;
                //ImageList1.Draw((Control as TListBox).Canvas, ARect.Left - 2, ARect.Top, 2);
                MouseOverText := CSMouseoverTextOrderFlag;
              end;

            ord(ctPRNClinicName):       // rpk 5/14/2012
              OutText := ClinicName;

//            2:
            ord(ctPRNTab):              // rpk 2/4/2011
              OutText := VDLTabText[StrToInt(VDLTab)];
//            3:
            ord(ctPRNStatus):           // rpk 2/4/2011
              OutText := GetOrderStatus(OrderStatus);
            ord(ctPRNVerifyNurse): begin // rpk 2/4/2011
                if OvrIntvent then begin
                  OvrRect := aRect;
              // adjust sides to fill to edge of cell.
                  OvrRect.Left := OvrRect.Left - 2;
                  OvrRect.Right := OvrRect.Right + 1;
                  OvrRect.Bottom := OvrRect.Bottom - 1;

                  with Canvas do begin
                    Brush.Color := $00FFFF; // bright yellow
                    Font.Color := clWindowText;
                    Brush.Style := bsSolid;
                    FillRect(OvrRect);
                  end;                  // with Canvas

                  MouseOverText := CSMouseOverTextOvrIntvent; // rpk 5/18/2011
                end;                    // if OvrIntvent

                if VerifyNurse = '***' then begin
                  Canvas.Font.Style := [fsBold];
                end;

                OutText := VerifyNurse; // rpk 2/4/2011
              end;

            ord(ctPRNWitness):          // rpk 9/11/2012
//              if WitnessFlag = WITNESS_REQUIRED then begin
//                ImageList1.Draw(Canvas, ARect.Left - 2, ARect.Top, CSWITNESS_IDX);
              if WitnessFlag >= WITNESS_RECOMMENDED then begin // rpk 10/23/2012
                ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, CSWITNESS_IDX); // rpk 9/17/2012
                MouseOverText := CSMouseOverTextWitness; // rpk 9/11/2012
              end;

//            4:
            ord(ctPRNMedication):       // rpk 2/4/2011
              OutText := ActiveMedication;
//            5:
//            ord(ctPRNSchedule): // rpk 2/4/2011
//              OutText := Schedule;
//            6:
            ord(ctPRNDosage):           // rpk 2/4/2011
              OutText := Trim(Dosage) + ', ' + Route;

            ord(ctPRNSchedule):         // rpk 11/14/2012
              OutText := Schedule;
//            7:
            ord(ctPRNLastGiven):        // rpk 2/4/2011
              if TimeLastGiven = '' then
                OutText := ''
              else
                OutText := DisplayVADateYearTime(TimeLastGiven);
//            8:
            ord(ctPRNSinceLast):        // rpk 2/4/2011
              OutText := SinceLast;
//            9:
            ord(ctPRNSpecialInstructions): // rpk 2/4/2011
              begin
                //              OutText := SpecialInstructions;
//                OutText := TrimSpecInstr(SpecialInstructions);
                OutText := GetSIOPIText; // rpk 1/4/2012
                OutText := TrimSpecInstr(OutText); // rpk 1/4/2012
              end;
//            10:
            ord(ctPRNStartDate):        // rpk 2/4/2011
              OutText := DisplayVADate(StartDateTime);
//            11:
            ord(ctPRNStopDate):         // rpk 2/4/2011
              OutText := DisplayVADate(StopDateTime);
          end

            //level 2 header
      else if (RowIndex = 2) and HeaderRow then
      begin
        if TCoverSheet_Order((Control as
          TListBox).Items.Objects[index]).OrderType = 'V' then
          // ii := 3
          ii := ord(ctPRNWitness)       // rpk 11/15/2012
        else
          // ii := 4;
          ii := ord(ctPRNMedication);   // rpk 11/15/2012

        if x > ii then
        begin
          TempARect := ARect;
          TempARect.Left := TempARect.Left - 3;
          with Canvas do
            if not (odSelected in State) then
            begin
              Brush.Color := clBtnFace;
              FillRect(TempARect);
            end;
        end;
        case x of
          // 0..3:
          ord(ctPRNStat)..ord(ctPRNWitness): // rpk 11/15/2012
            OutText := '';
          // 4:
          ord(ctPRNMedication):         // rpk 11/15/2012
            if TCoverSheet_Order((Control as
              TListBox).Items.Objects[index]).OrderType = 'V' then
//              OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(0)];
              OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(ord(cPRNBagID))]; // rpk 11/15/2012
          // 5:
          ord(ctPRNDosage):             // rpk 11/15/2012
//            OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(1)];
            OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(ord(cPRNActionBy))]; // rpk 11/15/2012
          // 6:
          ord(ctPRNSchedule):           // rpk 11/15/2012
//            OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(2)];
            OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(ord(cPRNAction))]; // rpk 11/15/2012
          // 7:
          ord(ctPRNLastGiven):          // rpk 11/15/2012
            if TCoverSheet_Order((Control as
              TListBox).Items.Objects[index]).ScheduleType = 'P' then
//              OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(3)];
              OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(ord(cPRNPRNReason))]; // rpk 11/15/2012
          // 8:
          ord(ctPRNSinceLast):          // rpk 11/15/2012
            if TCoverSheet_Order((Control as
              TListBox).Items.Objects[index]).ScheduleType = 'P' then
//              OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(4)];
              OutText := PRNAColTitleslvl2[TPRNColTypeslvl2(ord(cPRNPRNEffectiveness))]; // rpk 11/15/2012
          // 9..11:
          ord(ctPRNSpecialInstructions)..ord(ctPRNStopDate): // rpk 11/15/2012
            OutText := '';
        end;
      end

        //level 2 Data
      else if (RowIndex = 2) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Admin((Control as TListBox).Items.Objects[index]) do
        begin
          case x of
            // 0..2:
            ord(ctPRNStat)..ord(ctPRNVerifyNurse): // rpk 11/15/2012
              OutText := '';
            // 3:
            ord(ctPRNWitness):          // rpk 11/15/2012
              begin
                if (Comments.Count > 0) and (BagID <> '') then
                  if Expanded = 2 then
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                      15, ARect.Top, 0)
                  else
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                      15, ARect.Top, 1);

                // if Comments.Count > 0 then
                //   if Expanded = 2 then
                 //    ImageList1.Draw((Control as TListBox).Canvas, ARect.Right - 15, ARect.Top, 0)
                 //  else
                 //    ImageList1.Draw((Control as TListBox).Canvas, ARect.Right - 15, ARect.Top, 1);
              end;
            // 4:
            ord(ctPRNMedication):       // rpk 11/15/2012
              if BagID <> '' then
                OutText := BagID
              else if Comments.Count > 0 then
                if Expanded = 2 then
                  ImageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                    15, ARect.Top, 0)
                else
                  imageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                    15, ARect.Top, 1);
            // 5:
            ord(ctPRNDosage):           // rpk 11/15/2012
              OutText := ActionByInitials + ' ' + DisplayVADate(ActionDateTime);
            // 6:
            ord(ctPRNSchedule):         // rpk 11/15/2012
              OutText := GetLastActivityStatus(Action);
            // 7:
            ord(ctPRNLastGiven):        // rpk 11/15/2012
              OutText := PRNReason;
            // 8:
            ord(ctPRNSinceLast):        // rpk 11/15/2012
              OutText := PRNEffectComment;
            // 9..11:
            ord(ctPRNSpecialInstructions)..ord(ctPRNStopDate): // rpk 11/15/2012
              OutText := '';
          end;
        end
          //level 3 Header
      else if (RowIndex = 3) and HeaderRow then
      begin
//        if x > 7 then
        if x > ord(ctPRNLastGiven) then // rpk 11/15/2012
        begin
          TempARect := ARect;
          TempARect.Left := TempARect.Left - 3;
          with Canvas do
            if not (odSelected in State) then
            begin
              Brush.Color := clBtnFace;
              FillRect(TempARect);
            end;
        end;
        case x of
          // 0..7:
          ord(ctPRNStat)..ord(ctPRNLastGiven): // rpk 11/15/2012
            OutText := '';
          // 8:
          ord(ctPRNSinceLast):          // rpk 11/15/2012
//            OutText := PRNAColTitleslvl3[TPRNColTypeslvl3(0)];
            OutText := PRNAColTitleslvl3[TPRNColTypeslvl3(ord(cPRNCommentBy))]; // rpk 11/15/2012
          // 9:
          ord(ctPRNSpecialInstructions): // rpk 11/15/2012
//            OutText := PRNAColTitleslvl3[TPRNColTypeslvl3(1)];
            OutText := PRNAColTitleslvl3[TPRNColTypeslvl3(ord(cPRNComment))]; // rpk 11/15/2012
          // 10..11:
          ord(ctPRNStartDate)..ord(ctPRNStopDate): // rpk 11/15/2012
            OutText := '';
        end;
      end
        //level 3 Data
      else if (RowIndex = 3) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Comment((Control as TListBox).Items.Objects[index]) do
        begin
          case x of
            // 0..7:
            ord(ctPRNStat)..ord(ctPRNLastGiven): // rpk 11/15/2012
              OutText := '';
            // 8:
            ord(ctPRNSinceLast):        // rpk 11/15/2012
              OutText := ActionByInitials + ' ' + DisplayVADate(ActionDateTime);
            // 9:
            ord(ctPRNSpecialInstructions): // rpk 11/15/2012
              OutText := Comment;
            // 10..11:
            ord(ctPRNStartDate)..ord(ctPRNStopDate): // rpk 11/15/2012
              OutText := '';
          end;
        end;
      if MouseOverText = '' then
        grdCellData[(Control as TlistBox).Tag].Cells[x, Index] := OutText
      else
        grdCellData[(Control as TlistBox).Tag].Cells[x, Index] := MouseOverText;

      if ((RowIndex = 1) and (x = 0)) then
        //do nothing
      else
        //        DrawText(Canvas.Handle, PChar(OutText), Length(OutText),
        //        ARect, DT_END_ELLIPSIS or DT_NOPREFIX);
        //        DrawText(Canvas.Handle, PChar(OutText), Length(OutText),
        //        ARect, DT_WORD_ELLIPSIS or DT_NOPREFIX or DT_EDITCONTROL);
        DrawText(Canvas.Handle, PChar(OutText), Length(OutText), ARect,
          DT_SINGLELINE or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS);
            // rpk 4/29/2009
      ARect.Right := ARect.Right + 4;
      MouseOverText := '';
      Canvas.Brush.Color := BrushColor; // rpk 2/4/2011
      Canvas.Font.Color := CurrentFontColor; // rpk 5/25/2011
      Canvas.Font.Style := [];          // rpk 2/4/2011
    end;
  end;
end;                                    // lstPRNGroupBoxesDoseDrawItem

procedure TfrmCoverSheet.lstIVGroupBoxesDoseDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x,
    CellRight,
    TitleCount,
    RowIndex: integer;
  TextString,
    MouseOverText: string;
  ARect,
    TempARect: TRect;
  zSpecialInstructions: string;
  outText: string;
  HeaderRow: Boolean;
  BrushColor: TColor;
  CurrentFontColor: TColor;             // rpk 5/25/2011
  OvrRect: TRect;
begin
  with Control as TListBox do
  begin
    ARect := Rect;
    CurrentFontColor := Canvas.Font.Color; // rpk 5/25/2011
    with Canvas do
    begin
      if odd(StrToInt(piece((Control as TListBox).Items[index], '^', 2))) then
        Brush.Color := RGB(245, 245, 220)
      else
        Brush.Color := clCream;

      if odSelected in State then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
      end;

      FillRect(ARect);
      BrushColor := Canvas.Brush.Color;

      if (Piece((Control as TListBox).Items[index], '^', 1) = '1') and
        chkGridLines.Checked then
      begin
        Pen.Color := clSilver;
        MoveTo(ARect.Left, ARect.Top - 1);
        LineTo(ARect.Right, ARect.Top - 1);
      end;
    end;

    CellRight := -3;
    RowIndex := StrToInt(Piece((Control as TListBox).Items[index], '^', 1));
    HeaderRow := Piece((Control as TListBox).Items[index], '^', 3) = '1';
    TitleCount := Length(IVOColTitlesLvl1);

    if (RowIndex <> 0) and chkGridLines.Checked then
      with Canvas do
        for x := 0 to TitleCount - 1 do
        begin
          Pen.Color := clSilver;
          CellRight := CellRight + hdrIVGroupHeaders[0].Sections[x].Width;
          MoveTo(CellRight + 1, ARect.Bottom - 1);
          LineTo(CellRight + 1, ARect.Top);
        end;

    for x := 0 to TitleCount - 1 do
    begin
      if x > 0 then
        ARect.Left := ARect.Right + 2
      else
        ARect.Left := 2;

      ARect.Right := ARect.Left + hdrIVGroupHeaders[0].Sections[x].Width - 6;

      TextString := '';
      OutText := '';
      //level 1 data
      if (RowIndex = 1) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        //with TCoverSheet_Order((Control as TListBox).Items.Objects[index]) do
        with TCoverSheet_Admin((Control as TListBox).Items.Objects[index]) do
          case x of
//            0:
            ord(ctIVNoActionTaken):     // rpk 2/4/2011
              begin
                if ((Action <> 'A') and (Action <> '')) then
                  if IVExpanded = 2 then
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Left -
                      2, ARect.Top, 0)
                  else
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Left -
                      2, ARect.Top, 1);
                TempARect := ARect;
                TempARect.Left := TempARect.Left + 15;

                if TCoverSheet_Order(Order).NoActionTaken then
                begin
                  ImageList1.Draw((Control as TListBox).Canvas, TempARect.Left -
                    2, ARect.Top, 3);
                  MouseOverText := CSMouseOverTextNoAction;
                end;
              end;

//            1:
            ord(ctIVStat):              // rpk 2/4/2011
              if TCoverSheet_Order(Order).Stat then
              begin
                ImageList1.Draw((Control as TListBox).Canvas, ARect.Left - 2,
                  ARect.Top, 4);
                MouseOverText := CSMouseOverTextStat;
              end;
//            2:
            ord(ctIVFlag):              // rpk 2/4/2011
              if TCoverSheet_Order(Order).Flagged then
              begin
                Canvas.Brush.Color := clRed;
                TempARect := ARect;
                TempARect.Left := TempARect.Left - 3;
                TempARect.Right := TempARect.Right + 2;
                Canvas.FillRect(TempARect);
                Canvas.Brush.Color := BrushColor;
                //ImageList1.Draw((Control as TListBox).Canvas, ARect.Left - 2, ARect.Top, 2);
                MouseOverText := CSMouseOvertextOrderFlag;
              end;

            ord(ctIVClinicName):        // rpk 5/14/2012
              OutText := TCoverSheet_Order(Order).ClinicName;

//            3:
            ord(ctIVBagID):             // rpk 2/4/2011
              OutText := BagID;
//            4:
            ord(ctIVOrderStatus):       // rpk 2/4/2011
              OutText := GetOrderStatus(TCoverSheet_Order(Order).OrderStatus);
//            5:
            ord(ctIVBagStatus):         // rpk 2/4/2011
              OutText := GetLastActivityStatus(Action);
            ord(ctIVVerifyNurse): begin // rpk 2/4/2011
                if TCoverSheet_Order(Order).OvrIntvent then begin
                  OvrRect := aRect;
              // adjust sides to fill to edge of cell.
                  OvrRect.Left := OvrRect.Left - 2;
                  OvrRect.Right := OvrRect.Right + 1;
                  OvrRect.Bottom := OvrRect.Bottom - 1;

                  with Canvas do begin
                    Brush.Color := $00FFFF; // bright yellow
                    Font.Color := clWindowText;
                    Brush.Style := bsSolid;
                    FillRect(OvrRect);
                  end;                  // with Canvas

                  MouseOverText := CSMouseOverTextOvrIntvent; // rpk 5/18/2011
                end;                    // if OvrIntvent

                if TCoverSheet_Order(Order).VerifyNurse = '***' then begin
                  Canvas.Font.Style := [fsBold];
                end;

                OutText := TCoverSheet_Order(Order).VerifyNurse; // rpk 2/4/2011
              end;

            ord(ctIVWitness):
//              if TCoverSheet_Order(Order).WitnessFlag = WITNESS_REQUIRED then begin
//                ImageList1.Draw(Canvas, ARect.Left - 2, ARect.Top, CSWITNESS_IDX);
              if TCoverSheet_Order(Order).WitnessFlag >= WITNESS_RECOMMENDED then begin // rpk 10/23/2012
                ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, CSWITNESS_IDX); // rpk 9/17/2012
                MouseOverText := CSMouseOverTextWitness; // rpk 9/11/2012
              end;

//            6:
            ord(ctIVMedication):        // rpk 2/4/2011
              OutText := TCoverSheet_Order(Order).ActiveMedication;
//            7:
            ord(ctIVInfusionRate):      // rpk 2/4/2011
              OutText := TCoverSheet_Order(Order).Dosage;
//            8:
            ord(ctIVOtherPrintInfo):    // rpk 2/4/2011
              begin
                //              OutText := TCoverSheet_Order(Order).SpecialInstructions;
//                zSpecialInstructions :=
//                  TCoverSheet_Order(Order).SpecialInstructions;
//                OutText := TrimSpecInstr(zSpecialInstructions);
                zSpecialInstructions := TCoverSheet_Order(Order).GetSIOPIText; // rpk 1/4/2012
                OutText := TrimSpecInstr(zSpecialInstructions); // rpk 1/4/2012
              end;
//            9:
            ord(ctIVBagInfo):           // rpk 2/4/2011
              OutText := TCoverSheet_Order(Order).Changed;
//            10:
            ord(ctIVStartDate):         // rpk 2/4/2011
              OutText := DisplayVADate(TCoverSheet_Order(Order).StartDateTime);
//            11:
            ord(ctIVStopDate):          // rpk 2/4/2011
              OutText := DisplayVADate(TCoverSheet_Order(Order).StopDateTime);
          end

            //level 2 header
      else if (RowIndex = 2) and HeaderRow then
      begin
//        if x > 4 then
        if x > ord(ctIVOrderStatus) then // rpk 11/27/2012
        begin
          TempARect := ARect;
          TempARect.Left := TempARect.Left - 3;
          with Canvas do
            if not (odSelected in State) then
            begin
              Brush.Color := clBtnFace;
              FillRect(TempARect);
            end;
        end;

        case x of
//          0..4:
          ord(ctIVNoActionTaken)..ord(ctIVVerifyNurse): // rpk 11/27/2012
            OutText := '';
          // 5:
//            OutText := IVColTitleslvl2[TIVColTypeslvl2(0)];
          ord(ctIVWitness):             // rpk 11/27/2012
            OutText := IVColTitleslvl2[TIVColTypeslvl2(ord(ctIVActionDateTime))]; // rpk 11/27/2012
          // 6:
            // OutText := IVColTitleslvl2[TIVColTypeslvl2(1)];
          ord(ctIVMedication):          // rpk 11/27/2012
            OutText := IVColTitleslvl2[TIVColTypeslvl2(ord(ctIVActionBy))]; // rpk 11/27/2012
          // 7:
            // OutText := IVColTitleslvl2[TIVColTypeslvl2(2)];
          ord(ctIVInfusionRate):        // rpk 11/27/2012
            OutText := IVColTitleslvl2[TIVColTypeslvl2(ord(ctIVAction))]; // rpk 11/27/2012
          // 8:
            // OutText := IVColTitleslvl2[TIVColTypeslvl2(3)];
          ord(ctIVOtherPrintInfo):      // rpk 11/27/2012
            OutText := IVColTitleslvl2[TIVColTypeslvl2(ord(ctIVComment))]; // rpk 11/27/2012
          // 9:
//          10..11:
//            OutText := '';
          ord(ctIVBagInfo)..ord(ctIVStopDate): // rpk 11/27/2012
            OutText := '';
        end;
      end

        //level 2 Data
      else if (RowIndex = 2) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Admin((Control as TListBox).Items.Objects[index]) do
        begin
          case x of
//            0..4:
            ord(ctIVNoActionTaken)..ord(ctIVVerifyNurse): // rpk 11/27/2012
              OutText := '';
//            5:
            ord(ctIVWitness):           // rpk 11/27/2012
              OutText := DisplayVADate(piece(BagDetail[StrToInt(piece((Control as
                  TListBox).Items[index], '^', 4))], '^', 1));
//            6:
            ord(ctIVMedication):        // rpk 11/27/2012
              OutText := piece(BagDetail[StrToInt(piece((Control as
                  TListBox).Items[index], '^', 4))], '^', 2);
//            7:
            ord(ctIVInfusionRate):      // rpk 11/27/2012
              OutText :=
                GetLastActivityStatus(piece(BagDetail[StrToInt(piece((Control as
                  TListBox).Items[index], '^', 4))], '^', 3));
//            8:
            ord(ctIVOtherPrintInfo):    // rpk 11/27/2012
              OutText := piece(BagDetail[StrToInt(piece((Control as
                  TListBox).Items[index], '^', 4))], '^', 4);
//            9:
//              OutText := '';
//            10..11:
            ord(ctIVBagInfo)..ord(ctIVStopDate): // rpk 11/27/2012
              OutText := '';
          end;
        end
          //level 3 Header
      else if (RowIndex = 3) and HeaderRow then
      begin
//        if x > 6 then
        if x > ord(ctIVMedication) then begin // rpk 11/27/2012
          TempARect := ARect;
          TempARect.Left := TempARect.Left - 3;
          with Canvas do
            if not (odSelected in State) then
            begin
              Brush.Color := clBtnFace;
              FillRect(TempARect);
            end;
        end;
        case x of
//          0..6:
          ord(ctIVNoActionTaken)..ord(ctIVMedication): // rpk 11/27/2012
            OutText := '';
//          7:
//            OutText := PRNAColTitleslvl3[TPRNColTypeslvl3(0)];
          ord(ctIVInfusionRate):        // rpk 11/27/2012
            OutText := PRNAColTitleslvl3[TPRNColTypeslvl3(ord(cPRNCommentBy))]; // rpk 11/27/2012
//          8:
//            OutText := PRNAColTitleslvl3[TPRNColTypeslvl3(1)];
          ord(ctIVOtherPrintInfo):      // rpk 11/27/2012
            OutText := PRNAColTitleslvl3[TPRNColTypeslvl3(ord(cPRNComment))]; // rpk 11/27/2012
//          9..11:
          ord(ctIVBagInfo)..ord(ctIVStopDate): // rpk 11/27/2012
            OutText := '';
        end;
      end
        //level 3 Data
      else if (RowIndex = 3) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Comment((Control as TListBox).Items.Objects[index]) do
        begin
          case x of
//            0..6:
            ord(ctIVNoActionTaken)..ord(ctIVMedication): // rpk 11/27/2012
              OutText := '';
//            7:
            ord(ctIVInfusionRate):      // rpk 11/27/2012
              OutText := ActionByInitials + ' ' + DisplayVADate(ActionDateTime);
//            8:
            ord(ctIVOtherPrintInfo):    // rpk 11/27/2012
              OutText := Comment;
//            9..11:
            ord(ctIVBagInfo)..ord(ctIVStopDate): // rpk 11/27/2012
              OutText := '';
          end;
        end;
      if MouseOverText = '' then
        grdCellData[(Control as TlistBox).Tag].Cells[x, Index] := OutText
      else
        grdCellData[(Control as TlistBox).Tag].Cells[x, Index] := MouseOverText;

      if ((RowIndex = 1) and (x = 0)) then
        //do nothing
      else
        //        DrawText(Canvas.Handle, PChar(OutText), Length(OutText),
        //        ARect, DT_END_ELLIPSIS or DT_NOPREFIX);
        //        DrawText(Canvas.Handle, PChar(OutText), Length(OutText),
        //        ARect, DT_WORD_ELLIPSIS or DT_NOPREFIX or DT_EDITCONTROL);
        DrawText(Canvas.Handle, PChar(OutText), Length(OutText), ARect,
          //        DT_END_ELLIPSIS or DT_NOPREFIX or DT_EDITCONTROL or DT_WORDBREAK
          DT_SINGLELINE or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS);
            // rpk 4/29/2009
      ARect.Right := ARect.Right + 4;
      MouseOverText := '';
      Canvas.Brush.Color := BrushColor; // rpk 2/4/2011
      Canvas.Font.Color := CurrentFontColor; // rpk 5/25/2011
      Canvas.Font.Style := [];
    end;
  end;
end;                                    // lstIVGroupBoxesDoseDrawItem

procedure TfrmCoverSheet.lstExGroupBoxesDoseDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x,
    ii,
    CellRight,
    TitleCount,
    RowIndex: integer;
  TextString,
    MouseOverText: string;
  ARect,
    TempARect: TRect;
  //  zSpecialInstructions: string;
  outText: string;
  HeaderRow: Boolean;
  BrushColor: TColor;
  CurrentFontColor: TColor;             // rpk 5/25/2011
  OvrRect: TRect;                       // rpk 1/14/2011
{$IFDEF CAS_DDPE_RST}
  iRR: Integer;
  loaction: String;
  CSOrder: TCoverSheet_Order;
  csadmin: TCoverSheet_Admin;
{$ENDIF}
begin
  with Control as TListBox do
  begin
    ARect := Rect;
    CurrentFontColor := Canvas.Font.Color; // rpk 5/25/2011
    with Canvas do
    begin
      if odd(StrToInt(piece((Control as TListBox).Items[index], '^', 2))) then
        Brush.Color := RGB(245, 245, 220)
      else
        Brush.Color := clCream;

      if odSelected in State then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
      end;

      FillRect(ARect);
      BrushColor := Canvas.Brush.Color;
      if (Piece((Control as TListBox).Items[index], '^', 1) = '1') and
        chkGridLines.Checked then
      begin
        Pen.Color := clSilver;
        MoveTo(ARect.Left, ARect.Top - 1);
        LineTo(ARect.Right, ARect.Top - 1);
      end;
    end;

    CellRight := -3;
    TitleCount := Length(ExColTitlesLvl1);
    RowIndex := StrToInt(Piece((Control as TListBox).Items[index], '^', 1));
    HeaderRow := Piece((Control as TListBox).Items[index], '^', 3) = '1';

    if (RowIndex <> 0) and chkGridLines.Checked then
      with Canvas do
        for x := 0 to TitleCount - 1 do
        begin
          Pen.Color := clSilver;
          CellRight := CellRight + hdrExGroupHeaders[0].Sections[x].Width;
          MoveTo(CellRight + 1, ARect.Bottom - 1);
          LineTo(CellRight + 1, ARect.Top);
        end;

    for x := 0 to TitleCount - 1 do
    begin
      if x > 0 then
        ARect.Left := ARect.Right + 2
      else
        ARect.Left := 2;

      ARect.Right := ARect.Left + hdrExGroupHeaders[0].Sections[x].Width - 6;

      TextString := '';
      OutText := '';
      //level 1 data
      if (RowIndex = 1) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Order((Control as TListBox).Items.Objects[index]) do
          case x of
//            0:
            ord(ctExNoActionTaken):
              begin
                if AdministrationsWithAction.Count > 0 then
                  if Expanded = 2 then
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Left -
                      2, ARect.Top, 0)
                  else
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Left -
                      2, ARect.Top, 1);
                TempARect := ARect;
                TempARect.Left := TempARect.Left + 15;

                if NoActionTaken then
                begin
                  ImageList1.Draw((Control as TListBox).Canvas, TempARect.Left -
                    2, ARect.Top, 3);
                  MouseOverText := CSMouseOverTextNoAction;
                end;
              end;
//            1:
            ord(ctExStat):
              if Stat then
              begin
                ImageList1.Draw((Control as TListBox).Canvas, ARect.Left - 2,
                  ARect.Top, 4);
                MouseOverText := CSMouseOverTextStat;
              end;

//            2:
            ord(ctExFlag):
              if Flagged then
              begin
                Canvas.Brush.Color := clRed;
                TempARect := ARect;
                TempARect.Left := TempARect.Left - 3;
                TempARect.Right := TempARect.Right + 2;
                Canvas.FillRect(TempARect);
                Canvas.Brush.Color := BrushColor;
                //ImageList1.Draw((Control as TListBox).Canvas, ARect.Left - 2, ARect.Top, 2);
                MouseOverText := CSMouseOverTextOrderFlag;
              end;

            ord(ctExClinicName):        // rpk 5/14/2012
              OutText := ClinicName;

//            3:
            ord(ctExTab):
              OutText := VDLTabText[StrToInt(VDLTab)];

//            4:
            ord(ctExStatus):
              OutText := GetOrderStatus(OrderStatus);

            ord(ctExVerifyNurse): begin

                if OvrIntvent then begin
                  OvrRect := aRect;
              // adjust sides to fill to edge of cell.
                  OvrRect.Left := OvrRect.Left - 2;
                  OvrRect.Right := OvrRect.Right + 1;
                  OvrRect.Bottom := OvrRect.Bottom - 1;

                  with Canvas do begin
                    Brush.Color := $00FFFF; // bright yellow
                    Font.Color := clWindowText;
                    Brush.Style := bsSolid;
                    FillRect(OvrRect);
                  end;                  // with Canvas

                  MouseOverText := CSMouseOverTextOvrIntvent; // rpk 5/18/2011
                end;                    // if OvrIntvent

                if VerifyNurse = '***' then begin
                  Canvas.Font.Style := [fsBold];
                end;

                OutText := VerifyNurse; // rpk 2/4/2011
              end;

//            5:
            ord(ctExType):
              OutText := ScheduleType;


            ord(ctExWitness):           // rpk 9/11/2012
//              if WitnessFlag = WITNESS_REQUIRED then begin
//                ImageList1.Draw(Canvas, ARect.Left - 2, ARect.Top, CSWITNESS_IDX);
{$IFDEF CAS_DDPE_RST}
              begin
                MouseOverText := '';
                if WitnessFlag >= WITNESS_RECOMMENDED then begin
                  ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, CSWITNESS_IDX);
                  MouseOverText := CSMouseOverTextWitness;
                end;
                CSOrder := TCoverSheet_Order((Control as TListBox).Items.Objects[index]);
//                if (CSOrder.getLastOrderAction = 'G')
//                  and (CSOrder.RemovalStatus<>'') and (CSOrder.RemovalStatus<>'0') then // aan v. 3.0.083.17
//                loaction := CSOrder.getLastOrderAction;
//                if (loaction = 'G') and
//                  (CSOrder.RemovalStatus <> '') and
//                  (CSOrder.RemovalStatus <> '0') then // aan v. 3.0.083.17

//                if CSOrder.AdministrationsWithAction.Count > 0 then
//                  exAction

                if CSOrder.AdministrationsWithAction.Count > 0 then
                  csadmin := TCoverSheet_Admin(AllAdmins[AllAdmins.count - 1]);
                if (CSOrder.ScanStatus = 'G') and
//                if (CSOrder.LastActivityStatus = 'G') and
                (CSOrder.RemovalStatus <> '') and
                  (CSOrder.RemovalStatus <> '0') then // rpk 7/17/2015
                begin
                  iRR := frmMain.CAS_Icon;
                  frmMain.ilCAS_DDPE.Draw(Canvas, ARect.Left + 5 + 28, ARect.Top, iRR);
                  if MouseOverText <> '' then
                    MouseOverText := MouseOverText + #13#10#13#10;
                  MouseOverText := MouseOverText + CSRequiresRemoval;
                  // getRemovableOrderHint(TCoverSheet_Order((Control as TListBox).Items.Objects[index]));
                end;
              end;
{$ELSE}
              if WitnessFlag >= WITNESS_RECOMMENDED then begin // rpk 10/23/2012
                ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, CSWITNESS_IDX); // rpk 9/17/2012
                MouseOverText := CSMouseOverTextWitness; // rpk 9/11/2012
              end;
{$ENDIF}

//            6:
            ord(ctExMedication):
              OutText := ActiveMedication;

//            7:
//            ord(ctExSchedule):
//              OutText := Schedule;

//            8:
            ord(ctExDosage):
              OutText := Trim(Dosage) + ', ' + Route;

            ord(ctExSchedule):          // rpk 11/27/2012
              OutText := Schedule;      // rpk 11/27/2012

//            9:
            ord(ctExNextAction):
              OutText := NextAdminDateTime;

//            10:
            ord(ctExSpecialInstructions):
              begin
                //              OutText := SpecialInstructions;
//                OutText := TrimSpecInstr(SpecialInstructions);
                OutText := GetSIOPIText; // rpk 1/4/2012
                OutText := TrimSpecInstr(OutText); // rpk 1/4/2012
              end;

//            11:
            ord(ctExStartDate):
              OutText := DisplayVADate(StartDateTime);

//            12:
            ord(ctExStopDate):
              OutText := DisplayVADate(StopDateTime);
          end

            //level 2 header
      else if (RowIndex = 2) and HeaderRow then
      begin
        if TCoverSheet_Order((Control as
          TListBox).Items.Objects[index]).OrderType = 'V' then
//          ii := 5
          ii := ord(ctExWitness)        // rpk 11/27/2012
        else
//          ii := 6;
          ii := ord(ctExMedication);    // rpk 11/27/2012
        if x > ii then
        begin
          TempARect := ARect;
          TempARect.Left := TempARect.Left - 3;
          with Canvas do
            if not (odSelected in State) then
            begin
              Brush.Color := clBtnFace;
              FillRect(TempARect);
            end;
        end;
        case x of
//          0..5:
          ord(ctExNoActionTaken)..ord(ctExWitness): // rpk 11/27/2012
            OutText := '';
//          6:
          ord(ctExMedication):          // rpk 11/27/2012
            if TCoverSheet_Order((Control as
              TListBox).Items.Objects[index]).OrderType = 'V' then
//              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(0)];
              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(ctBagID))]; // rpk 11/27/2012
//          7:
//            OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(1)];
          ord(ctExDosage):              // rpk 11/27/2012
            OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(cActionBy))]; // rpk 11/27/2012
          // 8:
          ord(ctExSchedule):            // rpk 11/27/2012
//            OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(2)];
            OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(cAction))]; // rpk 11/27/2012
          // 9:
          ord(ctExNextAction):          // rpk 11/27/2012
            if TCoverSheet_Order((Control as
              TListBox).Items.Objects[index]).ScheduleType = 'P' then
//              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(3)];
              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(cPRNReason))]; // rpk 11/27/2012
          // 10:
          ord(ctExSpecialInstructions): // rpk 11/27/2012
            if TCoverSheet_Order((Control as
              TListBox).Items.Objects[index]).ScheduleType = 'P' then
//              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(4)];
              OutText := MedOverviewColTitleslvl2[TMedOverviewColTypeslvl2(ord(cPRNReason))]; // rpk 11/27/2012
          // 11..12:
          ord(ctExStartDate)..ord(ctExStopDate): // rpk 11/27/2012
            OutText := '';
        end;
      end

        //level 2 Data
      else if (RowIndex = 2) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Admin((Control as TListBox).Items.Objects[index]) do
        begin
          case x of
//            0..4:
            ord(ctExNoActionTaken)..ord(ctExType): // rpk 11/27/2012
              OutText := '';
            // 5:
            ord(ctExWitness):
              begin
                if (Comments.Count > 0) and (BagID <> '') then
                  if Expanded = 2 then
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                      15, ARect.Top, 0)
                  else
                    ImageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                      15, ARect.Top, 1);

                //   if Comments.Count > 0 then
                //     if Expanded = 2 then
                //       ImageList1.Draw((Control as TListBox).Canvas, ARect.Right - 15, ARect.Top, 0)
                //     else
                //       ImageList1.Draw((Control as TListBox).Canvas, ARect.Right - 15, ARect.Top, 1);
              end;
            // 6:
            ord(ctExMedication):        // rpk 11/27/2012
              if BagID <> '' then
                OutText := BagID
              else if Comments.Count > 0 then
                if Expanded = 2 then
                  ImageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                    15, ARect.Top, 0)
                else
                  imageList1.Draw((Control as TListBox).Canvas, ARect.Right -
                    15, ARect.Top, 1);

            //              OutText := BagID;
            // 7:
            ord(ctExDosage):            // rpk 11/27/2012
              OutText := ActionByInitials + ' ' + DisplayVADate(ActionDateTime);
            // 8:
            ord(ctExSchedule):          // rpk 11/27/2012
              OutText := GetLastActivityStatus(Action);
            // 9:
            ord(ctExNextAction):        // rpk 11/27/2012
              OutText := PRNReason;
            // 10:
            ord(ctExSpecialInstructions): // rpk 11/27/2012
              OutText := PRNEffectComment;
            // 11..12:
            ord(ctExStartDate)..ord(ctExStopDate): // rpk 11/27/2012
              OutText := '';
          end;
        end
          //level 3 Header
      else if (RowIndex = 3) and HeaderRow then
      begin
//        if x > 8 then
        if x > ord(ctExSchedule) then   // rpk 11/27/2012
        begin
          TempARect := ARect;
          TempARect.Left := TempARect.Left - 3;
          with Canvas do
            if not (odSelected in State) then
            begin
              Brush.Color := clBtnFace;
              FillRect(TempARect);
            end;
        end;
        case x of
//          0..8:
          ord(ctExNoActionTaken)..ord(ctExSchedule): // rpk 11/27/2012
            OutText := '';
//          9:
          ord(ctExNextAction):          // rpk 11/27/2012
//            OutText := MedOverviewColTitleslvl3[TMedOverviewColTypeslvl3(0)];
            OutText := MedOverviewColTitleslvl3[TMedOverviewColTypeslvl3(ord(cCommentBy))]; // rpk 11/27/2012
//          10:
          ord(ctExSpecialInstructions): // rpk 11/27/2012
//            OutText := MedOverviewColTitleslvl3[TMedOverviewColTypeslvl3(1)];
            OutText := MedOverviewColTitleslvl3[TMedOverviewColTypeslvl3(ord(cComment))]; // rpk 11/27/2012
//          11..12:
          ord(ctExStartDate)..ord(ctExStopDate): // rpk 11/27/2012
            OutText := '';
        end;
      end
        //level 3 Data
      else if (RowIndex = 3) and not HeaderRow and
        ((Control as TListBox).Items.Objects[index] <> nil) then
        with TCoverSheet_Comment((Control as TListBox).Items.Objects[index]) do
        begin
          case x of
//            0..8:
            ord(ctExNoActionTaken)..ord(ctExSchedule): // rpk 11/27/2012
              OutText := '';
//            9:
            ord(ctExNextAction):        // rpk 11/27/2012
              OutText := ActionByInitials + ' ' + DisplayVADate(ActionDateTime);
//            10:
            ord(ctExSpecialInstructions): // rpk 11/27/2012
              OutText := Comment;
//            11..12:
            ord(ctExStartDate)..ord(ctExStopDate): // rpk 11/27/2012
              OutText := '';
          end;
        end;
      if MouseOverText = '' then
        grdCellData[(Control as TlistBox).Tag].Cells[x, Index] := OutText
      else
        grdCellData[(Control as TlistBox).Tag].Cells[x, Index] := MouseOverText;

      if ((RowIndex = 1) and (x = 0)) then
        //do nothing
      else
        //        DrawText(Canvas.Handle, PChar(OutText), Length(OutText),
        //        ARect, DT_END_ELLIPSIS or DT_NOPREFIX);
        //        DrawText(Canvas.Handle, PChar(OutText), Length(OutText),
        //        ARect, DT_WORD_ELLIPSIS or DT_NOPREFIX or DT_EDITCONTROL);
        DrawText(Canvas.Handle, PChar(OutText), Length(OutText), ARect,
          //        DT_END_ELLIPSIS or DT_NOPREFIX or DT_EDITCONTROL or DT_WORDBREAK
          DT_SINGLELINE or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS);
            // rpk 4/29/2009

      ARect.Right := ARect.Right + 4;
      MouseOverText := '';
      Canvas.Brush.Color := BrushColor; // rpk 2/4/2011
      Canvas.Font.Color := CurrentFontColor; // rpk 5/25/2011
      Canvas.Font.Style := [];          // rpk 2/4/2011
    end;
  end;
end;                                    // lstExGroupBoxesDoseDrawItem

procedure TfrmCoverSheet.BuildMOGroup(MOListBox: TListBox);
var
  x, y, z, GroupNum: integer;
  tempTList: TList;
  expirestr: string;
begin
  ReDrawSuspend(sbxCoverSheet.Handle);
  if SelectedItemIndex <> -1 then
    ScrollBarPosition := sbxCoverSheet.VertScrollBar.Position;

  GroupNum := 0;                        // rpk 4/7/2009

  MOListBox.Clear;
  MOListBox.Height := 0;
  tempTList := TList.Create;
  if MOListBox = lstMOGroupBoxes[0] then
  begin
    GroupNum := 0;
    tempTList := ActiveCSOrders;
  end
  else if MOListBox = lstMOGroupBoxes[1] then
  begin
    GroupNum := 1;
    tempTList := FutureCSOrders;
  end
  else if MOListBox = lstMOGroupBoxes[2] then
  begin
    GroupNum := 2;
    tempTList := ExpiredCSOrders;
  end;

  if tempTList.Count > 0 then
  begin
    MedOverviewGrpExpanded[TMedOverviewGroups(GroupNum)] := 2;
    ImageList1.Draw(imgMOGroupImages[GroupNum].Canvas, 0, 0, 0);
  end;

  if MedOverviewGrpExpanded[TMedOverviewGroups(GroupNum)] <> 2 then
  begin
    MedOverviewGrpExpanded[TMedOverviewGroups(GroupNum)] := 0;
    hdrMOGroupHeaders[GroupNum].height := 0;
    lstMOGroupBoxes[GroupNum].height := 0;
  end;

  if tempTList.Count > 0 then
  begin
    {Four pieces of information are added via additem
    Piece 1 - current level being added
    Piece 2 - x value from top level loop, used to alternate colors when painted.
    Piece 3 - 0 not a header row, 1 header row
    Piece 4 - Used for IVOverview Level 2 data only
    }
    try

//      tempTList.Sort(SortCoverSheet);
      stableSort(tempTList, SortCoverSheet);
    finally
      for x := 0 to tempTList.Count - 1 do
      begin
        MOListBox.AddItem('1^' + IntToStr(x) + '^0', tempTList[x]);

        //add level 2 data
        with TCoverSheet_Order(tempTList[x]) do
          if (Expanded = 2) and (AdministrationsWithAction.Count > 0) then
          begin
            MOListBox.AddItem('2^' + IntToStr(x) + '^1', tempTList[x]);
            for y := 0 to AdministrationsWithAction.Count - 1 do
            begin
              if TCoverSheet_Admin(AdministrationsWithAction[y]).Action <> '' then
                MOListBox.AddItem('2^' + IntToStr(x) + '^0',
                  AdministrationsWithAction[y]);

              //add level 3 data
              with TCoverSheet_Admin(AdministrationsWithAction[y]) do
                if (Expanded = 2) and (Comments.Count > 0) then
                begin
                  MOListBox.AddItem('3^' + IntToStr(x) + '^1', nil);
                  for z := 0 to Comments.Count - 1 do
                    MOListBox.AddItem('3^' + IntToStr(x) + '^0', Comments[z]);
                end;
            end;
          end;
        //if tempTList.Count > 1 then MOListBox.AddItem('0', nil);
      end;
    end;
  end;                                  // if TempTList.Count > 0

  {if TempTList.Count = 1 then
    pnlMOGroupPanels[GroupNum].Caption := '       ' +
      MedOverviewGroupTitles[TMedOverviewGroups(GroupNum)] + ' [' +
      IntToStr(TempTList.Count) + ' Order]'
  else
    pnlMOGroupPanels[GroupNum].Caption := '       ' +
      MedOverviewGroupTitles[TMedOverviewGroups(GroupNum)] + ' [' +
      IntToStr(TempTList.Count) + ' Orders]';}

  if (OrderMode = omClinic) and (GroupNum = 2) then // rpk 2/26/2013
    expirestr := 'within last 7 days'   // expired/dc'd
  else
    expirestr := '';

  if TempTList.Count = 1 then
    pnlMOGroupPanels[GroupNum].Caption := '       ' +
      MedOverviewGroupTitles[TMedOverviewGroups(GroupNum)] + ' ' + expirestr + // rpk 2/22/2013
      ' [' + IntToStr(TempTList.Count) + ' Order]'
  else
    pnlMOGroupPanels[GroupNum].Caption := '       ' +
      MedOverviewGroupTitles[TMedOverviewGroups(GroupNum)] + ' ' + expirestr + // rpk 2/22/2013
      ' [' + IntToStr(TempTList.Count) + ' Orders]';

  grdCellData[GroupNum].RowCount := 0;
  //if TempTList.Count > 0 then
  //  grdCellData[GroupNum].RowCount := TempTlist.Count;
//  if MoListBox.Count > 0 then
//    grdCellData[GroupNum].RowCount := MoListBox.Count;

  MOListBox.TabStop := (MOListBox.Height > 0);
  ReDrawActivate(sbxCoverSheet.Handle);
  RepaintCoverSheet;
  if SelectedItemIndex <> -1 then
  begin
    MOListBox.ItemIndex := SelectedItemIndex;
    SelectedItemIndex := -1;
    sbxCoverSheet.VertScrollBar.Position := ScrollBarPosition;
    ScrollBarPosition := -1
  end;
end;                                    // BuildMOGroup

procedure TfrmCoverSheet.BuildPRNGroup(PRNListBox: TListBox);
var
  PRNCount, GroupNum, x, y, z: integer;
  tempTList: TList;
  //  , tempPRNTList: TList;
  expirestr: string;
begin
  ReDrawSuspend(sbxCoverSheet.Handle);
  if SelectedItemIndex <> -1 then
    ScrollBarPosition := sbxCoverSheet.VertScrollBar.Position;

  GroupNum := 0;                        // rpk 4/7/2009

  PRNListBox.Clear;
  PRNListBox.Height := 0;
  tempTList := TList.Create;
  //  tempPRNTList := TList.Create;
  PRNCount := 0;

  if PRNListBox = lstPRNGroupBoxes[0] then
  begin
    GroupNum := 0;
    tempTList := ActiveCSOrders;
  end
  else if PRNListBox = lstPRNGroupBoxes[1] then
  begin
    GroupNum := 1;
    tempTList := FutureCSOrders;
  end
  else if PRNListBox = lstPRNGroupBoxes[2] then
  begin
    GroupNum := 2;
    tempTList := ExpiredCSOrders;
  end;

  if TempTList.Count > 0 then
    for x := 0 to tempTList.Count - 1 do
      if TCoverSheet_Order(tempTList[x]).ScheduleType = 'P' then
      begin
        PRNAGrpExpanded[TPRNGroups(GroupNum)] := 2;
        //        tempPRNTList.Add(TCoverSheet_Order(TempTList[x]));
        break;
      end;

  if PRNAGrpExpanded[TPRNGroups(GroupNum)] <> 2 then
  begin
    PRNAGrpExpanded[TPRNGroups(GroupNum)] := 0;
    hdrPRNGroupHeaders[GroupNum].Height := 0;
    lstPRNGroupBoxes[GroupNum].Height := 0;
  end;

  if tempTList.Count > 0 then
  begin
    {Four pieces of information are added via additem
    Piece 1 - current level being added
    Piece 2 - x value from top level loop, used to alternate colors when painted.
    Piece 3 - 0 not a header row, 1 header row
    Piece 4 - Used for IVOverview Level 2 data only
    }
    try

//      tempTList.Sort(SortCoverSheet);
      stableSort(tempTList, SortCoverSheet);
    finally

      for x := 0 to tempTList.Count - 1 do
      begin
        if TCoverSheet_Order(tempTList[x]).ScheduleType = 'P' then
        begin
          PRNCount := PRNCount + 1;
          PRNListBox.AddItem('1^' + IntToStr(PRNCount) + '^0', tempTList[x]);

          //add level 2 data
          with TCoverSheet_Order(tempTList[x]) do
            if (Expanded = 2) and (AdministrationsWithAction.Count > 0) then
            begin
              PRNListBox.AddItem('2^' + IntToStr(PRNCount) + '^1', tempTList[x]);
              for y := 0 to AdministrationsWithAction.Count - 1 do
              begin
                if TCoverSheet_Admin(AdministrationsWithAction[y]).Action <> ''
                  then
                  PRNListBox.AddItem('2^' + IntToStr(PRNCount) + '^0',
                    AdministrationsWithAction[y]);

                //add level 3 data
                with TCoverSheet_Admin(AdministrationsWithAction[y]) do
                  if (Expanded = 2) and (Comments.Count > 0) then
                  begin
                    PRNListBox.AddItem('3^' + IntToStr(PRNCount) + '^1', nil);
                    for z := 0 to Comments.Count - 1 do
                      PRNListBox.AddItem('3^' + IntToStr(PRNCount) + '^0',
                        Comments[z]);
                  end;
              end;
            end;
        end;
      end;
    end;
  end;                                  // if tempTList.Count > 0

  {if PRNCount = 1 then
    pnlPRNGroupPanels[GroupNum].Caption := '       ' +
      PRNAGroupTitles[TPRNGroups(GroupNum)] + ' [' + IntToStr(PRNCount) + ' Order]'
  else
    pnlPRNGroupPanels[GroupNum].Caption := '       ' +
      PRNAGroupTitles[TPRNGroups(GroupNum)] + ' [' + IntToStr(PRNCount) +
      ' Orders]';}

  if (OrderMode = omClinic) and (GroupNum = 2) then // rpk 2/26/2013
    expirestr := 'within last 7 days'   // expired/dc'd
  else
    expirestr := '';

  if PRNCount = 1 then
    pnlPRNGroupPanels[GroupNum].Caption := '       ' +
      PRNAGroupTitles[TPRNGroups(GroupNum)] + ' ' + expirestr + // rpk 2/26/2013
      ' [' + IntToStr(PRNCount) + ' Order]'
  else
    pnlPRNGroupPanels[GroupNum].Caption := '       ' +
      PRNAGroupTitles[TPRNGroups(GroupNum)] + ' ' + expirestr + // rpk 2/26/2013
      ' [' + IntToStr(PRNCount) + ' Orders]';

  grdCellData[GroupNum].RowCount := 0;
  if PRNCount > 0 then
    grdCellData[GroupNum].RowCount := PRNCount;

  if SelectedItemIndex <> -1 then
  begin
    PRNListBox.ItemIndex := SelectedItemIndex;
    SelectedItemIndex := -1;
    sbxCoverSheet.VertScrollBar.Position := ScrollBarPosition;
    ScrollBarPosition := -1
  end;

  PRNListBox.TabStop := (PRNListBox.Height > 0);
  ReDrawActivate(sbxCoverSheet.Handle);
  RepaintCoverSheet;
end;                                    // BuildPRNGroup

procedure TfrmCoverSheet.BuildIVGroup(IVListBox: TListBox);
var
  //  IVCount: Integer;
  GroupNum, x, y: Integer;
  //  , z: integer;
  tempTList: TList;
begin
  ReDrawSuspend(sbxCoverSheet.Handle);
  if SelectedItemIndex <> -1 then
    ScrollBarPosition := sbxCoverSheet.VertScrollBar.Position;
  IVListBox.Clear;
  IVListBox.Height := 0;
  tempTList := TList.Create;
  //  IVCount := 0;

  GroupNum := 0;                        // rpk 4/7/2009

  if IVListBox = lstIVGroupBoxes[0] then
  begin
    GroupNum := 0;
    for x := 0 to AllAdmins.Count - 1 do
      with TCoverSheet_Admin(AllAdmins[x]) do
        if (Action = 'I') and (TCoverSheet_Order(Order).OrderType = 'V') then
        begin
          tempTList.Add(AllAdmins[x]);
        end;
  end
  else if IVListBox = lstIVGroupBoxes[1] then
  begin
    GroupNum := 1;
    for x := 0 to AllAdmins.Count - 1 do
      with TCoverSheet_Admin(AllAdmins[x]) do
        if (Action = 'S') and (TCoverSheet_Order(Order).OrderType = 'V') then
        begin
          tempTList.Add(AllAdmins[x]);
        end;

  end
  else if IVListBox = lstIVGroupBoxes[2] then
  begin
    GroupNum := 2;
    for x := 0 to AllAdmins.Count - 1 do
      with TCoverSheet_Admin(AllAdmins[x]) do
        if (Action <> 'S') and (Action <> 'I') and
          (TCoverSheet_Order(Order).OrderType = 'V') and
          (TCoverSheet_Order(Order).VDLTab = '3') then
        begin
          tempTList.Add(AllAdmins[x]);
        end
  end;

  if TempTList.Count > 0 then
  begin
    IVOGrpExpanded[TIVGroups(GroupNum)] := 2;
    ImageList1.Draw(imgIVGroupImages[GroupNum].Canvas, 0, 0, 0);
  end;

  if IVOGrpExpanded[TIVGroups(GroupNum)] <> 2 then
  begin
    IVOGrpExpanded[TIVGroups(GroupNum)] := 0;
    hdrIVGroupHeaders[GroupNum].Height := 0;
    lstIVGroupBoxes[GroupNum].Height := 0;
  end;

  if tempTList.Count > 0 then
    {Four pieces of information are added via additem
    Piece 1 - current level being added
    Piece 2 - x value from top level loop, used to alternate colors when painted.
    Piece 3 - 0 not a header row, 1 header row
    Piece 4 - Used for IVOverview Level 2 data only
    }
  begin
    try

//      tempTList.Sort(SortCoverSheet);
      stableSort(tempTList, SortCoverSheet);
    finally
      for x := 0 to tempTList.Count - 1 do
      begin
        IVListBox.AddItem('1^' + IntToStr(x) + '^0', tempTList[x]);

        //add level 2 data
        with TCoverSheet_Admin(tempTList[x]) do
          if IVExpanded = 2 then
          begin
            IVListBox.AddItem('2^' + IntToStr(x) + '^1', nil);
            if BagDetail <> nil then
              for y := 0 to BagDetail.Count - 1 do
                IVListBox.AddItem('2^' + IntToStr(x) + '^0^' + IntToStr(y),
                  tempTList[x]);
          end;
      end;
    end;
  end;                                  // if tempTList.Count > 0
  pnlIVGroupPanels[GroupNum].Caption := '       ' +
    IVOGroupTitles[TIVGroups(GroupNum)] +
    ' [' + IntToStr(tempTList.count) + ']';

  grdCellData[GroupNum].RowCount := 0;
  if TempTList.Count > 0 then
    grdCellData[GroupNum].RowCount := TempTlist.Count;

  if SelectedItemIndex <> -1 then
  begin
    IVListBox.ItemIndex := SelectedItemIndex;
    SelectedItemIndex := -1;
    sbxCoverSheet.VertScrollBar.Position := ScrollBarPosition;
    ScrollBarPosition := -1
  end;

  IVListBox.TabStop := (IVListBox.Height > 0);
  ReDrawActivate(sbxCoverSheet.Handle);
  RepaintCoverSheet;

end;                                    // BuildIVGroup

procedure TfrmCoverSheet.BuildExGroup(ExListBox: TListBox);
var
  ExCount, GroupNum, x, y, z: integer;
  tempTList: TList;
  titlestr: string;
begin
  ReDrawSuspend(sbxCoverSheet.Handle);
  if SelectedItemIndex <> -1 then
    ScrollBarPosition := sbxCoverSheet.VertScrollBar.Position;

//  GroupNum := 0; // rpk 4/7/2009
  GroupNum := ord(exExpired);           // rpk 7/12/2012

  ExListBox.Clear;
  ExListBox.Height := 0;
  tempTList := TList.Create;
  EXCount := 0;

//  if ExListBox = lstExGroupBoxes[0] then
  if ExListBox = lstExGroupBoxes[ord(exExpired)] then // rpk 7/11/2012
  begin
//    GroupNum := 0;
    GroupNum := ord(exExpired);         // rpk 7/11/2012
    tempTList := ExpiredCSOrders;
  end
//  else if ExListBox = lstExGroupBoxes[1] then
  else if ExListBox = lstExGroupBoxes[ord(exExpiring)] then // rpk 7/11/2012
  begin
//    GroupNum := 1;
    GroupNum := ord(exExpiring);        // rpk 7/11/2012
    for x := 0 to ActiveCSOrders.Count - 1 do
      with TCoverSheet_Order(ActiveCSOrders[x]) do
        if piece(StopDateTime, '.', 1) = piece(DateTimeToMDateTime(now +
          BCMA_SiteParameters.ServerClockVariance), '.', 1) then
          tempTList.Add(ActiveCSOrders[x])
  end
//  else if ExListBox = lstExGroupBoxes[2] then
  else if ExListBox = lstExGroupBoxes[ord(exExpiringTomorrow)] then // rpk 7/11/2012
  begin
//    GroupNum := 2;
    GroupNum := ord(exExpiringTomorrow); // rpk 7/11/2012
    for x := 0 to ActiveCSOrders.Count - 1 do
      with TCoverSheet_Order(ActiveCSOrders[x]) do
        if (FMDateTimeToDateTime(StrToInt(piece(StopDateTime, '.', 1))) >
          (DateOf(Now + BCMA_SiteParameters.ServerClockVariance))) and
          (FMDateTimeToDateTime(StrToInt(piece(StopDateTime, '.', 1))) <=
          (DateOf(Now + BCMA_SiteParameters.ServerClockVariance +
          Integer(cbxExpiring.Items.Objects[cbxExpiring.ItemIndex])))) then
          tempTList.Add(ActiveCSOrders[x])
  end;

  if TempTList.Count > 0 then
  begin
    ExGrpExpanded[TExpiredGroups(GroupNum)] := 2;
    ImageList1.Draw(imgExGroupImages[GroupNum].Canvas, 0, 0, 0);
  end
  else
    ExGrpExpanded[TExpiredGroups(GroupNum)] := 0;

  if ExGrpExpanded[TExpiredGroups(GroupNum)] <> 2 then
  begin
    ExGrpExpanded[TExpiredGroups(GroupNum)] := 0;
    if hdrExGroupHeaders[GroupNum] <> nil then
      hdrExGroupHeaders[GroupNum].Height := 0;
    if lstExGroupBoxes[GroupNum] <> nil then
      lstExGroupBoxes[GroupNum].Height := 0;
  end;

  {Four pieces of information are added via additem
  Piece 1 - current level being added
  Piece 2 - x value from top level loop, used to alternate colors when painted.
  Piece 3 - 0 not a header row, 1 header row
  Piece 4 - Used for IVOverview Level 2 data only
  }
  if tempTList.Count > 0 then
  begin
    try

//    tempTList.Sort(SortCoverSheet);
      stableSort(tempTList, SortCoverSheet);
    finally

      for x := 0 to tempTList.Count - 1 do
      begin
        ExCount := ExCount + 1;
        ExListBox.AddItem('1^' + IntToStr(x) + '^0', tempTList[x]);

        //add level 2 data
        with TCoverSheet_Order(tempTList[x]) do
          if (Expanded = 2) and (AdministrationsWithAction.Count > 0) then
          begin
            ExListBox.AddItem('2^' + IntToStr(x) + '^1', tempTList[x]);
            for y := 0 to AdministrationsWithAction.Count - 1 do
            begin
              if TCoverSheet_Admin(AdministrationsWithAction[y]).Action <> '' then
                ExListBox.AddItem('2^' + IntToStr(x) + '^0',
                  AdministrationsWithAction[y]);

              //add level 3 data
              with TCoverSheet_Admin(AdministrationsWithAction[y]) do
                if (Expanded = 2) and (Comments.Count > 0) then
                begin
                  ExListBox.AddItem('3^' + IntToStr(x) + '^1', nil);
                  for z := 0 to Comments.Count - 1 do
                    ExListBox.AddItem('3^' + IntToStr(x) + '^0', Comments[z]);
                end;
            end;
          end;
      end;
    end;
  end;                                  // if tempTList.Count > 0

  if OrderMode = omInpatient then begin
    { if ExCount = 1 then
      pnlExGroupPanels[GroupNum].Caption := '       ' +
        ExGroupTitles[TExpiredGroups(GroupNum)] + ' [' + IntToStr(ExCount) +
        ' Order]'
    else
      pnlExGroupPanels[GroupNum].Caption := '       ' +
        ExGroupTitles[TExpiredGroups(GroupNum)] + ' [' + IntToStr(ExCount) +
        ' Orders]'; }
    titlestr := ExGroupTitles[TExpiredGroups(GroupNum)];
  end
  else begin
    case GroupNum of
      ord(exExpired):
        titlestr := 'Expired/DC''d within last 7 days';
      ord(exExpiring):
        titlestr := 'Expiring Today';
      ord(exExpiringTomorrow):
        titlestr := 'Expiring within next 7 days (after Midnight tonight)';
    else
      titlestr := '';
    end;
  end;
  if ExCount = 1 then
    pnlExGroupPanels[GroupNum].Caption := '       ' +
      titlestr + ' [' + IntToStr(ExCount) + ' Order]'
  else
    pnlExGroupPanels[GroupNum].Caption := '       ' +
      titlestr + ' [' + IntToStr(ExCount) + ' Orders]';

  grdCellData[GroupNum].RowCount := 0;
  if ExCount > 0 then
    grdCellData[GroupNum].RowCount := ExCount;

  if SelectedItemIndex <> -1 then
  begin
    ExListBox.ItemIndex := SelectedItemIndex;
    SelectedItemIndex := -1;
    sbxCoverSheet.VertScrollBar.Position := ScrollBarPosition;
    ScrollBarPosition := -1
  end;

  ExListBox.TabStop := (ExListBox.Height > 0);
  ReDrawActivate(sbxCoverSheet.Handle);
  RepaintCoverSheet;
end;                                    // BuildExGroup



{There are three methods of rebuilding the coversheet, thus three main parameters,
 the latter two added later...
 Reload - Physically calls the RPC, reloads all data, clears all controls,
   re-populates the coversheet
 Rebuild - Simply rebuilds the listboxes or the three sections of the coversheet
 RebuildComplete - Competely wipes out all controls and re-paints the coversheet,
 thus more screen flicker, but necessary at times.
}

procedure TfrmCoverSheet.ReloadCoverSheet(ReLoad, Rebuild: Boolean; Hours: string
  = '24';
  RebuildComplete: Boolean = false);
var
  x: integer;
  ErrorString: string;
begin
  if ReLoad then
  begin
    pnlExHours.Visible := (cbxView.ItemIndex = ord(csvExpiringOrders)); // rpk 7/24/2012
//    if CurrentView = TCoverSheetViews(3) then
//    if CurrentView = TCoverSheetViews(ord(csvExpiringOrders)) then
//    if CurrentView = TCoverSheetViews(ord(csvExpiringOrders)) then begin

    if (CurrentView = csvExpiringOrders) then begin
//    if (CurrentView in [csvMedOverview, csvPRNAssessment, csvExpiringOrders]) then begin  // rpk 2/20/2013
      SetExCbx;                         // rpk 7/11/2012
      if cbxExpired.ItemIndex >= 0 then // rpk 7/12/2012
        Hours := IntToStr(Integer(cbxExpired.Items.Objects[cbxExpired.ItemIndex]))
      else
        Hours := '';
    end;
    SelectedItemIndex := -1;
    for x := 0 to SbxCoverSheet.ControlCount - 1 do
      if SbxCoverSheet.Controls[x] is TListBox then
        TListBox(SbxCoverSheet.Controls[x]).Clear;

    sbxCoverSheet.Visible := False;
    lblCoverSheet.Caption := 'Loading Cover Sheet';
    Repaint;
    ErrorString := LoadCoverSheetOrders(BCMA_Patient.IEN, Hours);

    // CQ 1301
    // Moved indicator update code above if ErrorString so that the indicators
    // are reset when there are no orders found for the selected order mode.
    with frmMain do begin
      { tbshtUnitDose.ImageIndex := Ord(BCMA_Patient.ActiveUDOrders);
      tbshtIVPIVPB.ImageIndex := Ord(BCMA_Patient.ActivePBOrders);
      tbshtIV.ImageIndex := Ord(BCMA_Patient.ActiveIVOrders);
      shpClinic.Brush.Color := clWhite;
      shpInpatient.Brush.Color := clWhite;
      with BCMA_Patient do begin
        if HasClinicOrders then // rpk 4/26/2012
          shpClinic.Brush.Color := clLime; // rpk 4/26/2012
        if HasInpatientOrders then // rpk 4/26/2012
          shpInpatient.Brush.Color := clLime; // rpk 4/26/2012
      end; }
//      UpdateShapes(BCMA_Patient); // rpk 8/10/2012
//      Invalidate;
    end;
    if ErrorString <> '' then begin
      lblCoverSheet.Caption := ErrorString;
      cbxView.Enabled := False;
      exit;
    end;
    CheckForEditedIVs;
    { with frmMain do begin
      tbshtUnitDose.ImageIndex := Ord(BCMA_Patient.ActiveUDOrders);
      tbshtIVPIVPB.ImageIndex := Ord(BCMA_Patient.ActivePBOrders);
      tbshtIV.ImageIndex := Ord(BCMA_Patient.ActiveIVOrders);
      shpClinic.Brush.Color := clWhite;
      shpInpatient.Brush.Color := clWhite;
      with BCMA_Patient do begin
        if HasClinicOrders then // rpk 4/26/2012
          shpClinic.Brush.Color := clLime; // rpk 4/26/2012
        if HasInpatientOrders then // rpk 4/26/2012
          shpInpatient.Brush.Color := clLime; // rpk 4/26/2012
      end;
    end; }
    cbxView.Enabled := True;
    cbxViewChange(self);
    sbxCoverSheet.Visible := True;

  end
  else                                  // rpk 10/1/2012
    BCMA_Patient.GetMedsOnPatient;      // rpk 10/1/2012

  frmMain.UpdateShapes(BCMA_Patient);   // rpk 10/1/2012
  Invalidate;                           // rpk 10/1/2012

  if Rebuild then
    case cbxView.ItemIndex of
//      0:
      ord(csvMedOverview):
        begin
          for x := 0 to Length(MedOverviewGroupTitles) - 1 do
            if MedOverviewGrpExpanded[TMedOverviewGroups(x)] = 2 then
              BuildMOGroup(lstMOGroupBoxes[x]);
        end;
//      1:
      ord(csvPRNAssessment):
        begin
          for x := 0 to Length(PRNAGroupTitles) - 1 do
            if PRNAGrpExpanded[TPRNGroups(x)] = 2 then
              BuildPRNGroup(lstPRNGroupBoxes[x]);
        end;
//      2:
      ord(csvIVOverview):
        begin
          for x := 0 to Length(IVOGroupTitles) - 1 do
            if IVOGrpExpanded[TIVGroups(x)] = 2 then
              BuildIVGroup(lstIVGroupBoxes[x]);
        end;
//      3:
      ord(csvExpiringOrders):
        begin
          for x := 0 to Length(ExGroupTitles) - 1 do
            //if ExGrpExpanded[TExpiredGroups(x)] = 2 then
            BuildExGroup(lstExGroupBoxes[x]);
        end;
    end;
  if ReBuildComplete then
  begin
    for x := 0 to SbxCoverSheet.ControlCount - 1 do
      if SbxCoverSheet.Controls[x] is TListBox then
        TListBox(SbxCoverSheet.Controls[x]).Clear;
    cbxViewChange(self);
  end;

//  ShowCtrlName('frmCoverSheetRepaintCoverSheet', ActiveControl);

end;                                    // ReloadCoverSheet

procedure TFrmCoverSheet.RepaintCoverSheet;
var
  x: integer;
begin
  with sbxCoverSheet do
    for x := 0 to ControlCount - 1 do
      controls[x].Repaint;
  with pnlView do
    for x := 0 to ControlCount - 1 do
      controls[x].Repaint;

//  ShowCtrlName('frmCoverSheetRepaintCoverSheet', ActiveControl);

end;

procedure TFrmCoverSheet.lstGroupBoxesContextPopup(Sender: TObject; MousePos:
  TPoint;
  var Handled: Boolean);
var
  RowIndex: integer;
  HeaderRow: Boolean;
begin
  // add SelectedOrder := nil;   initialization?
  RowIndex := 0;                        // rpk 4/7/2009
  HeaderRow := False;                   // rpk 4/7/2009

  if TListBox(Sender).ItemIndex <> -1 then
    with Sender as TListBox do
    begin
      RowIndex := StrToInt(Piece(Items[ItemIndex], '^', 1));
      HeaderRow := Piece(Items[ItemIndex], '^', 3) = '1';
    end;
  with TListBox(Sender) do
    case cbxView.ItemIndex of
      0..1, 3:
        if (ItemIndex <> -1) and (RowIndex = 1) and not HeaderRow then
        begin
          SelectedOrder := TCoverSheet_Order(Items.Objects[ItemIndex]);
          ActionCSDisplayOrder.Enabled := True;
          ActionCSMedHistory.Enabled := True;
          ActionCSAvailableBags.Enabled :=
            (TCoverSheet_Order(Items.Objects[ItemIndex]).OrderType = 'V');
          ActionCSDisplayFlag.Enabled := True;
        end
        else
        begin
          ActionCSDisplayOrder.Enabled := False;
          ActionCSMedHistory.Enabled := False;
          ActionCSAvailableBags.Enabled := False;
          ActionCSDisplayFlag.Enabled := False;
        end;
      2:
        if (ItemIndex <> -1) and (RowIndex = 1) and not HeaderRow then
        begin
          SelectedOrder := TCoverSheet_Admin(Items.Objects[ItemIndex]).Order;
          ActionCSDisplayOrder.Enabled := True;
          ActionCSMedHistory.Enabled := True;
          ActionCSAvailableBags.Enabled :=
            (TCoverSheet_Order(TCoverSheet_Admin(Items.Objects[ItemIndex]).Order).OrderType = 'V');
          ActionCSDisplayFlag.Enabled := True;
        end
        else
        begin
          ActionCSDisplayOrder.Enabled := False;
          ActionCSMedHistory.Enabled := False;
          ActionCSAvailableBags.Enabled := False;
          ActionCSDisplayFlag.Enabled := False;
        end;
    else
      ActionCSDisplayOrder.Enabled := False;
      ActionCSAvailableBags.Enabled := false;
      ActionCSMedHistory.Enabled := False;
      ActionCSDisplayFlag.Enabled := False;
    end;
end;

{function TFrmCoverSheet.GetIndexOfListBox(ListBoxIn: TListBox): Integer;
begin
  result := GroupBoxIndexes[cbxView.ItemIndex].IndexOf(ListBoxIn);
end;}

procedure TfrmCoverSheet.ActionCSAvailableBagsUpdate(Sender: TObject);
begin
  if Sender is TAction then             // rpk 4/6/2012
    (Sender as TAction).Enabled := lstCurrentTab = ctCS; // rpk 4/6/2012
end;

procedure TfrmCoverSheet.ActionCSDisplayFlagExecute(Sender: TObject);
var
  msg: string;
begin
  if SelectedOrder <> nil then
  begin                                 // rpk 3/30/2009
    if RightStr(SelectedOrder.FlaggedText, 3) = '...' then
    begin
      msg := SelectedOrder.FlaggedText + #13 + #13;
      msg := msg + 'NOTE: The above Reason for Order Flag text has been ' +
        'truncated. Please view the full text in CPRS';
    end
    else
      msg := SelectedOrder.FlaggedText;

    DefMessageDlg(msg, mtInformation, [mbOk], 0,
      'BCMA - Reason For Order Flag');
  end;
end;

procedure TfrmCoverSheet.ActionCSDisplayFlagUpdate(Sender: TObject);
begin
  ActionCSDisplayFlag.Enabled := False;

//  if (SelectedOrder <> nil) and SelectedOrder.Flagged then
  if (lstCurrentTab = ctCS) and (SelectedOrder <> nil) and SelectedOrder.Flagged then // rpk 4/6/2012
    ActionCSDisplayFlag.Enabled := True;
end;

procedure TfrmCoverSheet.ActionCSDisplayOrderExecute(Sender: TObject);
begin
  if SelectedOrder <> nil then
    DisplayOrder(BCMA_Patient.IEN, SelectedOrder.OrderNumber);
end;

procedure TfrmCoverSheet.ActionCSDisplaySIExecute(Sender: TObject);
begin
  if SelectedOrder <> nil then
    SelectedOrder.DisplaySIOPI(False);
end;

procedure TfrmCoverSheet.ActionCSDisplaySIUpdate(Sender: TObject); // rpk 1/4/2012
var
  sitxt: string;
begin
  ActionCSDisplaySI.Enabled := False;

//  if SelectedOrder <> nil then begin
  // CQ 1137
  if (lstCurrentTab = ctCS) and (SelectedOrder <> nil) then begin // rpk 4/6/2012
    sitxt := SelectedOrder.GetSIOPIText;
    ActionCSDisplaySI.Enabled := sitxt > '';
  end;
end;

procedure TfrmCoverSheet.lstGroupBoxesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  APoint: TPoint;
begin
  ReDrawSuspend(Handle);

  //set scrollbar position to saved position. This gets around the
  //built in scrollinview functionality. A user would click a low point on the
  //control and the scrollbox would scroll back up to the top left of the control
  if ScrollBarPosition <> -1 then
  begin
    sbxCoverSheet.VertScrollBar.Position := ScrollBarPosition;
    //  ScrollBarPosition := -1;
  end;

  //if a right click, highlight the row the right click took place on.
  if Button = mbRight then
  begin
    APoint.x := X;
    APoint.y := Y;
    with TListBox(Sender) do
    begin
      if ItemAtPos(APoint, True) <> -1 then
        ItemIndex := ItemAtPos(APoint, True);
      setfocus;
    end;
  end;
  ReDrawActivate(Handle);

  //  if ScrollBarPosition <> -1 then
  RepaintCoverSheet;
  ScrollBarPosition := -1;
end;                                    // lstGroupBoxesMouseDown

procedure TfrmCoverSheet.ActionCSMedHistoryExecute(Sender: TObject);
begin
  if SelectedOrder <> nil then
    MedicationHistoryReport(BCMA_Patient.IEN, SelectedOrder.OrderableItemIEN,
      SelectedOrder.OrderNumber);
end;

procedure TfrmCoverSheet.acRawOrderExecute(Sender: TObject);
begin
{$IFDEF CAS_DDPE_DEBUG}
  if SelectedOrder <> nil then
    MessageDlg(SelectedOrder.Raw, mtInformation, [mbOK], 0);
{$ENDIF}
end;

procedure TfrmCoverSheet.ActionCSAvailableBagsExecute(Sender: TObject);
var
  x: integer;
  msg: string;
  AvailableBags: TStringList;
begin
  if (SelectedOrder <> nil) and (SelectedOrder.OrderType = 'V') then
  begin
    AvailableBags := TStringList.Create;
    for x := 0 to AllAdmins.Count - 1 do
      if TCoverSheet_Admin(AllAdmins[x]).Order = SelectedOrder then
        with TCoverSheet_Admin(AllAdmins[x]) do
          if Action = 'A' then
            AvailableBags.Add(BagId);
    if AvailableBags.Count > 0 then
    begin
      msg := 'The following bags are available:' + #13 + #13;
      for x := 0 to AvailableBags.Count - 1 do
        msg := msg + AvailableBags[x] + #13;
    end
    else
      msg := 'No bags are available for this order!';
    DefMessageDlg(msg, mtInformation, [mbOk], 0);
  end;
end;

procedure TfrmCoverSheet.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  x: integer;
begin
  // if not onShow
  visible := false;
  SelectedOrder := nil;                 // rpk 4/6/2012

  for x := 0 to Length(grdCellData) - 1 do
    grdCellData[x].Free;

  with BCMA_UserParameters do
  begin
    CSMOSortColumn := CoverSheetSortColumns[TCoverSheetViews(csvMedOverView)];
    CSPRNSortColumn :=
      CoverSheetSortColumns[TCoverSheetViews(csvPRNAssessment)];
    CSIVSortColumn := CoverSheetSortColumns[TCoverSheetViews(csvIVOverView)];
    CSExSortColumn :=
      CoverSheetSortColumns[TCoverSheetViews(csvExpiringOrders)];
  end;

  CoverSheetOrders.Free;
  ExpiredCSOrders.Free;
  ActiveCSOrders.Free;
  FutureCSOrders.Free;
  AllAdmins.Free;
  AllComments.Free;

  //  for x := 0 to Length(CoverSheetViewTitles) - 1 do
  //    GroupBoxIndexes[x].free;
end;

procedure TFrmCoverSheet.lstGroupBoxesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
//var
//  HeaderRow: Boolean;
begin
  if Button = mbRight then
    exit;

  lstGroupBoxesCustomClick(Sender);

  // exit;  // exit was used to ignore following code which duplicated
            // lstGroupBoxesCustomClick

  //    MedOverViewItemIndex[TMedOverviewGroups(GetIndexOfListBox(TListBox(Sender)))] := TListBox(sender).ItemIndex;

  {SelectedItemIndex := TListBox(sender).ItemIndex;

  with Sender as TListBox do
    HeaderRow := Piece(Items[ItemIndex], '^', 3) = '1';
  with TListBox(Sender) do
    case cbxView.ItemIndex of
      0..1, 3:
        if (piece(Items[ItemIndex], '^', 1) = '1') and not HeaderRow then
          with TCoverSheet_Order(Items.Objects[ItemIndex]) do
          begin
            SelectedOrder := TCoverSheet_Order(Items.Objects[ItemIndex]);
            if Expanded = 0 then exit
            else if Expanded = 2 then Expanded := 1
            else Expanded := 2;
            case cbxView.ItemIndex of
              0:
                BuildMOGroup(Sender as TListBox);
              1:
                BuildPRNGroup(Sender as TListBox);
              2:
                BuildIVGroup(Sender as TListBox);
              3:
                BuildExGroup(Sender as TListBox);
            end;
          end
        else if (Piece(Items[ItemIndex], '^', 1) = '2') and not HeaderRow then
          with TCoverSheet_Admin((Sender as TListBox).Items.Objects[ItemIndex]) do
          begin
            if Expanded = 0 then exit
            else if Expanded = 2 then Expanded := 1
            else Expanded := 2;
            case cbxView.ItemIndex of
              0:
                BuildMOGroup(Sender as TListBox);
              1:
                BuildPRNGroup(Sender as TListBox);
              2:
                BuildIVGroup(Sender as TListBox);
              3:
                BuildExGroup(Sender as TListBox);
            end;
          end;
      2:
        if (Piece(Items[ItemIndex], '^', 1) = '1') and not HeaderRow then
          with TCoverSheet_Admin(Items.Objects[ItemIndex]) do
          begin
            if IVExpanded = 0 then exit
            else if IVExpanded = 2 then IVExpanded := 1
            else
            begin
              IVExpanded := 2;
              FetchIVBagDetail;
            end;
            BuildIVGroup(Sender as TListBox);
          end
        else if (Piece(Items[ItemIndex], '^', 1) = '2') and not HeaderRow then
          with TCoverSheet_Order(TCoverSheet_Admin(Items.Objects[ItemIndex]).Order) do
          begin
            if Expanded = 0 then exit
            else if Expanded = 2 then Expanded := 1
            else
            begin
              Expanded := 2;
              TCoverSheet_Admin(Items.Objects[ItemIndex]).FetchIVBagDetail;
            end;
            BuildIVGroup(Sender as TListBox);
          end;
    end;}

end;                                    // lstGroupBoxesMouseUp

procedure TFrmCoverSheet.lstGroupBoxesCustomClick(Sender: Tobject);
var
  HeaderRow: Boolean;
  RowIndex: Integer;
begin
  RowIndex := 0;                        // rpk 4/7/2009
  HeaderRow := False;                   // rpk 4/7/2009

  with TListBox(sender) do
    if ItemIndex > -1 then
    begin
      SelectedItemIndex := ItemIndex;
      HeaderRow := Piece(Items[ItemIndex], '^', 3) = '1';
      RowIndex := StrToInt(Piece(Items[ItemIndex], '^', 1));
    end;

  with TListBox(Sender) do
    if ItemIndex <> -1 then
      case cbxView.ItemIndex of
        0..1, 3:
          if (RowIndex = 1) and not HeaderRow then
            with TCoverSheet_Order(Items.Objects[ItemIndex]) do
            begin
              SelectedOrder := TCoverSheet_Order(Items.Objects[ItemIndex]);
              if Expanded = 0 then
                exit
              else if Expanded = 2 then
                Expanded := 1
              else
                Expanded := 2;
              case cbxView.ItemIndex of
                0:
                  BuildMOGroup(Sender as TListBox);
                1:
                  BuildPRNGroup(Sender as TListBox);
                2:
                  BuildIVGroup(Sender as TListBox);
                3:
                  BuildExGroup(Sender as TListBox);
              end;
            end
          else if (RowIndex = 2) and not HeaderRow then
            with TCoverSheet_Admin((Sender as TListBox).Items.Objects[ItemIndex])
              do
            begin
              if Expanded = 0 then
                exit
              else if Expanded = 2 then
                Expanded := 1
              else
                Expanded := 2;
              case cbxView.ItemIndex of
                0:
                  BuildMOGroup(Sender as TListBox);
                1:
                  BuildPRNGroup(Sender as TListBox);
                2:
                  BuildIVGroup(Sender as TListBox);
                3:
                  BuildExGroup(Sender as TListBox);
              end;
            end;
        2:
          if (RowIndex = 1) and not HeaderRow then
            with TCoverSheet_Admin(Items.Objects[ItemIndex]) do
            begin
              if IVExpanded = 0 then
                exit
              else if IVExpanded = 2 then
                IVExpanded := 1
              else
              begin
                IVExpanded := 2;
                FetchIVBagDetail;
              end;
              BuildIVGroup(Sender as TListBox);
            end
          else if (RowIndex = 2) and not HeaderRow then
            with
              TCoverSheet_Order(TCoverSheet_Admin(Items.Objects[ItemIndex]).Order)
              do
            begin
              if Expanded = 0 then
                exit
              else if Expanded = 2 then
                Expanded := 1
              else
              begin
                Expanded := 2;
                TCoverSheet_Admin(Items.Objects[ItemIndex]).FetchIVBagDetail;
              end;
              BuildIVGroup(Sender as TListBox);
            end;
      end;
  RepaintCoverSheet;
end;                                    // lstGroupBoxesCustomClick

procedure TFrmCoverSheet.lstGroupBoxesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ListBoxItem: TRect;
begin

  //allow scrolling via the Keyboard via Alt up and down arrow
  with sbxCoverSheet do
    if ((Shift = [ssAlt]) and (Key = VK_UP)) then
      VertScrollBar.position := VertScrollBar.Position - 7
    else if ((Shift = [ssAlt]) and (Key = VK_Down)) then
      VertScrollBar.position := VertScrollBar.Position + 7;

  if key = VK_UP then
    with TListBox(Sender) do
    begin
      ListBoxItem := ItemRect(ItemIndex);
      if Top < 0 then
        if (ListBoxItem.Top < abs(Top)) or (ListBoxItem.Top - abs(Top) <
          ItemHeight) then
          sbxCoverSheet.VertScrollBar.Position :=
            sbxCoverSheet.VertScrollBar.Position - ItemHeight;
      Repaint;
    end;

  if key = VK_DOWN then
    with TListBox(Sender) do
    begin
      ListBoxItem := ItemRect(ItemIndex);
      if ListBoxItem.Top + (ItemHeight * 2) + abs(Top) > sbxCoverSheet.Height
        then
        sbxCoverSheet.VertScrollBar.Position :=
          sbxCoversheet.VertScrollBar.Position + ItemHeight;
      //      RepaintCoverSheet;
    end;

  if (key = VK_RIGHT) or (key = VK_LEFT) then
  begin
    key := 0;
    lstGroupBoxesCustomClick(Sender);
  end;
end;                                    // lstGroupBoxesKeyDown

procedure TFrmCoverSheet.lstGroupBoxesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TListBox(Sender).Repaint;
end;                                    // lstGroupBoxesKeyUp

procedure TFrmCoverSheet.lstGroupBoxesExit(Sender: TObject);
begin
  (Sender as TListBox).ItemIndex := -1;
end;                                    // lstGroupBoxesExit

procedure TFrmCoverSheet.lstGroupBoxesEnter(Sender: TObject);
begin
  //  ReDrawSuspend(Handle);
  TListBox(Sender).ItemIndex := 0;
  //save the scrollbar position as the scrollinview functionality is going to move it
  ScrollBarPosition := sbxCoverSheet.VertScrollBar.Position;
  //  ReDrawActivate(Handle);
end;                                    // lstGroupBoxesEnter

{procedure TFrmCoverSheet.edtPnlGroupEnter(Sender: TObject);
begin
  with TPanel(TEdit(Sender).Parent) do
  begin
    BevelOuter := bvRaised;
    color := clSilver;
  end;
end; }

{procedure TFrmCoverSheet.edtPnlGroupExit(Sender: TObject);
begin
  with TPanel(TEdit(Sender).Parent) do
  begin
    BevelOuter := bvNone;
    color := clWhite;
  end;
end; }

procedure TfrmCoverSheet.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ActiveControl <> nil) and (ActiveControl.ClassType = TEdit) and ((key =
    VK_RIGHT) or (key = VK_LEFT)) then
  begin
    key := 0;
    pnlGroupClick(Sender);
  end;
end;

{procedure TfrmCoverSheet.edtPnlKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Sender.ClassType = TEdit) and ((key = VK_RIGHT) or (key = VK_LEFT)) then
  begin
    pnlGroupClick(TPanel(TEdit(Sender).Parent));
    TPanel(TEdit(Sender).Parent).Realign;
  end;
end;}

procedure TfrmCoverSheet.GrpExpCol(GroupNum: Integer);
begin
  case cbxView.ItemIndex of
    0:
      pnlGroupClick(pnlMOGroupPanels[GroupNum]);
    1:
      pnlGroupClick(pnlPRNGroupPanels[GroupNum]);
    2:
      pnlGroupClick(pnlIVGroupPanels[GroupNum]);
    3:
      pnlGroupClick(pnlExGroupPanels[GroupNum]);
  end;

end;

procedure TfrmCoverSheet.hdrCoverSheetSectionClick(HeaderControl:
  THeaderControl;
  Section: THeaderSection);
begin
  case TCoverSheetViews(cbxView.ItemIndex) of
    csvMedOverview:
      CoverSheetSortColumns[csvMedOverview] := Section.index;
    csvPRNAssessment:
      CoverSheetSortColumns[csvPRNAssessment] := Section.index;
    csvIVOverview:
      CoverSheetSortColumns[csvIVOverview] := Section.index;
    csvExpiringOrders:
      CoverSheetSortColumns[csvExpiringOrders] := Section.index;
  end;

  if CSSortType = stAscending then
    CSSortType := stDescending
  else if CSSortType = stDescending then
    CSSortType := stAscending;
end;

procedure TfrmCoverSheet.chkGridLinesClick(Sender: TObject);
begin
  RePaintCoverSheet;
end;

procedure TfrmCoverSheet.sbxCoverSheetMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  TScrollBox(Sender).VertScrollBar.Position :=
    TScrollBox(Sender).VertScrollBar.Position - 13;
end;

procedure TfrmCoverSheet.lstGroupBoxesMouseMove(Sender: TObject; Shift:
  TShiftState; X, Y: Integer);
var
//  tempWidth,
  idx, xx: integer;
  savwidth, sectwidth: Integer;
  APoint: TPoint;
  inListBox: TListBox;

  function SetHint: Boolean;
  var
    tmpHint: string;
    yy: Integer;
  begin
    Result := False;
//    if x > tempWidth - 3 then
//    else
//    begin
    if HintLastCell.X <> xx then
      application.CancelHint;

//      tmphint := grdCellData[(Sender as TListBox).tag].Cells[xx, (Sender as
//        TListBox).ItemAtPos(APoint, True)];

    // row in listbox
    yy := inListBox.ItemAtPos(APoint, True);
    if yy > -1 then
      tmphint := grdCellData[inListBox.tag].Cells[xx, yy]
    else
      tmphint := '';

    // the assumption is that Special Instructions / Other Print Info are the only
    // types of data that might be this long
    if Length(tmphint) > 180 then
      tmphint := CSTooMuchInfo;         // rpk 1/4/2012
//    (Sender as TListBox).Hint := tmphint;
    inListBox.Hint := tmphint;          // rpk 11/27/2012
    HintLastCell.X := xx;
    Result := True;
//    end;
  end;                                  // SetHint

begin                                   // lstGroupBoxesMouseMove
//  tempWidth := 0;
  savwidth := 0;

//  if (Sender as TListBox).Items.Count = 0 then
//    exit;

  if Sender is TListBox then begin
    inListBox := Sender as TListBox;
  end
  else
    exit;

  if inListBox.Items.Count = 0 then
    exit;

  APoint.x := x;
  APoint.Y := y;

  idx := inListBox.ItemAtPos(APoint, True);
  if (idx = -1) or (idx <> CurrentCSItem) then begin
    Application.CancelHint;
    inListBox.Hint := '';
  end;

//  if (Sender as TListBox).ItemAtPos(APoint, True) <> -1 then
  if idx <> -1 then begin
    if idx <> CurrentCSItem then
      CurrentCSItem := idx;

    case cbxView.ItemIndex of
//      0:
      ord(csvMedOverview):
        { for xx := 0 to length(MedOverviewColWidths) - 1 do
        begin
          // skip clinic column width in inpatient mode
//          if (OrderMode = omInpatient) and (xx = ord(cClinicName)) then
//            continue;
//          tempWidth := tempWidth +
//            MedOverviewColWidths[TMedOverviewColTypes(xx)];
          if (OrderMode = omInpatient) and (xx = ord(cClinicName)) then
            iwidth := 0
          else
            iwidth := MedOverviewColWidths[TMedOverviewColTypes(xx)];
          tempWidth := tempWidth + iwidth;
          if SetHint then
            Break;
        end; }
      // all headers will have same section widths; default to first one
        for xx := 0 to hdrMOGroupHeaders[0].Sections.Count - 1 do begin
          sectwidth := hdrMOGroupHeaders[0].Sections.Items[xx].Width;
          if (x > savwidth) and
            (x <= savwidth + sectwidth) then begin
            if xx <> HintLastCell.X then begin
              Application.CancelHint;
              inListBox.Hint := '';
            end;
            HintLastCell.X := xx;
            if SetHint then
              break;
          end;                          // if x
          savwidth := savwidth + sectwidth;
        end;                            // for

//      1:
      ord(csvPRNAssessment):
        { for xx := 0 to length(PRNAColWidths) - 1 do
        begin
          // skip clinic column width in inpatient mode
//          if (OrderMode = omInpatient) and (xx = ord(ctPRNClinicName)) then
//            continue;
//          tempWidth := tempWidth + PRNAColWidths[TPRNColTypes(xx)];
          if (OrderMode = omInpatient) and (xx = ord(cClinicName)) then
            iwidth := 0
          else
            iwidth := PRNAColWidths[TPRNColTypes(xx)];
          tempWidth := tempWidth + iwidth;
          if SetHint then
            Break;
        end; }
      // all headers will have same section widths; default to first one
        for xx := 0 to hdrPRNGroupHeaders[0].Sections.Count - 1 do begin
          sectwidth := hdrPRNGroupHeaders[0].Sections.Items[xx].Width;
          if (x > savwidth) and
            (x <= savwidth + sectwidth) then begin
            if xx <> HintLastCell.X then begin
              Application.CancelHint;
              inListBox.Hint := '';
            end;
            HintLastCell.X := xx;
            if SetHint then
              break;
          end;                          // if x
          savwidth := savwidth + sectwidth;
        end;                            // for

//      2:
      ord(csvIVOverview):
        { for xx := 0 to length(IVColWidths) - 1 do
        begin
          // skip clinic column width in inpatient mode
//          if (OrderMode = omInpatient) and (xx = ord(ctIVClinicName)) then
//            continue;
//          tempWidth := tempWidth + IVColWidths[TIVColTypes(xx)];
          if (OrderMode = omInpatient) and (xx = ord(cClinicName)) then
            iwidth := 0
          else
            iwidth := IVColWidths[TIVColTypes(xx)];
          tempWidth := tempWidth + iwidth;
          if SetHint then
            Break;
        end; }

      // all headers will have same section widths; default to first one
        for xx := 0 to hdrIVGroupHeaders[0].Sections.Count - 1 do begin
          sectwidth := hdrIVGroupHeaders[0].Sections.Items[xx].Width;
          if (x > savwidth) and
            (x <= savwidth + sectwidth) then begin
            if xx <> HintLastCell.X then begin
              Application.CancelHint;
              inListBox.Hint := '';
            end;
            HintLastCell.X := xx;
            if SetHint then
              break;
          end;                          // if x
          savwidth := savwidth + sectwidth;
        end;                            // for

//      3:
      ord(csvExpiringOrders):
        { for xx := 0 to length(ExColWidths) - 1 do
        begin
          // skip clinic column width in inpatient mode
//          if (OrderMode = omInpatient) and (xx = ord(ctExClinicName)) then
//            continue;
//          tempWidth := tempWidth + ExColWidths[TExpiredColTypes(xx)];
          if (OrderMode = omInpatient) and (xx = ord(cClinicName)) then
            iwidth := 0
          else
            iwidth := ExColWidths[TExpiredColTypes(xx)];
          tempWidth := tempWidth + iwidth;
          if SetHint then
            Break;
        end; }
      // all headers will have same section widths; default to first one
        for xx := 0 to hdrEXGroupHeaders[0].Sections.Count - 1 do begin
          sectwidth := hdrEXGroupHeaders[0].Sections.Items[xx].Width;
          if (x > savwidth) and
            (x <= savwidth + sectwidth) then begin
            if xx <> HintLastCell.X then begin
              Application.CancelHint;
              inListBox.Hint := '';
            end;
            HintLastCell.X := xx;
            if SetHint then
              break;
          end;                          // if x
          savwidth := savwidth + sectwidth;
        end;                            // for

    end;                                // case cbxView.ItemIndex
  end;

end;                                    // lstGroupBoxesMouseMove

procedure TfrmCoverSheet.ActionCSWhatsThisExecute(Sender: TObject);
begin
  with Application do
    if not HelpCommand(HELP_CONTEXT, 904) then // rpk 9/15/2010
      DefMessageDlg('Error accessing ' + application.helpfile, mtError, [mbOK],
        0);
end;

end.

