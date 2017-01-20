object AboutDlg: TAboutDlg
  Left = 495
  Top = 607
  ActiveControl = OKButton
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 371
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 349
    Height = 185
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProgramIcon: TImage
      Left = 20
      Top = 20
      Width = 32
      Height = 32
      AutoSize = True
      Center = True
      Picture.Data = {
        07544269746D617076020000424D760200000000000076000000280000002000
        0000200000000100040000000000000200000000000000000000100000001000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00000000000000000000000000000000000EE8787878EEEEEEE03F30878EEE
        EEE00EE8787878EEEEEEE03F30878EEEEEE00EE8787878EEEEEEE03F30878EEE
        EEE00EE8787878EEEEEEE03F30878EEEEEE00887787877788888803F3088787E
        EEE00788787878878887803F3088887EEEE00788887888878887803F3088887E
        EEE00877888887788888703F308887EEEEE00888777778888888037883088888
        8EE007777777777777703787883087777EE00888888888888803787FF8830888
        888008888888888880378777778830888880077777777788037873F3F3F87808
        88E00888888888803787FFFFFFFF8830EEE00887777778800001111111111100
        EEE00888888888888899B999B99999EEEEE00888888888888899B9B99BB9B9EE
        EEE0088888888888899BB9BB99BB99EEEEE0078888888888899B999B999999EE
        EEE0087788888778899B9B9BB9BB99EEEEE00888778778888E9B9B9BB9999EEE
        EEE0088888788888EE9B99B9BB9BEEEEEEE00EE8888888EEEEE999B9999EEEEE
        EEE00EEEE888EEEEEEEE99BB999EEEEEEEE00EEEEE8EEEEEEEEEE999B9EEEEEE
        EEE00EEEEE8EEEEEEEEEEEE999EEEEEEEEE00EEEEE8EEEEEEEEEEEEE99EEEEEE
        EEE00EEEEE8EEEEEEEEEEEEE9EEEEEEEEEE00EEEEE8EEEEEEEEEEEEEEEEEEEEE
        EEE00EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE00000000000000000000000000000
        0000}
      Stretch = True
      IsControl = True
    end
    object edtProductName: TEdit
      Left = 73
      Top = 16
      Width = 240
      Height = 16
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'Product Name'
    end
    object edtVersion: TEdit
      Left = 73
      Top = 38
      Width = 256
      Height = 16
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = 'Product Version'
    end
    object edtReleaseDate: TEdit
      Left = 73
      Top = 57
      Width = 256
      Height = 16
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = 'Release Date'
    end
    object edtCopyRight: TEdit
      Left = 8
      Top = 83
      Width = 321
      Height = 28
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
      Text = 'Legal Copy Right'
    end
    object edtComments: TEdit
      Left = 8
      Top = 117
      Width = 321
      Height = 34
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
      Text = 'Comments'
    end
    object edtCRC: TEdit
      Left = 8
      Top = 157
      Width = 321
      Height = 16
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
      Text = 'CRC'
    end
  end
  object OKButton: TButton
    Left = 278
    Top = 333
    Width = 75
    Height = 30
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
  end
  object pnl508: TPanel
    Left = 8
    Top = 204
    Width = 353
    Height = 123
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object RichEdit1: TRichEdit
      Left = 8
      Top = 15
      Width = 337
      Height = 97
      Alignment = taCenter
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        
          'VHA'#8217's Office of Information, Health Systems Design && Developmen' +
          't '
        'staff have made every effort during the design, development and '
        
          'testing of this application to ensure full accessibility to all ' +
          'users in '
        
          'compliance with Section 508 of the Rehabilitation Act of 1973, a' +
          's '
        'amended.  Please send any comments, questions or concerns '
        'regarding the accessibility of this application to BCMA508'
        '@domain.ext.')
      ReadOnly = True
      TabOrder = 0
    end
  end
end
