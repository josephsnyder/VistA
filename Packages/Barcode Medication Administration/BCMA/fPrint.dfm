object frmPrint: TfrmPrint
  Left = 513
  Top = 370
  HelpContext = 204
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Print'
  ClientHeight = 306
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblSelectPrinter: TLabel
    Left = 8
    Top = 13
    Width = 110
    Height = 13
    Caption = 'Please &Select a Printer:'
    FocusControl = cbxDeviceList
  end
  object cbxDeviceList: TORComboBox
    Left = 8
    Top = 32
    Width = 417
    Height = 140
    Style = orcsSimple
    AutoSelect = True
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2,4'
    Sorted = False
    SynonymChars = '<>'
    TabPositions = '30'
    TabOrder = 0
    OnNeedData = cbxDeviceListNeedData
    CharsNeedMatch = 1
  end
  object btnOk: TButton
    Left = 272
    Top = 273
    Width = 73
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 351
    Top = 273
    Width = 73
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 184
    Width = 417
    Height = 83
    Caption = 'Queuing'
    TabOrder = 3
    object lblQueueDateTime: TLabel
      Left = 56
      Top = 34
      Width = 101
      Height = 13
      Caption = 'Enter &Date and Time:'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
    end
    object chkQueueDateTime: TCheckBox
      Left = 32
      Top = 16
      Width = 110
      Height = 17
      Caption = '&Queue Report'
      TabOrder = 0
      OnClick = chkQueueDateTimeClick
    end
    object edtQueueDateTime: TEdit
      Left = 56
      Top = 49
      Width = 178
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 1
      OnChange = edtQueueDateTimeChange
      OnExit = edtQueueDateTimeExit
    end
    object btnDateTimePicker: TButton
      Left = 216
      Top = 51
      Width = 17
      Height = 19
      Caption = '6'
      Enabled = False
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Marlett'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnDateTimePickerClick
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 224
    Data = (
      (
        'Component = frmPrint'
        'Status = stsDefault')
      (
        'Component = cbxDeviceList'
        'Label = lblSelectPrinter'
        'Status = stsOK')
      (
        'Component = edtQueueDateTime'
        'Label = lblQueueDateTime'
        'Status = stsOK')
      (
        'Component = chkQueueDateTime'
        'Status = stsDefault')
      (
        'Component = btnDateTimePicker'
        'Text = Date Picker'
        'Status = stsOK'))
  end
end
