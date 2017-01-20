unit uCAS_ALUtils;

interface

uses
  Classes
  , BCMA_Startup
  , ExtCtrls
  , JPEG
  , Checklst
  , ComCtrls
  ;

type
  TSiteType = (stInjection, stDermal);

  TALItem = class(TObject)
  public
    ID,
//    Width, Height,
    X, Y: Integer;
    InjectionFlag, DermalFlag: Integer;
    Caption: string;
    constructor newALItem(aLine: string);
    function toString: string;
    procedure setByString(aLine: string);
    procedure setByString2(aLine: string);
  end;

  TALGroup = class(TObject)
  private
    fDivision: string;
    procedure setDivision(aDivision: string);
  public
//    Loaded: Boolean;
    ChangeCount: Integer;
    GroupName,
      MasterName,
      ImageName: string;
    LocationItems: TSTringList;

    constructor newALGroup;
    destructor Destroy; override;

    procedure ClearItems;
    function ItemByName(aName: string): TALItem;
    procedure Load(aDivision: string);
    function LocItemsToSL: TStringList;
//    procedure restoreFromBackup(aList: TStringList);
    procedure Save(aDivision: string);
    procedure setByCheckList(aList: TCheckListBox);
    // replace Group LocationItems with items in aList
    function setByList(aList: TStringList): Integer;
    function toString: string;

    property Division: string read fDivision write setDivision;
  end;

  TALGroupList = class(TObject)
  private
    fDivision: string;
    fItemsName: string;
    procedure setDivision(aDivision: string);
    procedure setItemsName(aName: string);
  public
    GroupItems: TStringList;

    property Division: string read fDivision write setDivision;
    property ItemsName: string read fItemsName write setItemsName;

    constructor newALGroupList;
    destructor Destroy; override;

    procedure Clear;
//    function getListMaster(aList: String): String;
    procedure ReLoad;
  end;

const
  ALDefaultList = 'Anatomic Locations';
  BodySiteList = 'Body Sites';          // rpk 10/5/2015
  BodySiteChartList = 'Body Sites Chart'; // rpk 12/9/2015

  AnatomicLocationsMasterImage = 'PSB AL IMAGE GENERAL';
  AnatomicLocationMapList = 'PSB LIST ANATOMIC LOCATIONS';
//  AnatomicLocationMap = 'PSB ANATOMICAL LOCATIONS MAP';
  MapDelimiter = '|';                   // don't forget to change validation logic of
                      // the parameter definition in case delimeter is changed

  pnAnatomicLocationGroupList = 'PSB AL GROUPS'; // parameter name holding AL Group names
  pnAnatomicLocationImageList = 'PSB AL IMAGES'; // parameter name holding AL Image names
  pnAnatomicLocationMasterList = 'PSB AL MASTER LIST'; // parameter name of ALML
//  pnAnatomicLocationMRR = 'PSB AL GROUP MRR'; // parameter name of MRR Group of AL

//  pnAnatomicLocationTransdermal = 'PSB LIST DERMAL SITES'; //
  pnBodySites = 'PSB LIST BODY SITES';

  kwMaster = 'MASTER';
  kwImage = 'IMAGE';
  kwItemSize = 'ITEMSIZE';

function getALGroups(aDivision: string): TStrings;
function getALImages(aDivision: string): TStrings;

function getMasterList(aDivision: string): TStrings;
function SaveMasterList(aDivision: string; aList: TStrings): string;

// Compare inList with MasterList, if an item is in inList and not in
// MasterList, add it to MasterList
// used to keep MasterList in synch with changes to BodySite list
function UpdateMasterList(aDivision: string; inList: TStrings): Boolean;

function saveImage(anImage: TImage; aDivision, anImageName: string): string;

function AnatomicalLocationsToStrings(aList: TListItems): TStringList;

procedure ListViewSetTopItem(ListView: TListView; InIndex: Integer);
procedure GetVisibleItems(var FirstIndex, LastIndex: Integer; LV: TListview);

{ function ShapeByItem(aShape: TShape; aParent: TWinControl;
  anItem: TListItem; anID: Integer): TShape;
function ShapeByItem2(aShape: TShape; aParent: TWinControl;
  anItem: TListItem; anID: Integer): TShape; }
//function PopulateSiteList(inList, outList: TStrings; inType: TSiteType; inSingle: Boolean): Integer;

implementation

uses
  SysUtils
  , BCMA_Util
  , uCAS_UU, fZZ_EventLog
  , Dialogs
  , Controls
//  , MFunStr
  , StrUtils
  , frmALMap
  , CommCtrl
//  , WSDLIntf
  ;

function rpcError(aSL: TStrings): Boolean;
begin
  Result := true;
  if assigned(aSL) then
    if aSL.Text <> '' then
      Result := copy(aSL.Text, 1, 1) = '-';
end;

function getDivisionParameter(aDivision, aParameter: string): TStrings;
var
  SL: TStrings;
begin
//  Result := nil;
  SL := nil;
  if BCMA_Broker.CallServer('PSB PARAMETER',
    ['GETLST', aDivision, aParameter], nil) then
  begin
    SL := BCMA_Broker.Results;
    if rpcError(SL) then
    begin
      addTextEvent('GET PARAMETER ERROR', SL.Text);
    end
    else
      SL.Delete(0);
  end;
  Result := SL;
end;

function getALGroups(aDivision: string): TStrings;
begin
  Result := getDivisionParameter(aDivision, pnAnatomicLocationGroupList);
end;

function getALImages(aDivision: string): TStrings;
begin
  Result := getDivisionParameter(aDivision, pnAnatomicLocationImageList);
end;

// Reminder: getMasterList returns a pointer to broker results
// save the master list to another stringlist prior to the next
// broker call

function getMasterList(aDivision: string): TStrings;
begin
  Result := getDivisionParameter(aDivision, pnAnatomicLocationMasterList);
end;

function saveMasterList(aDivision: string; aList: TStrings): string;
var
  i: integer;
  sError,
    s: string;
begin
  sError := '';
  if aList.Count = 0 then begin
    sError := 'New Master list is empty.  Save is aborted, Old master list is not deleted.';
    ShowMessage(sError);
  end
  else begin
    BCMA_Broker.CallServer('PSB PARAMETER', ['DELLST', aDivision, pnAnatomicLocationMasterList], nil);
    for i := 0 to aList.Count - 1 do
    begin
      s := aList[i];
       // save the Location parameter

      BCMA_Broker.CallServer('PSB PARAMETER',
        ['SETPAR', trim(aDivision), pnAnatomicLocationMasterList, IntToStr(i + 1), s], nil);
        // warn the user if an Item is not saved.

      if piece(BCMA_Broker.Results[0], '^', 1) = '-1' then
        sError := sError +
          'Invalid Parameter [' + IntToStr(i + 1) + '] ' + #13#10 + 'Value [' + s + '] was not saved.' + CRLF;
    end;
  end;
  Result := sError;
  if Result <> '' then
    Result := '-1^' + Result;
end;

function UpdateMasterList(aDivision: string; inList: TStrings): Boolean;
var
  masterSL: TStringList;
  inStr, savStr: string;
  i, idx, midx: Integer;
  bAdd: Boolean;
begin
  Result := False;
  bAdd := False;
  savStr := '?';

  masterSL := TStringList.Create;
  try
    masterSL.Assign(getMasterList(aDivision));
    if masterSL.Count > 0 then begin

      for I := 0 to inList.Count - 1 do begin
        inStr := inList[i];
        inStr := Piece(inStr, MapDelimiter, 1); // name
        inStr := StripString(inStr);
//        inStr := UpperCase(inStr);
        idx := masterSL.IndexOf(inStr);
        if idx < 0 then begin
          midx := masterSL.Add(inStr);
          if midx >= 0 then
            bAdd := True;
        end;
      end;                              // for i

      if bAdd then begin
        masterSL.Sort;
        savStr := SaveMasterList(aDivision, masterSL);
        if savStr = '' then
          Result := True
        else
          ShowMessage('UpdateMasterList: SaveMasterList failed: ' + savStr);
      end;
    end;
  finally
    MasterSL.Free;
  end;

end;                                    // UpdateMasterList

function saveImage(anImage: TImage; aDivision, anImageName: string): string;
var
  memS: TMemoryStream;
  SL: TStringList;
begin
  SL := nil;
  memS := TMemoryStream.Create;
  try
    if anImage.Picture <> nil then
    begin
      TJPEGImage(anImage.Picture.Graphic).SaveToStream(memS);
      memS.Position := 0;

      SL := UUEncodeMemoryStreamToStringList(memS);
      if Assigned(frmALMapEdit) and (frmALMapEdit.ViewMode = mmDebug) then
        SL.savetofile('c:\temp\saveImagepsbalimagegeneral.txt');

      BCMA_Broker.CallServer('PSB GETSETWP',
        ['SETWP', aDivision,
        anImageName,                    //'PSB MAP BACKGROUND',
          '1'], SL);

      if pos('1^WP', BCMA_Broker.Results.Text) = 1 then
//        MessageDlg(ALChartSaveSuccess, mtInformation,[mbOK],0)
        Result := ''
      else
      begin
//        MessageDlg(ALChartSaveFailure, mtError, [mbOK],0)
        Result := '-1^Error saving Image: ' + anImageName + ' for Division: ' + aDivision + '" ' + CRLF +
          piece(BCMA_Broker.Results.Text, '^', 2);
        addTextEvent('Error saving Image', Result);
      end;
    end;
  finally
    memS.Free;
    if SL <> nil then
      SL.Free;
  end;
end;                                    // SaveImage

{ function ShapeByItem(aShape: TShape; aParent: TWinControl;
  anItem: TListItem; anID: Integer): TShape;
const
  idxID = 0;
  idxX = 1;
  idxY = 2;
  idxMax = 3;                           // count of subitems
var
  shp: TShape;
  li: TListItem;
  X, Y, icnt: Integer;
begin
  Result := nil;
  li := anItem;
  icnt := li.subitems.Count;
  // icnt = 4, idxX = 3 is OK
  // icnt = 3, idxX = 3 is out of bounds
  if (icnt <= idxX) or (icnt <= idxY) then
    exit;
  if trim(li.SubItems[idxX]) = '' then
    exit;
  if trim(li.SubItems[idxY]) = '' then
    exit;
  if trim(li.SubItems[idxX]) = '0' then
    exit;
  if trim(li.SubItems[idxY]) = '0' then
    exit;

  li.StateIndex := idxCoordinates;

  X := round(StrToInt(li.SubItems[idxX]) * ScaleX);
  Y := round(StrToInt(li.SubItems[idxY]) * ScaleY);
  shp := aShape;
  if shp = nil then
    shp := newShape(aParent, X, Y)
  else
  begin
    shp.Parent := aParent;
    shp.Left := X;
    shp.Top := Y;
  end;
  shp.OnMouseDown := shpCircleMouseDown;
  shp.OnMouseUp := shpCircleMouseUp;
  shp.BringToFront;
  shp.tag := anID;
  shp.Hint := anItem.Caption;

  case ViewMode of
    mmView: ;
  else
    shp.Hint := shp.Hint
      + #13#10
      + Format('X: %s, Y:%s', [li.SubItems[idxX], li.SubItems[idxY]]) + #13#10
      + Format('ID: %s', [li.SubItems[idxID]]);
    ;
  end;

  shp.ShowHint := True;
  Result := shp;
end;

function ShapeByItem2(aShape: TShape; aParent: TWinControl;
  anItem: TListItem; anID: Integer): TShape;
var
  shp: TShape;
  li: TListItem;
  X, Y, icnt: Integer;
begin
  Result := nil;
  li := anItem;
  icnt := li.subitems.Count;
  if (icnt <= idxX) or (icnt <= idxY) then
    exit;
  if trim(li.SubItems[idxX]) = '' then
    exit;
  if trim(li.SubItems[idxY]) = '' then
    exit;
  if trim(li.SubItems[idxX]) = '0' then
    exit;
  if trim(li.SubItems[idxY]) = '0' then
    exit;

  li.StateIndex := idxCoordinates;

  X := round(StrToInt(li.SubItems[idxX]) * ScaleX);
  Y := round(StrToInt(li.SubItems[idxY]) * ScaleY);
  shp := aShape;
  if shp = nil then
    shp := newShape(aParent, X, Y)
  else
  begin
    shp.Parent := aParent;
    shp.Left := X;
    shp.Top := Y;
  end;
  shp.OnMouseDown := shpCircleMouseDown;
  shp.OnMouseUp := shpCircleMouseUp;
  shp.BringToFront;
  shp.tag := anID;
  shp.Hint := anItem.Caption;

  case ViewMode of
    mmView: ;
  else
    shp.Hint := shp.Hint
      + #13#10
      + Format('X: %s, Y:%s', [li.SubItems[idxX], li.SubItems[idxY]]) + #13#10
      + Format('ID: %s', [li.SubItems[idxID]]);
    ;
  end;

  shp.ShowHint := True;
  Result := shp;
end; }


function AnatomicalLocationsToStrings(aList: TListItems): TStringList;
var
  i: Integer;
  s: string;
begin
  Result := TStringList.Create;
  for i := 0 to aList.Count - 1 do begin
    if Trim(aList[i].Caption) > '' then begin
//      Result.Add(LocationItemToString(IntToStr(i + 1), aList[i]));
      s := LocationItemToString(IntToStr(i + 1), aList[i]);
      Result.Add(s);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
// TALItem
//

constructor TALItem.newALItem(aLine: string);
var
  s: string;
begin
  inherited Create;
//  ID := StrToIntDef(piece(aLine, MapDelimiter, 1), 0);
  s := piece(aLine, MapDelimiter, 1);
//  ID := StrToIntDef(s, 0);
//  if ID > 0 then begin
  if TryStrToInt(s, ID) then begin
    Caption := piece(aLine, MapDelimiter, 2);
    setByString(aLine);
  end
  else begin
    ID := StrToIntDef(piece(aLine, MapDelimiter, 4), 0);
    Caption := Piece(aLine, MapDelimiter, 1);
    setByString2(aLine);
  end;
end;

procedure TALItem.setByString(aLine: string);
begin
  X := StrToIntDef(piece(aLine, MapDelimiter, 3), 0);
  Y := StrToIntDef(piece(aLine, MapDelimiter, 4), 0);
end;

procedure TALItem.setByString2(aLine: string);
begin
  InjectionFlag := StrToIntDef(Piece(ALine, MapDelimiter, 2), 0);
  DermalFlag := StrToIntDef(Piece(ALine, MapDelimiter, 3), 0);
  X := StrToIntDef(piece(aLine, MapDelimiter, 5), 0);
  Y := StrToIntDef(piece(aLine, MapDelimiter, 6), 0);
end;

function TALItem.toString: string;
begin
  { Result :=
    IntToStr(ID) + MapDelimiter +
    Caption + MapDelimiter +
    IntToStr(X) + MapDelimiter +
    IntToStr(Y); }

  Result :=
    Caption + MapDelimiter +
    IntToStr(InjectionFlag) + MapDelimiter +
    IntToStr(DermalFlag) + MapDelimiter +
    IntToStr(ID) + MapDelimiter +
    IntToStr(X) + MapDelimiter +
    IntToStr(Y);

end;

////////////////////////////////////////////////////////////////////////////////
//
//TALGroup
//

constructor TALGroup.newALGroup;
begin
  inherited Create;
  LocationItems := TStringList.Create;
end;

destructor TALGroup.Destroy;
begin
  while LocationItems.Count > 0 do
  begin
    if LocationItems.Objects[0] <> nil then begin
      LocationItems.Objects[0].Free;
//        LocationItems.Objects[0] := nil;
    end;
    LocationItems.Delete(0);
  end;
  LocationItems.Free;
  inherited destroy;
end;

procedure TALGroup.Load(aDivision: string);
var
  s: string;
  i: Integer;
  LItem: TALItem;
begin
  fDivision := aDivision;
  if BCMA_Broker.CallServer('PSB PARAMETER', ['GETLST', aDivision, GroupName], nil) then
  begin
//      if MessageDLG('Loading Group:"'+GroupName+'" Division: "'+aDivision+'"'+
//        CRLF+CRLF + BCMA_Broker.Results.Text,mtConfirmation,[mbOK,mbCancel],0) = mrOK then
//    begin
    for i := 1 to BCMA_Broker.Results.Count - 1 do // 0 line contains counter
    begin
      s := piece(BCMA_Broker.Results[i], MapDelimiter, 1);
      if s = kwMaster then
        MasterName := piece(BCMA_Broker.Results[i], MapDelimiter, 2)
      else if s = kwImage then
        ImageName := piece(BCMA_Broker.Results[i], MapDelimiter, 2)
      else
      begin
        s := BCMA_Broker.Results[i];
        LItem := TALItem.newALItem(BCMA_Broker.Results[i]);
        LocationItems.AddObject(LItem.Caption, LItem);
      end;
    end;
    s := toString;
//    end;
  end
  else
  begin
    if piece(BCMA_Broker.Results[0], '^', 1) = '-1' then begin
      s := 'Group [' + GroupName + '] was not Loaded.' + CRLF + BCMA_Broker.Results.Text;
      ShowMessage(s);
    end;
  end;
  s := 'Loading AL GROUP "' + GroupName + '" Division "' + aDivision + '"' + CRLF + s;
  addTextEvent('AL GROUP LOAD', s);

end;                                    // Load

procedure TALGroup.Save(aDivision: string);
var
  i: Integer;
  sError,
    s: string;
  alItem: TALItem;
begin
  if Assigned(frmALMapEdit) and (frmALMapEdit.ViewMode = mmDebug) then
    if MessageDLG(toString, mtConfirmation, [mbOK, mbCancel], 0) <> mrOK then
      exit;

  BCMA_Broker.CallServer('PSB PARAMETER', ['DELLST', aDivision, GroupName], nil);
  BCMA_Broker.CallServer('PSB PARAMETER',
    ['SETPAR', trim(aDivision), GroupName, kwMaster, kwMaster + MapDelimiter + MasterName], nil);
  BCMA_Broker.CallServer('PSB PARAMETER',
    ['SETPAR', trim(aDivision), GroupName, kwImage, kwImage + MapDelimiter + ImageName], nil);

  for i := 0 to LocationItems.Count - 1 do
  begin
    alItem := TALItem(LocationItems.Objects[i]);
    if alItem = nil then
      continue;
    if Trim(alItem.Caption) = '' then
      continue;
    // reset the ID to the order of the item in the list?
    alItem.ID := i + 1;
    // save the Location parameter
    s := alItem.toString;
    BCMA_Broker.CallServer('PSB PARAMETER',
      ['SETPAR', trim(aDivision), GroupName, IntToStr(i + 1), s], nil);
      // warn the user if an Item is not saved.

    if piece(BCMA_Broker.Results[0], '^', 1) = '-1' then
      sError := sError + 'Invalid Parameter [' + IntToStr(i + 1) +
        '] ' + #13#10 + 'Value [' + s + '] was not saved.' + CRLF;
  end;

  sError := 'Saving AL GROUP "' + GroupName + '" Division "' + aDivision + '"' + CRLF + sError;
  addTextEvent('AL GROUP SAVE', sError);

end;                                    // Save

function TALGroup.toString: string;
var
  SL: TStringList;
  s, capstr: string;
  i: integer;
  alItem: TALItem;
const
  fmt = '%-40s: %s';
begin
  SL := TStringList.Create;
  SL.Add(Format(fmt, ['Group', GroupName]));
  SL.Add(Format(fmt, ['Image', ImageName]));

  for i := 0 to LocationItems.Count - 1 do
    if assigned(LocationItems.Objects[i]) then begin
//      SL.Add(format(fmt, [intTostr(I + 1), TALItem(LocationItems.Objects[i]).toString]));
      alItem := TALItem(LocationItems.Objects[i]);
      capstr := Trim(alItem.Caption);
      if capstr > '' then begin
        s := alItem.toString;
        SL.Add(format(fmt, [intTostr(I + 1), s]));
      end;
    end;
  Result := SL.Text;
  SL.Free;
end;                                    // toString

procedure TALGroup.setByCheckList(aList: TCheckListBox);
var
  b: Boolean;
  s: string;
  indx,
    i: integer;
  LItem: TALItem;
begin
  for I := 0 to aList.Count - 1 do
  begin
    s := aList.Items[i];
    b := aList.Checked[i];
    indx := LocationItems.IndexOf(s);
    if b then
    begin
      if indx < 0 then
      begin
        LItem := TALItem.newALItem(intToStr(i) + MapDelimiter + s + MapDelimiter);
        LocationItems.AddObject(s, LItem);
        addTextEvent('AL ITEM Add', 'Item added: "' + LItem.toString + '"');
      end
      else
      begin
        LItem := TALItem(LocationItems.Objects[indx]);
        if LItem <> nil then
          addTextEvent('AL ITEM Add', 'Item Found: "' + LItem.toString + '"')
        else
          addTextEvent('ERROR: AL ITEM Add', 'Nil Item Found: "' + s + '"')

      end;
    end
    else
    begin                               // not checked
      if indx >= 0 then
      begin
        LItem := TALItem(LocationItems.Objects[indx]);
        s := LocationItems[indx];
        if Assigned(LItem) then
        begin
          s := LItem.toString;
          LItem.Free;
          LocationItems.Delete(indx);
          addTextEvent('AL ITEM Delete', 'Item deleted: "' + s + '"');
        end
        else
          addTextEvent('ERROR: AL ITEM Delete', 'Not found Item to delete: "' + s + '"');
      end;
    end;
  end;
end;                                    // setByCheckList

function TALGroup.LocItemsToSL: TStringList;
var
  i: integer;
  SL: TSTringList;
  s: string;
  alItem: TALItem;
begin
  SL := TStringList.Create;
  if SL <> nil then
    for I := 0 to LocationItems.Count - 1 do begin
//    if TALItem(LocationItems.Objects[i]) <> nil then begin
      alItem := TALItem(LocationItems.Objects[i]);
      if (alItem <> nil) and (Trim(alItem.Caption) > '') then begin
//      SL.Add(TALItem(LocationItems.Objects[i]).toString)
        s := alItem.toString;
        SL.Add(s);
      end                               // if
      else
        addTextEvent('AL no Data', 'AL Group: "' + GroupName + '" Item: "' + IntToStr(i) + '"');
    end;                                // for
  Result := SL;
end;                                    // LocItemsToSL

function TALGroup.setByList(aList: TStringList): Integer;
var
  i: integer;
//  SL: TSTringList;
  s: string;
  alItem: TALItem;
//  indx: Integer;
begin
  Result := 0;
//  if aList.Count > 0 then begin
  if aList.Count >= 0 then begin
    self.ClearItems;
    for I := 0 to aList.Count - 1 do
    begin
      s := piece(aList[i], MapDelimiter, 1); // name
      if StripString(s) > '' then begin
        aLItem := TALItem.newALItem(aList[i]);
        LocationItems.AddObject(aLItem.Caption, aLItem);
      end
    end;
    Result := LocationItems.Count;
  end;
end;                                    // setByList

{ procedure TALGroup.restoreFromBackup(aList: TStringList);
var
  s: String;
  indx,
    i: integer;
  LItem: TALItem;
begin
//  for I := 0 to LocationItems.Count - 1 do
  for I := 0 to aList.Count - 1 do
  begin
//    s := piece(aList[i], MapDelimiter, 2);
    s := piece(aList[i], MapDelimiter, 1); // name
    indx := LocationItems.IndexOf(s);
    if indx < 0 then
//      addTextEvent('AL Item Not Found', 'Item: "' + s + '"')
    begin
      LItem := TALItem.newALItem(aList[i]);
      LocationItems.AddObject(LItem.Caption, LItem);
    end
    else if LocationItems.Objects[indx] = nil then
      addTextEvent('AL Item No Data Found', 'Item: "' + s + '"')
    else
      TALItem(LocationItems.Objects[indx]).setByString2(aList[i]);
  end;
end; }

procedure TALGroup.setDivision(aDivision: string);
begin
  if (fDivision <> aDivision) then
  begin
    fDivision := aDivision;
    Load(fDivision);
  end;
end;

function TALGroup.ItemByName(aName: string): TALItem;
var
  i: Integer;
begin
  Result := nil;
  i := LocationItems.IndexOf(aName);
  if i >= 0 then
    Result := TALItem(LocationItems.Objects[i]);

end;

procedure TALGroup.ClearItems;
var
  anItem: TALItem;
begin
  while LocationItems.Count > 0 do
  begin
    anItem := TALItem(LocationItems.Objects[0]);
    if anItem <> nil then begin
      anItem.Free;
//        LocationItems.Objects[0] := nil;
    end;
    LocationItems.Delete(0);
  end;
  LocationItems.Clear;
end;

////////////////////////////////////////////////////////////////////////////////
//
// TALGroupList
//

constructor TALGroupList.newALGroupList;
begin
  inherited Create;
  GroupItems := TStringList.Create;
end;

destructor TALGroupList.Destroy;
begin
  Clear;
  GroupItems.Free;
  inherited destroy;
end;

procedure TALGroupList.Clear;
begin
  while GroupItems.Count > 0 do
  begin
    if GroupItems.Objects[0] <> nil then
      GroupItems.Objects[0].Free;
    GroupItems.Delete(0);
  end;
end;

procedure TALGroupList.ReLoad;
begin
  if ItemsName = '' then
    exit;
  if Division = '' then
    exit;

  BCMA_Broker.CallServer('PSB PARAMETER', ['GETLST', Division, ItemsName], nil);
  GroupItems.Assign(BCMA_Broker.Results);
  if GroupItems.Count > 0 then
    GroupItems.Delete(0);
end;

procedure TALGroupList.setDivision(aDivision: string);
begin
  fDivision := aDivision;
  Clear;
  ReLoad;
end;

procedure TALGroupList.setItemsName(aName: string);
begin
  fItemsName := aName;
  Clear;
  ReLoad;
end;

{ function TALGroupList.getListMaster(aList: string): String;
var
  i: integer;
begin
  i := GroupItems.IndexOf(aList);
  if i >= 0 then
    Result := GroupItems[i]
  else
    Result := '';
end; }

{ function PopulateSiteList(inList, outList: TStrings; inType: TSiteType; inSingle: Boolean): Integer;
var
  i, j: Integer;
  s: String;
begin
  j := 0;
  if assigned(inList) and assigned(outList) then begin
    outList.Clear;
    case inType of
      stInjection: begin
          for I := 0 to inList.Count - 1 do begin
            if isInjectionSite(inList[i]) then begin
//              outList.Add(GetSite(inList[i]));
              if inSingle then
                s := GetSite(inList[i])
              else
                s := inList[i];
              outList.Add(s);
              inc(j);
            end;
          end;
        end;                            // stInjection
      stDermal: begin
          for I := 0 to inList.Count - 1 do begin
            if isDermalSite(inList[i]) then begin
//              outList.Add(GetSite(inList[i]));
              if inSingle then
                s := GetSite(inList[i])
              else
                s := inList[i];
              outList.Add(s);
              inc(j);
            end;
          end;
        end;                            // stDermal
    end;                                // case
  end;                                  // if assigned
  Result := j;
                                  end; }// PopulateSiteList

// based on http://www.delphigroups.info/2/56/308446.html

procedure ListViewSetTopItem(ListView: TListView; InIndex: Integer);
const
  SPropertyOutOfRange = 'Property %s out of range.';
var
  Difference, ItemHeight: Integer;
begin
  if not (ListView.ViewStyle = vsReport) then
    Exit;
  if (InIndex < 0) or (ListView.Items.Count = 0) or
    (InIndex > ListView.Items.Count - 1) then
    raise EInvalidOperation.CreateFmt(SPropertyOutOfRange, ['TopItem']);
  with ListView do
  begin
//    Difference := TopItem.Index - Items.Item[ItemIndex].Index;
    Difference := TopItem.Index - InIndex;
    with Items.Item[0].DisplayRect(drBounds) do
      ItemHeight := Top - Bottom;
    Scroll(0, Difference * ItemHeight);
  end;
end;                                    // ListViewSetTopItem

// from http://ic0de.org/archive/index.php/t-11792.html

procedure GetVisibleItems(var FirstIndex, LastIndex: Integer; LV: TListview);
 {Listview MUST be in report or list viewstyle}
var
  vrc: Integer;                         {Visible Row Count}
begin
  if LV.Items.Count = 0 then
  begin
    LastIndex := LV.Items.Count;
    FirstIndex := LV.Items.Count;
    Exit;
  end;

  vrc := LV.VisibleRowCount;
  FirstIndex := LV.TopItem.Index;

 {Base}
  if LV.TopItem.Index = 0 then
  begin
    LastIndex := vrc - 1;
  end else
 {Top}
    if LV.TopItem.Index <= vrc then
    begin
      LastIndex := (vrc + LV.TopItem.Index) - 1;
    end else
 {Middle}
      if LV.TopItem.Index >= vrc then
      begin
        LastIndex := (LV.TopItem.Index + vrc) - 1;
      end else
 {Bottom}
        if LV.TopItem.Index + vrc >= LV.Items.Count then
        begin
          LastIndex := LV.Items.Count - 1;
        end;

end;                                    // GetVisibleItems

end.

