object frmSelectReason: TfrmSelectReason
  Left = 920
  Top = 404
  HelpContext = 35
  ActiveControl = cbxSelections
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 10
  Caption = 'Selection Form'
  ClientHeight = 113
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 15
  object pnlButton: TPanel
    Left = 0
    Top = 78
    Width = 288
    Height = 35
    Align = alBottom
    Anchors = [akRight]
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 120
      Top = 5
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 208
      Top = 5
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 288
    Height = 78
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object lblSelectCaption: TLabel
      Left = 33
      Top = 20
      Width = 74
      Height = 15
      Caption = '&Selection List'
      FocusControl = cbxSelections
    end
    object cbxSelections: TComboBox
      Left = 33
      Top = 36
      Width = 223
      Height = 23
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
      OnEnter = cbxSelectionsEnter
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 64
    Top = 80
    Data = (
      (
        'Component = frmSelectReason'
        'Status = stsDefault')
      (
        'Component = cbxSelections'
        'Label = lblSelectCaption'
        'Status = stsOK')
      (
        'Component = Button1'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault'))
  end
end
