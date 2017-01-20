object frmEditMedLog: TfrmEditMedLog
  Left = 411
  Top = 169
  HelpContext = 136
  ActiveControl = lblSSN
  BorderIcons = [biHelp]
  BorderStyle = bsDialog
  Caption = 'BCMA - Edit Med Log'
  ClientHeight = 492
  ClientWidth = 595
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grpMain: TGroupBox
    Left = 0
    Top = 0
    Width = 595
    Height = 131
    Align = alTop
    TabOrder = 0
    object imgCCOWStatus: TImage
      Left = 8
      Top = 88
      Width = 40
      Height = 37
      Hint = 'CCOW Status'
      ParentShowHint = False
      ShowHint = True
      Transparent = True
    end
    object lblPatientNameCaption: TLabel
      Left = 8
      Top = 16
      Width = 67
      Height = 13
      Caption = '&Patient Name:'
      FocusControl = lblPatientName
    end
    object lblMedicationCaption: TLabel
      Left = 8
      Top = 68
      Width = 55
      Height = 13
      Caption = '&Medication:'
      FocusControl = memMedication
    end
    object lblAdminStatus: TLabel
      Left = 248
      Top = 16
      Width = 65
      Height = 13
      Caption = '&Admin Status:'
      FocusControl = cbxAdminStatus
    end
    object lblAdminDateTime: TLabel
      Left = 248
      Top = 44
      Width = 87
      Height = 13
      Caption = 'Action Date/&Time:'
      FocusControl = edtDateTime
    end
    object lblBodySite: TLabel
      Left = 248
      Top = 68
      Width = 64
      Height = 13
      Caption = '&Injection Site:'
      FocusControl = cbxBodySite
    end
    object lblSSNCaption: TLabel
      Left = 8
      Top = 44
      Width = 25
      Height = 13
      Caption = '&SSN:'
      FocusControl = lblSSN
    end
    object lblIVBagNumberCaption: TLabel
      Left = 248
      Top = 92
      Width = 75
      Height = 13
      Caption = 'I&V Bag Number:'
      FocusControl = lblIVBagNumber
    end
    object edtDateTime: TEdit
      Left = 344
      Top = 40
      Width = 223
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 4
      OnChange = edtDateTimeChange
      OnExit = edtDateTimeExit
    end
    object cbxBodySite: TComboBox
      Left = 344
      Top = 64
      Width = 241
      Height = 21
      ItemHeight = 0
      TabOrder = 6
      Text = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      OnChange = cbxBodySiteChange
      OnEnter = cbxBodySiteEnter
      OnExit = cbxBodySiteExit
    end
    object btnDatePicker: TButton
      Left = 568
      Top = 40
      Width = 17
      Height = 19
      Caption = '6'
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Marlett'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = btnDatePickerClick
    end
    object cbxAdminStatus: TComboBox
      Left = 344
      Top = 13
      Width = 241
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 3
      OnChange = cbxAdminStatusChange
      OnCloseUp = cbxAdminStatusCloseUp
      OnEnter = cbxAdminStatusEnter
    end
    object lblPatientName: TVA508StaticText
      Name = 'lblPatientName'
      Left = 80
      Top = 16
      Width = 73
      Height = 15
      Alignment = taLeftJustify
      Caption = 'lblPatientName'
      ParentColor = True
      TabOrder = 0
      TabStop = True
      ShowAccelChar = True
    end
    object lblSSN: TVA508StaticText
      Name = 'lblSSN'
      Left = 80
      Top = 44
      Width = 34
      Height = 15
      Alignment = taLeftJustify
      Caption = 'lblSSN'
      ParentColor = True
      TabOrder = 1
      TabStop = True
      ShowAccelChar = True
    end
    object lblIVBagNumber: TVA508StaticText
      Name = 'lblIVBagNumber'
      Left = 344
      Top = 92
      Width = 78
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblIVBagNumber'
      ParentColor = True
      TabOrder = 7
      TabStop = True
      ShowAccelChar = True
    end
    object memMedication: TMemo
      Left = 80
      Top = 68
      Width = 161
      Height = 37
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'memMedication')
      ReadOnly = True
      TabOrder = 2
      WantReturns = False
      OnEnter = memMedicationEnter
    end
  end
  object grpPRNs: TGroupBox
    Left = 0
    Top = 131
    Width = 595
    Height = 144
    Align = alTop
    Caption = 'P&RNs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object lblReasonCaption: TLabel
      Left = 8
      Top = 20
      Width = 40
      Height = 13
      Caption = 'Reason:'
      FocusControl = cbxReasons
    end
    object lblEffectivenessCaption: TLabel
      Left = 8
      Top = 44
      Width = 67
      Height = 13
      Caption = '&Effectiveness:'
      FocusControl = memPRNEffectiveness
    end
    object lblMaxChars: TLabel
      Left = 368
      Top = 44
      Width = 125
      Height = 13
      Caption = '(150 Characters Maximum)'
    end
    object cbxReasons: TComboBox
      Left = 80
      Top = 16
      Width = 225
      Height = 21
      ItemHeight = 0
      TabOrder = 0
      Text = 'cbxReasons'
      OnChange = cbxReasonsChange
      OnEnter = cbxReasonsEnter
      OnExit = cbxReasonsExit
    end
    object memPRNEffectiveness: TMemo
      Left = 8
      Top = 61
      Width = 577
      Height = 49
      Lines.Strings = (
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        '0123456789')
      MaxLength = 150
      TabOrder = 1
      WantReturns = False
      OnEnter = memPRNEffectivenessEnter
      OnExit = memPRNEffectivenessExit
    end
    object lblPRNNotSupported: TVA508StaticText
      Name = 'lblPRNNotSupported'
      Left = 8
      Top = 120
      Width = 334
      Height = 15
      Alignment = taCenter
      Caption = 
        '* The Edit Medication Log does not support PRN required pain sco' +
        'res.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 2
      TabStop = True
      ShowAccelChar = True
    end
  end
  object grpDispensedDrugs: TGroupBox
    Left = 0
    Top = 275
    Width = 595
    Height = 95
    Align = alTop
    Caption = '&Dispensed Drugs'
    TabOrder = 2
    object grdMedications: TStringGrid
      Left = 8
      Top = 16
      Width = 577
      Height = 73
      Hint = 
        'Use your arrow keys to move from field to field.  Right click to' +
        ' edit or add a dispensed drug, press enter when finished adding/' +
        'editing.'
      ColCount = 4
      DefaultRowHeight = 15
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
      ParentShowHint = False
      PopupMenu = PopupMenu1
      ShowHint = True
      TabOrder = 0
      OnContextPopup = grdMedicationsContextPopup
      OnEnter = grdMedicationsEnter
      OnExit = grdMedicationsExit
      OnKeyPress = grdMedicationsKeyPress
      OnKeyUp = grdMedicationsKeyUp
      OnMouseDown = grdMedicationsMouseDown
      OnSelectCell = grdMedicationsSelectCell
    end
  end
  object grpComments: TGroupBox
    Left = 0
    Top = 370
    Width = 595
    Height = 122
    Align = alClient
    TabOrder = 3
    DesignSize = (
      595
      122)
    object lblCommentRequired: TLabel
      Left = 8
      Top = 8
      Width = 267
      Height = 13
      Caption = '&Enter a Comment (Required)  (150 Characters Maximum):'
      FocusControl = memComment
    end
    object Label6: TLabel
      Left = 368
      Top = 8
      Width = 125
      Height = 13
      Caption = '(150 Characters Maximum)'
      Enabled = False
      Visible = False
    end
    object memComment: TMemo
      Left = 8
      Top = 24
      Width = 577
      Height = 49
      Lines.Strings = (
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        
          '0123456789 0123456789 0123456789 0123456789 0123456789 012345678' +
          '9 0123456789 '
        '0123456789')
      MaxLength = 150
      TabOrder = 0
      WantReturns = False
      OnChange = memCommentChange
      OnExit = memCommentExit
    end
    object btnOK: TButton
      Left = 433
      Top = 85
      Width = 73
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Enabled = False
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 512
      Top = 85
      Width = 73
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
      end>
    Left = 40
    Top = 456
    StyleName = 'XP Style'
    object actionEdit: TAction
      Caption = '&Edit'
      ShortCut = 16453
      OnExecute = actionEditExecute
      OnUpdate = actionEditUpdate
    end
    object actionAddDispensedDrug: TAction
      Caption = '&Add Dispensed Drug'
      ShortCut = 16449
      OnExecute = actionAddDispensedDrugExecute
      OnUpdate = actionAddDispensedDrugUpdate
    end
    object actionWhatsThis: TAction
      Caption = 'What'#39's this?'
      OnExecute = actionWhatsThisExecute
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 136
    Top = 456
    object Edit2: TMenuItem
      Action = actionEdit
    end
    object AddDispensedDrug2: TMenuItem
      Action = actionAddDispensedDrug
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Whatsthis2: TMenuItem
      Action = actionWhatsThis
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 200
    Top = 456
    Data = (
      (
        'Component = lblPatientName'
        'Label = lblPatientNameCaption'
        'Status = stsOK')
      (
        'Component = lblSSN'
        'Label = lblSSNCaption'
        'Status = stsOK')
      (
        'Component = lblIVBagNumber'
        'Label = lblIVBagNumberCaption'
        'Status = stsOK')
      (
        'Component = lblPRNNotSupported'
        'Status = stsDefault')
      (
        'Component = frmEditMedLog'
        'Status = stsDefault')
      (
        'Component = grpMain'
        'Status = stsDefault')
      (
        'Component = cbxAdminStatus'
        'Label = lblAdminStatus'
        'Status = stsOK')
      (
        'Component = edtDateTime'
        'Label = lblAdminDateTime'
        'Status = stsOK')
      (
        'Component = cbxBodySite'
        'Label = lblBodySite'
        'Status = stsOK')
      (
        'Component = cbxReasons'
        'Label = lblReasonCaption'
        'Status = stsOK')
      (
        'Component = memPRNEffectiveness'
        'Label = lblEffectivenessCaption'
        'Status = stsOK')
      (
        'Component = memComment'
        'Label = lblCommentRequired'
        'Status = stsOK')
      (
        'Component = btnDatePicker'
        'Text = DateTime Picker'
        'Status = stsOK')
      (
        'Component = memMedication'
        'Label = lblMedicationCaption'
        'Status = stsOK')
      (
        'Component = grdMedications'
        
          'Text = Use your arrow keys to move from field to field.  Right c' +
          'lick to edit or add a dispensed drug, press enter when finished ' +
          'adding/editing.'
        'Status = stsOK')
      (
        'Component = grpComments'
        'Status = stsDefault')
      (
        'Component = grpDispensedDrugs'
        'Status = stsDefault')
      (
        'Component = grpPRNs'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault'))
  end
end
