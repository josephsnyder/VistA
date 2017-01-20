unit fPtConfirmation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, BCMA_Objects, BCMA_Common,
  VA508AccessibilityManager, VA508AccessibilityRouter;

function ConfirmPatient : Boolean;

type
  TfrmPtConfirmation = class(TForm)
    pnlDemographics: TPanel;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    btnContinue: TButton;
    grpSensitive: TGroupBox;
    grpPatientFlags: TGroupBox;
    memPatientFlags: TMemo;
    grpAllergies: TGroupBox;
    memAllergies: TMemo;
    memADRs: TMemo;
    btnFlagDetails: TButton;
    edtName: TEdit;
    edtSSN: TEdit;
    edtDOB: TEdit;
    edtWard: TEdit;
    edtRmBd: TEdit;
    memSensitiveMSG: TMemo;
    pnlButtonMessage: TPanel;
    pnlMessage: TPanel;
    cbSpeedbump_Patient_Identifiers: TCheckBox;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblSSN: TLabel;
    lblName: TLabel;
    lblWard: TLabel;
    lblRmBd: TLabel;
    lblDOB: TLabel;
    lblAllergies: TLabel;
    lblADRs: TLabel;
    procedure cbSpeedbump_Patient_IdentifiersClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure btnFlagDetailsClick(Sender: TObject);
    procedure pnlButtonMessageEnter(Sender: TObject);
    procedure pnlButtonMessageExit(Sender: TObject);
    procedure pnlMessageEnter(Sender: TObject);
    procedure pnlMessageExit(Sender: TObject);
    procedure memPatientFlagsEnter(Sender: TObject);
    procedure memAllergiesEnter(Sender: TObject);
    procedure memADRsEnter(Sender: TObject);
  private
    { Private declarations }
    function PatientRecordText: string;
  public
    { Public declarations }
  end;

var
  frmPtConfirmation: TfrmPtConfirmation;

implementation

uses BCMA_Main, BCMA_Startup, BCMA_Util;

{$R *.dfm}

procedure TfrmPtConfirmation.FormShow(Sender: TObject);
//var
//  Status: integer;
//  msg: string;
begin
  lblSSN.Caption := '&' + BCMA_SiteParameters.PatientIDLabel + ':'; // rpk 9/15/2010
  if grpSensitive.Visible = False then
    height := height - grpSensitive.Height;

  if IsUnableToScan and not (ReadOnly or LimitedAccess or EditMedLog) then
  begin
    // added reset of ActiveControl so that form starts with confirmation checkbox
    // when entering from Unable to Scan mode.
//    ActiveControl := cbSpeedbump_Patient_Identifiers; // rpk 8/23/2010  commented out: bjr 8/22/2012
    cbSpeedbump_Patient_Identifiers.Visible := True;
    btnOk.Enabled := False;
  end
  else
  begin
    ActiveControl := btnCancel; // rpk 8/23/2010
    cbSpeedbump_Patient_Identifiers.Visible := False;
    if not btnContinue.Visible then
      btnOk.Enabled := True;
  end;
end;

procedure TfrmPtConfirmation.memADRsEnter(Sender: TObject);
begin
  GetScreenReader.Speak(memADRs.text); // rpk 9/7/2010
end;

procedure TfrmPtConfirmation.memAllergiesEnter(Sender: TObject);
begin
  GetScreenReader.Speak(memAllergies.text); // rpk 9/7/2010
end;

procedure TfrmPtConfirmation.memPatientFlagsEnter(Sender: TObject);
begin
  GetScreenReader.Speak(memPatientFlags.text); // rpk 9/7/2010
end;

function ConfirmPatient: Boolean;
var
  Status: integer;
  msg: string;
begin
  Result := False;
  frmMain.StatusBar.Panels[0].Text := 'Checking Sensitive Patient...';
  frmMain.StatusBar.Repaint;

  BCMA_Patient.CheckSensitive(Status, msg);
  frmMain.StatusBar.Panels[0].Text := '';
  msg := StringReplace(msg, '*', '', [rfReplaceAll]);
  msg := trim(msg);
  with TfrmPtConfirmation.create(Application) do
  try
    memSensitiveMsg.Clear; // rpk 8/19/2010
    with BCMA_Patient do
    begin
      case Status of
        0, 1:
          begin
            edtSSN.Text := SSN;
            edtDOB.Text := DOB;
            grpSensitive.Visible := (Status = 1);
            if Status = 1 then
              memSensitiveMsg.Text := msg;
            pnlButtonMessage.Caption := 'Is this the correct patient?';
            btnContinue.Visible := False;
            btnOk.Enabled := False;
          end;
        2:
          begin
            memSensitiveMsg.text := msg;
            edtSSN.text := '*SENSITIVE*';
            edtDOB.text := '*SENSITIVE*';
            pnlButtonMessage.Caption :=
              'Click accept if you understand the security issues.';
            btnOk.Enabled := False;

            if IsUnableToScan and not (ReadOnly or LimitedAccess or EditMedLog) then begin
              cbSpeedbump_Patient_Identifiers.Enabled := False; //bjr 8/22/2012
//              btnContinue.Enabled := False;
              btnContinue.Enabled := True; //bjr 8/22/2012
            end;

          end;
      else
        begin
          memSensitiveMsg.text := msg;
          edtSSN.text := '*SENSITIVE*';
          pnlButtonMessage.Caption := 'Unable to Continue';
          btnContinue.Visible := False;
          btnOk.Enabled := False;
        end;
      end; // case Status
      btnFlagDetails.Enabled := frmMain.actionFlag.Enabled;
      memPatientFlags.Text := PatientRecordText;
      memPatientFlags.SelStart := 0; // rpk 8/30/2010
      if BCMA_Patient.PatientRecordFlags.Count > 0 then // same as frmMain.actionFlag.Enabled ?
        btnFlagDetails.Enabled := True;
      edtName.text := Name;
      edtWard.text := Ward;
      edtRmBd.text := RmBed;
      memAllergies.Text := Allergies;
      memAllergies.SelStart := 0; // rpk 8/30/2010
      memADRs.Text := ADRs;
      memADRs.SelStart := 0; // rpk 8/30/2010
      pnlMessage.Caption := AdminMessage;
      if AdminMessage = '' then
        pnlMessage.Enabled := False;

      btnFlagDetails.Enabled := BCMA_Patient.PatientRecordFlags.Count > 0;
    end;

    Result := (showModal = mrOK);
  finally
//    free;
    Release; // rpk 6/18/2013
  end;

end;

{ procedure TfrmPtConfirmation.cbSpeedbump_Patient_IdentifiersClick(
  Sender: TObject);
var
  Status: integer;
  msg: string;
begin
  BCMA_Patient.CheckSensitive(Status, msg);

  if cbSpeedbump_Patient_Identifiers.Checked then
    if Status = 2 then
    begin
      //btnContinue.Visible := True;  bjr 8/22/2012
      //btnContinue.Enabled := True;  bjr 8/22/2012
      btnOK.Enabled := True;  //bjr 8/22/2012
    end
    else
      btnOK.Enabled := True
  else
  begin
    if Status = 2 then
    begin
      btnContinue.Enabled := False;
      btnOK.Enabled := False;
    end
    else
      btnOK.Enabled := False
  end;

end; }

procedure TfrmPtConfirmation.cbSpeedbump_Patient_IdentifiersClick(
  Sender: TObject);
var
  Status: integer;
  msg: string;
begin
  BCMA_Patient.CheckSensitive(Status, msg);

  if cbSpeedbump_Patient_Identifiers.Checked then
    if Status = 2 then begin
//      btnContinue.Visible := True; //bjr 8/22/2012
//      btnContinue.Enabled := True; //bjr 8/22/2012
//      btnOK.Enabled := False;
      btnOK.Enabled := True;  //bjr 8/22
    end
    else
      btnOK.Enabled := True
  else
  begin
    btnOK.Enabled := False;
    if Status = 2 then
    begin
      btnContinue.Enabled := False;
//      btnOK.Enabled := False;
    end
//    else
//      btnOK.Enabled := False
  end;

end; // cbSpeedbump_Patient_IdentifiersClick


procedure TfrmPtConfirmation.btnContinueClick(Sender: TObject);
begin
  with BCMA_Patient do
    if BCMA_Broker <> nil then
      with BCMA_Broker do
        if CallServer('DG SENSITIVE RECORD BULLETIN', [IEN], nil) then
          if Results[0] = '0' then
          begin
            DefMessageDlg('Sensitive record logging failed, this patient cannot be opened at this time!', mtError, [mbOK], 0);
            exit;
          end
          else
          begin
            edtSSN.text := SSN;
            edtDOB.text := DOB;
            //btnOK.Enabled := True;  bjr 8/22/2012
            btnContinue.Enabled := False;

            if IsUnableToScan and not (ReadOnly or LimitedAccess or EditMedLog) then begin
              cbSpeedbump_Patient_Identifiers.Enabled := True; //bjr 8/22/2012
              //lblButtonMessage.Caption := 'Is this the correct patient?';
//              if btnCancel.CanFocus then  // rpk 2/5/2013
//                btnCancel.SetFocus;
              // btnCancel.SetFocus;  bjr 8/22/2012
              if not cbSpeedbump_Patient_Identifiers.CanFocus then // rpk 9/21/2012
                cbSpeedbump_Patient_Identifiers.Show; // rpk 9/21/2012
              ActiveControl := cbSpeedbump_Patient_Identifiers; //bjr 8/22/2012
              if cbSpeedbump_Patient_Identifiers.CanFocus then // rpk 2/5/2013
                cbSpeedbump_Patient_Identifiers.SetFocus; // rpk 9/21/2012
            end
            else begin
              btnOK.Enabled := True; // rpk 9/21/2012
              btnCancel.SetFocus; // rpk 9/21/2012
            end;
          end;
end;

function TfrmPtConfirmation.PatientRecordText: string;
//var aPiece, aPatientRecordText: String;
var
  x: integer;
begin
  with BCMA_Patient do
    if PatientRecordFlags.Count > 0 then
      for x := 0 to PatientRecordFlags.Count - 1 do
        if x = 0 then
          Result := PatientRecordFlags[x]
        else
          Result := Result + ', ' + PatientRecordFlags[x];
  {
    if BCMA_Patient.PatientRecordFlags <> '' then
      aPatientRecordText := BCMA_Patient.PatientRecordFlags
    else
      exit;
    Result := Piece(aPatientRecordText, '^', 1);
    aPiece := Result;
    Delete(aPatientRecordText, 1, Length(aPiece) + 1);
    while Length(aPatientRecordText) > 0 do
    begin
      aPiece := Piece(aPatientRecordText, '^', 1);
      Result := Result + ', ' + aPiece;
      Delete(aPatientRecordText, 1, Length(aPiece) + 1);
    end;
  }
end;

procedure TfrmPtConfirmation.pnlButtonMessageEnter(Sender: TObject);
begin
  pnlButtonMessage.BevelKind := bkSoft;
end;

procedure TfrmPtConfirmation.pnlButtonMessageExit(Sender: TObject);
begin
  pnlButtonMessage.BevelKind := bkNone;
end;

procedure TfrmPtConfirmation.pnlMessageEnter(Sender: TObject);
begin
  pnlMessage.BevelKind := bkSoft;
end;

procedure TfrmPtConfirmation.pnlMessageExit(Sender: TObject);
begin
  pnlMessage.BevelKind := bkNone;
end;

procedure TfrmPtConfirmation.btnFlagDetailsClick(Sender: TObject);
begin
  frmMain.actionFlag.Execute;
end;

end.

