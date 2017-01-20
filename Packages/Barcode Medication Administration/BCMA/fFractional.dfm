object frmFractional: TfrmFractional
  Left = 683
  Top = 429
  HelpContext = 132
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Confirmation'
  ClientHeight = 320
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlInformation: TPanel
    Left = 0
    Top = 0
    Width = 339
    Height = 97
    Align = alTop
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 0
    object lblDispensedDrugIdent: TLabel
      Left = 8
      Top = 32
      Width = 241
      Height = 13
      AutoSize = False
      Caption = 'Dispensed Drug:'
      FocusControl = lblDispensedDrugName
    end
    object lblPerDoseIdent: TLabel
      Left = 8
      Top = 72
      Width = 110
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ordered units per dose:'
    end
    object lblWarning: TVA508StaticText
      Name = 'lblWarning'
      Left = 127
      Top = 0
      Width = 81
      Height = 26
      Alignment = taCenter
      Caption = 'Warning'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      ShowAccelChar = True
    end
    object lblDispensedDrugName: TVA508StaticText
      Name = 'lblDispensedDrugName'
      Left = 33
      Top = 43
      Width = 7
      Height = 15
      Alignment = taLeftJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      TabStop = True
      ShowAccelChar = True
    end
    object lblUnitsPerDose: TVA508StaticText
      Name = 'lblUnitsPerDose'
      Left = 131
      Top = 72
      Width = 7
      Height = 15
      Alignment = taLeftJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      TabStop = True
      ShowAccelChar = True
    end
  end
  object pnlUnits: TPanel
    Left = 0
    Top = 228
    Width = 339
    Height = 92
    Align = alBottom
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 1
    Visible = False
    object CheckBox2: TCheckBox
      Tag = 2
      Left = 136
      Top = 57
      Width = 97
      Height = 17
      Caption = 'CheckBox2'
      TabOrder = 2
      OnKeyPress = CheckBox2KeyPress
      OnMouseUp = CheckBox2MouseUp
    end
    object CheckBox1: TCheckBox
      Tag = 1
      Left = 33
      Top = 57
      Width = 97
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 1
      OnKeyPress = CheckBox2KeyPress
      OnMouseUp = CheckBox2MouseUp
    end
    object btnOK: TButton
      Left = 245
      Top = 53
      Width = 57
      Height = 25
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 3
    end
    object Memo1: TMemo
      Left = 8
      Top = 6
      Width = 200
      Height = 35
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'Select the number of units scanned that '
        'will be recorded in BCMA:')
      ReadOnly = True
      TabOrder = 0
      OnEnter = Memo1Enter
    end
  end
  object pnlBackPartial: TPanel
    Left = 0
    Top = 97
    Width = 339
    Height = 131
    Align = alClient
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 2
    object btnBack: TButton
      Left = 245
      Top = 20
      Width = 57
      Height = 25
      Caption = '&Back'
      Default = True
      ModalResult = 2
      TabOrder = 3
    end
    object btnPartial: TButton
      Left = 245
      Top = 84
      Width = 57
      Height = 25
      Caption = '&Partial'
      TabOrder = 4
      OnClick = btnPartialClick
    end
    object memInfo1: TMemo
      Left = 8
      Top = 16
      Width = 217
      Height = 39
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'You did not scan all of the units for this '
        'dispensed drug. Click the BACK button '
        'to scan additional units.')
      ReadOnly = True
      TabOrder = 0
      OnEnter = memInfo1Enter
    end
    object memInfo2: TMemo
      Left = 8
      Top = 80
      Width = 217
      Height = 33
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'Click the PARTIAL button to confirm the '
        'number of units that have been scanned.')
      ReadOnly = True
      TabOrder = 2
      OnEnter = memInfo2Enter
    end
    object lblInfo2: TVA508StaticText
      Name = 'lblInfo2'
      Left = 96
      Top = 59
      Width = 42
      Height = 15
      Alignment = taCenter
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Caption = '--  OR  --'
      ParentColor = True
      TabOrder = 1
      ShowAccelChar = True
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 296
    Top = 8
    Data = (
      (
        'Component = btnBack'
        'Status = stsDefault')
      (
        'Component = pnlBackPartial'
        'Status = stsDefault')
      (
        'Component = frmFractional'
        'Status = stsDefault')
      (
        'Component = pnlUnits'
        'Status = stsDefault')
      (
        'Component = lblWarning'
        'Status = stsDefault')
      (
        'Component = CheckBox1'
        'Status = stsDefault')
      (
        'Component = CheckBox2'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = memInfo1'
        'Status = stsDefault')
      (
        'Component = memInfo2'
        'Status = stsDefault')
      (
        'Component = lblInfo2'
        'Status = stsDefault')
      (
        'Component = btnPartial'
        'Status = stsDefault')
      (
        'Component = Memo1'
        'Status = stsDefault')
      (
        'Component = pnlInformation'
        'Status = stsDefault')
      (
        'Component = lblDispensedDrugName'
        'Label = lblDispensedDrugIdent'
        'Status = stsOK')
      (
        'Component = lblUnitsPerDose'
        'Label = lblPerDoseIdent'
        'Status = stsOK'))
  end
end
