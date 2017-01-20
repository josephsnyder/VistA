unit fClosePatientCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmClosePatientCheck = class(TForm)
    chkMRR: TCheckBox;
    chkIVP: TCheckBox;
    btnCancel: TButton;
    btnIgnore: TButton;
    btnOK: TButton;
    memMRR: TMemo;
    memIVP: TMemo;
    procedure btnIgnoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ClosePatientCheck(ivpmsg: String; var mrrflag, ivpflag: Boolean): Integer;

var
  frmClosePatientCheck: TfrmClosePatientCheck;

implementation

{$R *.dfm}

function ClosePatientCheck(ivpmsg: String; var mrrflag, ivpflag: Boolean): Integer;
//var
begin
  frmClosePatientCheck := TfrmClosepatientCheck.Create(Application);
  try
    with frmClosePatientCheck do begin
      memMRR.Visible := mrrflag;
      chkMRR.Visible := mrrflag;
      chkMRR.Checked := mrrflag;

      memIVP.Visible := ivpflag;
      chkIVP.Visible := ivpflag;
      chkIVP.Checked := ivpflag;
      memIVP.Lines.Text := ivpmsg;

      Result := ShowModal;

      mrrflag := chkMRR.Checked;
      ivpflag := chkIVP.Checked;

    end;  // with

  finally
    FreeAndNil(frmClosePatientCheck);
  end;
end;

procedure TfrmClosePatientCheck.btnIgnoreClick(Sender: TObject);
begin
  chkMRR.Checked := False;
  chkIVP.Checked := False;
  ModalResult := mrIgnore;
end;

end.
