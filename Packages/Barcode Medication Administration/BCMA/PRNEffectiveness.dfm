object frmPRNEffectiveness: TfrmPRNEffectiveness
  Left = 410
  Top = 195
  HelpContext = 51
  ActiveControl = lvwPRNList
  BorderIcons = []
  BorderStyle = bsSingle
  BorderWidth = 2
  Caption = 'PRN Effectiveness Log'
  ClientHeight = 549
  ClientWidth = 707
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
  object pnlOrderInfo: TPanel
    Left = 0
    Top = 0
    Width = 707
    Height = 369
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 2
    DesignSize = (
      707
      369)
    object lblDispensedDrug: TLabel
      Left = 20
      Top = 39
      Width = 82
      Height = 13
      Caption = 'Dispensed Drug: '
      FocusControl = lstDispensedDrugs
    end
    object lblSpecInstructions: TLabel
      Left = 18
      Top = 149
      Width = 177
      Height = 13
      Caption = 'Special Instructions / Other Print Info:'
      FocusControl = mmoSpecialInstructions
    end
    object lblAddComment: TLabel
      Left = 20
      Top = 256
      Width = 308
      Height = 13
      Caption = 'Enter a PRN Effectiveness Co&mment:  (150 Characters Maximum)'
      FocusControl = memAddComment
    end
    object lblSelectedAdministration: TLabel
      Left = 5
      Top = 5
      Width = 697
      Height = 20
      Align = alTop
      Alignment = taCenter
      Caption = 'Selected Administration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 192
    end
    object mmoSpecialInstructions: TMemo
      Left = 20
      Top = 169
      Width = 676
      Height = 85
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
      TabOrder = 9
      WantReturns = False
      OnEnter = mmoSpecialInstructionsEnter
    end
    object memAddComment: TMemo
      Left = 20
      Top = 270
      Width = 676
      Height = 32
      Anchors = [akLeft, akTop, akRight]
      Lines.Strings = (
        
          '0123456789012345678901234567890123456789012345678901234567890123' +
          '45678901234567890123456'
        '789012345678901234567890123456789012345678901234567890123456789')
      MaxLength = 150
      TabOrder = 0
      WantReturns = False
      OnKeyUp = memAddCommentKeyUp
    end
    object lstDispensedDrugs: TListBox
      Left = 18
      Top = 54
      Width = 399
      Height = 89
      Color = clBtnFace
      ItemHeight = 13
      TabOrder = 6
      OnEnter = lstDispensedDrugsEnter
    end
    object btnOK: TButton
      Left = 436
      Top = 318
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&OK'
      TabOrder = 2
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 517
      Top = 318
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      Enabled = False
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object btnMedHistory: TButton
      Left = 598
      Top = 318
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'M&ed History'
      Enabled = False
      TabOrder = 4
      OnClick = btnMedHistoryClick
    end
    inline fraVitals1: TfraVitals
      Left = 423
      Top = 41
      Width = 273
      Height = 102
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 7
      TabStop = True
      OnEnter = fraVitals1Enter
      OnExit = fraVitals1Exit
      ExplicitLeft = 423
      ExplicitTop = 41
      ExplicitWidth = 273
      ExplicitHeight = 102
      inherited lblVitals: TLabel
        Width = 273
        FocusControl = fraVitals1
        ExplicitWidth = 141
      end
      inherited grdVitals: TStringGrid
        Width = 273
        Height = 89
        OnSelectCell = fraVitals1grdVitalsSelectCell
        ExplicitWidth = 273
        ExplicitHeight = 89
        ColWidths = (
          64
          144
          149)
        RowHeights = (
          24
          24
          24
          24
          24)
      end
      inherited lvwVitals: TListView
        Width = 273
        Height = 89
        Anchors = [akTop, akRight]
        ExplicitWidth = 273
        ExplicitHeight = 89
      end
      inherited imglstVitals: TImageList
        Left = 104
        Top = 72
      end
    end
    object grpPainScore: TGroupBox
      Left = 20
      Top = 303
      Width = 393
      Height = 49
      Caption = 'Pain Score'
      TabOrder = 1
      object lblPainScore: TLabel
        Left = 6
        Top = 22
        Width = 30
        Height = 13
        Caption = 'V&alue:'
        FocusControl = cbxPainScore
      end
      object lblDateTime: TLabel
        Left = 206
        Top = 22
        Width = 54
        Height = 13
        Caption = '&Date/Time:'
        FocusControl = edtDateTime
      end
      object cbxPainScore: TComboBox
        Left = 40
        Top = 18
        Width = 161
        Height = 21
        Hint = 'Enter the Pain Score'
        AutoCloseUp = True
        Style = csDropDownList
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = cbxPainScoreChange
        OnKeyPress = cbxPainScoreKeyPress
      end
      object edtDateTime: TEdit
        Left = 264
        Top = 17
        Width = 121
        Height = 21
        Hint = 'Enter the date and the time that the Pain Score was taken'
        CharCase = ecUpperCase
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnChange = edtDateTimeChange
        OnExit = edtDateTimeExit
      end
    end
    object lblActiveMedication: TVA508StaticText
      Name = 'lblActiveMedication'
      Left = 20
      Top = 25
      Width = 93
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'Active Medication: '
      ParentColor = True
      TabOrder = 5
      TabStop = True
      ShowAccelChar = True
    end
    object pnlScrollDown: TPanel
      Left = 219
      Top = 142
      Width = 477
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'pnlScrollDown'
      TabOrder = 8
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
  object pnlButton: TPanel
    Left = 0
    Top = 516
    Width = 707
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = pnlButtonResize
    DesignSize = (
      707
      33)
    object btnExit: TButton
      Left = 605
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop]
      Caption = 'E&xit'
      ModalResult = 2
      TabOrder = 0
    end
    object lblUnitsGiven: TVA508StaticText
      Name = 'lblUnitsGiven'
      Left = 20
      Top = 8
      Width = 413
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 
        '*  Units Given do not display in the table above for orders with' +
        ' multiple dispensed drugs.'
      ParentColor = True
      TabOrder = 1
      TabStop = True
      ShowAccelChar = True
    end
  end
  object pnlPRNList: TPanel
    Left = 0
    Top = 369
    Width = 707
    Height = 147
    Align = alClient
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    DesignSize = (
      707
      147)
    object lblPRNList: TLabel
      Left = 20
      Top = 7
      Width = 213
      Height = 13
      Caption = '&PRN List (Select administration to document):'
      FocusControl = lvwPRNList
    end
    object grdPRNList: TStringGrid
      Left = 16
      Top = 26
      Width = 684
      Height = 105
      ColCount = 6
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
      TabOrder = 1
      OnClick = grdPRNListClick
      OnDblClick = grdPRNListDblClick
      OnKeyDown = grdPRNListKeyDown
      OnSelectCell = grdPRNListSelectCell
      ColWidths = (
        64
        64
        64
        64
        64
        65)
    end
    object lvwPRNList: TListView
      Left = 16
      Top = 26
      Width = 682
      Height = 105
      Anchors = [akLeft, akRight, akBottom]
      Columns = <
        item
          Caption = 'Orderable Item'
          MinWidth = 20
          Width = 150
        end
        item
          Caption = 'Units Given'
          MinWidth = 20
          Width = 75
        end
        item
          Caption = 'Administration Time'
          MinWidth = 20
          Width = 125
        end
        item
          Caption = 'Reason Given'
          MinWidth = 20
          Width = 100
        end
        item
          Caption = 'Administered By'
          Width = 100
        end
        item
          Caption = 'Location'
          Width = 100
        end>
      GridLines = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      ShowWorkAreas = True
      TabOrder = 0
      ViewStyle = vsReport
      OnColumnClick = lvwPRNListColumnClick
      OnDblClick = lvwPRNListDblClick
      OnEnter = lvwPRNListEnter
      OnKeyPress = lvwPRNListKeyPress
      OnSelectItem = lvwPRNListSelectItem
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 152
    Top = 8
    Data = (
      (
        'Component = frmPRNEffectiveness'
        'Status = stsDefault')
      (
        'Component = pnlOrderInfo'
        'Status = stsDefault')
      (
        'Component = lstDispensedDrugs'
        'Label = lblDispensedDrug'
        'Status = stsOK')
      (
        'Component = fraVitals1.grdVitals'
        'Label = fraVitals1.lblVitals'
        'Status = stsOK')
      (
        'Component = cbxPainScore'
        'Label = lblPainScore'
        'Status = stsOK')
      (
        'Component = edtDateTime'
        'Label = lblDateTime'
        'Status = stsOK')
      (
        'Component = mmoSpecialInstructions'
        'Label = lblSpecInstructions'
        'Status = stsOK')
      (
        'Component = memAddComment'
        'Label = lblAddComment'
        'Status = stsOK')
      (
        'Component = lvwPRNList'
        'Label = lblPRNList'
        'Status = stsOK')
      (
        'Component = grdPRNList'
        'Label = lblPRNList'
        'Status = stsOK')
      (
        'Component = pnlButton'
        'Status = stsDefault')
      (
        'Component = lblUnitsGiven'
        'Status = stsDefault')
      (
        'Component = pnlPRNList'
        'Status = stsDefault')
      (
        'Component = fraVitals1'
        'Status = stsDefault')
      (
        'Component = lblActiveMedication'
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
  object VA508ComponentAccessPRNList: TVA508ComponentAccessibility
    Component = grdPRNList
    OnValueQuery = VA508ComponentAccessPRNListValueQuery
    Left = 184
    Top = 8
  end
  object VA508ComponentAccessVitals: TVA508ComponentAccessibility
    Component = fraVitals1.grdVitals
    OnValueQuery = VA508ComponentAccessVitalsValueQuery
    Left = 216
    Top = 8
  end
end
