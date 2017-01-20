unit Instructor;
{
================================================================================
*	File:  Instructor.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 7 $  $Modtime: 7/20/99 3:42p $
*	Developer:    william.kurtze@domain.ext
*	Site:         VHA Dallas CIO FO
*
*	Description:  This is the form for validating an Instructor when the User is a
*								student.
*
*	Notes:
*
*
================================================================================
*	$Archive: /BCMA/BCMA Application/Instructor.pas $
*
* $History: Instructor.pas $
 *
 * *****************  Version 7  *****************
 * User: Zzzzzzkurtzw Date: 7/20/99    Time: 5:23p
 * Updated in $/BCMA/BCMA Application
 * Added and edited HelpContext ID's.
 *
 * *****************  Version 4  *****************
 * User: Zzzzzzkurtzw Date: 5/17/99    Time: 7:24p
 * Updated in $/BCMA/BCMA Application
 * Changed Uses from BCMA_Objects and BCMA_Common to BCMA_Startup.  Added
 * a save of the Instructor's name to global var InstructorName in
 * BCMA_Startup.
 *
 * *****************  Version 3  *****************
 * User: Vhatoppetitd Date: 4/20/99    Time: 3:26p
 * Updated in $/BCMA/BCMA Application
 * Set the edit boxes to null for initial displaying of the forms.
 *
 * *****************  Version 2  *****************
 * User: Vhatoppetitd Date: 3/30/99    Time: 11:06a
 * Updated in $/BCMA/BCMA Application
 * Finished Reports Menu Items, Fixed Missing Dose Window Not Closing,
 * Checked and corrected as needed the tab order on the Reports Request
 * Form.
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzkurtzw Date: 3/27/99    Time: 4:00p
 * Created in $/BCMA/BCMA Application
 * Instructor Validation from used whenever the User is a student.
*
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BCMA_Startup,
  //	BCMA_Objects,
  //	BCMA_Common,
  StdCtrls, TRPCB;
//  MFunStr;

type
  TfrmInstructor = class(TForm)
    edtAccess: TEdit;
    edtVerify: TEdit;
    btnCancel: TButton;
    btnSignOn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnSignOnClick(Sender: TObject);
    (*
      Uses RPC 'PSB INSTRUCTOR' to validate an Instructor.  If the Instructor
      is validated, ModalResult is set to mrOK otherwise, ModalResult is set
      to mrCancel.  In either case the form is closed.
    *)

    procedure btnCancelClick(Sender: TObject);
    procedure edtAccessChange(Sender: TObject);
    (*
      ModalResult is set to mrCancel and the form is closed.
    *)

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
  BCMA_Util, Hash;

procedure TfrmInstructor.btnSignOnClick(Sender: TObject);
var
  dPos: integer;
  ss,
    AccessCode,
    VerifyCode: string;
begin
  with BCMA_Broker do
  begin
    ss := edtAccess.Text + '$';
    edtAccess.Text := '';
    dPos := pos('$', ss);
    AccessCode := copy(ss, 1, dPos - 1);

    VerifyCode := edtVerify.Text;
    edtVerify.Text := '';
    if VerifyCode = '' then
      VerifyCode := copy(ss, dPos + 1, 999);

    CallServer('PSB INSTRUCTOR', [encrypt(AccessCode), encrypt(VerifyCode)],
      nil);
    if StrToIntDef(piece(Results[0], '^', 1), -1) > 0 then
    begin
      InstructorName := piece(Results[0], '^', 2);
      writeLogMessageProc(piece(Results[0], '^', 2) +
        ' Signed on as Instructor for ' +
        BCMA_User.UserName, nil);
      //					MessageDlg(piece(Results[0],'^',2) + ' Signed on as Instructor for ' +
      //						BCMA_User.UserName, mtInformation, [mbok], 0);
      ModalResult := mrOk;
    end
    else
    begin
      MessageDlg(piece(Results[0], '^', 2), mtError, [mbok], 0);
      ModalResult := mrCancel;
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

end.
