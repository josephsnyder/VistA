object frmPtSelect: TfrmPtSelect
  Left = 685
  Top = 59
  HelpContext = 600
  ActiveControl = edtPtName
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'BCMA - Patient Select'
  ClientHeight = 398
  ClientWidth = 784
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPatientList: TPanel
    Left = 0
    Top = 49
    Width = 784
    Height = 304
    HelpContext = 601
    Align = alClient
    TabOrder = 1
    object sgPtList: TStringGrid
      Left = 1
      Top = 181
      Width = 782
      Height = 122
      Align = alBottom
      RowCount = 2
      TabOrder = 1
      OnDblClick = btnOKClick
      OnEnter = sgPtListEnter
      OnExit = sgPtListExit
      OnSelectCell = sgPtListSelectCell
      ColWidths = (
        64
        64
        64
        64
        64)
    end
    object lvwPtList: TListView
      Left = 1
      Top = 1
      Width = 782
      Height = 136
      Align = alTop
      Columns = <
        item
          Caption = 'Name'
        end
        item
          Caption = 'SSN'
        end
        item
          Caption = 'DOB'
        end
        item
          Caption = 'Rm-Bd'
        end
        item
          Caption = 'Ward'
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 2
      ViewStyle = vsReport
      OnColumnClick = lvwPtListColumnClick
      OnDblClick = btnOKClick
      OnEnter = lvwPtListEnter
      OnExit = lvwPtListExit
      OnSelectItem = lvwPtListSelectItem
    end
    object stPtList: TStaticText
      Left = 0
      Top = 143
      Width = 38
      Height = 17
      Caption = 'stPtList'
      TabOrder = 0
      TabStop = True
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 353
    Width = 784
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnOK: TButton
      Left = 570
      Top = 12
      Width = 73
      Height = 25
      Caption = '&OK'
      Default = True
      Enabled = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 658
      Top = 12
      Width = 73
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 1
      TabOrder = 1
    end
  end
  object grpPtName: TGroupBox
    Left = 0
    Top = 0
    Width = 784
    Height = 49
    HelpContext = 600
    Align = alTop
    Caption = '&Patient Name (Last, First or SSN, Rm-Bd, or Ward)'
    TabOrder = 0
    object edtPtName: TEdit
      Left = 8
      Top = 16
      Width = 401
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 50
      TabOrder = 0
      OnEnter = edtPtNameEnter
      OnKeyUp = edtPtNameKeyUp
    end
  end
  object tmrPtSelect: TTimer
    Enabled = False
    OnTimer = tmrPtSelectTimer
    Left = 720
    Top = 9
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 456
    Top = 8
    Data = (
      (
        'Component = sgPtList'
        'Text = Patient List'
        'Status = stsOK')
      (
        'Component = frmPtSelect'
        'Status = stsDefault')
      (
        'Component = lvwPtList'
        'Status = stsDefault')
      (
        'Component = pnlPatientList'
        'Status = stsDefault')
      (
        'Component = grpPtName'
        'Status = stsDefault')
      (
        'Component = stPtList'
        'Status = stsDefault')
      (
        'Component = edtPtName'
        'Text = Patient Name'
        'Status = stsOK'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = sgPtList
    OnValueQuery = VA508ComponentAccessibility1ValueQuery
    Left = 608
    Top = 8
  end
end
