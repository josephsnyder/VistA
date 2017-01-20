unit fMedTherapyMedSelection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, VA508AccessibilityManager,
  VA508AccessibilityRouter;

type
  TfrmMedTherapyMedSelection = class(TForm)
    rgrpSearchCategory: TRadioGroup;
    grpSearch: TGroupBox;
    edtSearchText: TEdit;
    btnSearch: TButton;
    btnAdd: TButton;
    btnRemove: TButton;
    btnAddAll: TButton;
    btnRemoveAll: TButton;
    lvwSearchResults: TListView;
    lvwSelectedMedications: TListView;
    btnOK: TButton;
    grpSelect: TGroupBox;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    lblSearchText: TLabel;
    lblSearchResults: TLabel;
    lblSelMedications: TLabel;
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnRemoveAllClick(Sender: TObject);
    procedure edtSearchTextKeyPress(Sender: TObject; var Key: Char);
    procedure rgrpSearchCategoryClick(Sender: TObject);
    procedure lvwSearchResultsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvwSelectedMedicationsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure PopulateSearchResults;
    procedure PopulateSelected;
    procedure ClearLists;
    procedure CheckListItems;

  public
    { Public declarations }
    FormLoad: Boolean;
  end;

var
  frmMedTherapyMedSelection: TfrmMedTherapyMedSelection;

implementation

uses
  ReportRequest, BCMA_Startup, BCMA_Util, BCMA_Main, oReport, BCMA_Common;

{$R *.dfm}

{ TfrmMedTherapyMedSelection }

procedure TfrmMedTherapyMedSelection.btnSearchClick(Sender: TObject);
var
  Category: string;
begin
  btnSearch.Enabled := false;
  case rgrpSearchCategory.ItemIndex of
    0:
      Category := 'UD';
    1:
      Category := 'IV';
    2:
      Category := 'OIT';
    3:
      Category := 'VAC';
  end;
  if edtSearchText.Text <> '' then
    BCMA_Report.LoadMedicationList(edtSearchText.Text, Category);
  PopulateSearchResults;
  edtSearchText.SelectAll;
  edtSearchText.SetFocus;
  btnSearch.Enabled := True;
end;

procedure TfrmMedTherapyMedSelection.btnRemoveAllClick(Sender: TObject);
begin
  lvwSelectedMedications.SelectAll;
  btnRemove.Click;
end;

procedure TfrmMedTherapyMedSelection.CheckListItems;
begin
  lvwSelectedMedications.Enabled := (lvwSelectedMedications.Items.Count <> 0);
  lvwSearchResults.Enabled := (lvwSearchResults.Items.Count <> 0);

  if (lvwSelectedMedications.Items.Count <> 0) and
    (lvwSelectedMedications.ItemFocused = nil) and
    (lvwSelectedMedications.Selected = nil) then
    //lvwSelectedMedications.Items[0].Selected := true;
    lvwSelectedMedications.ItemFocused := lvwSelectedMedications.Items[0];
  if (lvwSearchResults.Items.Count <> 0) and (lvwSearchResults.ItemFocused = nil)
    and
    (lvwSearchResults.Selected = nil) then
    lvwSearchResults.ItemFocused := lvwSearchResults.Items[0];
  //    lvwSearchResults.Items[0].Selected := true;
end;

procedure TfrmMedTherapyMedSelection.ClearLists;
begin
  lvwSearchResults.Clear;
  lvwSearchResults.Enabled := false;
  lvwSelectedMedications.Clear;
  lvwSelectedMedications.Enabled := false;
end;

procedure TfrmMedTherapyMedSelection.edtSearchTextKeyPress(Sender: TObject;
  var Key: Char);
begin
  if edtSearchText.text <> '' then
    if key = chr(VK_RETURN) then
      btnSearch.Click;
end;

procedure TfrmMedTherapyMedSelection.btnAddAllClick(Sender: TObject);
begin
  lvwSearchResults.SelectAll;
  btnAdd.Click;
end;

procedure TfrmMedTherapyMedSelection.btnAddClick(Sender: TObject);
var
  //  x, SearchResultsItemIndex, SelectedMedicationsItemIndex: integer;
  Item: TListItem;
begin
  //  for x := lvwSearchResults.Items.Count - 1 downto 0 do
  //    if lvwSearchResults.Items[x].Selected then
  //    begin
  //      SelectedMedications.Add(lvwSearchResults.Items[x].Data);
  //      MedicationList.Remove(lvwSearchResults.Items[x].Data);
  //    end;

  //  if lvwSearchResults.Items.Count <> 0 then
  //    SearchResultsItemIndex := lvwSearchResults.Selected.Index;
  //  if lvwSelectedMedications.Items.Count <> 0 then
  //    SelectedMedicationsItemIndex := lvwSelectedMedications.Selected.Index;

  Item := lvwSearchresults.Selected;
  while Item <> nil do
  begin
    SelectedMedications.Add(Item.Data);
    MedicationList.Remove(Item.Data);

    lvwSelectedMedications.AddItem(Item.Caption, Item.Data);
    lvwSearchResults.Items.Delete(Item.Index);

    Item := lvwSearchResults.GetNextItem(Item, sdAll, [isSelected])
  end;

  CheckListItems;
  if lvwSearchResults.Items.Count <> 0 then
    lvwSearchResults.SetFocus;

  //PopulateSearchResults;
  //PopulateSelected;

//  if SearchResultsItemIndex < lvwSearchResults.Items.Count - 1 then
//  begin
//    //lvwSearchresults.ItemIndex := SearchResultsItemIndex;
//    lvwSearchResults.ItemFocused := lvwSearchResults.Items[SearchResultsItemIndex];
//    lvwSearchResults.Selected := lvwSearchResults.Items[SearchResultsItemIndex];
//    lvwSearchResults.Selected.MakeVisible(False);
//  end;

end;

procedure TfrmMedTherapyMedSelection.btnRemoveClick(Sender: TObject);
var
  //  x: integer;
  Item: TListItem;
begin

  Item := lvwSelectedMedications.Selected;
  while Item <> nil do
  begin
    MedicationList.Add(Item.Data);
    SelectedMedications.Remove(Item.Data);

    lvwSearchResults.AddItem(Item.Caption, Item.Data);
    lvwSelectedMedications.Items.Delete(Item.Index);

    Item := lvwSelectedMedications.GetNextItem(Item, sdAll, [isSelected])
  end;

  CheckListItems;
  if lvwSelectedMedications.Items.Count <> 0 then
    lvwSelectedMedications.SetFocus;
  //  for x := lvwSelectedMedications.Items.Count - 1 downto 0 do
  //    if lvwSelectedMedications.Items[x].Selected then
  //    begin
  //      MedicationList.Add(lvwSelectedMedications.Items[x].Data);
  //      SelectedMedications.Remove(lvwSelectedMedications.Items[x].Data);
  //    end;
  //  PopulateSearchResults;
  //  PopulateSelected;
end;

procedure TfrmMedTherapyMedSelection.FormCreate(Sender: TObject);
begin
  FormLoad := true;
  lvwSearchResults.Columns[0].Width := lvwSearchResults.Width -
    GetSystemMetrics(SM_CXVSCROLL) - 5;
  lvwSelectedMedications.Columns[0].Width := lvwSelectedMedications.Width -
    GetSystemMetrics(SM_CXVSCROLL) - 5;
  if SelectedMedications.Count <> 0 then
  begin
    rgrpSearchCategory.ItemIndex := BCMA_Report.MedTherapyCategoryItemIndex;
    PopulateSelected;
  end;
  FormLoad := false;
end;

procedure TfrmMedTherapyMedSelection.lvwSearchResultsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('A')) and (ssCtrl in Shift) then
  begin
    TListView(Sender).SelectAll;
    Key := 0;
  end;
end;

procedure TfrmMedTherapyMedSelection.lvwSelectedMedicationsKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('A')) and (ssCtrl in Shift) then
  begin
    TListView(Sender).SelectAll;
    Key := 0;
  end;
end;

procedure TfrmMedTherapyMedSelection.PopulateSearchResults;
var
  i: integer;
begin
  lvwSearchResults.Items.BeginUpdate;
  lvwSearchResults.Clear;
  if MedicationList.Count > 0 then
    for i := 0 to MedicationList.Count - 1 do
      lvwSearchResults.AddItem(TBCMA_ReportItemList(MedicationList[i]).ItemName,
        MedicationList[i]);
  lvwSearchResults.Items.EndUpdate;

  lvwSearchResults.Enabled := (lvwSearchResults.items.Count <> 0);

  CheckListItems;

end;

procedure TfrmMedTherapyMedSelection.PopulateSelected;
var
  i: Integer;
begin
  lvwSelectedMedications.Items.BeginUpdate;
  lvwSelectedMedications.Clear;
  if SelectedMedications.Count > 0 then
    for i := 0 to SelectedMedications.Count - 1 do
      lvwSelectedMedications.AddItem(TBCMA_ReportItemList(SelectedMedications[i]).ItemName, SelectedMedications[i]);
  lvwSelectedMedications.Items.EndUpdate;
  lvwSelectedMedications.Enabled := (lvwSelectedMedications.items.Count <> 0);

  CheckListItems;

end;

procedure TfrmMedTherapyMedSelection.rgrpSearchCategoryClick(Sender: TObject);
begin
  BCMA_Report.ClearMedicationList;
  BCMA_Report.MedTherapyCategoryItemIndex := rgrpSearchCategory.ItemIndex;
  ClearLists;
  if not FormLoad then
    BCMA_Report.ClearSelectedMedications;
end;

initialization
  SpecifyFormIsNotADialog(TfrmMedTherapyMedSelection);

end.
