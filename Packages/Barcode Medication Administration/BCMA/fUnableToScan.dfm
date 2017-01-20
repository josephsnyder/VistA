object frmUnableToScan: TfrmUnableToScan
  Left = 587
  Top = 235
  HelpContext = 108
  ActiveControl = cbxReasons
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'BCMA - Unable to Scan'
  ClientHeight = 610
  ClientWidth = 741
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlAdminInfo: TPanel
    Left = 0
    Top = 0
    Width = 741
    Height = 395
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      741
      395)
    object bvlAdminInfo: TBevel
      Left = 168
      Top = 11
      Width = 555
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
      ExplicitWidth = 353
    end
    object imgUnitsPerDose: TImage
      Left = 8
      Top = 110
      Width = 17
      Height = 20
      Proportional = True
      Transparent = True
    end
    object lblDispensedMeds: TLabel
      Left = 32
      Top = 312
      Width = 206
      Height = 13
      Caption = '&Dispensed Drugs / Medications / Solutions:'
      FocusControl = lvwMedications
    end
    object lblMedicationCaption: TLabel
      Left = 32
      Top = 29
      Width = 55
      Height = 13
      Caption = 'Medication:'
    end
    object lblSchedAdminTimeCaption: TLabel
      Left = 32
      Top = 50
      Width = 112
      Height = 13
      Caption = 'Scheduled Admin Time:'
    end
    object lblScheduleTypeCaption: TLabel
      Left = 32
      Top = 71
      Width = 75
      Height = 13
      Caption = 'Schedule Type:'
    end
    object lblLastActionCaption: TLabel
      Left = 32
      Top = 134
      Width = 56
      Height = 13
      Caption = 'Last Action:'
    end
    object lblBagIDCaption: TLabel
      Left = 32
      Top = 155
      Width = 36
      Height = 13
      Caption = 'Bag ID:'
    end
    object lblDosageCaption: TLabel
      Left = 32
      Top = 92
      Width = 114
      Height = 13
      Caption = 'Dosage / Infusion Rate:'
    end
    object lblUnitsPerDoseCaption: TLabel
      Left = 32
      Top = 113
      Width = 74
      Height = 13
      Caption = 'Units Per Dose:'
    end
    object lblMedRouteCaption: TLabel
      Left = 32
      Top = 176
      Width = 87
      Height = 13
      Caption = 'Medication Route:'
    end
    object lblAdminInfo: TLabel
      Left = 8
      Top = 8
      Width = 147
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Administration Information'
      FocusControl = lblMedication
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSpecInstr: TLabel
      Left = 32
      Top = 197
      Width = 177
      Height = 13
      Caption = '&Special Instructions / Other Print Info:'
      FocusControl = mmoSpecialInstructions
    end
    object lvwMedications: TListView
      Left = 32
      Top = 328
      Width = 683
      Height = 66
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      Columns = <
        item
          AutoSize = True
          Caption = 'Name'
        end>
      ColumnClick = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 10
      ViewStyle = vsReport
      OnEnter = lvwMedicationsEnter
    end
    object mmoSpecialInstructions: TMemo
      Left = 32
      Top = 217
      Width = 683
      Height = 90
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
        'MMMMMMMMM MMMM'
        'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
        'MMMMMMMMM MMMM'
        'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
        'MMMMMMMMM MMMM'
        'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
        'MMMMMMMMM MMMM'
        'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
        'MMMMMMMMM MMMM'
        'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
        'MMMMMMMMM MMMM'
        'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
        'MMMMMMMMM MMMM')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 9
      WantReturns = False
      OnEnter = mmoSpecialInstructionsEnter
    end
    object lblMedication: TVA508StaticText
      Name = 'lblMedication'
      Left = 160
      Top = 29
      Width = 64
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblMedication'
      ParentColor = True
      TabOrder = 0
      TabStop = True
      ShowAccelChar = True
    end
    object lblSchedAdminTime: TVA508StaticText
      Name = 'lblSchedAdminTime'
      Left = 160
      Top = 50
      Width = 95
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblSchedAdminTime'
      ParentColor = True
      TabOrder = 1
      TabStop = True
      ShowAccelChar = True
    end
    object lblScheduleType: TVA508StaticText
      Name = 'lblScheduleType'
      Left = 160
      Top = 71
      Width = 81
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblScheduleType'
      ParentColor = True
      TabOrder = 2
      TabStop = True
      ShowAccelChar = True
    end
    object lblLastAction: TVA508StaticText
      Name = 'lblLastAction'
      Left = 160
      Top = 134
      Width = 62
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblLastAction'
      ParentColor = True
      TabOrder = 5
      TabStop = True
      ShowAccelChar = True
    end
    object lblBagID: TVA508StaticText
      Name = 'lblBagID'
      Left = 160
      Top = 155
      Width = 42
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblBagID'
      ParentColor = True
      TabOrder = 6
      TabStop = True
      ShowAccelChar = True
    end
    object lblDosage: TVA508StaticText
      Name = 'lblDosage'
      Left = 160
      Top = 92
      Width = 49
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblDosage'
      ParentColor = True
      TabOrder = 3
      TabStop = True
      ShowAccelChar = True
    end
    object lblUnitsPerDose: TVA508StaticText
      Name = 'lblUnitsPerDose'
      Left = 160
      Top = 113
      Width = 77
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblUnitsPerDose'
      ParentColor = True
      TabOrder = 4
      TabStop = True
      ShowAccelChar = True
    end
    object lblMedRoute: TVA508StaticText
      Name = 'lblMedRoute'
      Left = 160
      Top = 176
      Width = 62
      Height = 15
      Alignment = taLeftJustify
      Caption = 'lblMedRoute'
      ParentColor = True
      TabOrder = 7
      TabStop = True
      ShowAccelChar = True
    end
    object pnlScrollDown: TPanel
      Left = 238
      Top = 190
      Width = 477
      Height = 27
      Caption = 'pnlScrollDown'
      TabOrder = 8
      DesignSize = (
        477
        27)
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
        Anchors = [akTop, akRight]
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
  object pnlUserInput: TPanel
    Left = 0
    Top = 395
    Width = 741
    Height = 141
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      741
      141)
    object bvlUnableToScanReason: TBevel
      Left = 156
      Top = 15
      Width = 559
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
      ExplicitWidth = 426
    end
    object lblReason: TLabel
      Left = 32
      Top = 31
      Width = 40
      Height = 13
      Caption = '&Reason:'
      FocusControl = cbxReasons
    end
    object lblEnterAComment: TLabel
      Left = 32
      Top = 54
      Width = 269
      Height = 13
      Caption = '&Enter a Comment (Optional)    (150 Characters Maximum):'
      FocusControl = memComment
    end
    object lblUnableToScanReason: TLabel
      Left = 14
      Top = 9
      Width = 136
      Height = 13
      Caption = 'Unable to Scan Reason'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbxReasons: TComboBox
      Left = 84
      Top = 27
      Width = 217
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
      OnChange = cbxReasonsChange
      OnEnter = cbxReasonsEnter
    end
    object memComment: TMemo
      Left = 32
      Top = 73
      Width = 683
      Height = 57
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 150
      TabOrder = 1
      WantReturns = False
      OnEnter = memCommentEnter
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 536
    Width = 741
    Height = 74
    Align = alClient
    Anchors = [akBottom]
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      741
      74)
    object Bevel1: TBevel
      Left = 116
      Top = -21
      Width = 513
      Height = 7
      Anchors = [akBottom]
      Shape = bsBottomLine
      ExplicitLeft = 49
      ExplicitTop = 2
    end
    object imgIcon: TImage
      Left = 14
      Top = 6
      Width = 49
      Height = 49
      Anchors = [akLeft, akBottom]
      Transparent = True
      Visible = False
    end
    object lblClickOK: TLabel
      Left = 591
      Top = 6
      Width = 100
      Height = 15
      Alignment = taCenter
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'Click OK to Continue'
    end
    object btnOK: TButton
      Left = 570
      Top = 28
      Width = 65
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 658
      Top = 28
      Width = 65
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object mmoMessage: TMemo
      Left = 69
      Top = 6
      Width = 305
      Height = 59
      Anchors = [akLeft, akBottom]
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Lines.Strings = (
        'NOTICE: Selecting OK and continuing with this '
        'administration will document all dispensed drugs, '
        'additives and/or solutions. This dialogue can not be '
        'used to administer a partial dose.')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      OnEnter = mmoMessageEnter
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 504
    Top = 56
    Data = (
      (
        'Component = frmUnableToScan'
        'Status = stsDefault')
      (
        'Component = lblMedication'
        'Label = lblMedicationCaption'
        'Status = stsOK')
      (
        'Component = lblSchedAdminTime'
        'Label = lblSchedAdminTimeCaption'
        'Status = stsOK')
      (
        'Component = lblScheduleType'
        'Label = lblScheduleTypeCaption'
        'Status = stsOK')
      (
        'Component = lblDosage'
        'Label = lblDosageCaption'
        'Status = stsOK')
      (
        'Component = lblUnitsPerDose'
        'Label = lblUnitsPerDoseCaption'
        'Status = stsOK')
      (
        'Component = lblLastAction'
        'Label = lblLastActionCaption'
        'Status = stsOK')
      (
        'Component = lblBagID'
        'Label = lblBagIDCaption'
        'Status = stsOK')
      (
        'Component = lblMedRoute'
        'Label = lblMedRouteCaption'
        'Status = stsOK')
      (
        'Component = mmoSpecialInstructions'
        'Label = lblSpecInstr'
        'Status = stsOK')
      (
        'Component = lvwMedications'
        'Label = lblDispensedMeds'
        'Status = stsOK')
      (
        'Component = cbxReasons'
        'Label = lblReason'
        'Status = stsOK')
      (
        'Component = memComment'
        'Text = Enter an optional comment. 150 characters maximum. '
        'Status = stsOK')
      (
        'Component = btnOK'
        'Label = lblClickOK'
        'Status = stsOK')
      (
        'Component = btnCancel'
        'Text = Cancel button'
        'Status = stsOK')
      (
        'Component = pnlAdminInfo'
        'Status = stsDefault')
      (
        'Component = pnlUserInput'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = mmoMessage'
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
