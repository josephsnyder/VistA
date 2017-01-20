object frmClosePatientCheck: TfrmClosePatientCheck
  Left = 0
  Top = 0
  Caption = 'Close Patient Check'
  ClientHeight = 366
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object chkMRR: TCheckBox
    Left = 56
    Top = 232
    Width = 218
    Height = 17
    Caption = 'Medications Requiring Removal Pending'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object chkIVP: TCheckBox
    Left = 280
    Top = 232
    Width = 193
    Height = 17
    Caption = 'UD or IVP/IVPB Tab Needs Review'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 280
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnIgnore: TButton
    Left = 168
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Ignore'
    TabOrder = 3
    OnClick = btnIgnoreClick
  end
  object btnOK: TButton
    Left = 56
    Top = 288
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object memMRR: TMemo
    Left = 56
    Top = 16
    Width = 417
    Height = 64
    Color = clBtnFace
    Lines.Strings = (
      
        'One or more medications applied to this patient is ready for rem' +
        'oval.'
      
        'Check the Unit Dose Tab, Next Action column, before closing the ' +
        'patient record.'
      
        'Are you sure you want to close this patient'#39's record before taki' +
        'ng action on the '
      'medication(s) requiring removal?')
    ReadOnly = True
    TabOrder = 5
  end
  object memIVP: TMemo
    Left = 56
    Top = 104
    Width = 417
    Height = 89
    Color = clBtnFace
    Lines.Strings = (
      
        'ACTIVE MEDICATION ORDERS are available for review on these Medic' +
        'ation Tab(s):'
      ''
      '=> Unit Dose'
      '=> IVP/IVPB'
      ''
      
        'Are you sure you want to close this patient'#39#39's record before vie' +
        'wing these Tab(s)?')
    ReadOnly = True
    TabOrder = 6
  end
end
