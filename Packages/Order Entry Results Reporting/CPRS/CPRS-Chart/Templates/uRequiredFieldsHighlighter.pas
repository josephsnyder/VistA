unit uRequiredFieldsHighlighter;

interface

uses
  uTemplateFields, System.Classes, Controls, ORFn;

type
  TRequiredFieldsHighlighter = class(TObject)
  private
    function parseTemplateFieldName(aSource: String): String;
    function parseTemplateFieldID(aSource: String): String;
    function getControlValue(aControl: TObject): String;
    function getRequiredFieldsNamesValues(aParent: TWinControl): TStringList;
    procedure HighlightControl(Ctrl: TControl; aRequired: boolean);
  public
    procedure HighlightControls(aRequired: boolean);
    function parseControlFLD(aSource: String): String;
    function IsTemplateControl(aCtrl, aCtrlMain: TObject): boolean;
    function getTemplateFieldByControl(aControl: TWinControl): TTemplateField;
    function getRequiredFieldText(aFld: TTemplateField; aDelim: String = U)
      : String; overload;
    function getRequiredFieldText(aCtrl: TWinControl; aDelim: String = U)
      : String; overload;
    function getControlIndex(aControl: TWinControl): Integer;
    function getControlByInd(anInd: Integer): TWinControl;
    function getRequiredControls: TStringList;
    function getRequiredFieldNames(aParent: TWinControl;
      anIndent: String): String;
    function getNumberOfMissingFields(aParent: TWinControl): Integer;
{$IFDEF DEBUG}
    function getControlInfo(aControl: TWinControl): String;
{$ENDIF}
  end;

procedure clearRequiredControls;
procedure AddFieldControl(aFld: TTemplateField; aControl: TWinControl;
  anID: String);
procedure AddParentCheckbox(anEntry: TTemplateDialogEntry;
  aControl: TWinControl);

implementation

uses
  fOptionsTIUTemplates, ExtCtrls, ORCtrls, ORDtTm, Vcl.Graphics, Vcl.StdCtrls,
  Vcl.ComCtrls, mTemplateFieldButton, VAUtils, SysUtils, Dialogs,
  uDlgComponents;

var
  fRequiredControls: TStringList;

// Extension of the TORDateCombo
type
  TORDateCombo=class(ORDtTm.TORDateCombo)
  private
    procedure setRequiredColor(aColor:TColor);
  public
    property RequiredColor:TColor write setRequiredColor;
  end;

procedure TORDateCombo.setRequiredColor(aColor: TColor);
begin
  MonthCombo.Color := aColor;
  DayCombo.Color := aColor;
  YearEdit.Color := aColor;
end;

procedure clearRequiredControls;
begin
  if assigned(fRequiredControls) then
    fRequiredControls.Clear;
end;

procedure AddFieldControl(aFld: TTemplateField; aControl: TWinControl;
  anID: String);
var
  s: String;
begin
  try
    s := aFld.ID + U + aFld.FldName + U + IntToStr(Integer(aFld)) + U + 'FLD:' +
      anID + U + 'ctrl:' + IntToStr(Integer(aControl));;
    if aFld.Required then
      s := s + U + '(*R*)';
    fRequiredControls.AddObject(s, aControl);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure AddParentCheckbox(anEntry: TTemplateDialogEntry;
  aControl: TWinControl);
var
  s: String;
begin
  try
    s := IntToStr(Integer(anEntry));
    fRequiredControls.AddObject(s, aControl);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////

function TRequiredFieldsHighlighter.parseTemplateFieldName
  (aSource: String): String;
begin
  Result := piece(aSource, U, 2);
end;

function TRequiredFieldsHighlighter.getTemplateFieldByControl
  (aControl: TWinControl): TTemplateField;
var
  ind: Integer;
  fldID: String;
begin
  Result := nil;
  ind := fRequiredControls.IndexOfObject(aControl);
  if ind > -1 then
  begin
    fldID := parseTemplateFieldID(fRequiredControls[ind]);
    Result := getTemplateField(fldID, True);
  end;
end;

Procedure TRequiredFieldsHighlighter.HighlightControl(Ctrl: TControl;
  aRequired: boolean);
var
  Color2Use: TColor;
begin
  if not assigned(Ctrl) then
    Exit;

  Color2Use := clWindow;
  if aRequired then
  begin
    if Ctrl.Enabled then
      Color2Use := ReqHighlightColor
    else
      Color2Use := ReqHighlightDisabledColor;
  end
  else
  begin
    if ((Ctrl is TEdit) or (Ctrl is TORComboBox) or (Ctrl is TORDateCombo) or
      (Ctrl is TORDateBox) or (Ctrl is TRichEdit)) then
      Color2Use := clWindow
    else if ((Ctrl is TORCheckBox) or (Ctrl is TfraTemplateFieldButton) or
      (Ctrl is TPanel)) then
      Color2Use := clBtnFace;
  end;

  if (Ctrl is TEdit) then
    TEdit(Ctrl).Color := Color2Use
  else if (Ctrl is TORComboBox) then
    TORComboBox(Ctrl).Color := Color2Use
//  else if (Ctrl is TCPRSDialogDateCombo) then
//    TCPRSDialogDateCombo(Ctrl).Color := Color2Use
  else if (Ctrl is TORDateCombo) then
    TORDateCombo(Ctrl).RequiredColor := Color2Use
  else if (Ctrl is TCPRSDialogDateBox) then
    TCPRSDialogDateBox(Ctrl).Color := Color2Use
  else if (Ctrl is TORDateBox) then
    TORDateBox(Ctrl).Color := Color2Use
  else if (Ctrl is TRichEdit) then
    TRichEdit(Ctrl).Color := Color2Use
  else if (Ctrl is TORCheckBox) then
    TORCheckBox(Ctrl).Color := Color2Use
  else if (Ctrl is TfraTemplateFieldButton) then
    TfraTemplateFieldButton(Ctrl).Color := Color2Use
  else if (Ctrl is TPanel) then
    TPanel(Ctrl).Color := Color2Use
end;

function TRequiredFieldsHighlighter.getControlValue(aControl: TObject): String;
begin
  Result := '';
  if aControl is TEdit then
    Result := TEdit(aControl).Text
  else if (aControl is TRadioButton) and (TRadioButton(aControl).Checked) then
    Result := TRadioButton(aControl).Caption
  else if (aControl is TORComboBox) then
    Result := TORComboBox(aControl).Text
  else if (aControl is TMemo) then
    Result := TMemo(aControl).Text
  else if (aControl is TRichEdit) then
    Result := TRichEdit(aControl).Text
  else if (aControl is TORCheckBox) and (TORCheckBox(aControl).Checked) then
    Result := TORCheckBox(aControl).Caption
  else if (aControl is TCheckBox) and (TCheckBox(aControl).Checked) then
    Result := TCheckBox(aControl).Caption
end;

function TRequiredFieldsHighlighter.parseTemplateFieldID
  (aSource: String): String;
begin
  Result := piece(aSource, U, 1);
end;

function TRequiredFieldsHighlighter.parseControlFLD(aSource: String): String;
begin
  Result := piece(aSource, U, 4);
end;

function TRequiredFieldsHighlighter.getRequiredFieldText(aCtrl: TWinControl;
  aDelim: String = U): String;
var
  FLD: String;
  i: Integer;
begin
  Result := '';
  if not assigned(fRequiredControls) then
    Exit;
  i := fRequiredControls.IndexOfObject(aCtrl);
  if i < 0 then
    Exit;

  FLD := parseControlFLD(fRequiredControls[i]);
  for i := 0 to fRequiredControls.Count - 1 do
  begin
    if FLD <> parseControlFLD(fRequiredControls[i]) then
      continue;
    Result := Result + getControlValue(fRequiredControls.Objects[i]);
  end;
end;

function TRequiredFieldsHighlighter.getRequiredFieldText(aFld: TTemplateField;
  aDelim: String = U): String;
var
  s: String;
  i: Integer;
begin
  Result := '';
  for i := 0 to fRequiredControls.Count - 1 do
  begin
    if parseTemplateFieldName(fRequiredControls[i]) <> aFld.FldName then
      continue;
    s := getControlValue(fRequiredControls.Objects[i]);
    if s <> '' then
      Result := Result + s + aDelim;
  end;
  if Result <> '' then
    Result := copy(Result, 1, Length(Result) - Length(aDelim));
end;

procedure TRequiredFieldsHighlighter.HighlightControls(aRequired: boolean);
var
  i: Integer;

  procedure HighlightControlInstance(Ctrl: TWinControl; aRequired: boolean);
  var
    FLD: TTemplateField;
  begin
    FLD := getTemplateFieldByControl(Ctrl);
    if assigned(FLD) then
      HighlightControl(Ctrl, aRequired and FLD.Required and
        (getRequiredFieldText(Ctrl) = ''));
  end;

begin
  for i := 0 to fRequiredControls.Count - 1 do
  begin
    if assigned(fRequiredControls.Objects[i]) then
      HighlightControlInstance(TWinControl(fRequiredControls.Objects[i]),
        aRequired);
  end;
end;

function TRequiredFieldsHighlighter.IsTemplateControl(aCtrl,
  aCtrlMain: TObject): boolean;
begin
  if TWinControl(aCtrl).Parent = aCtrlMain then
    Result := True
  else
    Result := (TWinControl(aCtrl).Parent <> nil) and
      IsTemplateControl(TWinControl(aCtrl).Parent, aCtrlMain);
end;

function TRequiredFieldsHighlighter.getRequiredControls: TStringList;
begin
  Result := fRequiredControls;
end;

function TRequiredFieldsHighlighter.getRequiredFieldsNamesValues
  (aParent: TWinControl): TStringList;
var
  i, idx: Integer;
  Ctrl: TWinControl;
  FLD: TTemplateField;
  sl: TStringList;
  fldID, s: String;
begin
  sl := TStringList.Create;
  for i := 0 to fRequiredControls.Count - 1 do
  begin
    Ctrl := TWinControl(fRequiredControls.Objects[i]);
    if not assigned(Ctrl) then
      continue;
    if not Ctrl.Enabled then
      continue;
    if IsTemplateControl(Ctrl, aParent) then
    begin
      FLD := getTemplateFieldByControl(Ctrl);
      if not FLD.Required then
        continue;
      fldID := parseControlFLD(fRequiredControls[i]);
      idx := sl.IndexOfName(fldID);
      if idx < 0 then
        sl.Add(fldID + '=' + getControlValue(Ctrl))
      else
      begin
        s := getControlValue(Ctrl);
        if s = '' then
          continue;
        if sl.Values[fldID] <> '' then
          sl.Values[fldID] := sl.Values[fldID] + U + s
        else
          sl.Values[fldID] := s;
      end;
    end;
  end;
  Result := sl;
end;

function TRequiredFieldsHighlighter.getRequiredFieldNames(aParent: TWinControl;
  anIndent: String): String;
var
  i: Integer;
  sl: TStringList;
  s: String;

  function getFieldNameByFLD(aFld: String): String;
  var
    i: Integer;
  begin
    Result := '';
    for i := 0 to fRequiredControls.Count - 1 do
    begin
      if parseControlFLD(fRequiredControls[i]) <> aFld then
        continue;
      Result := parseTemplateFieldName(fRequiredControls[i]);
      break;
    end;
  end;

begin
  Result := '';
  sl := getRequiredFieldsNamesValues(aParent);
  for i := 0 to sl.Count - 1 do
  begin
    if sl.Values[sl.Names[i]] <> '' then
      continue;
    s := getFieldNameByFLD(sl.Names[i]);
    if s <> '' then
      Result := Result + anIndent + s + CRLF;
  end;
  sl.Free;
end;

function TRequiredFieldsHighlighter.getNumberOfMissingFields
  (aParent: TWinControl): Integer;
var
  sl: TStringList;
  i: Integer;
begin
  Result := 0;
  sl := getRequiredFieldsNamesValues(aParent);
  for i := 0 to sl.Count - 1 do
    if trim(sl.Values[sl.Names[i]]) = '' then
      inc(Result);
  sl.Free;
end;

function TRequiredFieldsHighlighter.getControlIndex
  (aControl: TWinControl): Integer;
begin
  if not assigned(aControl) then
    Result := -1
  else
    Result := fRequiredControls.IndexOfObject(aControl);
end;

function TRequiredFieldsHighlighter.getControlByInd(anInd: Integer)
  : TWinControl;
begin
  Result := nil;
  try
    Result := TWinControl(fRequiredControls.Objects[anInd]);
  except
  end;
end;

{$IFDEF DEBUG}

function TRequiredFieldsHighlighter.getControlInfo
  (aControl: TWinControl): String;
var
  ind: Integer;
begin
  if not assigned(aControl) then
    Result := 'Control is not assigned'
  else
  begin
    ind := fRequiredControls.IndexOfObject(aControl);
    if ind > -1 then
      Result := Format('%s', [fRequiredControls[ind]])
    else
      Result := 'Field is not assigned';
  end;
end;
{$ENDIF}

initialization

fRequiredControls := TStringList.Create;

finalization

fRequiredControls.Free;

end.
