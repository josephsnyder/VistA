unit fDateTimePicker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Mask, BCMA_Common, DateUtils, StrUtils,
  VA508AccessibilityManager;

function DateTimePickerExecute(var DateTimeText: string; DisplayTime: Boolean;
  DefaultMDateTime: string; DisAllowFutureDateTime: Boolean): string;

type
  TfrmDateTimePicker = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    pnlTime: TPanel;
    calCalendar: TMonthCalendar;
    lstHours: TListBox;
    lstMinutes: TListBox;
    btnCalendarMinus: TButton;
    btnToday: TButton;
    btnCalendarPlus: TButton;
    btnNow: TButton;
    btnMidNight: TButton;
    Panel3: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    edtTime: TMaskEdit;
    Label1: TLabel;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblDateTime: TLabel;
    procedure lstHoursClick(Sender: TObject);
    procedure lstMinutesClick(Sender: TObject);
    procedure btnNowClick(Sender: TObject);
    procedure btnMidNightClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCalendarMinusClick(Sender: TObject);
    procedure btnCalendarPlusClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure UpdateDateTime;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtTimeExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure calCalendarClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  MinutesArray: array[0..11] of string = (
    '00', '05', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55'
    );

var
  frmDateTimePicker: TfrmDateTimePicker;
  MDateTime, DateTimeString: string;
  DisplayTimeSelector: Boolean;
  DisFutureDateTime: Boolean;

implementation

{$R *.dfm}
uses
  BCMA_Util;
//  MFunStr;

function DateTimePickerExecute(var DateTimeText: string; DisplayTime: Boolean;
  DefaultMDateTime: string;
  DisAllowFutureDateTime: Boolean): string;
var
  tmpTime: string;
begin
  DisFutureDateTime := DisAllowFutureDateTime;
  DisplayTimeSelector := DisplayTime;
  with TfrmDateTimePicker.create(application) do
  try
    if DefaultMDateTime <> '' then
    begin
      tmpTime := piece(DisplayVADate(DefaultMDateTime), '@', 2);
      edtTime.Text := MidStr(tmpTime, 1, 2) + ':' + MidStr(tmpTime, 3, 2);
      calCalendar.Date :=
        DateOf(FMDateTimeToDateTime(StrToFloat(DefaultMDateTime)));
    end
    else
    begin
      edtTime.Text := FormatDateTime('hh:mm', now +
        BCMA_SiteParameters.ServerClockVariance);
      calCalendar.Date := Now;
    end;
    UpdateDateTime;
    ShowModal;
    Result := MDateTime;
    DateTimeText := DateTimeString;
  finally
//    free;
    Release; // rpk 6/18/2013
  end;

end;

procedure TfrmDateTimePicker.UpdateDateTime;
var
  tmpdt: string;
begin
  //  if DisplayTimeSelector = True then
  //    lblDateTime.Caption := DateToStr(calCalendar.Date) + ' ' + edtTime.Text
  //  else
  //    lblDateTime.Caption := DateToStr(calCalendar.Date);

  if DisplayTimeSelector then
    tmpdt := DateToStr(calCalendar.Date) + ' ' + edtTime.Text
  else
    tmpdt := DateToStr(calCalendar.Date);

  lblDateTime.Caption := tmpdt + ' ';  // rpk 8/13/2010, pad with space to compensate for truncation
  //  VA508STDateTime.Caption := tmpdt;

end;

procedure TfrmDateTimePicker.lstHoursClick(Sender: TObject);
begin
  if lstMinutes.ItemIndex = -1 then
    edtTime.Text := lstHours.Items.Strings[lstHours.ItemIndex] + ':00'
  else
    edtTime.Text := lstHours.Items.Strings[lstHours.ItemIndex] + ':' +
      MinutesArray[lstMinutes.ItemIndex];
  UpdateDateTime;
end;

procedure TfrmDateTimePicker.lstMinutesClick(Sender: TObject);
begin
  if lsthours.ItemIndex > -1 then
  begin
    edtTime.Text := lstHours.Items.Strings[lstHours.ItemIndex] + ':' +
      MinutesArray[lstMinutes.ItemIndex];
    UpdateDateTime;
  end;
end;

procedure TfrmDateTimePicker.btnNowClick(Sender: TObject);
begin
  edtTime.Text := FormatDateTime('hh:mm', now +
    BCMA_SiteParameters.ServerClockVariance);
  calCalendar.Date := Now + BCMA_SiteParameters.ServerClockVariance;
  UpdateDateTime;
end;

procedure TfrmDateTimePicker.btnMidNightClick(Sender: TObject);
begin
  //Ok, Ok, what exactly is midnight??  CPRS GUI displays 23:59, Vitals GUI displays 00:00
  //yet inpatient meds start date accepts 2400, and NOT 0000...so, who's to say???
  //Since we deal mostly with Inpatient Meds, following their standard
  edtTime.Text := '24:00';
  UpdateDateTime;
end;

procedure TfrmDateTimePicker.FormCreate(Sender: TObject);
begin
  //  edtTime.Text := FormatDateTime('hh:mm', now + BCMA_SiteParameters.ServerClockVariance);
  //  calCalendar.Date := Now;
  //  UpdateDateTime;
end;

procedure TfrmDateTimePicker.btnCalendarMinusClick(Sender: TObject);
begin
  calCalendar.Date := calCalendar.Date - 1;
  UpdateDatetime;
end;

procedure TfrmDateTimePicker.btnCalendarPlusClick(Sender: TObject);
begin
  calCalendar.Date := calCalendar.Date + 1;
  UpdateDateTime;
end;

procedure TfrmDateTimePicker.btnTodayClick(Sender: TObject);
begin
  calCalendar.Date := Now + BCMA_SiteParameters.ServerClockVariance;
  UpdateDateTime;
end;

procedure TfrmDateTimePicker.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
const
  minute = 1 / (24 * 60);
var
  tempDateTime,
    //    ss,
  NowMDateTime: string;
begin
  if ModalResult = mrCancel then
    exit;
  if DisplayTimeSelector then
  begin
    if edtTime.Text = '00:00' then
    begin
      edtTime.Text := '24:00';
      DefMessageDlg('00:00 has been converted to 24:00 to represent midnight!',
        mtInformation, [mbOK], 0)
    end;
    tempDateTime := DateTimeToMDateTime(calCalendar.Date + minute);
    SetPiece(tempDateTime, '.', 2, StringReplace(edtTime.text, ':', '', []));
  end
  else
    tempDateTime := DateTimeToMDateTime(calCalendar.Date + minute);

  MDateTime := ValidMDateTime(tempDateTime);

  if MDateTime = '' then
  begin
    DefMessageDlg('Invalid Date and/or time!', mtError, [mbOK], 0);
    CanClose := false;
    exit;
  end;

  if DisplayTimeSelector then
    DateTimeString := tempDateTime
  else
  begin
    MDateTime := piece(MDatetime, '.', 1);
    DateTimeString := piece(tempDateTime, '@', 1);
  end;

  if DisFutureDateTime then
  begin
    NowMDateTime := 'N';
    NowMDateTime := ValidMDateTime(NowMDateTime);
    if DisplayTimeSelector then
    begin
      if StrToFloat(MDateTime) > StrToFloat(NowMDateTime) then
      begin
        DefMessageDlg('The date and time can''t be in the future.', mtError,
          [mbOk], 0);
        CanClose := false;
        exit;
      end;
    end
    else
    begin
      if StrToFloat(MDateTime) > StrToFloat(piece(NowMDateTime, '^', 1)) then
      begin
        DefMessageDlg('The date can''t be in the future.', mtError,
          [mbOk], 0);
        CanClose := false;
        exit;
      end;
    end;
  end;
end;

procedure TfrmDateTimePicker.edtTimeExit(Sender: TObject);
begin
  if edtTime.Text = '24:00' then
    exit;
  try
    StrToTime(edtTime.Text);
    UpdateDateTime;
  except
    DefMessageDlg('An invalid time has been entered!', mtError, [mbOK], 0);
    edtTime.SetFocus;
  end;
end;

procedure TfrmDateTimePicker.FormShow(Sender: TObject);
begin
  if DisplayTimeSelector = False then
  begin
    caption := 'BCMA - Date Selection';
    pnlTime.Visible := False;
    Width := Width - pnlTime.Width;
  end
  else
    caption := 'BCMA - Date/Time Selection';
end;

procedure TfrmDateTimePicker.calCalendarClick(Sender: TObject);
begin
  UpdateDateTime;
end;

procedure TfrmDateTimePicker.btnCancelClick(Sender: TObject);
begin
  MDateTime := '';
  DateTimeString := '';
end;

end.
