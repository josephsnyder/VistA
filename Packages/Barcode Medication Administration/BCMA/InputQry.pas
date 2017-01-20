unit InputQry;
{
================================================================================
*	File:  InputQry.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 12 $  $Modtime: 2/28/02 5:15p $
*
*	Description:  This is an InputQry form for the application.  This is an
*               InputQuery with enhancements.
*
*	Notes:        Changed labels to VA508StaticText  rpk 8/26/2009
*
*
================================================================================
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, BCMA_Util, BCMA_Objects,
  VA508AccessibilityManager, VA508AccessibilityRouter;

function inputPrompt(const TitleStr, PromptStr, DefaultStr: string;
  MaxStrLength: Integer; isRequired, isMasked: boolean;
  OrderTypeID: TOrderTypes;             // rpk 3/11/2011
  var CheckState: Boolean; CheckCaption: string; DisplaylblMaximum: Boolean =
  True): string;
(*
  Uses form TfrmInputQry to prompt for user input.  Input argument DefaultStr
  provides an optional Default value.  If MaxStrLength is greater than zero,
  then length(result) <= MaxStrLength.  If isRequired = True, then a blank
  result is not allowed.  If isMasked = True, then user input is masked.  Also,
  if isMasked is true, isValidManualInput should not be called since an e-signature
  may be all-numeric.  The result is blank, if the user cancels.
*)

type
  TfrmInputQry = class(TForm)
    pnlButton: TPanel;
    edtInputQry: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    chkCheckBox: TCheckBox;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    vstPrompt: TLabel;
    vstMaximum: TLabel;
    procedure edtInputQryChange(Sender: TObject);
    (*
      Enables the OK button if isBlankAllowed = True or if the edtInputQry
      text value is not blank.
    *)

    procedure btnOKClick(Sender: TObject);
    (*
      Saves the user input into ResultStr and sets the ModalResult = mrOK,
      closing the form.
    *)

    procedure edtInputQryKeyPress(Sender: TObject; var Key: Char);
    {
      If we receive a carriage return (ie, from the scanner), close the form.
    }

    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    {
      Force the form to the from to the foreground as the main form may have focus as a
      result of the shared broker.
    }

  private
    { Private declarations }
    ///
    ///  NOTE: isMasked (in inputPrompt) is currently true only when inputPrompt
    ///  is called for an e-signature.
    ///  isValidManualInput should only be called for quantity/units input.
    ///  It should not be called when isMasked is true.
    ///
    function isValidManualInput(inStr: string): Boolean;

  public
    { Public declarations }
  end;

var
  frmInputQry: TfrmInputQry;
  isBlankAllowed: boolean;
  ResultStr: string;

implementation

{$R *.DFM}
uses
  BCMA_Startup, BCMA_Main, BCMA_Common,
//  MFunStr,
  Math;

var
  iqOrderTypeID: TOrderTypes;
  MsgDlgOn: Boolean;
  validateInput: Boolean;

function inputPrompt(const TitleStr, PromptStr, DefaultStr: string;
  MaxStrLength: Integer; isRequired, isMasked: boolean;
  OrderTypeID: TOrderTypes;             // rpk 3/11/2011
  var CheckState: Boolean; CheckCaption: string; DisplaylblMaximum: Boolean =
  True): string;
var
  frmInputQry: TfrmInputQry;
begin
  result := '';
  iqOrderTypeID := OrderTypeID;
  MsgDlgOn := False;
  /// use validateInput to decide when to call isValidManualInput.  See comments
  ///  in interface.
  validateInput := not isMasked;

//  with TfrmInputQry.Create(application) do
  frmInputQry := TfrmInputQry.Create(application);
//  with TfrmInputQry.Create(application) do

//  with frmInputQry do begin
  try
    with frmInputQry do begin           // rpk 2/23/2012
      caption := TitleStr;
    //    lblPrompt.Caption := PromptStr;
      vstPrompt.Caption := PromptStr;
      edtInputQry.Text := DefaultStr;
      edtInputQry.MaxLength := max(0, MaxStrLength);

      with chkCheckBox do begin
        Visible := CheckCaption <> '';
        Caption := CheckCaption;
        Checked := CheckState;
      end;
    //    if (edtInputQry.MaxLength > 0) and DisplaylblMaximum then
    //      lblMaximum.caption := 'Maximum Length = ' + intToStr(edtInputQry.MaxLength)
    //    else
    //      lblMaximum.caption := '';

      if ScreenReaderSystemActive then begin // rpk 8/29/2010
        if (edtInputQry.MaxLength > 0) and DisplaylblMaximum then
          vstPrompt.caption := PromptStr + ', Maximum Length = ' +
            intToStr(edtInputQry.MaxLength);
        vstMaximum.caption := '';
      end
      else begin
        if (edtInputQry.MaxLength > 0) and DisplaylblMaximum then
          vstMaximum.caption := 'Maximum Length = ' +
            intToStr(edtInputQry.MaxLength)
        else
          vstMaximum.caption := '';
      end;

      isBlankAllowed := not isRequired;
      btnOK.Enabled := not isRequired;

      if isMasked then
        edtInputQry.PasswordChar := '*';

      if (showModal = mrOK) then
        result := ResultStr;
      CheckState := chkCheckBox.Checked;
      MsgDlgOn := False;
    end;                                // with frmInputQry
  finally
//    free;
//    frmInputQry.Free;
    frmInputQry.Release;                // rpk 6/18/2013
  end;                                  // try
end;                                    // inputPrompt

function TfrmInputQry.isValidManualInput(inStr: string): Boolean;
var
  ival: Int64;
  i, upos, vpos, lenstr: Integer;
  c: Char;
  aIVBag: TBCMA_IVBags;
  tmpstr, msgstr: string;
  TestSet: set of ' '..'Z';
begin
  Result := True;

  /// ignore validation when inputPrompt called for e-signature.
  if not ValidateInput then begin
    ResultStr := edtInputQry.text;
    exit;
  end;

  msgstr := '';
  TestSet := ['0'..'9', 'V'];
  tmpstr := Trim(InStr);
  tmpstr := UpperCase(tmpstr);

  // test for string with embedded blank or comma which indicates more than one word
  // expect multi-word input, e.g., 25 ml
  //// Removed one word test since some one word input is valid: e.g., sparingly.

  ///
  ///? Do we want to allow a single text character input?
  /// What is minimum number of text-only characters?
  ///
  // Will only trap integer, IV label, and drug code errors when more than one word in input.

  upos := Pos('U', tmpstr);
  vpos := Pos('V', tmpstr);
  lenstr := Length(tmpstr);

  // if we match a plain integer of any kind, probably found scanned input since
  // nurse should be including the units abbreviation.
  // reject as invalid manual input.

  if TryStrToInt64(tmpstr, ival) then
    Result := False;

  // test for all numeric string
  if Result and (upos = 0) and (vpos = 0) then begin
    Result := False;
    TestSet := ['0'..'9'];
    for I := 1 to lenstr do begin
      c := tmpstr[i];
      if not (c in TestSet) then begin
        Result := True;
        break;
      end;
    end;
    // if still false at this point, string matches nnnnnn,
    // plain numeric is not acceptable, reject it.
  end;

  // test for nnnVnnn which is an IV label
  if Result and (vpos > 0) and (vpos < lenstr) then begin
    Result := False;
    for I := 1 to lenstr do begin
      c := tmpstr[i];
      if not (c in TestSet) then begin
        Result := True;
        break;
      end;
    end;
  // if still false at this point, string matches nnnVnnn for IV label,
  // reject it.
  end;

  // test for nnnnnU  or nnnnn U  (number and U for units)
  if Result and (upos = lenstr) then begin
    Result := False;
    TestSet := [' ', '.', '0'..'9', 'U']; // rpk 5/25/2011
    for I := 1 to lenstr do begin
      c := tmpstr[i];
      if not (c in TestSet) then begin
        Result := True;
        break;
      end;
    end;
    // if still false at this point, string matches nnnnnn U for number units,
    // single letter U is not acceptable, reject it.
    if not Result then
      msgstr :=
        '"U" or "u" is not an acceptable abbreviation.' + CRLF +
        'Retype entry using the word "units".';
  end;

  if Result then begin
    // check for scanned input as known drug code
    if BCMA_Broker <> nil then begin
      with BCMA_Broker do begin

        case lstcurrenttab of

          ctUD: begin
              if CallServer('PSB SCANMED', [inStr,
                lstUnitDoseCurrentTab[lstCurrentTab]], nil) then begin
                // if ScanMed fails, treat as unknown, accept as valid input since
                // we don't have a real match on drug IEN, etc.  Avoid false negative.
                if Results.Count - 1 <> StrToInt(Results[0]) then begin
                  DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
                  Result := True;
                end
                // else if -1, no match on drug IEN for current tab,  treat as valid manual input.
                else if piece(Results[1], '^', 1) = '-1' then
                  Result := True;
              end;
            end;

          ctPB: begin
              case iqOrderTypeID of
                otUnitDose: begin
                  // IVP order
                    if CallServer('PSB SCANMED', [inStr,
                      lstUnitDoseCurrentTab[lstCurrentTab]], nil) then begin
                      // if ScanMed fails, treat as unknown, accept as valid input since
                      // we don't have a real match on drug IEN, etc.  Avoid false negative.
                      if Results.Count - 1 <> StrToInt(Results[0]) then begin
                        DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
                        Result := True;
                      end
                      // else if -1, no match on drug IEN for current tab,  treat as valid manual input.
                      else if piece(Results[1], '^', 1) = '-1' then
                        Result := True;
                    end;
                  end;                  // otUnitDose

                otIV: begin
                // This code may never be executed.  inputPrompt is called by
                // scanmultipledoses.  That is called only for unit dose tab ctUD
                // or order type unit dose otUnitDose.
                // Assume that LoadIVBags has already been called for the
                // current IVPB order.
                    aIVBag := nil;
                    aIVBag := BCMA_Patient.GetIVBagFromUniqueID(inStr);
                    if aIVBag = nil then
                      // if nil, no match on PB either, treat as valid manual input
                      Result := True;
                  end;

              else                      // case
                Result := True;         // otNone: no test; pass as valid
              end;                      // case IqOrderTypeID

            end;                        // case ctPB

        end;                            // case lstcurrenttab

      end;                              // with BCMA_Broker

    end;                                // if BCMA_Broker <> nil

  end;                                  // if not integer, IV label, or nnnnnU

  if Result then begin
    ResultStr := edtInputQry.text;
  end
  else begin
    if msgstr = '' then
      msgstr := 'Incorrect or insufficient information entered. ' + CRLF +
        'Please enter the correct quantity and units. ' + CRLF + CRLF +
        'Examples: 5000 units, 2 mg, 1 puff, small amount, 1 inch.';
    MsgDlgOn := True;
    DefMessageDlg(msgstr, mtError, [mbOK], 0);
    MsgDlgOn := False;
    edtInputQry.Text := '';
    modalResult := mrNone;
  end;

end;                                    // isValidManualInput

procedure TfrmInputQry.edtInputQryChange(Sender: TObject);
begin
  btnOK.Enabled := (isBlankAllowed or (edtInputQry.text <> ''));
end;

procedure TfrmInputQry.btnOKClick(Sender: TObject);
begin
//  ResultStr := edtInputQry.text;
//  modalResult := mrOK;
  if isValidManualInput(edtInputQry.Text) then
    modalResult := mrOK;
end;

procedure TfrmInputQry.edtInputQryKeyPress(Sender: TObject; var Key: Char);
begin
//  if edtInputQry.text <> '' then
//    if key = chr(VK_RETURN) then
//    begin
//      ResultStr := edtInputQry.text;
//      modalResult := mrOK;
//    end;
  if edtInputQry.text <> '' then
    if key = chr(VK_RETURN) then
      if isValidManualInput(edtInputQry.Text) then
        modalResult := mrOK;

end;

procedure TfrmInputQry.FormActivate(Sender: TObject);
begin
  if not MsgDlgOn then                  // rpk 5/27/2011
    ForceForegroundWindow(handle);
end;

procedure TfrmInputQry.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

initialization
  SpecifyFormIsNotADialog(TfrmInputQry);
  isBlankAllowed := True;
end.
