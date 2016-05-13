unit uPaPI;

////////////////////////////////////////////////////////////////////////////////
///
/// Project:    PaPI
/// Date:       2012-08-16
/// Comments:
///             Parking a Prescription Initiative (PaPI) support
///
////////////////////////////////////////////////////////////////////////////////

interface
uses
  ORNet
  , uCore
  , rOrders
  ;

const
  papiActive =
    'Active - A prescription with this status is part of the patient''s ' + #13#10 +
    'current expected medication regimen, and if refills remain,' + #13#10 +
    'it can be filled or refilled upon request.';
  papiActiveSusp =
    'Active/Suspended - A prescription with this status is part of the patient''s' + #13#10 +
    'current expected medication regimen and a request has been placed' + #13#10 +
    'to be filled at a future date.';
  papiActivePark =
    'Active/Parked - A prescription with this status is part of the patient''s ' + #13#10 +
    'current expected medication regimen, but the next fill will not be dispensed until requested.';
  papiPending =
    'Pending - A prescription with this status is an order that has been entered through CPRS.' + #13#10+
    'It has been signed by the provider but is awaiting pharmacy review.' + #13#10 +
    'It cannot be filled until after the pharmacist reviews and finishes the order.';
  papiNonVerified =
    'Non-verified - A prescription with this status has been either entered or finished ' + #13#10 +
    'by a pharmacy technician and will become active upon a pharmacist''s review. ' + #13#10 +
    'Until such review, a non-verified order cannot be filled.';
  papiExpired =
    'Expired - A prescription with this status indicates the expiration date has passed ' + #13#10 +
    'and the prescription is no longer active. ' + #13#10 +
    'A prescription may be renewed up to 120 days after expiration.';
  papiHold =
    'Hold - A prescription that was placed on hold due to reasons determined by the physician/pharmacist.' + #13#10 +
    'This prescription cannot be filled until the hold is resolved.';
  papiDiscontinued =
    'Discontinued - A prescription with this status has been made inactive '+ #13#10 +
    'either by a new (replacement) prescription or by the request of a physician.';
  papiDiscontinuedEdit =
    'Discontinued (Edit) - A prescription with this status indicates a medication order ' + #13#10 +
    'has been edited by either a physician  or pharmacist creating a new order.';
  papiUnreleased =
    'Unreleased – An order that has been created in the system but ' + #13#10 +
    'has not been sent to the ancillary service to be addressed.';
  papiCanceled =
    'Canceled – An order that was discontinued before it was shared with an ancillary service.';
  papiRenewed =
//    'Renewed - An order that has been renewed;' + #13#10 +
//    'it is still active until expired or is completed.';
    'Renewed- An order that has been updated;'+#13#10+
    'a more current version of the order exists.';

  papiTX_UnderConstruction =  'Coming soon.';
  papiTC_UnderConstruction =  'Under construction.';

var
  bPaPIAvailable: Boolean;
  bPaPIHide: Boolean;
  bPaPIParkSignature: Boolean;

function papiMedStatusHint(aStatus: String;EditMode:Boolean = false): String;
function papiOrderStatusHint(aStatus: String): String;

function papiParkingAvailable: Boolean; overload;
function papiParkingAvailable(anOrd: TOrder): Boolean; overload;
function papiParkingAvailable(anEnc: TEncounter):Boolean; overload;
function papiParkingAvailable(aLocation,anOrder:String):Boolean; overload;
function papiSetAvailable(aValue:Boolean): String;

function papiParkingHide:Boolean;
function papiSetHide(aValue:Boolean): String;

function getOptionValue(anOption:String):String;
function papiDrugIsParkable(aDrugID: String):Boolean;
function papiOrderIsParkable(anOrderID: String):Boolean;

implementation
uses
  SysUtils, VAUtils;

const           //1      8           20          32      40           53      61   66           79        89         100                 120
  papiKeywords = 'ACTIVE ACTIVE/SUSP ACTIVE/PARKED PENDING NON-VERIFIED EXPIRED HOLD DISCONTINUED CANCELLED UNRELEASED DISCONTINUED (EDIT) RENEWED';
  papiKeywordsOrder =
                 'ACTIVE ACTIVE/SUSP ACTIVE/PARKED PENDING NON-VERIFIED EXPIRED HOLD DISCONTINUED CANCELLED UNRELEASED DISCONTINUED (EDIT) RENEWED';


function papiMedStatusHint(aStatus: String;EditMode:Boolean = false): String;
begin
  Result := '';
  case pos(UpperCase(aStatus),papiKeywords) of
    1: Result := papiActive;
    8: Result := papiActiveSusp;
    20: Result := papiActivePark;
    34: Result := papiPending;
    42: Result := papiNonVerified;
    55: Result := papiExpired;
    63: Result := papiHold;
    68: if EditMode then
          Result := papiDiscontinuedEdit
        else
          Result := papiDiscontinued;
    81: Result := papiCanceled;
    91: Result := papiUnreleased;
    102: Result := papiDiscontinuedEdit;
    122: Result := papiRenewed;
    else
      Result := 'unknown status <'+aStatus+'>';
  end;
end;

function papiOrderStatusHint(aStatus: String): String;
begin
  Result := '';
  case pos(UpperCase(aStatus),papiKeywordsOrder) of
    1: Result := papiActive;
    8: Result := papiActiveSusp;
    20: Result := papiActivePark;
    34: Result := papiPending;
    42: Result := papiNonVerified;
    55: Result := papiExpired;
    63: Result := papiHold;
    68: Result := papiDiscontinued;
    81: Result := papiCanceled;
    91: Result := papiUnreleased;
    102: Result := papiDiscontinuedEdit;
    122: Result := papiRenewed;
    else
      Result := 'unknown status <'+aStatus+'>';
  end;

end;

function papiParkingAvailable:Boolean; overload;
begin
  Result := papiParkingAvailable(Encounter);
end;

function papiParkingAvailable(anEnc: TEncounter): Boolean; overload;
var
  s: String;
begin
  Result := False;
  if Assigned(anEnc) then
    begin
      try
        s := IntToStr(anEnc.Location);
      except
        s := '0';
      end;
      CallV('PSORPC', ['GETPARK','LOC',s]);
      if RPCBrokerV.Results.Count > 0 then
        RESULT := RPCBrokerV.Results[0] = 'YES';
    end;
  bPaPIAvailable := RESULT;
end;

function papiParkingAvailable(anOrd: TOrder): Boolean; overload;
begin
  Result := False;
  if Assigned(anOrd) then
    begin
      CallV('PSORPC', ['GETPARK','ORD',anOrd.ID]);
      if RPCBrokerV.Results.Count > 0 then
        RESULT := RPCBrokerV.Results[0] = 'YES';
    end;
  bPaPIAvailable := RESULT;
end;

function papiParkingAvailable(aLocation,anOrder:String):Boolean; overload;
begin
  //CallV('PSORPC', ['GETPAR','SYS','PSO PARKING','AVAILABLE']);
  CallV('PSORPC', ['GETPARK',aLocation,anOrder]);
  RESULT := RPCBrokerV.Results[0] = 'YES';
  bPaPIAvailable := RESULT;
end;

function papiParkingHide:Boolean;
begin
  //CallV('PSORPC', ['GETPAR','SYS','PSO PARKING','HIDE']);
  CallV('PSORPC', ['GETHIDE']);
  RESULT := RPCBrokerV.Results[0] = 'YES';
  bPaPIHide := RESULT;
end;

function papiSetAvailable(aValue:Boolean): String;
begin
  if aValue then
    CallV('PSORPC', ['SETPARK','YES'])
  else
    CallV('PSORPC', ['SETPARK','NO']);

  RESULT := RPCBrokerV.Results[0];
  bPapiAvailable := aValue;
end;

function papiSetHide(aValue:Boolean): String;
begin
  if aValue then
    CallV('PSORPC', ['SETHIDE','YES'])
  else
    CallV('PSORPC', ['SETHIDE','NO']);

  RESULT := RPCBrokerV.Results[0];
  bPapiHide := aValue;
end;

function getOptionValue(anOption:String):String;
var
  i: integer;
  s: String;
begin
  Result := '';
  for i := 1 to ParamCount do            // params may be: S[ERVER]=hostname P[ORT]=port DEBUG
  begin
    s := ParamStr(i);
    if pos(UpperCase(anOption),UpperCase(s)) = 1 then
      begin
       Result := Piece(s,'=',2);
       break;
     end;
  end;
end;

function papiDrugIsParkable(aDrugID: String):Boolean;
begin
  Result := False;
  CallV('PSORPC', ['PARKDRG',aDrugID]);
  if RPCBrokerV.Results.Count > 0 then
    RESULT := copy(RPCBrokerV.Results[0],1,1) = '1'; 
end;


function papiOrderIsParkable(anOrderID: String):Boolean;
begin
  Result := False;
  CallV('PSORPC', ['PARKORD',anOrderID]);
  if RPCBrokerV.Results.Count > 0 then
    RESULT := copy(RPCBrokerV.Results[0],1,1) = '1'; 
end;

begin
  bPaPIAvailable := False;
  // set PaPI defaults
  bPaPIHide := False;
  bPaPIParkSignature := False;
end.
