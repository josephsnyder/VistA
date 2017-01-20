unit Splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, VHA_Objects, ComCtrls;

type
  TfrmSplash = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    lblStatus: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    lblFileVersion: TLabel;
    pnl508: TPanel;
    lbl508: TLabel;
    prgbrSplashScreen: TProgressBar;
    Label1: TLabel;
    Label3: TLabel;
    procedure Timer1Timer(Sender: TObject);
    {
      Sets timer enabled equal to false
    }

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    {
      Checks to see if the form can close
    }

    procedure FormCreate(Sender: TObject);
    {
      obtains the file version information and places it on the form
    }

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.DFM}

procedure TfrmSplash.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TfrmSplash.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not Timer1.Enabled;
end;

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  with TVersionInfo.Create(application) do
  try
    lblFileVersion.Caption := 'Version: ' + FileVersion;
  finally
    free;
  end;
end;

end.
