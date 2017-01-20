unit stabSort;

(*Philippe Ranger, 29-1-00. Put into the public domain. Please credit
source.*)

interface

uses classes;

procedure stableSort(lst: Tlist; uf: TlistSortCompare);
(*POST lst is sorted according to uf, and the elements for which uf
returned 0 are in their original order.*)

(*****************************­****************)
implementation

var
  Mlst: Tlist;
  Muf: TlistSortCompare;
  lst1: Tlist;

function lstComp(p1, p2: pointer): integer;
var
  i1, i2: integer;
begin
  i1 := integer(p1);
  i2 := integer(p2);
  result := Muf(Mlst[i1], Mlst[i2]);
  if (result = 0) then
    result := i1 - i2;
end;

procedure stableSort(lst: Tlist; uf: TlistSortCompare);
type
  TaInts = array[0..MaxListSize - 1] of integer;
  TpaInts = ^TaInts;
var
  //    lst1: Tlist;
  j: integer;
  pi1: TpaInts;
  pp, pp1: PpointerList;
begin
  if (lst = nil) or (lst.count < 2) then
    EXIT;
  Mlst := lst;
  Muf := uf;
  lst1 := Tlist.create;
  try

    (*set lst1 to hold indices 0 to lst.count-1*)
    // capacity exceeded error rpk 5/11/2011
//    lst1.capacity := lst.capacity;
    lst1.count := lst.count;
    pi1 := TpaInts(lst1.list);
    for j := 0 to lst1.count - 1 do
    begin
      pi1[j] := j;
    end;

    (*sort using comp function above*)
    lst1.sort(lstComp);

    (*replace indices in lst1 with actual pointers from lst*)
    pp1 := lst1.list;
    for j := 0 to lst1.count - 1 do
    begin
      pp1[j] := lst[pi1[j]];
    end;

    (*copy lst1 into lst*)
    pp := lst.list;
    for j := 0 to lst.count - 1 do
    begin
      pp[j] := pp1[j];
    end;

  finally
    lst1.free;
  end;
end;

end.
