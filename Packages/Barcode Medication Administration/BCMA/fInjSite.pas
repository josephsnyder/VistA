unit fInjSite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VA508AccessibilityManager, VA508AccessibilityRouter, StdCtrls,
  ExtCtrls, ComCtrls;

type
  TfrmInjSite = class(TForm)
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    ListView1: TListView;
    ListView2: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInjSite: TfrmInjSite;

procedure ShowInjSite;

implementation

{$R *.dfm}

procedure ShowInjSite;
//var
//  frmInjSite: TfrmInjSite;
begin

  frmInjSite := TfrmInjSite.Create(Application);
  try
    frmInjSite.ShowModal;
  finally
    frmInjSite.Free;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmInjSite);
end.
