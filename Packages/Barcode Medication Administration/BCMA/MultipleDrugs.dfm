object frmMultipleDrugs: TfrmMultipleDrugs
  Left = 548
  Top = 293
  HelpContext = 133
  BorderIcons = [biMinimize, biMaximize, biHelp]
  BorderStyle = bsSingle
  BorderWidth = 3
  Caption = 'Multiple Dose'
  ClientHeight = 478
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 404
    Width = 579
    Height = 74
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object pnlScannerStatus: TPanel
      Left = 0
      Top = 0
      Width = 209
      Height = 74
      Align = alLeft
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object lblScannerStatusCaption: TLabel
        Left = 4
        Top = 5
        Width = 76
        Height = 13
        Caption = '&Scanner Status:'
        FocusControl = lblScannerStatus
      end
      object pnlScannerIndicator: TPanel
        Left = 58
        Top = 39
        Width = 51
        Height = 21
        BevelOuter = bvLowered
        Color = clRed
        ParentBackground = False
        TabOrder = 0
        OnClick = pnlScannerIndicatorClick
      end
      object btnEnableScanner: TButton
        Left = 114
        Top = 35
        Width = 89
        Height = 25
        Caption = 'Ena&ble Scanner'
        TabOrder = 1
        OnClick = btnEnableScannerClick
      end
      object lblScannerStatus: TVA508StaticText
        Name = 'lblScannerStatus'
        Left = 86
        Top = 6
        Width = 39
        Height = 15
        Alignment = taLeftJustify
        Caption = 'Ready'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        ShowAccelChar = True
      end
    end
    object Panel3: TPanel
      Left = 447
      Top = 0
      Width = 132
      Height = 74
      Align = alRight
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object btnDone: TButton
        Left = 7
        Top = 36
        Width = 56
        Height = 25
        Caption = '&Done'
        ModalResult = 1
        TabOrder = 0
        OnClick = btnDoneClick
      end
      object btnCancel: TButton
        Left = 70
        Top = 36
        Width = 56
        Height = 25
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
    object pnlScannerInput: TPanel
      Left = 209
      Top = 0
      Width = 238
      Height = 74
      Align = alClient
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object Label6: TLabel
        Left = 14
        Top = 21
        Width = 75
        Height = 13
        Caption = 'Scan &Bar Code:'
      end
      object edtScannerInput: TEdit
        Left = 14
        Top = 40
        Width = 70
        Height = 9
        TabStop = False
        AutoSize = False
        MaxLength = 40
        TabOrder = 0
        OnEnter = edtScannerInputEnter
        OnExit = edtScannerInputExit
        OnKeyDown = edtScannerInputKeyDown
        OnKeyPress = edtScannerInputKeyPress
        OnKeyUp = edtScannerInputKeyUp
      end
    end
    object Panel5: TPanel
      Left = 215
      Top = 16
      Width = 93
      Height = 41
      BevelOuter = bvNone
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 579
    Height = 404
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 579
      Height = 201
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        579
        201)
      object lblActiveMedicationCaption: TLabel
        Left = 0
        Top = 10
        Width = 91
        Height = 13
        Caption = '&Active Medication: '
        Color = clBtnFace
        FocusControl = txtActiveMedication
        ParentColor = False
      end
      object lblSpecInstr: TLabel
        Left = 0
        Top = 61
        Width = 95
        Height = 13
        Caption = 'Special &Instructions:'
        FocusControl = mmoSpecialInstructions
      end
      object lblDosageUnits: TLabel
        Left = 0
        Top = 182
        Width = 77
        Height = 13
        Alignment = taCenter
        Caption = 'Doses &To Scan:'
        FocusControl = clbxDoses
      end
      object lblDosageOrderedCaption: TLabel
        Left = 0
        Top = 29
        Width = 84
        Height = 13
        Caption = 'Dosage &Ordered: '
        Color = clBtnFace
        FocusControl = txtDosage
        ParentColor = False
      end
      object mmoSpecialInstructions: TMemo
        Left = 0
        Top = 81
        Width = 579
        Height = 89
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
          'MMMMMMMMM MMMMMMMMM MMMM'
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
          'MMMMMMMMM MMMMMMMMM MMMM'
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
          'MMMMMMMMM MMMMMMMMM MMMM'
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
          'MMMMMMMMM MMMMMMMMM MMMM'
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
          'MMMMMMMMM MMMMMMMMM MMMM'
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
          'MMMMMMMMM MMMMMMMMM MMMM'
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
          'MMMMMMMMM MMMMMMMMM MMMM')
        ParentColor = True
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 3
        WantReturns = False
        OnEnter = mmoSpecialInstructionsEnter
        OnMouseDown = mmoSpecialInstructionsMouseDown
      end
      object txtActiveMedication: TVA508StaticText
        Name = 'txtActiveMedication'
        Left = 134
        Top = 9
        Width = 115
        Height = 15
        Alignment = taLeftJustify
        AutoSize = True
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'txtActiveMedication'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ShowAccelChar = True
      end
      object txtDosage: TVA508StaticText
        Name = 'txtDosage'
        Left = 134
        Top = 28
        Width = 60
        Height = 15
        Alignment = taLeftJustify
        AutoSize = True
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'txtDosage'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        ShowAccelChar = True
      end
      object pnlScrollDown: TPanel
        Left = 102
        Top = 54
        Width = 477
        Height = 27
        Anchors = [akTop, akRight]
        Caption = 'pnlScrollDown'
        TabOrder = 2
        object lblScrollDown: TStaticText
          Left = 8
          Top = 7
          Width = 316
          Height = 17
          Caption = '<Scroll down or click '#39'Display Instructions'#39' for full text>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object btnDisplaySIOPI: TButton
          Left = 340
          Top = 2
          Width = 129
          Height = 25
          Caption = 'Display I&nstructions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btnDisplaySIOPIClick
        end
      end
    end
    object pnlDoses: TPanel
      Left = 0
      Top = 201
      Width = 579
      Height = 95
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object clbxDoses: TCheckListBox
        Left = 0
        Top = 0
        Width = 579
        Height = 95
        OnClickCheck = clbxDosesClickCheck
        Align = alClient
        Color = clBtnFace
        Flat = False
        ItemHeight = 18
        Style = lbOwnerDrawFixed
        TabOrder = 0
        TabWidth = 3
        OnContextPopup = clbxDosesContextPopup
        OnDrawItem = clbxDosesDrawItem
        OnEnter = clbxDosesEnter
      end
    end
    object pnlComments: TPanel
      Left = 0
      Top = 296
      Width = 579
      Height = 108
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        579
        108)
      object lblEnterComment: TLabel
        Left = 0
        Top = 18
        Width = 266
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = '&Enter a Comment (Optional)   (150 Characters Maximum):'
        FocusControl = mmoComments
        ExplicitTop = 21
      end
      object mmoComments: TMemo
        Left = 0
        Top = 35
        Width = 579
        Height = 83
        Anchors = [akLeft, akRight, akBottom]
        MaxLength = 150
        TabOrder = 0
        OnEnter = mmoCommentsEnter
      end
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 512
    Top = 8
    Data = (
      (
        'Component = frmMultipleDrugs'
        'Status = stsDefault')
      (
        'Component = mmoSpecialInstructions'
        'Label = lblSpecInstr'
        'Status = stsOK')
      (
        'Component = clbxDoses'
        'Label = lblDosageUnits'
        'Status = stsOK')
      (
        'Component = mmoComments'
        'Label = lblEnterComment'
        'Status = stsOK')
      (
        'Component = txtActiveMedication'
        'Label = lblActiveMedicationCaption'
        'Status = stsOK')
      (
        'Component = txtDosage'
        'Label = lblDosageOrderedCaption'
        'Status = stsOK')
      (
        'Component = btnEnableScanner'
        'Status = stsDefault')
      (
        'Component = pnlScannerStatus'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = pnlScannerInput'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = pnlScannerIndicator'
        'Status = stsDefault')
      (
        'Component = edtScannerInput'
        'Text = Scanner Status: Ready'
        'Status = stsOK')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnDone'
        'Status = stsDefault')
      (
        'Component = lblScannerStatus'
        'Label = lblScannerStatusCaption'
        'Status = stsOK')
      (
        'Component = pnlDoses'
        'Status = stsDefault')
      (
        'Component = pnlScrollDown'
        'Status = stsDefault')
      (
        'Component = lblScrollDown'
        'Status = stsDefault')
      (
        'Component = btnDisplaySIOPI'
        'Status = stsDefault'))
  end
end
