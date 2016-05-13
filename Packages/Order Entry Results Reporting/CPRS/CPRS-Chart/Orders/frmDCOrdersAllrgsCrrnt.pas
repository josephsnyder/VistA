unit frmDCOrdersAllrgsCrrnt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, fBase508Form,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, ORNet, VA508AccessibilityManager, rMisc;

type
  TfrmDCOrdersAllrgsCrrnt = class(TfrmBase508Form)
    lblAllergies: TLabel;
    Panel1: TPanel;
    lstAlleries: TCaptionListBox;
    Panel2: TPanel;
    cmdYes: TButton;
    cmdNo: TButton;
    mnoVerifyAllrgyDisc: TMemo;
    lblVerifyAllrgyDisc: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmdYesClick(Sender: TObject);
    procedure cmdNoClick(Sender: TObject);
    procedure lstAlleriesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstAlleriesMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure unMarkedOrignalOrderDC(OrderArr: TStringList);
  private
    okYesPressed: Boolean;
    function MeasureColumnHeight(TheOrderText: string; Index: Integer):integer;

  public
    existingPatientAllergiesStrLst: TStringList;
  end;

//function ExecuteDCOrders(SelectedList: TList; var DelEvt: boolean): Boolean;
function ExecuteDCAllgryOrders(): Boolean;

implementation

{$R *.DFM}

////NSR20080226 Ty - added fArtAllgy to uses.
uses rOrders, uCore, uConst, fOrders, fArtAllgy,rCover, fOptionsSurrogate;

function ExecuteDCAllgryOrders(): Boolean;
var
 frmDCOrdersAllrgsCrrnt: TfrmDCOrdersAllrgsCrrnt;
begin
  try
    frmDCOrdersAllrgsCrrnt := TfrmDCOrdersAllrgsCrrnt.Create(Application);
    try
      frmDCOrdersAllrgsCrrnt.ShowModal;
      Result := frmDCOrdersAllrgsCrrnt.okYesPressed;
    finally
      frmDCOrdersAllrgsCrrnt.Free;
    end;
  except
    Result := False;
  end;
end;

procedure TfrmDCOrdersAllrgsCrrnt.FormCreate(Sender: TObject);
var
  I: Integer;
  AllergiesStrLst: TStringList;
  AllergyStr: String;
  const NO_KNOWN_ALLERGIES='No Known Allergies';
begin
  inherited;
  AllergiesStrLst := nil;
  okYesPressed:=false;
  try
      existingPatientAllergiesStrLst := TStringList.Create;
      AllergiesStrLst:= TStringList.Create; //Used as a place hold or parsing drug name
      ListAllergies(existingPatientAllergiesStrLst);
      lstAlleries.Sorted:=true;
      for I := 0 to existingPatientAllergiesStrLst.count -1 do
       begin
         if (Piece(existingPatientAllergiesStrLst.Strings[0], U, 1) = '') and (Piece(existingPatientAllergiesStrLst.Strings[0], U, 2) <> NO_KNOWN_ALLERGIES) then
            begin
              lstAlleries.items.add(NO_KNOWN_ALLERGIES);
            end
         else
            begin
//              if POS('^',existingPatientAllergiesStrLst.Strings[i]) > 0 then
//                 frmOptionsSurrogate.SplitAString('^',existingPatientAllergiesStrLst.Strings[i],AllergiesStrLst);

//************** CODE WAS MODIFIED 05/05/2015 by Kim Hovorka for NSR #20080226  **************************/
              AllergyStr:=Piece(existingPatientAllergiesStrLst.Strings[i], '^', 2)+
                '  [SEVERITY:'+Piece(existingPatientAllergiesStrLst.Strings[i], '^', 3)+']  '+
                Piece(existingPatientAllergiesStrLst.Strings[i], '^', 4);

              lstAlleries.items.add(AllergyStr);
            end;
       end;
  finally
     existingPatientAllergiesStrLst.Destroy;
     AllergiesStrLst.Destroy;
  End;
end;

procedure TfrmDCOrdersAllrgsCrrnt.cmdYesClick(Sender: TObject);
begin
  inherited;
   okYesPressed:=true;
   Close;
end;

procedure TfrmDCOrdersAllrgsCrrnt.cmdNoClick(Sender: TObject);
begin
  inherited;
  okYesPressed:=false;
 Close;
end;

procedure TfrmDCOrdersAllrgsCrrnt.lstAlleriesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
begin
  inherited;
  x := '';
  ARect := Rect;
  with lstAlleries do
  begin
   if Index < Items.Count then
    begin
      x := Items[Index];
      DrawText(Canvas.handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
    end;
  end;
end;

procedure TfrmDCOrdersAllrgsCrrnt.lstAlleriesMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x:string;
begin
  inherited;
  with lstAlleries do if Index < Items.Count then
  begin
    x := Items[index];
    AHeight := MeasureColumnHeight(x, Index);
  end;
end;

function TfrmDCOrdersAllrgsCrrnt.MeasureColumnHeight(TheOrderText: string;
  Index: Integer): integer;
var
  ARect: TRect;
begin
  ARect.Left := 0;
  ARect.Top := 0;
  ARect.Bottom := 0;
  ARect.Right := lstAlleries.Width - 6;
  Result := WrappedTextHeightByFont(lstAlleries.Canvas,lstAlleries.Font,TheOrderText,ARect);
end;

procedure TfrmDCOrdersAllrgsCrrnt.FormDestroy(Sender: TObject);
begin
  inherited;
  if self.existingPatientAllergiesStrLst <> nil then self.existingPatientAllergiesStrLst.Free;
end;

procedure TfrmDCOrdersAllrgsCrrnt.unMarkedOrignalOrderDC(OrderArr: TStringList);
begin
 CallV('ORWDX1 UNDCORIG', [OrderArr]);
end;

end.
