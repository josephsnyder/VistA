object frmPrintPtSelect: TfrmPrintPtSelect
  Left = 647
  Top = 142
  HelpContext = 199
  ActiveControl = edtWard
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'BCMA - Print by Ward Patient Selection'
  ClientHeight = 398
  ClientWidth = 745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 353
    Width = 745
    Height = 45
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object btnOK: TButton
      Left = 570
      Top = 12
      Width = 73
      Height = 25
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 658
      Top = 12
      Width = 73
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object grpPtName: TGroupBox
    Left = 0
    Top = 0
    Width = 745
    Height = 49
    Align = alTop
    Caption = 'Selected &Ward '
    TabOrder = 1
    object edtWard: TEdit
      Left = 3
      Top = 14
      Width = 401
      Height = 21
      CharCase = ecUpperCase
      Color = clBtnFace
      MaxLength = 50
      ReadOnly = True
      TabOrder = 0
      OnKeyUp = edtWardKeyUp
    end
  end
  object grpPtList: TGroupBox
    Left = 0
    Top = 49
    Width = 745
    Height = 304
    Align = alTop
    Caption = 
      '&Patient List - Select multiple patients by using the Shift or C' +
      'ontrol key '
    TabOrder = 2
    TabStop = True
    object pnlPatientList: TPanel
      Left = 2
      Top = 15
      Width = 741
      Height = 287
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lvwPtList: TListView
        Left = 0
        Top = 0
        Width = 741
        Height = 129
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
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = lvwPtListColumnClick
        OnDblClick = btnOKClick
        OnEnter = lvwPtListEnter
        OnKeyDown = lvwPtListKeyDown
        OnSelectItem = lvwPtListSelectItem
      end
      object sgPtList: TStringGrid
        Left = 0
        Top = 160
        Width = 737
        Height = 123
        TabOrder = 1
        OnEnter = sgPtListEnter
        OnSelectCell = sgPtListSelectCell
      end
    end
  end
  object stPtList: TVA508StaticText
    Name = 'stPtList'
    Left = 8
    Top = 199
    Width = 89
    Height = 15
    Alignment = taLeftJustify
    TabOrder = 3
    ShowAccelChar = True
  end
  object tmrPtSelect: TTimer
    Interval = 100
    OnTimer = tmrPtSelectTimer
    Left = 16
    Top = 361
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 640
    Top = 8
    Data = (
      (
        'Component = frmPrintPtSelect'
        'Status = stsDefault')
      (
        'Component = grpPtName'
        'Status = stsDefault')
      (
        'Component = grpPtList'
        'Status = stsDefault')
      (
        'Component = edtWard'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = pnlPatientList'
        'Status = stsDefault')
      (
        'Component = sgPtList'
        'Status = stsDefault')
      (
        'Component = lvwPtList'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = stPtList'
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = sgPtList
    OnValueQuery = VA508ComponentAccessibility1ValueQuery
    OnItemQuery = VA508ComponentAccessibility1ItemQuery
    Left = 680
    Top = 8
  end
end
