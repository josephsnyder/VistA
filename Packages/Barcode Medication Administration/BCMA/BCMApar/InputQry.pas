unit InputQry;
{
================================================================================
*	File:  InputQry.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 12 $  $Modtime: 2/28/02 5:15p $
*
*	Description:  This is an InputQry form for the application.  This is an
*               InputQuery with enhancements.
*
*	Notes:
*
*
================================================================================
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, BCMA_Util;

(*
  Uses form TfrmInputQry to prompt for user input.  Input argument DefaultStr
  provides an optional Default value.  If MaxStrLength is greater than zero,
  then length(result) <= MaxStrLength.  If isRequired = True, then a blank
  result is not allowed.  If isMasked = True, then user input is masked.  The
  result is blank, if the user cancels.
*)
function inputPrompt(const TitleStr, PromptStr, DefaultStr: string;
  MaxStrLength: Integer; isRequired, isMasked: boolean;
  var CheckState: Boolean; CheckCaption: string): string;

(*
  Uses form TfrmInputQry to prompt for user input.  Input argument DefaultStr
  provides an optional Default value.  If MaxStrLength is greater than zero,
  then length(result) <= MaxStrLength.  If isRequired = True, then a blank
  result is not allowed.  If isMasked = True, then user input is masked.  The
  result is blank, if the user cancels.  Allows two checkboxes to be used.
  At least one checkbox must be selected for OK to be enabled.
*)
function inputPrompt2(const TitleStr, PromptStr, DefaultStr: string;
  MaxStrLength: Integer; isRequired, isMasked: boolean;
  var CheckState: Boolean; CheckCaption: string;
  var CheckState2: Boolean; CheckCaption2: string = ''): string;

type
  TfrmInputQry = class(TForm)
    pnlButton: TPanel;
    lblPrompt: TLabel;
    edtInputQry: TEdit;
    lblMaximum: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    chkCheckBox: TCheckBox;
    chkCheckBox2: TCheckBox;
    procedure edtInputQryChange(Sender: TObject);
    (*
      Enables the OK button if isBlankAllowed = True or if the edtInputQry
      text value is not blank.
    *)

    procedure btnOKClick(Sender: TObject);
    (*
      Saves the user input into ResultStr and sets the ModalResult = mrOK,
      closing the form.
    *)

    procedure edtInputQryKeyPress(Sender: TObject; var Key: Char);
    {
      If we receive a carriage return (ie, from the scanner), close the form.
    }

    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkCheckBoxClick(Sender: TObject);
    {
      Force the form to the foreground as the main form may have focus as a
      result of the shared broker.
    }

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInputQry: TfrmInputQry;
  isBlankAllowed: boolean;
  ResultStr: string;

implementation

{$R *.DFM}
uses
  Math;

var
  ip2: Boolean;                         // set true when inputPrompt2 is called (for body sites only)

function inputPrompt(const TitleStr, PromptStr, DefaultStr: string;
  MaxStrLength: Integer; isRequired, isMasked: boolean;
  var CheckState: Boolean; CheckCaption: string): string;
begin
  result := '';
  ip2 := False;                         // rpk 6/8/2016

  with TfrmInputQry.Create(application) do
  try
    caption := TitleStr;
    lblPrompt.Caption := PromptStr;
    edtInputQry.Text := DefaultStr;
    edtInputQry.MaxLength := max(0, MaxStrLength);

    with chkCheckBox do
    begin
      Visible := CheckCaption <> '';
      Caption := CheckCaption;
      Checked := CheckState;
    end;
    if edtInputQry.MaxLength > 0 then
      lblMaximum.caption := 'Maximum Length = ' + intToStr(edtInputQry.MaxLength)
    else
      lblMaximum.caption := '';

    isBlankAllowed := not isRequired;
    btnOK.Enabled := not isRequired;

    if isMasked then
      edtInputQry.PasswordChar := '*';

    if TitleStr = 'Add New Item' then   // rpk 9/9/2016
      HelpContext := 14                 // rpk 9/9/2016
    else if TitleStr = 'Edit Item' then // rpk 9/9/2016
      HelpContext := 15;                // rpk 9/9/2016

    if (showModal = mrOK) then
      result := ResultStr;
    CheckState := chkCheckBox.Checked;
  finally
    free;
  end;
end;

function inputPrompt2(const TitleStr, PromptStr, DefaultStr: string;
  MaxStrLength: Integer; isRequired, isMasked: boolean;
  var CheckState: Boolean; CheckCaption: string;
  var CheckState2: Boolean; CheckCaption2: string = ''): string;
begin
  result := '';
  ip2 := True;                          // rpk 6/8/2016

  with TfrmInputQry.Create(application) do
  try
    caption := TitleStr;
    lblPrompt.Caption := PromptStr;
    edtInputQry.Text := DefaultStr;
    edtInputQry.MaxLength := max(0, MaxStrLength);

    with chkCheckBox do
    begin
      Visible := CheckCaption <> '';
      Caption := CheckCaption;
      Checked := CheckState;
    end;
    with chkCheckBox2 do
    begin
      Visible := CheckCaption2 <> '';
      Caption := CheckCaption2;
      Checked := CheckState2;
    end;
    if edtInputQry.MaxLength > 0 then
      lblMaximum.caption := 'Maximum Length = ' + intToStr(edtInputQry.MaxLength)
    else
      lblMaximum.caption := '';

    isBlankAllowed := not isRequired;
    btnOK.Enabled := not isRequired;

    if isMasked then
      edtInputQry.PasswordChar := '*';

    if TitleStr = 'Add New Item' then   // rpk 9/9/2016
      HelpContext := 14                 // rpk 9/9/2016
    else if TitleStr = 'Edit Item' then // rpk 9/9/2016
      HelpContext := 15;                // rpk 9/9/2016

    if (showModal = mrOK) then
      result := ResultStr;
    CheckState := chkCheckBox.Checked;
    CheckState2 := chkCheckBox2.Checked;

  finally
    free;
  end;
end;


procedure TfrmInputQry.chkCheckBoxClick(Sender: TObject);
begin
  // if called from inputprompt2 for body sites, ensure that at least one checkbox is checked
  // to enable OK button
  if ip2 then
    btnOK.Enabled := ((chkCheckBox.Visible and chkCheckBox.Checked) or
      (chkCheckBox2.Visible and chkCheckBox2.Checked)) and
//      (isBlankAllowed or (edtInputQry.text <> ''));    /// trim to eliminate blank
    (isBlankAllowed or (trim(edtInputQry.text) <> '')); // trim to eliminate blank; rpk 8/26/2016
end;

procedure TfrmInputQry.edtInputQryChange(Sender: TObject);
begin
//  btnOK.Enabled := (isBlankAllowed or (edtInputQry.text <> ''));
  // if called from inputprompt2 for body sites, ensure that at least one checkbox is checked
  if ip2 then begin                     // rpk 6/8/2016
    btnOK.Enabled := ((chkCheckBox.Visible and chkCheckBox.Checked) or
      (chkCheckBox2.Visible and chkCheckBox2.Checked)) and
//      (isBlankAllowed or (edtInputQry.text <> ''))
    (isBlankAllowed or (trim(edtInputQry.text) <> '')) // trim to eliminate blank; rpk 8/26/2016
  end                                   // rpk 6/7/2016
  else                                  // rpk 6/7/2016
    btnOK.Enabled := (isBlankAllowed or (edtInputQry.text <> '')); // rpk 6/7/2016
end;

procedure TfrmInputQry.btnOKClick(Sender: TObject);
begin
  ResultStr := edtInputQry.text;
  modalResult := mrOK;
end;

procedure TfrmInputQry.edtInputQryKeyPress(Sender: TObject; var Key: Char);
begin
  if edtInputQry.text <> '' then
    if key = chr(VK_RETURN) then
    begin
      ResultStr := edtInputQry.text;
      modalResult := mrOK;
    end;
end;

procedure TfrmInputQry.FormActivate(Sender: TObject);
begin
  ForceForegroundWindow(handle);
end;

procedure TfrmInputQry.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

initialization
  isBlankAllowed := True;
end.

