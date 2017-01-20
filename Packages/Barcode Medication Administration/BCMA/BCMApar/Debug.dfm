object frmDebug: TfrmDebug
  Left = 413
  Top = 302
  BorderIcons = []
  Caption = 'frmDebug'
  ClientHeight = 305
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 264
    Width = 744
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 555
      Top = 0
      Width = 189
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnClose: TButton
        Left = 106
        Top = 10
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Close'
        Default = True
        ModalResult = 2
        TabOrder = 0
        OnClick = btnCloseClick
      end
      object btnPrint: TButton
        Left = 20
        Top = 10
        Width = 75
        Height = 25
        Caption = 'Print'
        TabOrder = 1
        OnClick = btnPrintClick
      end
    end
    object chkDebug: TCheckBox
      Left = 16
      Top = 16
      Width = 129
      Height = 17
      Caption = 'Enable Debug Mode'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = chkDebugClick
    end
  end
  object Memo1: TRichEdit
    Left = 0
    Top = 0
    Width = 744
    Height = 264
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
end
