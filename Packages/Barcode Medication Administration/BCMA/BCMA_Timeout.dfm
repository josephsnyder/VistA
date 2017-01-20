object frmTimeOut: TfrmTimeOut
  Left = 425
  Top = 286
  BorderStyle = bsDialog
  Caption = 'BCMA Timeout'
  ClientHeight = 155
  ClientWidth = 310
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblCaption: TLabel
    Left = 17
    Top = 24
    Width = 285
    Height = 15
    AutoSize = False
    Caption = 'BCMA has been idle and will close in 30 seconds.'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Button1: TButton
    Left = 197
    Top = 114
    Width = 97
    Height = 25
    Caption = '&Don'#39't Close '
    ModalResult = 3
    TabOrder = 0
  end
  object lblCountDown: TStaticText
    Left = 130
    Top = 53
    Width = 41
    Height = 33
    AutoSize = False
    Caption = '30'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Transparent = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 112
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 128
    Top = 112
    Data = (
      (
        'Component = frmTimeOut'
        'Status = stsDefault')
      (
        'Component = lblCountDown'
        'Label = lblCaption'
        'Status = stsOK')
      (
        'Component = Button1'
        'Status = stsDefault'))
  end
end
