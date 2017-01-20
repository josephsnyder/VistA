unit Splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, VHA_Objects, ComCtrls, VA508AccessibilityManager,
  VA508AccessibilityRouter;

type
  TfrmSplash = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label2: TLabel;
    Timer1: TTimer;
    prgbrSplashScreen: TProgressBar;
    stStatus: TStaticText;
    st508FileVersion: TVA508StaticText;
    stBlank: TStaticText;
    Label1: TLabel;
    Memo1: TMemo;
    stFileVersion: TStaticText;         // replacement for lblStatus
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
    procedure WriteStatus(stStr: string);
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
    //			lblFileVersion.Caption := 'Version: ' + FileVersion;
    stFileVersion.Caption := 'Version: ' + FileVersion + ' '; // rpk 7/28/2010
  finally
    free;
  end;
end;

procedure TfrmSplash.WriteStatus(stStr: string);
var
  bfocused: Boolean;
begin
  stStatus.Caption := stStr;
  bfocused := stStatus.Focused;
  if bfocused then
  begin
    stBlank.SetFocus;
  end;
  stStatus.SetFocus;
  stStatus.Invalidate;
  frmSplash.Update;
end;

initialization
  SpecifyFormIsNotADialog(TfrmSplash);

end.
