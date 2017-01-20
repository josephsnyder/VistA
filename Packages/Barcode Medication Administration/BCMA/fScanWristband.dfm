object frmScanWristband: TfrmScanWristband
  Left = 717
  Top = 333
  HelpContext = 33
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'BCMA - Scan Patient Wristband'
  ClientHeight = 163
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bvlLine: TBevel
    Left = 16
    Top = 71
    Width = 263
    Height = 9
    Shape = bsBottomLine
  end
  object lblScannerStatusCaption: TLabel
    Left = 80
    Top = 21
    Width = 76
    Height = 13
    Caption = 'Scanner Status:'
  end
  object btnEnableScanner: TButton
    Left = 8
    Top = 133
    Width = 89
    Height = 25
    Caption = '&Enable Scanner'
    Enabled = False
    TabOrder = 0
    OnClick = btnEnableScannerClick
  end
  object btnUnableToScan: TButton
    Left = 103
    Top = 133
    Width = 89
    Height = 25
    Caption = '&Unable to Scan'
    TabOrder = 1
    OnClick = btnUnableToScanClick
  end
  object btnCancel: TButton
    Left = 200
    Top = 133
    Width = 89
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object edtScannerInput: TEdit
    Left = 81
    Top = 111
    Width = 0
    Height = 19
    AutoSize = False
    Ctl3D = False
    MaxLength = 50
    ParentCtl3D = False
    TabOrder = 4
    OnEnter = edtScannerInputEnter
    OnExit = edtScannerInputExit
    OnKeyDown = edtScannerInputKeyDown
    OnKeyPress = edtScannerInputKeyPress
    OnKeyUp = edtScannerInputKeyUp
  end
  object pnlScannerStatus: TPanel
    Left = 95
    Top = 40
    Width = 105
    Height = 25
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clLime
    ParentBackground = False
    TabOrder = 5
    OnClick = edtScannerInputEnter
  end
  object lblScannerStatus: TVA508StaticText
    Name = 'lblScannerStatus'
    Left = 162
    Top = 19
    Width = 63
    Height = 15
    Alignment = taLeftJustify
    AutoSize = True
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Not Ready'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = True
    ParentFont = False
    TabOrder = 3
    TabStop = True
    ShowAccelChar = True
  end
  object lblScanPatientWristband: TVA508StaticText
    Name = 'lblScanPatientWristband'
    Left = 80
    Top = 96
    Width = 137
    Height = 15
    Alignment = taLeftJustify
    AutoSize = True
    Caption = 'Scan Patient Wristband'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = True
    ParentFont = False
    TabOrder = 6
    TabStop = True
    ShowAccelChar = True
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 240
    Top = 96
    Data = (
      (
        'Component = frmScanWristband'
        'Status = stsDefault')
      (
        'Component = btnUnableToScan'
        'Status = stsDefault')
      (
        'Component = btnEnableScanner'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = pnlScannerStatus'
        'Status = stsDefault')
      (
        'Component = edtScannerInput'
        'Status = stsDefault')
      (
        'Component = lblScannerStatus'
        'Label = lblScannerStatusCaption'
        'Status = stsOK')
      (
        'Component = lblScanPatientWristband'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault'))
  end
end
