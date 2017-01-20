object frmInstructor: TfrmInstructor
  Left = 570
  Top = 319
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Instructor Sign-On'
  ClientHeight = 159
  ClientWidth = 209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 30
    Width = 79
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Access Code:'
  end
  object Label2: TLabel
    Left = 25
    Top = 78
    Width = 70
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Verify Code:'
  end
  object edtAccess: TEdit
    Left = 103
    Top = 26
    Width = 90
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnChange = edtAccessChange
  end
  object edtVerify: TEdit
    Left = 103
    Top = 74
    Width = 90
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 16
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnSignOn: TButton
    Left = 118
    Top = 120
    Width = 75
    Height = 25
    Caption = '&Sign On'
    Default = True
    Enabled = False
    TabOrder = 3
    OnClick = btnSignOnClick
  end
end
