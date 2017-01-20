unit fEdtMedLogAdminSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, BCMA_Startup, BCMA_Objects, DateUtils, Grids,
  ExtCtrls, VA508AccessibilityManager, VA508AccessibilityRouter;

function EditMedLogSelectAdministration: Boolean;

type
  TfrmEditMedLogAdminSelect = class(TForm)
    lvwAdministrations: TListView;
    btnDown: TButton;
    edtDate: TEdit;
    btnDatePicker: TButton;
    btnUp: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    grdAdministrations: TStringGrid;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    lblPatientNameCaption: TLabel;
    lblSSNCaption: TLabel;
    lblPatientName508: TVA508StaticText;
    lblSSN: TVA508StaticText;
    lblDate: TVA508StaticText;
    lblDateVisual: TLabel;
    procedure edtDateExit(Sender: TObject);
    procedure edtDateEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure lvwAdministrationsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnOKClick(Sender: TObject);
    procedure btnDatePickerClick(Sender: TObject);
    procedure edtDateKeyPress(Sender: TObject; var Key: Char);
    procedure edtDateChange(Sender: TObject);
    procedure VA508ComponentAccessibility1ItemQuery(Sender: TObject;
      var Item: TObject);
    procedure VA508ComponentAccessibility1ValueQuery(Sender: TObject;
      var Text: string);
    procedure grdAdministrationsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure grdAdministrationsSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure FormShow(Sender: TObject);
    procedure lvwAdministrationsEnter(Sender: TObject);
  private
    { Private declarations }
    function CheckDate(DateIn: string): Boolean;
    function RefreshAdministrations: Boolean;
  public
    { Public declarations }
  end;

var
  frmEditMedLogAdminSelect: TfrmEditMedLogAdminSelect;
  SelectedDate: TDateTime;
implementation

{$R *.dfm}
uses
  BCMA_Common,
  BCMA_Util,
  BCMA_Main,
  fEditMedLog,
  fDateTimePicker,
//  MFunStr,
  StrUtils;

var
  SelectedX: integer;
  SelectedY: integer;

function EditMedLogSelectAdministration: Boolean;
begin

  Result := True;                       // rpk 4/23/2009  -- unused return in current calling functions

  with TfrmEditMedLogAdminSelect.create(application) do try
    edtDate.Text := 'N';
    CheckDate(edtDate.Text);
    RefreshAdministrations;
    ShowModal;
  finally
//    free;
    Release;                            // rpk 6/18/2013
  end;
end;

function TfrmEditMedLogAdminSelect.RefreshAdministrations: Boolean;
var
  MultList: TStringList;
  tmpstr, rowstr1, rowstr2: string;
  x: integer;
begin
  Result := False;
  MultList := TStringList.Create;
  lvwAdministrations.Clear;
//  lvwAdministrations.Repaint;
  lvwAdministrations.Invalidate;        // rpk 9/3/2010
  btnOK.Enabled := False;
  SelectedX := 1;
  SelectedY := 1;
  if ScreenReaderSystemActive then begin
    sgClear(grdAdministrations);        // rpk 9/3/2010
    sgInit(grdAdministrations, 1, 0);   // rpk 10/12/2010
    grdAdministrations.Rows[0].CommaText :=
      'Medication,Type,Status,"Action Date/Time",Int';
    grdAdministrations.Invalidate;
  end;

  with MultList do begin
    Add('ADMLKUP');
    Add(BCMA_Patient.IEN);
    Add(piece(DateTimeToMDateTime(SelectedDate), '.', 1));
  end;
  frmMain.StatusBar.Panels[0].Text := 'Retrieving Administrations...';
  frmMain.StatusBar.Repaint;

  if (BCMA_Broker <> nil) then
    with BCMA_Broker do
      if CallServer('PSB MED LOG LOOKUP', ['~!#null#~!'], MultList) then begin
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0],
          -1)) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if piece(Results[1], '^', 1) = '-1' then
//          lblDate.Caption := 'Searching Date: ' + edtDate.Text + ' - ' +
//            piece(Results[1], '^', 2)
          lblDateVisual.Caption := 'Searching Date: ' + edtDate.Text + ' - ' +
            piece(Results[1], '^', 2)
        else begin
          Result := True;
          Results.Delete(0);
//          grdAdministrations.FixedRows := 1;
//          grdAdministrations.RowCount := Results.Count + 1; // rpk 6/4/2010

          btnOK.Enabled := Results.Count > 0; // rpk 9/1/2010

          if ScreenReaderSystemActive then
            for x := 0 to Results.Count - 1 do
              grdAdministrations.Objects[x, 0] := nil;

          sgInit(grdAdministrations, 1, Results.Count); // rpk 9/10/2010
          for x := 0 to Results.Count - 1 do begin
            if ScreenReaderSystemActive then begin
              with grdAdministrations do begin
                tmpstr :=
                  //              Piece(Results[x], '^', 6) + ',' +
                IfThen(Piece(Results[x], '^', 4) <> '',
                  '"' + (Piece(Results[x], '^', 3) + '"  "(' + Piece(Results[x],
                  '^', 4) +
                  ')"'),
                  '"' + (Piece(Results[x], '^', 3))) + '", "' +
                  Piece(Results[x], '^', 6) + '", "' +
                  (GetLastActivityStatus(piece(Results[x], '^', 5))) + '", "' +
                  (DisplayVADateYearTime(piece(Results[x], '^', 7))) + '", "' +
                  (piece(Results[x], '^', 8)) + '"';
//                RowCount := x + 2;
                Rows[x + 1].CommaText := tmpstr;

                rowstr1 := Rows[x + 1].CommaText;

                Cells[0, x + 1] := IfThen(Piece(Results[x], '^', 4) <> '',
                  (Piece(Results[x], '^', 3) + ' (' +
                  Piece(Results[x], '^', 4) + ')'),
                  (Piece(Results[x], '^', 3)));
                Cells[1, x + 1] := Piece(Results[x], '^', 6);
                Cells[2, x + 1] := (GetLastActivityStatus(piece(Results[x], '^', 5)));
                Cells[3, x + 1] := (DisplayVADateYearTime(piece(Results[x], '^', 7)));
                Cells[4, x + 1] := (piece(Results[x], '^', 8));

                rowstr2 := Rows[x + 1].CommaText;

                Objects[0, x + 1] := ptr(StrToInt(piece(Results[x], '^', 1)));
              end;
            end
            else begin
              with lvwAdministrations do begin
                AddItem(Piece(Results[x], '^', 6),
                  ptr(StrToInt(piece(Results[x],
                  '^', 1))));           // type
                if Piece(Results[x], '^', 4) <> '' then // medication
                  Items[x].SubItems.Add(Piece(Results[x], '^', 3) + '  (' +
                    Piece(Results[x], '^', 4) + ')')
                else
                  Items[x].SubItems.Add(Piece(Results[x], '^', 3));

                //if Piece(Results[x], '^', 4) <> '' then
                //  AddItem(Piece(Results[x], '^', 3) + '  (' + Piece(Results[x], '^', 4) + ')', ptr(StrToInt(piece(Results[x], '^', 1))))
                //else
                //  AddItem(Piece(Results[x], '^', 3), ptr(StrToInt(piece(Results[x], '^', 1))));
                Items[x].SubItems.Add(GetLastActivityStatus(piece(Results[x],
                  '^', 5)));                 // status
                Items[x].SubItems.Add(DisplayVADateYearTime(piece(Results[x],
                  '^', 7)));                 // action date/time
                Items[x].SubItems.Add(piece(Results[x], '^', 8)); // int: initials, who documented last action
              end;
            end;                        // else not ScreenReaderSystemActive

          end;                          // for x

//          if ScreenReaderSystemActive then
//            grdAdministrations.Repaint
//          else
//            lvwAdministrations.Repaint;

          if ScreenReaderSystemActive then
            grdAdministrations.Invalidate
          else
            lvwAdministrations.Invalidate;

        end;                            // else Results[1] not -1
      end;                              // if CallServer

  MultList.Free;

  frmMain.StatusBar.Panels[0].Text := '';
  frmMain.StatusBar.Invalidate;         // rpk 6/4/2010

end;

procedure TfrmEditMedLogAdminSelect.VA508ComponentAccessibility1ItemQuery(
  Sender: TObject; var Item: TObject);
//var
//  i: integer;
begin
  //  i := 100 * SelectedY + SelectedX;
  //  Item := TObject(i);
end;

procedure TfrmEditMedLogAdminSelect.VA508ComponentAccessibility1ValueQuery(
  Sender: TObject; var Text: string);
begin
  Text := ' Name ' + grdAdministrations.Cells[0, SelectedY] + ' ' +
    'Column ' + grdAdministrations.Cells[SelectedX, 0] + ', ' +
    grdAdministrations.Cells[SelectedX, SelectedY];
end;

procedure TfrmEditMedLogAdminSelect.edtDateExit(Sender: TObject);
begin
  if (edtDate.Tag = 1) or (edtDate.Text = '') then
    exit;
  if CheckDate(edtDate.Text) then
    RefreshAdministrations
  else begin
    //    edtDate.Clear;
    edtDate.SetFocus;
  end;
end;                                    //  edtDateExit

procedure TfrmEditMedLogAdminSelect.edtDateEnter(Sender: TObject);
begin
  //  edtDate.tag := 0;
end;

function TfrmEditMedLogAdminSelect.CheckDate(DateIn: string): Boolean;
var
  MDate: Double;
  NowMDate: string;
begin
  //if null, then add space, a null value causes an M error.
  // we are relying on the M side to return the error message to display to the user

  if DateIn = '' then
    DateIn := ' ';
  //  MDate := -1;
  MDate := StrToFloatDef(piece(ValidMDateTime(DateIn), '.', 1), -1);
  //  if MDate = -1 then exit;
  if MDate <> -1 then begin
    NowMDate := 'N';
    NowMDate := Piece(ValidMDateTime(NowMDate), '.', 1);
    if MDate > StrToFloat(piece(NowMDate, '^', 1)) then begin
      DefMessageDlg('The date can''t be in the future.', mtError, [mbOk], 0);
      DateIn := DateTimeToMDateTime(SelectedDate);
      ValidMDateTime(DateIn);
      edtDate.text := piece(DateIn, '@', 1);
      edtDate.SetFocus;
      //      edtDate.Clear;
      edtDate.Tag := 0;
      result := False;
    end
    else begin
      SelectedDate := FMDateTimeToDateTime(MDate + 0.0001);
      edtDate.text := piece(DateIn, '@', 1);
      edtDate.tag := 1;
//      lblDate.Caption := 'Searching Date: ' + edtDate.Text;
      lblDateVisual.Caption := 'Searching Date: ' + edtDate.Text;
      Result := true;
    end;
  end
  else begin
    edtDate.setFocus;
    DateIn := DateTimeToMDateTime(SelectedDate);
    ValidMDateTime(DateIn);
    edtDate.text := piece(DateIn, '@', 1);
    //edtDate.Clear;
    edtDate.tag := 0;
    result := False;
  end;
end;

procedure TfrmEditMedLogAdminSelect.FormCreate(Sender: TObject);
begin
  // append blank pad to compensate for VA508StaticText re-size
//  lblPatientName.Caption := BCMA_Patient.Name;  // rpk 7/28/2010
  lblPatientName508.Caption := BCMA_Patient.Name + ' '; // rpk 7/28/2010
  lblSSNCaption.Caption := '&' + BCMA_SiteParameters.PatientIDLabel + ': ';
  // rpk 9/17/2010
//  lblSSN.Caption := BCMA_Patient.SSN;
  // append blank pad to compensate for VA508StaticText re-size
  lblSSN.Caption := BCMA_Patient.SSN + ' '; // rpk 7/13/2010

  with lvwAdministrations do begin
    Column[0].Width := trunc(Width * 0.07);
    Column[1].Width := trunc(Width * 0.5);
    Column[2].Width := trunc(Width * 0.13);
    Column[3].Width := trunc(Width * 0.20);
    Column[4].Width := trunc(Width * 0.09);
  end;

  with grdAdministrations do begin
    //    ColWidths[0] := trunc(Width * 0.07);
    //    ColWidths[1] := trunc(Width * 0.5);
    ColWidths[0] := trunc(Width * 0.4);
    ColWidths[1] := trunc(Width * 0.07);
    ColWidths[2] := trunc(Width * 0.13);
    ColWidths[3] := trunc(Width * 0.20);
    ColWidths[4] := trunc(Width * 0.19);
  end;
end;

procedure TfrmEditMedLogAdminSelect.FormShow(Sender: TObject);
begin

  if ScreenReaderSystemActive then begin
    ActiveControl := grdAdministrations;
    lvwAdministrations.Hide;
    grdAdministrations.BringToFront;
    grdAdministrations.Show;
//    grdAdministrations.RowCount := grdAdministrations.FixedRows + 1;
//    grdAdministrations.RowCount := 2;  // rpk 9/2/2010
//    grdAdministrations.FixedRows := 1;  // rpk 9/2/2010
//    sgInit(grdAdministrations, 1, 2); // rpk 9/10/2010
    sgInit(grdAdministrations, 1, 0);   // rpk 10/12/2010
    grdAdministrations.Rows[0].CommaText :=
      'Medication,Type,Status,"Action Date/Time",Int';
    grdAdministrations.Invalidate;
    //    grdAdministrations.Refresh;
  end
  else begin
    ActiveControl := lvwAdministrations;
    grdAdministrations.Hide;
    lvwAdministrations.BringToFront;
    lvwAdministrations.Show;
    lvwAdministrations.Invalidate;
    //    lvwAdministrations.Refresh;
  end;

  // temporary fix until cause of re-size is found.  rpk 7/13/2010
//  if lblSSN.Width < 73 then
//    lblSSN.Width := 73;
//  Update;
end;

procedure TfrmEditMedLogAdminSelect.grdAdministrationsSelectCell(
  Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  SelectedX := ACol;
  SelectedY := ARow;
  btnOK.Enabled := True;
end;

procedure TfrmEditMedLogAdminSelect.grdAdministrationsSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  btnOK.Enabled := True;
end;

procedure TfrmEditMedLogAdminSelect.btnDownClick(Sender: TObject);
begin
  if CheckDate(piece(DateTimeToMDateTime(SelectedDate - 1), '.', 1)) then
    RefreshAdministrations;
end;

procedure TfrmEditMedLogAdminSelect.btnUpClick(Sender: TObject);
begin
  if CheckDate(piece(DateTimeToMDateTime(SelectedDate + 1), '.', 1)) then
    RefreshAdministrations;
end;

procedure TfrmEditMedLogAdminSelect.lvwAdministrationsChange(
  Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if lvwAdministrations.ItemIndex <> -1 then
    btnOk.Enabled := True
  else
    btnOk.Enabled := False;
end;

procedure TfrmEditMedLogAdminSelect.lvwAdministrationsEnter(Sender: TObject);
begin
  with lvwAdministrations do begin
    if (Selected = nil) and (Items[0] <> nil) then
      Selected := Items[0];
  end;
end;

procedure TfrmEditMedLogAdminSelect.btnOKClick(Sender: TObject);
begin
  if ScreenReaderSystemActive then begin
    if grdAdministrations.RowCount < 2 then
      Exit;
  end;

  if (edtDate.tag = 0) then
    if not CheckDate(edtDate.Text) then begin
      edtDate.Clear;
      edtDate.setFocus;
      exit;
    end;

  if ScreenReaderSystemActive then begin
    //    if EditMedLogExecute(IntToStr(Integer(grdAdministrations.objects[SelectedX, SelectedY]))) then
    if EditMedLogExecute(IntToStr(Integer(grdAdministrations.objects[0,
      grdAdministrations.Row]))) then
      RefreshAdministrations;
  end
  else begin
    if lvwAdministrations.ItemIndex <> -1 then
      if
        EditMedLogExecute(IntToStr(Integer(lvwAdministrations.Items[lvwAdministrations.Selected.index].data))) then
        RefreshAdministrations;
  end;
end;

procedure TfrmEditMedLogAdminSelect.btnDatePickerClick(Sender: TObject);
var
  zDateTime, zMDateTime: string;
begin
  zMDateTime := DateTimePickerExecute(zDateTime, False,
    DateTimeToMDateTime(SelectedDate), True);
  if zMDateTime <> '' then
    if CheckDate(MDateTime) then
      RefreshAdministrations;
  //edtDate.text := zDateTime;

end;

procedure TfrmEditMedLogAdminSelect.edtDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = #13) and (edtDate.Text <> '') then
    if CheckDate(edtDate.Text) then
      RefreshAdministrations
    else begin
      edtDate.Clear;
      edtDate.SetFocus;
    end;
end;

procedure TfrmEditMedLogAdminSelect.edtDateChange(Sender: TObject);
begin
  edtDate.Tag := 0;
end;

initialization
  SpecifyFormIsNotADialog(TfrmEditMedLogAdminSelect);

end.

