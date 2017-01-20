object frmReport: TfrmReport
  Left = 450
  Top = 194
  BorderWidth = 10
  Caption = 'Report'
  ClientHeight = 527
  ClientWidth = 764
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 764
    Height = 494
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object ReportText: TRichEdit
      Left = 0
      Top = 0
      Width = 764
      Height = 494
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      PlainText = True
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
      OnEnter = ReportTextEnter
    end
  end
  object pnlButton: TPanel
    Left = 0
    Top = 494
    Width = 764
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel1: TPanel
      Left = 163
      Top = 0
      Width = 601
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnClose: TButton
        Left = 515
        Top = 6
        Width = 75
        Height = 25
        Cancel = True
        Caption = '&Cancel'
        Default = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ModalResult = 2
        ParentFont = False
        TabOrder = 4
        OnClick = btnCloseClick
      end
      object btnPrint: TButton
        Left = 337
        Top = 6
        Width = 75
        Height = 25
        Cancel = True
        Caption = '&Print'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnPrintClick
      end
      object btnNext: TButton
        Left = 426
        Top = 6
        Width = 75
        Height = 25
        Cancel = True
        Caption = '&Next'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ModalResult = 1
        ParentFont = False
        TabOrder = 3
      end
      object lblCount: TStaticText
        Left = 132
        Top = 13
        Width = 90
        Height = 20
        Caption = 'Report x of x'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = True
      end
      object btnPrintLocal: TButton
        Left = 251
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Print &Local'
        Enabled = False
        TabOrder = 1
        TabStop = False
        Visible = False
        OnClick = btnPrintLocalClick
      end
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 712
    Top = 16
  end
end
