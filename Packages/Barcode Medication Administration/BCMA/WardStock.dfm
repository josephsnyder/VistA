object frmWardStock: TfrmWardStock
  Left = 613
  Top = 326
  HelpContext = 167
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Ward Stock'
  ClientHeight = 310
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 260
    Width = 488
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object pnlScannerStatus: TPanel
      Left = 0
      Top = 0
      Width = 120
      Height = 50
      Align = alLeft
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object lblScannerStatus: TLabel
        Left = 8
        Top = 2
        Width = 43
        Height = 26
        Caption = 'Scanner Status:'
        FocusControl = lblScannerStatusReady
        WordWrap = True
      end
      object pnlScannerIndicator: TPanel
        Left = 58
        Top = 7
        Width = 51
        Height = 21
        BevelOuter = bvLowered
        Color = clRed
        TabOrder = 0
        OnClick = pnlScannerIndicatorClick
      end
      object lblScannerStatusReady: TVA508StaticText
        Name = 'lblScannerStatusReady'
        Left = 8
        Top = 31
        Width = 63
        Height = 15
        Alignment = taLeftJustify
        AutoSize = True
        Caption = 'Not Ready'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        ShowAccelChar = True
      end
    end
    object pnlScannerInput: TPanel
      Left = 120
      Top = 0
      Width = 184
      Height = 50
      Align = alClient
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object lblScanMedication: TLabel
        Left = 6
        Top = 7
        Width = 72
        Height = 13
        Caption = '&Scan Bar Code'
      end
      object edtScannerInput: TEdit
        Left = 6
        Top = 22
        Width = 113
        Height = 21
        CharCase = ecUpperCase
        MaxLength = 50
        TabOrder = 0
        OnEnter = edtScannerInputEnter
        OnExit = edtScannerInputExit
        OnKeyDown = edtScannerInputKeyDown
        OnKeyPress = edtScannerInputKeyPress
        OnKeyUp = edtScannerInputKeyUp
      end
    end
    object Panel3: TPanel
      Left = 304
      Top = 0
      Width = 184
      Height = 50
      Align = alRight
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object btnDone: TButton
        Left = 26
        Top = 13
        Width = 63
        Height = 25
        Caption = '&OK'
        ModalResult = 1
        TabOrder = 0
        OnClick = btnDoneClick
      end
      object btnCancel: TButton
        Left = 96
        Top = 13
        Width = 63
        Height = 25
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 488
    Height = 260
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 488
      Height = 260
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        488
        260)
      object Label2: TVA508StaticText
        Name = 'Label2'
        Left = 8
        Top = 227
        Width = 355
        Height = 15
        Alignment = taLeftJustify
        AutoSize = True
        Caption = 
          'If Unable to Scan, type the bar code number for each component, ' +
          'pressing'
        ParentColor = True
        TabOrder = 2
        ShowAccelChar = True
      end
      object Label5: TVA508StaticText
        Name = 'Label5'
        Left = 8
        Top = 242
        Width = 387
        Height = 15
        Alignment = taLeftJustify
        AutoSize = True
        Caption = 
          'When typing a bar code, enter numeric values only (omit non-nume' +
          'ric characters).'
        ParentColor = True
        TabOrder = 5
        ShowAccelChar = True
      end
      object Label3: TVA508StaticText
        Name = 'Label3'
        Left = 365
        Top = 227
        Width = 41
        Height = 15
        Alignment = taLeftJustify
        AutoSize = True
        Caption = '[Enter]'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 3
        ShowAccelChar = True
      end
      object Label4: TVA508StaticText
        Name = 'Label4'
        Left = 406
        Top = 227
        Width = 79
        Height = 15
        Alignment = taLeftJustify
        AutoSize = True
        Caption = 'after each entry.'
        ParentColor = True
        TabOrder = 4
        ShowAccelChar = True
      end
      object Memo1: TMemo
        Left = 8
        Top = 184
        Width = 417
        Height = 37
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          
            'Continue scanning each additive and/or solution only once. When ' +
            'finished, click OK to '
          'search for an order on the Virtual Due List.')
        ReadOnly = True
        TabOrder = 1
      end
      object lstWardStock: TListBox
        Left = 5
        Top = 8
        Width = 476
        Height = 173
        Anchors = [akLeft, akTop, akRight, akBottom]
        Enabled = False
        ExtendedSelect = False
        ItemHeight = 13
        TabOrder = 0
      end
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 264
    Top = 264
    Data = (
      (
        'Component = Label2'
        'Status = stsDefault')
      (
        'Component = Label5'
        'Status = stsDefault')
      (
        'Component = Label3'
        'Status = stsDefault')
      (
        'Component = Label4'
        'Status = stsDefault')
      (
        'Component = frmWardStock'
        'Status = stsDefault')
      (
        'Component = edtScannerInput'
        'Label = lblScanMedication'
        'Status = stsOK')
      (
        'Component = lstWardStock'
        'Status = stsDefault')
      (
        'Component = pnlScannerStatus'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = pnlScannerIndicator'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Memo1'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = lblScannerStatusReady'
        'Label = lblScannerStatus'
        'Status = stsOK')
      (
        'Component = pnlScannerInput'
        'Status = stsDefault'))
  end
end
