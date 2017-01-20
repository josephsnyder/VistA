unit fPrint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, BCMA_Common, BCMA_Util, ExtCtrls,
  VA508AccessibilityManager;

type
  TfrmPrint = class(TForm)
    cbxDeviceList: TORComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    chkQueueDateTime: TCheckBox;
    edtQueueDateTime: TEdit;
    btnDateTimePicker: TButton;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblSelectPrinter: TLabel;
    lblQueueDateTime: TLabel;
    procedure cbxDeviceListNeedData(Sender: TObject;
      const StartFrom: string; Direction, InsertAt: Integer);
    procedure btnOkClick(Sender: TObject);
    procedure chkQueueDateTimeClick(Sender: TObject);
    procedure btnDateTimePickerClick(Sender: TObject);
    procedure edtQueueDateTimeExit(Sender: TObject);
    procedure edtQueueDateTimeChange(Sender: TObject);
  private
    { Private declarations }
    function CheckDateTime(DateIn: string): Boolean;
  public
    { Public declarations }
  end;

var
  frmPrint: TfrmPrint;

implementation

{$R *.DFM}
uses
  fDateTimePicker;
//  MFunStr;

procedure TfrmPrint.cbxDeviceListNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  cbxDeviceList.ForDataUse(SubsetOfDevices(StartFrom, Direction));
end;

function TfrmPrint.CheckDateTime(DateIn: string): Boolean;
var
  MDateTime,
    NowMDateTime: string;
begin
  Result := False; // rpk 4/23/2009

  if (edtQueueDateTime.text <> '') and (edtQueueDateTime.tag = 0) then begin
    NowMDateTime := 'N';
    NowMDateTime := ValidMDateTime(NowMDateTime);
    MDateTime := ValidMDateTime(DateIn);

    if MDateTime <> '' then begin
      edtQueueDateTime.text := DateIn;
      edtQueueDateTime.tag := 1;
      BCMA_Report.QueueDateTime := MDateTime;
      Result := true;
    end
    else begin
      edtQueueDateTime.setFocus;
      edtQueueDateTime.Clear;
      edtQueueDateTime.tag := 0;
      result := False;
    end;
  end;
end;

procedure TfrmPrint.chkQueueDateTimeClick(Sender: TObject);
begin
  edtQueueDateTime.Enabled := chkQueueDateTime.Checked;
  btnDateTimePicker.Enabled := chkQueueDateTime.Checked;
  lblQueueDateTime.Enabled := chkQueueDateTime.Checked;
  if not chkQueueDateTime.Checked then
    BCMA_Report.QueueDateTime := ''
  else begin
    edtQueueDateTime.Text := 'N';
    CheckDateTime('N');
  end;

end;

procedure TfrmPrint.edtQueueDateTimeChange(Sender: TObject);
begin
  edtQueueDateTime.tag := 0;
end;

procedure TfrmPrint.edtQueueDateTimeExit(Sender: TObject);
begin
  if edtQueueDateTime.Text <> '' then
    CheckDateTime(edtQueueDateTime.Text);
end;

procedure TfrmPrint.btnDateTimePickerClick(Sender: TObject);
var
  zDateTime, zMDateTime: string;
begin
  zMDateTime := DateTimePickerExecute(zDateTime, True, '', False);
  if zMDateTime <> '' then begin
    edtQueueDateTime.tag := 1;
    edtQueueDateTime.Text := zDateTime;
    BCMA_Report.QueueDateTime := zMDateTime;
  end
  else
    edtQueueDateTime.tag := 0;
end;

procedure TfrmPrint.btnOkClick(Sender: TObject);
begin
  if cbxDeviceList.ItemID <> '' then begin
    BCMA_UserParameters.DefaultPrinterName := Piece(cbxDeviceList.ItemID, ';',
      2);
    BCMA_UserParameters.DefaultPrinterIEN :=
      StrToInt(Piece(cbxDeviceList.ItemID,
      ';', 1));
    BCMA_UserParameters.Changed := True;

    with BCMA_Report do
      Execute('^' + Piece(cbxDeviceList.ItemID, ';', 1));
  end
  else begin
    ModalResult := mrNone; // stay on the form;  rpk 9/7/2010
    DefMessageDlg('Please select a printer.', mtInformation,
      [mbOk], 0);
  end;
end;

end.

