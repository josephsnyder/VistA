unit fFractional;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList, XPStyleActnCtrls, ActnMan,
  VA508AccessibilityManager, VA508AccessibilityRouter;

type
  TfrmFractional = class(TForm)
    pnlInformation: TPanel;
    lblDispensedDrugIdent: TLabel;
    pnlUnits: TPanel;
    CheckBox2: TCheckBox;
    CheckBox1: TCheckBox;
    lblPerDoseIdent: TLabel;
    pnlBackPartial: TPanel;
    btnBack: TButton;
    btnPartial: TButton;
    btnOK: TButton;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblWarning: TVA508StaticText;
    memInfo1: TMemo;
    memInfo2: TMemo;
    lblInfo2: TVA508StaticText;
    Memo1: TMemo;
    lblDispensedDrugName: TVA508StaticText;
    lblUnitsPerDose: TVA508StaticText;
    procedure CheckBox2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox2KeyPress(Sender: TObject; var Key: Char);
    procedure btnPartialClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure memInfo1Enter(Sender: TObject);
    procedure memInfo2Enter(Sender: TObject);
    procedure Memo1Enter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFractional: TfrmFractional;

implementation

uses
  MultipleDrugs;

{$R *.dfm}

procedure TfrmFractional.CheckBox2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  xx: integer;
begin
  for xx := 0 to pnlUnits.ControlCount - 1 do
    if pnlUnits.Controls[xx] is TCheckBox then
      (pnlUnits.Controls[xx] as TCheckBox).State := cbUnChecked;

  case (Sender as TCheckbox).Tag of
    1: Checkbox1.State := cbChecked;
    2: Checkbox2.State := cbChecked;
    //    3: Checkbox3.State := cbChecked;
    //    4: Checkbox4.State := cbChecked;
    //    5: Checkbox5.State := cbChecked;
    //    6: Checkbox6.State := cbChecked;
  end;
  btnOk.enabled := True;

end;

procedure TfrmFractional.CheckBox2KeyPress(Sender: TObject; var Key: Char);
var
  xx: integer;
begin
  if key = chr(VK_SPACE) then
  begin
    for xx := 0 to pnlUnits.ControlCount - 1 do
      if pnlUnits.Controls[xx] is TCheckBox then
        (pnlUnits.Controls[xx] as TCheckBox).State := cbUnChecked;
    btnOk.Enabled := True;
  end;
end;

procedure TfrmFractional.btnPartialClick(Sender: TObject);
begin
  if btnPartial.ModalResult = mrOK then
    exit;
  pnlUnits.visible := True;
  height := Height + pnlUnits.Height;
  btnPartial.Enabled := False;
  //  frmFractional.Visible := False;
end;

procedure TfrmFractional.FormCreate(Sender: TObject);
begin
  Height := Height - pnlUnits.Height;
end;

procedure TfrmFractional.memInfo1Enter(Sender: TObject);
begin
  GetScreenReader.Speak(memInfo1.text);  // rpk 9/7/2010
end;

procedure TfrmFractional.memInfo2Enter(Sender: TObject);
begin
  GetScreenReader.Speak(memInfo2.text);  // rpk 9/7/2010
end;

procedure TfrmFractional.Memo1Enter(Sender: TObject);
begin
  GetScreenReader.Speak(Memo1.text);  // rpk 9/7/2010
end;

end.
