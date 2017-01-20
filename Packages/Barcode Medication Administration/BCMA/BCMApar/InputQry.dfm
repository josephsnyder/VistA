object frmInputQry: TfrmInputQry
  Left = 402
  Top = 498
  ActiveControl = edtInputQry
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 10
  ClientHeight = 119
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrompt: TLabel
    Left = 13
    Top = 11
    Width = 43
    Height = 13
    Caption = 'lblPrompt'
    FocusControl = edtInputQry
  end
  object lblMaximum: TLabel
    Left = 317
    Top = 11
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'ZZZZZZZZ'
  end
  object pnlButton: TPanel
    Left = 0
    Top = 84
    Width = 409
    Height = 35
    Align = alBottom
    Anchors = [akRight]
    BevelOuter = bvNone
    TabOrder = 0
    object btnOK: TButton
      Left = 216
      Top = 7
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 304
      Top = 7
      Width = 75
      Height = 25
      Caption = '&Cancel'
      Default = True
      ModalResult = 2
      TabOrder = 1
    end
  end
  object edtInputQry: TEdit
    Left = 13
    Top = 28
    Width = 360
    Height = 21
    TabOrder = 1
    OnChange = edtInputQryChange
    OnKeyPress = edtInputQryKeyPress
  end
  object chkCheckBox: TCheckBox
    Left = 13
    Top = 56
    Width = 180
    Height = 17
    Caption = 'chkCheckBox'
    TabOrder = 2
    OnClick = chkCheckBoxClick
  end
  object chkCheckBox2: TCheckBox
    Left = 200
    Top = 56
    Width = 173
    Height = 17
    Caption = 'chkCheckBox2'
    TabOrder = 3
    Visible = False
    OnClick = chkCheckBoxClick
  end
end
