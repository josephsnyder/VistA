{$WARN XML_CREF_NO_RESOLVE OFF}
{$WARN XML_NO_MATCHING_PARM OFF}
unit fOptionsTIUTemplates;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, VA508AccessibilityManager,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.UITypes;

type
  TfrmTIUTemplates = class(TfrmBase508Form)
    btnOK: TButton;
    btnCancel: TButton;
    cbHighlightColor: TColorBox;
    rgNavigationPos: TRadioGroup;
    gpButtons: TGridPanel;
    btnDefaults: TButton;
    gpDetails: TGridPanel;
    ckbHighlight: TCheckBox;
    bvlNotesTitles: TBevel;
    gbHighlightColor: TGroupBox;
    procedure btnDefaultsClick(Sender: TObject);
    procedure rgNavigationPosClick(Sender: TObject);
    procedure cbHighlightColorChange(Sender: TObject);
    procedure ckbHighlightClick(Sender: TObject);
  private
    { Private declarations }
    procedure setDefaults;
    procedure setInfo(aValue:String);
    function getInfo:String;
    procedure AdjustToFontSize(aSize:Integer);
  public
    { Public declarations }
    property Info:String read getInfo write setInfo;
  end;

var
  frmTIUTemplates: TfrmTIUTemplates;

  ReqHighlightColor: TColor; // 14737656;
  ReqHighlightDisabledColor: TColor; // clSilver;
  ReqHighlight: Boolean;
  ReqHighlightAlign: Integer;

/// <summary>Opens dialog and saves preferences if changed</summary>
/// <remarks>
/// Lets user request the highlighting,select color, and position of the navigation buttons
/// </remarks>
procedure UpdateRequiredFieldsPreferences;

/// <summary>Loadts preference string from server.</summary>
/// <remarks>
/// Updates value of <c>PreferencesOnServer</c>
/// </remarks>
procedure RestoreHighlightOptions;

/// <summary>Saves preference string on server.</summary>
/// <remarks>
/// Calls server only if value of <c>PreferencesOnServer</c> is different from the dialog <c>Info</c> string
/// </remarks>
procedure SaveHighlightOptions;

implementation

uses
  ORFn
  , mRequiredFieldsNavigator
  , fTemplateDialog
  , rMisc
  , rOptions;

const
  defReqHighlightColor = clYellow;
  defReqHighlightDisabledColor = clBtnFace; // not included in the user preferences
  defReqHighlight = True;
  defReqHighlightAlign = 0;

var
  PreferencesOnServer: String;

{$R *.dfm}
////////////////////////////////////////////////////////////////////////////////
procedure setUserOptionsDefaults;
begin
  ReqHighlightColor := defReqHighlightColor;
  ReqHighlightDisabledColor := defReqHighlightDisabledColor;
  ReqHighlight := defReqHighlight;
  ReqHighlightAlign := defReqHighlightAlign;
end;

function getHighlightInfo:String;
begin
  if ReqHighlight then
    Result := '1^'
  else
    Result := '0^';

  Result := Result + IntToStr(ReqHighlightColor) + '^';
  Result := Result + IntToStr(ReqHighlightAlign);
end;

procedure setHighlightInfo(anInfo:String);
begin
  ReqHighlight := not (copy(anInfo,1,1)='0');
  ReqHighlightColor := StrToIntDef(piece(anInfo,U,2),defReqHighlightColor);
  ReqHighlightAlign := StrToIntDef(piece(anInfo,U,3),defReqHighlightAlign);
end;

procedure RestoreHighlightOptions;
var
  s:String;
begin
  s := rpcGetSetRequiredFieldsPreferences('LDPREF','');
  if pos('-',s)= 1  then
    begin
      if MessageDlg('No data found on server' + CRLF + CRLF +
        'Press OK to restore the default values' + CRLF +
        'Press Cancel to ignore', mtConfirmation,
        [mbOK,mbCancel],0) = mrOK
         then
           setUserOptionsDefaults;
      PreferencesOnServer := '';
    end
  else
    begin
      setHighlightInfo(s);
      PreferencesOnServer := s;
    end;
end;

procedure saveHighlightOptions;
var
  s,sParam: String;
begin
  sParam := getHighlightInfo;
  if sParam <> PreferencesOnServer then
    begin
      s := rpcGetSetRequiredFieldsPreferences('SVPREF',sParam);
      if pos('-',s)=1 then
        MessageDLG('Error saving Highlighting preferences'+CRLF + piece(s,U,2),mtError,[mbOK],0)
      else
        PreferencesOnServer := sParam;
    end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure UpdateRequiredFieldsPreferences;
begin
  if not assigned(frmTIUTemplates) then
    Application.CreateForm(TfrmTIUTemplates,frmTIUTemplates);

  ResizeAnchoredFormToFont(frmTIUTemplates);
  frmTIUTemplates.AdjustToFontSize(Application.MainForm.Font.Size);

  restoreHighlightOptions;
  try
    frmTIUTemplates.Info := PreferencesOnServer;
    if frmTIUTemplates.ShowModal <> mrCancel then
      SaveHighlightOptions;
  finally
    frmTIUTemplates.Release;
    frmTIUTemplates := nil;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmTIUTemplates.btnDefaultsClick(Sender: TObject);
begin
  inherited;
  setDefaults;
end;

procedure TfrmTIUTemplates.cbHighlightColorChange(Sender: TObject);
begin
  inherited;
  ReqHighLightColor := Get508CompliantColor(cbHighlightColor.Selected);

  if assigned(frmTemplateDialog) then
    frmTemplateDialog.setReqHighlightColor;
end;

procedure TfrmTIUTemplates.ckbHighlightClick(Sender: TObject);
begin
  inherited;
  ReqHighLight := ckbHighlight.checked;
{
  gbHighlightColor.Enabled := ReqHighLight;
  rgNavigationPos.Enabled := ReqHighLight;
}
  if assigned(frmTemplateDialog) then
    frmTemplateDialog.setReqHighlightColor;
end;

function TfrmTIUTemplates.getInfo:String;
begin
  if ckbHighlight.Checked then
    Result := '1^'
  else
    Result := '0^';
  Result := Result + IntToStr(cbHighlightColor.Selected) + '^';
  Result := Result + IntToStr(rgNavigationPos.ItemIndex) + '^';
end;

procedure TfrmTIUTemplates.rgNavigationPosClick(Sender: TObject);
begin
  inherited;
  ReqHighlightAlign := rgNavigationPos.ItemIndex;
  if assigned(frmTemplateDialog) then
    frmTemplateDialog.setReqHighlightAlign(rgNavigationPos.ItemIndex);
end;

procedure TfrmTIUTemplates.setInfo(aValue:String);
begin
  try
    ckbHighlight.Checked := pos('1',aValue)=1;
    cbHighlightColor.Selected := StrToIntDef(piece(aValue,U,2),clYellow);
    rgNavigationPos.ItemIndex := StrToIntDef(piece(aValue,U,3),0);
  except
    setDefaults;
  end;
end;

procedure TfrmTIUTemplates.setDefaults;
begin
  setUserOptionsDefaults;

  ckbHighlight.Checked := ReqHighlight;
  cbHighlightColor.Selected := ReqHighlightColor;
  rgNavigationPos.ItemIndex := ReqHighlightAlign;
  if assigned(frmTemplateDialog) then
    begin
      frmTemplateDialog.setReqHighlightColor;
      frmTemplateDialog.setReqHighlightAlign(ReqHighlightAlign);
    end;
end;

procedure TfrmTIUTemplates.AdjustToFontSize(aSize:Integer);
var
  X,Y,H,V:Integer;
begin
  adjustButtonSizeToFont(aSize,X,Y,H,V);

  gpButtons.ColumnCollection.Items[1].Value := X;
  gpButtons.ColumnCollection.Items[3].Value := X;
  gpButtons.ColumnCollection.Items[5].Value := X;

  gpButtons.Height := Y + V + V;

  gpButtons.RowCollection.Items[0].Value := V;
  gpButtons.RowCollection.Items[1].Value := Y;
  gpButtons.RowCollection.Items[2].Value := V;

  gpDetails.RowCollection.Items[0].Value := V;
  gpDetails.RowCollection.Items[1].Value := Y;
  gpDetails.RowCollection.Items[2].Value := V;
  gpDetails.RowCollection.Items[3].Value := trunc(Y * 2.5);
  gpDetails.RowCollection.Items[4].Value := V;
  gpDetails.RowCollection.Items[5].Value := Y * 2;

  Height := trunc(
    Y * 5.5 + V * 5 + gpDetails.Margins.Top + gpDetails.Margins.Bottom +
    gpButtons.Height +
    GetSystemMetrics(SM_CYCAPTION)); // window title bar size
{$IFDEF AA_DEBUG}
  caption :=
    Format('Y: %d  V: %d  btn: %d dt: %D Height: %d',
      [Y,V,gpButtons.Height, gpDetails.Height, Height]);
{$ENDIF}
end;

initialization

setUserOptionsDefaults;

end.
