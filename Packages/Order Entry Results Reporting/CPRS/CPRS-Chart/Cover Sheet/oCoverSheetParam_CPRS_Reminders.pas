unit oCoverSheetParam_CPRS_Reminders;

{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    PII                 
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TCoverSheetParam_CPRS. Special functions
  *                     for the CLinical Reminders display
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
  TCoverSheetParam_CPRS_Reminders = class(TCoverSheetParam_CPRS, ICoverSheetParam)
  protected
    function getDetailRPC: string; override;

    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
    { Public declarations }
  end;

implementation

uses
  mCoverSheetDisplayPanel_CPRS_Reminders;

{ TCoverSheetParam_CPRS_Reminders }

function TCoverSheetParam_CPRS_Reminders.getDetailRPC: string;
begin
  { TODO 3 -oDanP -cThings Yet Undone : Something about interactive reminders }
  // if InteractiveReminders then
  // Result := 'ORQQPXRM REMINDER DETAIL'
  // else
  Result := 'ORQQPX REMINDER DETAIL';
end;

function TCoverSheetParam_CPRS_Reminders.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_CPRS_Reminders.Create(aOwner);
end;

end.
