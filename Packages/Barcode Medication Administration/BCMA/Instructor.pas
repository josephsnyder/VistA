unit Instructor;
{
================================================================================
*	File:  Instructor.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 16 $  $Modtime: 3/01/02 9:20a $

*	Description:  This is the form for validating an Instructor when the User is a
*								student.
*
*	Notes:
*
*
*	$Archive: /BCMA GUI V2/BCMA Application/PSB_2_0/Instructor.pas $
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BCMA_Startup, BCMA_Common, StdCtrls, TRPCB,
//  MFunStr,
  BCMA_Util,
  VA508AccessibilityManager, VA508AccessibilityRouter, ExtCtrls;

type
  TfrmInstructor = class(TForm)
    edtAccess: TEdit;
    edtVerify: TEdit;
    btnCancel: TButton;
    btnSignOn: TButton;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    Label1: TLabel;
    Label2: TLabel;

    (*
      Uses RPC 'PSB INSTRUCTOR' to validate an Instructor.  If the Instructor
      is validated, ModalResult is set to mrOK otherwise, ModalResult is set
      to mrCancel.  In either case the form is closed.
    *)
    procedure btnSignOnClick(Sender: TObject);

    (*
      ModalResult is set to mrCancel and the form is closed.
    *)
    procedure btnCancelClick(Sender: TObject);

    procedure edtAccessChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInstructor: TfrmInstructor;

implementation

{$R *.DFM}
uses
  Hash;

procedure TfrmInstructor.btnSignOnClick(Sender: TObject);
const
  delim = ';';
var
  dPos: integer;
  ss,
    AccessCode,
    VerifyCode: string;
begin
  with BCMA_Broker do begin
    {
//    ss := edtAccess.Text + '$';
    // CQ 1628: use semicolon for delimiter between access and verify codes
    // entered on the same line.  // rpk 6/25/2013
    ss := edtAccess.Text + delim;
    edtAccess.Text := '';
//    dPos := pos('$', ss);
    dPos := pos(delim, ss);
    AccessCode := copy(ss, 1, dPos - 1);

    VerifyCode := edtVerify.Text;
    edtVerify.Text := '';
    if VerifyCode = '' then
      VerifyCode := copy(ss, dPos + 1, 999);
    }

    // CQ 1628: use semicolon for delimiter between access and verify codes
    // entered on the same line.  // rpk 6/25/2013

    // also re-wrote code to eliminate a trailing delimiter added to the verify code
    // when access;verify used and edtverify.text was blank

    // case 1: no delimiter in edtAccess.text
    // assign edtAccess.Text to access code
    // assign edtVerify.Text to verify code

    // case 2: delimiter is embedded in edtAccess.Text
    // copy section before delimiter to Access code
    // copy second section after delimiter to Verify code if edtVerify.text is empty

    // check for embedded delimiter
    ss := edtAccess.text;
    dpos := Pos(delim, ss);
    if dpos = 0 then begin
      AccessCode := edtAccess.Text;
      VerifyCode := edtVerify.Text;
    end
    else begin
      AccessCode := copy(ss, 1, dPos - 1);
      if edtVerify.Text = '' then
        VerifyCode := copy(ss, dPos + 1, 999)
      else
        VerifyCode := edtVerify.Text;
    end;

    edtAccess.Text := '';
    edtVerify.Text := '';

    CallServer('PSB INSTRUCTOR', [encrypt(AccessCode), encrypt(VerifyCode)],
      nil);
    if StrToInt64Def(piece(Results[0], '^', 1), -1) > 0 then begin
      BCMA_User.InstructorDUZ := piece(Results[0], '^', 1);
      InstructorName := piece(Results[0], '^', 2);
      writeLogMessageProc(piece(Results[0], '^', 2) +
        ' Signed on as Instructor for ' +
        BCMA_User.UserName, nil);
      //					MessageDlg(piece(Results[0],'^',2) + ' Signed on as Instructor for ' +
      //						BCMA_User.UserName, mtInformation, [mbok], 0);
      ModalResult := mrOk;
    end
    else begin
      DefMessageDlg(piece(Results[0], '^', 2), mtError, [mbok], 0);
      ModalResult := mrAbort;
    end;
  end;
end;

procedure TfrmInstructor.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmInstructor.edtAccessChange(Sender: TObject);
begin
  with sender as TEdit do
    btnSignOn.Enabled := (text <> '');
end;

procedure TfrmInstructor.FormActivate(Sender: TObject);
begin
  ForceForegroundWindow(handle);
end;

initialization
  SpecifyFormIsNotADialog(TfrmInstructor);

end.
