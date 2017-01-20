object frmInputQry: TfrmInputQry
  Left = 402
  Top = 498
  HelpContext = 106
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
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object vstPrompt: TLabel
    Left = 12
    Top = 8
    Width = 47
    Height = 13
    Caption = 'vstPrompt'
    Color = clBtnFace
    ParentColor = False
  end
  object vstMaximum: TLabel
    Left = 254
    Top = 8
    Width = 116
    Height = 13
    Caption = 'Maximum Length = NNN'
    Color = clBtnFace
    FocusControl = edtInputQry
    ParentColor = False
  end
  object pnlButton: TPanel
    Left = 0
    Top = 84
    Width = 409
    Height = 35
    Align = alBottom
    Anchors = []
    BevelOuter = bvNone
    TabOrder = 2
    object btnOK: TButton
      Left = 208
      Top = 7
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 297
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
    Left = 12
    Top = 30
    Width = 360
    Height = 21
    TabOrder = 0
    OnChange = edtInputQryChange
    OnKeyPress = edtInputQryKeyPress
  end
  object chkCheckBox: TCheckBox
    Left = 12
    Top = 57
    Width = 360
    Height = 17
    Caption = 'chkCheckBox'
    TabOrder = 1
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 121
    Top = 78
    Data = (
      (
        'Component = frmInputQry'
        'Status = stsDefault')
      (
        'Component = edtInputQry'
        'Label = vstPrompt'
        'Status = stsOK'))
  end
end
