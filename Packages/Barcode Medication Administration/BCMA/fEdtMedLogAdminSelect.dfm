object frmEditMedLogAdminSelect: TfrmEditMedLogAdminSelect
  Left = 389
  Top = 474
  HelpContext = 179
  ActiveControl = lvwAdministrations
  BorderStyle = bsDialog
  Caption = 'BCMA - Edit Med Log Administration Selection'
  ClientHeight = 275
  ClientWidth = 685
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    685
    275)
  PixelsPerInch = 96
  TextHeight = 13
  object lblPatientNameCaption: TLabel
    Left = 8
    Top = 6
    Width = 67
    Height = 13
    Caption = '&Patient Name:'
  end
  object lblSSNCaption: TLabel
    Left = 8
    Top = 22
    Width = 25
    Height = 13
    Caption = '&SSN:'
  end
  object lblDateVisual: TLabel
    Left = 8
    Top = 41
    Width = 91
    Height = 15
    AutoSize = False
    Caption = 'Searching &Date'
    FocusControl = lvwAdministrations
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grdAdministrations: TStringGrid
    Left = 8
    Top = 61
    Width = 662
    Height = 153
    Anchors = [akLeft, akRight, akBottom]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 1
    OnSelectCell = grdAdministrationsSelectCell
    OnSetEditText = grdAdministrationsSetEditText
  end
  object lvwAdministrations: TListView
    Left = 8
    Top = 61
    Width = 662
    Height = 153
    Anchors = [akLeft, akTop, akRight]
    Columns = <
      item
        Caption = 'Type'
      end
      item
        Caption = 'Medication'
      end
      item
        Caption = 'Status'
      end
      item
        Caption = 'Action Date/Time '
      end
      item
        Caption = 'Int'
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lvwAdministrationsChange
    OnDblClick = btnOKClick
    OnEnter = lvwAdministrationsEnter
  end
  object btnDown: TButton
    Left = 16
    Top = 240
    Width = 25
    Height = 21
    Caption = '<<'
    TabOrder = 2
    OnClick = btnDownClick
  end
  object edtDate: TEdit
    Left = 48
    Top = 240
    Width = 81
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 3
    Text = '01/01/2004'
    OnChange = edtDateChange
    OnEnter = edtDateEnter
    OnExit = edtDateExit
    OnKeyPress = edtDateKeyPress
  end
  object btnDatePicker: TButton
    Left = 128
    Top = 242
    Width = 17
    Height = 19
    Caption = '6'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Marlett'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnDatePickerClick
  end
  object btnUp: TButton
    Left = 152
    Top = 240
    Width = 25
    Height = 21
    Caption = '>>'
    TabOrder = 5
    OnClick = btnUpClick
  end
  object btnOK: TButton
    Left = 509
    Top = 236
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&OK'
    Enabled = False
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 597
    Top = 236
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object lblPatientName508: TVA508StaticText
    Name = 'lblPatientName508'
    Left = 81
    Top = 4
    Width = 91
    Height = 15
    Alignment = taLeftJustify
    AutoSize = True
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'lblPatientName508'
    ParentColor = True
    TabOrder = 8
    TabStop = True
    ShowAccelChar = True
  end
  object lblSSN: TVA508StaticText
    Name = 'lblSSN'
    Left = 80
    Top = 20
    Width = 80
    Height = 15
    Alignment = taLeftJustify
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'OOO-OO-OOOO'
    ParentColor = True
    TabOrder = 9
    TabStop = True
    ShowAccelChar = True
  end
  object lblDate: TVA508StaticText
    Name = 'lblDate'
    Left = 264
    Top = 240
    Width = 95
    Height = 15
    Alignment = taLeftJustify
    AutoSize = True
    Caption = 'Searching &Date:'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    TabStop = True
    Visible = False
    ShowAccelChar = True
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 608
    Top = 8
    Data = (
      (
        'Component = frmEditMedLogAdminSelect'
        'Status = stsDefault')
      (
        'Component = lvwAdministrations'
        'Label = lblDateVisual'
        'Status = stsOK')
      (
        'Component = btnDown'
        'Text = Previous'
        'Status = stsOK')
      (
        'Component = btnUp'
        'Text = Next'
        'Status = stsOK')
      (
        'Component = lblPatientName508'
        'Label = lblPatientNameCaption'
        'Status = stsOK')
      (
        'Component = lblSSN'
        'Label = lblSSNCaption'
        'Status = stsOK')
      (
        'Component = btnDatePicker'
        'Text = Date Picker'
        'Status = stsOK')
      (
        'Component = edtDate'
        'Status = stsDefault')
      (
        'Component = grdAdministrations'
        'Label = lblDateVisual'
        'Status = stsOK')
      (
        'Component = lblDate'
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = grdAdministrations
    OnValueQuery = VA508ComponentAccessibility1ValueQuery
    Left = 648
    Top = 8
  end
end
