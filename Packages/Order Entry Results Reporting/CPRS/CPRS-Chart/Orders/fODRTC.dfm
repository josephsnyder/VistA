inherited frmODRTC: TfrmODRTC
  Left = 203
  Top = 183
  Width = 670
  Height = 517
  Caption = 'Return To Clinic'
  Constraints.MinHeight = 365
  Constraints.MinWidth = 300
  ExplicitWidth = 670
  ExplicitHeight = 517
  PixelsPerInch = 96
  TextHeight = 13
  object lblOrderSig: TLabel [0]
    Left = 8
    Top = 379
    Width = 44
    Height = 13
    Caption = 'Order Sig'
  end
  object stQuickOrdersDisabled: TStaticText [1]
    Left = 8
    Top = 22
    Width = 163
    Height = 17
    Caption = 'Quick Orders combo box disabled'
    TabOrder = 6
  end
  inherited memOrder: TCaptionMemo
    Left = 9
    Top = 396
    Width = 555
    Height = 69
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Constraints.MinWidth = 25
    TabOrder = 2
    Caption = 'Order Sig'
    ExplicitLeft = 9
    ExplicitTop = 396
    ExplicitWidth = 555
    ExplicitHeight = 69
  end
  object pnlRequired: TPanel [3]
    Left = 0
    Top = 0
    Width = 654
    Height = 370
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      654
      370)
    object lblClinic: TLabel
      Left = 8
      Top = 44
      Width = 32
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Clinic *'
    end
    object lblQO: TLabel
      Left = 8
      Top = 5
      Width = 79
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'My Quick Orders'
    end
    object lblMoreInfo: TLabel
      Left = 8
      Top = 286
      Width = 79
      Height = 13
      Caption = 'More Information'
      Visible = False
    end
    object stIntervalInDays: TStaticText
      Left = 152
      Top = 160
      Width = 165
      Height = 17
      Caption = 'Interval in day(s) spin edit disabled'
      TabOrder = 7
    end
    object cboRTCClinic: TORComboBox
      Left = 8
      Top = 59
      Width = 261
      Height = 21
      CaseChanged = False
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Clinic'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Text = ''
      OnKeyUp = cboRTCClinicKeyUp
      OnMouseClick = cboRTCClinicMouseClick
      OnNeedData = cboRTCClinicNeedData
      CharsNeedMatch = 1
    end
    object lblClinicallyIndicated: TStaticText
      Left = 9
      Top = 93
      Width = 106
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Return to clinic date*:'
      TabOrder = 12
    end
    object dateCIDC: TORDateBox
      Left = 8
      Top = 111
      Width = 98
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 2
      OnChange = dateCIDCChange
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
    object lblNumberAppts: TStaticText
      Left = 8
      Top = 140
      Width = 124
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Number of Appointments*'
      TabOrder = 13
    end
    object txtNumAppts: TCaptionEdit
      Left = 8
      Top = 159
      Width = 60
      Height = 19
      AutoSize = False
      TabOrder = 4
      Text = '1'
      OnChange = txtNumApptsChange
      OnClick = txtNumApptsClick
      Caption = 'Nums of Appointments*'
    end
    object SpinNumAppt: TUpDown
      Left = 68
      Top = 159
      Width = 16
      Height = 19
      Associate = txtNumAppts
      Min = 1
      Max = 60
      Position = 1
      TabOrder = 15
    end
    object lblFrequency: TStaticText
      Left = 147
      Top = 140
      Width = 81
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Interval in day(s)'
      TabOrder = 16
    end
    object cboPreReq: TORComboBox
      Left = 8
      Top = 209
      Width = 261
      Height = 21
      CheckBoxes = True
      Style = orcsDropDown
      AutoSelect = False
      Caption = 'Pre-Req'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 8
      Text = ''
      CheckEntireLine = True
      OnChange = cboPreReqChange
      CharsNeedMatch = 1
    end
    object lblPReReq: TStaticText
      Left = 8
      Top = 190
      Width = 169
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Prerequisites: (Check all that apply)'
      TabOrder = 17
    end
    object lblComments: TStaticText
      Left = 8
      Top = 239
      Width = 53
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Comments'
      TabOrder = 19
    end
    object txtInterval: TCaptionEdit
      Left = 147
      Top = 159
      Width = 66
      Height = 21
      TabOrder = 5
      Text = '0'
      OnChange = txtIntervalChange
      OnClick = txtIntervalClick
      Caption = 'Interval in day(s)'
    end
    object spnInterval: TUpDown
      Left = 213
      Top = 159
      Width = 16
      Height = 21
      Associate = txtInterval
      Max = 30
      TabOrder = 6
    end
    object chkTimeSensitve: TCheckBox
      Left = 147
      Top = 111
      Width = 97
      Height = 17
      Caption = 'Time Sensitive'
      TabOrder = 3
      OnClick = chkTimeSensitveClick
    end
    object memInfo: TMemo
      Left = 9
      Top = 303
      Width = 493
      Height = 57
      Color = clInfoBk
      Lines.Strings = (
        '')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 10
      Visible = False
    end
    object edtComment: TEdit
      Left = 8
      Top = 256
      Width = 493
      Height = 21
      TabOrder = 9
      OnChange = edtCommentChange
    end
    object cboPerQO: TORComboBox
      Left = 8
      Top = 19
      Width = 261
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Quick Orders'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      OnDropDownClose = cboPerQODropDownClose
      OnKeyUp = cboPerQOKeyUp
      OnMouseClick = cboPerQOMouseClick
      CharsNeedMatch = 1
    end
  end
  inherited cmdAccept: TButton
    Left = 572
    Top = 396
    Width = 69
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 3
    ExplicitLeft = 572
    ExplicitTop = 396
    ExplicitWidth = 69
  end
  inherited cmdQuit: TButton
    Left = 572
    Top = 435
    Width = 67
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 5
    ExplicitLeft = 572
    ExplicitTop = 435
    ExplicitWidth = 67
  end
  inherited pnlMessage: TPanel
    Left = 228
    Top = 367
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    ExplicitLeft = 228
    ExplicitTop = 367
    inherited imgMessage: TImage
      Left = 7
      Top = 7
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExplicitLeft = 7
      ExplicitTop = 7
    end
    inherited memMessage: TRichEdit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 592
    Top = 8
    Data = (
      (
        'Component = memOrder'
        'Text = Order Sig'
        'Status = stsOK')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODRTC'
        'Status = stsDefault')
      (
        'Component = pnlRequired'
        'Status = stsDefault')
      (
        'Component = cboRTCClinic'
        'Status = stsDefault')
      (
        'Component = lblClinicallyIndicated'
        'Status = stsDefault')
      (
        'Component = dateCIDC'
        'Status = stsDefault')
      (
        'Component = lblNumberAppts'
        'Status = stsDefault')
      (
        'Component = txtNumAppts'
        'Status = stsDefault')
      (
        'Component = SpinNumAppt'
        'Status = stsDefault')
      (
        'Component = lblFrequency'
        'Status = stsDefault')
      (
        'Component = cboPreReq'
        'Status = stsDefault')
      (
        'Component = lblPReReq'
        'Status = stsDefault')
      (
        'Component = lblComments'
        'Status = stsDefault')
      (
        'Component = cboPerQO'
        'Status = stsDefault')
      (
        'Component = txtInterval'
        'Status = stsDefault')
      (
        'Component = spnInterval'
        'Status = stsDefault')
      (
        'Component = chkTimeSensitve'
        'Status = stsDefault')
      (
        'Component = memInfo'
        'Status = stsDefault')
      (
        'Component = edtComment'
        'Status = stsDefault')
      (
        'Component = stQuickOrdersDisabled'
        'Status = stsDefault')
      (
        'Component = stIntervalInDays'
        'Status = stsDefault'))
  end
end
