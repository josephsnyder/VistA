unit oCoverSheetParam_CPRS_Allergies;

{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    PII                 
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from base. This parameter is used to override
  *                     the NewCoverSheetControl method.
  *
  *       Notes:
  *
  ================================================================================
}
interface

uses
  System.Classes,
  Vcl.Controls,
  oCoverSheetParam_CPRS,
  iCoverSheetIntf;

type
  TCoverSheetParam_CPRS_Allergies = class(TCoverSheetParam_CPRS, ICoverSheetParam)
  protected
    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
    constructor Create(aInitString: string);
    destructor Destroy; override;
  end;

implementation

uses
  mCoverSheetDisplayPanel_CPRS_Allergies;

{ TCoverSheetParam_CPRS_Allergies }

constructor TCoverSheetParam_CPRS_Allergies.Create(aInitString: string);
begin
  inherited Create(aInitString);
  setAllowDetailPrint(True);
end;

destructor TCoverSheetParam_CPRS_Allergies.Destroy;
begin
  inherited;
end;

function TCoverSheetParam_CPRS_Allergies.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_CPRS_Allergies.Create(aOwner);
end;

end.
