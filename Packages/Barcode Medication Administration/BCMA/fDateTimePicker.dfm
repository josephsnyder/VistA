object frmDateTimePicker: TfrmDateTimePicker
  Left = 538
  Top = 216
  HelpContext = 500
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'BCMA - Date/Time Selection'
  ClientHeight = 304
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 361
    Height = 257
    Align = alTop
    TabOrder = 0
    object Panel1: TPanel
      Left = 2
      Top = 15
      Width = 231
      Height = 240
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 0
      object lblDateTime: TLabel
        Left = 8
        Top = 8
        Width = 56
        Height = 13
        Caption = 'lblDateTime'
        FocusControl = calCalendar
      end
      object calCalendar: TMonthCalendar
        Left = 19
        Top = 40
        Width = 197
        Height = 153
        Date = 40402.653942615740000000
        MinDate = 29221.000000000000000000
        TabOrder = 0
        TabStop = True
        OnClick = calCalendarClick
      end
      object btnCalendarMinus: TButton
        Left = 19
        Top = 208
        Width = 49
        Height = 25
        Caption = '<<'
        TabOrder = 1
        OnClick = btnCalendarMinusClick
      end
      object btnToday: TButton
        Left = 89
        Top = 208
        Width = 49
        Height = 25
        Caption = '&Today'
        TabOrder = 2
        OnClick = btnTodayClick
      end
      object btnCalendarPlus: TButton
        Left = 160
        Top = 208
        Width = 49
        Height = 25
        Caption = '>>'
        TabOrder = 3
        OnClick = btnCalendarPlusClick
      end
    end
    object pnlTime: TPanel
      Left = 233
      Top = 15
      Width = 126
      Height = 240
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 26
        Height = 13
        Caption = 'Time:'
      end
      object lstHours: TListBox
        Left = 8
        Top = 40
        Width = 49
        Height = 161
        ItemHeight = 13
        Items.Strings = (
          '00'
          '01'
          '02'
          '03'
          '04'
          '05'
          '06'
          '07'
          '08'
          '09'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23')
        TabOrder = 0
        OnClick = lstHoursClick
      end
      object lstMinutes: TListBox
        Left = 72
        Top = 40
        Width = 49
        Height = 161
        ItemHeight = 13
        Items.Strings = (
          ':00 -'
          ':05 '
          ':10'
          ':15 -'
          ':20'
          ':25'
          ':30 -'
          ':35'
          ':40'
          ':45 -'
          ':50'
          ':55')
        TabOrder = 1
        OnClick = lstMinutesClick
      end
      object btnNow: TButton
        Left = 8
        Top = 208
        Width = 49
        Height = 25
        Caption = '&Now'
        TabOrder = 2
        OnClick = btnNowClick
      end
      object btnMidNight: TButton
        Left = 72
        Top = 208
        Width = 49
        Height = 25
        Caption = '&Midnight'
        TabOrder = 3
        OnClick = btnMidNightClick
      end
      object edtTime: TMaskEdit
        Left = 48
        Top = 4
        Width = 70
        Height = 21
        EditMask = '!99:99;1; '
        MaxLength = 5
        TabOrder = 4
        Text = '  :  '
        OnExit = edtTimeExit
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 257
    Width = 361
    Height = 47
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      361
      47)
    object btnCancel: TButton
      Left = 280
      Top = 12
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 201
      Top = 12
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 40
    Top = 264
    Data = (
      (
        'Component = frmDateTimePicker'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = lstHours'
        'Status = stsDefault')
      (
        'Component = edtTime'
        'Label = Label1'
        'Status = stsOK')
      (
        'Component = btnCalendarMinus'
        'Text = Previous'
        'Status = stsOK')
      (
        'Component = btnCalendarPlus'
        'Text = Next'
        'Status = stsOK')
      (
        'Component = btnNow'
        'Status = stsDefault')
      (
        'Component = pnlTime'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnToday'
        'Status = stsDefault')
      (
        'Component = btnMidNight'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = GroupBox1'
        'Status = stsDefault')
      (
        'Component = calCalendar'
        'Label = lblDateTime'
        'Status = stsOK'))
  end
end
