object frmSelectInjection: TfrmSelectInjection
  Left = 0
  Top = 0
  HelpContext = 129
  BorderIcons = [biSystemMenu]
  BorderWidth = 10
  Caption = 'Injection Site Form'
  ClientHeight = 543
  ClientWidth = 882
  Color = clBtnFace
  Constraints.MaxWidth = 1024
  Constraints.MinHeight = 543
  Constraints.MinWidth = 870
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 15
  object pnlButton: TPanel
    Left = 0
    Top = 505
    Width = 882
    Height = 38
    Align = alBottom
    Anchors = [akRight]
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      882
      38)
    object SpeedButton7: TSpeedButton
      Left = 661
      Top = 13
      Width = 23
      Height = 22
      Caption = 'dbg'
      Flat = True
      Visible = False
      OnClick = SpeedButton7Click
    end
    object btnOK: TButton
      Left = 719
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 807
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
    end
    object pnlDebug: TPanel
      Left = 0
      Top = 0
      Width = 625
      Height = 38
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object SpeedButton1: TSpeedButton
        Left = 253
        Top = 13
        Width = 57
        Height = 22
        Caption = 'Window'
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TSpeedButton
        Left = 310
        Top = 13
        Width = 57
        Height = 22
        Caption = 'Group 1'
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton2Click
      end
      object SpeedButton3: TSpeedButton
        Left = 435
        Top = 13
        Width = 57
        Height = 22
        Caption = 'Group 2'
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton3Click
      end
      object SpeedButton4: TSpeedButton
        Left = 559
        Top = 12
        Width = 57
        Height = 22
        Caption = 'Label'
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton4Click
      end
      object SpeedButton5: TSpeedButton
        Left = 367
        Top = 13
        Width = 57
        Height = 22
        Caption = 'Table 1'
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton5Click
      end
      object SpeedButton6: TSpeedButton
        Left = 492
        Top = 13
        Width = 57
        Height = 22
        Caption = 'Table 2'
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton6Click
      end
      object ckbAckRoute: TCheckBox
        Left = 110
        Top = 17
        Width = 129
        Height = 17
        Caption = 'Show Ack Route C/B'
        Font.Charset = ANSI_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = ckbAckRouteClick
      end
      object pnlTools: TPanel
        Left = 0
        Top = 0
        Width = 104
        Height = 38
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object spbChart: TSpeedButton
          Left = 55
          Top = 13
          Width = 23
          Height = 22
          GroupIndex = 10
          Caption = 'v.2'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clPurple
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnClick = spbOldClick
        end
        object spbNew: TSpeedButton
          Left = 32
          Top = 13
          Width = 23
          Height = 22
          GroupIndex = 10
          Caption = 'v.1'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clPurple
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
          OnClick = spbOldClick
        end
        object spbOld: TSpeedButton
          Left = 8
          Top = 13
          Width = 23
          Height = 22
          GroupIndex = 10
          Down = True
          Caption = 'v.0'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clPurple
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
          OnClick = spbOldClick
        end
        object spbThree: TSpeedButton
          Left = 78
          Top = 13
          Width = 23
          Height = 22
          GroupIndex = 10
          Caption = 'v.3'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clPurple
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnClick = spbOldClick
        end
      end
    end
  end
  object pnlSelInjSite: TPanel
    Left = 0
    Top = 367
    Width = 882
    Height = 138
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 2
    object pnlAckRoute: TPanel
      Left = 1
      Top = 1
      Width = 880
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object grpAckRoute: TGroupBox
        Left = 0
        Top = 0
        Width = 880
        Height = 40
        Align = alClient
        TabOrder = 0
        object chkAckRoute: TCheckBox
          Left = 3
          Top = 9
          Width = 374
          Height = 25
          Caption = 'I acknowledge this medication is to be administered via &route:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          WordWrap = True
          OnClick = chkAckRouteClick
        end
        object txtRoute: TStaticText
          Left = 386
          Top = 14
          Width = 52
          Height = 17
          Caption = 'txtRoute'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          TabStop = True
        end
      end
    end
    object pnlSiteSelector: TPanel
      Left = 1
      Top = 41
      Width = 880
      Height = 96
      Align = alClient
      TabOrder = 1
      DesignSize = (
        880
        96)
      object lblSiteSelector: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 5
        Width = 119
        Height = 15
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'Select &Injection Site:'
        FocusControl = lbSiteSelector
        Transparent = False
      end
      object lblSelectCaption: TLabel
        AlignWithMargins = True
        Left = 584
        Top = 4
        Width = 119
        Height = 16
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'Select &Injection Site:'
        FocusControl = cbxSelections
        Transparent = False
        Visible = False
      end
      object lbSiteSelector: TListBox
        Left = 3
        Top = 25
        Width = 872
        Height = 66
        HelpContext = 207
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clCream
        Columns = 4
        ItemHeight = 15
        TabOrder = 0
        OnClick = lbSiteSelectorClick
        OnEnter = lbSiteSelectorEnter
      end
      object cbxSelections: TComboBox
        Left = 709
        Top = 1
        Width = 166
        Height = 21
        HelpContext = 129
        Style = csSimple
        Anchors = [akTop, akRight]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 2
        TabStop = False
        Visible = False
        OnClick = cbxSelectionsClick
        OnEnter = cbxSelectionsEnter
      end
      object bbSelectFromChart: TBitBtn
        Left = 386
        Top = 6
        Width = 162
        Height = 16
        Caption = '&Select from Body Diagram'
        TabOrder = 1
        OnClick = bbSelectFromChartClick
      end
    end
  end
  object grpPrevBodySitesOrderItem: TGroupBox
    Left = 0
    Top = 0
    Width = 882
    Height = 173
    Align = alTop
    Caption = '&Previous Injection Sites for this Medication (up to 4)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    TabStop = True
    DesignSize = (
      882
      173)
    object lblOrderableItem: TLabel
      Left = 8
      Top = 21
      Width = 88
      Height = 13
      Caption = 'Orderable Item:'
      FocusControl = lblOrderableItemText
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblRoute: TLabel
      Left = 479
      Top = 21
      Width = 39
      Height = 13
      Caption = 'Route:'
      FocusControl = lblRouteText
      Transparent = False
    end
    object lvwPrevBodySitesOrderItem: TListView
      Left = 3
      Top = 40
      Width = 872
      Height = 126
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      Columns = <
        item
          Caption = 'Date Time'
          MinWidth = 125
          Width = 125
        end
        item
          Caption = 'Medication'
          MinWidth = 280
          Width = 280
        end
        item
          Caption = 'Dosage Given'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Route'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Injection Site'
          MinWidth = 220
          Width = 220
        end>
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ReadOnly = True
      ParentFont = False
      TabOrder = 2
      ViewStyle = vsReport
      OnClick = lvwPrevBodySitesOrderItemClick
    end
    object ckbDebug: TCheckBox
      Left = 814
      Top = -2
      Width = 58
      Height = 17
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'Debug'
      Font.Charset = ANSI_CHARSET
      Font.Color = clPurple
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Visible = False
      OnClick = ckbDebugClick
    end
    object lblOrderableItemText: TVA508StaticText
      Name = 'lblOrderableItemText'
      Left = 102
      Top = 19
      Width = 371
      Height = 15
      Alignment = taLeftJustify
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Caption = 'XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXX'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      TabStop = True
      ShowAccelChar = True
    end
    object lblRouteText: TVA508StaticText
      Name = 'lblRouteText'
      Left = 524
      Top = 22
      Width = 347
      Height = 15
      Alignment = taLeftJustify
      Caption = 'XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXX'
      TabOrder = 1
      TabStop = True
      ShowAccelChar = True
    end
  end
  object grpPrevBodySitesPatient: TGroupBox
    Left = 0
    Top = 173
    Width = 882
    Height = 194
    Align = alClient
    Caption = '&All Injection Sites'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    TabStop = True
    DesignSize = (
      882
      194)
    object lvwPrevBodySitesPatient: TListView
      Left = 2
      Top = 15
      Width = 873
      Height = 177
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBtnFace
      Columns = <
        item
          Caption = 'Date Time'
          MinWidth = 125
          Width = 125
        end
        item
          Caption = 'Medication'
          MinWidth = 280
          Width = 280
        end
        item
          Caption = 'Dosage Given'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Route'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Injection Site'
          MinWidth = 220
          Width = 220
        end>
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ReadOnly = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lvwPrevBodySitesPatientClick
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 424
    Top = 8
    Data = (
      (
        'Component = lvwPrevBodySitesOrderItem'
        'Status = stsDefault')
      (
        'Component = frmSelectInjection'
        'Status = stsDefault')
      (
        'Component = lblOrderableItemText'
        'Label = lblOrderableItem'
        'Status = stsOK')
      (
        'Component = lblRouteText'
        'Label = lblRoute'
        'Status = stsOK')
      (
        'Component = lbSiteSelector'
        'Label = lblSiteSelector'
        'Status = stsOK')
      (
        'Component = bbSelectFromChart'
        'Status = stsDefault'))
  end
end
