object frmInjSite: TfrmInjSite
  Left = 0
  Top = 0
  Caption = 'frmInjSite'
  ClientHeight = 456
  ClientWidth = 699
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 64
    Top = 40
    Width = 250
    Height = 150
    Columns = <>
    TabOrder = 0
  end
  object ListView2: TListView
    Left = 80
    Top = 272
    Width = 250
    Height = 150
    Columns = <>
    TabOrder = 1
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 600
    Top = 40
    Data = (
      (
        'Component = ListView1'
        'Status = stsDefault')
      (
        'Component = ListView2'
        'Status = stsDefault'))
  end
end
