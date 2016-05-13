object frmAllergyCheck: TfrmAllergyCheck
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Selected Medication Allergy Check'
  ClientHeight = 359
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    704
    359)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 303
    Width = 40
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Reason:'
  end
  object reInfo: TRichEdit
    Left = 8
    Top = 8
    Width = 688
    Height = 285
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object cbAllergyReason: TComboBox
    Left = 54
    Top = 299
    Width = 642
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
  end
  object btnContinue: TButton
    Left = 482
    Top = 326
    Width = 117
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Continue Order'
    ModalResult = 1
    TabOrder = 2
    OnClick = btnContinueClick
  end
  object btnCancel: TButton
    Left = 605
    Top = 326
    Width = 91
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel Order'
    ModalResult = 2
    TabOrder = 3
  end
  object amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 16
    Data = (
      (
        'Component = frmAllergyCheck'
        'Status = stsDefault')
      (
        'Component = reInfo'
        
          'Text = Displaying information returned on the Order / Allergy Ch' +
          'eck'
        'Status = stsOK')
      (
        'Component = cbAllergyReason'
        
          'Text = Select a Reason from the List or manually enter any valid' +
          ' reason'
        'Status = stsOK')
      (
        'Component = btnContinue'
        'Text = Continue Order'
        'Status = stsOK')
      (
        'Component = btnCancel'
        'Text = Cancel Order'
        'Status = stsOK'))
  end
end
