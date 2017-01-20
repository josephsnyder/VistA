unit MedLog;
{
================================================================================
*	File:  MedLog.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 25 $  $Modtime: 2/06/02 12:29p $
*
*	Description:  This form is for logging transactions for a patient's active
*               medication orders.  There is a tabsheet for each type of
*               transaction.  Only the tabsheet for one transaction type is
*               visible at a time.
*
*	Notes:
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls,
  BCMA_Objects, VA508AccessibilityManager, VA508AccessibilityRouter,
  BCMA_Util;                            //bjr 8/14/2012

type
  TfrmMedLog = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    PageControl: TPageControl;
    tsConfirmPRN: TTabSheet;
    btnSubmit: TBitBtn;
    BitBtn2: TBitBtn;
    lbxPRNReasons: TListBox;
    tsPRNEffectiveness: TTabSheet;
    tsConfirmContinuous: TTabSheet;
    tsNotGiven: TTabSheet;
    tsAddComment: TTabSheet;
    mmoAddComment: TMemo;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblConfirmPRNSelectReason: TLabel;
    lblPRNEffEnterComment: TLabel;
    Label9: TLabel;
    lblConfContEnterComment: TLabel;
    Label8: TLabel;
    lblNotGivenSelectReason: TLabel;
    lblAddCommentEnterComment: TLabel;
    memConfCont: TMemo;
    memPRNEffectiveness: TMemo;
    lbxNotGivenReasons: TListBox;
    Panel3: TPanel;
    pnlImage: TPanel;
    Image: TImage;
    pnlMedications: TPanel;
    lblActiveMedicationCaption: TLabel;
    lblActiveMedication: TVA508StaticText;
    lblDispensedDrugCaption: TLabel;
    lblDispensedDrug: TVA508StaticText;
    pnlInstructions: TPanel;
    lblSpecInstructions: TLabel;
    pnlScrollDown: TPanel;
    lblScrollDown: TStaticText;
    btnDisplaySIOPI: TButton;
    mmoSpecialInstructions: TMemo;
    pnlMessage: TPanel;
    lblMessage: TLabel;
    mmoMessage: TMemo;
    pnlConfirmation: TPanel;
    memConfComment: TMemo;
    lblConfComment: TLabel;
    procedure FormCreate(Sender: TObject);
    (*
      Initially sets the visibility of all tabs to False.  Clears all display
      areas.
    *)

    procedure FormShow(Sender: TObject);
    (*
      Checks the current MedOrder for validity, then fills readonly fields.
      Sets up the active page corresponding to the transaction type.
    *)

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    (*
      Checks to make sure all required data is entered before closing the
      form.  Uses method CanCloseCheck prior to allowing an mrOK close.
    *)

    procedure btnOKClick(Sender: TObject);
    (*
      Sets ModalResult to mrOK, closing the form.
    *)

    procedure lbxPRNReasonsEnter(Sender: TObject);
    (*
      Enables the Submit button, since a reason has now been selected.
    *)

    procedure lbxPRNReasonsKeyPress(Sender: TObject; var Key: Char);
    (*
      If the <Enter> key is pressed, the btnOKClick method is run.
    *)

    procedure lbxPRNReasonsClick(Sender: TObject);
    {
      if an item is selected, then enable the ok button
    }

    procedure mmoAddCommentChange(Sender: TObject);
    procedure mmoSpecialInstructionsEnter(Sender: TObject);
    procedure mmoMessageEnter(Sender: TObject);
    procedure mmoAddCommentEnter(Sender: TObject);
    procedure lbxNotGivenReasonsClick(Sender: TObject);
    procedure memConfContChange(Sender: TObject);
    procedure memPRNEffectivenessChange(Sender: TObject);
    procedure memPRNEffectivenessEnter(Sender: TObject);
    procedure memConfContEnter(Sender: TObject);
    procedure lbxNotGivenReasonsEnter(Sender: TObject);
    procedure lbxNotGivenReasonsKeyPress(Sender: TObject; var Key: Char);
    procedure mmoAddCommentMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mmoAddCommentMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mmoAddCommentContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure mmoAddCommentMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure lbxPRNReasonsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure btnDisplaySIOPIClick(Sender: TObject);
    procedure memConfCommentChange(Sender: TObject);
    {
      If a comment is added, enable the ok button.
    }

  private
    { Private declarations }
    function CanCloseCheck: boolean;
    (*
      Returns True if all required data has been entered or selected.
    *)
    procedure setViewMode(aMode: string);
    procedure Clear;
  public
    { Public declarations }
    MedOrder: TBCMA_MedOrder;
    MedLogType: TMedLogTypes;
  end;

var
  frmMedLog         : TfrmMedLog;

// if redmesg is true, highlight message in red
function ConfirmComment(aMedication, aDrug, aMessage: string; redmesg: Boolean;
  var aComment: string): boolean;         // rpk 4/11/2016

implementation
{$R *.DFM}

uses
  BCMA_Common, Math;

function ConfirmComment(aMedication, aDrug, aMessage: string; redmesg: Boolean;
  var aComment: string): boolean;
begin
  Result := False;
  if not assigned(frmMedLog) then
    Application.CreateForm(TfrmMedLog, frmMedLog);
  if not assigned(frmMedLog) then
    Exit;
  with frmMedLog do
  begin
    Clear;
    setViewMode('Confirmation');
    lblActiveMedication.Caption := aMedication;
    lblDispensedDrug.Caption := aDrug;
    mmoMessage.Font.Color := IfThen(redmesg, clRed, clWindowText);  // rpk 4/11/2016
    mmoMessage.Text := aMessage;
    Result := ShowModal = mrOK;
    aComment := memConfComment.Text;
  end;
  FreeAndNil(frmMedLog);
end;                                    // ConfirmComment

procedure TfrmMedLog.Clear;
var
  ii                : integer;
begin
  with PageControl do
    for ii := 0 to PageCount - 1 do
      pages[ii].TabVisible := False;

  mmoSpecialInstructions.Clear;         // rpk 8/16/2010
  mmoMessage.clear;
  mmoAddComment.clear;
  memConfCont.Clear;
  memPRNEffectiveness.Clear;
  lbxPRNReasons.items.clear;            // rpk 9/15/2010
  lbxNotGivenReasons.Items.Clear;       // rpk 9/15/2010

{$IFDEF CAS_DDPE_RST}                   // aan v.3.0.83.17 2015-06-25
  pnlImage.Visible := False;
  Image.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
  memConfComment.Clear;                 // rpk 9/16/2015
  memConfComment.TabStop := False;      // rpk 7/23/2015
  pnlConfirmation.SendToBack;
  pnlConfirmation.Hide;                 // rpk 7/22/2015
{$ENDIF}
end;                                    // Clear

procedure TfrmMedLog.FormCreate(Sender: TObject);
begin
  Clear;
  PageControl.BringToFront;             // rpk 9/16/2015
end;

procedure TfrmMedLog.FormShow(Sender: TObject);
begin
  // Set Help for Form to Help of TabSheet for help for specific report request.
  if PageControl.ActivePage <> nil then // rpk 7/22/2015
    HelpContext := PageControl.ActivePage.HelpContext; // rpk 8/5/2015

  with PageControl do begin
    ActivePage.TabVisible := True;

    if ActivePage = tsAddComment then begin
      with mmoAddComment do begin
        parent := ActivePage;
        clear;
        show;
        setFocus;
      end;
    end
    else if ActivePage = tsPRNEffectiveness then begin
      with memPRNEffectiveness do begin
        parent := ActivePage;
        clear;
        show;
        setFocus;
      end;
    end
    else if ActivePage = tsConfirmContinuous then begin
      with memConfCont do begin
        parent := ActivePage;
        clear;
        show;
        setFocus;
      end;
    end
    else if (ActivePage = tsNotGiven) then begin
      with lbxNotGivenReasons do begin
        parent := ActivePage;
        itemIndex := -1;
        show;
        setFocus;
      end;
    end
    else if (ActivePage = tsConfirmPRN) then
      with lbxPRNReasons do begin
        parent := ActivePage;
        lblMessage.Caption := 'Last Four Actions:';
        itemIndex := -1;
        show;
        setFocus;
      end;
  end;

  mmoSpecialInstructions.SelStart := 0; // rpk 3/19/2012
  pnlScrollDown.Visible := mmoSpecialInstructions.Lines.Count > 6;  // rpk 3/14/2012

end;                                    // FormShow

procedure TfrmMedLog.setViewMode(aMode: string);
begin
  if aMode = 'Confirmation' then
  begin
    pnlConfirmation.Left := PageControl.Left; // rpk 7/22/2015
    pnlConfirmation.Top := PageControl.Top; // rpk 7/22/2015
    pnlConfirmation.Height := PageControl.Height; // rpk 7/22/2015
    pnlConfirmation.Width := PageControl.Width; // rpk 7/22/2015
    mmoAddComment.TabStop := False;     // rpk 7/23/2015
    pnlConfirmation.BringToFront;       // rpk 7/22/2015
    pnlConfirmation.Show;               // rpk 7/22/2015
    pnlImage.Visible := true;
    pnlInstructions.Visible := False;
//      mmoAddComment.Ctl3D := False;
    PageControl.ActivePage := tsAddComment;
    Caption := aMode;                   // rpk 7/17/2015
  end
  else
  begin
    pnlConfirmation.SendToBack;
    PageControl.BringToFront;
    PageControl.Show;
    pnlInstructions.Visible := True;
    mmoAddComment.Ctl3D := True;
    mmoAddComment.TabStop := True;      // rpk 7/23/2015
    Clear;
    Caption := 'Medication Log';
  end;
end;                                    // setViewMode


procedure TfrmMedLog.btnDisplaySIOPIClick(Sender: TObject);
var
  tbool             : Boolean;
begin
  if MedOrder <> nil then begin
    with Medorder do begin
      tbool := DisplaySIOPI(False);     // rpk 11/09/2011
    end;
  end;
end;

procedure TfrmMedLog.btnOKClick(Sender: TObject);
begin
  if pnlConfirmation.Visible then       // rpk 9/16/2015
    mmoAddComment.Text := memConfComment.Text; // allow form to close
end;

function TfrmMedLog.CanCloseCheck: boolean;
var
  errMsg            : string;
begin
  result := False;
  errMsg := '';                         // rpk 9/16/2015
  with PageControl do begin
    if (ActivePage = tsConfirmContinuous) then begin
      memConfCont.text := StripString(memConfCont.text); //bjr 8/16/2012
      if Trim(memConfCont.text) <> '' then {// rpk 8/19/2010} begin
        cmtUserComments := memConfCont.text;
        result := True;
      end
      else
        errMsg := 'You Must Enter a Comment!';
    end
    else if (ActivePage = tsPRNEffectiveness) then begin
      if Trim(memPRNEffectiveness.text) <> '' then {// rpk 8/19/2010} begin
        cmtUserComments := memPRNEffectiveness.text;
        result := True;
      end
      else
        errMsg := 'You Must Enter a Comment!';
    end
    else if (ActivePage = tsAddComment) then begin
      if Trim(mmoAddComment.text) <> '' then {// rpk 8/19/2010} begin
        cmtUserComments := mmoAddComment.text;
        result := True;
      end
      else
        errMsg := 'You Must Enter a Comment!';
    end
    else if (ActivePage = tsConfirmPRN) then begin
      with lbxPRNReasons do
        if itemIndex > -1 then begin
          cmtReasonGivenPRN := Items[lbxPRNReasons.itemIndex];
          result := True;
        end
        else
          errMsg := 'You Must Select a Reason from the List!';
    end
    else if (ActivePage = tsNotGiven) then begin
      with lbxNotGivenReasons do
        if itemIndex > -1 then begin
          cmtUserComments := Items[lbxNotGivenReasons.itemIndex];
          result := True;
        end
        else
          errMsg := 'You Must Select a Reason from the List!';
    end;
  end;
  if errMsg > '' then                   // rpk 9/16/2015
    DefMessageDlg(errMsg, mtError, [mbOK], 0); // rpk 9/16/2015
end;                                    // CanCloseCheck

procedure TfrmMedLog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  canClose := (modalResult = mrCancel) or CanCloseCheck;
  if not CanClose then
    PageControl.ActivePage.setFocus;
end;

procedure TfrmMedLog.lbxNotGivenReasonsClick(Sender: TObject);
begin
  if lbxNotGivenReasons.ItemIndex <> -1 then
    btnOK.Enabled := True;
end;

procedure TfrmMedLog.lbxNotGivenReasonsEnter(Sender: TObject);
begin
  btnSubmit.Enabled := True;
end;

procedure TfrmMedLog.lbxNotGivenReasonsKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(VK_RETURN) then
    btnOKClick(Sender);
end;

procedure TfrmMedLog.lbxPRNReasonsClick(Sender: TObject);
begin
  if lbxPRNReasons.ItemIndex <> -1 then
    btnOK.Enabled := True;
end;

procedure TfrmMedLog.lbxPRNReasonsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  bval              : Boolean;
begin
  bval := Handled;
end;

procedure TfrmMedLog.lbxPRNReasonsEnter(Sender: TObject);
begin
  btnSubmit.Enabled := True;
end;

procedure TfrmMedLog.lbxPRNReasonsKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(VK_RETURN) then
    btnOKClick(Sender);
end;

procedure TfrmMedLog.memConfCommentChange(Sender: TObject);
begin
  btnOK.Enabled := trim(memConfComment.Text) <> ''; // rpk 7/22/2015
end;

procedure TfrmMedLog.memConfContChange(Sender: TObject); // rpk 9/15/2010
begin
  if trim(memConfCont.Text) <> '' then  //bjr 5/12/10 for BCMA00000425
    btnOK.Enabled := True
  else
    btnOK.Enabled := False;
end;

procedure TfrmMedLog.memConfContEnter(Sender: TObject);
begin
  GetScreenReader.Speak(memConfCont.text); // rpk 9/7/2010
end;

procedure TfrmMedLog.memPRNEffectivenessChange(Sender: TObject); // rpk 9/15/2010
begin
  if trim(memPRNEffectiveness.Text) <> '' then //bjr 5/12/10 for BCMA00000425
    btnOK.Enabled := True
  else
    btnOK.Enabled := False;
end;

procedure TfrmMedLog.memPRNEffectivenessEnter(Sender: TObject);
begin
  GetScreenReader.Speak(memPRNEffectiveness.text); // rpk 9/7/2010
end;

procedure TfrmMedLog.mmoAddCommentChange(Sender: TObject);
begin
  if trim(mmoAddComment.Text) <> '' then //bjr 5/12/10 for BCMA00000425
    btnOK.Enabled := True
  else
    btnOK.Enabled := False;
end;

procedure TfrmMedLog.mmoAddCommentContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  bval              : Boolean;
begin
  bval := Handled;
end;

procedure TfrmMedLog.mmoAddCommentEnter(Sender: TObject);
begin
  GetScreenReader.Speak(mmoAddComment.text); // rpk 9/7/2010
end;

procedure TfrmMedLog.mmoAddCommentMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
var
  maval             : TMouseActivate;
  ix, iy            : Integer;
begin
  maval := MouseActivate;
  ix := X;
  iy := Y;
end;

procedure TfrmMedLog.mmoAddCommentMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  btn               : TMouseButton;
  ix, iy            : Integer;
begin
  btn := Button;
  ix := X;
  iy := Y;
end;

procedure TfrmMedLog.mmoAddCommentMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ix, iy            : Integer;
begin
  ix := X;
  iy := Y;
end;

procedure TfrmMedLog.mmoMessageEnter(Sender: TObject);
begin
  GetScreenReader.Speak(mmoMessage.text); // rpk 9/7/2010
end;

procedure TfrmMedLog.mmoSpecialInstructionsEnter(Sender: TObject);
begin
  GetScreenReader.Speak(mmoSpecialInstructions.text); // rpk 9/7/2010
end;

end.

