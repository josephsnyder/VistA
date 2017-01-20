unit BCMA_Timeout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, VA508AccessibilityManager;

type
  TfrmTimeOut = class(TForm)
    Timer1: TTimer;
    Button1: TButton;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblCaption: TLabel;
    lblCountDown: TStaticText;
    procedure FormCreate(Sender: TObject);
    {
      Sets the variable Counter = 30
    }

    procedure Timer1Timer(Sender: TObject);
    {
      Decrements the counter variable, updates the caption on the label, if
      counter = 0, then close.
    }

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTimeOut: TfrmTimeOut;
  Counter: Integer;
implementation

{$R *.DFM}
uses
  BCMA_Util;

procedure TfrmTimeOut.FormCreate(Sender: TObject);
begin
  ForceForegroundWindow(Self.handle);
  counter := 30;
  beep;
end;

procedure TfrmTimeOut.Timer1Timer(Sender: TObject);
begin
  dec(Counter);
  lblCountDown.caption := IntToStr(Counter);
  //  VA508STCountDown.Caption := IntToStr(Counter);
  case Counter of
    20, 10:
      begin
        ForceForegroundWindow(handle);
        beep;
      end;
  end;
  if Counter = 0 then
    Close;
end;

end.
