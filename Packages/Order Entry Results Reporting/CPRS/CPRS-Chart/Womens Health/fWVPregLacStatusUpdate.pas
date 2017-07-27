unit fWVPregLacStatusUpdate;
{
  ================================================================================
  *
  *       Application:  TDrugs Patch OR*3*377 and WV*1*24
  *       Developer:    PII                 
  *       Site:         Salt Lake City ISC
  *
  *       Description:  Update form to enter the appropriate information for
  *                     pregnancy and lactation data. Caller supplies the
  *                     appropriate patient via the TWVPatient object as
  *                     an IWVPaitent interface.
  *
  *       Notes:
  *
  ================================================================================
}

interface

uses
  System.Actions,
  System.Classes,
  System.SysUtils,
  System.UITypes,
  System.Variants,
  Vcl.ActnList,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Menus,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows,
  iWVInterface;

type
  TfrmWVPregLacStatusUpdate = class(TForm)
    btnCancel: TButton;
    btnSave: TButton;
    pnlOptions: TPanel;
    pnlPregnancyStatus: TPanel;
    bvlPregnancyStatus: TBevel;
    ckbxAbleToConceiveYes: TCheckBox;
    ckbxAbleToConceiveNo: TCheckBox;
    ckbxMenopause: TCheckBox;
    ckbxHysterectomy: TCheckBox;
    stxtAbleToConceive: TStaticText;
    stxtCurrentlyPregnant: TStaticText;
    ckbxPregnantYes: TCheckBox;
    ckbxPregnantNo: TCheckBox;
    ckbxPregnantUnsure: TCheckBox;
    dtpLastMenstrualPeriod: TDateTimePicker;
    stxtLastMenstrualPeriod: TStaticText;
    pnlLactationStatus: TPanel;
    bvlLactationStatus: TBevel;
    ckbxLactatingYes: TCheckBox;
    ckbxLactatingNo: TCheckBox;
    Bevel1: TBevel;
    stxtLactationStatus: TStaticText;
    ckbxPermanent: TCheckBox;
    pnlEddMethod: TPanel;
    lblEDDMethod: TLabel;

    procedure AbleToConceiveYesNo(Sender: TObject);
    procedure PregnantYesNoUnsure(Sender: TObject);
    procedure dtpLastMenstrualPeriodChange(Sender: TObject);
    procedure CheckOkToSave(Sender: TObject);
    procedure ckbxLactatingYesNoClick(Sender: TObject);
  private
    { Private declarations }
    fDFN: string;
  public
    function Execute: Boolean;
    function GetData(aList: TStringList): Boolean;
  end;

function NewPLUpdateForm(aDFN: string): TfrmWVPregLacStatusUpdate;

implementation

{$R *.dfm}


const
  { Names for Name=Value pairs }
  SUB_ABLE_TO_CONCEIVE = 'ABLE TO CONCEIVE';
  SUB_LACTATION_STATUS = 'LACTATION STATUS';
  SUB_LAST_MENSTRUAL_PERIOD = 'LAST MENSTRUAL PERIOD DATE';
  SUB_MEDICAL_REASON = 'MEDICAL REASON';
  SUB_PATIENT = 'PATIENT';
  SUB_PREGNANCY_STATUS = 'PREGNANCY STATUS';

function NewPLUpdateForm(aDFN: string): TfrmWVPregLacStatusUpdate;
var
  i: integer;
begin
  Result := TfrmWVPregLacStatusUpdate.Create(Application.MainForm);

  with Result do
    begin
      Loaded;
      Position := poMainFormCenter;
      fDFN := aDFN;
      pnlPregnancyStatus.Visible := True;
      pnlLactationStatus.Visible := True;

      i := pnlOptions.Height;

      if pnlLactationStatus.Visible then
        i := i + pnlLactationStatus.Height + pnlLactationStatus.Margins.Top + pnlLactationStatus.Margins.Bottom;

      if pnlPregnancyStatus.Visible then
        i := i + pnlPregnancyStatus.Height + pnlPregnancyStatus.Margins.Top + pnlPregnancyStatus.Margins.Bottom;

      ClientHeight := i;
    end;
end;

procedure TfrmWVPregLacStatusUpdate.CheckOkToSave(Sender: TObject);
begin
  if ckbxAbleToConceiveYes.Checked then
    btnSave.Enabled := ckbxPregnantYes.Checked or ckbxPregnantNo.Checked or ckbxPregnantUnsure.Checked
  else if ckbxAbleToConceiveNo.Checked then
    btnSave.Enabled := ckbxHysterectomy.Checked or ckbxMenopause.Checked or ckbxPermanent.Checked
  else if ckbxLactatingYes.Checked or ckbxLactatingNo.Checked then
    btnSave.Enabled := True
  else
    btnSave.Enabled := False;
end;

procedure TfrmWVPregLacStatusUpdate.ckbxLactatingYesNoClick(Sender: TObject);
begin
  if Sender = ckbxLactatingYes then
    if ckbxLactatingYes.Checked then
      ckbxLactatingNo.Checked := False;

  if Sender = ckbxLactatingNo then
    if ckbxLactatingNo.Checked then
      ckbxLactatingYes.Checked := False;

  CheckOkToSave(Sender);
end;

procedure TfrmWVPregLacStatusUpdate.dtpLastMenstrualPeriodChange(Sender: TObject);
begin
  dtpLastMenstrualPeriod.Format := '';
end;

procedure TfrmWVPregLacStatusUpdate.AbleToConceiveYesNo(Sender: TObject);
begin
  if Sender = ckbxAbleToConceiveYes then
    if ckbxAbleToConceiveYes.Checked then
      ckbxAbleToConceiveNo.Checked := False;

  if Sender = ckbxAbleToConceiveNo then
    if ckbxAbleToConceiveNo.Checked then
      ckbxAbleToConceiveYes.Checked := False;

  if ckbxAbleToConceiveYes.Checked then
    begin
      ckbxMenopause.Checked := False;
      ckbxMenopause.Enabled := False;
      ckbxHysterectomy.Checked := False;
      ckbxHysterectomy.Enabled := False;
      ckbxPermanent.Checked := False;
      ckbxPermanent.Enabled := False;

      ckbxPregnantYes.Enabled := True;
      ckbxPregnantNo.Enabled := True;
      ckbxPregnantUnsure.Enabled := True;

      stxtLastMenstrualPeriod.Enabled := False;
      dtpLastMenstrualPeriod.Enabled := False;
      dtpLastMenstrualPeriod.Format := ' ';
      lblEDDMethod.Enabled := False;
    end
  else if ckbxAbleToConceiveNo.Checked then
    begin
      ckbxMenopause.Enabled := True;
      ckbxHysterectomy.Enabled := True;
      ckbxPermanent.Enabled := True;

      ckbxPregnantYes.Enabled := False;
      ckbxPregnantYes.Checked := False;
      ckbxPregnantNo.Enabled := False;
      ckbxPregnantNo.Checked := False;
      ckbxPregnantUnsure.Enabled := False;
      ckbxPregnantUnsure.Checked := False;

      stxtLastMenstrualPeriod.Enabled := False;
      dtpLastMenstrualPeriod.Enabled := False;
      dtpLastMenstrualPeriod.Format := ' ';
      lblEDDMethod.Enabled := False;
    end
  else
    begin
      ckbxMenopause.Checked := False;
      ckbxMenopause.Enabled := False;
      ckbxHysterectomy.Checked := False;
      ckbxHysterectomy.Enabled := False;
      ckbxPermanent.Checked := False;
      ckbxPermanent.Enabled := False;

      ckbxPregnantYes.Enabled := False;
      ckbxPregnantYes.Checked := False;
      ckbxPregnantNo.Enabled := False;
      ckbxPregnantNo.Checked := False;
      ckbxPregnantUnsure.Enabled := False;
      ckbxPregnantUnsure.Checked := False;

      stxtLastMenstrualPeriod.Enabled := False;
      dtpLastMenstrualPeriod.Enabled := False;
      dtpLastMenstrualPeriod.Format := ' ';
      lblEDDMethod.Enabled := False;
    end;

  CheckOkToSave(Sender);
end;

procedure TfrmWVPregLacStatusUpdate.PregnantYesNoUnsure(Sender: TObject);
begin
  if Sender = ckbxPregnantYes then
    if ckbxPregnantYes.Checked then
      begin
        ckbxPregnantNo.Checked := False;
        ckbxPregnantUnsure.Checked := False;
        stxtLastMenstrualPeriod.Enabled := True;
        dtpLastMenstrualPeriod.Enabled := True;
        dtpLastMenstrualPeriod.DateTime := Now;
        dtpLastMenstrualPeriod.Format := ' ';
        lblEDDMethod.Enabled := True;
      end
    else
      begin
        stxtLastMenstrualPeriod.Enabled := False;
        dtpLastMenstrualPeriod.Enabled := False;
        dtpLastMenstrualPeriod.Format := ' ';
        lblEDDMethod.Enabled := False;
      end;

  if Sender = ckbxPregnantNo then
    if ckbxPregnantNo.Checked then
      begin
        ckbxPregnantYes.Checked := False;
        ckbxPregnantUnsure.Checked := False;
      end;

  if Sender = ckbxPregnantUnsure then
    if ckbxPregnantUnsure.Checked then
      begin
        ckbxPregnantYes.Checked := False;
        ckbxPregnantNo.Checked := False;
      end;

  CheckOkToSave(Sender);
end;

function TfrmWVPregLacStatusUpdate.Execute: Boolean;
begin
  Result := (ShowModal = mrOk);
end;

function TfrmWVPregLacStatusUpdate.GetData(aList: TStringList): Boolean;
var
  aDateTime: TDateTime;
  y, m, d: Word;
  aStr: string;

  procedure AddReason(var aStr: string; aValue: string);
  begin
    if aStr <> '' then
      begin
        // Remove any previous 'and's
        if Pos(' and ', aStr) > 0 then
          aStr := StringReplace(aStr, ' and ', ', ', [rfReplaceAll]);
        // Append on this value with a gramatically correct 'and'
        aStr := Format('%s and %s', [aStr, aValue]);
        // Set capitialization to gramatically correct first char only
        aStr := UpperCase(Copy(aStr, 1, 1)) + LowerCase(Copy(aStr, 2, Length(aStr)));
      end
    else
      aStr := aValue;
  end;

begin
  aList.Clear;
  try
    aList.Values[SUB_PATIENT] := fDFN;

    if ckbxAbleToConceiveYes.Checked then
      begin
        aList.Values[SUB_ABLE_TO_CONCEIVE] := 'Yes';

        if ckbxPregnantYes.Checked then
          begin
            aList.Values[SUB_PREGNANCY_STATUS] := 'Yes';

            if dtpLastMenstrualPeriod.Format = '' then
              begin
                aDateTime := dtpLastMenstrualPeriod.DateTime;
                DecodeDate(aDateTime, y, m, d);
                aList.Values[SUB_LAST_MENSTRUAL_PERIOD] := IntToStr(((y - 1700) * 10000) + (m * 100) + d);
              end
          end
        else if ckbxPregnantNo.Checked then
          aList.Values[SUB_PREGNANCY_STATUS] := 'No'
        else if ckbxPregnantUnsure.Checked then
          aList.Values[SUB_PREGNANCY_STATUS] := 'Unsure'
        else
          aList.Values[SUB_PREGNANCY_STATUS] := 'Unknown';
      end
    else if ckbxAbleToConceiveNo.Checked then
      begin
        aList.Values[SUB_ABLE_TO_CONCEIVE] := 'No';
        aStr := '';

        if ckbxHysterectomy.Checked then
          AddReason(aStr, ckbxHysterectomy.Caption);

        if ckbxMenopause.Checked then
          AddReason(aStr, ckbxMenopause.Caption);

        if ckbxPermanent.Checked then
          AddReason(aStr, ckbxPermanent.Caption);

        aList.Values[SUB_MEDICAL_REASON] := aStr;
      end;

    if ckbxLactatingYes.Checked then
      aList.Values[SUB_LACTATION_STATUS] := 'Yes'
    else if ckbxLactatingNo.Checked then
      aList.Values[SUB_LACTATION_STATUS] := 'No';

    Result := True;
  except
    on e: Exception do
      begin
        aList.Clear;
        aList.Add('-1^' + e.Message);
        Result := False;
      end;
  end;
end;

end.
