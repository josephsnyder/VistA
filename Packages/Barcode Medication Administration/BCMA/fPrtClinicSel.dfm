object frmPrtClinicSel: TfrmPrtClinicSel
  Left = 0
  Top = 0
  HelpContext = 242
  Caption = 'Clinic Selection'
  ClientHeight = 405
  ClientWidth = 642
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grpSearch: TGroupBox
    Left = 0
    Top = 0
    Width = 642
    Height = 72
    Align = alTop
    Caption = 'Search Criteria '
    TabOrder = 0
    object lblSearchText: TLabel
      Left = 142
      Top = 19
      Width = 91
      Height = 13
      Caption = 'Enter Search &Text:'
      FocusControl = edtSearchText
    end
    object lblSearchPrefix: TLabel
      Left = 15
      Top = 19
      Width = 97
      Height = 13
      Caption = 'Enter Search &Prefix:'
    end
    object edtSearchText: TEdit
      Left = 142
      Top = 38
      Width = 387
      Height = 21
      Hint = 'Enter text you want to search for'
      CharCase = ecUpperCase
      MaxLength = 30
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object btnSearch: TButton
      Left = 544
      Top = 36
      Width = 82
      Height = 25
      Caption = '&Search'
      Default = True
      TabOrder = 2
      OnClick = btnSearchClick
    end
    object edtSearchPrefix: TEdit
      Left = 15
      Top = 38
      Width = 92
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
  end
  object grpSelect: TGroupBox
    Left = 0
    Top = 72
    Width = 642
    Height = 272
    Align = alTop
    Padding.Left = 5
    Padding.Right = 5
    TabOrder = 1
    object lblSearchResults: TLabel
      Left = 8
      Top = 25
      Width = 75
      Height = 13
      Caption = 'Search R&esults:'
      FocusControl = lvwSearchResults
    end
    object lblSelClinics: TLabel
      Left = 378
      Top = 24
      Width = 80
      Height = 13
      Caption = 'Selected  &Clinics:'
      FocusControl = lvwSelectedClinics
    end
    object btnAdd: TButton
      Left = 279
      Top = 89
      Width = 82
      Height = 25
      Hint = 'Adds the highlighted items in the left pane to the right pane'
      Caption = '&Add  >'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      WordWrap = True
      OnClick = btnAddClick
    end
    object btnRemove: TButton
      Left = 279
      Top = 168
      Width = 82
      Height = 25
      Hint = 'Remove the highlighted items from the right pane'
      Caption = '<  &Remove'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnRemoveClick
    end
    object btnAddAll: TButton
      Left = 279
      Top = 120
      Width = 82
      Height = 25
      Hint = 'Adds all the items in the left pane to the right pane'
      Caption = 'Add A&ll >>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnAddAllClick
    end
    object btnRemoveAll: TButton
      Left = 279
      Top = 199
      Width = 82
      Height = 25
      Hint = 'Remove all the items from the right pane'
      Caption = '<< Remo&ve All'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnRemoveAllClick
    end
    object lvwSearchResults: TListView
      Left = 8
      Top = 44
      Width = 257
      Height = 225
      Hint = 'Items return from the search'
      Columns = <
        item
          Caption = 'Item'
          Width = 175
        end>
      Enabled = False
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowWorkAreas = True
      ShowHint = True
      SortType = stText
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = lvwSearchResultsDblClick
    end
    object lvwSelectedClinics: TListView
      Left = 378
      Top = 43
      Width = 256
      Height = 225
      Hint = 'The items you have selected to display on the report'
      Columns = <
        item
          Caption = 'Item'
          Width = 175
        end>
      Enabled = False
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowWorkAreas = True
      ShowHint = True
      SortType = stText
      TabOrder = 5
      ViewStyle = vsReport
      OnDblClick = lvwSelectedClinicsDblClick
    end
  end
  object btnOK: TButton
    Left = 478
    Top = 360
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 562
    Top = 360
    Width = 64
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 424
    Top = 352
    Data = (
      (
        'Component = edtSearchPrefix'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmPrtClinicSel'
        'Status = stsDefault'))
  end
end
