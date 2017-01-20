unit fPrtClinicSel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VA508AccessibilityManager, ComCtrls, StdCtrls;

type
  TfrmPrtClinicSel = class(TForm)
    grpSearch: TGroupBox;
    lblSearchPrefix: TLabel;
    edtSearchPrefix: TEdit;
    lblSearchText: TLabel;
    edtSearchText: TEdit;
    btnSearch: TButton;
    grpSelect: TGroupBox;
    lblSearchResults: TLabel;
    lvwSearchResults: TListView;
    btnAdd: TButton;
    btnAddAll: TButton;
    btnRemove: TButton;
    btnRemoveAll: TButton;
    lblSelClinics: TLabel;
    lvwSelectedClinics: TListView;
    btnOK: TButton;
    btnCancel: TButton;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    procedure btnSearchClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnRemoveAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvwSearchResultsDblClick(Sender: TObject);
    procedure lvwSelectedClinicsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FormLoad: Boolean;
    procedure PopulateSearchResults;
    procedure PopulateSelected;
    procedure CheckListItems;
    procedure ClearLists;
  end;

var
  frmPrtClinicSel: TfrmPrtClinicSel;

implementation

uses ReportRequest, oReport, BCMA_Common;

{$R *.dfm}

procedure TfrmPrtClinicSel.CheckListItems;
begin
  lvwSelectedClinics.Enabled := (lvwSelectedClinics.Items.Count <> 0);
  lvwSearchResults.Enabled := (lvwSearchResults.Items.Count <> 0);

  if (lvwSelectedClinics.Items.Count <> 0) and
    (lvwSelectedClinics.ItemFocused = nil) and
    (lvwSelectedClinics.Selected = nil) then
    //lvwSelectedClinics.Items[0].Selected := true;
    lvwSelectedClinics.ItemFocused := lvwSelectedClinics.Items[0];
  if (lvwSearchResults.Items.Count <> 0) and (lvwSearchResults.ItemFocused = nil)
    and
    (lvwSearchResults.Selected = nil) then
    lvwSearchResults.ItemFocused := lvwSearchResults.Items[0];
  //    lvwSearchResults.Items[0].Selected := true;
end;

procedure TfrmPrtClinicSel.ClearLists;
begin
  lvwSearchResults.Clear;
  lvwSearchResults.Enabled := false;
  lvwSelectedClinics.Clear;
  lvwSelectedClinics.Enabled := false;
end;

procedure TfrmPrtClinicSel.FormCreate(Sender: TObject);
begin
  FormLoad := true;
  with BCMA_UserParameters do begin // rpk 6/26/2012
    edtSearchPrefix.Text := ClinSrchPrefix;
    edtSearchText.Text := ClinSrchText;
  end;
  lvwSearchResults.Columns[0].Width := lvwSearchResults.Width -
    GetSystemMetrics(SM_CXVSCROLL) - 5;
  lvwSelectedClinics.Columns[0].Width := lvwSelectedClinics.Width -
    GetSystemMetrics(SM_CXVSCROLL) - 5;
  if SelectedClinics.Count <> 0 then begin
    PopulateSelected;
  end;
  FormLoad := false;
end;

procedure TfrmPrtClinicSel.lvwSearchResultsDblClick(Sender: TObject);
begin
  btnAddClick(Sender);
end;

procedure TfrmPrtClinicSel.lvwSelectedClinicsDblClick(Sender: TObject);
begin
  btnRemoveClick(Sender);
end;

procedure TfrmPrtClinicSel.PopulateSelected;
var
  i: Integer;
begin
  lvwSelectedClinics.Items.BeginUpdate;
  lvwSelectedClinics.Clear;
  if SelectedClinics.Count > 0 then
    for i := 0 to SelectedClinics.Count - 1 do
      lvwSelectedClinics.AddItem(TBCMA_ReportItemList(SelectedClinics[i]).ItemName,
        SelectedClinics[i]);
  lvwSelectedClinics.Items.EndUpdate;
  lvwSelectedClinics.Enabled := (lvwSelectedClinics.items.Count <> 0);

  CheckListItems;
end; // PopulateSelected

procedure TfrmPrtClinicSel.PopulateSearchResults;
var
  i: integer;
begin
  lvwSearchResults.Items.BeginUpdate;
  lvwSearchResults.Clear;
  if ClinicList.Count > 0 then
    for i := 0 to ClinicList.Count - 1 do
      lvwSearchResults.AddItem(TBCMA_ReportItemList(ClinicList[i]).ItemName,
        ClinicList[i]);
  lvwSearchResults.Items.EndUpdate;

  lvwSearchResults.Enabled := (lvwSearchResults.items.Count <> 0);

  CheckListItems;
end; // PopulateSearchResults

procedure TfrmPrtClinicSel.btnAddAllClick(Sender: TObject);
begin
  lvwSearchResults.SelectAll;
  btnAdd.Click;
end;

procedure TfrmPrtClinicSel.btnAddClick(Sender: TObject);
var
  Item: TListItem;
begin
  Item := lvwSearchresults.Selected;
  while Item <> nil do begin
    SelectedClinics.Add(Item.Data);
    ClinicList.Remove(Item.Data);

    lvwSelectedClinics.AddItem(Item.Caption, Item.Data);
    lvwSearchResults.Items.Delete(Item.Index);

    Item := lvwSearchResults.GetNextItem(Item, sdAll, [isSelected])
  end;

  CheckListItems;
  if lvwSearchResults.Items.Count <> 0 then
    lvwSearchResults.SetFocus;

end;

procedure TfrmPrtClinicSel.btnRemoveAllClick(Sender: TObject);
begin
  lvwSelectedClinics.SelectAll;
  btnRemove.Click;
end;

procedure TfrmPrtClinicSel.btnRemoveClick(Sender: TObject);
var
  Item: TListItem;
begin
  Item := lvwSelectedClinics.Selected;
  while Item <> nil do begin
    ClinicList.Add(Item.Data);
    SelectedClinics.Remove(Item.Data);

    lvwSearchResults.AddItem(Item.Caption, Item.Data);
    lvwSelectedClinics.Items.Delete(Item.Index);

    Item := lvwSelectedClinics.GetNextItem(Item, sdAll, [isSelected])
  end;

  CheckListItems;
  if lvwSelectedClinics.Items.Count <> 0 then
    lvwSelectedClinics.SetFocus;
end;

procedure TfrmPrtClinicSel.btnSearchClick(Sender: TObject);
var
  ret: Boolean;
begin
  ret := False; // rpk 8/17/2012
  btnSearch.Enabled := false;
  with BCMA_UserParameters do begin // rpk 6/26/2012
    ClinSrchPrefix := edtSearchPrefix.Text;
    ClinSrchText := edtSearchText.Text;
  end;
  ret := BCMA_Report.LoadClinicList(edtSearchPrefix.Text, edtSearchText.Text);
  if ret then begin
    PopulateSearchResults;
  end;
  edtSearchText.SelectAll;
  edtSearchText.SetFocus;
  btnSearch.Enabled := True;
end;

end.

