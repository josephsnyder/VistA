unit fSelectInjection;
{
================================================================================
*	File:  fSelectInjection.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 12 $  $Modtime: 5/02/02 2:37p $
*	Description:  This is a dialog for selecting from a list of reasons.
*
*
================================================================================
}
interface

uses
  BCMA_Objects, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls,
  VA508AccessibilityManager, VA508AccessibilityRouter;

function SelectFromInjectionList(aMedOrder: TBCMA_MedOrder; title: string;
  selectionList: TStringlist): string;
(*
  Uses form TfrmSelectInjection to display injection site history and conditionally
  prompt for user input via a combobox list.
  If selectionList is nil, it does not display the pnlSelInjSite which contains the
  selection list prompt and combobox.
*)

function SelectFromDermalList(aMedOrder: TBCMA_MedOrder; title: string;
  selectionList: TStringlist): string;
(*
  Uses form TfrmSelectInjection to display dermal site history and conditionally
  prompt for user input via a combobox list.
  If selectionList is nil, it does not display the pnlSelInjSite which contains the
  selection list prompt and combobox.
*)

type
  TfrmSelectInjection = class(TForm)
    pnlButton: TPanel;
    pnlSelInjSite: TPanel;
    cbxSelections: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    grpPrevBodySitesOrderItem: TGroupBox;
    lvwPrevBodySitesOrderItem: TListView;
    grpPrevBodySitesPatient: TGroupBox;
    lvwPrevBodySitesPatient: TListView;
    grpAckRoute: TGroupBox;
    chkAckRoute: TCheckBox;
    txtRoute: TStaticText;
    lblSelectCaption: TLabel;
    lblOrderableItem: TLabel;
    lblRoute: TLabel;
    lbSiteSelector: TListBox;
    pnlAckRoute: TPanel;
    lblSiteSelector: TLabel;
    pnlSiteSelector: TPanel;
    spbOld: TSpeedButton;
    spbNew: TSpeedButton;
    ckbAckRoute: TCheckBox;
    spbChart: TSpeedButton;
    bbSelectFromChart: TBitBtn;
    spbThree: TSpeedButton;
    pnlDebug: TPanel;
    pnlTools: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    ckbDebug: TCheckBox;
    SpeedButton7: TSpeedButton;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblOrderableItemText: TVA508StaticText;
    lblRouteText: TVA508StaticText;
    (*
      If an item has been selected from the list, modalResult is set to
      itemIndex + 100, closing the form.
    *)
    procedure btnOKClick(Sender: TObject);
    procedure cbxSelectionsClick(Sender: TObject);
    procedure chkAckRouteClick(Sender: TObject);
    procedure cbxSelectionsEnter(Sender: TObject);
    procedure spbOldClick(Sender: TObject);
    procedure ckbAckRouteClick(Sender: TObject);
    procedure bbSelectFromChartClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ckbDebugClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure lbSiteSelectorClick(Sender: TObject);
    procedure lbSiteSelectorEnter(Sender: TObject);
    procedure lvwPrevBodySitesOrderItemClick(Sender: TObject);
    procedure lvwPrevBodySitesPatientClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSelectInjection: TfrmSelectInjection;

implementation

uses
  BCMA_Main, BCMA_Startup, BCMA_Common, BCMA_Util,
//  MFunStr,
  Math, frmALMap,
  InputQry, fInfo;

{$R *.DFM}

var
//  isopen: Boolean;
//  lvwheight: Integer;
//  pnlselinjht: Integer;
  uMedOrder: TBCMA_MedOrder;
  CurSiteType: TSiteType;


// SiteAbbr: 'I'=Injection; 'D'=Dermal

function GetSiteList(PatientIEN, OrderNum, Duration, MaxSites, SiteAbbr: string;
  var SiteList: TStringList): Boolean;
var
  i, pcnt, idx: Integer;
  resstr, cntstr, lststr: string;
  FMTime: double;
  FMTimeStr, datetimestr, msgstr: string;
begin
  Result := False;

  if SiteList = nil then
    exit;

  try
    SiteList.Clear;

    with BCMA_Broker do begin
      if CallServer('PSB GETINJECTIONSITE', [patientIen, OrderNum, duration, maxsites, SiteAbbr], nil) then begin
        if Results.Count > 1 then begin
          cntstr := Results[0];
          for I := 1 to Results.Count - 1 do begin // rpk 11/3/2011
            resstr := Results[i];
            pcnt := PieceCnt(resstr, U);
            FMTimeStr := Piece(resstr, U, 1);
            // time = -1 indicates no available data
            if FMTimeStr = '-1' then begin
              msgstr := piece(resstr, U, 2);
              lststr := msgstr;
            end
            else begin
              FMTime := StrToFloat(FMTimeStr);
              datetimestr := FormatFMDateTime('MM/DD/YYYY@HH:NN', FMTime);
              lststr := datetimestr + U + pieces(resstr, '^' {UC}, 3, pcnt); // changing to '^' to remove declaration of UC from BCMA_Util aan 20150618
            end;

            idx := SiteList.Add(lststr);
            if idx > -1 then            // rpk 11/30/2011
              Result := True;

          end;                          // rpk 11/3/2011
        end;
      end;
    end;

  finally
    ;
  end;

end;                                    // GetSiteList

function PutSiteList(SiteList: TStringList; var LstVw: TListView): Boolean;
var
  i, j: Integer;
  icnt, pcnt: Integer;
  listrow, colstr: string;
  lstitem: TListItem;
begin
  Result := False;
  icnt := SiteList.Count;
  LstVw.Clear;

  for i := 0 to icnt - 1 do begin
    listrow := SiteList[i];
    colstr := Piece(listrow, U, 1);
    LstVw.AddItem(colstr, nil);
    lstitem := LstVw.items[i];
    pcnt := PieceCnt(listrow, U);
    for j := 2 to pcnt do begin
      colstr := Piece(listrow, U, j);
      lstitem.SubItems.Add(colstr);
    end;
    Result := True;
  end;                                  // for i

end;                                    // PutSiteList

function SelectFromInjectionList(aMedOrder: TBCMA_MedOrder;
  title: string;
  selectionList: TStringlist): string;
var
  ii, icnt: integer;
  OIList, PTList: TStringList;
  durstr, maxdurstr, maxinjstr: string;
  tbool: Boolean;
  cancelleft, okleft: Integer;
  LabelString: string;
{$IFDEF CAS_DDPE_TEST}
  casSL: TSTringList;
{$ENDIF}
begin
  result := '';
  CurSiteType := stInjection;
  LabelString := 'Select &Injection Site:';

  maxdurstr := '9999999';
  maxinjstr := '9999999';
  if aMedOrder = nil then
    Exit;

  OIList := nil;                        // rpk 3/5/2012
  PTList := nil;                        // rpk 3/5/2012
  frmSelectInjection := nil;            // rpk 9/16/2016

  durstr := BCMA_SiteParameters.InjSiteHistMaxHrs; // rpk 2/6/2012
  uMedOrder := aMedOrder;               // rpk 2/15/2012

{$IFDEF CAS_DDPE_TEST}
  { if selectionList = nil then
  begin
    casSL := TStringList.Create;
    casSL.Add('Tests selection list for CAS DDPE');
    casSL.Add('Tests value 1');
    casSL.Add('Tests value 2');
    casSL.Add('Tests value January');
    casSL.Add('Tests value February');
    casSL.Add('Tests value March');
    casSL.Add('Tests value April');
    casSL.Add('Tests value May');
    casSL.Add('Tests value June');
    casSL.Add('Tests value July');
    casSL.Add('Tests value August');
    casSL.Add('Tests value September');
    casSL.Add('Tests value October');
    casSL.Add('Tests value November');
    casSL.Add('Tests value December');
    selectionList := casSL;
  end; }
{$ENDIF}

//  frmSelectInjection := TfrmSelectInjection.Create(Application);
  Application.CreateForm(TfrmSelectInjection, frmSelectInjection); // rpk 9/16/2016
  try                                   // rpk 2/23/2012
    cancelleft := frmSelectInjection.btnCancel.Left;
    okleft := frmSelectInjection.btnOK.Left;
    // injection site list
    frmSelectInjection.lbSiteSelector.HelpContext := 207; // rpk 9/16/2016
    // if have a selection list, show the Cancel button
    if selectionList <> nil then begin
      frmSelectInjection.btnCancel.Show;
      case lstCurrentTab of
        // Specify_the_Injection_Site_for_the_Unit_Dose_Medication
        ctUD: frmSelectInjection.HelpContext := 129;
        // Specify_the_IVP_IVPB_Injection_Site
        ctPB: frmSelectInjection.HelpContext := 151;
      else
        frmSelectInjection.HelpContext := 129;
      end;
    end
    else begin
      // otherwise, hide the Cancel button and move the OK button over to the
      // Cancel position on the right side of the button panel.
      frmSelectInjection.btnCancel.Hide;
      frmSelectInjection.btnOK.Left := cancelleft;
      frmSelectInjection.btnOK.BringToFront;

      case lstCurrentTab of
        // Display_the_Injection_Site_for_the_Unit_Dose_Medication
        ctUD: frmSelectInjection.HelpContext := 452;
        // Display_the_Injection_Site_for_the_IVP_IVPB_Medication
        ctPB: frmSelectInjection.HelpContext := 450;
      else
        frmSelectInjection.HelpContext := 452;
      end;
    end;

    OILIst := TStringList.Create;
    PTList := TStringList.Create;
    if (OIList <> nil) and (PTList <> nil) then begin
      with aMedOrder do begin
        // 'I' for injection sites
        tbool := GetSiteList(PatientIEN, OrderableItemIEN, maxdurstr, '4', 'I', OIList); // rpk 2/7/2012
        tbool := GetSiteList(PatientIEN, '', durstr, maxinjstr, 'I', PTList);

        with frmSelectInjection do begin
          lblOrderableItemText.Caption := ActiveMedication;
          lblRouteText.Caption := Route; // rpk 3/13/2012
          lblSelectCaption.Caption := LabelString;
          caption := title;
          grpPrevBodySitesPatient.Caption :=
            '&All Injection Sites (within last ' + durstr + ' hours)'; // rpk 2/28/2012

          PutSiteList(OIList, lvwPrevBodySitesOrderItem);
          PutSiteList(PTList, lvwPrevBodySitesPatient);

          if selectionlist = nil then begin
            // if selectionlist is nil we are displaying only the injection site
            // history.  we want to shorten the select injection site panel in
            // this case and cause the lvwPrevInjSitesPatient to expand since it
            // and its parent groupbox are alClient.
            pnlSelInjSite.Hide;

            pnlSelInjSite.Height := 0;  // rpk 2/13/2012
            btnOK.Enabled := True;      // rpk 2/13/2012
          end
          else begin
            pnlSelInjSite.Show;
            icnt := PopulateSiteList(selectionList, lbSiteSelector.Items, stInjection, True);
{$IFDEF CAS_DDPE_TEST}
            casSL := TStringList.Create;
            casSL.Text := selectionList.Text + #13#10 +
              selectionList.Text + #13#10 +
              selectionList.Text + #13#10 +
              selectionList.Text + #13#10
              ;
            spbOld.Visible := True;
            spbNew.Visible := True;
            spbChart.Show;
            spbThree.Show;
{$ENDIF}
            // disable the OK button until an entry in the injection list
            // is selected.
            btnOK.Enabled := False;     // rpk 2/13/2012

            // display the groupbox containing the acknowledge checkbox and route only
            // if we are on the IVP/IVPB tab and the flag for display injection
            // history on IVP/IVPB is set  rpk 2/15/2012
            if (InjOnPb and (lstCurrentTab = ctPB)) then begin
              pnlAckRoute.Show;         //CAS_DDPE_TEST
              txtRoute.Caption := Route;
            end
            else
              pnlAckRoute.Hide;         //CAS_DDPE_TEST
          end;

          // rpk 2/15/2012
          frmSelectInjection.height := min(frmSelectInjection.height, Screen.WorkAreaHeight);
          frmSelectInjection.width := min(frmSelectInjection.width, Screen.WorkAreaWidth);

          if frmSelectInjection.Visible then
            frmSelectInjection.Hide;
          ii := frmSelectInjection.showModal;

          if (selectionlist <> nil) and (ii <> mrCancel) then
//            result := selectionList[ii - 100];
            result := GetSite(lbSiteSelector.Items[ii - 100]); // rpk 10/19/2015
          if selectionList <> nil then
            frmSelectInjection.btnOK.Left := okleft;
        end;                            // with frmSelectInjection
      end;                              // with aMedOrder
    end;                                // if OIList, PTList
  finally
    frmSelectInjection.lvwPrevBodySitesOrderItem.Clear;
    frmSelectInjection.lvwPrevBodySitesPatient.Clear;

    frmSelectInjection.Release;         // rpk 6/18/2013
//    FreeAndNil(frmSelectInjection);         // rpk 4/25/2016

    if OIList <> nil then
      OIList.Free;
    if PTList <> nil then
      PTList.Free;

{$IFDEF CAS_DDPE_TEST}
    if assigned(casSL) then
      freeAndNil(casSL);
{$ENDIF}
  end;
end;                                    // SelectFromInjectionList

function SelectFromDermalList(aMedOrder: TBCMA_MedOrder;
  title: string;
  selectionList: TStringlist): string;
var
  ii, icnt: integer;
  OIList, PTList: TStringList;
  durstr, durhrsstr, maxdurstr, maxinjstr: string;
  tbool: Boolean;
  cancelleft, okleft: Integer;
  LabelString: string;
  idurdays, idurhours: Integer;
{$IFDEF CAS_DDPE_TEST}
  casSL: TSTringList;
{$ENDIF}
begin
  result := '';
  CurSiteType := stDermal;
  LabelString := 'Select &Dermal Site:';

  maxdurstr := '9999999';
  maxinjstr := '9999999';
  if aMedOrder = nil then
    Exit;

  OIList := nil;                        // rpk 3/5/2012
  PTList := nil;                        // rpk 3/5/2012
  frmSelectInjection := nil;            // rpk 9/16/2016

  durstr := BCMA_SiteParameters.DermSiteHistMaxDays; // rpk 11/5/2015
  idurdays := StrToIntDef(durstr, 0);   // rpk 11/5/2015
  idurhours := idurdays * 24;           // rpk 11/5/2015
  durhrsstr := IntToStr(idurhours);     // rpk 11/5/2015

  uMedOrder := aMedOrder;               // rpk 2/15/2012

//  frmSelectInjection := TfrmSelectInjection.Create(Application);
  Application.CreateForm(TfrmSelectInjection, frmSelectInjection); // rpk 9/14/2016
  try                                   // rpk 2/23/2012
    frmSelectInjection.grpPrevBodySitesOrderItem.caption := '&Previous Dermal Sites for this Medication (up to 4)';
    frmSelectInjection.lvwPrevBodySitesOrderItem.Columns[4].Caption := 'Dermal Site';
    frmSelectInjection.grpPrevBodySitesPatient.Caption := '&All Dermal Sites';
    frmSelectInjection.lvwPrevBodySitesPatient.Columns[4].Caption := 'Dermal Site';
    cancelleft := frmSelectInjection.btnCancel.Left;
    okleft := frmSelectInjection.btnOK.Left;
    // dermal site list
    frmSelectInjection.lbSiteSelector.HelpContext := 39; // rpk 9/16/2016
    // if have a selection list, show the Cancel button
    if selectionList <> nil then begin
      frmSelectInjection.btnCancel.Show;
//      case lstCurrentTab of
        // Specify_the_Dermal_Site_for_the_Unit_Dose_Medication
//        ctUD: frmSelectInjection.HelpContext := 145;  // rpk 9/14/2016
        // Specify_the_IVP_IVPB_Injection_Site
//        ctPB: frmSelectInjection.HelpContext := 151;
//      else
        // Specify_the_Dermal_Site_for_the_Unit_Dose_Medication
      frmSelectInjection.HelpContext := 145; // rpk 9/14/2016
//      end;
    end
    else begin
      // otherwise, hide the Cancel button and move the OK button over to the
      // Cancel position on the right side of the button panel.
      frmSelectInjection.btnCancel.Hide;
      frmSelectInjection.btnOK.Left := cancelleft;
      frmSelectInjection.btnOK.BringToFront;

//      case lstCurrentTab of
        // Display_the_Dermal_Site_for_the_Unit_Dose_Medication
//        ctUD: frmSelectInjection.HelpContext := 49;  // rpk 9/14/2016
        // Display_the_Injection_Site_for_the_IVP_IVPB_Medication
//        ctPB: frmSelectInjection.HelpContext := 450;
//      else
        // Display_the_Dermal_Site_for_the_Unit_Dose_Medication
      frmSelectInjection.HelpContext := 49; // rpk 9/14/2016
//      end;
    end;

    OILIst := TStringList.Create;
    PTList := TStringList.Create;
    if (OIList <> nil) and (PTList <> nil) then begin
      with aMedOrder do begin
        // 'D' for dermal sites
        tbool := GetSiteList(PatientIEN, OrderableItemIEN, maxdurstr, '4', 'D', OIList); // rpk 2/7/2012
        tbool := GetSiteList(PatientIEN, '', durhrsstr, maxinjstr, 'D', PTList); // rpk 11/5/2015

        with frmSelectInjection do begin
          lblOrderableItemText.Caption := ActiveMedication;
          lblRouteText.Caption := Route; // rpk 3/13/2012
          lblSelectCaption.Caption := LabelString;
          lblSiteSelector.Caption := LabelString;
          caption := title;
          grpPrevBodySitesPatient.Caption :=
            '&All Dermal Sites (within last ' + durhrsstr + ' hours)'; // rpk 12/21/2015

          PutSiteList(OIList, lvwPrevBodySitesOrderItem);
          PutSiteList(PTList, lvwPrevBodySitesPatient);

          if selectionlist = nil then begin
            // if selectionlist is nil we are displaying only the injection site
            // history.  we want to shorten the select injection site panel in
            // this case and cause the lvwPrevInjSitesPatient to expand since it
            // and its parent groupbox are alClient.
            pnlSelInjSite.Hide;

            pnlSelInjSite.Height := 0;  // rpk 2/13/2012
            btnOK.Enabled := True;      // rpk 2/13/2012
          end
          else begin
            pnlSelInjSite.Show;
            icnt := PopulateSiteList(selectionList, lbSiteSelector.Items, stDermal, True); // rpk 10/16/2015
{$IFDEF CAS_DDPE_TEST}
            casSL := TStringList.Create;
            casSL.Text := selectionList.Text + #13#10 +
              selectionList.Text + #13#10 +
              selectionList.Text + #13#10 +
              selectionList.Text + #13#10
              ;
            spbOld.Visible := True;
            spbNew.Visible := True;
            spbChart.Show;
            spbThree.Show;
{$ENDIF}
            // disable the OK button until an entry in the injection list
            // is selected.
            btnOK.Enabled := False;     // rpk 2/13/2012

            // display the groupbox containing the acknowledge checkbox and route only
            // if we are on the IVP/IVPB tab and the flag for display injection
            // history on IVP/IVPB is set  rpk 2/15/2012
            if (InjOnPb and (lstCurrentTab = ctPB)) then begin
              pnlAckRoute.Show;         //CAS_DDPE_TEST
              txtRoute.Caption := Route;
            end
            else
              pnlAckRoute.Hide;         //CAS_DDPE_TEST
          end;

          // rpk 2/15/2012
          frmSelectInjection.height := min(frmSelectInjection.height, Screen.WorkAreaHeight);
          frmSelectInjection.width := min(frmSelectInjection.width, Screen.WorkAreaWidth);

          if frmSelectInjection.Visible then
            frmSelectInjection.Hide;
          ii := frmSelectInjection.showModal;

          if (selectionlist <> nil) and (ii <> mrCancel) then
//            result := selectionList[ii - 100];
            result := GetSite(lbSiteSelector.Items[ii - 100]); // rpk 10/19/2015
          if selectionList <> nil then
            frmSelectInjection.btnOK.Left := okleft;
        end;                            // with frmSelectInjection
      end;                              // with aMedOrder
    end;                                // if OIList, PTList
  finally
    frmSelectInjection.lvwPrevBodySitesOrderItem.Clear;
    frmSelectInjection.lvwPrevBodySitesPatient.Clear;

    frmSelectInjection.Release;         // rpk 6/18/2013
//    FreeAndNil(frmSelectInjection);         // rpk 4/25/2016

    if OIList <> nil then
      OIList.Free;
    if PTList <> nil then
      PTList.Free;

{$IFDEF CAS_DDPE_TEST}
    if assigned(casSL) then
      freeAndNil(casSL);
{$ENDIF}
  end;
end;                                    // SelectFromDermalList

procedure TfrmSelectInjection.bbSelectFromChartClick(Sender: TObject);
const
  pnBodySites = 'PSB LIST BODY SITES';  // copied from uCAS_ALUtils
var
  divisionstr, SelectedSite: string;
begin
  BCMA_Broker.CallServer('PSB PARAMETER', ['GETDIV', BCMA_User.DivisionIEN], nil);
  if piece(BCMA_Broker.Results[0], '^', 1) = '-1' then
    MessageDlg(piece(BCMA_Broker.Results[0], '^', 2), mtError, [mbOK], 0)
  else
  begin
    divisionstr := piece(BCMA_Broker.Results[0], '^', 2);
    SelectedSite := SelectAnatomicalLocation(divisionstr, pnBodySites, CurSiteType);
    if SelectedSite > '' then begin
      lbSiteSelector.ItemIndex := lbSiteSelector.Items.IndexOf(SelectedSite);
      lbSiteSelectorClick(lbSiteSelector);
      btnOK.Click;                      // rpk 9/28/2016
    end;
  end;
end;

procedure TfrmSelectInjection.btnOKClick(Sender: TObject);
begin
  with lbSiteSelector do
    if itemIndex > -1 then
      modalResult := 100 + itemIndex;
end;                                    // btnOKClick

procedure TfrmSelectInjection.cbxSelectionsClick(Sender: TObject);
begin
  if pnlSelInjSite.Visible then begin
    if (uMedOrder <> nil) and
      (uMedOrder.InjOnPb and
      (lstCurrentTab = ctPB) and
      (cbxSelections.ItemIndex > -1)) then begin
      btnOK.Enabled := chkAckRoute.Checked and (cbxSelections.ItemIndex > -1);
    end
    else
      btnOK.Enabled := cbxSelections.ItemIndex > -1;
  end;
end;

procedure TfrmSelectInjection.cbxSelectionsEnter(Sender: TObject);
begin
  { case lstcurrenttab of
    ctUD: cbxSelections.HelpContext := 129;
    ctPB: cbxSelections.HelpContext := 151;
  else
    cbxSelections.HelpContext := 129;
  end; }
end;

procedure TfrmSelectInjection.chkAckRouteClick(Sender: TObject);
begin
  btnOK.Enabled := chkAckRoute.Checked and (cbxSelections.ItemIndex > -1);
end;

procedure TfrmSelectInjection.ckbAckRouteClick(Sender: TObject);
begin
  pnlAckRoute.Visible := ckbAckRoute.Checked;
end;

procedure TfrmSelectInjection.ckbDebugClick(Sender: TObject);
begin
  pnlDebug.Visible := ckbDebug.Checked;
end;

procedure TfrmSelectInjection.lbSiteSelectorClick(Sender: TObject);
begin
  if pnlSelInjSite.Visible then begin
    if (uMedOrder <> nil) and
      (uMedOrder.InjOnPb and
      (lstCurrentTab = ctPB) and
      (lbSiteSelector.ItemIndex > -1)) then begin
      btnOK.Enabled := chkAckRoute.Checked and (lbSiteSelector.ItemIndex > -1);
    end
    else
      btnOK.Enabled := lbSiteSelector.ItemIndex > -1;
  end;
end;

procedure TfrmSelectInjection.lbSiteSelectorEnter(Sender: TObject);
begin
  { case lstcurrenttab of
    ctUD: lbSiteSelector.HelpContext := 129;
    ctPB: lbSiteSelector.HelpContext := 151;
  else
    lbSiteSelector.HelpContext := 129;
  end; }
  case CurSiteType of                   // rpk 9/16/2016
    stInjection: lbSiteSelector.HelpContext := 207; // rpk 9/16/2016
    stDermal: lbSiteSelector.HelpContext := 39; // rpk 9/16/2016
  end;                                  // rpk 9/16/2016
end;

procedure TfrmSelectInjection.lvwPrevBodySitesOrderItemClick(Sender: TObject);
var
  str: string;
begin
  str := getLvwRow(Sender as TListView);
  if ScreenReaderSystemActive then
    GetScreenReader.Speak(str);
end;

procedure TfrmSelectInjection.lvwPrevBodySitesPatientClick(Sender: TObject);
var
  str: string;
begin
  str := getLvwRow(Sender as TListView);
  if ScreenReaderSystemActive then
    GetScreenReader.Speak(str);
end;

procedure TfrmSelectInjection.spbOldClick(Sender: TObject);
begin
  lblSelectCaption.Visible := spbOld.Down or spbChart.Down;
  cbxSelections.Visible := spbOld.Down or spbChart.Down;
  lblSiteSelector.Visible := spbNew.Down or spbThree.Down;
  lbSiteSelector.Visible := spbNew.Down or spbThree.Down;
  bbSelectFromChart.Visible := spbChart.Down or spbThree.Down;
  if spbThree.Down then
    bbSelectFromChart.Top := 2
  else
    bbSelectFromChart.Top := 28;

end;

procedure TfrmSelectInjection.SpeedButton1Click(Sender: TObject);
var
  s: string;
  b: boolean;
begin
  s := inputPrompt('Window Caption Edit', 'Enter New value of Caption', Caption,
    80, false, false, otNone, b, '', False);
  if s <> '' then
    Caption := s;
end;

procedure TfrmSelectInjection.SpeedButton2Click(Sender: TObject);
var
  s: string;
  b: boolean;
begin
  s := inputPrompt('Group 1 Caption Edit', 'Enter New value of Caption', grpPrevBodySitesOrderItem.Caption,
    80, false, false, otNone, b, '', False);
  if s <> '' then
    grpPrevBodySitesOrderItem.Caption := s;
end;

procedure TfrmSelectInjection.SpeedButton3Click(Sender: TObject);
var
  s: string;
  b: boolean;
begin
  s := inputPrompt('Group 2 Caption Edit', 'Enter New value of Caption', grpPrevBodySitesPatient.Caption,
    80, false, false, otNone, b, '', False);
  if s <> '' then
    grpPrevBodySitesPatient.Caption := s;
end;

procedure TfrmSelectInjection.SpeedButton4Click(Sender: TObject);
var
  s: string;
  b: boolean;
begin
  s := inputPrompt('Group 1 Caption Edit', 'Enter New value of Caption', lblSelectCaption.Caption,
    80, false, false, otNone, b, '', False);
  if s <> '' then
  begin
    lblSiteSelector.Caption := s;
    lblSelectCaption.Caption := s;
  end;
end;

procedure TfrmSelectInjection.SpeedButton5Click(Sender: TObject);
var
  i: integer;
  s: string;
begin
  s := '';
  for I := 0 to lvwPrevBodySitesOrderItem.Columns.Count - 1 do
    s := s + lvwPrevBodySitesOrderItem.Columns[i].Caption + #13#10;
  if ShowInfo(s) = mrOK then
    for I := 0 to lvwPrevBodySitesOrderItem.Columns.Count - 1 do
      lvwPrevBodySitesOrderItem.Columns[i].Caption := frmInfo.mmInfo.Lines[i];
end;

procedure TfrmSelectInjection.SpeedButton6Click(Sender: TObject);
var
  i: integer;
  s: string;
begin
  s := '';
  for I := 0 to lvwPrevBodySitesPatient.Columns.Count - 1 do
    s := s + lvwPrevBodySitesPatient.Columns[i].Caption + #13#10;
  if ShowInfo(s) = mrOK then
    for I := 0 to lvwPrevBodySitesPatient.Columns.Count - 1 do
      lvwPrevBodySitesPatient.Columns[i].Caption := frmInfo.mmInfo.Lines[i];
end;

procedure TfrmSelectInjection.SpeedButton7Click(Sender: TObject);
begin
  ckbDebug.Checked := not ckbDebug.Checked;
  ckbDebugClick(nil);
end;

initialization
  SpecifyFormIsNotADialog(TfrmSelectInjection);

end.

