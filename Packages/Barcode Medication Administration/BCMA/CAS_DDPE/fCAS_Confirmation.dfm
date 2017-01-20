object frmCAS_Confirmation: TfrmCAS_Confirmation
  Left = 0
  Top = 0
  Caption = 'Confirmation'
  ClientHeight = 393
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlUserInput: TPanel
    Left = 0
    Top = 201
    Width = 424
    Height = 151
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 203
    ExplicitWidth = 581
    DesignSize = (
      424
      151)
    object bvlUnableToScanReason: TBevel
      Left = 72
      Top = 19
      Width = 326
      Height = 3
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
      Visible = False
      ExplicitWidth = 483
    end
    object lblEnterAComment: TLabel
      Left = 72
      Top = 28
      Width = 225
      Height = 13
      Caption = '&Enter a Comment   (150 Characters Maximum):'
      FocusControl = memComment
    end
    object memComment: TMemo
      Left = 72
      Top = 47
      Width = 326
      Height = 94
      Anchors = [akLeft, akTop, akRight, akBottom]
      MaxLength = 150
      TabOrder = 0
      WantReturns = False
      ExplicitWidth = 483
      ExplicitHeight = 140
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 352
    Width = 424
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 404
    ExplicitWidth = 581
    DesignSize = (
      424
      41)
    object Button1: TButton
      Left = 243
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 399
    end
    object Button2: TButton
      Left = 324
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 480
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 424
    Height = 153
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 2
    ExplicitWidth = 581
    DesignSize = (
      424
      153)
    object lblDispensedMeds: TLabel
      Left = 72
      Top = 55
      Width = 84
      Height = 13
      Caption = 'Dispensed Drugs:'
      FocusControl = lvwMedications
    end
    object lblMedicationCaption: TLabel
      Left = 72
      Top = 24
      Width = 88
      Height = 13
      Caption = 'Active Medication:'
      FocusControl = VA508stMedication
    end
    object Image: TImage
      Left = 8
      Top = 23
      Width = 49
      Height = 45
    end
    object lvwMedications: TListView
      Left = 176
      Top = 54
      Width = 222
      Height = 98
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvNone
      BevelOuter = bvNone
      Color = clScrollBar
      Columns = <
        item
          Caption = 'Name'
          Width = 200
        end>
      ColumnClick = False
      Ctl3D = False
      ReadOnly = True
      RowSelect = True
      ShowColumnHeaders = False
      TabOrder = 0
      ViewStyle = vsReport
    end
    object VA508stMedication: TVA508StaticText
      Name = 'VA508stMedication'
      Left = 176
      Top = 23
      Width = 63
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'VA508stMedication'
      ParentColor = True
      TabOrder = 1
      TabStop = True
      ShowAccelChar = True
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 153
    Width = 424
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 104
    ExplicitWidth = 581
    object VA508stMessage: TVA508StaticText
      Name = 'VA508stMessage'
      Left = 69
      Top = 8
      Width = 44
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Message'
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 528
    Top = 16
    Data = (
      (
        'Component = frmCAS_Confirmation'
        'Status = stsDefault')
      (
        'Component = pnlUserInput'
        'Status = stsDefault')
      (
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Button1'
        'Status = stsDefault')
      (
        'Component = Button2'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = lvwMedications'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = VA508stMessage'
        'Status = stsDefault')
      (
        'Component = VA508stMedication'
        'Status = stsDefault'))
  end
end
