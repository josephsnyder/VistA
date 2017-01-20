unit MultOrder;
{
================================================================================
*	File:  MultOrder.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 20 $  $Modtime: 5/06/02 10:20a $
*
*	Description:  This is the form for displaying multiple orders for a given
*								scanned dispensed drug for the application.  The form will
*               resize itself at creation time, according to the number of
*               lines and the length of the longest line in the listbox.
*
*	Notes: Set hdrMultOrder Enabled to True to allow resizing of columns.
*        Change column draw procedures to use enumerated types for outtext at end
*        per bcma_main update.
*        Check for consistency with hdrUnitDose, lstUnitDose, and sgUnitDose on main form
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Grids, ComCtrls, BCMA_Util,
  VA508AccessibilityManager, VA508AccessibilityRouter, ImgList;

const
  MAXCHARS = 110;
  MINCHARS = 30;
  MAXLINES = 40;
  MINLINES = 5;

type
  TfrmMultOrder = class(TForm)
    pnlOrderItem: TPanel;
    pnlButton: TPanel;
    hdrMultiOrder: THeaderControl;
    btnCancel: TButton;
    btnOK: TButton;
    lstMultiOrder: TListBox;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblDispensedDrug: TVA508StaticText;
    lblDispensedDrugCaption: TLabel;
    lblSelectOrder: TLabel;
    grdMultiOrder: TStringGrid;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    ImageList1Sav: TImageList;
    procedure FormShow(Sender: TObject);
    (*
      Sets the initial size of the form according to the number of lines and
      the length of the longest line of text in the report.
    *)

    procedure btnOKClick(Sender: TObject);
    (*
      If a list item has been selected, modalResult is set to ItemIndex + 100,
      thus closing the form.
    *)

    procedure pnlButtonResize(Sender: TObject);
    (*
      Resets the positions of the OK and Cancel buttons whenever the form
      is resized, to ensure that they will always be visible.
    *)

//    procedure lbxScannedOrdersEnter(Sender: TObject);
//    {
//      Enables the OK button, since an item has now been selected from the list.
//    }

//    procedure sgMultOrderEnter(Sender: TObject);
//    {
//    }

    procedure lstMultiOrderMeasureItem(Control: TWinControl;
      Index: Integer; var Height: Integer);
    {
      Called to calculate the height of each row
    }

    procedure lstMultiOrderDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    {
      Draws the data on the canvas including the gridlines
    }

    procedure hdrMultiOrderSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    {
      When a headersection is resized, recalculate the max size of each headersection,
      and re-paint lstMultiOrder with the new column sizes.
    }

    procedure lstMultiOrderClick(Sender: TObject);
    {
      if an item is selected, enable the OK button.
    }
    procedure grdMultiOrderDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdMultiOrderSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure grdMultiOrderEnter(Sender: TObject);
    procedure VA508ComponentAccessibility1ValueQuery(Sender: TObject;
      var Text: string);
    procedure grdMultiOrderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    {procedure VA508ComponentAccessibility1ItemQuery(Sender: TObject;
      var Item: TObject);}

  private
    { Private declarations }
  public
    { Public declarations }
    // enable creating procedure to pass in the string list which can be used
    // to rebuild the lstMultiOrder listbox.
    // this enables measureitem to re-calculate row height and reset ordertootall
    // based on current width of column.
    moList: TStringList;
//    multHdrMinWidth: Integer;
  end;

var
  frmMultOrder: TfrmMultOrder;
//  ItemsHeight: Integer;

implementation

{$R *.DFM}

uses
  Math, BCMA_Common, BCMA_Objects, BCMA_Main, BCMA_Startup,
//  MFunStr,
  uCAS_Utils;

var
  SelectedX, SelectedY: Integer;

procedure TfrmMultOrder.FormCreate(Sender: TObject);
begin
  moList := TStringList.Create;         // rpk 1/20/2012
end;

procedure TfrmMultOrder.FormDestroy(Sender: TObject);
begin
  if moList <> nil then
    moList.Destroy;                     // rpk 1/20/2012
end;

procedure TfrmMultOrder.FormShow(Sender: TObject);
begin
  with self do begin
    width := frmmain.Width - 20;
    height := frmmain.Height div 2;
  end;
  if tag = 0 then
    btnCancel.setFocus
  else begin
    btnCancel.Visible := false;
    btnOk.Enabled := True;
    btnOk.Left := btnCancel.Left;
  end;

        if {$IFDEF CAS_508_DEBUG}(CAS_508 = 'ON') or
{$ENDIF}ScreenReaderSystemActive then begin
//  if ScreenReaderSystemActive then begin // rpk 9/6/2010
    lstMultiOrder.SendToBack;
    lstMultiOrder.Hide;
    hdrMultiOrder.Hide;
    lstMultiOrder.TabStop := False;
    lblSelectOrder.FocusControl := grdMultiOrder; // rpk 10/16/2012
    grdMultiOrder.TabStop := True;
    grdMultiOrder.Align := alClient;
    grdMultiOrder.BringToFront;
    grdMultiOrder.Show;
    grdMultiOrder.Repaint;
  end
  else begin
    grdMultiOrder.SendToBack;
    grdMultiOrder.Hide;
    grdMultiOrder.TabStop := False;
    lblSelectOrder.FocusControl := lstMultiOrder; // rpk 10/16/2012
    lstMultiOrder.TabStop := True;
    hdrMultiOrder.Show;
    hdrMultiOrder.Repaint;
    lstMultiOrder.Align := alClient;
    hdrMultiOrderSectionResize(hdrMultiOrder, hdrMultiOrder.Sections[0]);
    lstMultiOrder.BringToFront;
    lstMultiOrder.Show;
    lstMultiOrder.Repaint;

  end;
end;

procedure TfrmMultOrder.grdMultiOrderClick(Sender: TObject);
begin
  if grdMultiOrder.Row > 0 then
    btnOk.Enabled := True;
end;

//
// add Witness column before active medication
//

procedure TfrmMultOrder.grdMultiOrderDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  x,
    ii,
//    CellRight,
  TempHeight,
    CurrentTop,
//    TitleCount,
  Index: integer;
  TextString, si_txt: string;
  CurrentFontColor: TColor;
  ARect: TRect;
  OutText: string;
  MO_tmp: TBCMA_MedOrder;
  OvrRect: TRect;                       // rpk 1/14/2011
  SIOPIText: string;                    // rpk 1/12/2012
  NextAction, NextDT: String;           // rpk 8/4/2015
  isLate: Boolean;                      // rpk 8/17/2015
begin
//  if (ARow = 0) or (ACol = 0) or (ARow > VisibleMedList.Count) then
  if (ARow = 0) or (ARow > VisibleMedList.Count) then
    Exit;

  // avoid repetitive drawing once cell is filled.
  if grdMultiOrder.Cells[ACol, ARow] <> '' then
    Exit;

  //
  // Todo: add cr-lfs to format long lines as multiple lines.
  //
  Index := ARow - 1;
  si_txt := '';
  ARect := Rect;
  TempHeight := 0;

  if VisibleMedList.Count > 0 then
    with grdMultiOrder do begin
      outputDebugString(PChar(IntToStr(Arect.Bottom - Arect.Top)));

      CurrentFontColor := Canvas.Font.Color;

      MO_tmp := TBCMA_MedOrder(VisibleMedList[StrToInt(lstMultiOrder.items[ARow - 1])]); // rpk 8/12/2011

      //
      // on Provider Hold
      //
      if (MO_tmp.OrderStatus = 'H') and not
        (gdSelected in State) then
        Canvas.Brush.Color := $00DDDDDD;

//      x := ACol;
      x := ACol - 1;

//      if x > 0 then
      if x >= 0 then
        ARect.Left := ARect.Right + 2
      else
        ARect.Left := 2;

      TextString := '';
      OutText := '';

      with MO_tmp do
        case x of
//          0: begin // Active Medication row title
          -1: begin                     // Active Medication row title
//          1: begin
//              CurrentTop := ARect.Top;
              TextString := ActiveMedication;
              grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 9/24/2009
              ARect.Left := ARect.Left + 7;
            end;

          0: begin                      // ctclinicname, pbclinicname, ivclinicname  rpk 5/14/2012
              OutText := ClinicName;
            end;

          1:                            // ctscanstatus, pbscanstatus, ivorderstatus
            case lstCurrentTab of
              ctUD, ctPB:
              // DEBUG Provider Hold
                if (MO_tmp.OrderStatus = 'H') then
                  OutText := '(PH), ' + ScanStatus
                else
                  OutText := ScanStatus;
              ctIV:
                OutText := GetOrderStatus(OrderStatus);
            end;
          2: begin                      // ctverifynurse, pbverifynurse, ivverifynurse
//          3: begin // ctverifynurse, pbverifynurse, ivverifynurse
              OutText := '';            // rpk 8/16/2011

              if OvrIntvent then begin
                OvrRect := aRect;
              // adjust sides to fill to edge of cell.
                OvrRect.Left := OvrRect.Left - 4;
                OvrRect.Right := OvrRect.Right + 1;
                OvrRect.Bottom := OvrRect.Bottom - 1;

                with Canvas do begin
                  Brush.Color := $00FFFF; // bright yellow
                  Font.Color := clBlack;
                  Brush.Style := bsSolid;
                  FillRect(OvrRect);
                end;                    // with Canvas
                // DEBUG ONLY
                // OutText := 'OI:';
              end;                      // if OvrIntvent

              if VerifyNurse = '***' then begin
                Canvas.Font.Style := [fsBold];
              end;
              OutText := VerifyNurse;
//              OutText := OutText + VerifyNurse;  // rpk 8/16/2011
            end;

          3:                            // ctselfmed, pbschedtype, ivtype
//          4: // ctselfmed, pbschedtype, ivtype
            case lstCurrentTab of
              ctUD:
                OutText := SelfMed;
              ctPB:
                OutText := ScheduleType;
              ctIV:
                OutText := GetIVType(AdministrationUnit);
            end;

          4: begin                      // ctschedtype, pbwitness, ivwitness
//          5: begin // ctschedtype, pbwitness, ivwitness
              case lstCurrentTab of
                ctUD:
                  OutText := ScheduleType;
                ctPB, ctIV:
                  if WitnessFlag = WITNESS_REQUIRED then
//                    ImageList1.Draw(Canvas, ARect.Left - 2, ARect.Top, 2);
                    OutText := 'Witness Required'
                  else if WitnessFlag = WITNESS_RECOMMENDED then // rpk 10/15/2012
                    OutText := 'Witness Recommended';
              end;
            end;

          5:                            // ctwitness, pbmedicationsolution, ivmedicationsolution
//          6: // ctwitness, pbmedicationsolution, ivmedicationsolution
            case lstCurrentTab of
              ctUD:
{$IFDEF CAS_DDPE_RST}                   // v.3.0.83.21 -- aan 20150709
                OutText :=
                  getOrderAlertText(mo_Tmp, frmMain.acNextActionWithDate.Checked);
{$ELSE}
//                OutText := ScheduleType;
                if WitnessFlag = WITNESS_REQUIRED then
                  OutText := 'Witness Required'
                else if WitnessFlag = WITNESS_RECOMMENDED then // rpk 10/15/2012
                  OutText := 'Witness Recommended';
{$ENDIF}
              ctPB, ctIV: begin
                  CurrentTop := ARect.Top;
                  TextString := ActiveMedication;
                  grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 9/24/2009
                  // put active medication in first column to identify row
//                  grdMultiOrder.Cells[0, ARow] := TextString; // rpk 9/24/2009
                  ARect.Left := ARect.Left + 7;


                  if OrderTypeID = otUnitDose then begin
                    for ii := 0 to OrderedDrugCount - 1 do begin
                      ARect.Top := ARect.Top + TempHeight;
                      TextString := OrderedDrugs[ii].Name;
                      if TextString > '' then begin
                        grdMultiOrder.Cells[ACol, ARow] :=
                          grdMultiOrder.Cells[ACol, ARow] + ', ' + TextString;
                        // rpk 9/24/2009
                      end;
                    end;
                  end
                  else begin
                    for ii := 0 to AdditiveCount - 1 do begin
                      ARect.Top := ARect.Top + TempHeight;
                      TextString := piece(Additives[ii], '^', 3) +
                        ' ' +
                        piece(Additives[ii], '^', 4) + ' ' +
                        piece(Additives[ii], '^', 5);
                      if Trim(TextString) > '' then begin
                        grdMultiOrder.Cells[ACol, ARow] :=
                          grdMultiOrder.Cells[ACol, ARow] + ', ' + TextString;
                        // rpk 9/24/2009
                      end;
                    end
                  end;                  // else not unit dose

                  if OrderTooTall then begin
                    ARect.Top := ARect.Top + TempHeight;
                    Canvas.Font.Color := clRed;
                    Canvas.Font.Style := [fsbold];
                    grdMultiOrder.Cells[ACol, ARow] := ErrRowTooTall;
                  end
                  else begin
                    ARect.Top := ARect.Top + TempHeight;
                    Canvas.Font.Color := clRed;
                    Canvas.Font.Style := [fsbold];
//                    si_txt := Trim(SpecialInstructions); // rpk 10/28/2009
//                    if si_txt > '' then begin // rpk 10/28/2009
//                      grdMultiOrder.Cells[ACol, ARow] :=
//                        grdMultiOrder.Cells[ACol, ARow] + ' ' + si_txt;
                      // rpk 10/28/2009
                    SIOPIText := GetSIOPIText;
                    if SIOPIText > '' then
                      DrawText(Canvas.Handle, PChar(SIOPIText),
                        Length(SIOPIText), ARect, DT_WORDBREAK or
                        DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS);
                      // rpk 1/12/2012
                  end;                  // else not ordertootall

                  ARect.Top := CurrentTop;
                end;                    // ctPB, ctIV
            end;                        // case lstCurrentTab

//          5:
          6:                            // ctactivemedication, pbinfusionrate, ivinfusionrate
//          7: // ctactivemedication, pbinfusionrate, ivinfusionrate
            case lstCurrentTab of
              ctUD: begin
                  CurrentTop := ARect.Top;
                  TextString := ActiveMedication;
                  grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 8/5/2009
                  // put active medication in first column to identify row
//                  grdMultiOrder.Cells[0, ARow] := TextString; // rpk 9/24/2009
                  ARect.Left := ARect.Left + 7;

                  for ii := 0 to OrderedDrugCount - 1 do begin
                    ARect.Top := ARect.Top + TempHeight;
                    TextString := OrderedDrugs[ii].Name;
                    if TextString > '' then begin
                      grdMultiOrder.Cells[ACol, ARow] :=
                        grdMultiOrder.Cells[ACol, ARow] + ', ' + TextString;
                      // rpk 8/5/2009
                    end;
                  end;

                  if OrderTooTall then begin
                    ARect.Top := ARect.Top + TempHeight;
                    Canvas.Font.Color := clRed;
                    Canvas.Font.Style := [fsBold];
                    grdMultiOrder.Cells[ACol, ARow] := ErrRowTooTall;
                  end
                  else begin
                    ARect.Top := ARect.Top + TempHeight;
                    Canvas.Font.Color := clRed;
                    Canvas.Font.Style := [fsBold];
//                    si_txt := Trim(SpecialInstructions); // rpk 10/28/2009
//                    if si_txt > '' then begin // rpk 10/28/2009
//                      grdMultiOrder.Cells[ACol, ARow] :=
//                        grdMultiOrder.Cells[ACol, ARow] + ' ' + si_txt;
                      // rpk 10/28/2009
                    SIOPIText := GetSIOPIText;
                    if SIOPIText > '' then
                      DrawText(Canvas.Handle, PChar(SIOPIText),
                        Length(SIOPIText), ARect, DT_WORDBREAK or
                        DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS);
                      // rpk 1/12/2012
                  end;
                  ARect.Top := CurrentTop;
                end;                    // ctUD

              ctPB, ctIV: begin
                  TextString := Trim(Dosage) + ', ' + Schedule;
                  grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 9/24/2009
                end;
            end;                        // case lstCurrentTab

//          6:
          7:                            // ctdosage, pbroute, ivroute
//          8: // ctdosage, pbroute, ivroute
            case lstCurrentTab of
              ctUD: begin
                  TextString := Trim(Dosage) + ', ' + Schedule;
                  grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 9/24/2009
                end;
              ctPB, ctIV: begin
                  grdMultiOrder.Cells[ACol, ARow] := Route; // rpk 9/24/2009
                end;
            end;                        // case 7

//          7:
          8:                            // ctroute, pbremovalstatus, ivbaginformation; was: ctroute, pbadministrationtime, ivbaginformation
//          9: // ctroute, pbadministrationtime, ivbaginformation
            case lstCurrentTab of
              ctUD: begin
                  grdMultiOrder.Cells[ACol, ARow] := Route; // rpk 8/5/2009
                end;

              ctPB:                     // pbremovalstatus
{$IFDEF CAS_DDPE_RST}
                OutText := getOrderNextAction(MO_tmp, frmMain.acNextActionWithDate.Checked,
                  NextAction, NextDT, isLate);
//                OutText := getOrderNextAction(MO_tmp, frmMain.acNextActionWithDate.Checked,
//                  NextAction, NextDT);
{$ELSE}
                if ScheduleType = 'C' then // rpk 7/18/2012
                  OutText := DisplayVADate(AdministrationTime);
{$ENDIF}
              ctIV: begin               // ivbaginformation
                  TempHeight := 0;
                  if LastActivityStatus > '' then begin
                    TextString := GetLastActivityStatus(LastActivityStatus) +
                      ': ' +
                      DisplayVADateYearTime(TimeLastAction); // rpk 9/24/2009
                    grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 9/24/2009
                  end;
                  ARect.Top := ARect.Top + TempHeight;
                  if OrderChangedData.Count > 0 then begin
                    OutText := GetLastActivityStatus(piece(OrderChangedData[0],
                      '^', 4));
                    OutText := OutText + ' bag on changed order';
                  end
                  else
                    OutText := '';
                end;                    // ctIV
            end;                        // case 8

//          8:
          9:                            // ctRemovalStatus, pblastaction, ivorderstopdate
            case lstCurrentTab of
              ctUD:
{$IFDEF CAS_DDPE_RST}
                OutText :=
                getOrderNextAction(MO_tmp, frmMain.acNextActionWithDate.Checked,
                  NextAction, NextDT, isLate);
{$ELSE}
                if ScheduleType = 'C' then begin
                  OutText := DisplayVADate(AdministrationTime);
                end;
{$ENDIF}
              ctPB: begin               // pblastaction
                  if LastActivityStatus > '' then begin
                    TextString := GetLastActivityStatus(LastActivityStatus) +
                      ': ' +
                      DisplayVADateYearTime(TimeLastAction); // rpk 9/24/2009
                    grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 9/24/2009
                  end;
                  ARect.Top := ARect.Top + TempHeight;
                  if OrderTransferred = '1' then
                    OutText := BCMA_Patient.TransferredTransactionType
                  else
                    OutText := '';
                end;                    // ctPB
              ctIV:
                OutText := DisplayVADate(StopDateTime);
            end;                        // case 9

//          9:
          10:                           // cttimelastgiven, pblastsite
            case lstCurrentTab of
              ctUD: begin               // cttimelastgiven
{ $IFDEF CAS_DDPE_RST}                   // with CAS introducing new column on VDL we copy functionality from previous column
//                  if ScheduleType = 'C' then
//                    OutText := DisplayVADate(AdministrationTime);
{ $ELSE}
                  if LastActivityStatus > '' then begin
                    TextString := GetLastActivityStatus(LastActivityStatus) +
                      ': ' +
                      DisplayVADateYearTime(TimeLastAction); // rpk 9/24/2009
                    grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 9/24/2009
                  end;
                  ARect.Top := ARect.Top + TempHeight;
                  if OrderTransferred = '1' then
                    OutText := BCMA_Patient.TransferredTransactionType
                  else
                    OutText := '';
{ $ENDIF}
                end;                    // UD
              ctPB: begin               // pblastsite
{ $IFDEF CAS_DDPE_RST}                   // with CAS introducing new column on VDL we copy functionality from previous column
                  { if LastActivityStatus > '' then begin
                    TextString := GetLastActivityStatus(LastActivityStatus) +
                      ': ' +
                      DisplayVADateYearTime(TimeLastAction); // rpk 9/24/2009
                    grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 9/24/2009
                  end;
                  ARect.Top := ARect.Top + TempHeight;
                  if OrderTransferred = '1' then
                    OutText := BCMA_Patient.TransferredTransactionType
                  else
                    OutText := ''; }
{ $ELSE}
                  OutText := LastSite;
{ $ENDIF}
                end;
            end;                        // case 10

//          10: // LastSite
          11:                           // ctlastsite
            case lstCurrentTab of
              ctUD: begin               // ctlastsite
{ $IFDEF CAS_DDPE_RST}
                  { if LastActivityStatus > '' then begin
                    TextString := GetLastActivityStatus(LastActivityStatus) +
                      ': ' +
                      DisplayVADateYearTime(TimeLastAction); // rpk 9/24/2009
                    grdMultiOrder.Cells[ACol, ARow] := TextString; // rpk 9/24/2009
                  end;
                  ARect.Top := ARect.Top + TempHeight;
                  if OrderTransferred = '1' then
                    OutText := BCMA_Patient.TransferredTransactionType
                  else
                    OutText := ''; }

{ $ELSE}
                  OutText := LastSite;
{ $ENDIF}
                end;
{ $IFDEF CAS_DDPE_RST}
//              ctPB:                     // pblastsite
//                OutText := LastSite;
{ $ENDIF}
            end;  // case 11
{ $IFDEF CAS_DDPE_RST}
//          12:                           // ctlastsite
//            case lstCurrentTab of
//              ctUD: OutText := LastSite;
//            end;
{ $ENDIF}

        end;                            // case x

      case lstCurrentTab of
        ctUD:
          case x of
//            1, 2, 3, 4, 7, 8, 9, 10: begin
//            1, 2, 3, 4, 7, 8, 9, 10, 11: begin // rpk 5/14/2012
//            1, 2, 3, 4, 7, 8, 9, 10, 11, 12: begin // rpk 5/18/2012
{$IFDEF CAS_DDPE_RST}
            ord(ctRemovalStatus),
              ord(ctWitness),
{$ENDIF}
            ord(ctclinicname), ord(ctscanstatus), ord(ctverifynurse),
              ord(ctselfmed), ord(ctScheduleType),
//              ord(ctadministrationtime),
              ord(cttimelastgiven), ord(ctlastsite): begin // rpk 6/20/2012
                if OutText <> '' then begin
                  grdMultiOrder.Cells[ACol, ARow] :=
                    grdMultiOrder.Cells[ACol, ARow] + ' ' + OutText; // rpk 8/5/2009
                end;
              end;
          end;

//        ctPB, ctIV:
        ctPB:
          case x of
//            1, 2, 3, 6, 7, 8, 9: begin
//            1, 2, 3, 6, 7, 8, 9, 10: begin // rpk 5/14/2012
//            1, 2, 3, 6, 7, 8, 9, 10, 11: begin // rpk 5/14/2012
            ord(pbclinicname), ord(pbscanstatus), ord(pbverifynurse),
              ord(pbScheduleType), ord(pbremovalstatus),
//              ord(pbadministrationtime),
              ord(pblastaction),
              ord(pblastsite): begin    // rpk 6/20/2012
                if OutText <> '' then begin
                  grdMultiOrder.Cells[ACol, ARow] :=
                    grdMultiOrder.Cells[ACol, ARow] + ' ' + OutText;
                  // rpk 9/24/2009
                end;
              end;
          end;

//        ctPB, ctIV:
        ctIV:
          case x of
//            1, 2, 3, 6, 7, 8, 9: begin
//            1, 2, 3, 6, 7, 8, 9, 10: begin // rpk 5/14/2012
//            1, 2, 3, 6, 7, 8, 9, 10, 11: begin // rpk 5/14/2012
            ord(ivclinicname), ord(ivorderstatus), ord(ivverifynurse),
              ord(ivtype), ord(ivbaginformation), ord(ivorderstopdate): begin // rpk 6/20/2012
                if OutText <> '' then begin
                  grdMultiOrder.Cells[ACol, ARow] :=
                    grdMultiOrder.Cells[ACol, ARow] + ' ' + OutText;
                  // rpk 9/24/2009
                end;
              end;
          end;
      end;                              // case lstCurrentTab

      Canvas.Font.Color := CurrentFontColor;
      Canvas.Font.Style := [];
      ARect.Right := ARect.Right + 4;

      // mark null cells with blank to prevent re-processing same cell on repaints.
      if grdMultiOrder.Cells[ACol, ARow] = '' then
        grdMultiOrder.Cells[ACol, ARow] := ' ';
    end;                                // with grdMultiOrder

  // Don't use Invalidate here, it will put characters in locations on left side
  // of string grid.
  //  sgUnitDose.Invalidate; // rpk 8/13/2009;

end;

procedure TfrmMultOrder.grdMultiOrderEnter(Sender: TObject);
var
  CanSelect: Boolean;
begin
  with grdMultiOrder do begin
    if (Row < 1) and (RowCount > 1) then
      Row := 1;
    grdMultiOrderSelectCell(Sender, Col, Row, CanSelect);
  end;
end;

procedure TfrmMultOrder.grdMultiOrderSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  SelectedX := ACol;
  SelectedY := ARow;
end;

procedure TfrmMultOrder.btnOKClick(Sender: TObject);
begin
  if ScreenReaderSystemActive then begin
    if grdMultiOrder.Row > 0 then
      modalResult := (grdMultiOrder.Row - 1) + 100;
  end
  else
    modalResult := lstMultiOrder.ItemIndex + 100;
end;

procedure TfrmMultOrder.pnlButtonResize(Sender: TObject);
begin
  btnOK.Width := btnCancel.Width;
  btnOK.Left := pnlButton.ClientWidth - (btnOK.Width + self.BorderWidth + 5) *
    2;
  btnCancel.Left := pnlButton.ClientWidth - (btnCancel.Width + self.BorderWidth
    + 5);
end;

{ procedure TfrmMultOrder.VA508ComponentAccessibility1ItemQuery(Sender: TObject;
  var Item: TObject);
var
  i, j: Integer;
begin
  j := Integer(Item);
  i := (100 * SelectedY) + SelectedX;
  if i <> j then
    j := i;
  Item := TObject(i);
end; }// VA508ComponentAccessibility1ItemQuery

procedure TfrmMultOrder.VA508ComponentAccessibility1ValueQuery(Sender: TObject;
  var Text: string);
var
  Index: Integer;
  MO_tmp: TBCMA_MedOrder;
begin
//  Text := ' Med ' + grdMultiOrder.Cells[0, SelectedY] + ' ' + // rpk 9/6/2010
//    'Column ' + grdMultiOrder.Cells[SelectedX, 0] + ', ' +
//    grdMultiOrder.Cells[SelectedX, SelectedY];

  Text := '';
  MO_tmp := nil;
  Index := SelectedY - 1;
  if (Index >= 0) then
//    MO_tmp := TBCMA_MedOrder(VisibleMedList[Index]);
    MO_tmp := TBCMA_MedOrder(VisibleMedList[StrToInt(lstMultiOrder.items[Index])]); // rpk 8/12/2011

  // Announce Provider Hold in first column.
  if (MO_tmp <> nil) and (Index >= 0) and (SelectedX = 1) and
    (MO_tmp.OrderStatus = 'H') then
    Text := ' Order is on Provider Hold, ';

  if (MO_tmp <> nil) and MO_tmp.OvrIntvent and (SelectedX = 2) then begin
    Text := Text + ' Order has override or intervention reasons, '; // rpk 5/20/2011
  end;

  Text := Text + ' Med ' + grdMultiOrder.Cells[0, SelectedY] + ' ' +
    'Column ' + grdMultiOrder.Cells[SelectedX, 0] + ', ' +
    grdMultiOrder.Cells[SelectedX, SelectedY];
end;                                    // VA508ComponentAccessibility1ValueQuery

//procedure TfrmMultOrder.lbxScannedOrdersEnter(Sender: TObject);
//begin
//  btnOK.enabled := True;
//end;

//procedure TfrmMultOrder.sgMultOrderEnter(Sender: TObject);
//begin
//  btnOK.enabled := True;
//end;

procedure TfrmMultOrder.lstMultiOrderMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
var
//  TextString,
//    TextString2,
//    TextString3,
//    TextString4,
//    LastAct: string;
//  CellHeight,
//    DosageHeight,
//    OrderedCount: Integer;
//  SpecialInstructionsHeight,
//    DrugsHeight,
//    RouteHeight,
//    LastActHeight,
//    TooTallHt: Integer;
//  iheight: Integer;
  rowidx: Integer;
//  ARect: TRect;
//  OrderableItem,
//    SpecialInstruct,
//    DosageSchedule,
//    MedRoute: string;
//  aMedOrder: TBCMA_MedOrder;


  { procedure ResetRect;
  begin
    with ARect do begin
      Left := 0;
      Top := 0;
      Bottom := 0;
      case lstCurrentTab of
        ctUD:
          Right := hdrMultiOrder.Sections[4].Width - 6;
        ctPB, ctIV:
          Right := hdrMultiOrder.Sections[3].Width - 6;
      end;
    end;
  end; }

begin
  if VisibleMedList.Count = 0 then
    Exit;

  // rowidx = VisibleMedList row
  rowidx := StrToInt(lstMultiOrder.items[index]);
//  Height := frmMain.GetRowHeight(frmMain.lstUnitDose.Canvas, frmMain.lstUnitDose.ItemRect(rowidx),
//    rowidx)
  Height := frmMain.GetRowHeight(TListBox(Control).Canvas, TListBox(Control).ItemRect(Index),
    hdrMultiOrder, rowidx)              // rpk 7/29/2015
//  Height := frmMain.GetRowHeight(lstMultiOrder.Canvas, lstMultiOrder.ItemRect(Index),
//    hdrMultiOrder, rowidx)  // rpk 8/3/2015
{$IFDEF CAS_DDPE_DEBUG}
  + frmMain.CAS_TopDelta
{$ENDIF}
  ;
  (* rowidx := StrToInt(lstMultiOrder.items[index]);
  aMedOrder := TBCMA_MedOrder(VisibleMedList[rowidx]);
  with aMedOrder do begin
    TextString := ActiveMedication;
    TextString2 := 'Dummy Text';
    case OrderTypeID of
      otUnitDose:
        OrderedCount := OrderedDrugCount;
      otIV:
        OrderedCount := AdditiveCount + SolutionCount;
    else
      OrderedCount := 1;
    end;

//    TextString3 := SpecialInstructions;
    TextString3 := GetSIOPIText; // rpk 1/12/2012
    TextString4 := Trim(Dosage) + ', ' + Schedule;

    OrderTooTall := False;
    OrderableItem := ActiveMedication;
    case OrderTypeID of
      otUnitDose:
        OrderedCount := OrderedDrugCount;
      otIV:
        OrderedCount := AdditiveCount + SolutionCount
    else
      OrderedCount := 1;
    end;
    SpecialInstruct := GetSIOPIText;
    DosageSchedule := Trim(Dosage) + ', ' + Schedule;
    MedRoute := Route;
    LastAct := GetLastActivityStatus(LastActivityStatus) + ': ' // rpk 9/26/2012
      + DisplayVADateYearTime(TimeLastAction);
  end;

  ARect := lstMultiOrder.ItemRect(Index);
  ResetRect;

//  CellHeight := DrawText(Canvas.Handle, PChar(TextString), Length(TextString),
//    ARect, DT_END_ELLIPSIS or DT_NOPREFIX or DT_CALCRECT);
  CellHeight := DrawText(Canvas.Handle, PChar(OrderableItem),
    Length(OrderableItem),
    ARect, DT_END_ELLIPSIS or DT_NOPREFIX or DT_CALCRECT);

  ResetRect;
  ARect.Left := 7;
//  CellHeight := CellHeight + (DrawText(Canvas.Handle, PChar(TextString2),
//    Length(TextString2),
//    ARect, DT_END_ELLIPSIS or DT_NOPREFIX or DT_CALCRECT) * OrderedCount);
  DrugsHeight := DrawText(Canvas.Handle, PChar('Dispensed Drugs'),
    Length('Dispensed Drugs'), ARect, DT_END_ELLIPSIS or DT_NOPREFIX or
    DT_CALCRECT) * OrderedCount;
  CellHeight := CellHeight + DrugsHeight;

  ResetRect;
//  with TBCMA_MedOrder(VisibleMedList[StrToInt(lstMultiOrder.items[index])]) do
  with aMedOrder do
    if OrderTypeID = otUnitDose then
      ARect.Left := 7
    else
      ARect.Left := 14;

//  CellHeight := CellHeight + DrawText(Canvas.Handle, PChar(TextString3),
//    Length(TextString3),
//    ARect, DT_WORDBREAK or DT_CALCRECT or DT_NOPREFIX or DT_EDITCONTROL or
//    DT_WORD_ELLIPSIS);
  Canvas.Font.Style := [fsBold];
  SpecialInstructionsHeight := DrawText(Canvas.Handle,
    PChar(SpecialInstruct),
    Length(SpecialInstruct), ARect, DT_WORDBREAK or DT_CALCRECT or DT_NOPREFIX
    or
    DT_EDITCONTROL or DT_WORD_ELLIPSIS);
  CellHeight := CellHeight + SpecialInstructionsHeight;
  Canvas.Font.Style := [];

  ResetRect;
  { case lstCurrentTab of
    ctUD:
      ARect.Right := hdrMultiOrder.Sections[5].Width - 6;
    ctPB, ctIV:
      ARect.Right := hdrMultiOrder.Sections[4].Width - 6;
  end; }
  case lstCurrentTab of
    ctUD:
      ARect.Right := hdrMultiOrder.Sections[ord(ctdosage)].Width - 6;
    ctPB, ctIV:
      ARect.Right := hdrMultiOrder.Sections[ord(pbinfusionrate)].Width - 6;
  end;
//  DosageHeight := DrawText(Canvas.Handle, PChar(TextString4),
//    Length(TextString4),
//    ARect, DT_WORDBREAK or DT_CALCRECT or DT_NOPREFIX or DT_EDITCONTROL or
//    DT_WORD_ELLIPSIS);
  DosageHeight := DrawText(Canvas.Handle, PChar(DosageSchedule),
    Length(DosageSchedule), ARect, DT_WORDBREAK or DT_CALCRECT or DT_NOPREFIX or
    DT_EDITCONTROL or DT_WORD_ELLIPSIS);

  case lstCurrentTab of
    ctUD:
      ARect.Right := hdrMultiOrder.Sections[ord(ctroute)].Width - 6;
    ctPB, ctIV:
      ARect.Right := hdrMultiOrder.Sections[ord(pbroute)].Width - 6;
  end;
  RouteHeight := DrawText(Canvas.Handle, PChar(MedRoute),
    Length(MedRoute), ARect, DT_WORDBREAK or DT_CALCRECT or DT_NOPREFIX or
    DT_EDITCONTROL or DT_WORD_ELLIPSIS);

  case lstCurrentTab of
    ctUD:
      ARect.Right := hdrMultiOrder.Sections[ord(cttimelastgiven)].Width - 6;
    ctPB, ctIV:
      ARect.Right := hdrMultiOrder.Sections[ord(pblastaction)].Width - 6;
  end;
  LastActHeight := DrawText(Canvas.Handle, PChar(LastAct), // rpk 9/26/2012
    Length(LastAct), ARect, DT_WORDBREAK or DT_CALCRECT or DT_NOPREFIX or
    DT_EDITCONTROL or DT_WORD_ELLIPSIS);

  iHeight := Trunc(MaxValue([CellHeight, DosageHeight, RouteHeight, LastActHeight])) + 2;

//  Height := Max(CellHeight, DosageHeight) + 2;
//  ItemsHeight := ItemsHeight + Height;

  if iHeight > 255 then begin
//    TBCMA_MedOrder(VisibleMedList[rowidx]).OrderTooTall := True;
    aMedOrder.OrderTooTall := True;
    //      CellHeight := iHeight - DrugsHeight - SpecialInstructionsHeight;
          // change functionality to display ordered drugs above ErrRowTooTall
//    CellHeight := Height - SpecialInstructionsHeight; // rpk 10/8/2009
    CellHeight := iHeight - SpecialInstructionsHeight; // rpk 9/7/2011
    ResetRect;
    Canvas.Font.Style := [fsBold];
//    ARect.Left := 7;
    if aMedOrder.OrderTypeID = otUnitDose then // rpk 1/23/2012
      ARect.Left := 7
    else
      ARect.Left := 14;
//    CellHeight := CellHeight + DrawText(CtrlCanvas.Handle, PChar(ErrRowTooTall),
//      Length(ErrRowTooTall), ARect, DT_WORDBREAK or DT_CALCRECT or
//      DT_NOPREFIX or DT_EDITCONTROL or DT_WORD_ELLIPSIS);
    TooTallHt := DrawText(Canvas.Handle, PChar(ErrRowTooTall),
      Length(ErrRowTooTall), ARect, DT_WORDBREAK or DT_CALCRECT or
      DT_NOPREFIX or DT_EDITCONTROL or DT_WORD_ELLIPSIS);
    CellHeight := CellHeight + TooTallHt;
    Canvas.Font.Style := [];
    iHeight := Max(CellHeight, DosageHeight);
  end;

  Height := iheight; *)

  // later use GetRowHeight from main form when general functions are available
//  Height := frmMain.GetRowHeight(lstMultiOrder.Canvas, lstMultiOrder.ItemRect(Index),
//    Index);

end;                                    // lstMultiOrderMeasureItem

procedure TfrmMultOrder.lstMultiOrderDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x,
    ii,
    CellRight,
    TempHeight,
    CurrentTop,
    TitleCount: integer;
  TextString: string;
  CurrentFontColor: TColor;
{$IFDEF CAS_DDPE_RST}
  aCasImageIdx,
    aCasTopOffset,
    aCasLeftOffset: Integer;
  aCasRect,                             // CAS_DDPE_RST
{$ENDIF}
  ARect: TRect;
  OvrRect: TRect;                       // rpk 1/14/2011
//  zSpecialInstructions: string;
  outText: string;
  aMedOrder: TBCMA_MedOrder;            // rpk 6/6/2011
  savBrushColor: TColor;                // rpk 1/14/2011
  SIOPIText: string;                    // rpk 1/12/2012
  NextAction, NextDT, tmpstr: String;   // rpk 8/4/2015
  isLate: Boolean;                      // rpk 8/17/2015
begin
  if VisibleMedList.Count > 0 then
    with lstMultiOrder do begin

      ARect := Rect;
      CurrentFontColor := Canvas.Font.Color;
      savBrushColor := Canvas.Brush.Color; // rpk 1/14/2011

      aMedOrder := TBCMA_MedOrder(VisibleMedList[StrToInt(lstMultiOrder.items[index])]); // rpk 6/6/2011
//      if (TBCMA_MedOrder(VisibleMedList[StrToInt(lstMultiOrder.items[index])]).OrderStatus = 'H') and not (odSelected in State) then
      if (aMedOrder.OrderStatus = 'H') and not (odSelected in State) then // rpk 6/6/2011
        Canvas.Brush.Color := $00DDDDDD;

      with Canvas do begin
        FillRect(ARect);
        Pen.Color := clSilver;
        MoveTo(ARect.Left, ARect.Bottom - 1);
        LineTo(ARect.Right, ARect.Bottom - 1);
      end;

      CellRight := -3;

      case lstCurrentTab of
        ctUD:
          TitleCount := Length(VDLColumnTitles);
        ctPB:
          TitleCount := Length(lstPBColumnTitles);
        ctIV:
          TitleCount := Length(lstIVColumnTitles);
      else
        TitleCount := Length(VDLColumnTitles);
      end;

      for x := 0 to TitleCount - 1 do begin
        CellRight := CellRight + hdrMultiOrder.Sections[x].Width;
        Canvas.MoveTo(CellRight, ARect.Bottom - 1);
        Canvas.LineTo(CellRight, ARect.Top);
      end;

      CurrentTop := ARect.Top;          // rpk 2/3/2012

      for x := 0 to TitleCount - 1 do begin
        if x > 0 then
          ARect.Left := ARect.Right + 2
        else
          ARect.Left := 2;

        ARect.Right := ARect.Left + hdrMultiOrder.Sections[x].Width - 6;
        // reset top of writing rectangle to top of row.
        ARect.Top := CurrentTop;        // rpk 2/3/2012

        TextString := '';
        OutText := '';

//        with TBCMA_MedOrder(VisibleMedList[StrToInt(lstMultiOrder.items[index])])
        with aMedOrder do               // rpk 6/6/2011
          case x of
            0: begin                    // ctclinicname, pbclinicname, ivclinicname
                OutText := ClinicName;
              end;
//            0: begin
            1: begin                    // ctscanstatus, pbscanstatus, ivorderstatus
                case lstCurrentTab of
                  ctUD, ctPB:
                    OutText := ScanStatus;
                  ctIV:
                    OutText := GetOrderStatus(OrderStatus);
                end;
              end;
//            1: begin
            2: begin                    // ctverifynurse, pbverifynurse, ivverifynurse
                if OvrIntvent then begin
                  OvrRect := aRect;
              // adjust sides to fill to edge of cell.
                  OvrRect.Left := OvrRect.Left - 4;
                  OvrRect.Right := OvrRect.Right + 1;
                  OvrRect.Bottom := OvrRect.Bottom - 1;

                  with Canvas do begin
                    Brush.Color := $00FFFF; // bright yellow
                    Font.Color := clBlack;
                    Brush.Style := bsSolid;
                    FillRect(OvrRect);
                  end;                  // with Canvas

                end;                    // if OvrIntvent

                if VerifyNurse = '***' then begin
                  Canvas.Font.Style := [fsBold];
                end;

                OutText := VerifyNurse;
                ListGridDrawCell(lstMultiOrder, hdrMultiOrder, Index, x, OutText, False);
//                OutText := VerifyNurse;
              end;

//            2: begin
            3: begin                    // ctselfmed, pbschedtype, ivtype
                case lstCurrentTab of
                  ctUD:
                    OutText := SelfMed;
                  ctPB:
                    OutText := ScheduleType;
                  ctIV:
                    OutText := GetIVType(AdministrationUnit);
                end;
              end;

//              3: begin
            4: begin                    // ctschedtype, pbwitness, ivwitness
                case lstCurrentTab of
                  ctUD:
                    OutText := ScheduleType;
                  ctPB, ctIV:
//                    if WitnessFlag = WITNESS_REQUIRED then
//                      ImageList1.Draw(Canvas, ARect.Left - 2, ARect.Top, 2);
                    if WitnessFlag >= WITNESS_RECOMMENDED then // rpk 10/10/2012
//                      ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, 2);    // rpk 9/25/2012
                      frmMain.ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, WITNESS_IDX); // rpk 9/8/2015
                end;
              end;
//            3: begin
//            4: begin
            5: begin                    // ctwitness, pbmedicationsolution, ivmedicationsolution
                case lstCurrentTab of
                  ctUD: begin
//                    OutText := ScheduleType;
//                    if WitnessFlag = WITNESS_REQUIRED then
//                      ImageList1.Draw(Canvas, ARect.Left - 2, ARect.Top, 2);
                      if WitnessFlag >= WITNESS_RECOMMENDED then // rpk 10/10/2012

{$IFDEF CAS_DDPE_RST}
                      begin
                        aCasTopOffset := 17;
                        aCasLeftOffset := 28;
//                        ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, WITNESS_IDX); // rpk 9/14/2012
                        frmMain.ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, WITNESS_IDX); // rpk 9/8/2015
                      end
                      else
                      begin
                        aCasTopOffset := 0;
//                        aCasLeftOffset := 0;
                        aCasLeftOffset := 28; //0; v.3.0.83.20 - fixing offset of the icon aan 20150702
                      end;

                      if frmMain.acAlertMultiple.Checked and
                        isRemovalRequiredByOrder(aMedOrder) then
                      begin
                          //aCasImageIdx := RemovalImageIndexByStatus(GetLastActivityStatus(LastActivityStatus));
                        aCasImageIdx := frmMain.CAS_Icon; // only one icon is used
                        if frmMain.CAS_HOrientation then
                          frmMain.ilCAS_DDPE.Draw(Canvas, ARect.Left + aCasLeftOffset, ARect.Top, aCasImageIdx)
                        else
                          frmMain.ilCAS_DDPE.Draw(Canvas, ARect.Left + 5, ARect.Top + aCasTopOffset, aCasImageIdx);
                      end;
{$ELSE}
//                        ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, 2);  // rpk 9/25/2012
                        frmMain.ImageList1.Draw(Canvas, ARect.Left + 5, ARect.Top, WITNESS_IDX); // rpk 9/8/2015
{$ENDIF}
                    end;                // ctUD
                  ctPB, ctIV: begin

                      CurrentTop := ARect.Top;
                      TextString := ActiveMedication;
                      TempHeight := DrawText(Canvas.Handle, PChar(TextString),
                        Length(TextString), ARect, DT_END_ELLIPSIS or
                        DT_NOPREFIX);

                      ARect.Left := ARect.Left + 7;

                        // change functionality to always display ordered drugs,
                        // additives, solutions // rpk 9/26/2012

                      if OrderTypeID = otUnitDose then begin
                        for ii := 0 to OrderedDrugCount - 1 do begin
                          ARect.Top := ARect.Top + TempHeight;
                          TextString := OrderedDrugs[ii].Name;
                          TempHeight := DrawText(Canvas.Handle,
                            PChar(TextString),
                            Length(TextString), ARect, DT_END_ELLIPSIS
                            or DT_NOPREFIX);
                        end;
                      end
                      else begin
                        for ii := 0 to AdditiveCount - 1 do begin
                          ARect.Top := ARect.Top + TempHeight;
                          TextString := piece(Additives[ii], '^', 3) +
                            ' ' +
                            piece(Additives[ii], '^', 4) + ' ' +
                            piece(Additives[ii], '^', 5);
                          TempHeight := DrawText(Canvas.Handle,
                            PChar(TextString),
                            Length(TextString), ARect, DT_END_ELLIPSIS
                            or DT_NOPREFIX);
                        end;

                        ARect.Left := ARect.Left + 7;
                        for ii := 0 to SolutionCount - 1 do begin
                          ARect.Top := ARect.Top + TempHeight;
                          TextString := piece(Solutions[ii], '^', 3) +
                            ' ' +
                            piece(Solutions[ii], '^', 4) + ' ' +
                            piece(Solutions[ii], '^', 5);
                          TempHeight := DrawText(Canvas.Handle,
                            PChar(TextString),
                            Length(TextString), ARect, DT_END_ELLIPSIS
                            or DT_NOPREFIX);
                        end
                      end;


                      ARect.Top := ARect.Top + TempHeight;
                      Canvas.Font.Color := clRed;
                      if OrderTooTall then begin
                        Canvas.Font.Color := clRed;
                        Canvas.Font.Style := [fsbold];
                        TempHeight := DrawText(Canvas.Handle, PChar(ErrRowTooTall),
                          Length(ErrRowTooTall), ARect, DT_WORDBREAK or
                          DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL); // rpk 1/23/2012
                      end
                      else begin
                        Canvas.Font.Color := clRed;
                        Canvas.Font.Style := [fsbold];
                        SIOPIText := GetSIOPIText;
                        TempHeight := DrawText(Canvas.Handle, PChar(SIOPIText),
                          Length(SIOPIText), ARect, DT_WORDBREAK or
                          DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL); // rpk 1/23/2012
                      end;              // else not OrderTooTall
                      ARect.Top := CurrentTop;
                    end;
                end;
              end;

//            4: begin
//            5: begin
            6: begin                    // ctactivemedication, pbinfusionrate, ivinfusionrate
                case lstCurrentTab of
                  ctUD: begin
                      CurrentTop := ARect.Top;
                      TextString := ActiveMedication;
                      TempHeight := DrawText(Canvas.Handle, PChar(TextString),
                        Length(TextString), ARect, DT_END_ELLIPSIS or
                        DT_NOPREFIX);

                      ARect.Left := ARect.Left + 7;
                      for ii := 0 to OrderedDrugCount - 1 do begin
                        ARect.Top := ARect.Top + TempHeight;
                        TextString := OrderedDrugs[ii].Name;
                        TempHeight := DrawText(Canvas.Handle, PChar(TextString),
                          Length(TextString), ARect, DT_END_ELLIPSIS or
                          DT_NOPREFIX); // rpk 1/18/2012
//                          TempHeight := DrawText(Canvas.Handle, PChar(TextString),
//                            Length(TextString), ARect, DT_END_ELLIPSIS or
//                            DT_NOPREFIX or DT_EDITCONTROL);  // rpk 4/3/2013
                      end;

                      ARect.Top := ARect.Top + TempHeight;
                      Canvas.Font.Color := clRed;
                      if OrderTooTall then begin
                        Canvas.Font.Color := clRed;
                        Canvas.Font.Style := [fsBold];
                        TempHeight := DrawText(Canvas.Handle, PChar(ErrRowTooTall),
                          Length(ErrRowTooTall), ARect, DT_WORDBREAK or
                          DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL); // rpk 1/23/2012
                      end
                      else begin
                        Canvas.Font.Color := clRed;
                        Canvas.Font.Style := [fsBold];
                        SIOPIText := GetSIOPIText;
                        TempHeight := DrawText(Canvas.Handle, PChar(SIOPIText),
                          Length(SIOPIText), ARect, DT_WORDBREAK or
                          DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL); // rpk 1/23/2012
                      end;              // else not order too tall

                      ARect.Top := ARect.Top + TempHeight; // debug
                      ARect.Top := CurrentTop;
                    end;
                  ctPB, ctIV: begin
                      TextString := Trim(Dosage) + ', ' + Schedule;
                      DrawText(Canvas.Handle, PChar(TextString),
                        Length(TextString), ARect,
//                        DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS);
                        DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or
                        DT_EDITCONTROL); // rpk 6/12/2012
                    end;
                end;
              end;

//            5: begin
//            6: begin
            7: begin                    // ctdosage, pbroute, ivroute
                case lstCurrentTab of
                  ctUD: begin
                      TextString := Trim(Dosage) + ', ' + Schedule;
                      DrawText(Canvas.Handle, PChar(TextString),
                        Length(TextString), ARect,
//                        DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS);
                        DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or
                        DT_EDITCONTROL); // rpk 6/12/2012
                    end;
                  ctPB, ctIV:
//                    OutText := Route;
                    DrawText(Canvas.Handle, PChar(Route), Length(Route), ARect,
                      DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or
                      DT_EDITCONTROL);  // rpk 9/26/2012
                end;
              end;

//            6:
//            7:
            8:                          // ctroute, pbremovalstatus, ivbaginformation; was: ctroute, pbadministrationtime, ivbaginformation
              case lstCurrentTab of
                ctUD:                   // ctroute
//                  OutText := Route;
                  DrawText(Canvas.Handle, PChar(Route), Length(Route), ARect,
                    DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or
                    DT_EDITCONTROL);    // rpk 9/26/2012
                ctPB: begin             // pbremovalstatus
{$IFDEF CAS_DDPE_RST}
                      // write Next Action on first line, Next Datetime on second line
                    tmpstr := getOrderNextAction(aMedOrder, frmMain.acNextActionWithDate.Checked,
                      NextAction, NextDT, isLate);
//                    tmpstr := getOrderNextAction(aMedOrder, frmMain.acNextActionWithDate.Checked,
//                      NextAction, NextDT);
                    aCasRect := aRect;
                    aCasRect.Left := aCasRect.Left + aCasLeftOffset;

//                    isLate := isLateOrder(aMedOrder);
                    if isLate then begin // rpk 8/17/2015
                      Canvas.Font.Color := clRed;
                      Canvas.Font.Style := [fsbold];
                    end;
                    TempHeight := DrawText(Canvas.Handle, PChar(NextAction), Length(NextAction), ACasRect,
                      DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL);

//                      if acNextActionWithDate.Checked then begin
                    ACasRect.Top := ACasRect.Top + TempHeight;
                    TempHeight := DrawText(Canvas.Handle, PChar(NextDT), Length(NextDT), ACasRect,
                      DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL);
//                      end;
{$ELSE}
                    if ScheduleType = 'C' then // rpk 7/18/2012
                      OutText := DisplayVADate(AdministrationTime);
{$ENDIF}
                  end;
                ctIV: begin             // ivbaginformation
                    if LastActivityStatus = '' then
                      TempHeight := DrawText(Canvas.Handle, PChar(''),
                        Length(''), ARect, DT_END_ELLIPSIS or DT_NOPREFIX)
                    else
                      TempHeight := DrawText(Canvas.Handle,
                        PChar(DisplayVADateYearTime(TimeLastAction)),
                        Length(DisplayVADateYearTime(TimeLastAction)), ARect,
//                      DT_END_ELLIPSIS or DT_NOPREFIX);
                        DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or
                        DT_EDITCONTROL); // rpk 6/12/2012
                    ARect.Top := ARect.Top + TempHeight;
//                    OutText := GetLastActivityStatus(LastActivityStatus);
                    if OrderChangedData.Count > 0 then begin
                      OutText :=
                        GetLastActivityStatus(piece(OrderChangedData[0],
                        '^', 4));
                      OutText := OutText + ' bag on changed order';
                    end
                    else
                      OutText := '';
                  end;
              end;

//            7:
//            8:
            9:                          // ctRemovalStatus, pblastaction, ivorderstopdate
              case lstCurrentTab of
                ctUD:
{$IFDEF CAS_DDPE_RST}
                  begin                 // ctremovalstatus
                    aCasLeftOffset := 0;
                    if ((RemovalStatus <> '') and (RemovalStatus <> '0')) and
                      IsRemovalRequiredByStatus(ScanStatus) then
                    begin
                      if frmMain.CAS_Icon > 10 then
                        aCasLeftOffset := 0
                      else
                        aCasLeftOffset := 32; // offset of text in the table cell
//                                aCasImageIdx := RemovalImageIndexByStatus(GetLastActivityStatus(LastActivityStatus));
                      aCasImageIdx := frmMain.CAS_Icon;
                      if not frmMain.acAlertMultiple.Checked then
                        frmMain.ilCAS_DDPE.Draw(Canvas, ARect.Left + 5, ARect.Top, aCasImageIdx)
                      else
                        aCasLeftOffset := 0;
                    end;
//                    OutText :=
//                      getOrderNextAction(aMedOrder,frmMain.acNextActionWithDate.Checked);
                    // write Next Action on first line, Next Datetime on second line
                    tmpstr :=
                      getOrderNextAction(aMedOrder, frmMain.acNextActionWithDate.Checked,
                      NextAction, NextDT, isLate);
                    aCasRect := aRect;
                    aCasRect.Left := aCasRect.Left + aCasLeftOffset;

                    if isLate then begin // rpk 8/17/2015
                      Canvas.Font.Color := clRed;
                      Canvas.Font.Style := [fsbold];
                    end;
                    TempHeight := DrawText(Canvas.Handle, PChar(NextAction), Length(NextAction), ACasRect,
                      DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL);

                    ACasRect.Top := ACasRect.Top + TempHeight;
                    TempHeight := DrawText(Canvas.Handle, PChar(NextDT), Length(NextDT), ACasRect,
                      DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL);
                  end;
{$ELSE}
                  if ScheduleType = 'C' then // admin time
                    OutText := DisplayVADate(AdministrationTime);
{$ENDIF}
                ctPB: begin             // pblastaction
{ $IFDEF CAS_DDPE_RST}
//                    if ScheduleType = 'C' then // rpk 7/18/2012
//                      OutText := DisplayVADate(AdministrationTime);
{ $ELSE}
                    if LastActivityStatus = '' then
                      TempHeight := DrawText(Canvas.Handle, PChar(''),
                        Length(''), ARect, DT_END_ELLIPSIS or DT_NOPREFIX)
                    else
                      TempHeight := DrawText(Canvas.Handle,
                        PChar(GetLastActivityStatus(LastActivityStatus) + ': ' +
                        DisplayVADateYearTime(TimeLastAction)),
                        Length(GetLastActivityStatus(LastActivityStatus) + ': '
                        + DisplayVADateYearTime(TimeLastAction)), ARect,
                        DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or
                        DT_EDITCONTROL); // rpk 6/12/2012
                    ARect.Top := ARect.Top + TempHeight;
                    if OrderTransferred = '1' then
                      OutText := BCMA_Patient.TransferredTransactionType
                    else
                      OutText := '';
{ $ENDIF}
                  end;
                ctIV:                   // ivorderstopdate
                  OutText := DisplayVADate(StopDateTime);
              end;

//            8:
//            9:
            10:                         // cttimelastgiven, pblastsite  // was: cttimelastgiven, pblastsite
              case lstCurrentTab of
                ctUD: begin             // cttimelastgiven
{ $IFDEF CAS_DDPE_RST}
                    { if ScheduleType = 'C' then // Next action
                    begin
                      OutText := DisplayVADate(AdministrationTime);
//                        if (RemovalStatus <> '') and (RemovalStatus <> '0') then
//                          OutText := DisplayVADate(RemovalDateTime)
//                        else
//                          OutText := DisplayVADate(AdministrationTime);
                    end; }
{ $ELSE}
                    if LastActivityStatus = '' then // last time given
                      TempHeight := DrawText(Canvas.Handle, PChar(''),
                        Length(''), ARect, DT_END_ELLIPSIS or DT_NOPREFIX)
                    else
                      TempHeight := DrawText(Canvas.Handle,
                        PChar(GetLastActivityStatus(LastActivityStatus) + ': ' +
                        DisplayVADateYearTime(TimeLastAction)),
                        Length(GetLastActivityStatus(LastActivityStatus) + ': '
                        + DisplayVADateYearTime(TimeLastAction)), ARect,
                        DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or
                        DT_EDITCONTROL); // rpk 6/12/2012
                    ARect.Top := ARect.Top + TempHeight;
                    if OrderTransferred = '1' then
                      OutText := BCMA_Patient.TransferredTransactionType
                    else
                      OutText := '';
{ $ENDIF}
                  end;
                ctPB: begin             // pblastsite
{ $IFDEF CAS_DDPE_RST}
                    { if LastActivityStatus = '' then
                      TempHeight := DrawText(Canvas.Handle, PChar(''),
                        Length(''), ARect, DT_END_ELLIPSIS or DT_NOPREFIX)
                    else
                      TempHeight := DrawText(Canvas.Handle,
                        PChar(GetLastActivityStatus(LastActivityStatus) + ': ' +
                        DisplayVADateYearTime(TimeLastAction)),
                        Length(GetLastActivityStatus(LastActivityStatus) + ': '
                        + DisplayVADateYearTime(TimeLastAction)), ARect,
                        DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or
                        DT_EDITCONTROL); // rpk 6/12/2012
                    ARect.Top := ARect.Top + TempHeight;
                    if OrderTransferred = '1' then
                      OutText := BCMA_Patient.TransferredTransactionType
                    else
                      OutText := ''; }
{ $ELSE}
                    OutText := LastSite;
{ $ENDIF}
                  end;
              end;

//            9: // LastSite
//            10: // LastSite
            11:                         // ctlastsite
              case lstCurrentTab of
                ctUD: begin  // ctlastsite
{ $IFDEF CAS_DDPE_RST}
                    { if LastActivityStatus = '' then
                      TempHeight := DrawText(Canvas.Handle, PChar(''),
                        Length(''), ARect, DT_END_ELLIPSIS or DT_NOPREFIX)
                    else
                      TempHeight := DrawText(Canvas.Handle,
                        PChar(GetLastActivityStatus(LastActivityStatus) + ': ' +
                        DisplayVADateYearTime(TimeLastAction)),
                        Length(GetLastActivityStatus(LastActivityStatus) + ': '
                        + DisplayVADateYearTime(TimeLastAction)), ARect,
//                          DT_END_ELLIPSIS or DT_NOPREFIX);
                        DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or
                        DT_EDITCONTROL); // rpk 6/12/2012
                    ARect.Top := ARect.Top + TempHeight;
                    if OrderTransferred = '1' then
                      OutText := BCMA_Patient.TransferredTransactionType
                    else
                      OutText := ''; }
{ $ELSE}
                    OutText := LastSite;
{ $ENDIF}
                  end;
{ $IFDEF CAS_DDPE_RST}
                { ctPB: begin             // pblastsite                                                  // rpk 2/15/2012
                    OutText := LastSite;
                  end; }
{ $ENDIF}
              end;  // 11
{ $IFDEF CAS_DDPE_RST}
            { 12:                         // ctlastsite
              case lstCurrentTab of
                ctUD: begin
                    OutText := LastSite;
                  end;
              end; }
{ $ENDIF}
          end;

        case lstCurrentTab of
          ctUD:
            case x of
//              0, 1, 2, 3, 6, 7, 8, 9:
//              0, 1, 2, 3, 6, 7, 8, 9, 10:
{$IFDEF CAS_DDPE_RST}
                { ord(ctRemovalStatus):
                  begin
                    aCasRect := aRect;
                    aCasRect.Left := aCasRect.Left + aCasLeftOffset;
// v.3.0.83.18
//                    if acNextActionWithDate.Checked then
//                      OutText := OutText + CAS_naDelim + '('+ aMedOrder.TextNextActionTime +')';

                    DrawText(Canvas.Handle, PChar(OutText), Length(OutText), ACasRect,
                      DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL);
                  end; }
{$ENDIF}
              ord(ctclinicname), ord(ctscanstatus), ord(ctverifynurse),
                ord(ctselfmed), ord(ctScheduleType),
//                ord(ctadministrationtime),
                ord(cttimelastgiven), ord(ctlastsite): // rpk 6/11/2012
                DrawText(Canvas.Handle, PChar(OutText), Length(OutText), ARect,
//                  DT_END_ELLIPSIS or DT_NOPREFIX);
                  DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL); // rpk 5/16/2012
            end;

          ctPB:
//          ctIV:
            case x of
//              0, 1, 2, 5, 6, 7, 8:
//              0, 1, 2, 5, 6, 7, 8, 9:
              ord(pbclinicname), ord(pbscanstatus), ord(pbverifynurse),
                ord(pbScheduleType),
//                ord(pbadministrationtime),
                ord(pblastaction), ord(pblastsite): // rpk 6/11/2012
                DrawText(Canvas.Handle, PChar(OutText), Length(OutText), ARect,
//                  DT_END_ELLIPSIS or DT_NOPREFIX);
                  DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL); // rpk 5/16/2012
            end;
          ctIV:
            case x of
//              0, 1, 2, 5, 6, 7, 8:
//              0, 1, 2, 5, 6, 7, 8, 9:
              ord(ivclinicname), ord(ivorderstatus), ord(ivverifynurse),
                ord(ivtype), ord(ivbaginformation), ord(ivorderstopdate): // rpk 6/11/2012
                DrawText(Canvas.Handle, PChar(OutText), Length(OutText), ARect,
//                  DT_END_ELLIPSIS or DT_NOPREFIX);
                  DT_WORDBREAK or DT_NOPREFIX or DT_WORD_ELLIPSIS or DT_EDITCONTROL); // rpk 5/16/2012
            end;
        end;
//        if (x = 1) and aMedOrder.OvrIntvent then
        if (x = ord(ctVerifyNurse)) and aMedOrder.OvrIntvent then // rpk 6/7/2012
          Canvas.Brush.Color := savBrushColor;
        Canvas.Font.Color := CurrentFontColor;
        Canvas.Font.Style := [];        // rpk 6/23/2011
        ARect.Right := ARect.Right + 4;
      end;
    end;
end;                                    // lstMultiOrderDrawItem

procedure TfrmMultOrder.hdrMultiOrderSectionResize(
  HeaderControl: THeaderControl; Section: THeaderSection);
var
  ii: Integer;
begin
  ReadjustHdr(HeaderControl);

  lstMultiOrder.Items.Clear;
  for ii := 0 to moList.Count - 1 do begin
    lstMultiOrder.Items.Add(piece(moList[ii], ';', 1));
    grdMultiOrder.Cells[0, ii + 1] := piece(moList[ii], ';', 1);
  end;

  lstMultiOrder.Repaint;
end;

procedure TfrmMultOrder.lstMultiOrderClick(Sender: TObject);
begin
  if lstMultiOrder.ItemIndex <> -1 then
    btnOk.Enabled := True;
end;

initialization
  SpecifyFormIsNotADialog(TfrmMultOrder);

end.
