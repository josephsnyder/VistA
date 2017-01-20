unit WardStock;
{
================================================================================
*	File:  WardStock.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 5 $  $Modtime: 3/04/02 2:14p $
*
*	Description:  This is a form for scanning additives and solutions for a
*               WardStock order.

*	Notes:
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, BCMA_Objects, CheckLst, BCMA_Util,
  VA508AccessibilityManager;

type
  TfrmWardStock = class(TForm)
    (*
      This is a form for scanning multiple additives and soltuions for a wardstock
    *)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    pnlScannerStatus: TPanel;
    pnlScannerIndicator: TPanel;
    pnlScannerInput: TPanel;
    edtScannerInput: TEdit;
    btnCancel: TButton;
    btnDone: TButton;
    lstWardStock: TListBox;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    Label2: TVA508StaticText;
    Label5: TVA508StaticText;
    Label3: TVA508StaticText;
    Label4: TVA508StaticText;
    lblScannerStatus: TLabel;
    lblScanMedication: TLabel;
    Memo1: TMemo;
    lblScannerStatusReady: TVA508StaticText;
    procedure FormCreate(Sender: TObject);
    (*
      Allocates memory and initializes variables.
    *)

    procedure FormDestroy(Sender: TObject);
    (*
      Frees memory allocated.
    *)

    procedure FormShow(Sender: TObject);
    (*
      Set focus to edtScannerInput
    *)

    procedure edtScannerInputEnter(Sender: TObject);
    (*
      Sets pnlScannerIndicator.Color to clLime and sets
      lblScannerStatusReady.Caption to 'Ready', indicating that the scanner
      is ready to receive input.
    *)

    procedure edtScannerInputExit(Sender: TObject);
    (*
      Sets pnlScannerIndicator.Color to clRed and sets
      lblScannerStatusReady.Caption to 'Not Ready', indicating that the
      scanner is not ready to receive input.
    *)

    procedure edtScannerInputKeyPress(Sender: TObject; var Key: Char);
    (*
      Waits for an <Enter> key, then calls method MarkDrugAsGiven to validate
      the edtScannerInput.text value.
    *)

    procedure pnlScannerIndicatorClick(Sender: TObject);
    (*
      Sets focus to field edtScannerInput.
    *)

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    {
      Checks to see if the form can be closed
    }

    procedure btnDoneClick(Sender: TObject);
    {
      Set variable CloseFrm = True, if edtScannerInput.text is not null, then
      call method MarkDrugAsGiven
    }

    procedure btnCancelClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtScannerInputKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtScannerInputKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    {
      Sets CloseFrm = true
    }

  private
    { Private declarations }
    ScanCount: integer;

    function MarkDrugAsGiven(scanIEN: string): Boolean;
    {
      Calls method ScanDrug, the clears and sets focus to edtScannerInput
    }

  public
    { Public declarations }
    MedOrder: TBCMA_MedOrder;
    Drugidx: integer;
    UAS_LogState: TUASLogAction; {JK 5/16/2008}
    function ScanDrug(ScanIEN: string; AlreadyValid: Boolean = False): Boolean;
    {
      Calls method isValidDrug to check to see if the drug is valid, then adds it
      to the appropriate TStringList, and populates the list box.
    }

  end;

var
  frmWardStock: TfrmWardStock;
  Mult_ScannedDrug: TBCMA_DispensedDrug;
  CloseFrm: Boolean;
  zAdditives,
    zSolutions: TStringList;

implementation

{$R *.DFM}
uses
  BCMA_Startup,
  BCMA_Common,
//  MFunStr,
  BCMA_Main;

procedure TfrmWardStock.FormCreate(Sender: TObject);
begin
  Mult_ScannedDrug := TBCMA_DispensedDrug.create(BCMA_Broker);
  //  clbxDoses.clear;
  ScanCount := 0;
  CloseFrm := True;
  zAdditives := TStringList.Create;
  zSolutions := TStringList.Create;
  frmMain.WardStockInProc := True;
  UAS_LogState := LA_OkToLog; {JK 5/16/2008}
end;

procedure TfrmWardStock.FormShow(Sender: TObject);
begin
//  lstWardStock.Clear; // rpk 4/13/2011
  edtScannerInput.setFocus;
end;

procedure TfrmWardStock.FormActivate(Sender: TObject);
begin
  edtScannerInputEnter(Sender);
end;

procedure TfrmWardStock.FormDestroy(Sender: TObject);
begin
  Mult_ScannedDrug.free;
  frmMain.WardStockInProc := False;
end;

procedure TfrmWardStock.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := CloseFrm;
  CloseFrm := True;
end;

procedure TfrmWardStock.edtScannerInputEnter(Sender: TObject);
begin
  pnlScannerIndicator.Color := clLime;
  lblScannerStatusReady.Caption := 'Ready';
//  stScannerStatusReady.Caption := 'Ready';
  StopKeyboardTimer;
end;

procedure TfrmWardStock.edtScannerInputExit(Sender: TObject);
begin
  pnlScannerIndicator.Color := clRed;
  lblScannerStatusReady.Caption := 'Not Ready';
//  stScannerStatusReady.Caption := 'Not Ready';
end;

function TfrmWardStock.MarkDrugAsGiven(scanIEN: string): Boolean;
begin
  if not ScanDrug(scanIEN) then
    Result := False
  else
    Result := True;

  edtScannerInput.clear;
  edtScannerInput.setFocus;

end;

procedure TfrmWardStock.edtScannerInputKeyPress(Sender: TObject;
  var Key: Char);
begin
  {disable Cut and Past}
  if Key = #22 then
    key := #0;

  if (edtScannerInput.text <> '') and (key = chr(VK_RETURN)) then
  begin
    //Logic Added to Deal with Keyed Bar Codes
    StopKeyboardTimer;
    if KeyedBarCode then //begin
      //LogUnableToScan('', '', '', '', 'M', 1); {Removed 7/8/2008 JK per CQ #116}
      KeyedBarCode := False;
    //end else
      //LogUnableToScan('', '', '', '', 'M', 2);  {Removed 7/17/2008 JK per CQ #116}

    MarkDrugAsGiven(edtScannerInput.Text);
  end;
end;

procedure TfrmWardStock.pnlScannerIndicatorClick(Sender: TObject);
begin
  edtScannerInput.SetFocus;
end;

procedure TfrmWardStock.btnDoneClick(Sender: TObject);
var
  CRKey: Char;
begin
  CRKey := chr(VK_RETURN);
  if Trim(edtScannerInput.Text) <> '' then
  begin
    edtScannerInputKeyPress(Self, CRKey); {JK 8/24/2008}
    CloseFrm := False;
  end
  else
  begin

    CloseFrm := True;

    if edtScannerInput.text <> '' then
      if MarkDrugAsGiven(edtScannerInput.text) then
        CloseFrm := True
      else
        CloseFrm := False;
    //  else begin
    //    DefMessageDlg('You did not specify a barcode. Re-enter code or press cancel to quit',
    //      mtInformation, [mbOK], 0);
    //    CloseFrm := False;
    //  end;
  end;

end;

procedure TfrmWardStock.btnCancelClick(Sender: TObject);
begin
  DefMessageDlg('Order Administration Cancelled!', mtWarning, [mbOK], 0);
  UAS_LogState := LA_Cancelled; {JK 5/16/2008}
  CloseFrm := True;
end;

function TfrmWardStock.ScanDrug(ScanIEN: string; AlreadyValid: Boolean):
  Boolean;
begin
  Result := False;  // rpk 4/26/2011
  with BCMA_ScannedDrug do begin
    if AlreadyValid = False then
      if not isValidDrug(ScanIEN) then begin
        Result := False;
        Exit
      end;

    if piece(ResultString, '^', 1) = 'ADD' then
      zAdditives.Add(ResultString)
    else if piece(ResultString, '^', 1) = 'SOL' then
      zSolutions.Add(ResultString);

    lstWardStock.Items.Add(BCMA_ScannedDrug.Name + ', ' + Dose);
    lstWardStock.Invalidate;  // rpk 4/26/2011
//    lstWardStock.Repaint;  // rpk 4/26/2011

    Result := True;

  end;  // with BCMA_ScannedDrug
  
end;

procedure TfrmWardStock.FormDeactivate(Sender: TObject);
begin
  edtScannerInputExit(Sender);
end;

procedure TfrmWardStock.edtScannerInputKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  {disable cut and paste}
  if key = VK_Insert then
    key := 0;
end;

procedure TfrmWardStock.edtScannerInputKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if edtScannerInput.Text <> '' then
  begin
    if (KeyBoardTimer = nil) or (KeyedBarCode = False) then
      StartKeyboardTimer;
  end
  else
  begin
    StopKeyboardTimer;
    KeyedBarCode := False;
  end;
end;

end.

