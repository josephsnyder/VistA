object frmFiveRights: TfrmFiveRights
  Left = 0
  Top = 0
  HelpContext = 203
  BorderStyle = bsSingle
  Caption = 'Medication Verification'
  ClientHeight = 507
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  DesignSize = (
    413
    507)
  PixelsPerInch = 96
  TextHeight = 13
  object rbVerifyMedication: TRadioButton
    Left = 23
    Top = 15
    Width = 113
    Height = 17
    Caption = 'Verify &Medication'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = rbVerifyMedicationClick
  end
  object rbVerifyFiveRights: TRadioButton
    Left = 23
    Top = 281
    Width = 113
    Height = 17
    Caption = 'Verify &Five Rights'
    TabOrder = 2
    TabStop = True
    OnClick = rbVerifyFiveRightsClick
  end
  object pnlVerifyMedication: TPanel
    Left = 27
    Top = 38
    Width = 348
    Height = 231
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      348
      231)
    object lblEnterBarCode: TLabel
      Left = 24
      Top = 13
      Width = 226
      Height = 26
      Caption = 
        'Type in the human readable number below the Bar Code of the drug' +
        ' being administered'
      WordWrap = True
    end
    object edEnterBarCode: TEdit
      Left = 24
      Top = 48
      Width = 219
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      CharCase = ecUpperCase
      MaxLength = 22
      TabOrder = 0
      OnKeyPress = edEnterBarCodeKeyPress
    end
    object btnSubmit: TButton
      Left = 255
      Top = 48
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Submit'
      TabOrder = 1
      OnClick = btnSubmitClick
    end
    object mmoDrugInfo: TMemo
      Left = 24
      Top = 79
      Width = 306
      Height = 141
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      Lines.Strings = (
        '')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
      WantReturns = False
      OnEnter = mmoDrugInfoEnter
    end
  end
  object pnlFiveRights: TPanel
    Left = 27
    Top = 304
    Width = 348
    Height = 145
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object cbRightPatient: TCheckBox
      Left = 24
      Top = 20
      Width = 97
      Height = 17
      Caption = 'Right Patient'
      TabOrder = 0
      OnClick = cbRightPatientClick
    end
    object cbRightMedication: TCheckBox
      Left = 24
      Top = 43
      Width = 97
      Height = 17
      Caption = 'Right Medication'
      TabOrder = 1
      OnClick = cbRightMedicationClick
    end
    object cbRightDose: TCheckBox
      Left = 24
      Top = 66
      Width = 97
      Height = 17
      Caption = 'Right Dose'
      TabOrder = 2
      OnClick = cbRightDoseClick
    end
    object cbRightRoute: TCheckBox
      Left = 24
      Top = 89
      Width = 97
      Height = 17
      Caption = 'Right Route'
      TabOrder = 3
      OnClick = cbRightRouteClick
    end
    object cbRightTime: TCheckBox
      Left = 24
      Top = 112
      Width = 97
      Height = 17
      Caption = 'Right Time'
      TabOrder = 4
      OnClick = cbRightTimeClick
    end
  end
  object btnCancel: TButton
    Left = 297
    Top = 472
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 209
    Top = 472
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 4
    OnClick = btnOKClick
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 24
    Top = 464
    Data = (
      (
        'Component = frmFiveRights'
        'Status = stsDefault')
      (
        'Component = pnlVerifyMedication'
        'Status = stsDefault')
      (
        'Component = edEnterBarCode'
        'Label = lblEnterBarCode'
        'Status = stsOK')
      (
        'Component = btnSubmit'
        'Status = stsDefault')
      (
        'Component = mmoDrugInfo'
        'Status = stsDefault')
      (
        'Component = rbVerifyFiveRights'
        'Status = stsDefault')
      (
        'Component = pnlFiveRights'
        'Status = stsDefault')
      (
        'Component = rbVerifyMedication'
        'Text = Verify Medication'
        'Status = stsOK'))
  end
end
