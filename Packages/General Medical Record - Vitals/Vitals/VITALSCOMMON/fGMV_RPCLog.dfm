object frmGMV_RPCLog: TfrmGMV_RPCLog
  Left = 538
  Top = 190
  Width = 1009
  Height = 623
  Caption = 'RPC Log'
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 337
    Top = 41
    Width = 4
    Height = 529
    Cursor = crHSplit
    Color = clSilver
    ParentColor = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1001
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = clSilver
    TabOrder = 0
    DesignSize = (
      1001
      41)
    object BitBtn1: TBitBtn
      Left = 919
      Top = 8
      Width = 75
      Height = 25
      Hint = 'Close window'
      Anchors = [akTop, akRight]
      Caption = '&Close'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object CheckBox1: TCheckBox
      Left = 10
      Top = 11
      Width = 97
      Height = 17
      Hint = 'Keep this window above others '
      Caption = '&Stay On Top'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = CheckBox1Click
    end
  end
  object Panel3: TPanel
    Left = 341
    Top = 41
    Width = 660
    Height = 529
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object mm: TMemo
      Left = 0
      Top = 30
      Width = 660
      Height = 499
      Hint = 'RPC call detailed description'
      Align = alClient
      BorderStyle = bsNone
      Color = clCream
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ScrollBars = ssBoth
      ShowHint = True
      TabOrder = 0
    end
    object pnlTitle: TPanel
      Left = 0
      Top = 0
      Width = 660
      Height = 30
      Align = alTop
      BevelOuter = bvLowered
      TabOrder = 1
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 337
    Height = 529
    ActivePage = tsEvents
    Align = alLeft
    TabIndex = 1
    TabOrder = 2
    TabPosition = tpBottom
    object tsRPC: TTabSheet
      Caption = 'RPC'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 329
        Height = 503
        Align = alClient
        BevelOuter = bvNone
        Constraints.MinWidth = 175
        TabOrder = 0
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 329
          Height = 27
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            329
            27)
          object Label1: TLabel
            Left = 10
            Top = 5
            Width = 88
            Height = 13
            Caption = '&Log Size (records) '
            FocusControl = ComboBox1
          end
          object ComboBox1: TComboBox
            Left = 112
            Top = 1
            Width = 212
            Height = 21
            Hint = 'Select the number of records to keep in the log'
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            Color = clInfoBk
            Ctl3D = False
            ItemHeight = 13
            ParentCtl3D = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Items.Strings = (
              '300'
              '100'
              '50'
              '30')
          end
        end
        object lbLog: TListBox
          Left = 0
          Top = 27
          Width = 329
          Height = 476
          Hint = 'Executed RPC Log'
          Align = alClient
          BorderStyle = bsNone
          Color = clCream
          Ctl3D = False
          ItemHeight = 13
          ParentCtl3D = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = lbLogClick
        end
      end
    end
    object tsEvents: TTabSheet
      Caption = 'Events'
      ImageIndex = 1
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 329
        Height = 503
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 329
          Height = 29
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            329
            29)
          object Label2: TLabel
            Left = 10
            Top = 5
            Width = 88
            Height = 13
            Caption = '&Log Size (records) '
            FocusControl = ComboBox2
          end
          object ComboBox2: TComboBox
            Left = 112
            Top = 1
            Width = 212
            Height = 21
            Hint = 'Select the number of records to keep in the log'
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            Color = clCream
            ItemHeight = 13
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Items.Strings = (
              '300'
              '100'
              '50'
              '30')
          end
        end
        object lbRoutines: TListBox
          Left = 0
          Top = 29
          Width = 329
          Height = 474
          Hint = 'Executed RPC Log'
          Align = alClient
          BorderStyle = bsNone
          Color = 14215640
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ItemHeight = 14
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = lbRoutinesClick
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 570
    Width = 1001
    Height = 19
    Panels = <>
    SimplePanel = False
  end
end
