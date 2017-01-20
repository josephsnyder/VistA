object frmMedTherapyMedSelection: TfrmMedTherapyMedSelection
  Left = 514
  Top = 380
  HelpContext = 202
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'BCMA - Medication Therapy - Medication Selection'
  ClientHeight = 497
  ClientWidth = 565
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
  object rgrpSearchCategory: TRadioGroup
    Left = 0
    Top = 0
    Width = 565
    Height = 91
    Hint = 
      'Select the category you wish to search by. Changing the category' +
      ' will clear any currently selected medications.'
    Align = alTop
    Caption = '&Drug Search Category '
    ItemIndex = 2
    Items.Strings = (
      'Dispensed Drugs'
      'IV Medications'
      'Orderable Item'
      'VA Drug Class')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = rgrpSearchCategoryClick
  end
  object grpSearch: TGroupBox
    Left = 0
    Top = 91
    Width = 565
    Height = 72
    Align = alTop
    Caption = 'Search Criteria '
    TabOrder = 1
    object lblSearchText: TLabel
      Left = 16
      Top = 19
      Width = 91
      Height = 13
      Caption = 'Enter Search &Text:'
      FocusControl = edtSearchText
    end
    object edtSearchText: TEdit
      Left = 24
      Top = 38
      Width = 213
      Height = 21
      Hint = 'Enter text you want to search for'
      CharCase = ecUpperCase
      MaxLength = 30
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnKeyPress = edtSearchTextKeyPress
    end
    object btnSearch: TButton
      Left = 243
      Top = 36
      Width = 82
      Height = 25
      Caption = '&Search'
      TabOrder = 1
      OnClick = btnSearchClick
    end
  end
  object grpSelect: TGroupBox
    Left = 0
    Top = 163
    Width = 565
    Height = 272
    Align = alTop
    Padding.Left = 5
    Padding.Right = 5
    TabOrder = 2
    object lblSearchResults: TLabel
      Left = 8
      Top = 25
      Width = 75
      Height = 13
      Caption = 'Search R&esults:'
      FocusControl = lvwSearchResults
    end
    object lblSelMedications: TLabel
      Left = 336
      Top = 24
      Width = 107
      Height = 13
      Caption = 'Selected  &Medications:'
      FocusControl = lvwSelectedMedications
    end
    object btnAdd: TButton
      Left = 243
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
      Left = 243
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
      Left = 243
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
      Left = 243
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
      Width = 221
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
      OnKeyDown = lvwSearchResultsKeyDown
    end
    object lvwSelectedMedications: TListView
      Left = 336
      Top = 43
      Width = 221
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
      OnKeyDown = lvwSelectedMedicationsKeyDown
    end
  end
  object btnOK: TButton
    Left = 480
    Top = 456
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 3
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 400
    Top = 456
    Data = (
      (
        'Component = frmMedTherapyMedSelection'
        'Status = stsDefault')
      (
        'Component = edtSearchText'
        'Label = lblSearchText'
        'Status = stsOK')
      (
        'Component = lvwSearchResults'
        'Label = lblSearchResults'
        'Status = stsOK')
      (
        'Component = lvwSelectedMedications'
        'Label = lblSelMedications'
        'Status = stsOK')
      (
        'Component = rgrpSearchCategory'
        'Status = stsDefault'))
  end
end
