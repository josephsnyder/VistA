unit Options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, VA508AccessibilityManager, ExtCtrls;

type
  TfrmOptions = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    chkDebug: TCheckBox;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    Label1: TVA508StaticText;
    procedure btnOKClick(Sender: TObject);
    {
      Sets debugmode = chkDebug.Checked, closes the form
    }

    procedure btnCancelClick(Sender: TObject);
    {
      Closes the form
    }

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

uses
  BCMA_Startup;
{$R *.DFM}

procedure TfrmOptions.btnOKClick(Sender: TObject);
begin
  if BCMA_Broker <> nil then
    with BCMA_Broker do
      DebugMode := chkDebug.Checked;
  Close;
end;

procedure TfrmOptions.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
