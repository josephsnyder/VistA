unit fODAllergyCheck;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  fODMeds, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ORFn, ORNet, rOrders, Vcl.ComCtrls,
  Winapi.RichEdit, ShellAPI, Vcl.ExtCtrls, VA508AccessibilityManager, fAutoSz;

type
  TfrmAllergyCheck = class(TForm)
    reInfo: TRichEdit;
    Label1: TLabel;
    cbAllergyReason: TComboBox;
    btnContinue: TButton;
    btnCancel: TButton;
    amgrMain: TVA508AccessibilityManager;
    procedure btnContinueClick(Sender: TObject);
    procedure cbAllergyReasonChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MedIEN : Integer;
    parentorder : TForm;
    procedure WndProc(var Msg: TMessage); override; // Used to fire URL's in TRichEdit
    procedure setup(aMedIEN:Integer;aSL: TStringList);
  end;

//  function NewAllergyCheckForm(parent: TForm; ID : Integer): Boolean;
function MedFieldsNeeded(aMedIEN:Integer; var aReason:String):Boolean;

var
  frmAllergyCheck: TfrmAllergyCheck;

implementation

{$R *.dfm}

////////////////////////////////////////////////////////
// Code Below Modified by KCH on 10/15/2015 for NSR 20071211
function MedFieldsNeeded(aMedIEN:Integer; var aReason:String):Boolean;
var
  AllergyCheck: TfrmAllergyCheck;
  SL: TSTringList;

begin
  Result := True;
  SL := TStringList.Create; // initialize explicitely
  aReason := '';

  Try
    OrderChecksOnMedicationSelect(SL, 'PSI', aMedIEN);
    if SL.Count > 0 then
      begin
        AllergyCheck := TfrmAllergyCheck.Create(nil);
        Try
          AllergyCheck.setup(aMedIEN,SL);
          Result := AllergyCheck.ShowModal = mrOk;
          aReason := AllergyCheck.cbAllergyReason.Text;
        Finally
          FreeAndNil(AllergyCheck);
        End;
      end;
  Finally
    SL.Free;
  End;
end;

procedure TfrmAllergyCheck.cbAllergyReasonChange(Sender: TObject);
begin
  btnContinue.Enabled := (Length(Trim(cbAllergyReason.Text)) >= 4) AND
    (Pos('^', cbAllergyReason.Text) = 0);
end;

procedure TfrmAllergyCheck.setup(aMedIEN: Integer; aSL: TStringList);
var
  OCList: TStringList;
  gridText, substr, s: string;
  i,j : Integer;
  remOC: TStringList;
  mask: Word;

begin
  mask := SendMessage(reInfo.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(reInfo.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(reInfo.Handle, EM_AUTOURLDETECT, Integer(true), 0);

  remOC := TStringList.Create;
  GetAllergyReasonList(MedIEN,'A');
  FastAssign(RPCBrokerV.Results,cbAllergyReason.Items);

  OCList := aSL;
  for i := 0 to OCList.Count - 1 do
  begin
    s := Piece(OCList[i], U, 4);
    gridText := s;
    substr := Copy(s, 0, 2);
    if substr = '||' then
      begin
        gridText := '';
        substr := Copy(s, 3, Length(s));
        GetXtraTxt(remOC, Piece(substr, '&', 1), Piece(substr, '&', 2));
        reInfo.Lines.Add('(' + inttostr(i + 1) + ' of ' + inttostr(OCList.Count) + ')  ');
        for j := 0 to remOC.Count - 1 do
          reInfo.Lines.Add('      ' + remOC[j]);
      end
    else
      reInfo.Lines.Add(gridText + CRLF);
  end;
  remOC.Free;
end;

////////////////////////////////////////////////////////

//********** Code below added by KCH 8/7/2015 for NSR 20071211**************
procedure TfrmAllergyCheck.btnContinueClick(Sender: TObject);
begin
(*
  if (Length(Trim(cbAllergyReason.Text)) < 4) or
     not ContainsVisibleChar(cbAllergyReason.Text) then
  begin
  end;
*)
end;

procedure TfrmAllergyCheck.WndProc(var Msg: TMessage);
var
  p: TENLink;
  sURL: string;

begin
  if (Msg.Msg = WM_NOTIFY) then
    begin
      if (PNMHDR(Msg.lParam).code = EN_LINK) then
        begin
          p := TENLink(Pointer(TWMNotify(Msg).NMHdr)^);
          if (p.Msg = WM_LBUTTONDOWN) then
            begin
              try
                SendMessage(frmAllergyCheck.reInfo.Handle, EM_EXSETSEL, 0, Longint(@(p.chrg)));
                sURL := reInfo.SelText;
                ShellExecute(Handle, 'open', PChar(sURL), NIL, NIL, SW_SHOWNORMAL);
              except
                ShowMessage('Error opening HyperLink');
              end;
            end;
        end;
    end;

  inherited;
end;

end.
