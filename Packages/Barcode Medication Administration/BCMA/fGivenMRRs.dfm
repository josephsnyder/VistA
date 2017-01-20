object frmGivenMRRs: TfrmGivenMRRs
  Left = 632
  Top = 151
  HelpContext = 128
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'BCMA - Given Medications that Require Removal'
  ClientHeight = 475
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlAdminInfo: TPanel
    Left = 0
    Top = 0
    Width = 539
    Height = 401
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      539
      401)
    object bvlAdminInfo: TBevel
      Left = 163
      Top = 15
      Width = 363
      Height = 3
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
    end
    object lblDispensedMeds: TLabel
      Left = 32
      Top = 130
      Width = 194
      Height = 13
      Caption = 'Dispensed Drugs/&Medications/Solutions:'
      FocusControl = lvwMedications
    end
    object lblNextDoseActionCaption: TLabel
      Left = 32
      Top = 243
      Width = 104
      Height = 13
      Caption = 'Next Dose Action:'
      FocusControl = lblNextDoseAction
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblScheduleTypeCaption: TLabel
      Left = 32
      Top = 270
      Width = 75
      Height = 13
      Caption = 'Schedule Type:'
      FocusControl = lblScheduleType
    end
    object lblLastActionCaption: TLabel
      Left = 32
      Top = 296
      Width = 56
      Height = 13
      Caption = 'Last Action:'
      FocusControl = lblLastAction
    end
    object lblOrderStatusCaption: TLabel
      Left = 32
      Top = 350
      Width = 62
      Height = 13
      Caption = 'Order Status:'
      FocusControl = lblOrderStatus
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOrderStopDateTimeCaption: TLabel
      Left = 32
      Top = 377
      Width = 108
      Height = 13
      Caption = 'Order Stop Date/Time:'
      FocusControl = lblOrderStopDateTime
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblLocationCaption: TLabel
      Left = 32
      Top = 101
      Width = 54
      Height = 13
      Caption = 'Location:'
      FocusControl = lblLocation
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblLastSiteCaption: TLabel
      Left = 32
      Top = 323
      Width = 41
      Height = 13
      Caption = 'Last Site'
      FocusControl = lblLastSite
    end
    object lvwMedications: TListView
      Left = 32
      Top = 149
      Width = 481
      Height = 73
      Columns = <
        item
          Caption = 'Name'
          Width = 325
        end>
      ColumnClick = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 3
      ViewStyle = vsReport
      OnEnter = lvwMedicationsEnter
    end
    object lblAdminInfo: TVA508StaticText
      Name = 'lblAdminInfo'
      Left = 8
      Top = 8
      Width = 149
      Height = 15
      Alignment = taLeftJustify
      Anchors = [akLeft, akTop, akRight]
      AutoSize = True
      Caption = 'Administration Information'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      TabStop = True
      ShowAccelChar = True
    end
    object lblNextDoseAction: TVA508StaticText
      Name = 'lblNextDoseAction'
      Left = 176
      Top = 242
      Width = 107
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblNextDoseAction'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 4
      TabStop = True
      ShowAccelChar = True
    end
    object lblScheduleType: TVA508StaticText
      Name = 'lblScheduleType'
      Left = 176
      Top = 269
      Width = 81
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblScheduleType'
      ParentColor = True
      TabOrder = 5
      TabStop = True
      ShowAccelChar = True
    end
    object lblLastAction: TVA508StaticText
      Name = 'lblLastAction'
      Left = 176
      Top = 295
      Width = 62
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblLastAction'
      ParentColor = True
      TabOrder = 6
      TabStop = True
      ShowAccelChar = True
    end
    object lblOrderStatus: TVA508StaticText
      Name = 'lblOrderStatus'
      Left = 176
      Top = 349
      Width = 68
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblOrderStatus'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 8
      TabStop = True
      ShowAccelChar = True
    end
    object lblOrderStopDateTime: TVA508StaticText
      Name = 'lblOrderStopDateTime'
      Left = 176
      Top = 376
      Width = 65
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'Not Available'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 9
      TabStop = True
      ShowAccelChar = True
    end
    object lblLocation: TVA508StaticText
      Name = 'lblLocation'
      Left = 176
      Top = 100
      Width = 65
      Height = 15
      HelpContext = 240
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'lblLocation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      ShowAccelChar = True
    end
    object lblLastSite: TVA508StaticText
      Name = 'lblLastSite'
      Left = 176
      Top = 322
      Width = 219
      Height = 15
      Alignment = taLeftJustify
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Caption = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      ParentColor = True
      TabOrder = 7
      TabStop = True
      ShowAccelChar = True
    end
    object memNotice: TMemo
      Left = 32
      Top = 45
      Width = 435
      Height = 40
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Lines.Strings = (
        
          'NOTICE: The status of this order has been changed. Please review' +
          ' the '
        
          'current patient orders in CPRS to determine whether or not this ' +
          'medication '
        'needs to be removed.')
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 408
    Width = 539
    Height = 67
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      539
      67)
    object bvlPatchNumber: TBevel
      Left = 18
      Top = 10
      Width = 239
      Height = 2
      Anchors = [akBottom]
      Shape = bsBottomLine
      ExplicitTop = 111
    end
    object lblPatchNumber: TVA508StaticText
      Name = 'lblPatchNumber'
      Left = 274
      Top = 1
      Width = 241
      Height = 18
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = True
      Caption = 'Meds Requiring Removal  99 of XX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      ShowAccelChar = True
    end
    object btnCancel: TButton
      Left = 451
      Top = 22
      Width = 75
      Height = 29
      Anchors = [akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object btnOK: TButton
      Left = 370
      Top = 22
      Width = 75
      Height = 29
      Anchors = [akBottom]
      Caption = '&OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 496
    Data = (
      (
        'Component = frmGivenMRRs'
        'Status = stsDefault')
      (
        'Component = pnlAdminInfo'
        'Status = stsDefault')
      (
        'Component = lvwMedications'
        'Label = lblDispensedMeds'
        'Status = stsOK')
      (
        'Component = lblNextDoseAction'
        'Label = lblNextDoseActionCaption'
        'Status = stsOK')
      (
        'Component = lblScheduleType'
        'Label = lblScheduleTypeCaption'
        'Status = stsOK')
      (
        'Component = lblLastAction'
        'Label = lblLastActionCaption'
        'Status = stsOK')
      (
        'Component = lblOrderStatus'
        'Label = lblOrderStatusCaption'
        'Status = stsOK')
      (
        'Component = lblOrderStopDateTime'
        'Label = lblOrderStopDateTimeCaption'
        'Status = stsOK')
      (
        'Component = lblAdminInfo'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = lblPatchNumber'
        'Status = stsDefault')
      (
        'Component = lblLocation'
        'Label = lblLocationCaption'
        'Status = stsOK')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = lblLastSite'
        'Label = lblLastSiteCaption'
        'Status = stsOK')
      (
        'Component = memNotice'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault'))
  end
end
