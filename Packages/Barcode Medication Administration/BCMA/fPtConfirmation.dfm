object frmPtConfirmation: TfrmPtConfirmation
  Left = 777
  Top = 442
  HelpContext = 33
  ActiveControl = btnCancel
  BorderIcons = [biHelp]
  BorderStyle = bsDialog
  Caption = 'BCMA - Patient Confirmation'
  ClientHeight = 489
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDemographics: TPanel
    Left = 0
    Top = 0
    Width = 604
    Height = 97
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object lblSSN: TLabel
      Left = 16
      Top = 24
      Width = 25
      Height = 13
      Caption = '&SSN:'
      FocusControl = edtSSN
    end
    object lblName: TLabel
      Left = 16
      Top = 8
      Width = 31
      Height = 13
      Caption = '&Name:'
      FocusControl = edtName
    end
    object lblWard: TLabel
      Left = 362
      Top = 8
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = '&Ward:'
      FocusControl = edtWard
    end
    object lblRmBd: TLabel
      Left = 353
      Top = 40
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = '&Rm-Bd:'
      FocusControl = edtRmBd
    end
    object lblDOB: TLabel
      Left = 16
      Top = 40
      Width = 26
      Height = 13
      Caption = 'DO&B:'
      FocusControl = edtDOB
    end
    object edtName: TEdit
      Left = 64
      Top = 7
      Width = 290
      Height = 14
      AutoSize = False
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'edtName'
    end
    object edtSSN: TEdit
      Left = 64
      Top = 23
      Width = 281
      Height = 14
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'edtSSN'
    end
    object edtDOB: TEdit
      Left = 64
      Top = 39
      Width = 281
      Height = 14
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = 'edtDOB'
    end
    object edtWard: TEdit
      Left = 400
      Top = 7
      Width = 281
      Height = 14
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      Text = 'edtWard'
    end
    object edtRmBd: TEdit
      Left = 400
      Top = 39
      Width = 281
      Height = 14
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = 'edtRmBd'
    end
    object pnlMessage: TPanel
      Left = 8
      Top = 59
      Width = 593
      Height = 30
      BevelOuter = bvNone
      TabOrder = 5
      TabStop = True
      OnEnter = pnlMessageEnter
      OnExit = pnlMessageExit
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 448
    Width = 604
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      604
      41)
    object btnOK: TButton
      Left = 432
      Top = 7
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Yes'
      Enabled = False
      ModalResult = 1
      TabOrder = 2
    end
    object btnCancel: TButton
      Left = 511
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 3
    end
    object btnContinue: TButton
      Left = 351
      Top = 7
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Accept'
      TabOrder = 1
      OnClick = btnContinueClick
    end
    object cbSpeedbump_Patient_Identifiers: TCheckBox
      Left = 28
      Top = 6
      Width = 285
      Height = 29
      Caption = 
        '&I have confirmed this patient'#39's identity using two acceptable f' +
        'orms of patient identifiers.'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      WordWrap = True
      OnClick = cbSpeedbump_Patient_IdentifiersClick
    end
  end
  object grpSensitive: TGroupBox
    Left = 0
    Top = 283
    Width = 604
    Height = 128
    Align = alTop
    Caption = 'Sensitive Record Access'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object memSensitiveMSG: TMemo
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 594
      Height = 105
      Align = alClient
      Alignment = taCenter
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'memSensitiveMSG')
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
    end
  end
  object grpPatientFlags: TGroupBox
    Left = 0
    Top = 225
    Width = 604
    Height = 58
    Align = alTop
    Caption = 'Patient &Flags:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    DesignSize = (
      604
      58)
    object memPatientFlags: TMemo
      Left = 9
      Top = 16
      Width = 504
      Height = 33
      Anchors = [akLeft, akTop, akRight]
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        '0123456789')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WantReturns = False
      OnEnter = memPatientFlagsEnter
    end
    object btnFlagDetails: TButton
      Left = 528
      Top = 20
      Width = 65
      Height = 25
      Caption = '&Details'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnFlagDetailsClick
    end
  end
  object grpAllergies: TGroupBox
    Left = 0
    Top = 97
    Width = 604
    Height = 128
    Align = alTop
    TabOrder = 2
    DesignSize = (
      604
      128)
    object lblAllergies: TLabel
      Left = 8
      Top = 12
      Width = 53
      Height = 13
      Caption = '&Allergies:'
      FocusControl = memAllergies
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblADRs: TLabel
      Left = 8
      Top = 68
      Width = 37
      Height = 13
      Caption = 'ADRs:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object memAllergies: TMemo
      Left = 8
      Top = 25
      Width = 587
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        '0123456789')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WantReturns = False
      OnEnter = memAllergiesEnter
    end
    object memADRs: TMemo
      Left = 9
      Top = 81
      Width = 587
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        '0123456789')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      WantReturns = False
      OnEnter = memADRsEnter
    end
  end
  object pnlButtonMessage: TPanel
    Left = 0
    Top = 411
    Width = 604
    Height = 37
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlButtonMessage'
    TabOrder = 5
    TabStop = True
    OnEnter = pnlButtonMessageEnter
    OnExit = pnlButtonMessageExit
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 552
    Top = 8
    Data = (
      (
        'Component = frmPtConfirmation'
        'Status = stsDefault')
      (
        'Component = edtName'
        'Label = lblName'
        'Status = stsOK')
      (
        'Component = edtSSN'
        'Label = lblSSN'
        'Status = stsOK')
      (
        'Component = edtDOB'
        'Label = lblDOB'
        'Status = stsOK')
      (
        'Component = edtWard'
        'Label = lblWard'
        'Status = stsOK')
      (
        'Component = edtRmBd'
        'Label = lblRmBd'
        'Status = stsOK')
      (
        'Component = memAllergies'
        'Label = lblAllergies'
        'Status = stsOK')
      (
        'Component = memADRs'
        'Label = lblADRs'
        'Status = stsOK')
      (
        'Component = memPatientFlags'
        'Status = stsDefault')
      (
        'Component = grpAllergies'
        'Status = stsDefault')
      (
        'Component = grpPatientFlags'
        'Status = stsDefault')
      (
        'Component = grpSensitive'
        'Status = stsDefault')
      (
        'Component = cbSpeedbump_Patient_Identifiers'
        'Status = stsDefault')
      (
        'Component = memSensitiveMSG'
        'Status = stsDefault'))
  end
end
