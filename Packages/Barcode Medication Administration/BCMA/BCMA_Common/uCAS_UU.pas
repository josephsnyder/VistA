unit uCAS_UU;

interface
uses
  Classes
  , SysUtils
  ;

function UUDecodeStringListToStream(aSL: TStringList; aStream: TStream): Integer;
function UUEncodeMemoryStreamToStringList(aMemStream: TMemoryStream): TStringList;

//function UUEncode(aSource: string): string;
//function UUEncodeStringStream(aSource: TStringStream): string;


type
  TTriplet = array[0..2] of byte;
  TKwartet = array[0..3] of byte;

const
  UUE_HEADER = 'begin';                 //'-- Begin UUEncoded Data --';
  UUE_FOOTER = 'end';                   //'--- End UUEncoded Data ---';
  MAX_RPC_LINES = 100;

implementation

uses
//  IdCoderUUE,
  Dialogs
  ;


// copied from http://www.drbob42.com/books/uucode.htm ------------------- begin
const
  SP = $20;

procedure Triplet2Kwartet(const Triplet: TTriplet;
  var Kwartet: TKwartet);
var
  i: Integer;
begin
  Kwartet[0] := (Triplet[0] SHR 2);
  Kwartet[1] := ((Triplet[0] SHL 4) AND $30) +
    ((Triplet[1] SHR 4) AND $0F);
  Kwartet[2] := ((Triplet[1] SHL 2) AND $3C) +
    ((Triplet[2] SHR 6) AND $03);
  Kwartet[3] := (Triplet[2] AND $3F);
  for i := 0 to 3 do
    if Kwartet[i] = 0 then
      Kwartet[i] := $40 + Ord(SP)
    else Inc(Kwartet[i], Ord(SP))
end;                                    // Triplet2Kwartet


procedure Kwartet2Triplet(const Kwartet: TKwartet;
  var Triplet: TTriplet);
//var
//  i: Integer;
begin
  Triplet[0] := Byte(((Kwartet[0] - Ord(SP)) SHL 2) +
    (((Kwartet[1] - Ord(SP)) AND $30) SHR 4));
  Triplet[1] := Byte((((Kwartet[1] - Ord(SP)) AND $0F) SHL 4) +
    (((Kwartet[2] - Ord(SP)) AND $3C) SHR 2));
  Triplet[2] := Byte((((Kwartet[2] - Ord(SP)) AND $03) SHL 6) +
    ((Kwartet[3] - Ord(SP)) AND $3F))
end;                                    //  Kwartet2Triplet

// copied from http://www.drbob42.com/books/uucode.htm --------------------- end

function UUDecodeStringListToStream(aSL: TStringList; aStream: TStream): Integer;
var
  s: String;
  iStart,
//  iStop,
  i: Integer;

  procedure ProcessLine(aLine: String);
  var
    iBytes,
      iPosLine,
      iPosBuff,
      i,
      iLen: Integer;

    aQuartet: TKwartet;
    aTriplet: TTriplet;

    Buff: array[0..45] of byte;

  begin
    iBytes := ord(aLine[1]) - 32;
    iPosLine := 2;
    iPosBuff := 0;
    iLen := Length(aLine);

    for i := 0 to 45 do
      Buff[i] := 0;

    while iPosLine + 3 <= iLen do
    begin
      for i := 0 to 3 do
        aQuartet[i] := ord(aLine[iPosLine + i]);

      aTriplet[0] := 0;
      aTriplet[1] := 0;
      aTriplet[2] := 0;

      Kwartet2Triplet(aQuartet, aTriplet);
      for i := 0 to 2 do
        Buff[i + iPosBuff] := aTriplet[i];

      inc(iPosBuff, 3);
      inc(iPosLine, 4);
    end;
    aStream.Write(Buff, iBytes);
  end;                                  // ProcessLine

begin
  Result := 0;
  // if the data is encoded both header and footer should be present
  if (pos(UUE_HEADER, aSL.Text) = 0)
    or (pos(UUE_FOOTER, aSL.Text) = 0) then
    Exit;

  iStart := -1;
  for i := 0 to aSL.Count - 1 do
    if pos(UUE_HEADER, Trim(aSL[i])) = 1 then
    begin
      iStart := i;                      // search for the first occurence of the Header;
      break;
    end
    else
      inc(iStart);
  if iStart < 0 then
    Exit;

  i := iStart + 1;                      // selecting line after the HEADER
  while aSL[i] <> UUE_FOOTER do
  try
    s := trim(aSL[i]);
    processLine(s);
    aSL.Delete(i);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;

  // added return result > 0 on success
  Result := i;                          // rpk 1/20/2016

end;                                    // UUDecodeStringListToStream

function UUEncodeMemoryStreamToStringList(aMemStream: TMemoryStream): TStringList;
var
  s: String;
  i, iLen, iTotal: Integer;
//    iPos: Integer;
  SL: TSTringList;
  Triplet: TTriplet;
  Kwartet: TKwartet;
begin
  SL := TStringList.Create;
  SL.Add(UUE_HEADER + ' 777 ' + 'fileName.uue');
  aMemStream.Position := 0;
  iTotal := 0;                          // rpk 3/31/2016
  while aMemStream.Position < aMemStream.Size do
  begin
    Triplet[0] := 0;
    Triplet[1] := 0;
    Triplet[2] := 0;
    iLen := aMemStream.Read(Triplet, 3);
    if iLen = 0 then
      break;

    Triplet2Kwartet(Triplet, Kwartet);
    for i := 0 to 3 do
      s := s + char(Kwartet[i]);

    if iLen < 3 then
    begin
      s := char(iTotal + iLen + 32) + s;
      SL.Add(s);
      break;
    end;
    if length(s) = 60 then
    begin
      s := 'M' + s;
      SL.Add(s);
      s := '';
      iTotal := 0;
    end
    else
      inc(iTotal, iLen);
  end;
  SL.Add(UUE_FOOTER);
  Result := SL;
end;                                    // UUEncodeMemoryStreamToStringList

{ function StreamToString(aStream: TStream): String;
var
  SS: TStringStream;
begin
  Result := '';
  if aStream <> nil then
  begin
    SS := TStringStream.Create('');
    try
      ss.CopyFrom(aStream, 0);
      Result := SS.DataString;
    finally
      SS.Free;
    end;
  end;
                                  end; }// StreamToString

{ function UUEncode(aSource: string): string;
var
  aStrList: TStringList;
  aStrStream: TStringStream;
begin
  aStrStream := TStringStream.Create(aSource);
  aStrList := TStringList.Create;

  with TIdEncoderUUE.Create(nil) do
  try
    aStrList.Add(UUE_HEADER);
    aStrStream.Position := 0;
    while aStrStream.Position < aStrStream.Size do
      aStrList.Add(Encode(aStrStream, 45));
    aStrList.Add(UUE_FOOTER);
  finally
    FreeAndNil(aStrStream);
    Free;
  end;
  Result := aStrList.Text;
  aStrList.Free;
                                  end; }// UUEncode

{ function UUEncodeStringStream(aSource: TStringStream): string;
var
  aStrList: TStringList;
begin
  aStrList := TStringList.Create;

  with TIdEncoderUUE.Create(nil) do
  try
    aStrList.Add(UUE_HEADER);
    aSource.Position := 0;
    while aSource.Position < aSource.Size do
      aStrList.Add(Encode(aSource, 45));
    aStrList.Add(UUE_FOOTER);
  finally
    Free;
  end;
  Result := aStrList.Text;
  aStrList.Free;
                                  end; }// UUEncodeStringStream

{ function UUEncodeString(aSource: string): string;
var
  aStrStream: TStringStream;
begin
  aStrStream := TStringStream.Create(aSource);
  Result := UUEncodeStringStream(aStrStream);
  aStrStream.Free;
                                  end; }// UUEncodeString


end.

