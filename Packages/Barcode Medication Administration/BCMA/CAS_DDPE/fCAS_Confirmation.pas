unit fCAS_Confirmation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, VA508AccessibilityManager, ComCtrls, StdCtrls;

type
  TfrmCAS_Confirmation = class(TForm)
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    pnlUserInput: TPanel;
    bvlUnableToScanReason: TBevel;
    lblEnterAComment: TLabel;
    memComment: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    lblDispensedMeds: TLabel;
    lvwMedications: TListView;
    Panel3: TPanel;
    VA508stMessage: TVA508StaticText;
    lblMedicationCaption: TLabel;
    VA508stMedication: TVA508StaticText;
    Image: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCAS_Confirmation: TfrmCAS_Confirmation;

function CAS_Confirm(aMedicine,aMessage:String): Integer;

implementation

{$R *.dfm}

procedure TfrmCAS_Confirmation.FormCreate(Sender: TObject);
begin
  Image.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
end;

function CAS_Confirm(aMedicine,aMessage:String): Integer;
begin
  Result := -1;
  if not assigned(frmCAS_Confirmation) then
    Application.CreateForm(TfrmCAS_Confirmation,frmCas_Confirmation);
  if not assigned(frmCAS_Confirmation) then
    exit
  else with frmCAS_Confirmation do
    begin
      VA508stMedication.Caption := aMedicine;
      VA508stMessage.Caption := aMessage;
      Result := frmCAS_Confirmation.ShowModal;
    end;
end;

end.
