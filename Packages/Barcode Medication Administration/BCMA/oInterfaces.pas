unit oInterfaces;
interface

uses
  Controls, Classes;
type
  I_Anything = interface
    ['{23E71F9E-C3DB-4E3E-8365-00DECD6C5717}']
    procedure CreateMe(aWinControl: TWinControl);
    procedure RebuildMe;
    function MyNameIs: string;
    procedure CloseMe;

    //    property EnableDisplayOrders: Boolean read FEnableDisplayOrders write FEnableDisplayOrders;
    //    function EnableDisplayOrdersMenu: Boolean;
    //    function EnableDisplayMedHistory: Boolean;
    //    function EnableDisplayAvailableBags: Boolean;

  end;

type
  TBaseInterfacedObject = class(TInterfacedObject)
    {
    This object exposes _AddRef and _Release to the public level
    so that it is inheritted and doesn't have to be added to every
    class that uses any of these interfaces.
    }
  public
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

implementation

{ TBaseInterfacedObject }

function TBaseInterfacedObject._AddRef: Integer;
begin
  Result := -1;
end;

function TBaseInterfacedObject._Release: Integer;
begin
  Result := -1;
end;
end.
