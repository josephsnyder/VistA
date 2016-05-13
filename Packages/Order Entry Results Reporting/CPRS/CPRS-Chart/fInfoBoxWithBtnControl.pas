unit fInfoBoxWithBtnControl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  VA508AccessibilityManager;

//type
//  TfrmInfoBoxWithBtnControl = class(TForm)
//    Panel1: TPanel;
//    Splitter1: TSplitter;
//    GridPanel1: TGridPanel;
//    lblText: TVA508StaticText;
//    Button1: TButton;
//    Button2: TButton;
//    Button3: TButton;
//    Button4: TButton;
//
//    procedure btnClick(Sender: TObject);
//    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//  private
//    { Private declarations }
//    value: integer;
//    procedure setControl(var btn: TButton; text: string; show: boolean; index: integer = 0);
//    function buttonText: string;
//    procedure sizePanel;
//  public
//    { Public declarations }
//  end;

//function processMessage(caption, text: string; buttons: TStringList): integer;
function DefMessageDlg(const Msg: string; DlgType: TMsgDlgType; list: TStringList;
        const aCaption: string = ''; NoDefault: Boolean = false): Integer;

//var
//  frmInfoBoxWithBtnControl: TfrmInfoBoxWithBtnControl;

implementation

uses ORFn;

{$R *.dfm}

function DefMessageDlg(const Msg: string; DlgType: TMsgDlgType; list: TStringList;
          const aCaption: string = ''; NoDefault: Boolean = false): Integer;


var
  Dlg: TForm;
  i, j, cnt, btnLast, btnPos, btnSpace, btnNum, value: integer;
  btn: TButton;
//  zPnl: TPanel;
  str: string;
//  bforeground, bfocused, bactive,
//  bres: Boolean;
//  BytesAllocated: longInt;
  Buttons: TMsgDlgButtons;

begin
//  Dlg := nil; // rpk 4/23/2009
//  zPnl := nil; // rpk 4/23/2009

//  BytesAllocated := GetHeapStatus.TotalAllocated;

  //map captions to the following button
  //    (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore,
  //    mbAll, mbNoToAll, mbYesToAll, mbHelp, mbClose);
  Result := -1;
  cnt := list.Count;
  case cnt of
        4:
        begin
          str := list.Strings[0];
          SetPiece(str, U, 3, 'Yes');
          list.Strings[0] := str;
          str := list.Strings[1];
          SetPiece(str, U, 3, 'No');
          list.Strings[1] := str;
          str := list.Strings[2];
          SetPiece(str, U, 3, 'Cancel');
          list.Strings[2] := str;
          str := list.Strings[3];
          SetPiece(str, U, 3, 'Abort');
          list.Strings[3] := str;
          Buttons := [mbYes, mbNo, mbCancel, mbAbort];
        end;
        3:
        begin
          str := list.Strings[0];
          SetPiece(str, U, 3, 'Yes');
          list.Strings[0] := str;
          str := list.Strings[1];
          SetPiece(str, U, 3, 'No');
          list.Strings[1] := str;
          str := list.Strings[2];
          SetPiece(str, U, 3, 'Cancel');
          list.Strings[2] := str;
          Buttons := [mbYes, mbNo, mbCancel];
        end;
        2:
        begin
          str := list.Strings[0];
          SetPiece(str, U, 3, 'Yes');
          list.Strings[0] := str;
          str := list.Strings[1];
          SetPiece(str, U, 3, 'No');
          list.Strings[1] := str;
          Buttons := [mbYes, mbNo];
        end;
        1:
        begin
          str := list.Strings[0];
          SetPiece(str, U, 3, 'Yes');
          list.Strings[0] := str;
          Buttons := [mbYes];
        end;
  end;
  Dlg := CreateMessageDialog(Msg, DlgType, buttons);
  if Dlg <> nil then begin // rpk 5/14/2013
    try
      btnPos := 0;
      btnSpace := 0;
      btnNum := 0;
      btnLast := 0;
      //determine the existing space between buttons
      for i := 0 to Dlg.ComponentCount - 1 do
        if Dlg.Components[i] is TButton then begin
          btn := TButton(Dlg.Components[i]);
          if btnNum = 0 then btnlast := btn.Left + btn.Width
          else btnSpace := (btn.Left + btn.Width) - btnlast;
          inc(btnNum);
          if btnNum = 2 then break;
        end;
      if btnSpace = 0 then btnSpace := 10;

      for i := 0 to Dlg.ComponentCount - 1 do
        if Dlg.Components[i] is TButton then begin
          btn := TButton(Dlg.Components[i]);
          for j := 0 to list.count-1 do
            begin
              str := list.Strings[j];
              if (Piece(str, U, 3) = btn.Name) then
                begin
                  btn.Caption := Piece(str, u, 1);
                  SetPiece(str, U, 4, IntToStr(btn.modalResult));
                  list.Strings[j] := str;
                  if Piece(str, U, 2) = 'true' then
                    begin
                      btn.default := true;
                      btn.tabstop := true;
                    end
                  else
                    begin
                      btn.default := false;
                      btn.tabstop := false;
                    end;
                end;
            end;
          btn.Width :=  TextWidthByFont(btn.Handle, btn.caption);
          btn.Left := btnPos + btnSpace;
          //if btn.Left < btnPos then btn.Left := btnPos + btnSpace;
          btnPos := btn.Left + btn.Width;
          If NoDefault then
          begin
            btn.default := false;
            btn.tabstop := false;
            dlg.ActiveControl := nil;
            dlg.DefocusControl(btn, False);
          end;
      end;
      if dlg.Width < (btnPos + btnSpace) then dlg.Width := btnPos + btnSpace;

    finally
    end;

    try // rpk 2/23/2012
    //This will cover that hopefully rare scenario that the message box receives so
    //much text that it tries to expand right off the screen.
      with Dlg do
        if Height > Screen.WorkAreaHeight then begin
          AutoScroll := True;
          Top := Screen.WorkAreaTop;
          Height := Screen.WorkAreaHeight;
          Width := TLabel(FindComponent('Message')).Width +
            TImage(FindComponent('Image')).Width + 60;
        end;

      // center on main form
      Dlg.Position := poMainFormCenter; // rpk 10/25/2012

// NOTE: fsStayOnTop: Don't use
// This form remains on top of the DESKTOP and of other forms in the project,
// except any others that also have FormStyle set to fsStayOnTop.
// If one fsStayOnTop form launches another, neither form will consistently remain on top.

//      Dlg.FormStyle := fsStayOnTop; // rpk 10/25/2013

//      if HelpCtx > 0 then begin // rpk 5/14/2013
//        Dlg.HelpType := htContext; // rpk 5/14/2013
//        Dlg.HelpContext := HelpCtx; // rpk 5/9/2013
//      end;

      if aCaption = '' then
        case DlgType of
          mtWarning:
            Dlg.Caption := 'Warning';
          mtError:
            Dlg.Caption := 'Error';
          mtInformation:
            Dlg.Caption := 'Information';
          mtConfirmation:
            Dlg.Caption := 'Confirmation';
        end
      else
        Dlg.Caption := aCaption;

//      BytesAllocated := GetHeapStatus.TotalAllocated;
       //not sure if this is needed
//      zPnl := TPanel.Create(Application);
//      if zPnl <> nil then begin // rpk 5/14/2013
//        try // rpk 2/23/2012
//
//          BytesAllocated := GetHeapStatus.TotalAllocated;
//
//          with zPnl do begin
//            Caption := msg;
//            Left := 0; // rpk 5/14/2013
//            Parent := Dlg;
//            Height := 1;
//            Width := 1;
//          end;

          dlg.BringToFront; // use BringToFront to move dlg to top of form stack;  rpk 10/25/2013


          value := Dlg.ShowModal;
          result := value;
          for j := 0 to list.count-1 do
            begin
              str := list.Strings[j];
              if (Piece(str, U, 4) = IntToStr(value)) then
                begin
                  Result := j;
                  break;
                end;
            end;
//        finally // rpk 3/9/2009
//          zPnl.Free; // rpk 3/9/2009
          ;
//        end; // rpk 3/9/2009
//      end; // if zPnl <> nil
    finally // rpk 3/9/2009
      Dlg.Release; // rpk 6/18/2013
  //    bres := ShowApplicationAndFocusOK(Application);
    end; // rpk 3/9/2009
  end; // if Dlg <> nil

//  BytesAllocated := GetHeapStatus.TotalAllocated;

end; // DefMessageDlg


//function processMessage(caption, text: string; buttons: TStringList): integer;
//var
//cnt: integer;
//str: string;
//btn: TButton;
//begin
//  result := -1;
//  try
//    begin
//      frmInfoBoxWithBtnControl := TfrmInfoBoxWithBtnControl.Create(Application);
//      ResizeAnchoredFormToFont(frmInfoBoxWithBtnControl);
//      frmInfoBoxWithBtnControl.value := -1;
//      frmInfoBoxWithBtnControl.Caption := caption;
//      frmInfoBoxWithBtnControl.lblText.Caption := text +
//        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut odio ex, semper dictum auctor et, bibendum faucibus nunc. Class ' + CRLF +
//        'aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent quis ornare odio. Donec nulla ' + CRLF +
//        'nulla, gravida at mi vel, porta pulvinar neque. Nullam commodo sem quam, vitae pharetra felis scelerisque sed. Phasellus ' + CRLF +
//        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut odio ex, semper dictum auctor et, bibendum faucibus nunc. Class ' + CRLF +
//        'aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent quis ornare odio. Donec nulla ' + CRLF +
//        'nulla, gravida at mi vel, porta pulvinar neque. Nullam commodo sem quam, vitae pharetra felis scelerisque sed. Phasellus ' + CRLF +
//                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut odio ex, semper dictum auctor et, bibendum faucibus nunc. Class ' + CRLF +
//        'aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent quis ornare odio. Donec nulla ' + CRLF +
//        'nulla, gravida at mi vel, porta pulvinar neque. Nullam commodo sem quam, vitae pharetra felis scelerisque sed. Phasellus ' + CRLF +
//        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut odio ex, semper dictum auctor et, bibendum faucibus nunc. Class ' + CRLF +
//        'aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent quis ornare odio. Donec nulla ' + CRLF +
//        'nulla, gravida at mi vel, porta pulvinar neque. Nullam commodo sem quam, vitae pharetra felis scelerisque sed. Phasellus ' + CRLF;
//      frmInfoBoxWithBtnControl.sizePanel;
//      cnt := buttons.Count;
//      case cnt of
//        4:
//        begin
//          str := buttons.Strings[0];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button1, str, true, 0);
//          str := buttons.Strings[1];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button2, str, true, 1);
//          str := buttons.Strings[2];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button3, str, true, 2);
//          str := buttons.Strings[3];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button4, str, true, 3);
//        end;
//        3:
//        begin
//          str := buttons.Strings[0];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button1, str, true, 0);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[0].Value := 33.00;
//          str := buttons.Strings[1];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button2, str, true, 1);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[1].Value :=33.00;
//          str := buttons.Strings[2];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button3, str, true, 2);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[2].Value := 33.00;
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button4, '', false);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[3].Value := 0;
//        end;
//        2:
//        begin
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button1, '', false);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[0].Value := 0;
//          str := buttons.Strings[0];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button2, str, true, 0);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[1].Value := 50.00;
//          str := buttons.Strings[1];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button3, str, true, 1);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[2].Value := 50.00;
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button4, '', false);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[3].Value := 0;
//        end;
//        1:
//        begin
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button1, '', false);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[0].Value := 0;
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button2, '', false);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[1].Value := 0;
//          str := buttons.Strings[0];
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button3, str, true, 0);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[2].Value := 100;
//          frmInfoBoxWithBtnControl.setControl(frmInfoBoxWithBtnControl.Button4, '', false);
//          frmInfoBoxWithBtnCOntrol.GridPanel1.ColumnCollection[3].Value := 0;
//        end;
//      end;
//      frmInfoBoxWithBtnControl.GridPanel1.Refresh;
//      if frmInfoBoxWithBtnControl.ShowModal > -1 then
//        begin
//          result := frmInfoBoxWithBtnControl.value;
//        end;
//    end;
//  finally
//
//  end;
//
//end;
//
//{ TfrmInfoBoxWithBtnControl }
//
//
//
//procedure TfrmInfoBoxWithBtnControl.btnClick(Sender: TObject);
//var
//btn: TButton;
//begin
//    btn := Sender as TButton;
//    if btn.Tag < 0 then modalResult := -1
//    else
//      begin
//        modalResult := btn.Tag;
//        frmInfoBoxWithBtnControl.value := btn.tag;
////        frmInfoBoxWithBtnControl.CloseModal;
//        close;
//      end;
//end;
//
//function TfrmInfoBoxWithBtnControl.buttonText: string;
//begin
//   result := '';
//   if (self.Button1.Enabled) and (self.Button1.Visible) then result := result + CRLF + self.Button1.Caption;
//   if (self.Button2.Enabled) and (self.Button2.Visible) then result := result + CRLF + self.Button2.Caption;
//   if (self.Button3.Enabled) and (self.Button3.Visible) then result := result + CRLF + self.Button3.Caption;
//   if (self.Button4.Enabled) and (self.Button4.Visible) then result := result + CRLF + self.Button4.Caption;
//
//end;
//
//procedure TfrmInfoBoxWithBtnControl.FormClose(Sender: TObject;
//  var Action: TCloseAction);
//begin
//    try
//    inherited;
//    Action := caFree;
//  except
//    Action := caFree;
//  end;
//end;
//
//procedure TfrmInfoBoxWithBtnControl.FormCloseQuery(Sender: TObject;
//  var CanClose: Boolean);
//var
//str: string;
//begin
//    if self.value < 0 then
//      begin
//        CanClose := false;
//        str := self.buttonText;
//        if (self.GridPanel1.CellCount = 1) then
//          InfoBox('You must select the button ' + CRLF + str + CRLF + CRLF + 'To exit the form', 'Error', MB_OK)
//          else
//            InfoBox('You must select one of the buttons '+ CRLF + str + CRLF + CRLF + 'To exit the form', 'Error', MB_OK);
//      end;
//end;
//
//procedure TfrmInfoBoxWithBtnControl.setControl(var btn:TButton; text: string; show: boolean; index: integer);
//begin
//  if show = false then
//          begin
//            btn.Visible := false;
//            btn.Enabled := false;
//          end
//        else
//          begin
//            btn.Caption := text;
//            btn.Width := TextWidthByFont(btn.Handle, btn.Caption) + 5;
//            btn.Height := TextHeightByFont(btn.Handle, btn.Caption) + 10;
//            btn.Tag := index;
//          end;
//end;
//
//procedure TfrmInfoBoxWithBtnControl.sizePanel;
//begin
//    self.lblText.Width :=  TextWidthByFont(self.lblText.Handle, self.lblText.Caption) + 5;
//    //self.lblText.Height :=  TextWidthByFont(self.lblText.Handle, self.lblText.Caption) + 10;
////    self.Panel1.Width := self.lblText.Left + self.lblText.Width + 5;
////    self.Panel1.Height := self.lblText.Top + self.lblText.Height + 5;
////    infoBox('Width: ' + IntToStr(self.Panel1.Width) + CRLF + 'Heigth: ' + IntToStr(self.Panel1.Height), 'begin',MB_OK);
////    self.Panel1.Width := self.lblText.Left + TextWidthByFont(self.lblText.Handle, self.lblText.Caption) + 5;
////    self.Panel1.Height := self.lblText.Top + TextWidthByFont(self.lblText.Handle, self.lblText.Caption) + 5;
////    infoBox('Width: ' + IntToStr(self.Panel1.Width) + CRLF + 'Heigth: ' + IntToStr(self.Panel1.Height), 'end',MB_OK);
////    self.width := self.Panel1.Left + self.Panel1.Width + 5;
//////    self.height := self.Panel1.Height + self.GridPanel1.Height + 5;
////    self.Resize;
////    self.Height := self.GridPanel1.Top + self.GridPanel1.Height;
//end;

end.
