object frmInfoBoxWithBtnControl: TfrmInfoBoxWithBtnControl
  Left = 0
  Top = 0
  Caption = 'frmInfoBoxWithBtnControl'
  ClientHeight = 236
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 120
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 233
    Width = 633
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
    Color = clScrollBar
    ParentColor = False
    ExplicitTop = 277
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 185
    Align = alTop
    Color = clBtnHighlight
    ParentBackground = False
    TabOrder = 0
    object lblText: TVA508StaticText
      Name = 'lblText'
      Left = 32
      Top = 32
      Width = 6
      Height = 18
      Alignment = taLeftJustify
      Caption = ''
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  object GridPanel1: TGridPanel
    Left = 0
    Top = 185
    Width = 633
    Height = 48
    Align = alClient
    ColumnCollection = <
      item
        Value = 25.509616554714540000
      end
      item
        Value = 24.789574278965090000
      end
      item
        Value = 24.710797376519240000
      end
      item
        Value = 24.990011789801120000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = Button1
        Row = 0
      end
      item
        Column = 1
        Control = Button2
        Row = 0
      end
      item
        Column = 2
        Control = Button3
        Row = 0
      end
      item
        Column = 3
        Control = Button4
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 1
    DesignSize = (
      633
      48)
    object Button1: TButton
      Left = 35
      Top = 4
      Width = 91
      Height = 40
      Anchors = []
      Caption = 'Button1'
      TabOrder = 0
      OnClick = BtnClick
      ExplicitLeft = 32
      ExplicitTop = 2
    end
    object Button2: TButton
      Left = 191
      Top = 4
      Width = 96
      Height = 39
      Anchors = []
      Caption = 'Button2'
      TabOrder = 1
      OnClick = BtnClick
      ExplicitTop = 34
    end
    object Button3: TButton
      Left = 357
      Top = 4
      Width = 75
      Height = 39
      Anchors = []
      Caption = 'Button3'
      TabOrder = 2
      OnClick = BtnClick
      ExplicitTop = 34
    end
    object Button4: TButton
      Left = 514
      Top = 2
      Width = 75
      Height = 43
      Anchors = []
      Caption = 'Button4'
      TabOrder = 3
      OnClick = BtnClick
      ExplicitTop = 16
    end
  end
end
