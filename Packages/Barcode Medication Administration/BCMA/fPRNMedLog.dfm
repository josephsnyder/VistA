object frmPRNMedLog: TfrmPRNMedLog
  Left = 622
  Top = 189
  HelpContext = 44
  ActiveControl = cbxReason
  BorderIcons = []
  BorderStyle = bsSingle
  BorderWidth = 10
  Caption = 'PRN Medication Log'
  ClientHeight = 558
  ClientWidth = 660
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlData: TPanel
    Left = 0
    Top = 0
    Width = 660
    Height = 558
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      660
      558)
    object bvlLine1: TBevel
      Left = 4
      Top = 376
      Width = 649
      Height = 3
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
    end
    object lblActiveMed: TLabel
      Left = 0
      Top = 1
      Width = 88
      Height = 13
      Caption = '&Active Medication:'
      FocusControl = lblActiveMedicationName
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblDispensedDrug: TLabel
      Left = 0
      Top = 19
      Width = 79
      Height = 13
      Caption = '&Dispensed Drug:'
      FocusControl = lstDispensedDrugs
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblSpecialInstructions: TLabel
      Left = 0
      Top = 127
      Width = 177
      Height = 13
      Caption = '&Special Instructions / Other Print Info:'
      FocusControl = memSpecialInstructions
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblSelectReason: TLabel
      Left = 419
      Top = 408
      Width = 85
      Height = 13
      Anchors = [akRight, akBottom]
      Caption = 'Select a  &Reason:'
      FocusControl = cbxReason
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblPainScore: TLabel
      Left = 419
      Top = 463
      Width = 55
      Height = 13
      Anchors = [akRight, akBottom]
      Caption = '&Pain Score:'
      FocusControl = cbxPainScore
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblLastFourActions: TLabel
      Left = -1
      Top = 242
      Width = 85
      Height = 13
      Caption = '&Last Four Actions:'
      FocusControl = lvwLastFourActions
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object memSpecialInstructions: TMemo
      Left = 0
      Top = 147
      Width = 660
      Height = 86
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMM' +
          'MMMMM MMMM'
        
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMM' +
          'MMMMM MMMM'
        
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMM' +
          'MMMMM MMMM'
        
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMM' +
          'MMMMM MMMM'
        
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMM' +
          'MMMMM MMMM'
        
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMM' +
          'MMMMM MMMM'
        
          'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMM' +
          'MMMMM MMMM')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 10
      WantReturns = False
      OnEnter = memSpecialInstructionsEnter
    end
    object lstDispensedDrugs: TListBox
      Left = 0
      Top = 38
      Width = 378
      Height = 81
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 7
    end
    inline fraVitals1: TfraVitals
      Left = 384
      Top = 26
      Width = 276
      Height = 93
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      TabStop = True
      OnEnter = fraVitals1Enter
      OnExit = fraVitals1Exit
      ExplicitLeft = 384
      ExplicitTop = 26
      ExplicitWidth = 276
      ExplicitHeight = 93
      inherited lblVitals: TLabel
        Width = 276
        Caption = '&Vitals (click + for the last four):'
        FocusControl = fraVitals1
        ExplicitWidth = 141
      end
      inherited grdVitals: TStringGrid
        Width = 276
        Height = 80
        ExplicitWidth = 276
        ExplicitHeight = 80
        RowHeights = (
          24
          24
          24
          24
          24)
      end
      inherited lvwVitals: TListView
        Width = 276
        Height = 80
        Anchors = [akTop, akRight, akBottom]
        ExplicitWidth = 276
        ExplicitHeight = 80
      end
      inherited imglstVitals: TImageList
        Left = 248
        Top = 16
      end
    end
    object cbxPainScore: TComboBox
      Left = 419
      Top = 477
      Width = 216
      Height = 21
      AutoCloseUp = True
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 0
      ParentFont = False
      TabOrder = 2
      OnChange = cbxPainScoreChange
      OnEnter = cbxPainScoreEnter
      OnExit = cbxPainScoreExit
      OnKeyPress = cbxPainScoreKeyPress
    end
    object grpAcknowledge: TGroupBox
      Left = 16
      Top = 388
      Width = 337
      Height = 130
      TabOrder = 0
      object imgIcon: TImage
        Left = 19
        Top = 40
        Width = 49
        Height = 49
        Transparent = True
      end
      object lblScheduleCaption: TLabel
        Left = 83
        Top = 23
        Width = 58
        Height = 13
        Caption = 'Schedule:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblLastActionCaption: TLabel
        Left = 83
        Top = 42
        Width = 66
        Height = 13
        Caption = 'Last Given:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object chkAck: TCheckBox
        Left = 83
        Top = 86
        Width = 251
        Height = 33
        Caption = 
          '&I have reviewed the schedule and last administration of this me' +
          'dication.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        WordWrap = True
      end
      object lblSchedule: TVA508StaticText
        Name = 'lblSchedule'
        Left = 155
        Top = 22
        Width = 56
        Height = 15
        Alignment = taLeftJustify
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'Schedule'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 0
        ShowAccelChar = True
      end
      object lblLastActionSinceLast: TVA508StaticText
        Name = 'lblLastActionSinceLast'
        Left = 155
        Top = 43
        Width = 132
        Height = 15
        Alignment = taLeftJustify
        AutoSize = True
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'lblLastActionSinceLast'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 1
        ShowAccelChar = True
      end
      object lblLastActionDateTime: TVA508StaticText
        Name = 'lblLastActionDateTime'
        Left = 155
        Top = 63
        Width = 130
        Height = 15
        Alignment = taLeftJustify
        AutoSize = True
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'lblLastActionDateTime'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 2
        ShowAccelChar = True
      end
    end
    object lblUnitsGivenMessage: TVA508StaticText
      Name = 'lblUnitsGivenMessage'
      Left = 0
      Top = 359
      Width = 413
      Height = 15
      Alignment = taLeftJustify
      Caption = 
        '*  Units Given do not display in the table above for orders with' +
        ' multiple dispensed drugs.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 12
      TabStop = True
      ShowAccelChar = True
    end
    object pnlLastFourActions: TPanel
      Left = 0
      Top = 258
      Width = 724
      Height = 94
      Caption = 'pnlLastFourActions'
      TabOrder = 11
      object grdLastFourActions: TStringGrid
        Left = 1
        Top = 1
        Width = 722
        Height = 92
        Align = alClient
        RowCount = 3
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 1
        OnEnter = grdLastFourActionsEnter
        OnSelectCell = grdLastFourActionsSelectCell
        ColWidths = (
          64
          64
          64
          64
          64)
      end
      object lvwLastFourActions: TListView
        Left = 1
        Top = 1
        Width = 722
        Height = 92
        Align = alClient
        Columns = <
          item
            Caption = 'Date/Time'
            MinWidth = 20
            Width = 150
          end
          item
            Caption = 'Action'
            MinWidth = 20
            Width = 100
          end
          item
            Caption = 'Type'
            MinWidth = 20
            Width = 100
          end
          item
            Caption = 'Reason'
            MinWidth = 20
            Width = 150
          end
          item
            Caption = 'Units Given'
            MinWidth = 20
            Width = 99
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        GridLines = True
        ReadOnly = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
        OnEnter = lvwLastFourActionsEnter
      end
    end
    object lblActiveMedicationName: TVA508StaticText
      Name = 'lblActiveMedicationName'
      Left = 94
      Top = 0
      Width = 122
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Caption = 'lblActiveMedicationName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 6
      TabStop = True
      ShowAccelChar = True
    end
    object btnOK: TButton
      Left = 376
      Top = 523
      Width = 81
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 3
    end
    object btnCancel: TButton
      Left = 465
      Top = 523
      Width = 81
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 4
    end
    object btnMedHistory: TButton
      Left = 554
      Top = 523
      Width = 81
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'M&ed History'
      TabOrder = 5
      OnClick = btnMedHistoryClick
    end
    object cbxReason: TComboBox
      Left = 419
      Top = 422
      Width = 216
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 0
      ParentFont = False
      TabOrder = 1
      OnChange = cbxReasonChange
      OnEnter = cbxReasonEnter
      OnKeyPress = cbxReasonKeyPress
    end
    object pnlScrollDown: TPanel
      Left = 183
      Top = 120
      Width = 477
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'pnlScrollDown'
      TabOrder = 9
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
        TabOrder = 1
        OnClick = btnDisplaySIOPIClick
      end
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 224
    Data = (
      (
        'Component = lblUnitsGivenMessage'
        'Status = stsDefault')
      (
        'Component = frmPRNMedLog'
        'Text = PRN Medication Log'
        'Status = stsOK')
      (
        'Component = lstDispensedDrugs'
        'Label = lblDispensedDrug'
        'Status = stsOK')
      (
        'Component = memSpecialInstructions'
        'Label = lblSpecialInstructions'
        'Status = stsOK')
      (
        'Component = grpAcknowledge'
        'Status = stsDefault')
      (
        'Component = chkAck'
        'Status = stsDefault')
      (
        'Component = cbxPainScore'
        'Label = lblPainScore'
        'Status = stsOK')
      (
        'Component = fraVitals1.lvwVitals'
        'Label = fraVitals1.lblVitals'
        'Status = stsOK')
      (
        'Component = fraVitals1.grdVitals'
        'Label = fraVitals1.lblVitals'
        'Status = stsOK')
      (
        'Component = pnlData'
        'Status = stsDefault')
      (
        'Component = pnlLastFourActions'
        'Status = stsDefault')
      (
        'Component = lvwLastFourActions'
        'Label = lblLastFourActions'
        'Status = stsOK')
      (
        'Component = grdLastFourActions'
        'Label = lblLastFourActions'
        'Status = stsOK')
      (
        'Component = lblActiveMedicationName'
        'Label = lblActiveMed'
        'Status = stsOK')
      (
        'Component = fraVitals1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnMedHistory'
        'Status = stsDefault')
      (
        'Component = cbxReason'
        'Label = lblSelectReason'
        'Status = stsOK')
      (
        'Component = lblSchedule'
        'Label = lblScheduleCaption'
        'Status = stsOK')
      (
        'Component = lblLastActionSinceLast'
        'Label = lblLastActionCaption'
        'Status = stsOK')
      (
        'Component = lblLastActionDateTime'
        'Label = lblLastActionCaption'
        'Status = stsOK')
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
  object VA508ComponentAccessLFA: TVA508ComponentAccessibility
    Component = grdLastFourActions
    OnValueQuery = VA508ComponentAccessLFAValueQuery
    Left = 256
  end
  object VA508ComponentAccessVitals: TVA508ComponentAccessibility
    Component = fraVitals1.grdVitals
    OnValueQuery = VA508ComponentAccessVitalsValueQuery
    Left = 296
  end
end
