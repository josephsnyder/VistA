{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Contains TRPCBroker and related components.
  Unit: fRPCBErrMsg Error Display to permit application control
        over bringing it to the front.
	Current Release: Version 1.1 Patch 50
*************************************************************** }

{ **************************************************
  Changes in v1.1.50 (JLI 9/1/2011) XWB*1.1*50
  1. None.
************************************************** }

unit fRPCBErrMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmErrMsg = class(TForm)
    Button1: TButton;
    mmoErrorMessage: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure RPCBShowException(Sender: TObject; E: Exception);
  end;

procedure RPCBShowErrMsg(ErrorText: String);

var
  frmErrMsg: TfrmErrMsg;

implementation

{$R *.DFM}

procedure RPCBShowErrMsg(ErrorText: String);
begin
  frmErrMsg := TfrmErrMsg.Create(Application);
  frmErrMsg.mmoErrorMessage.Lines.Add(ErrorText);
  frmErrMsg.ShowModal;
  frmErrMsg.Free;
end;

class procedure TfrmErrMsg.RPCBShowException(Sender: TObject; E: Exception);
begin
  frmErrMsg := TfrmErrMsg.Create(Application);
  frmErrMsg.mmoErrorMessage.Lines.Add(E.Message);
  frmErrMsg.ShowModal;
  frmErrMsg.Free;
end;

end.
