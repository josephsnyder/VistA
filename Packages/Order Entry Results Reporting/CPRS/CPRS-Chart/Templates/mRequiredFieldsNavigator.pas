unit mRequiredFieldsNavigator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, uTemplateFields, TypInfo, ORFn, ORNet, StrUtils,
  fxBroker, ORCtrls, ORDtTm, Vcl.Menus, uRequiredFieldsHighlighter;

type
  TRequiredFieldsFrame = class(TFrame)
    gpButtons: TGridPanel;
    btnPrev: TButton;
    btnNext: TButton;
    btnFirst: TButton;
    btnLast: TButton;
    stxtTotalRequired: TStaticText;
    PopupMenu1: TPopupMenu;
    T1: TMenuItem;
    B1: TMenuItem;
    L1: TMenuItem;
    R1: TMenuItem;
    pnlLmargin: TPanel;
    pnlRMargin: TPanel;
    procedure btnFirstClick(Sender: TObject);
    procedure T1Click(Sender: TObject);
  private
    { Private declarations }
    fCurrentControl: TWinControl;
    fFocusedControl: TWinControl;
    fCurrentControlInd: Integer;
    fRequiredTotal: Integer;
    procedure setRequiredTotal(aValue: Integer);
    procedure setCurrentControl(aControl: TWinControl);
    procedure setFocusedControl(aControl: TWinControl);
    function getCtrlList: TStringList;
  public
    { Public declarations }
    szButtonX: Integer;
    szButtonY: Integer;
    szMarginH: Integer;
    szMarginV: Integer;

    RFH: TRequiredFieldsHighlighter;

    property CtrlList: TStringList read getCtrlList;
    property CurrentControl: TWinControl read fCurrentControl
      write setCurrentControl;
    property CurrentControlInd: Integer read fCurrentControlInd
      write fCurrentControlInd;
    property RequiredTotal: Integer read fRequiredTotal write setRequiredTotal;

    property FocusedControl: TWinControl read fFocusedControl
      write setFocusedControl;

    function toStr: String;
    function getNextRequiredControlInd(aCurrent: Integer;
      aDirection: Integer): Integer;
    procedure setButtonStatus;
    procedure setAlign(anAl: TAlign); overload;
    procedure setAlign(anAl: Integer); overload;
    procedure focusControl(anID: Integer = -1);
    procedure adjustButtonSize(aSize: Integer);
    procedure setRowColumn(aRow, aColumn: Integer; aControlItem: TControlItem);
    procedure setV(aHeight, aWidth: Integer);
    procedure setH(aHeight, aWidth: Integer);

  end;

procedure adjustButtonSizeToFont(aSize: Integer; var X, Y, HGap, VGap: Integer);

implementation

{$R *.dfm}

uses
  VAUtils, uDlgComponents, mTemplateFieldButton, rMisc, fOptionsTIUTemplates;

procedure adjustButtonSizeToFont(aSize: Integer; var X, Y, HGap, VGap: Integer);
begin
  HGap := 8;
  case aSize of
    8, 9:
      begin
        X := 75;
        Y := 24;
        VGap := 8;
      end;
    10, 11:
      begin
        X := 85;
        Y := 26;
        VGap := 10;
      end;
    12, 13:
      begin
        X := 95;
        Y := 32;
        VGap := 12;
      end;
    14, 15, 16, 17:
      begin
        X := 120;
        Y := 38;
        VGap := 16;
      end;
    18:
      begin
        X := 150;
        Y := 42;
        VGap := 20;
      end;
  else
    begin
      X := 105;
      Y := 44;
    end;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////

function TRequiredFieldsFrame.getCtrlList: TStringList;
begin
  Assert(RFH <> nil, 'RFH is not assigned');
  Result := RFH.getRequiredControls;
end;

procedure TRequiredFieldsFrame.setButtonStatus;
var
  i: Integer;
begin
  Assert(RFH <> nil, 'RFH is not assigned');
  case fRequiredTotal of
    0:
      begin
        btnFirst.Enabled := False;
        btnLast.Enabled := False;
        btnPrev.Enabled := False;
        btnNext.Enabled := False;
      end;
    1:
      begin
        btnFirst.Enabled := True;
        btnLast.Enabled := False;
        btnPrev.Enabled := False;
        btnNext.Enabled := False;
      end;
  else
    begin
      i := getNextRequiredControlInd(CurrentControlInd, -1);
      btnFirst.Enabled := i >= 0;
      btnPrev.Enabled := i >= 0;
      i := getNextRequiredControlInd(CurrentControlInd, 1);
      btnNext.Enabled := i <= RFH.getRequiredControls.Count - 1;
      btnLast.Enabled := btnNext.Enabled;
    end;
  end;
end;

procedure TRequiredFieldsFrame.setRequiredTotal(aValue: Integer);
var
  s: String;
begin
  fRequiredTotal := aValue;
  s := 'All Required Fields have Values';
  if aValue <> 0 then
    s := 'Total Number of Required Fields without Values: ' +
      Format('%d', [aValue]);

  stxtTotalRequired.Caption := s;
  setButtonStatus;
end;

procedure TRequiredFieldsFrame.T1Click(Sender: TObject);
begin
  if Sender = T1 then
    setAlign(alTop)
  else if Sender = B1 then
    setAlign(alBottom)
  else if Sender = L1 then
    setAlign(alLeft)
  else if Sender = R1 then
    setAlign(alRight)
end;

function TRequiredFieldsFrame.getNextRequiredControlInd(aCurrent: Integer;
  aDirection: Integer): Integer;
var
  ctrl: TWinControl;
  sFLD, sFLDCurrent: String;
  bFound: Boolean;
  ind: Integer;
  fld: TTemplateField;
begin
  Assert(RFH <> nil, 'RFH is not assigned');
  Result := aCurrent;
  ind := aCurrent;
  if not assigned(CtrlList) then
    exit;

  sFLDCurrent := '';
  if (ind >= 0) and (ind < CtrlList.Count) then
  begin
    ind := ind - aDirection;
    repeat
      inc(ind, aDirection);
      if not(CtrlList.Objects[ind] is TCPRSDialogParentCheckBox) then
        break;
    until (ind = 0) or (ind = CtrlList.Count - 1);
    if ind = CtrlList.Count then
      exit;
    CurrentControlInd := ind;
    sFLDCurrent := RFH.parseControlFLD(CtrlList[CurrentControlInd]);
  end;

  bFound := False;
  repeat
    ind := ind + aDirection;

    if ind < 0 then
      bFound := True
    else if ind >= CtrlList.Count then
      bFound := True
    else
    begin
      ctrl := TWinControl(CtrlList.Objects[ind]);
      if ctrl is TCPRSDialogParentCheckBox then
        continue;
      if pos(U, CtrlList[ind]) = 0 then
        continue;
      sFLD := RFH.parseControlFLD(CtrlList[ind]);
      if sFLD = sFLDCurrent then
        continue;
      fld := RFH.getTemplateFieldByControl(ctrl);
      if not assigned(fld) or not fld.Required then
        continue;
      if not TWinControl(CtrlList.Objects[ind]).Enabled then
        continue;
      if RFH.getRequiredFieldText(TWinControl(CtrlList.Objects[ind])) <> '' then
        continue;
      bFound := True;
    end;
  until bFound;

  Result := ind;
end;

procedure TRequiredFieldsFrame.btnFirstClick(Sender: TObject);
var
  tmpBn: TButton;
  iPos, i: Integer;

  function getFLDFirstControlInd(aFLD: String): Integer;
  var
    i: Integer;
    s: String;
  begin
    Result := -1;
    s := aFLD;
    for i := 0 to CtrlList.Count - 1 do
      if RFH.parseControlFLD(CtrlList[i]) = s then
        break;
    if (i >= 0) and (i < CtrlList.Count) then
      Result := i;
  end;

begin
  inherited;
  Assert(RFH <> nil, 'RFH is not assigned');

  i := RFH.getNumberOfMissingFields(parent); // assuming parent is sbMain
  if i > 0 then
  begin
    iPos := -1;
    tmpBn := (Sender as TButton);
    if tmpBn = btnFirst then
      iPos := getNextRequiredControlInd(-1, 1)
    else if tmpBn = btnLast then
      iPos := getNextRequiredControlInd(CtrlList.Count, -1)
    else if tmpBn = btnPrev then
      iPos := getNextRequiredControlInd(CurrentControlInd, -1)
    else if tmpBn = btnNext then
      iPos := getNextRequiredControlInd(CurrentControlInd, 1);
    if (iPos >= 0) and (iPos < CtrlList.Count) then
      CurrentControlInd := iPos;

    if (CurrentControlInd < 0) or (CurrentControlInd >= CtrlList.Count) then
    else if (CtrlList.Objects[CurrentControlInd] is TWinControl) then
    begin
      if TWinControl(CtrlList.Objects[CurrentControlInd]).Visible and
        TWinControl(CtrlList.Objects[CurrentControlInd]).Enabled then
        TWinControl(CtrlList.Objects[CurrentControlInd]).SetFocus;
      stxtTotalRequired.Caption :=
        IntToStr(Integer(CtrlList.Objects[CurrentControlInd])) + '  ' +
        CtrlList.Objects[CurrentControlInd].ClassName;
    end;
  end;
  RequiredTotal := i;
end;

function TRequiredFieldsFrame.toStr: String;
begin
  Result := Format('Current Control Index: %d', [CurrentControlInd]);
  Result := Result + CRLF + 'Font Size: ' + IntToStr(Font.Size) + CRLF +
    'Button Width: ' + IntToStr(szButtonX) + CRLF + 'Button Height: ' +
    IntToStr(szButtonY) + CRLF + 'Button Margin: ' + IntToStr(szMarginH) + CRLF
    + 'Width: ' + IntToStr(Width) + CRLF + 'Heidth: ' + IntToStr(Height) + CRLF;
  Result := Result + CRLF + RFH.getRequiredFieldNames(parent, '  ');
end;

procedure TRequiredFieldsFrame.focusControl(anID: Integer = -1);
var
  ind: Integer;
begin
  if CtrlList.Count < 1 then
    exit;
  if anID = -1 then
    ind := CurrentControlInd
  else
    ind := anID;

  if ind < 0 then
    ind := 0;

  if assigned(CtrlList.Objects[ind]) then
    if assigned(TWinControl(CtrlList.Objects[ind]).parent) and
      TWinControl(CtrlList.Objects[ind]).Enabled then
      TWinControl(CtrlList.Objects[ind]).SetFocus
    else
      ShowMessage('Error setting focus on control ' + CRLF +
        TWinControl(CtrlList.Objects[ind]).Name + CRLF +
        TWinControl(CtrlList.Objects[ind]).QualifiedClassName);
end;

procedure TRequiredFieldsFrame.setCurrentControl(aControl: TWinControl);
var
  ind: Integer;
begin
  if aControl = nil then
    exit;
  if aControl is TCPRSDialogParentCheckBox then
    exit;
  if aControl is TORComboEdit then
    exit;

  ind := getCtrlList.IndexOfObject(aControl);
  CurrentControlInd := ind;
end;

procedure TRequiredFieldsFrame.setFocusedControl(aControl: TWinControl);
var
  ind: Integer;
  fld: TTemplateField;
begin
  Assert(RFH <> nil, 'RFH is not assigned');

  fFocusedControl := aControl;
  fld := RFH.getTemplateFieldByControl(aControl);
  if assigned(fld) then
  begin
    if fld.Required then
      if (RFH.getRequiredFieldText(fld, U) = '') then
        CurrentControl := aControl
      else
      begin
        ind := RFH.getControlIndex(aControl);
        if ind > -1 then
        begin
          ind := getNextRequiredControlInd(ind, 1);
          if (ind > -1) and (ind < RFH.getRequiredControls.Count) then
            CurrentControl := RFH.getControlByInd(ind);
        end;
      end;
    setButtonStatus;
  end;
end;

procedure TRequiredFieldsFrame.setRowColumn(aRow, aColumn: Integer;
  aControlItem: TControlItem);
begin
  aControlItem.Column := aColumn;
  aControlItem.Row := aRow;
  aControlItem.RowSpan := 1;
  aControlItem.ColumnSpan := 1;
end;

procedure TRequiredFieldsFrame.setV(aHeight, aWidth: Integer);
var
  i: Integer;
  ctrl: TControlItem;
  ci: TCellItem;

begin
  ci := gpButtons.RowCollection[0];
  ci.SizeStyle := ssAbsolute;
  ci.Value := 4.0;
  for i := 1 to 4 do
  begin
    ci := gpButtons.RowCollection[i];
    ci.SizeStyle := ssAbsolute;
    ci.Value := aHeight;
  end;
  ci := gpButtons.RowCollection[5];
  ci.SizeStyle := ssPercent;
  ci.Value := 100.0;

  ci := gpButtons.ColumnCollection[0];
  ci.SizeStyle := ssPercent;
  ci.Value := 100.0;
  for i := 1 to 4 do
  begin
    ci := gpButtons.ColumnCollection[i];
    ci.SizeStyle := ssAbsolute;
    ci.Value := 0.0;
  end;

  for i := 0 to gpButtons.ControlCollection.Count - 1 do
  begin
    ctrl := gpButtons.ControlCollection[i];
    if ctrl.Control = btnFirst then
      setRowColumn(1, 0, ctrl)
    else if ctrl.Control = btnPrev then
      setRowColumn(2, 0, ctrl)
    else if ctrl.Control = btnNext then
      setRowColumn(3, 0, ctrl)
    else if ctrl.Control = btnLast then
      setRowColumn(4, 0, ctrl)
    else if ctrl.Control = stxtTotalRequired then
      setRowColumn(5, 0, ctrl)
  end;
end;

procedure TRequiredFieldsFrame.setH(aHeight, aWidth: Integer);
var
  i: Integer;
  ci: TCellItem;
  ctrl: TControlItem;
begin
  ci := gpButtons.RowCollection[0];
  ci.SizeStyle := ssAbsolute;
  ci.Value := aHeight;

  for i := 1 to 5 do
  begin
    ci := gpButtons.RowCollection[i];
    ci.SizeStyle := ssAbsolute;
    ci.Value := 0.0;
  end;

  ci := gpButtons.ColumnCollection[0];
  ci.SizeStyle := ssPercent;
  ci.Value := 100.0;
  for i := 1 to 4 do
  begin
    ci := gpButtons.ColumnCollection[i];
    ci.SizeStyle := ssAbsolute;
    ci.Value := aWidth;
  end;

  for i := 0 to gpButtons.ControlCollection.Count - 1 do
  begin
    ctrl := gpButtons.ControlCollection[i];
    if ctrl.Control = stxtTotalRequired then
      setRowColumn(0, 0, ctrl)
    else if ctrl.Control = btnFirst then
      setRowColumn(0, 1, ctrl)
    else if ctrl.Control = btnPrev then
      setRowColumn(0, 2, ctrl)
    else if ctrl.Control = btnNext then
      setRowColumn(0, 3, ctrl)
    else if ctrl.Control = btnLast then
      setRowColumn(0, 4, ctrl)
  end;
end;

procedure TRequiredFieldsFrame.setAlign(anAl: TAlign);
begin
  case anAl of
    alNone:
      ;
    alTop:
      begin
        if parent.align = alTop then
          exit
        else if align = alBottom then
          align := alTop
        else
        begin
          setH(szButtonY, szButtonX);
          align := alTop;
          Height := szButtonY;
        end;
      end;
    alBottom:
      begin
        if align = alBottom then
          exit
        else if align = alTop then
          align := alBottom
        else
        begin
          setH(szButtonY, szButtonX);
          align := alBottom;
          Height := szButtonY;
        end;
      end;
    alLeft:
      begin
        if align = alLeft then
          exit
        else if align = alRight then
          align := alLeft
        else
        begin
          setV(szButtonY, szButtonX);
          align := alLeft;
          Width := pnlLmargin.Width + pnlLmargin.Width + szButtonX;
        end;
      end;

    alRight:
      begin
        if align = alRight then
          exit
        else if align = alLeft then
          align := alRight
        else
        begin
          setV(szButtonY, szButtonX);
          align := alRight;
          Width := pnlLmargin.Width + pnlLmargin.Width + szButtonX;
        end;
      end;
    alClient:
      ;
    alCustom:
      ;
  end;
  invalidate;
end;

procedure TRequiredFieldsFrame.adjustButtonSize(aSize: Integer);
begin
  adjustButtonSizeToFont(aSize, szButtonX, szButtonY, szMarginH, szMarginV);
  setAlign(ReqHighlightAlign);
end;

procedure TRequiredFieldsFrame.setAlign(anAl: Integer);
begin
  case anAl of
    0:
      setAlign(alTop);
    1:
      setAlign(alBottom);
    2:
      setAlign(alLeft);
    3:
      setAlign(alRight);
  else
    setAlign(alTop);
  end;
end;

end.
