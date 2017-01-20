object frmMissingDose: TfrmMissingDose
  Left = 394
  Top = 168
  HelpContext = 50
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  BorderWidth = 15
  Caption = 'Missing Dose Request'
  ClientHeight = 292
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 409
    Height = 292
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TabStop = False
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 401
        Height = 264
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblLocation: TLabel
          Left = 10
          Top = 9
          Width = 41
          Height = 13
          Caption = 'Location'
        end
        object Label3: TLabel
          Left = 10
          Top = 126
          Width = 91
          Height = 13
          Caption = 'Administration Time'
        end
        object Label4: TLabel
          Left = 189
          Top = 167
          Width = 37
          Height = 13
          Caption = '&Reason'
          FocusControl = cbxReason
        end
        object Label5: TLabel
          Left = 10
          Top = 166
          Width = 98
          Height = 13
          Caption = '&Date@Time Needed'
          FocusControl = edTimeNeeded
        end
        object Label6: TLabel
          Left = 10
          Top = 88
          Width = 37
          Height = 13
          Caption = 'Dosage'
        end
        object Label7: TLabel
          Left = 10
          Top = 50
          Width = 64
          Height = 13
          Caption = 'Ordered Drug'
        end
        object edLocation: TEdit
          Left = 10
          Top = 24
          Width = 159
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
          Text = 'edLocation'
        end
        object edDrugName: TEdit
          Left = 10
          Top = 65
          Width = 337
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 5
          Text = 'edDrugName'
        end
        object btnSend: TButton
          Left = 180
          Top = 214
          Width = 78
          Height = 23
          Caption = '&Submit'
          Default = True
          TabOrder = 2
          OnClick = btnSendClick
        end
        object edDosage: TEdit
          Left = 10
          Top = 102
          Width = 159
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 6
          Text = 'edDosage'
        end
        object edAdminTime: TEdit
          Left = 10
          Top = 140
          Width = 159
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 7
          Text = 'edAdminTime'
        end
        object cbxReason: TComboBox
          Left = 189
          Top = 181
          Width = 159
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          OnEnter = cbxReasonEnter
          Items.Strings = (
            'Dropped'
            'Empty Package'
            'Not Available'
            'Wrong Dose/Drug Delivered'
            'Package Contents Damaged'
            'Package Integrity Damaged'
            'Barcode/IEN Illegible')
        end
        object edTimeNeeded: TEdit
          Left = 10
          Top = 181
          Width = 159
          Height = 21
          CharCase = ecUpperCase
          TabOrder = 0
          OnEnter = edTimeNeededEnter
          OnExit = edTimeNeededExit
        end
        object btnCancel: TButton
          Left = 269
          Top = 214
          Width = 78
          Height = 23
          Cancel = True
          Caption = '&Cancel'
          ModalResult = 2
          TabOrder = 3
          OnClick = btnCancelClick
        end
        object edDrugIEN: TEdit
          Left = 234
          Top = 9
          Width = 159
          Height = 21
          Hint = 'Filer^677301.4^.06'
          TabStop = False
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 8
          Text = 'edDrug'
          Visible = False
        end
      end
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 32
    Top = 240
    Data = (
      (
        'Component = edLocation'
        'Label = lblLocation'
        'Status = stsOK')
      (
        'Component = edDrugName'
        'Label = Label7'
        'Status = stsOK')
      (
        'Component = edDosage'
        'Label = Label6'
        'Status = stsOK')
      (
        'Component = edAdminTime'
        'Label = Label3'
        'Status = stsOK')
      (
        'Component = edTimeNeeded'
        'Label = Label5'
        'Status = stsOK')
      (
        'Component = cbxReason'
        'Label = Label4'
        'Status = stsOK')
      (
        'Component = edDrugIEN'
        'Status = stsDefault')
      (
        'Component = frmMissingDose'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault'))
  end
end
