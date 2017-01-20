unit uIVUtilities;

interface
uses
  Dialogs, StdCtrls, controls, classes, BCMA_Objects;

function GetIVBagFromHistory(ScannedText: string): TBCMA_IVBags;
//function GetOrderViaOrderNumber(OrderNum: string; VDLIn: TListBox;
//  DisplayNilMessage: Boolean = True): TBCMA_MedOrder;
function GetOrderViaOrderNumber(OrderNum: string; var idxOrder: Integer;  // rpk 11/16/2011
  DisplayNilMessage: Boolean = True): TBCMA_MedOrder;
//function GetOrderFromUniqueID(ScannedText: string; VDLIn: TListBox):
//  TBCMA_MedOrder;
function GetOrderFromUniqueID(ScannedText: string; var idxOrder: Integer):  // rpk 11/16/2011
  TBCMA_MedOrder;
//function CheckInfusingBags(ScannedText: string; VDLIn: TListBox; BagStatus: string;
//  var CurFlowUID: string; var InfusingBags: Boolean; var BailOut: Boolean): Boolean; //allow continue or not
function CheckInfusingBags(ScannedText: string; BagStatus: string;
  var CurFlowUID: string; var InfusingBags: Boolean; var BailOut: Boolean):
  Boolean; //allow continue or not
procedure DisplayIVOrderChanges(aMedOrder: TBCMA_MedOrder = nil);
procedure LoadIVOrderChangeInfo;
function FormatDisplayMessage(aMedOrder: TBCMA_MedOrder; UniqueIDIn: string;
  DisplayMsg: Boolean = True): string;

implementation

uses BCMA_Common, BCMA_Util, BCMA_Startup, BCMA_Main,
//MFunStr,
SysUtils;

function GetIVBagFromHistory(ScannedText: string): TBCMA_IVBags;
{Gets a the OrderNumber from history via the UniqueId that was scanned}
var
  idxBag, ii: integer;
begin
  result := nil;
  idxBag := -1;
  with IVHistoryDates do
    for ii := 0 to Count - 1 do
      with TBCMA_IVBags(Items[ii]) do
        if ScannedText = UniqueID then begin
          if idxbag <> -1 then begin
            DefMessageDlg('The scanned bag was found more than once in the bag history!'
              +
              #13 + 'This indicates a possible error in the data.  The bag cannot'
              + #13 +
              'be scanned at this time', mtError, [mbOk], 0);
            Result := nil;
            exit;
          end;
          Result := TBCMA_IVBags(Items[ii]);
          idxbag := ii;
        end;
end;

//function GetOrderViaOrderNumber(OrderNum: string; VDLIn: TListBox;
//  DisplayNilMessage: Boolean = True): TBCMA_MedOrder;
function GetOrderViaOrderNumber(OrderNum: string; var idxOrder: Integer;  // rpk 11/16/2011
  DisplayNilMessage: Boolean = True): TBCMA_MedOrder;
{Retrieves an Order via the Order Number passed in}
var
//  idxorder,
    ii: integer;
begin
  idxorder := -1;
  Result := nil;
  with VisibleMedList do
    //with BCMA_Patient.MedOrders do
    for ii := 0 to VisibleMedList.count - 1 do
      //for ii := 0 to BCMA_Patient.MedOrders.count - 1 do

      with TBCMA_MedOrder(items[ii]) do
        if OrderNumber = OrderNum then begin
          if idxorder <> -1 then begin
            DefMessageDlg('The Order Number was found in more than one order on the VDL.'
              +
              #13 + 'This indicates a possible error in the data.  This action cannot'
              + #13 +
              'be completed at this time', mtError, [mbOk], 0);
            Result := nil;
            Exit;
          end;
          Result := TBCMA_MedOrder(Items[ii]);
//          if VDLIn <> nil then
//            VDLIn.itemindex := ii;
          idxorder := ii;
        end;
  if (Result = nil) and DisplayNilMessage then
    DefMessageDlg('An order cannot be found, this action cannot be completed at this time.', mtError, [mbOk], 0);
end;

//function GetOrderFromUniqueID(ScannedText: string; VDLIn: TListBox):
//  TBCMA_MedOrder;

///
/// GetOrderFromUniqueID:
/// ii is the index of orders in VisibleMedList.
/// jj is the index of the IV bag list (UniqueIDs) in that order.
/// Result returns ii of order with IV bag id which matches ScannedText containing
/// bag id that is passed in.
/// 
function GetOrderFromUniqueID(ScannedText: string; var idxOrder: Integer):  // rpk 11/16/2011
  TBCMA_MedOrder;
var
//  idxorder,
    ii,
    jj: integer;
begin
  idxOrder := -1;
  Result := nil;
  with VisibleMedList do
    for ii := 0 to VisibleMedList.count - 1 do
      with TBCMA_MedOrder(items[ii]) do
        for jj := 0 to UniqueIDCount - 1 do
          if piece(UniqueIDs.strings[jj], '^', 1) = ScannedText then begin
            if idxOrder <> -1 then begin
              DefMessageDlg('The scanned bag was found in more than one order!'
                + #13 +
                'This indicates a possible error in the order.  The bag cannot' + #13
                + 'be scanned at this time', mtError, [mbOk], 0);
              Result := nil;
              Exit;
            end;
            // match: return the order in Result;
            // return index ii of order in VisibleMedList in output idxOrder
            Result := TBCMA_MedOrder(Items[ii]);
//            VDLIn.itemindex := ii;
//            idxorder := jj;  /// not jj
            idxOrder := ii;  // rpk 1/26/2012
          end;
end;  // GetOrderFromUniqueID

//function CheckInfusingBags(ScannedText: string; VDLIn: TListBox; BagStatus: string;
//  var CurFlowUID: string; var InfusingBags: Boolean; var BailOut: Boolean): Boolean;

function CheckInfusingBags(ScannedText: string; BagStatus: string;
  var CurFlowUID: string; var InfusingBags: Boolean; var BailOut: Boolean):
  Boolean;
{There is supposed to be only one bag infusing, on an order, at a time, and the code is
designed as such, however, we occasionally have reports that some sites manage to
get more then one bag, on a single order, infusing at the same time.  This code will
attempt to handle this scenario and take appropriate action based on the number of bags
infusing}
var
  ii, jj, InfusingBagCounter: integer;
begin
  jj := 0; // rpk 4/6/2009
  Result := False; // rpk 4/6/2009

  BailOut := False;
  InfusingBagCounter := 0;
  InfusingBags := False;
  with IVHistoryDates do
    for ii := 0 to Count - 1 do
      with TBCMA_IVBags(Items[ii]) do
        if ((ScanStatus = 'I') or (ScanStatus = 'S')) then //and
          {//(ScannedText <> UniqueID)) then} begin
          InfusingBagCounter := InfusingBagCounter + 1;
          jj := ii;
        end;

  if InfusingBagCounter = 0 then
    Result := False;

  if InfusingBagCounter = 1 then
    with IVHistoryDates do
      with TBCMA_IVBags(Items[jj]) do begin
        if ((ScanStatus = 'I') or (ScanStatus = 'S')) and (ScannedText <>
          UniqueID) then
          if DefMessageDlg('Bag ' + UniqueID + ' is currently ' +
            GetLastActivityStatus(ScanStatus) +
            '.' + #13 + 'Would you like to complete this bag now?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
            CurFlowUID := UniqueID;
            Result := True;
          end
          else begin
            CurFlowUID := '';
            Result := False;
            BailOut := True;
          end
        else
          Result := False;
      end;

  if InfusingBagCounter > 1 then
    if ((BagStatus <> 'I') and (BagStatus <> 'S')) then begin
      DefMessageDlg('There are already two or more bags currently stopped or infusing.  '
        +
        'Please complete the currently infusing bags.' + #13#13 + 'Your current '
        +
        'action will be cancelled.', mtError, [mbok], 0);
      Result := True;
      CurFlowUID := '';
      //toBeWardStock := nil;
    end
    else
      //allow them to continue to possibly mark the bag as completed, so we
      //set results to false, but set the infusingbags to true to pass on to
      {//the scaniv screen to let it know more than one bag is already infusing.} begin
      InfusingBags := True;
      Result := False;
    end;
end;

procedure DisplayIVOrderChanges(aMedOrder: TBCMA_MedOrder = nil);
var
  i: integer;
begin
  if aMedOrder <> nil then
    FormatDisplayMessage(aMedorder, '')
  else
    with BCMA_Patient.MedOrders do
      for i := 0 to count - 1 do
        with TBCMA_MedOrder(items[i]) do
          if OrderChangedData.Count > 0 then
            FormatDisplayMessage(TBCMA_MedOrder(Items[i]), '');
end;

function FormatDisplayMessage(aMedOrder: TBCMA_MedOrder; UniqueIDIn: string;
  DisplayMsg: Boolean = True): string;
var
  BagNumber, MsgList, BagState, ActionDateTime: string;
  //   OrderNumber: string;
  x, y: integer;
  IVAdd,
    IVSol,
    IVChanged: TStringList;
  function CheckOrder(OrderNumIn: string): Boolean;
  var
    ii: integer;
  begin
    Result := false;
    with BCMA_Patient.MedOrders do
      for ii := 0 to count - 1 do
        with TBCMA_MedOrder(items[ii]) do
          if OrderNumber = OrderNumIn then begin
            Result := True;
            Break;
          end;
  end;

begin
  with aMedOrder do begin
    IVAdd := TStringList.Create;
    IVSOl := TStringList.Create;
    IVChanged := TStringList.Create;
    x := 0;
    while x < OrderChangedData.Count - 1 do begin
      BagNumber := piece(OrderChangedData[x], '^', 2);
      BagState := GetLastActivityStatus(piece(OrderChangedData[x], '^', 4));
      OrderNumber := piece(OrderChangedData[x], '^', 5);
      x := x + 1;
      while x <= OrderChangedData.Count - 1 do begin
        if piece(OrderChangedData[x], '^', 1) = 'ADD' then
          IVAdd.Add(OrderChangedData[x])
        else if piece(OrderChangedData[x], '^', 1) = 'SOL' then
          IVSol.Add(OrderChangedData[x])
        else if piece(OrderChangedData[x], '^', 1) = 'CD' then
          IVChanged.Add(OrderChangedData[x])
        else if piece(OrderChangedData[x], '^', 1) = 'END' then begin
          if DisplayMsg then
            MsgList := 'IV Bag ' + BagNumber + ' is currently ' +
              BagState + ', and the associated order has been changed.' + #13;
          if DisplayMsg then
            MsgList := MsgList +
              'The bag contents and order changes are listed below:' + #13#13;
          if DisplayMsg then
            MsgList := MsgList + 'Bag Contents:' + #13;

          for y := 0 to IVAdd.Count - 1 do
            if DisplayMsg then
              MsgList := MsgList + piece(IVAdd[y], '^', 3) + ' ' +
                piece(IVAdd[y], '^', 4) + #13;

          for y := 0 to IVSol.Count - 1 do
            if DisplayMsg then
              MsgList := MsgList + piece(IVSol[y], '^', 3) + ' ' +
                piece(IVSol[y], '^', 4) + #13;

          if DisplayMsg then
            MsgList := MsgList + #13 + 'Order Changes:' + #13;
          for y := 0 to IVChanged.Count - 1 do begin
            if (ActionDateTime = '') or (ActionDateTime =
              DisplayVADateYearTime(piece(IVChanged[y], '^', 2))) then
              MsgList := MsgList + DisplayVADateYearTime(piece(IVChanged[y],
                '^', 2)) + ' - ' + piece(IVChanged[y], '^', 3) + #13
            else
              MsgList := MsgList + #13 +
                DisplayVADateYearTime(piece(IVChanged[y], '^', 2)) + ' - ' +
                piece(IVChanged[y], '^', 3) + #13;

            ActionDateTime := DisplayVADateYearTime(piece(IVChanged[y], '^',
              2));
          end;

          if CheckOrder(OrderNumber) then
            if DisplayMsg then
              DefMessageDlg(MsgList, mtInformation, [mbok], 0);

          if UniqueIDIn = BagNumber then
            result := MsgList;

          ActionDateTime := '';
          IVAdd.Clear;
          IVSol.Clear;
          IVChanged.Clear;
          x := x + 1;
          Break;

        end;
        x := x + 1
      end;
    end;
    IVAdd.Free;
    IVSol.Free;
    IVChanged.Free;
  end;
end;

procedure LoadIVOrderChangeInfo;
var
  x: integer;
  idxOrder: Integer;
  aMedOrder: TBCMA_MedOrder;

  function MultOrders: TStringList;
  var
    ii: integer;
    OrderList: TStringList;
  begin
    OrderList := TStringList.Create;
    with VisibleMedList do
      for ii := 0 to VisibleMedList.count - 1 do
        with TBCMA_MedOrder(items[ii]) do
          OrderList.Add(OrderNumber);
    Result := OrderList;
  end;

begin
  if (BCMA_Broker <> nil) and
    (BCMA_Patient.MedOrders <> nil) and
    (BCMA_Patient.IEN <> '') and (BCMA_Patient.MedOrders.Count > 0) then
    with BCMA_Broker do
      if CallServer('PSB CHECK IV', [BCMA_Patient.IEN], MultOrders) then
        if (Results.Count = 0) or (Results.Count - 1 <> StrToInt(Results[0]))
          then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if (results.Count > 1) and
          (piece(Results[1], '^', 1) = '-1') then
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
        else begin
          x := 1;
          while x < Results.Count - 1 do begin
            aMedOrder := nil;
//            aMedOrder := GetOrderViaOrderNumber(piece(Results[x], '^', 5), nil,
//              False);
            aMedOrder := GetOrderViaOrderNumber(piece(Results[x], '^', 5), idxOrder,
              False);
            //x := x + 1;
            while x <= Results.count - 1 do begin
              if aMedOrder <> nil then
                aMedOrder.OrderChangedData.Add(Results[x]);
              if piece(Results[x], '^', 1) = 'END' then begin
                x := x + 1;
                break;
              end;
              x := x + 1
            end;

          end;
        end;

end;

end.

