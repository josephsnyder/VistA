unit BCMA_IV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ImgList, Menus, Grids,
  VA508AccessibilityManager, VA508AccessibilityRouter;

type
  TfraIV = class(TFrame)
    spltIV1: TSplitter;
    ImageList1: TImageList;                          
    Panel1: TPanel;
    Panel2: TPanel;
    hdrIVBagDetail: THeaderControl;
    Panel3: TPanel;
    tvwIVHistory: TTreeView;
    mnuIVHistory: TPopupMenu;
    mnuAddComment: TMenuItem;
    mnuMark: TMenuItem;
    mnuMissingDose: TMenuItem;
    mnuHeld: TMenuItem;
    mnuRefused: TMenuItem;
    lblIVHistory: TLabel;
    Panel4: TPanel;
    lstIVBagDetail: TListBox;
    stBagDetail: TStaticText;
    sgIVBagDetail: TStringGrid;

    procedure sgIVBagDetailSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    SelectedIVX, SelectedIVY: Integer;
  end;

implementation

{$R *.DFM}

procedure TfraIV.sgIVBagDetailSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  SelectedIVX := ACol;
  SelectedIVY := ARow;
end;

end.

