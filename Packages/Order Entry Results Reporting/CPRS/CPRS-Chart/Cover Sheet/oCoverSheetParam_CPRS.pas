unit oCoverSheetParam_CPRS;

{
  ================================================================================
  *
  *       Application:  CPRS - CoverSheet
  *       Developer:    PII                 
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Inherited from TCoverSheetParam this parameter holds
  *                     custom items for displaying CPRS data in the CoverSheet.
  *
  *       Notes:
  *
  ================================================================================
}
interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  oCoverSheetParam,
  iCoverSheetIntf;

type
  TCoverSheetParam_CPRS = class(TCoverSheetParam, ICoverSheetParam_CPRS)
  private
    fLoadInBackground: boolean;
    fDateFormat: string;
    fDatePiece: integer;
    fDetailRPC: string;
    fInvert: boolean;
    fMainRPC: string;
    fParam1: string;
    fStatus: string;
    fTitleCase: boolean;
    fPollingID: string;
    fHighlightText: boolean;
    fAllowDetailPrint: boolean;
  protected
    function getLoadInBackground: boolean; virtual;
    function getDateFormat: string; virtual;
    function getDatePiece: integer; virtual;
    function getDetailRPC: string; virtual;
    function getInvert: boolean; virtual;
    function getMainRPC: string; virtual;
    function getParam1: string; virtual;
    function getStatus: string; virtual;
    function getTitleCase: boolean; virtual;
    function getPollingID: string; virtual;
    function getHighlightText: boolean; virtual;
    function getAllowDetailPrint: boolean; virtual;

    procedure setLoadInBackground(const aValue: boolean);
    procedure setAllowDetailPrint(const aValue: boolean);

    function NewCoverSheetControl(aOwner: TComponent): TControl; override;
  public
    constructor Create(aInitString: string);
    destructor Destroy; override;
  end;

implementation

uses
  oDelimitedString,
  mCoverSheetDisplayPanel_CPRS;

{ TCoverSheetParam_CPRS }

constructor TCoverSheetParam_CPRS.Create(aInitString: string);
begin
  inherited Create;

  with NewDelimitedString(aInitString) do
    try
      fID := GetPieceAsInteger(1);
      fTitle := GetPiece(2);
      fStatus := GetPiece(3);
      fMainRPC := GetPiece(6);
      fInvert := GetPieceAsBoolean(8, False);
      fDateFormat := GetPiece(10);
      fDatePiece := GetPieceAsInteger(11, 0);
      fParam1 := GetPiece(12);
      fDetailRPC := GetPiece(16);
      fTitleCase := GetPieceAsBoolean(7);
      fHighlightText := GetPieceIsNotNull(9);
      fAllowDetailPrint := False;
      case fID of
        10:
          fPollingID := 'PROB'; // Active Problems
        30:
          fPollingID := 'CWAD'; // Postings
        40:
          fPollingID := 'MEDS'; // Medications
        50:
          fPollingID := 'RMND'; // Clinical Reminders
        60:
          fPollingID := 'LABS'; // Recent Lab Results
        70:
          fPollingID := 'VITL'; // Vitals
        80:
          fPollingID := 'VSIT'; // Appointments
      else
        fPollingID := '';
      end;
    finally
      Free;
    end;
  {
    Example of aInitString from VistA

    ZZZ(0)="99^Women's Health^^S^^WVRPCOR COVER^1^^^^^^^20^2,3^WVRPCOR DETAIL^1^1606"
    ZZZ(1)="70^Vitals^^S^^ORQQVI VITALS^^^^T^4^^^5,17,19,27^2,5,4,6,7,8^^1.1^34"
    ZZZ(2)="80^Appointments/Visits/Admissions^^S^^ORWCV VST^1^1^^T^2^^^16,27^2,3,4^ORWCV DTLVST^2^35"
    ZZZ(3)="10^Active Problems^^S^^ORQQPL LIST^1^^^^^A^^2,3^9,10,2^ORQQPL DETAIL^3^28"
    ZZZ(4)="20^Allergies / Adverse Reactions^^S^^ORQQAL LIST^1^^^^^^^^2^ORQQAL DETAIL^4^29"
    ZZZ(5)="30^Postings^^S^^ORQQPP LIST^1^^Maroon^D^3^^^20^2,3^^5^30"
    ZZZ(6)="40^Active Medications^^S^^ORWPS COVER^1^1^^^^1^^35^2,4^ORWPS DETAIL^6^31"
    ZZZ(7)="50^Clinical Reminders                                        Due Date^^S^^ORQQPX REMINDERS LIST^^^^D^3^^^34,44^2,3^^7^32"
    ZZZ(8)="60^Recent Lab Results^^S^^ORWCV LAB^1^^^D^3^^^34^2,3^ORWOR RESULT^8^33"
    ZZZ(9)="90^Recent Immunizations^^S^^ORQQPX IMMUN LIST^1^^Purple^T^3^^^15,35^2,4,3^ORWCV DTLVST^9^1138"
  }
end;

destructor TCoverSheetParam_CPRS.Destroy;
begin
  inherited;
end;

function TCoverSheetParam_CPRS.getLoadInBackground: boolean;
begin
  Result := fLoadInBackground;
end;

function TCoverSheetParam_CPRS.getAllowDetailPrint: boolean;
begin
  Result := fAllowDetailPrint;
end;

function TCoverSheetParam_CPRS.getDateFormat: string;
begin
  Result := fDateFormat;
end;

function TCoverSheetParam_CPRS.getDatePiece: integer;
begin
  Result := fDatePiece;
end;

function TCoverSheetParam_CPRS.getDetailRPC: string;
begin
  Result := fDetailRPC;
end;

function TCoverSheetParam_CPRS.getHighlightText: boolean;
begin
  Result := fHighlightText;
end;

function TCoverSheetParam_CPRS.getInvert: boolean;
begin
  Result := fInvert;
end;

function TCoverSheetParam_CPRS.getMainRPC: string;
begin
  Result := fMainRPC;
end;

function TCoverSheetParam_CPRS.getParam1: string;
begin
  Result := fParam1;
end;

function TCoverSheetParam_CPRS.getPollingID: string;
begin
  Result := fPollingID;
end;

function TCoverSheetParam_CPRS.getStatus: string;
begin
  Result := fStatus;
end;

function TCoverSheetParam_CPRS.getTitleCase: boolean;
begin
  Result := fTitleCase;
end;

function TCoverSheetParam_CPRS.NewCoverSheetControl(aOwner: TComponent): TControl;
begin
  Result := TfraCoverSheetDisplayPanel_CPRS.Create(aOwner);
end;

procedure TCoverSheetParam_CPRS.setAllowDetailPrint(const aValue: boolean);
begin
  fAllowDetailPrint := aValue;
end;

procedure TCoverSheetParam_CPRS.setLoadInBackground(const aValue: boolean);
begin
  fLoadInBackground := aValue;
end;

end.
