unit frmALMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, jpeg, ActnList, StdActns,
  ToolWin, ActnMan, ActnCtrls, XPStyleActnCtrls, IdCoder, IdCoder3to4,
  IdCoder00E, IdCoderUUE, IdBaseComponent
  , ImgList
  , uCAS_ALUtils
  , Menus
  ;

type
  TMapViewMode = (mmView, mmEdit, mmSelect, mmDebug,
    mmSelectDermal, mmSelectInjection, mmSave);

  TfrmALMapEdit = class(TForm)
    pnlDialog: TPanel;
    pnlChartLocations: TPanel;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    pnlChart: TPanel;
    pnlBodyChart: TPanel;
    imgBody: TImage;
    pnlLocations: TPanel;
    lvWork: TListView;
    pnlSizeScale: TPanel;
    lblScale: TLabel;
    lblScaleXY: TLabel;
    lblSize: TLabel;
    splMap: TSplitter;
    amALMap: TActionManager;
    FileOpen1: TFileOpen;
    acMapClear: TAction;
    acSaveChartToVistA: TAction;
    acAddItem: TAction;
    acDeleteItem: TAction;
    acEditItem: TAction;
    pnlSelect: TPanel;
    acMode: TAction;
    acRestore: TAction;
    lblPosition: TLabel;
    ImageList1: TImageList;
    acLoadImageFromVistA: TAction;
    acErase: TAction;
    pnlImageToolBar: TPanel;
    pnlItemsToolBar: TPanel;
    tlbItemList: TToolBar;
    tbAddItem: TToolButton;
    tbDeleteItem: TToolButton;
    tbEditItem: TToolButton;
    pnlImgEdit: TPanel;
    pnlLocEdit: TPanel;
    tlbImage: TToolBar;
    tbEraseImage: TToolButton;
    tbFileOpenImage: TToolButton;
    tbLoadImageFromVista: TToolButton;
    tbSaveChartToVista: TToolButton;
    tlbLocEdit: TToolBar;
    tbMapClear: TToolButton;
    tbRestoreMap: TToolButton;
    acMapSaveToVistA: TAction;
    tbSaveToVista: TToolButton;
    pnlImage: TPanel;
    edImage: TEdit;
    lblItems: TLabel;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Rename1: TMenuItem;
    Delete1: TMenuItem;
    tbSaveBodySites: TToolButton;
    procedure imgBodyMouseEnter(Sender: TObject);
    procedure imgBodyMouseLeave(Sender: TObject);
    procedure imgBodyMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
//    procedure edSizeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure imgBodyDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure imgBodyDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvWorkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvWorkChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure FileOpen1Accept(Sender: TObject);
    procedure acAddItemExecute(Sender: TObject);
    procedure acClearMapExecute(Sender: TObject);
    procedure acModeExecute(Sender: TObject);
    procedure pnlSelectDblClick(Sender: TObject);
    procedure acRestoreExecute(Sender: TObject);
//    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acDeleteItemExecute(Sender: TObject);
    procedure acEditItemExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgBodyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvWorkCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure acSaveChartToVistAExecute(Sender: TObject);
    procedure acLoadImageFromVistAExecute(Sender: TObject);
    procedure acEraseExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
//    procedure cmbALImagesChange(Sender: TObject);
    procedure acMapSaveToVistAExecute(Sender: TObject);
    function ShapeByItem(aShape: TShape; aParent: TWinControl; anItem: TListItem;
      anID: Integer): TShape;
    function ShapeByItem2(aShape: TShape; aParent: TWinControl; anItem: TListItem;
      anID: Integer): TShape;
  private
    { Private declarations }
    fBackup: TStringList;
    fViewMode: TMapViewMode;
    fChangeCount: Integer;
    fGroup: string;
    fDivision: string;


    procedure setMapViewMode(aMode: TMapViewMode);
    function newShape(anOwner: TComponent; x, y: Integer): TShape;

    procedure shpCircleMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure shpCircleMouseLeave(Sender: TObject);
    procedure shpCircleMouseEnter(Sender: TObject);
    procedure shpCircleMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

//    function getItemName: String;
//    procedure RestoreFromBackup;
    { function ShapeByItem(aShape: TShape; aParent: TWinControl; anItem: TListItem;
      anID: Integer): TShape;
    function ShapeByItem2(aShape: TShape; aParent: TWinControl; anItem: TListItem;
      anID: Integer): TShape; }
    procedure setDivisionLoadImage(aDivision: string);
    procedure setGroup(aGroup: string);


  public
    { Public declarations }
    SizeX,
      SizeY: Integer;
    ScaleX,
      ScaleY: Double;
    MasterList: string;

    // bparLvwDefAnswer is used as a run-time pointer to BCMAParameters.LvwDefAnswer listview
    // or frmALMap.lvWork
    // It is checked in shpCircleMouseDown to select the corresponding listview entry
    // for the dot that is clicked on the frmALView body chart.
    // This pointer is used to avoid build conflicts between BCMA and BCMA Parameters
    // projects.
    bparLvwDefAnswer: TListView;

    property Backup: TStringList read fBackup write fBackup;
    property ChangeCount: Integer read fChangeCount;
//    property Division: String read fDivision write setDivision;
    property Division: string read fDivision write setDivisionLoadImage;
    property Group: string read fGroup write setGroup;
    property ViewMode: TmapViewMode read fViewMode write setMapViewMode;

//    procedure setByListItems(aList: TListItems); overload;
//    procedure setByList(aList: TStringList); overload;
    procedure setByList(aList: TStringList);
//    procedure setByList(aList: TStringList; aParent: TWinControl);
//    procedure setByALList(aList: TStringList);
    procedure setByALList(aList: TStringList; aParent: TWinControl);
    procedure setDimensions;
    procedure LocationsRefresh;
//    procedure LocationsRefresh(aParent: TWinControl);
//    procedure setDivisionData;
    procedure setDivision(aDivision: string);
    procedure setDivisionData(aGroupName: string);
//    procedure GetImageFromVistA(aName: string);
    function GetImageFromVistA(aName: string): Boolean;
  end;

var
  frmALMapEdit: TfrmALMapEdit;

const
  UM_ALSETUP = WM_USER + 500;           // used to setup AL forms

  clAL_New = clMoneyGreen;
  clAL_Selected = clGreen;
  clAL_MouseOver = clBlue;
  clAL_MouseDown = clRed;
  clAL_MouseEnter = clBlue;
  clAL_MouseLeave = clMoneyGreen;

  clCoordinates = clCream;
  clNoCoordinates = clMoneyGreen;
  idxCoordinates = 8;
  idxNoCoordinates = -1;

  fmtSize = 'Size %d X %d';

  ALChartSaveSuccess = 'Background Image was saved in VistA';
  ALChartSaveFailure = 'Background Image was NOT saved!';
  ALChartLoadFailure = 'Background Image was NOT Loaded!';

  // idb - 'piece' position in a line of Backup
  idbName = 2;
  idbID = 1;
  idbX = 3;
  idbY = 4;

  idbInjection = 5;
  idbDermal = 6;

  // idx - SubItems Indexes

  { idxID = 0;
  idxX = 1;
  idxY = 2;
  idxMax = 3; }// count of subitems

//  idxName = 0;
  idxInjection = 0;
  idxDermal = 1;
  idxID = 2;
  idxX = 3;
  idxY = 4;
  idxMax = 5;                           // count of subitems

procedure setFormParented(aForm: TForm; aParent: TWinControl; anAlign: TAlign = alClient);

function newLocationMap(aMode: TMapViewMode; aDivision: string): TfrmALMapEdit;
function LocationMapEdit(aList: TStringList; aDivision, aGroup, aMaster, anImage: string): Integer;

function removeShapes(aList: TListItems; bClear: Boolean = true): Integer;
// function removeShapesData(aList: TListItems): Integer;
function countShapes(aList: TListItems): Integer;

//procedure AnatomicalLocationsFromStrings(aList:TListItems;aSource:TStrings;
//  bCreateShapes:Boolean = false);
function LocationItemToString(anID: string; anItem: TListItem): string;
//function AnatomicalLocationsToStrings(aList: TListItems): TStringList;

// SelectAnatomicalLocation moved to BCMA_Common.
//function SelectAnatomicalLocation(aDivision: String): String;
//function SelectAnatomicalLocation(aDivision, aGroupName: String): String;
//function SelectAnatomicalLocation(aDivision, aGroupName: String; inSite: TSiteType): String;

procedure ToggleV(aControl: TControl);

implementation

uses
  BCMA_Util, InputQry, BCMA_Startup, uCAS_UU, StrUtils,
//MFunStr,
//BCMAParameters,
  fZZ_EventLog
{$IFNDEF CAS_DDPE_MAPEDIT}
//, uCAS_Utils
{$ENDIF}
  ;

{$R *.dfm}

const
  itemwidth = 260;
  injwidth = 90;
  dermwidth = 80;

procedure ToggleV(aControl: TControl);
begin
  aControl.Visible := not aControl.Visible;
end;

//procedure setFormParented;

procedure setFormParented(aForm: TForm; aParent: TWinControl; anAlign: TAlign = alClient);
begin
  if aForm.Parent <> aParent then
  begin
    aForm.BorderStyle := bsNone;
    aForm.Parent := aParent;
    aForm.Align := anAlign;
    aForm.Menu := nil;
    aForm.Show;
  end;
end;

(*
procedure AnatomicalLocationsFromStrings(aList:TListItems;aSource:TStrings;
  bCreateShapes:Boolean = false);
var
  i: integer;

  procedure setItemMapInfo(aValue:String);
  var
    s,ss: String;
    iLimit,
    ii,
    idx: Integer;
    li: TListItem;
  begin
    iLimit := 0;
    idx := 0;
    while idx < Length(aValue) do
      begin
        if aValue[idx+1]=MapDelimeter then
          inc(iLimit);
        inc(idx);
      end;

    idx := 2;
    s := piece(aValue,MapDelimeter,idx);
    ii := StrToIntDef(s,0);
    if ii > aList.Count then
      exit;
    li := aList[ii-1];

    while li.SubItems.Count < iLimit do
      li.SubItems.Add('');
    for idx := 0 to li.SubItems.Count - 1 do
      begin
        ss := piece(aValue,MapDelimeter,idx+3);
        li.SubItems[idx] := ss;
      end;

    if bCreateShapes and (li.SubItems[idxX]<>'') and (li.SubItems[idxY]<>'') then
      li.Data := TShape.Create(nil);
  end;

begin
  for i := 1 to aSource.Count - 1 do // item 0 contains counter of lines
    setItemMapInfo(aSource[i]);
end;
*)

function LocationItemToString(anID: string; anItem: TListItem): string;
var
  s: string;
begin
  s := '';
  if anItem = nil then
    exit;
  if Trim(anItem.Caption) > '' then begin
    { Result := anID + MapDelimiter + anItem.Caption;
    if not assigned(anItem.SubItems) then
      exit;
    if anItem.SubItems.Count < idxX + 1 then
      exit;
    Result := Result + MapDelimiter + trim(anItem.SubItems[idxX]);
    if anItem.SubItems.Count < idxY + 1 then
      exit;
    Result := Result + MapDelimiter + trim(anItem.SubItems[idxY]); }

    Result := anItem.Caption;
    if not assigned(anItem.SubItems) then
      exit;

    if anItem.SubItems.Count <= idxInjection then
      exit;
    s := anItem.SubItems[idxInjection];
    Result := Result + MapDelimiter + IfThen(s = 'Y', '1', '0');

    if anItem.SubItems.Count <= idxDermal then
      exit;
    s := anItem.SubItems[idxDermal];
    Result := Result + MapDelimiter + IfThen(s = 'Y', '1', '0');

//    if anItem.SubItems.Count < idxID + 1 then
//      exit;
//    Result := Result + MapDelimiter + trim(anItem.SubItems[idxID]);
    Result := Result + MapDelimiter + trim(anID);

    if anItem.SubItems.Count < idxX + 1 then
      exit;
    Result := Result + MapDelimiter + trim(anItem.SubItems[idxX]);

    if anItem.SubItems.Count < idxY + 1 then
      exit;
    Result := Result + MapDelimiter + trim(anItem.SubItems[idxY]);

  end
  else
    Result := '';
end;


{ function AnatomicalLocationsToStrings(aList: TListItems): TStringList;
var
  i: Integer;
  s: String;
begin
  Result := TStringList.Create;
  for i := 0 to aList.Count - 1 do begin
    if Trim(aList[i].Caption) > '' then begin
//      Result.Add(LocationItemToString(IntToStr(i + 1), aList[i]));
      s := LocationItemToString(IntToStr(i + 1), aList[i]);
      Result.Add(s);
    end;
  end;
end; }

function newLocationMap(aMode: TMapViewMode; aDivision: string): TfrmALMapEdit;
begin
  Application.CreateForm(TfrmALMapEdit, Result);
  if Assigned(Result) then begin
    Result.edImage.Text := AnatomicLocationsMasterImage;
    // if mmEdit or mmSave, we don't want to load the background body image from vista
    // in both, we set fDivision here to avoid triggering the loadimage in SetDivision
    // in mmSave, we are doing a forced save to vista of the background body image loaded at design-time
    // this will keep the image at the site up-to-date if there are any changes in
    // the released build.
    if (aMode = mmEdit) or (aMode = mmSave) then begin
      Result.fDivision := aDivision;
      if aMode = mmSave then
        Result.acSaveChartToVista.Execute;
    end
    else
      Result.Division := aDivision;
    Result.ViewMode := aMode;
  end;
end;

function LocationMapEdit(aList: TStringList; aDivision, aGroup, aMaster, anImage: string): Integer;
begin
  Result := 0;

  if not assigned(frmALMapEdit) then
    frmALMapEdit := newLocationMap(mmEdit, aDivision);

  frmALMapEdit.Group := aGroup;
  frmALMapEdit.MasterList := aMaster;
  frmALMapEdit.edImage.Text := anImage;

  frmALMapEdit.Backup.Assign(aList);
  frmALMapEdit.setByList(aList);

  // set view mode to edit here after list has been loaded.
  // setViewMode needs a non-empty list in order to set column widths
  frmALMapEdit.ViewMode := mmEdit;      // rpk 9/12/2016

  if assigned(frmALMapEdit) then
    frmALMapEdit.bparLvwDefAnswer := frmALMapEdit.lvWork;

  if frmALMapEdit.ShowModal = mrOK then begin
    Result := frmALMapEdit.ChangeCount;
  end;
end;                                    // LocationMapEdit

function removeShapes(aList: TListItems; bClear: Boolean = true): Integer;
var
  li: TListItem;
  i, j: integer;
  shp: TShape;
begin
  Result := 0;
  for i := 0 to aList.Count - 1 do
  begin
    li := aList[i];
    if assigned(li.Data) then
    begin
      shp := TShape(li.data);
      shp.Parent := nil;
      if bClear then
        freeandnil(shp);
      li.Data := nil;
      for j := 0 to li.SubItems.Count - 1 do
        li.SubItems[j] := '';
      li.StateIndex := idxNoCoordinates;
      Inc(Result);
    end;
  end;
end;

{ function removeShapesData(aList: TListItems): Integer;
var
  li: TListItem;
  i: integer;
begin
  Result := 0;
  for i := 0 to aList.Count - 1 do
  begin
    li := aList[i];
    if assigned(li.Data) then
    begin
      TShape(li.Data).Parent := nil;
      li.Data := nil;
      Inc(Result);
    end;
  end;
end; }

function countShapes(aList: TListItems): Integer;
var
  li: TListItem;
  i: integer;
begin
  Result := 0;
  for i := 0 to aList.Count - 1 do
  begin
    li := aList[i];
    if assigned(li.Data) then
      Inc(Result);
  end;
end;

//function SelectAnatomicalLocation(aDivision: String): String;

//function SelectAnatomicalLocation(aDivision, aGroupName: String): String;
{ function SelectAnatomicalLocation(aDivision, aGroupName: String; inSite: TSiteType): String;
var
  icnt: Integer;
  selectionList: TStringList;
begin
  Result := '';
  selectionList := TStringList.Create;
  try
    if not Assigned(frmALMapEdit) then
      frmALMapEdit := newLocationMap(mmSelect, aDivision);

    frmALMapEdit.Division := aDivision;
    frmALMapEdit.ViewMode := mmSelect;
  //  frmALMapEdit.setDivisionData;
  //  frmALMapEdit.setDivisionData(aGroupName);
    if aGroupName = '' then
      aGroupName := AnatomicLocationMapList;
    if BCMA_Broker.CallServer('PSB PARAMETER',
      ['GETLST', aDivision, aGroupName], nil) then begin

      selectionList.Assign(BCMA_Broker.Results);
      if selectionList.Count > 0 then
        selectionList.Delete(0);

      icnt := PopulateSiteList(selectionList, frmALMapEdit.Backup, inSite, False);
    end;
  finally
    selectionList.Free;
  end;
//  Backup.Assign(BCMA_Broker.Results);
//  if frmALMapEdit.Backup.Count > 0 then
//    frmALMapEdit.Backup.Delete(0);
  frmALMapEdit.setByList(frmALMapEdit.Backup);

  if frmALMapEdit.ShowModal = mrOK then
    Result := frmALMapEdit.lvWork.Selected.Caption;
  FreeAndNil(frmALMapEdit);
end; }



////////////////////////////////////////////////////////////////////////////////

function TfrmALMapEdit.ShapeByItem(aShape: TShape; aParent: TWinControl;
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
end;                                    // ShapeByItem

function TfrmALMapEdit.ShapeByItem2(aShape: TShape; aParent: TWinControl;
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
end;                                    // ShapeByItem2

procedure TfrmALMapEdit.LocationsRefresh;
//procedure TfrmALMapEdit.LocationsRefresh(aParent: TWinControl);
var
  li: TListItem;
  i: integer;
  shp: TShape;

  procedure AdjustShapePosition(aShape: TShape; anX, anY: string);
  var
    X, Y: Integer;
  begin
    X := round(StrToInt(anX) * ScaleX);
    Y := round(StrToInt(anY) * ScaleY);
    aShape.Left := X;
    aShape.Top := Y;
    aShape.BringToFront;
  end;

begin
  fChangeCount := 0;
  setDimensions;

  for i := 0 to lvWork.Items.Count - 1 do
  begin
    li := lvWork.Items[i];
    if assigned(li.data) then
    begin
      shp := TShape(li.Data);
      shp.Tag := i;
      AdjustShapePosition(shp, li.SubItems[idxX], li.SubItems[idxY]);
    end
    else
    begin
//      shp := ShapeByItem(nil, pnlBodyChart, li, i);
      shp := ShapeByItem2(nil, pnlBodyChart, li, i);
//      shp := ShapeByItem2(nil, aParent, li, i);
      if shp <> nil then
        li.Data := shp;
    end;
  end;
end;                                    // LocationsRefresh

{ procedure TfrmALMapEdit.setByListItems(aList: TListItems);
begin
  removeShapes(lvWork.Items);
  lvWork.Items.Clear;
  lvWork.Items.Assign(aList);
  LocationsRefresh;
end; }

procedure TfrmALMapEdit.setByList(aList: TStringList);
//procedure TfrmALMapEdit.setByList(aList: TStringList; aParent: TWinControl);   // rpk 5/2/2016
var
  i: integer;

//  procedure setMapItem(aValue: String);
  procedure setMapItem(ii: Integer; aValue: string);
  var
    iLimit,
      idx: Integer;
    li: TListItem;
    j, ID: Integer;
    s: string;
  begin
    iLimit := 0;
    idx := 0;
{
    while idx < Length(aValue) do
      begin
        if aValue[idx+1]=MapDelimeter then
          inc(iLimit);
        inc(idx);
      end;
}
    li := lvWork.Items.Add;
    s := Piece(aValue, MapDelimiter, 1);
    if TryStrToInt(s, ID) then begin
      li.Caption := piece(aValue, MapDelimiter, 2); // name
      li.SubItems.Add(piece(aValue, MapDelimiter, 1)); // ID
      li.SubItems.Add(piece(aValue, MapDelimiter, 3)); // X
      li.SubItems.Add(piece(aValue, MapDelimiter, 4)); // Y
      li.StateIndex := idxNoCoordinates;
      li.Data := ShapeByItem(nil, pnlBodyChart, li, ID);
//      li.Data := ShapeByItem(nil, aParent, li, ID);
    end
    else begin
      li.Caption := piece(aValue, MapDelimiter, 1); // name

      s := piece(AValue, MapDelimiter, 2);
      j := StrToIntDef(s, 0);
      li.SubItems.Add(IfThen(j = 1, 'Y', '')); // injection flag

      s := piece(AValue, MapDelimiter, 3);
      j := StrToIntDef(s, 0);
      li.SubItems.Add(IfThen(j = 1, 'Y', '')); // dermal flag

      li.SubItems.Add(piece(aValue, MapDelimiter, 4)); // ID
      li.SubItems.Add(piece(aValue, MapDelimiter, 5)); // X
      li.SubItems.Add(piece(aValue, MapDelimiter, 6)); // Y
      li.StateIndex := idxNoCoordinates;
//      li.Data := ShapeByItem2(nil, pnlBodyChart, li, i);
      li.Data := ShapeByItem2(nil, pnlBodyChart, li, ii);
//      li.Data := ShapeByItem2(nil, aParent, li, ii);
    end;
//    li.StateIndex := idxNoCoordinates;
//    if li.SubItems.Count > idxX then
//    li.Data := ShapeByItem(nil, pnlBodyChart, li, i);
  end;                                  // setMapItem

begin
  removeShapes(lvWork.Items, True);
//  lvWork.Items.Clear;
  while lvWork.Items.Count > 0 do
  begin
    lvWork.Items.Delete(0);
  end;
  lvWork.Items.Clear;                   // rpk 5/2/2016
  for i := 0 to aList.Count - 1 do
//    setMapItem(aList[i]);
    setMapItem(i, aList[i]);
end;                                    // setByList

procedure TfrmALMapEdit.setByALList(aList: TStringList; aParent: TWinControl);
var
  i: integer;

//  procedure setMapItem(anItem: TALItem);
  procedure setMapItem(ii: Integer; anItem: TALItem);
  var
    li: TListItem;
  begin
    li := lvWork.Items.Add;
    li.Caption := anItem.Caption;
    li.SubItems.Add(IfThen(anItem.InjectionFlag = 1, 'Y', ''));
    li.SubItems.Add(IfThen(anItem.DermalFlag = 1, 'Y', ''));
    li.SubItems.Add(IntToStr(anItem.ID));
    li.SubItems.Add(IntToStr(anItem.X));
    li.SubItems.Add(IntToStr(anItem.Y));
    li.StateIndex := idxNoCoordinates;

//    li.Data := ShapeByItem(nil, pnlBodyChart, li, i);
//    li.Data := ShapeByItem2(nil, pnlBodyChart, li, ii);
    li.Data := ShapeByItem2(nil, aParent, li, ii);
  end;

begin
  removeShapes(lvWork.Items, True);
  lvWork.Items.Clear;
  for i := 0 to aList.Count - 1 do
  begin
    if assigned(aList.Objects[i]) then
      if aList.Objects[i] is TALItem then
//        setMapItem(TALItem(aList.Objects[i]));
        setMapItem(i, TALItem(aList.Objects[i]));
  end;
end;                                    // setByALList

procedure TfrmALMapEdit.setDimensions;
begin
  ScaleX := imgBody.Width / imgBody.Picture.Width;
  ScaleY := imgBody.Height / imgBody.Picture.Height;

  lblScaleXY.Caption := Format('%6.2n x %6.2n', [ScaleX, ScaleY]);
  lblSize.Caption := Format('Image size: %d x %d', [imgBody.Picture.Width, imgBody.Picture.Height]);
end;

procedure TfrmALMapEdit.acAddItemExecute(Sender: TObject);
var
  newVal: string;                       // holds the value of the item name
  ListItem: TListItem;                  // reference to the current ListView Row
  CheckState: Boolean;                  // holds the state of the inputPrompt() checkbox
  CheckState2: Boolean;                 // holds the state of the second inputPrompt() checkbox
  Attribute: string;                    // holds the value of the items attribute (req pain)
  Attribute2: string;                   // holds the second value of the items attribute
  i: Integer;
  bfound: Boolean;
begin
{$IFDEF CAS_DDPE_MAPEDIT}
  Attribute := '';
  Attribute2 := '';
  checkstate := False;
  checkstate2 := False;
  newVal := inputPrompt2('Add New Item', 'Item:', '', 30, true, false,
    CheckState, 'Injection Site', CheckState2, 'Dermal Site');
  if CheckState = true then
    Attribute := 'Y';
  if CheckState2 = true then
    Attribute2 := 'Y';
  //remove leading and trailing spaces before we check for null
  newVal := StripString(newVal, True);
//  newVal := UpperCase(newVal);          // rpk 1/14/2016
  if newVal <> '' then
  begin
    // need to check for duplicates
    bfound := False;
    for I := 0 to lvWork.items.Count - 1 do
//      if lvWork.Items[i].Caption = newVal then begin
      if SameText(lvWork.Items[i].Caption, newVal) then begin // rpk 6/14/2016
        bfound := True;
        break;
      end;

    if bfound then
      ShowMessage(newVal + ' is already in the list. Not added.')
    else begin
      ListItem := lvWork.Items.Add;
      ListItem.Caption := newVal;
      lvWork.Selected := ListItem;
      // add the attribute to the ListView (column 2)
      ListItem.SubItems.Add(Attribute); // injection flag
      // add the attribute to the ListView (column 3)
      ListItem.SubItems.Add(Attribute2); // dermal flag
      ListItem.SubItems.Add('');        // ID
      ListItem.SubItems.Add('');        // X
      ListItem.SubItems.Add('');        // Y

      Inc(fChangeCount);
    end;
  end;
{$ENDIF}
end;                                    // acAddItemExecute

procedure TfrmALMapEdit.acClearMapExecute(Sender: TObject);
begin
  if MessageDLG('Remove mapping data?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if removeShapes(lvWork.Items) > 0 then
      Inc(fChangeCount);
  end;
end;

procedure TfrmALMapEdit.acDeleteItemExecute(Sender: TObject);
var
  li: TListItem;
  shp: TShape;
begin
  if not assigned(lvWork.Selected) then
    ShowMessage('Select an Item to delete from the list or the Map')
  else
  begin
    li := lvWork.Selected;
    if MessageDLG('Remove item ' + li.Caption + ' ?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
      if assigned(li.Data) then
      begin
        shp := TShape(li.Data);
        shp.Parent := nil;
        FreeAndNil(shp);
        li.Data := nil;
      end;
      lvWork.Items.Delete(lvWork.ItemIndex);
      Inc(fChangeCount);
    end;
  end;
end;                                    // acDeleteItemExecute

procedure TfrmALMapEdit.acEraseExecute(Sender: TObject);
begin
  if imgBody.Picture <> nil then
    imgBody.Picture := nil;
end;

procedure TfrmALMapEdit.acLoadImageFromVistAExecute(Sender: TObject);
var
  tbool: Boolean;
begin
  try
    // use group image name?
    tbool := GetImageFromVistA(edImage.Text);
    if not tbool then begin
      if ViewMode = mmDebug then        // rpk 4/25/2016
        MessageDlg('Background image was not found.  Saving default background image to Vista.', mtInformation, [mbOK], 0);
      acSaveChartToVistAExecute(nil);
    end;
  except
    on E: Exception do
      MessageDlg('Error loading Image file "' + edImage.Text + '"' + CRLF + CRLF +
        E.Message, mtError, [mbOK], 0);
  end;
end;

//procedure TfrmALMapEdit.GetImageFromVistA(aName: string);

function TfrmALMapEdit.GetImageFromVistA(aName: string): Boolean;
var
  jpg: TJPEGImage;
  memS: TMemoryStream;
  SL: TStringList;
  iret: Integer;
begin
  Result := False;
  memS := nil;
  SL := nil;
  BCMA_Broker.CallServer('PSB GETSETWP',
    ['GETWP', Division, aName {'PSB MAP BACKGROUND'}, '1'], nil);
  if (BCMA_Broker.Results.Count < 2) or
    (pos(UUE_HEADER, BCMA_Broker.Results[1]) <> 1) then
//    MessageDlg(ALChartLoadFailure, mtError, [mbOK], 0)
    AddTextEvent('GetImageFromVista', ALChartLoadFailure)
  else begin
//  try
    memS := TMemoryStream.Create;
    try
      SL := TSTringList.Create;
      try
        SL.Assign(BCMA_Broker.Results);
        SL.Delete(0);

        iret := UUDecodeStringListToStream(SL, memS);
        if iret > 0 then begin
          try
            acEraseExecute(nil);

            jpg := TJpegImage.Create;
            memS.Position := 0;
            jpg.LoadFromStream(memS);
            imgBody.Picture.Assign(jpg);
            jpg.Free;
            setDimensions;
            Result := True;
          except
            on E: Exception do
              ShowMessage(E.Message);
          end;
        end;                            // if iret > 0
      finally                           // try SL Create
        SL.Free;
      end;
    finally                             // try memS create
      memS.Free;
    end;
  end;                                  // else broker results ok
end;                                    // GetImageFromVistA

procedure TfrmALMapEdit.acMapSaveToVistAExecute(Sender: TObject);
var
  i: Integer;
  sError,
    s: string;
//  alItem: TALItem;
  anItem: TListItem;
begin
  BCMA_Broker.CallServer('PSB PARAMETER', ['DELLST', Division, Group], nil);
  BCMA_Broker.CallServer('PSB PARAMETER',
    ['SETPAR', trim(Division), Group, kwMaster, MasterList], nil);
  BCMA_Broker.CallServer('PSB PARAMETER',
    ['SETPAR', trim(Division), Group, kwImage, edImage.Text], nil);

  for i := 0 to lvWork.Items.Count - 1 do
  begin
//    alItem := TALItem(lvWork.Items[i].Data);
//    if alItem = nil then
//      continue;
    anItem := lvWork.Items[i];
    if anItem = nil then
      continue;
     // save the Location parameter
    if Trim(anItem.Caption) > '' then begin
//      BCMA_Broker.CallServer('PSB PARAMETER',
//        ['SETPAR', trim(Division), Group, IntToStr(i + 1), alItem.toString], nil);
      s := LocationItemToString(IntToStr(i + 1), anItem);
      BCMA_Broker.CallServer('PSB PARAMETER',
        ['SETPAR', trim(Division), Group, IntToStr(i + 1), s], nil);

      // warn the user if an Item is not saved.
      if piece(BCMA_Broker.Results[0], '^', 1) = '-1' then
        sError := sError + 'Invalid Parameter [' + IntToStr(i + 1) +
          '] ' + #13#10 + 'Value [' + s + '] was not saved.' + CRLF;
    end;
  end;

end;

procedure TfrmALMapEdit.acModeExecute(Sender: TObject);
begin
{$IFDEF CAS_DDPE_DEBUG}
  if ViewMode = mmEdit then
    ViewMode := mmSelect
  else if ViewMode = mmSelect then
    ViewMode := mmView
  else if ViewMode = mmView then
    ViewMode := mmDebug
  else if ViewMode = mmDebug then
    ViewMode := mmEdit;
{$ENDIF}
end;

procedure TfrmALMapEdit.acEditItemExecute(Sender: TObject);
var
  li: TListItem;
//  shp: TShape;
  oldval, newVal: string;
  CheckState: Boolean;
  CheckState2: Boolean;                 // holds the state of the second inputPrompt() checkbox
  curCheckState: boolean;               // the existing state of first cbx
  curCheckState2: boolean;              // the existing state of second cbx
  Attribute: string;                    // holds the value of the items attribute (req pain)
  Attribute2: string;                   // holds the second value of the items attribute
  i: Integer;
  bfound: Boolean;
begin
{$IFDEF CAS_DDPE_MAPEDIT}
  if not assigned(lvWork.Selected) then
    ShowMessage('Select an Item to delete from the list or the Map')
  else
  begin
    li := lvWork.Selected;
    oldVal := li.Caption;
    curCheckState := false;
    CurCheckState2 := False;
//    newVal := inputPrompt('Edit Item', 'Item:', newVal, 30, false, false,
//      CheckState, '');
    Attribute := '';
    Attribute2 := '';
    CheckState := li.SubItems[idxInjection] = 'Y';
    CurCheckState := CheckState;
    CheckState2 := li.SubItems[idxDermal] = 'Y';
    CurCheckState2 := CheckState2;
    newVal := inputPrompt2('Edit Item', 'Item:', oldval, 30, true, false,
      CheckState, 'Injection Site', CheckState2, 'Dermal Site');
    if CheckState = true then
      Attribute := 'Y';
    if CheckState2 = true then
      Attribute2 := 'Y';
    newVal := StripString(newVal, True);
//    newVal := UpperCase(newVal);        // rpk 1/14/2016
    // don't add if there's no item name or if nothing changed
//    if (newVal <> '') and (oldVal <> newVal)
//    then
//    begin
    if newVal <> '' then
      if ((newVal <> oldVal) or
        (checkState <> curCheckState) or
        (checkState2 <> curCheckState2)) then begin
      // need to check for duplicates
        if (oldVal <> newVal) then begin
          bfound := False;
          for I := 0 to lvWork.items.Count - 1 do
//            if lvWork.Items[i].Caption = newVal then begin
            if SameText(lvWork.Items[i].Caption, newVal) then begin // rpk 6/14/2016
              bfound := True;
              break;
            end;

          if bfound then
            ShowMessage(newVal + ' is already in the list. Not changed.')
          else begin
            li.Caption := newVal;
          end;
        end;
        Inc(fChangeCount);
      end;
//      else begin
//    if not bfound then
//      li.Caption := newVal;
    if li.SubItems.Count > idxInjection then
      li.SubItems[idxInjection] := Attribute // injection flag
    else
      li.SubItems.Add(Attribute);
    if li.SubItems.Count > idxDermal then
      li.SubItems[idxDermal] := Attribute2 // dermal flag
    else
      li.SubItems.Add(Attribute2);
    if assigned(li.Data) then
      TShape(li.Data).Hint := newVal;
    li.Update;
//      end;
//    end;
  end;
{$ENDIF}
end;

procedure TfrmALMapEdit.acRestoreExecute(Sender: TObject);
begin
//  if MessageDLG('Restore items list?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//    RestoreFromBackup;
  ShowMessage('Restore of items not implemented yet.');
end;

procedure TfrmALMapEdit.acSaveChartToVistAExecute(Sender: TObject);
var
  memS: TMemoryStream;
  SL: TStringList;
  tbool: Boolean;
begin
  memS := TMemoryStream.Create;
  SL := nil;
  try
//    if imgBody.Picture <> nil then
    if (imgBody.Picture <> nil) and (imgBody.Picture.Graphic <> nil) then
    begin
      TJPEGImage(imgBody.Picture.Graphic).SaveToStream(memS);
      memS.Position := 0;
      SL := UUEncodeMemoryStreamToStringList(memS);
      if ViewMode = mmDebug then
        SL.savetofile('c:\temp\saveChartpsbalimagegeneral.txt');

      tbool := BCMA_Broker.CallServer('PSB GETSETWP',
        ['SETWP', Division,
        edImage.Text,                   //'PSB MAP BACKGROUND',
          '1'], SL);

      { if ViewMode = mmDebug then begin  // rpk 4/25/2016
        if pos('1^WP', BCMA_Broker.Results.Text) = 1 then
          MessageDlg(ALChartSaveSuccess, mtInformation, [mbOK], 0)
        else
          MessageDlg(ALChartSaveFailure, mtError, [mbOK], 0);
      end; }
      if pos('1^WP', BCMA_Broker.Results.Text) = 1 then begin
        if ViewMode = mmDebug then      // rpk 4/25/2016
          MessageDlg(ALChartSaveSuccess, mtInformation, [mbOK], 0)
      end
      else
        MessageDlg(ALChartSaveFailure, mtError, [mbOK], 0);
    end;
  finally
    memS.Free;
    SL.Free;
  end;
end;

{ procedure TfrmALMapEdit.cmbALImagesChange(Sender: TObject);
begin
  MessageDLG('Changing image name does not automatically reload the picture' + CRLF +
    'Click "Load" button to load image manually', mtInformation, [mbOK], 0);
end; }

procedure TfrmALMapEdit.setGroup(aGroup: string);
begin
  fGroup := aGroup;
  pnlSelect.Caption := '  Anatomic Location Group: "' + fGroup + '"';
end;

procedure TfrmALMapEdit.setDivision(aDivision: string);
//var
//   tbool: Boolean;
begin
  fDivision := aDivision;
end;

procedure TfrmALMapEdit.setDivisionLoadImage(aDivision: string);
//var
//   tbool: Boolean;
begin
  if Division = aDivision then
    exit;
  fDivision := aDivision;
  acLoadImageFromVistAExecute(nil);
end;

//procedure TfrmALMapEdit.setDivisionData;

procedure TfrmALMapEdit.setDivisionData(aGroupName: string);
begin
//  BCMA_Broker.CallServer('PSB PARAMETER',
//    ['GETLST', Division, AnatomicLocationMapList], nil);
  if aGroupName = '' then
//    aGroupName := AnatomicLocationMapList;
    aGroupName := pnBodySites;
  BCMA_Broker.CallServer('PSB PARAMETER',
    ['GETLST', Division, aGroupName], nil);

  Backup.Assign(BCMA_Broker.Results);
  if Backup.Count > 0 then
    Backup.Delete(0);
  setByList(Backup);
//  setByList(Backup, pnlBodyChart);  // rpk 5/2/2016
end;


{ procedure TfrmALMapEdit.RestoreFromBackup;
begin
//
end; }

{ procedure TfrmALMapEdit.edSizeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    setDimensions;
end; }

procedure TfrmALMapEdit.FileOpen1Accept(Sender: TObject);
begin
  imgBody.Picture.LoadFromFile(FileOpen1.Dialog.FileName);
  setDimensions;
end;

{ procedure TfrmALMapEdit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
(*
  if ChangeCount > 0 then
    case MessageDLG('You changed the Map during this session.'+#13#10+
      'Do you want to save changes?'+#13#10+
      'Press:'+#9+'"YES" - to save changes'+ #13#10+
      #9+'"No" - to restore the Map'+ #13#10+
      #9+'"Cancel" - to continue editing',
      mtConfirmation,[mbYes,mbNo,mbCancel],0) of
      mrNo: begin
        Restore;
        CanClose := True;
      end;
      mrYes: CanClose := True;
      mrCancel: CanClose := False;
    end;
*)
end; }

procedure TfrmALMapEdit.FormCreate(Sender: TObject);
begin
  fBackup := TStringList.Create;
  bparLvwDefAnswer := nil;
end;

procedure TfrmALMapEdit.FormDestroy(Sender: TObject);
begin
  fBackup.Free;
end;

procedure TfrmALMapEdit.FormResize(Sender: TObject);
var
  sX, sY: string;
  d: double;
  i: Integer;
  X, Y: Integer;
  li: TListItem;
  shp: TShape;
begin
  setDimensions;
  try
    for i := 0 to lvWork.Items.Count - 1 do
    begin
      li := lvWork.Items[i];
//      if assigned(li.Data) and (li.SubItems.Count > 0) then
      if assigned(li.Data) and (li.SubItems.Count > idxY) then
      try
        sX := li.SubItems[idxX];
        sY := li.SubItems[idxY];
        d := StrToFloat(sX) * ScaleX;
        X := Round(d);
        d := StrToFloat(sY) * ScaleY;
        Y := Round(d);
        shp := li.Data;
        shp.Top := Y;
        shp.Left := X;
      except
        on E: Exception do
          ShowMessage(E.Message);
      end;
    end;
  finally
//    SendMessage(Handle,WM_SETREDRAW,WPARAM(True),0);
  end;
  Invalidate;
end;

procedure TfrmALMapEdit.FormShow(Sender: TObject);
var
  i: Integer;
begin
  if not assigned(lvWork.Selected) and (lvWork.Items.Count > 0) then
  begin
    lvWork.ItemIndex := 0;
    if assigned(lvWork.Selected) and assigned(lvWork.Selected.Data) then
      TShape(lvWork.Selected.data).Brush.Color := clAL_Selected;
  end;
  try
    i := lvWork.Columns.Count;
      {
      lvWork.Columns[0].Width := itemwidth;
      lvWork.Columns[1].Caption := 'Injection Site';
      lvWork.Columns[1].Width := injwidth;
      lvWork.Columns[2].Caption := 'Dermal Site';
      lvWork.Columns[2].Width := dermwidth;
      lvWork.Columns[3].Caption := 'ID';
      lvWork.Columns[3].Width := 50;
      lvWork.Columns[4].Caption := 'X';
      lvWork.Columns[4].Width := 50;
      lvWork.Columns[5].Caption := 'Y';
      lvWork.Columns[5].Width := 50;
      }

    if lvWork.Visible then
      if lvWork.CanFocus then
        lvWork.SetFocus;
  except
  end;
end;

procedure TfrmALMapEdit.imgBodyDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  shp: TShape;
  li: TListItem;
begin
  if Source is TListView then
  begin
    shp := newShape(pnlBodyChart, X, Y);
    lvWork.Selected.Data := shp;
    shp.Tag := lvWork.ItemIndex;
    shp.Hint := lvWork.Selected.Caption;
    shp.ShowHint := true;
    li := lvWork.Selected;

    while lvWork.Selected.SubItems.Count < idxMax do
      lvWork.Selected.SubItems.Add('');

//    lvWork.Selected.SubItems[idxInjection] := format('%d', InjectionFlag);
//    lvWork.Selected.SubItems[idxDermal] := format('%d', DermalFlag);
    lvWork.Selected.SubItems[idxID] := format('%d', [lvWork.ItemIndex]);
    lvWork.Selected.SubItems[idxX] := format('%6.0n', [X / ScaleX]);
    lvWork.Selected.SubItems[idxY] := format('%6.0n', [Y / ScaleY]);
    lvWork.Selected.StateIndex := idxCoordinates;
    if ViewMode <> mmView then
      shp.Hint := li.Caption
        + #13#10
        + Format('X: %s, Y:%s', [li.SubItems[idxX], li.SubItems[idxY]]) + #13#10
        + Format('ID: %s', [li.SubItems[idxID]]);
  end
//  if Source is TShape then
  else if Source is TShape then
  begin
    shp := TShape(Source);
    shp.Left := x - (shp.Width div 2); ;
    shp.Top := y - (shp.Height div 2);
    shp.Brush.Color := clAL_New;
//    lvWork.Items[shp.Tag].SubItems[idxX] := format('%6.0n', [X / ScaleX]);
//    lvWork.Items[shp.Tag].SubItems[idxY] := format('%6.0n', [Y / ScaleY]);
    li := lvWork.Items[shp.Tag];
    li.SubItems[idxX] := format('%6.0n', [X / ScaleX]);
    li.SubItems[idxY] := format('%6.0n', [Y / ScaleY]);
    if ViewMode <> mmView then
      shp.Hint := li.Caption
        + #13#10
        + Format('X: %s, Y:%s', [li.SubItems[idxX], li.SubItems[idxY]]) + #13#10
        + Format('ID: %s', [li.SubItems[idxID]]);

    shp.ShowHint := True;
  end;
  inc(fChangeCount);
end;                                    // imgBodyDragDrop

procedure TfrmALMapEdit.imgBodyDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TShape;
  Accept := accept or (Source is TListView);
  if Accept then
  begin
    case State of
      dsDragEnter: lblPosition.Show;
      dsDragLeave: lblPosition.Hide;
      dsDragMove: begin
          if Source is TListView then begin
//        lblPosition.Caption :=
//          Format('<|%s|> %d:%d', [(Source as TListView).Name, x, y]);
            lblPosition.Caption :=
              Format('<|%s|> %d:%d', [(Source as TListView).Selected.Caption, x, y]);
//          lblPosition.Caption :=
//            Format('<|%s|> %d:%d', [lvWork.Selected.Caption, x, y]);
          end
          else if Source is TShape then
            lblPosition.Caption :=
              Format('<|%s|> %d:%d', [(Source as TShape).Hint, x, y]);
        end;                            // dsDragMove
    end;                                // case State
  end;                                  // if accept
end;                                    // imgBodyDragOver

procedure TfrmALMapEdit.imgBodyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ssCtrl in Shift) then
    acMode.Execute;
end;

procedure TfrmALMapEdit.imgBodyMouseEnter(Sender: TObject);
begin
  lblPosition.Show;
end;

procedure TfrmALMapEdit.imgBodyMouseLeave(Sender: TObject);
begin
  lblPosition.Hide;
end;

procedure TfrmALMapEdit.imgBodyMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  try
    lblPosition.Caption := Format(' %d:%d (%6.2n:%6.2n)', [x, y, x / ScaleX, y / ScaleY]);
    lblItems.Caption := Format(' Items: %d', [lvWork.Items.count]);

  except
  end;
end;

procedure TfrmALMapEdit.lvWorkChanging(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
begin
  if assigned(Item.Data) then
  try
    TShape(Item.Data).Brush.Color := clAL_MouseLeave;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfrmALMapEdit.lvWorkCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
//  if (Item.SubItems.Count >= idxX) and (Item.SubItems[idxX] <> '') then
  if (Item.SubItems.Count > idxX) and
    (Item.SubItems[idxX] <> '') and
    (Item.SubItems[idxX] <> '0') then
    lvWork.Canvas.Brush.Color := clCoordinates
  else
    lvWork.Canvas.Brush.Color := clNoCoordinates;
end;

procedure TfrmALMapEdit.lvWorkMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  li: TListItem;
begin
  if Sender is TListView then
  begin
    li := TListView(Sender).GetItemAt(X, Y);
    if not assigned(li) then
      exit;
    if not assigned(li.Data) and ((ViewMode = mmEdit) or (ViewMode = mmDebug)) then
      lvWork.BeginDrag(True);
    if assigned(li.Data) then
      TShape(li.Data).Brush.Color := clAL_Selected;
  end;
end;

function TfrmALMapEdit.newShape(anOwner: TComponent; x, y: Integer): TShape;
var
  shp: TShape;
begin
  shp := TShape.Create(self);
  shp.OnMouseDown := shpCircleMouseDown;
  shp.Brush.Color := clAL_New;
  shp.Shape := stCircle;
  shp.Width := 17;
  shp.Height := 17;
//  shp.Width := 10;
//  shp.Height := 10;
  shp.Top := y - (shp.Height div 2);
  shp.Left := x - (shp.Width div 2);
  shp.OnMouseEnter := shpCircleMouseEnter;
  shp.OnMouseLeave := shpCircleMouseLeave;
//  shp.DragCursor := crDefault;
  shp.DragCursor := crDrag;             // rpk 1/13/2016
  TPanel(anOwner).InsertControl(shp);
  Result := shp;
end;

procedure TfrmALMapEdit.pnlSelectDblClick(Sender: TObject);
begin
{$IFDEF CAS_DDPE_DEBUG}
  acModeExecute(nil);
{$ENDIF}
end;

procedure TfrmALMapEdit.shpCircleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  shp: TShape;
  firstidx, lastidx, idx: Integer;
begin
  if Button = mbLeft then
  begin
    if not assigned(lvWork.Selected) and (lvWork.Items.Count > 0) then
      lvWork.ItemIndex := 0;
    if not assigned(lvWork.Selected) then
      exit;
    if ((ViewMode = mmEdit) or (ViewMode = mmDebug)) then
      (Sender as TControl).BeginDrag(True);
    if Sender is TShape then
    begin
      shp := TShape(Sender);
//          shp.Brush.Color := clAL_MouseDown;
//          lvWork.ItemIndex := shp.Tag;

//          if lvWork.ItemIndex <> shp.Tag then
//            shp.Brush.Color := clAL_MouseEnter
//          else
      shp.Brush.Color := clAL_Selected;

      lvWork.ItemIndex := shp.Tag;
      // if on default answer list tab with frmALView displaying,
      // when user clicks dot on frmALView, select the corresponding row
      // in lvwDefAnswer.
//      if frmBCMAParameters.lvwDefAnswer.Visible and (shp.Tag >= 0) then begin
      if Assigned(bparLvwDefAnswer) then begin
        if bparlvwDefAnswer.Visible and (shp.Tag >= 0) then begin
          idx := shp.Tag;
//        GetVisibleItems(firstidx, lastidx, frmBCMAParameters.lvwDefAnswer); // rpk 1/13/2016
          GetVisibleItems(firstidx, lastidx, bparlvwDefAnswer); // rpk 1/13/2016
        // if newly selected row is not visible, readjust listview to show the row
          if (idx < firstidx) or (idx > lastidx) then begin // rpk 1/13/2016
          // show selected row near middle of visible listview
//          idx := shp.Tag - (frmBCMAParameters.lvwDefAnswer.VisibleRowCount div 2);
            idx := shp.Tag - (bparlvwDefAnswer.VisibleRowCount div 2);
            if idx < 0 then
              idx := 0;
//          ListViewSetTopItem(frmBCMAParameters.lvwDefAnswer, idx); // rpk 1/13/2016
            ListViewSetTopItem(bparlvwDefAnswer, idx); // rpk 1/13/2016
          end;
          bparlvwDefAnswer.ItemIndex := shp.Tag; // rpk 1/13/2016
//        frmBCMAParameters.lvwDefAnswer.Invalidate; // rpk 1/13/2016
          bparlvwDefAnswer.Invalidate;  // rpk 1/13/2016
        end;                            // if bparlvwDefAnswer.Visible and (shp.Tag >= 0)
      end;                              // if Assigned(bparLvwDefAnswer)

    end;                                // if sender is tshape
  end;
end;

procedure TfrmALMapEdit.shpCircleMouseEnter(Sender: TObject);
var
  shp: TShape;
begin
  if Sender is TShape then
  begin
    shp := (Sender as TShape);
    if lvWork.ItemIndex <> shp.Tag then
      shp.Brush.Color := clAL_MouseEnter
    else
      shp.Brush.Color := clAL_Selected;
  end;
end;

procedure TfrmALMapEdit.shpCircleMouseLeave(Sender: TObject);
var
  shp: TShape;
begin
  if Sender is TShape then
  begin
    shp := (Sender as TShape);
    if lvWork.ItemIndex <> shp.Tag then
      shp.Brush.Color := clAL_MouseLeave
    else
      shp.Brush.Color := clAL_Selected;
  end;
end;

procedure TfrmALMapEdit.shpCircleMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  shp: TShape;
begin
  if Sender is TShape then
  begin
    shp := (Sender as TShape);
    if lvWork.ItemIndex <> shp.Tag then
      shp.Brush.Color := clAL_MouseLeave
    else
      shp.Brush.Color := clAL_Selected;
  end;
end;

{ function TfrmALMapEdit.getItemName: String;
begin
  If lvWork.ItemIndex > -1 then
    Result := lvWork.Items[lvWork.ItemIndex].Caption
  else
    Result := '?';
end; }

procedure TfrmALMapEdit.setMapViewMode(aMode: TMapViewMode);
var
  i: integer;
begin
  fViewMode := aMode;

  pnlSizeScale.Visible := (fViewMode = mmEdit) or (ViewMode = mmDebug);
  pnlSelect.Visible := (ViewMode = mmDebug);
  pnlDialog.Visible := fViewMode <> mmView;
  pnlLocations.Visible := fViewMode <> mmView;
  splMap.Visible := fViewMode <> mmView;
  lvWork.ShowColumnHeaders := fViewMode in
    [mmEdit, mmSelect, mmSelectInjection, mmSelectDermal, mmDebug];
  if aMode in [mmEdit, mmDebug] then
    lvWork.PopupMenu := PopupMenu1;

  tlbImage.Enabled := ViewMode = mmDebug; // rpk 1/26/2016
  tlbImage.Visible := ViewMode = mmDebug; // rpk 1/26/2016
  tlbItemList.Visible := (fViewMode = mmEdit) or (ViewMode = mmDebug); // rpk 2/18/2016
  pnlItemsToolBar.Enabled := ViewMode = mmDebug; // rpk 1/26/2016
  pnlItemsToolBar.Visible := ViewMode = mmDebug; // rpk 1/26/2016

  if aMode = mmView then
    splMap.Align := alLeft
  else
    splMap.Align := alRight;

  case ViewMode of
    mmEdit: Caption := 'Body Site Editor';
    mmDebug: Caption := 'Body Site Editor (Debug Mode)';
    mmSelect: Caption := 'Body Site Selector'; // rpk 1/5/2016
    mmSelectDermal: Caption := 'Dermal Site Selector'; // rpk 1/5/2016
    mmSelectInjection: Caption := 'Injection Site Selector'; // rpk 1/5/2016
    mmView: Caption := 'Body Site Viewer';
  end;

  if lvWork = nil then                  // rpk 5/2/2016
    exit;
  // if no items in list, leave before setting column widths.  Attempting to
  // set column widths with no rows can cause a stream read error.
  if lvWork.Items.Count = 0 then        // rpk 9/12/2016
    exit;

  if ViewMode = mmEdit then begin
    lvWork.Columns[0].Width := itemwidth;
    lvWork.Columns[1].Caption := 'Injection Site';
    lvWork.Columns[1].Width := injwidth;
    lvWork.Columns[2].Caption := 'Dermal Site';
    lvWork.Columns[2].Width := dermwidth;
    lvWork.Columns[3].Caption := '';
    lvWork.Columns[3].Width := 0;
    lvWork.Columns[4].Caption := '';
    lvWork.Columns[4].Width := 0;
    lvWork.Columns[5].Caption := '';
    lvWork.Columns[5].Width := 0;
  end
  else
    for i := 1 to lvWork.Columns.Count - 1 do begin
      //mmView, mmEdit, mmSelect, mmDebug
      if lvWork.Columns[i] = nil then
        break;
      if ViewMode in [mmView, mmSelect, mmSelectInjection, mmSelectDermal] then
        lvWork.Columns[i].width := 0
      else if ViewMode = mmDebug then
        lvWork.Columns[i].width := 64;
    end;
end;

end.

