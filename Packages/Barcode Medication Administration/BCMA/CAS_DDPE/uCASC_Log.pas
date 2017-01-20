unit uCASC_Log;

interface
uses
  Classes
  ;

  function getAdministrations(aPatient,aDate:String): TStringList;
  function getAdministrationDetail(anID:String): TStringList;
  function getMedLogComments(anID:String): TStringList;

implementation
uses
  SysUtils
  , BCMA_Startup
  , BCMA_Common
  ;


function getPsbMedLogLookup(aParam: array of String): TStringList;
var
  i: integer;
  SL,
  MultList: TStringList;
//  tmpstr, rowstr1, rowstr2: string;
//  x: integer;
begin
  MultList := TStringList.Create;

  for i := Low(aParam) to High(aParam) do
    MultList.Add(aParam[i]);

  if (BCMA_Broker <> nil) then
    with BCMA_Broker do
      if CallServer('PSB MED LOG LOOKUP', ['~!#null#~!'], MultList) then begin
        SL := TStringList.Create;

        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0],
          -1)) then
          SL.Add('Incomplete data returned from System')
        else if copy(Results[1],1,2) = '-1' then
          begin
            SL.ADD('Error calling PSB MED LOG LOOKUP');
            for i := Low(aParam) to High(aParam) do
              SL.Add(aParam[i]);
            SL.ADD('Error: ' +  ' - ' + copy(Results[1],4,10000))
          end
        else begin
          Results.Delete(0);

        SL.Text := Results.Text;
        end;
      end;

  MultList.Free;
  Result := SL;
end;

function getAdministrations(aPatient,aDate:String): TStringList;
begin
  Result := getPsbMedLogLookup(['ADMLKUP',aPatient,aDate]);
end;

function getAdministrationDetail(anID:String): TStringList;
begin
  Result := getPsbMedLogLookup(['SELECTAD',anID]);
end;

function getMedLogComments(anID:String): TStringList;
var
  ML: TStringList;
  SL: TSTringList;
begin
  ML := TStringList.Create;
  ML.Add('FILE=53.793');
  ML.Add('IENS=,'+anID+',');
  ML.Add('FIELDS=.01;.02;.03');
  ML.Add('FLAGS=PU');

  SL := TSTringList.Create;
  if (BCMA_Broker <> nil) then
    with BCMA_Broker do
//      if CallServer('ZZ DIC LIST', ['53.793',anID,'.01;.02;.03'],nil) then
      if CallServer('DDR LISTER', ['~!#null#~!'], ML) then
        begin
          SL.Text := Results.Text;
        end
      else
        begin
          SL.Text := 'Errors processing RPC call';
        end;
  Result := SL;
end;
end.
