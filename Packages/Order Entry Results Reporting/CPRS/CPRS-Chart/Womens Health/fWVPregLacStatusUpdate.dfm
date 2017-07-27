object frmWVPregLacStatusUpdate: TfrmWVPregLacStatusUpdate
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Women'#39's Health - Pregnancy and Lactation Status Update'
  ClientHeight = 349
  ClientWidth = 573
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object pnlOptions: TPanel
    Left = 0
    Top = 309
    Width = 573
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    ExplicitTop = 303
    DesignSize = (
      573
      40)
    object btnSave: TButton
      Left = 482
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Save'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 401
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlPregnancyStatus: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 567
    Height = 208
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Pregnancy Status'
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      567
      208)
    object bvlPregnancyStatus: TBevel
      Left = 5
      Top = 8
      Width = 557
      Height = 5
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
      ExplicitWidth = 440
    end
    object Bevel1: TBevel
      Left = 5
      Top = 90
      Width = 557
      Height = 5
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
      ExplicitWidth = 399
    end
    object ckbxAbleToConceiveYes: TCheckBox
      Left = 20
      Top = 30
      Width = 150
      Height = 17
      Caption = 'Yes, able to conceive'
      TabOrder = 1
      OnClick = AbleToConceiveYesNo
    end
    object ckbxAbleToConceiveNo: TCheckBox
      Left = 20
      Top = 55
      Width = 150
      Height = 17
      Caption = 'No, not able to conceive'
      TabOrder = 2
      WordWrap = True
      OnClick = AbleToConceiveYesNo
    end
    object ckbxMenopause: TCheckBox
      Left = 273
      Top = 55
      Width = 85
      Height = 17
      Caption = 'Menopause'
      Enabled = False
      TabOrder = 4
      OnClick = CheckOkToSave
    end
    object ckbxHysterectomy: TCheckBox
      Left = 180
      Top = 55
      Width = 90
      Height = 17
      Caption = 'Hysterectomy'
      Enabled = False
      TabOrder = 3
      OnClick = CheckOkToSave
    end
    object stxtAbleToConceive: TStaticText
      Left = 6
      Top = 3
      Width = 133
      Height = 17
      Caption = 'Medically Able To Conceive'
      TabOrder = 0
      Transparent = False
    end
    object stxtCurrentlyPregnant: TStaticText
      Left = 6
      Top = 85
      Width = 89
      Height = 17
      Caption = 'Pregnancy Status'
      TabOrder = 6
      Transparent = False
    end
    object ckbxPregnantYes: TCheckBox
      Left = 20
      Top = 114
      Width = 150
      Height = 17
      Caption = 'Yes, pregnant'
      Enabled = False
      TabOrder = 7
      OnClick = PregnantYesNoUnsure
    end
    object ckbxPregnantNo: TCheckBox
      Left = 20
      Top = 154
      Width = 150
      Height = 17
      Caption = 'No, not pregnant'
      Enabled = False
      TabOrder = 11
      OnClick = PregnantYesNoUnsure
    end
    object ckbxPregnantUnsure: TCheckBox
      Left = 20
      Top = 179
      Width = 150
      Height = 17
      Caption = 'Unsure if pregnant'
      Enabled = False
      TabOrder = 12
      OnClick = PregnantYesNoUnsure
    end
    object dtpLastMenstrualPeriod: TDateTimePicker
      Left = 243
      Top = 111
      Width = 105
      Height = 21
      Date = 42356.344585000000000000
      Format = ' '
      Time = 42356.344585000000000000
      Enabled = False
      TabOrder = 9
      OnChange = dtpLastMenstrualPeriodChange
    end
    object stxtLastMenstrualPeriod: TStaticText
      Left = 128
      Top = 116
      Width = 107
      Height = 17
      Caption = 'Last menstrual period'
      Enabled = False
      TabOrder = 8
      TabStop = True
    end
    object ckbxPermanent: TCheckBox
      Left = 367
      Top = 55
      Width = 162
      Height = 17
      Caption = 'Permanent female sterilization'
      Enabled = False
      TabOrder = 5
      OnClick = CheckOkToSave
    end
    object pnlEddMethod: TPanel
      Left = 128
      Top = 136
      Width = 401
      Height = 19
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'pnlEddMethod'
      ShowCaption = False
      TabOrder = 10
      TabStop = True
      object lblEDDMethod: TLabel
        Left = 0
        Top = 0
        Width = 401
        Height = 19
        Align = alClient
        AutoSize = False
        Caption = 'lblEDDMethod'
        EllipsisPosition = epEndEllipsis
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        ExplicitLeft = 160
        ExplicitTop = 8
        ExplicitWidth = 66
        ExplicitHeight = 13
      end
    end
  end
  object pnlLactationStatus: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 217
    Width = 567
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Lactation Status'
    ParentColor = True
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 202
    DesignSize = (
      567
      80)
    object bvlLactationStatus: TBevel
      Left = 5
      Top = 8
      Width = 557
      Height = 5
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
      ExplicitWidth = 430
    end
    object ckbxLactatingYes: TCheckBox
      Left = 20
      Top = 30
      Width = 175
      Height = 17
      Caption = 'Yes, currently lactating'
      TabOrder = 1
      OnClick = ckbxLactatingYesNoClick
    end
    object ckbxLactatingNo: TCheckBox
      Left = 20
      Top = 55
      Width = 175
      Height = 17
      Caption = 'No, not currently lactating'
      TabOrder = 2
      OnClick = ckbxLactatingYesNoClick
    end
    object stxtLactationStatus: TStaticText
      Left = 6
      Top = 4
      Width = 82
      Height = 17
      Caption = 'Lactation Status'
      TabOrder = 0
      Transparent = False
    end
  end
end
