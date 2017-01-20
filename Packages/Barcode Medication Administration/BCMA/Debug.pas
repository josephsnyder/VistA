unit Debug;
{
================================================================================
*	File:  Debug.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 18 $  $Modtime: 6/06/01 8:33a $
*
*	Description:  This is the Debug Form for the application.  It is used by
*               TBCMA_Broker to display debugging information.
*
*	Notes:
*
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Printers, ComCtrls, VA508AccessibilityRouter;

type
  TfrmDebug = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnClose: TButton;
    btnPrint: TButton;
    Memo1: TRichEdit;
    chkDebug: TCheckBox;

    procedure btnCloseClick(Sender: TObject);
    (*
      Sets the ModalResult and closes the form.
    *)

    procedure btnPrintClick(Sender: TObject);
    procedure chkDebugClick(Sender: TObject);
    procedure Memo1Enter(Sender: TObject);
    (*
      Sends the Debug lines to the selected printer.
    *)

  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute(const Title, Header: string; txtList: TStrings);
    (*
      Creates frmDebug and enters initial header lines into the memo display.
      Enters a single header line into the display.  Writes the debug info to
      a log file and then shows frmDebug modally.
    *)
  end;

var
  frmDebug: TfrmDebug;

implementation
{$R *.DFM}

uses
  BCMA_Startup;

procedure TfrmDebug.btnPrintClick(Sender: TObject);
var
  i, j: integer;
begin
  with TPrintDialog.Create(Application) do
  begin
    if Execute then
    begin
      Printer.BeginDoc;
      Printer.Canvas.Font.Name := 'Courier New';
      Printer.Canvas.Font.Size := 8;
      j := 10;
      for i := 0 to Memo1.Lines.Count - 1 do
      begin
        Printer.Canvas.TextOut(10, j, Memo1.Lines[i]);
        j := j + Printer.Canvas.TextHeight('W') + 10;
        if j > (Printer.PageHeight - 150) then
        begin
          Printer.Newpage;
          j := 10;
        end;
      end;
      Printer.EndDoc;
    end;
    Free;
  end;
end;

procedure TfrmDebug.Execute(const Title, Header: string; txtList: TStrings);
var
  ii: integer;
  dtString: string;

  yy,
    mm,
    dd,
    hh,
    nn,
    ss,
    ms: word;
begin
  with TfrmDebug.Create(Application) do
  try
    Caption := 'DEBUG MODE: [' + Title + ']';
    decodeDate(Date, yy, mm, dd);
    decodeTime(Time, hh, nn, ss, ms);

    dtString := 'Date/Time Stamp: ' +
      Format('%2.2d/%2.2d/%4.4d %2.2d:%2.2d:%2.2d', [mm, dd, yy, hh, nn, ss]);
    with Memo1.Lines do
    begin
      Clear;
      Add('---------------------------------------------------------------------');
      Add('DEBUG Report');
      Add('Application:     ' + Application.Title);
      Add(dtString);
      Add('Port #: ' + PortString);
      Add('---------------------------------------------------------------------');
      Add(Header);
      if txtList <> nil then
        for ii := 0 to txtList.Count - 1 do
          Add('Results[' + IntToStr(ii) + '] = ' + txtList.Strings[ii]);

      Memo1.SelStart := 0;              // rpk 8/31/2010

      try
        SaveToFile('C:\TEMP\DEBUG.LOG');
      except
        on e: EFCreateError do
          MessageDlg('Could not write to log file:' + #13#13 +
            'C:\temp\debug.log' + #13#13 + e.Message, mtError, [mbOK], 0);
      end;
    end;

    showModal;
  finally
//    free;
    Release;                            // rpk 6/18/2013
  end;
end;

procedure TfrmDebug.Memo1Enter(Sender: TObject);
begin
  GetScreenReader.Speak(Memo1.text);    // rpk 9/7/2010
end;

procedure TfrmDebug.btnCloseClick(Sender: TObject);
begin
  //	ModalResult := mrCancel;
end;

procedure TfrmDebug.chkDebugClick(Sender: TObject);
begin
  if BCMA_Broker <> nil then
    with BCMA_Broker do
      DebugMode := chkDebug.Checked;
end;

end.
