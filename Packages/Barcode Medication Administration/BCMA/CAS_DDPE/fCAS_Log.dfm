object frmCAS_Log: TfrmCAS_Log
  Left = 0
  Top = 0
  Caption = 'frmCAS_Log'
  ClientHeight = 540
  ClientWidth = 590
  Color = clMoneyGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object splCalendar: TSplitter
    Left = 121
    Top = 0
    Height = 540
    Color = clSilver
    ParentColor = False
    ExplicitLeft = 264
    ExplicitTop = 208
    ExplicitHeight = 100
  end
  object pnlCalendar: TPanel
    Left = 0
    Top = 0
    Width = 121
    Height = 540
    Align = alLeft
    BevelOuter = bvNone
    Color = clCream
    TabOrder = 0
    object pnlCalHeader: TPanel
      Left = 0
      Top = 0
      Width = 121
      Height = 25
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = '  Calendar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object dbgCalendar: TDBGrid
      Left = 0
      Top = 25
      Width = 121
      Height = 495
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsCalendar
      FixedColor = clInfoBk
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = dbgCalendarDrawColumnCell
    end
    object pnlCalFooter: TPanel
      Left = 0
      Top = 520
      Width = 121
      Height = 20
      Align = alBottom
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Visible = False
    end
  end
  object pnlOrdersComments: TPanel
    Left = 124
    Top = 0
    Width = 466
    Height = 540
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlOrdersComments'
    TabOrder = 1
    object splDateComment: TSplitter
      Left = 0
      Top = 153
      Width = 466
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitWidth = 139
    end
    object pnlComments: TPanel
      Left = 0
      Top = 156
      Width = 466
      Height = 384
      Align = alClient
      BevelOuter = bvNone
      Color = clCream
      TabOrder = 0
      object pnlCommentsHeader: TPanel
        Left = 0
        Top = 0
        Width = 466
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          466
          25)
        object spbAddComment: TSpeedButton
          Left = 344
          Top = 1
          Width = 121
          Height = 20
          Anchors = [akTop, akRight]
          Caption = 'Add Comment'
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
            000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
            00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
            F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
            0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
            FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
            FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
            0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
            00333377737FFFFF773333303300000003333337337777777333}
          NumGlyphs = 2
          OnClick = spbAddCommentClick
        end
        object spbGrid: TSpeedButton
          Left = 5
          Top = 1
          Width = 42
          Height = 20
          GroupIndex = 20
          Down = True
          Caption = 'Table'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = spbDataClick
        end
        object spbData: TSpeedButton
          Left = 48
          Top = 1
          Width = 40
          Height = 20
          GroupIndex = 20
          Caption = 'Text'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = spbDataClick
        end
      end
      object mmDetails: TMemo
        Left = 0
        Top = 25
        Width = 466
        Height = 339
        Align = alClient
        BorderStyle = bsNone
        Color = clCream
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object vleMedLogRecord: TValueListEditor
        Left = 0
        Top = 25
        Width = 466
        Height = 339
        Align = alClient
        BorderStyle = bsNone
        Ctl3D = False
        FixedColor = clInfoBk
        ParentCtl3D = False
        ScrollBars = ssVertical
        TabOrder = 2
        TitleCaptions.Strings = (
          'Item'
          'Value')
        Visible = False
        ColWidths = (
          163
          301)
      end
      object dbgComments: TDBGrid
        Left = 0
        Top = 25
        Width = 466
        Height = 339
        Align = alClient
        BorderStyle = bsNone
        DataSource = dsComments
        FixedColor = clInfoBk
        Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Visible = False
      end
      object pnlCommentsFooter: TPanel
        Left = 0
        Top = 364
        Width = 466
        Height = 20
        Align = alBottom
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        Visible = False
      end
    end
    object pnlMedLog: TPanel
      Left = 0
      Top = 0
      Width = 466
      Height = 153
      Align = alTop
      BevelOuter = bvNone
      Color = clCream
      TabOrder = 1
      object pnlMedLogHdr: TPanel
        Left = 0
        Top = 0
        Width = 466
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object dbtDate: TDBText
          Left = 8
          Top = 6
          Width = 46
          Height = 13
          AutoSize = True
          DataSource = dsCalendar
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object pnlDate: TPanel
          Left = 120
          Top = 0
          Width = 346
          Height = 25
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          object spbBack: TSpeedButton
            Left = 35
            Top = 1
            Width = 27
            Height = 22
            Caption = '<<'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = spbBackClick
          end
          object spbForward: TSpeedButton
            Left = 152
            Top = 1
            Width = 27
            Height = 22
            Caption = '>>'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = spbForwardClick
          end
          object btnRefresh: TSpeedButton
            Left = 321
            Top = 0
            Width = 23
            Height = 22
            Flat = True
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000130B0000130B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
              3333333777333777FF33339993707399933333773337F3777FF3399933000339
              9933377333777F3377F3399333707333993337733337333337FF993333333333
              399377F33333F333377F993333303333399377F33337FF333373993333707333
              333377F333777F333333993333101333333377F333777F3FFFFF993333000399
              999377FF33777F77777F3993330003399993373FF3777F37777F399933000333
              99933773FF777F3F777F339993707399999333773F373F77777F333999999999
              3393333777333777337333333999993333333333377777333333}
            NumGlyphs = 2
            OnClick = btnRefreshClick
          end
          object spbNow: TSpeedButton
            Left = 1
            Top = 1
            Width = 34
            Height = 22
            Caption = 'Now'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = spbNowClick
          end
          object dtpkrHigh: TDateTimePicker
            Left = 64
            Top = 1
            Width = 86
            Height = 21
            HelpContext = 232
            BevelInner = bvNone
            Date = 42370.000000000000000000
            Time = 42370.000000000000000000
            Color = clBtnFace
            ParentColor = True
            TabOrder = 0
            OnChange = dtpkrHighChange
          end
          object edEnd: TEdit
            Left = 239
            Top = 2
            Width = 76
            Height = 19
            Ctl3D = False
            ParentColor = True
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 1
          end
          object cmbSpan: TComboBox
            Left = 180
            Top = 1
            Width = 53
            Height = 21
            ItemHeight = 13
            TabOrder = 2
            Text = '30'
            OnChange = dtpkrHighChange
            Items.Strings = (
              '30'
              '60'
              '122'
              '365'
              '730')
          end
        end
      end
      object dbgMedLog: TDBGrid
        Left = 0
        Top = 25
        Width = 466
        Height = 128
        Align = alClient
        BorderStyle = bsNone
        DataSource = dsMedLog
        FixedColor = clInfoBk
        Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
  end
  object dsCalendar: TDataSource
    DataSet = cdsCalendar
    OnDataChange = dsCalendarDataChange
    Left = 16
    Top = 96
  end
  object cdsCalendar: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cdsCalendarIndex1'
      end>
    Params = <>
    StoreDefs = True
    Left = 16
    Top = 64
  end
  object cdsMedLog: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cdsCalendarIndex1'
      end>
    Params = <>
    StoreDefs = True
    Left = 24
    Top = 208
  end
  object dsMedLog: TDataSource
    DataSet = cdsMedLog
    OnDataChange = dsMedLogDataChange
    Left = 24
    Top = 240
  end
  object cdsComments: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cdsCalendarIndex1'
      end>
    Params = <>
    StoreDefs = True
    Left = 24
    Top = 304
  end
  object dsComments: TDataSource
    DataSet = cdsComments
    Left = 24
    Top = 336
  end
end
