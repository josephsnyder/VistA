inherited frmDCOrdersAllrgsCrrnt: TfrmDCOrdersAllrgsCrrnt
  Left = 316
  Top = 226
  Caption = 'List of allergies currently recorded for the patient:'
  ClientHeight = 312
  ClientWidth = 424
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 440
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  object lblAllergies: TLabel [0]
    Left = 0
    Top = 0
    Width = 424
    Height = 13
    Align = alTop
    Caption = 'Allergy List:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
    ExplicitWidth = 67
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 13
    Width = 425
    Height = 235
    Align = alCustom
    TabOrder = 0
    object lstAlleries: TCaptionListBox
      Left = 1
      Top = 1
      Width = 423
      Height = 233
      Cursor = crHandPoint
      TabStop = False
      Style = lbOwnerDrawVariable
      Align = alClient
      BevelWidth = 3
      ExtendedSelect = False
      ItemHeight = 13
      TabOrder = 0
      StyleElements = [seFont]
      OnDrawItem = lstAlleriesDrawItem
      OnMeasureItem = lstAlleriesMeasureItem
      Caption = 'The following orders will be discontinued '
    end
  end
  object Panel2: TPanel [2]
    Left = -1
    Top = 248
    Width = 425
    Height = 98
    Align = alCustom
    Constraints.MinHeight = 88
    TabOrder = 1
    DesignSize = (
      425
      98)
    object lblVerifyAllrgyDisc: TLabel
      Left = 2
      Top = 5
      Width = 482
      Height = 13
      Caption = 
        'Do you want to enter the allergy/adverse drug reaction for the m' +
        'edication being discontinued?'#9#39
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cmdYes: TButton
      Left = 133
      Top = 37
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = '&Yes'
      Default = True
      TabOrder = 0
      OnClick = cmdYesClick
    end
    object cmdNo: TButton
      Left = 211
      Top = 37
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&No'
      TabOrder = 1
      OnClick = cmdNoClick
    end
    object mnoVerifyAllrgyDisc: TMemo
      Left = 1
      Top = 5
      Width = 423
      Height = 26
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        
          '                              Do you want to enter the allergy/a' +
          'dverse drug reaction'
        
          '                              for the medication being discontin' +
          'ued?')
      TabOrder = 2
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 392
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = lstAlleries'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = cmdYes'
        'Status = stsDefault')
      (
        'Component = cmdNo'
        'Status = stsDefault')
      (
        'Component = frmDCOrdersAllrgsCrrnt'
        'Status = stsDefault')
      (
        'Component = mnoVerifyAllrgyDisc'
        'Status = stsDefault'))
  end
end
