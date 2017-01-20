object frmScanIV: TfrmScanIV
  Left = 597
  Top = 353
  HelpContext = 163
  ActiveControl = memComment
  BorderIcons = []
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Scan IV'
  ClientHeight = 580
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  DesignSize = (
    569
    580)
  PixelsPerInch = 96
  TextHeight = 13
  object grpBagInformation: TGroupBox
    Left = 0
    Top = 0
    Width = 569
    Height = 417
    Align = alTop
    Caption = 'Bag Information'
    TabOrder = 0
    DesignSize = (
      569
      417)
    object lblMedsSolns: TLabel
      Left = 3
      Top = 78
      Width = 109
      Height = 13
      Caption = '&Medication / Solutions:'
      FocusControl = lstMedicationSolutions
    end
    object lblCurBagStatusCaption: TLabel
      Left = 8
      Top = 15
      Width = 112
      Height = 13
      Alignment = taRightJustify
      Caption = 'Current &Bag Status:'
      FocusControl = lblScanStatus
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblIVBagNumberCaption: TLabel
      Left = 8
      Top = 34
      Width = 75
      Height = 13
      Caption = 'IV Bag Number:'
      FocusControl = lblBagNumber
    end
    object lblRouteCaption: TLabel
      Left = 8
      Top = 50
      Width = 87
      Height = 13
      Caption = 'Medication Route:'
      FocusControl = lblRouteText
    end
    object lblOtherPrintInfo: TLabel
      Left = 3
      Top = 186
      Width = 74
      Height = 13
      Caption = 'Other &Print Info:'
      FocusControl = memOtherPrintInfo
    end
    object lstMedicationSolutions: TListBox
      Left = 3
      Top = 97
      Width = 560
      Height = 83
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ExtendedSelect = False
      ItemHeight = 13
      TabOrder = 3
    end
    object grpOrderChanges: TGroupBox
      Left = 3
      Top = 296
      Width = 563
      Height = 115
      Anchors = [akLeft, akTop, akRight]
      Caption = 'O&rder Changes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      DesignSize = (
        563
        115)
      object memOrderChanges: TRichEdit
        Left = 3
        Top = 12
        Width = 557
        Height = 100
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        OnEnter = memOrderChangesEnter
      end
    end
    object lblRouteText: TVA508StaticText
      Name = 'lblRouteText'
      Left = 99
      Top = 49
      Width = 55
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'Route Text'
      ParentColor = True
      TabOrder = 2
      TabStop = True
      ShowAccelChar = True
    end
    object lblScanStatus: TVA508StaticText
      Name = 'lblScanStatus'
      Left = 126
      Top = 14
      Width = 7
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      TabStop = True
      ShowAccelChar = True
    end
    object lblBagNumber: TVA508StaticText
      Name = 'lblBagNumber'
      Left = 99
      Top = 32
      Width = 5
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      ParentColor = True
      TabOrder = 1
      TabStop = True
      ShowAccelChar = True
    end
    object memOtherPrintInfo: TMemo
      Left = 3
      Top = 205
      Width = 563
      Height = 87
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      Lines.Strings = (
        
          'LINE 1 XX MMMM WWWW XXXX MMMM WWWW MMMM XXXX WWWW MMMM XXXX WWWW' +
          ' '
        'WWWW MMMM '
        'XXXXXXXXXX'
        'XXXXXXXXXX'
        'XXXXXXXXXX'
        'XXXXXXXXXX'
        'XXXXXXXXXX')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object pnlScrollDown: TPanel
      Left = 89
      Top = 179
      Width = 477
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'pnlScrollDown'
      TabOrder = 4
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 411
    Width = 569
    Height = 136
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    DesignSize = (
      569
      136)
    object lblEnterComment: TLabel
      Left = 3
      Top = 6
      Width = 212
      Height = 13
      Caption = 'E&nter a Comment (150 Characters Maximum):'
      FocusControl = memComment
    end
    object Label11: TLabel
      Left = 305
      Top = 80
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Select an &Action:'
      FocusControl = cbxAction
    end
    object Label12: TLabel
      Left = 262
      Top = 108
      Width = 112
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Select an &Injection Site:'
      FocusControl = cbxInjectionSite
    end
    object memComment: TMemo
      Left = 8
      Top = 24
      Width = 552
      Height = 49
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 150
      ScrollBars = ssVertical
      TabOrder = 0
      WantReturns = False
    end
    object cbxAction: TComboBox
      Left = 392
      Top = 77
      Width = 169
      Height = 21
      Style = csDropDownList
      Anchors = [akRight]
      ItemHeight = 0
      TabOrder = 1
      OnChange = cbxActionChange
      OnEnter = cbxActionEnter
    end
    object cbxInjectionSite: TComboBox
      Left = 380
      Top = 105
      Width = 180
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akRight]
      ItemHeight = 0
      TabOrder = 2
      OnEnter = cbxInjectionSiteEnter
    end
  end
  object btnOK: TButton
    Left = 414
    Top = 553
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 494
    Top = 552
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Top = 528
    Data = (
      (
        'Component = frmScanIV'
        'Status = stsDefault')
      (
        'Component = cbxAction'
        'Label = Label11'
        'Status = stsOK')
      (
        'Component = grpBagInformation'
        'Status = stsDefault')
      (
        'Component = lblRouteText'
        'Label = lblRouteCaption'
        'Status = stsOK')
      (
        'Component = lstMedicationSolutions'
        'Label = lblMedsSolns'
        'Status = stsOK')
      (
        'Component = memOrderChanges'
        'Status = stsDefault')
      (
        'Component = grpOrderChanges'
        'Status = stsDefault')
      (
        'Component = memComment'
        'Label = lblEnterComment'
        'Status = stsOK')
      (
        'Component = cbxInjectionSite'
        'Label = Label12'
        'Status = stsOK')
      (
        'Component = lblScanStatus'
        'Label = lblCurBagStatusCaption'
        'Status = stsOK')
      (
        'Component = lblBagNumber'
        'Label = lblIVBagNumberCaption'
        'Status = stsOK')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = memOtherPrintInfo'
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
