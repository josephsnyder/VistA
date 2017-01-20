unit mVitals;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ImgList, Grids, VA508AccessibilityRouter,
  ExtCtrls, VA508AccessibilityManager;

type
  TfraVitals = class(TFrame)
    lvwVitals: TListView;
    imglstVitals: TImageList;
    grdVitals: TStringGrid;
    lblVitals: TLabel;
    constructor Create(aOwner: TComponent); override;
    destructor Destroy(); override;
    procedure lvwVitalsClick(Sender: TObject);
    procedure lvwVitalsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdVitalsClick(Sender: TObject);
    procedure grdVitalsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdVitalsDblClick(Sender: TObject);
    procedure grdVitalsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FrameEnter(Sender: TObject);
    procedure lvwVitalsEnter(Sender: TObject);
    procedure grdVitalsEnter(Sender: TObject);
  private
    { Private declarations }
    fVTemp,
      fVPulse,
      fVResp,
      fVBP,
      fVPain: TStringList;

  public
    { Public declarations }
//    fVTemp,
//      fVPulse,
//      fVResp,
//      fVBP,
//      fVPain: TStringList;
    SelectedVX, SelectedVY: Integer;
    procedure LoadVitals;
    procedure RefreshVitals;
  end;

  TVitalTypes = (vtTemp,
    vtPulse,
    vtResp,
    vtBP,
    vtPain
    );

const
  VitalState: array[TVitalTypes] of integer =
  (3, 3, 3, 3, 3); //0=+ 1=- 2=blank 3=unknown

  VitalNames: array[TVitalTypes] of string =
  ('Temp', 'Pulse', 'Resp', 'BP', 'Pain'
    );

implementation

{$R *.dfm}
uses BCMA_Startup, BCMA_Common, BCMA_Objects, BCMA_Util,
//MFunStr,
Math;

constructor TfraVitals.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  try
    fVTemp := TStringList.Create;
    fVPain := TStringList.Create;
    fVBP := TStringList.Create;
    fVPulse := TStringList.Create;
    fVResp := TStringList.Create;
  finally
  end;
end;

destructor TFraVitals.Destroy; // rpk 6/16/2010
begin
  FreeAndNil(fVTemp);
  FreeAndNil(fvPain);
  FreeAndNil(fvBP);
  FreeAndNil(fVPulse);
  FreeAndNil(fVResp);
  inherited Destroy;
end;

procedure TfraVitals.FrameEnter(Sender: TObject);
begin
  if ScreenReaderSystemActive then begin
    if grdVitals.CanFocus then
      grdVitals.SetFocus;
  end
  else begin
    if lvwVitals.CanFocus then
      lvwVitals.SetFocus;
  end;
end;

// Vitalstates: 0=+ 1=- 2=blank 3=unknown

procedure TfraVitals.LoadVitals;
var
  x: integer;
  tempStr: string;
begin
  if ScreenReaderSystemActive then begin
    lvwVitals.SendToBack;
    lvwVitals.Hide;
    lvwVitals.TabStop := False;

    grdVitals.BringToFront;
    grdVitals.TabStop := True;
    grdVitals.Show;
    grdVitals.Align := alClient;
//    sgInit(grdVitals, 1, 2); // rpk 9/10/2010
    sgInit(grdVitals, 1, 0); // rpk 10/12/2010
    grdVitals.rows[0].CommaText := 'Vital, Value, Date';
    grdVitals.Invalidate;
  end
  else begin
    grdVitals.SendToBack;
    grdVitals.Hide;
    grdVitals.TabStop := False;

    lvwVitals.BringToFront;
    lvwVitals.TabStop := True;
    lvwVitals.Show;
    lvwVitals.Align := alClient;
    lvwVitals.Invalidate;
  end;

  if BCMA_Broker <> nil then
    with BCMA_Broker do
      if CallServer('PSB VITALS', [BCMA_Patient.IEN], nil) then
        if Results.Count - 1 <> StrToInt(Results[0]) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if (results.Count > 1) and
          (piece(Results[1], '^', 1) = '-1') then
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
        else if Results.count > 1 then begin
          try
            if fVTemp = nil then
              fVTemp := TStringList.Create;
            if fVPain = nil then
              fVPain := TStringList.Create;
            if fVBP = nil then
              fVBP := TStringList.Create;
            if fVPulse = nil then
              fVPulse := TStringList.Create;
            if fVResp = nil then
              fVResp := TStringList.Create;

            fVTemp.Clear;   // rpk 9/27/2010
            fVPain.Clear;   // rpk 9/27/2010
            fVBP.Clear;   // rpk 9/27/2010
            fVPulse.Clear;   // rpk 9/27/2010
            fVResp.Clear;   // rpk 9/27/2010

            for x := 0 to Results.Count - 1 do begin
              tempStr := piece(results[x], '^', 1);
              if tempStr = 'T' then
                if fVtemp.Count = 0 then
                  fVTemp.AddObject(results[x], ptr(0))
                else
                  fVTemp.AddObject(results[x], nil);
              if tempStr = 'P' then
                fVPulse.Add(results[x])
              else if tempStr = 'R' then
                fVResp.Add(results[x])
              else if tempStr = 'BP' then
                fVBP.Add(results[x])
              else if tempStr = 'PN' then
                fVPain.Add(results[x]);
            end;

            for x := 0 to length(VitalState) - 1 do
              VitalState[TVitalTypes(x)] := 3;
            RefreshVitals;

          finally
          end;
        end;

end; // LoadVitals

procedure TfraVitals.grdVitalsClick(Sender: TObject);
//var
//  x: Integer;
//  SavRow: Integer;
begin
  {with grdVitals do
  begin
    //    SavRow := Row;
    if Row = 0 then
      exit;
    x := integer(Objects[0, Row]);
    if x = -1 then
      exit;
    if VitalState[TVitalTypes(x)] = 0 then
      VitalState[TVitalTypes(x)] := 1
    else if VitalState[TVitalTypes(x)] = 1 then
      VitalState[TVitalTypes(x)] := 0;
    // RefreshVitals;
    // resetting the row here would generate another click event and
    // cause a recursion on grdVitalsClick
    //    Row := Max(SavRow, Row);
  end;}
end;

procedure TfraVitals.grdVitalsDblClick(Sender: TObject);
var
  x: Integer;
//  SavRow: Integer;
begin
  with grdVitals do begin
//    SavRow := Row;
    if Row = 0 then
      exit;
    x := integer(Objects[0, Row]);
    if x = -1 then
      exit;
    if VitalState[TVitalTypes(x)] = 0 then
      VitalState[TVitalTypes(x)] := 1
    else if VitalState[TVitalTypes(x)] = 1 then
      VitalState[TVitalTypes(x)] := 0;
    RefreshVitals;
    //    Row := Max(SavRow, Row);
//    if (x = 0) or (x = 1) then
//    begin
//    Row := SavRow;
    //    end;

  end;
end;

procedure TfraVitals.grdVitalsEnter(Sender: TObject);
var
  CanSelect: Boolean;
begin
  with grdVitals do begin
    if (rowcount > 1) and (row < 1) then
      row := 1;
    grdVitalsSelectCell(Sender, Col, Row, CanSelect);
  end;
end;

procedure TfraVitals.grdVitalsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  x: Integer;
//  SavRow: Integer;
begin
  if (key = VK_RIGHT) or (key = VK_LEFT) or (key = VK_SPACE) or
    (key = VK_OEM_MINUS) or (key = VK_OEM_PLUS) or
    (key = VK_ADD) or (key = VK_SUBTRACT) then
    with grdVitals do begin
      //      SavRow := Row;
      if Row = 0 then
        exit;
      x := integer(Objects[0, Row]);
      if x = -1 then
        exit;
      if VitalState[TVitalTypes(x)] = 0 then
        VitalState[TVitalTypes(x)] := 1
      else if VitalState[TVitalTypes(x)] = 1 then
        VitalState[TVitalTypes(x)] := 0;
      RefreshVitals;

      //      Row := SavRow;

    end;

end;

procedure TfraVitals.grdVitalsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  SelectedVX := ACol;
  SelectedVY := ARow;
end;

procedure TfraVitals.lvwVitalsClick(Sender: TObject);
//var
//  x: integer;
begin
  with lvwVitals do begin
    if ItemIndex = -1 then
      exit;
    if items[ItemIndex].ImageIndex = 3 then
      exit;
    if items[ItemIndex].imageIndex = 4 then
      exit;
    if integer(Items[ItemIndex].Data) = -1 then
      exit;
    if VitalState[TVitalTypes(integer(Items[ItemIndex].Data))] = 0 then
      VitalState[TVitalTypes(integer(Items[ItemIndex].Data))] := 1
    else if VitalState[TVitalTypes(integer(Items[ItemIndex].Data))] = 1 then
      VitalState[TVitalTypes(integer(Items[ItemIndex].Data))] := 0;
    RefreshVitals;
  end;
end;

procedure TfraVitals.lvwVitalsEnter(Sender: TObject);
begin
  if (lvwVitals.Selected = nil) and (lvwVitals.Items[0] <> nil) then
    lvwVitals.Selected := lvwVitals.Items[0];
end;

procedure TfraVitals.lvwVitalsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  x, y: integer;
begin
  if (key = VK_RIGHT) or (key = VK_LEFT) then
    with lvwVitals do begin
      if ItemIndex = -1 then
        exit;
      if integer(Items[ItemIndex].Data) = -1 then
        exit;
      y := ItemIndex;
      x := VitalState[TVitalTypes(integer(Items[ItemIndex].Data))];
      if x = 0 then
        VitalState[TVitalTypes(integer(Items[ItemIndex].Data))] := 1
      else if x = 1 then
        VitalState[TVitalTypes(integer(Items[ItemIndex].Data))] := 0;
      RefreshVitals;
      if (x = 0) or (x = 1) then begin
        lvwVitals.itemindex := y;
        lvwVitals.Items[y].Focused := True;
      end;

    end;

end; // lvwVitalsKeyUp

procedure TfraVitals.RefreshVitals;
//var
//  x: integer;
//  ztest: string;
var
  CurRow, SavRow: Integer;
  tstr: string;

  procedure SetColumnData(VitalType: TVitalTypes; VitalsIn: TStringList);
  var
    x: integer;
  begin
    { TODO -oBob -cReview : Check handling of x for VitalState = 2;  x may be undefined. }
    x := 0; // rpk 9/24/2010; was not initialized, implied 0

    //  0=+ 1=- 2=blank 3=unknown
    if VitalState[VitalType] = 3 then
      if VitalsIn.Count > 1 then
        VitalState[VitalType] := 0
      else
        VitalState[VitalType] := 2;

    if ScreenReaderSystemActive then begin // update stringgrid
      case VitalState[VitalType] of
        0: begin //Plus
            Inc(CurRow);
            with grdVitals do begin
              RowCount := CurRow + 1;
              tstr := '"+ ' + VitalNames[VitalType] + '" "' +
                piece(VitalsIn[0], '^', 4) + '" "' +
                DisplayVADateYearTime(piece(VitalsIn[0], '^', 2)) + '"';
              Rows[CurRow].CommaText := tstr;
              // Items[Items.count - 1].ImageIndex := VitalState[VitalType];
              Objects[0, CurRow] := ptr(integer(VitalType));
              //              Objects[1, CurRow] := ptr(integer(VitalState[VitalType]));
            end;
          end;

        1: //minus
          for x := 0 to VitalsIn.Count - 1 do
            if x = 0 then begin
              Inc(CurRow);
              with grdVitals do begin
                RowCount := CurRow + 1;
                tstr := '"- ' + VitalNames[VitalType] + '" "' +
                  piece(VitalsIn[x], '^', 4) + '" "' +
                  DisplayVADateYearTime(piece(VitalsIn[x], '^', 2)) + '"';
                Rows[CurRow].CommaText := tstr;
                // Items[Items.count - 1].ImageIndex := VitalState[VitalType];
                Objects[0, CurRow] := ptr(integer(VitalType));
                //                Objects[1, CurRow] := ptr(integer(VitalState[VitalType]));
              end;
            end
            else if x = VitalsIn.Count - 1 then begin
              Inc(CurRow);
              with grdVitals do begin
                RowCount := CurRow + 1;
                tstr := '" ", "' + piece(VitalsIn[x], '^', 4) + '", "' +
                  DisplayVADateYearTime(piece(VitalsIn[x], '^', 2)) + '"';
                Rows[CurRow].CommaText := tstr;
                // Items[Items.count - 1].imageIndex := 4;
                Objects[0, CurRow] := ptr(-1);
                //                Objects[1, CurRow] := ptr(integer(4));
              end;
            end
            else begin
              Inc(CurRow);
              with grdVitals do begin
                RowCount := CurRow + 1;
                tstr := '" ", "' +
                  piece(VitalsIn[x], '^', 4) + '", "' +
                  DisplayVADateYearTime(piece(VitalsIn[x], '^', 2));
                Rows[CurRow].CommaText := tstr;
                // Items[Items.count - 1].ImageIndex := 3;
                Objects[0, CurRow] := ptr(-1);
                //                Objects[1, CurRow] := ptr(integer(3));
              end;
            end;
        2: //null pic, either only one entry or no entries
          if VitalsIn.Count = 0 then begin
            Inc(CurRow);
            with grdVitals do begin
              RowCount := CurRow + 1;
              tstr := '" ' + VitalNames[VitalType] +
                '", " ", "No Entries Found"';
              Rows[CurRow].CommaText := tstr;
              // Items[Items.count - 1].ImageIndex := 2;
              Objects[0, CurRow] := ptr(integer(-1));
              //              Objects[1, CurRow] := ptr(integer(2));
            end;
          end
          else begin
              // 1 item in VitalsIn, x = index 0
            Inc(CurRow);
            with grdVitals do begin
              RowCount := CurRow + 1;
              tstr := '" ' + VitalNames[VitalType] + '" "' +
                piece(VitalsIn[x], '^', 4) + '" "' +
                DisplayVADateYearTime(piece(VitalsIn[x], '^', 2)) + '"';
              Rows[CurRow].CommaText := tstr;
                // Items[Items.count - 1].ImageIndex := 2;
              Objects[0, CurRow] := ptr(integer(-1));
                //                Objects[1, CurRow] := ptr(integer(2));
            end; // with grdVitals
//            end; // if
          end; // case VitalState[VitalType]
      end; // case
    end // ScreenReaderSystemActive true
    else begin // update listview
      case VitalState[VitalType] of
        0: //Plus
          with lvwVitals do begin
            AddItem(VitalNames[VitalType], ptr(integer(VitalType)));
            Items[Items.count - 1].SubItems.Add(piece(VitalsIn[0], '^', 4));
            Items[Items.count -
              1].SubItems.Add(DisplayVADateYearTime(piece(VitalsIn[0], '^',
              2)));
            Items[Items.count - 1].ImageIndex := VitalState[VitalType];
          end;

        1: //minus
          with lvwVitals do
            for x := 0 to VitalsIn.Count - 1 do
              if x = 0 then begin
                lvwVitals.AddItem(VitalNames[VitalType],
                  ptr(integer(VitalType)));
                Items[Items.count - 1].SubItems.Add(piece(VitalsIn[x], '^', 4));
                Items[Items.count -
                  1].SubItems.Add(DisplayVADateYearTime(piece(VitalsIn[x], '^',
                  2)));
                Items[Items.count - 1].ImageIndex := VitalState[VitalType];
              end
              else if x = VitalsIn.Count - 1 then begin
                lvwVitals.AddItem('', ptr(-1));
                Items[Items.count - 1].SubItems.Add(piece(VitalsIn[x], '^', 4));
                Items[Items.count -
                  1].SubItems.Add(DisplayVADateYearTime(piece(VitalsIn[x], '^',
                  2)));
                Items[Items.count - 1].imageIndex := 4;
              end
              else begin
                lvwVitals.AddItem('', ptr(-1));
                Items[Items.count - 1].SubItems.Add(piece(VitalsIn[x], '^', 4));
                Items[Items.count -
                  1].SubItems.Add(DisplayVADateYearTime(piece(VitalsIn[x], '^',
                  2)));
                Items[Items.count - 1].ImageIndex := 3;
              end;
        2: //null pic, either only one entry or no entries
          with lvwVitals do begin
            if VitalsIn.Count = 0 then begin
              lvwVitals.AddItem(VitalNames[VitalType], ptr(integer(-1)));
              Items[Items.count - 1].SubItems.Add('');
              Items[Items.count - 1].SubItems.Add('No Entries Found');
              Items[Items.count - 1].ImageIndex := 2;
            end
            else begin
              // 1 item in VitalsIn, x = index 0
              lvwVitals.AddItem(VitalNames[VitalType], ptr(integer(-1)));
              Items[Items.count - 1].SubItems.Add(piece(VitalsIn[x], '^', 4));
              Items[Items.count -
                1].SubItems.Add(DisplayVADateYearTime(piece(VitalsIn[x], '^',
                2)));
              Items[Items.count - 1].ImageIndex := 2;
            end;
          end;
      end; // case VitalState[VitalType]
    end; // ScreenReaderSystemActive false

  end; // SetColumnData

begin

  CurRow := 0;
  SavRow := 0;

  if ScreenReaderSystemActive then begin
    SavRow := grdVitals.Row;
    // row 0 contains column titles;  first inc in SetColumnData will use row 1
    lvwVitals.SendToBack;
    lvwVitals.Hide;
    lvwVitals.TabStop := False;

    grdVitals.BringToFront;
    grdVitals.TabStop := True;
    grdVitals.Show;
//    if grdVitals.CanFocus then
//      grdVitals.SetFocus;
    grdVitals.Align := alClient;
//    sgInit(grdVitals, 1, 2); // rpk 9/10/2010
    sgInit(grdVitals, 1, 0); // rpk 10/12/2010
    grdVitals.rows[0].CommaText := 'Vital, Value, Date';
    grdVitals.Invalidate;
  end
  else begin
    with lvwVitals do begin
      Clear;
      Columns[0].Width := 75;
      Columns[1].Width := 75;
      Columns[2].Width := Width - (Columns[0].Width + Columns[1].Width) - 25;
//      Columns[0].Width := 50; // rpk 10/8/2009
//      Columns[1].Width := 50; // rpk 10/8/2009
//      Columns[2].Width := Width - (Columns[0].Width + Columns[1].Width);
      // rpk 10/8/2009
      grdVitals.SendToBack;
      grdVitals.Hide;
      grdVitals.TabStop := False;

      lvwVitals.BringToFront;
      lvwVitals.TabStop := True;
      lvwVitals.Show;
//      if lvwVitals.CanFocus then
//        lvwVitals.SetFocus;
      lvwVitals.Align := alClient;
      lvwVitals.Invalidate;
    end;
  end;

  {if ScreenReaderSystemActive then
  begin
    lvwVitals.SendToBack;
    lvwVitals.Hide;
    grdVitals.BringToFront;
    grdVitals.Show;
    grdVitals.Align := alClient;
    grdVitals.RowCount := grdVitals.FixedRows;
    grdVitals.rows[0].CommaText := 'Vital, Value, Date';
    SelectedVX := 1;
    SelectedVY := 1;
    grdVitals.Invalidate;
  end
  else
  begin
    grdVitals.SendToBack;
    grdVitals.Hide;
    lvwVitals.BringToFront;
    lvwVitals.Show;
    lvwVitals.Align := alClient;
    lvwVitals.Invalidate;
  end;}

  SetColumnData(vtTemp, fvTemp);
  SetColumnData(vtPain, fvPain);
  SetColumnData(vtBP, fvBP);
  SetColumnData(vtPulse, fvPulse);
  SetColumnData(vtResp, fvResp);
  //  case VitalState[vtTemp] of
  //    3:

  if ScreenReaderSystemActive then begin
    if SavRow < 1 then
      SavRow := 1;
    grdVitals.Row := Min(grdVitals.RowCount - 1, SavRow);
  end;

end; // RefreshVitals

initialization
  SpecifyFormIsNotADialog(TfraVitals);

end.

