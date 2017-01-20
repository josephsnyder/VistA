unit BCMA_ParObjects;

interface
uses
  Classes, VHA_Objects, Trpcb,
//  MFunStr,
  sysutils;
type
  TBCMA_WardList = class(TObject)

  private
    FRPCBroker: TBCMA_Broker;
    FWardName,
      FIEN: string;
    FBCMAWard,
      FPiggyBack,
      FChemo,
      FHyperal,
      FAdmixture,
      FSyringe: Integer;
    FWards: TList;

  protected

  public
    property Wards: TList read FWards;
    property WardName: string read FWardName {write SetWardName};
    property BCMAWard: integer read FBCMAWard;
    property PiggyBack: integer read FPiggyBack;
    property Chemo: Integer read FChemo;
    property Hyperal: Integer read FHyperal;
    property Admixture: Integer read FAdmixture;
    property Strings: Integer read FSyringe;
    property IEN: string read FIEN;

    procedure LoadWardData;
    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    procedure clear;
  end;

implementation

uses
  BCMA_Startup,
  BCMAParameters,
  BCMA_Util;

procedure TBCMA_WardList.LoadWardData();
var
  i: Integer;
begin
  FWards := TList.Create;

  if FRPCBroker <> nil then
    with FRPCBroker do
      if CallServer('PSB WARDLIST', [piece(Division, ';', 1)], nil) then
        for i := 1 to Results.Count - 1 do
        begin
          with FWards do
          begin
            add(TBCMA_WardList.create(FRPCBroker));
            with TBCMA_WardList(FWards[FWards.count - 1]) do
            begin
              FWardName := piece(Results[i], '^', 1);
              FBCMAWard := StrToInt(piece(Results[i], '^', 2));
              if FBCMAWard = 1 then
              begin
                FIEN := piece(Results[i], '^', 3);
                FPiggyBack := StrToInt(piece(Results[i], '^', 7));
                FChemo := StrToInt(piece(Results[i], '^', 5));
                FHyperal := StrToInt(piece(Results[i], '^', 6));
                FAdmixture := StrToInt(piece(Results[i], '^', 4));
                FSyringe := StrToInt(piece(Results[i], '^', 8))
              end;
            end;
          end;
        end;
end;

constructor TBCMA_WardList.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then
  begin
    FRPCBroker := RPCBroker;
    //FWards := TList.Create;
  end;
  Clear;
end;

procedure TBCMA_WardList.Clear;
begin
  if FWards <> nil then
    FWards.Clear;
  FWardName := '';
  FIEN := '';

  FBCMAWard := 0;
  FPiggyBack := 0;
  FChemo := 0;
  FHyperal := 0;
  FAdmixture := 0;
  FSyringe := 0;
end;

end.
