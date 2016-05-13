unit fDupPro;    //Created by Kim Hovorka 12/01/2014 for Similar Provider Name issue

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ORCtrls, ExtCtrls, OrFn, OrNet, fBase508Form,
  VA508AccessibilityManager, Vcl.ComCtrls;

type
  TfrmDupPro = class(TfrmBase508Form)
    pnlDupPros: TPanel;
    pnlSelDupPro: TPanel;
    lblSelDupPros: TLabel;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lboSelPro: TCaptionListView;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lboSelProDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    function getDupDFN: Int64;
  public
  end;

var
  frmDupPro: TfrmDupPro;
  DupDFN : Int64;
  ProStrs: TStringList;

function CheckforSimilarProviders(const DUZ: Int64; CSPKey:String; CSPFlag:Boolean): Int64; //Modified by Kim Hovorka 03/16/2015
function CheckforSimilarCosigners(const DUZ: Int64; CSPDate:Double; TITLEIEN: Integer; IEN:Integer; CSPFlag:Boolean): Int64; //Added by Kim Hovorka 12/2/2014

implementation

{$R *.dfm}

uses rCore, uCore;  //, fEncnt;

procedure TfrmDupPro.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmDupPro.FormActivate(Sender: TObject);
var
  theDups: tStringList;

begin
  inherited;
  DupDFN := -1; // Pre-set as default.
  theDups := tStringList.create;
  FastAssign(ProStrs, theDups);
  FastAssign(theDups, lboSelPro.ItemsStrings); //Add duplicate clinical names to window.
  ResizeAnchoredFormToFont(self);
end;

procedure TfrmDupPro.btnOKClick(Sender: TObject);
begin
  if not (Length(lboSelPro.ItemID) > 0) then  //*DFN*
  begin
    infoBox('A provider has not been selected.', 'No Provider Selected', MB_OK);
    exit;
  end;

  DupDFN := lboSelPro.ItemID;  //*DFN*
  close;
end;

procedure TfrmDupPro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (key = VK_ESCAPE) then
    btnCancel.click;
end;

procedure TfrmDupPro.lboSelProDblClick(Sender: TObject);
begin
  btnOKClick(btnOK);
end;

function TfrmDupPro.getDupDFN: Int64;
begin
  Result := DupDFN;
end;

function CheckforSimilarProviders(const DUZ: Int64; CSPKey:String; CSPFlag:Boolean): Int64; //Added by Kim Hovorka 12/2/2014
var
  i: Integer;
  frmProDupSel: TfrmDupPro;
  PrStrs: TStringList;
  DupDFN : Int64;

begin
  DupDFN := -1;

  if DUZ = 0 then
  begin
    ShowMessage('No Provider Selected!');
    Result := DupDFN;
    Exit;
  end;

  if User.DUZ <> DUZ then
    begin
      // Check data on server for duplicates:
      CallV('ORWU NEWPERS',[DUZ,1,CSPKey,'','','',CSPFlag]); //was using 'PROVIDER-CLINICAL';
      PrStrs := TStringList.Create;

      with RPCBrokerV do
        if (Results.Count > 1) OR ((Results.Count = 1) AND (StrToInt64(Piece(Results[0], U, 1)) <> DUZ)) then    //Get the duplicate clinical provider information here!
          begin
            for i := 0 to Results.Count - 1 do
            begin
              PrStrs.Add(Piece(Results[i], U, 1) + U + Piece(Results[i], U, 2) + Piece(Results[i], U, 3));
            end;

            // Call form to get user's selection of Duplicate Clinical Providers:
            frmProDupSel := TfrmDupPro.Create(Application);

            with frmProDupSel do
              begin
                try
                  ProStrs := PrStrs;
                  ShowModal;
                  DupDFN := getDupDFN;
                finally
                  Release;
//                  Result := DupDFN;
                end;
              end;
          end          //This section and below modified on 3/17/2015
          else if ((Results.Count = 1) AND (StrToInt64(Piece(Results[0], U, 1)) = DUZ)) then    //Get the duplicate clinical provider information here!
            DupDFN := DUZ
          else if (Results.Count = 0) then
            ShowMessage('The name selected is not a CPRS user name allowable for entry in this field. Please select another name.');
    end
    else
      DupDFN := DUZ;

  Result := DupDFN;
end;

function CheckforSimilarCosigners(const DUZ: Int64; CSPDate:Double; TITLEIEN: Integer; IEN:Integer; CSPFlag:Boolean): Int64; //Added by Kim Hovorka 12/2/2014
var
  i: Integer;
  frmProDupSel: TfrmDupPro;
  PrStrs: TStringList;
  DupDFN : Int64;

begin
  DupDFN := -1;

  if DUZ = 0 then
  begin
    ShowMessage('No Cosigner Selected!');
    Result := DupDFN;
    Exit;
  end;

  if User.DUZ <> DUZ then
    begin
      // Check data on server for duplicates:
      CallV('ORWU2 COSIGNER',[DUZ,1,CSPDate,IEN,TITLEIEN,CSPFlag]);
      PrStrs := TStringList.Create;

      with RPCBrokerV do
        if (Results.Count > 1) OR ((Results.Count = 1) AND (StrToInt64(Piece(Results[0], U, 1)) <> DUZ)) then    //Get the duplicate clinical cosigners information here!
          begin
            for i := 0 to Results.Count - 1 do
            begin
              PrStrs.Add(Piece(Results[i], U, 1) + U + Piece(Results[i], U, 2) + Piece(Results[i], U, 3));
            end;

            // Call form to get user's selection of Duplicate Clinical Cosigners:
            frmProDupSel := TfrmDupPro.Create(Application);

            with frmProDupSel do
              begin
                try
                  ProStrs := PrStrs;
                  ShowModal;
                  DupDFN := getDupDFN;
                finally
                  Release;
//                  Result := DupDFN;
                end;
              end;
          end          //This section and below modified on 3/17/2015
          else if ((Results.Count = 1) AND (StrToInt64(Piece(Results[0], U, 1)) = DUZ)) then    //Get the duplicate clinical provider information here!
            DupDFN := DUZ
          else if (Results.Count = 0) then
            ShowMessage('The name selected is not a CPRS user name allowable for entry in this field. Please select another name.');
    end
    else
      DupDFN := DUZ;

  Result := DupDFN;
end;

end.
