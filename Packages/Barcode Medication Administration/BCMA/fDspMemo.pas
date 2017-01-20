unit fDspMemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, VA508AccessibilityRouter,
  VA508AccessibilityManager;

type
  TfrmDspMemo = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDspMemo: TfrmDspMemo;

implementation

{$R *.dfm}

procedure TfrmDspMemo.FormCreate(Sender: TObject);
begin
{
Delphi Help Note: 
 Constraints apply to the height of the form.
 However, the height of the form depends on how large Windows makes the title bar.
 For example, Windows XP uses much larger title bars than other windowing systems.
 To work around this, note the ClientHeight when you design your form and
 set the constraints in the FormCreate event.
 In the following example, ClientHeight is represented by x:
 Constraints.MinHeight := x + Height - ClientHeight.
 }

 // Not sure that this works as advertised....

//  Constraints.MinHeight := Height - ClientHeight;

//  Self.DoubleBuffered := True;  // rpk 2/8/2012
end;

initialization
  SpecifyFormIsNotADialog(TfrmDspMemo);
end.
