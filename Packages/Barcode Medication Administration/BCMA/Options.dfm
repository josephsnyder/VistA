object frmOptions: TfrmOptions
  Left = 498
  Top = 350
  HelpContext = 126
  ActiveControl = chkDebug
  BorderStyle = bsSingle
  Caption = 'BCMA Options'
  ClientHeight = 195
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 392
    Height = 153
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 0
    TabStop = False
    object TabSheet1: TTabSheet
      Caption = 'General'
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 384
        Height = 121
        Caption = 'Session Options'
        TabOrder = 0
        object chkDebug: TCheckBox
          Left = 16
          Top = 24
          Width = 89
          Height = 17
          Caption = 'Debug Mode'
          TabOrder = 0
        end
        object Label1: TVA508StaticText
          Name = 'Label1'
          Left = 8
          Top = 96
          Width = 250
          Height = 15
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'NOTE: Session Options will be disabled upon log out'
          ParentColor = True
          TabOrder = 1
          TabStop = True
          ShowAccelChar = True
        end
      end
    end
  end
  object btnOK: TButton
    Left = 232
    Top = 160
    Width = 73
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 312
    Top = 160
    Width = 73
    Height = 25
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 136
    Top = 160
    Data = (
      (
        'Component = Label1'
        'Status = stsDefault')
      (
        'Component = frmOptions'
        'Status = stsDefault'))
  end
end
