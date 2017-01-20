object frmBCMAParameters: TfrmBCMAParameters
  Left = 549
  Top = 79
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'BCMA Site Parameters'
  ClientHeight = 772
  ClientWidth = 526
  Color = clWindow
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000CCCCCCCCC0BBBBBBBBB0000000000
    0CCCCCCCCCCC0BBBBBBBBBBB00000000CCBBBCCCBBCC0BCBBBCBCBBCB0000000
    CCBCCBCBCCBC0BCBBBCBCBBCB000000CCCBCCBCBCCCC0BCBBBCBCBBCBB00000C
    CCBBBCCBCCCC0BCBBBCBCCCCBB00000CCCBCCBCBCCCC0BCBCBCBCBBCBB000000
    CCBCCBCBCCBC0BCCBCCBCBBCB0000000CCBBBCCCBBCC0BCBBBCBBCCBB0000000
    0CCCCCCCCCCC0BBBBBBBBBBB00000000000CCCCCCCCC0BBBBBBBBB0000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFC6663199C6663199C6663199C6663199C6663199C666
    3199C6663199C6663199C6663199FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE00
    003FF800000FF0000007E0000003E0000003C0000001C0000001C0000001E000
    0003E0000003F0000007F800000FFE00003FFFFFFFFFFFFFFFFFFFFFFFFF}
  Menu = menu
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 526
    Height = 772
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object lblDivision: TLabel
      Left = 17
      Top = 248
      Width = 432
      Height = 66
      Alignment = taCenter
      AutoSize = False
      Caption = 'lblDivision'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object gbBCMA: TGroupBox
      Left = 78
      Top = 66
      Width = 305
      Height = 161
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      object lblSilver: TLabel
        Left = 16
        Top = 26
        Width = 274
        Height = 110
        Alignment = taCenter
        AutoSize = False
        Caption = 'BCMA Parameters'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -48
        Font.Name = 'Lucida Sans'
        Font.Style = [fsItalic]
        ParentColor = False
        ParentFont = False
        Transparent = True
        WordWrap = True
      end
      object lblBlack: TLabel
        Left = 15
        Top = 24
        Width = 274
        Height = 110
        Alignment = taCenter
        AutoSize = False
        Caption = 'BCMA Parameters'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -48
        Font.Name = 'Lucida Sans'
        Font.Style = [fsItalic]
        ParentFont = False
        Transparent = True
        WordWrap = True
      end
    end
    object PageControl1: TPageControl
      Left = 5
      Top = 5
      Width = 516
      Height = 762
      ActivePage = tsAnswerList
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MultiLine = True
      ParentFont = False
      TabOrder = 1
      TabStop = False
      Visible = False
      OnChange = PageControl1Change
      OnChanging = PageControl1Changing
      object tsFacility: TTabSheet
        HelpContext = 2
        Caption = 'F&acility'
        ParentShowHint = False
        ShowHint = True
        object GroupBox5: TGroupBox
          Left = 0
          Top = 0
          Width = 508
          Height = 201
          Align = alTop
          Caption = 'Facility Information (Read-Only) '
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          object Label6: TLabel
            Left = 295
            Top = 142
            Width = 56
            Height = 13
            Caption = 'Zip Code:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label5: TLabel
            Left = 198
            Top = 142
            Width = 35
            Height = 13
            Caption = 'State:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label4: TLabel
            Left = 10
            Top = 142
            Width = 26
            Height = 13
            Caption = 'City:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label3: TLabel
            Left = 10
            Top = 102
            Width = 89
            Height = 13
            Caption = 'Address Line 2:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label2: TLabel
            Left = 10
            Top = 62
            Width = 89
            Height = 13
            Caption = 'Address Line 1:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label1: TLabel
            Left = 10
            Top = 24
            Width = 37
            Height = 13
            Caption = 'Name:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object edtAddressZip: TEdit
            Left = 294
            Top = 156
            Width = 59
            Height = 21
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 5
            Text = '00000'
          end
          object edtAddressState: TEdit
            Left = 198
            Top = 156
            Width = 89
            Height = 21
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 4
            Text = 'KANSAS'
          end
          object edtAddressCity: TEdit
            Left = 10
            Top = 156
            Width = 180
            Height = 21
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 3
            Text = 'METROPOLIS'
          end
          object edtAddress2: TEdit
            Left = 10
            Top = 116
            Width = 280
            Height = 21
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 2
            Text = 'C/O ALL VETERANS'
          end
          object edtAddress1: TEdit
            Left = 10
            Top = 76
            Width = 280
            Height = 21
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            Text = '101 ERROR FREE LANE'
          end
          object edtFacName: TEdit
            Left = 10
            Top = 38
            Width = 343
            Height = 21
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            Text = 'BCMA VA'
          end
        end
        object GroupBox6: TGroupBox
          Left = 0
          Top = 201
          Width = 508
          Height = 533
          Align = alClient
          Caption = ' BCMA Status for Division '
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          TabStop = True
          OnEnter = GroupBox6Enter
          OnExit = GroupBox6Exit
          object Label21: TLabel
            Left = 169
            Top = 17
            Width = 46
            Height = 13
            AutoSize = False
            Caption = 'Notice:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object cbxOnLine: TCheckBox
            Left = 8
            Top = 16
            Width = 105
            Height = 17
            HelpContext = 104
            Alignment = taLeftJustify
            Caption = 'BCMA &On-Line:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnClick = cbxOnLineClick
          end
          object Memo1: TMemo
            Left = 169
            Top = 31
            Width = 201
            Height = 65
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            Lines.Strings = (
              'This parameter only affects users '
              'signing on to the current division.  '
              'Multi-Division sites must enable/ '
              'disable access for each division.')
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object tsParameters: TTabSheet
        HelpContext = 3
        Caption = '&Parameters'
        object pnlLeft: TPanel
          Left = 0
          Top = 0
          Width = 209
          Height = 734
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'pnlLeft'
          TabOrder = 0
          object gbxMissingDosePrinters: TGroupBox
            Left = 0
            Top = 0
            Width = 209
            Height = 113
            Align = alTop
            Caption = 'Output D&evices'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            TabOrder = 0
            TabStop = True
            OnEnter = gbxMissingDosePrintersEnter
            OnExit = gbxMissingDosePrintersExit
            object edtCOMissingDoseReqPrt: TLabeledEdit
              Left = 10
              Top = 78
              Width = 182
              Height = 21
              CharCase = ecUpperCase
              EditLabel.Width = 170
              EditLabel.Height = 13
              EditLabel.Caption = 'Clinic Missing Dose Request Printer:'
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -11
              EditLabel.Font.Name = 'MS Sans Serif'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = 'CLINIC MISSING DOSE REQUEST PRINTER'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtCOMissingDoseReqPrtExit
            end
            object edtIMMissingDoseReqPrt: TLabeledEdit
              Left = 10
              Top = 34
              Width = 182
              Height = 21
              CharCase = ecUpperCase
              EditLabel.Width = 186
              EditLabel.Height = 13
              EditLabel.Caption = 'Inpatient Missing Dose Request Printer:'
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -11
              EditLabel.Font.Name = 'MS Sans Serif'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = 'INPATIENT MISSING DOSE REQUEST PRINTER'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtIMMissingDoseRequestPrtExit
            end
          end
          object gbxMailGroups: TGroupBox
            Left = 0
            Top = 113
            Width = 209
            Height = 190
            HelpContext = 200
            Align = alTop
            Caption = '&Mail Groups'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            TabStop = True
            OnEnter = gbxMailGroupsEnter
            OnExit = gbxMailGroupsExit
            object Label15: TLabel
              Left = 10
              Top = 16
              Width = 67
              Height = 13
              Caption = 'Due List Error:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label16: TLabel
              Left = 11
              Top = 57
              Width = 122
              Height = 13
              Caption = 'Missing Dose Notification:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object lblUnabletoScan: TLabel
              Left = 10
              Top = 138
              Width = 81
              Height = 13
              Caption = 'Unable To Scan:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object edtMGDLError: TEdit
              Left = 10
              Top = 30
              Width = 182
              Height = 21
              HelpContext = 108
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = 'edtMGDLError'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtMGDLErrorExit
            end
            object edtMGInpatientMissingDose: TEdit
              Left = 10
              Top = 71
              Width = 182
              Height = 21
              HelpContext = 109
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = 'edtMGInpatientMissingDose'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtMGInpatientMissingDoseExit
            end
            object edtMgUnknown: TLabeledEdit
              Left = 10
              Top = 111
              Width = 182
              Height = 21
              HelpContext = 124
              EditLabel.Width = 87
              EditLabel.Height = 13
              EditLabel.Caption = 'Unknown Actions:'
              EditLabel.Font.Charset = DEFAULT_CHARSET
              EditLabel.Font.Color = clWindowText
              EditLabel.Font.Height = -11
              EditLabel.Font.Name = 'MS Sans Serif'
              EditLabel.Font.Style = []
              EditLabel.ParentFont = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Text = 'edtMgUnknown'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtMgUnknownExit
            end
            object edtMGMSF: TEdit
              Left = 10
              Top = 154
              Width = 182
              Height = 21
              HelpContext = 125
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              Text = 'edtMGMSF'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtMGMSFExit
            end
          end
          object grpBarCodeOptions: TGroupBox
            Left = 0
            Top = 367
            Width = 209
            Height = 124
            Align = alTop
            Caption = '&Bar Code Options'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            object lblDefaultBarCodeFormat: TLabel
              Left = 10
              Top = 16
              Width = 119
              Height = 13
              Caption = 'Default Bar Code Format:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object lblDefaultBarCodePrefix: TLabel
              Left = 10
              Top = 56
              Width = 113
              Height = 13
              Caption = 'Default Bar Code Prefix:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object cbxBCFormat: TComboBox
              Left = 8
              Top = 32
              Width = 97
              Height = 21
              HelpContext = 11
              ItemHeight = 13
              TabOrder = 0
              OnClick = cbxBCFormatClick
              Items.Strings = (
                'C39'
                '128'
                'I25')
            end
            object edtBCPrefix: TEdit
              Left = 8
              Top = 72
              Width = 185
              Height = 21
              HelpContext = 12
              TabOrder = 1
              Text = 'edtBCPrefix'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtBCPrefixExit
            end
            object chkRobotRX: TCheckBox
              Left = 8
              Top = 99
              Width = 161
              Height = 17
              HelpContext = 13
              Caption = 'Using Robot RX'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = chkRobotRXClick
            end
          end
          object grpReports: TGroupBox
            Left = 0
            Top = 303
            Width = 209
            Height = 64
            Align = alTop
            Caption = '&Reports'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            object Label14: TLabel
              Left = 8
              Top = 40
              Width = 100
              Height = 13
              Caption = 'Med Hist Days Back:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object edtMedHistDaysBack: TEdit
              Left = 120
              Top = 35
              Width = 81
              Height = 21
              HelpContext = 127
              MaxLength = 4
              TabOrder = 1
              OnChange = edtMedHistDaysBackChange
              OnEnter = edtMedHistDaysBackEnter
              OnExit = edtMedHistDaysBackExit
            end
            object cbxRptInclComm: TCheckBox
              Left = 10
              Top = 17
              Width = 129
              Height = 17
              HelpContext = 126
              Caption = 'Include Comments'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = cbxRptInclCommClick
            end
          end
          object grpFiveRights: TGroupBox
            Left = 0
            Top = 491
            Width = 209
            Height = 71
            Align = alTop
            Caption = '5 Ri&ghts Override'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            object chk5UnitDose: TCheckBox
              Left = 8
              Top = 21
              Width = 137
              Height = 17
              HelpContext = 128
              Caption = 'Unit Dose Administration'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = chk5UnitDoseClick
            end
            object chk5IV: TCheckBox
              Left = 8
              Top = 40
              Width = 121
              Height = 17
              HelpContext = 129
              Caption = 'IV Administration'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = chk5IVClick
            end
          end
        end
        object pnlRight: TPanel
          Left = 209
          Top = 0
          Width = 299
          Height = 734
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pnlRight'
          TabOrder = 1
          object gbxVDL: TGroupBox
            Left = 0
            Top = 259
            Width = 299
            Height = 62
            Align = alTop
            Caption = 'Vir&tual Due List Default Times'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            object Label18: TLabel
              Left = 11
              Top = 18
              Width = 51
              Height = 13
              Caption = 'Start Time:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label19: TLabel
              Left = 116
              Top = 18
              Width = 51
              Height = 13
              Caption = 'Stop Time:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object cmbxStartTime: TComboBox
              Left = 11
              Top = 32
              Width = 97
              Height = 21
              HelpContext = 115
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ItemHeight = 13
              ParentFont = False
              TabOrder = 0
              OnClick = cmbxStartTimeClick
              Items.Strings = (
                '0 hours prior'
                '1 hour prior'
                '2 hours prior'
                '3 hours prior'
                '4 hours prior'
                '5 hours prior')
            end
            object cmbxStopTime: TComboBox
              Left = 114
              Top = 32
              Width = 97
              Height = 21
              HelpContext = 116
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ItemHeight = 13
              ParentFont = False
              TabOrder = 1
              OnClick = cmbxStopTimeClick
              Items.Strings = (
                '0 hours after'
                '1 hour after'
                '2 hours after'
                '3 hours after'
                '4 hours after'
                '5 hours after')
            end
          end
          object gbxAdministration: TGroupBox
            Left = 0
            Top = 0
            Width = 299
            Height = 73
            Align = alTop
            Caption = 'Admi&nistration'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            DesignSize = (
              299
              73)
            object cbxESig: TCheckBox
              Left = 44
              Top = 20
              Width = 246
              Height = 17
              HelpContext = 110
              Anchors = [akTop, akRight]
              Caption = 'Require ESig to Administer Medication'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = cbxESigClick
            end
            object chkMultiAdmin: TCheckBox
              Left = 44
              Top = 40
              Width = 246
              Height = 17
              HelpContext = 201
              Anchors = [akTop, akRight]
              Caption = 'Allow Multiple Admins for On-Call'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = chkMultiAdminClick
            end
          end
          object grpMiscOptions: TGroupBox
            Left = 0
            Top = 385
            Width = 299
            Height = 349
            Align = alClient
            Caption = 'Misc &Options'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
            DesignSize = (
              299
              349)
            object lblPatientTransfer: TLabel
              Left = 11
              Top = 40
              Width = 238
              Height = 13
              Caption = 'Patient Transfer Notification Timeframe [In Hours] :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label36: TLabel
              Left = 11
              Top = 88
              Width = 155
              Height = 13
              Caption = 'BCMA Idle Timeout [In Minutes] :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object lblPRNDoc: TLabel
              Left = 11
              Top = 115
              Width = 153
              Height = 13
              Caption = 'PRN Documentation [In Hours] :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object lblMRRDisplayDuration: TLabel
              Left = 11
              Top = 175
              Width = 237
              Height = 13
              Caption = 'Meds Requirng Removal (MRR) Display Duration: '
              FocusControl = cbxPatchDuration
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label24: TLabel
              Left = 11
              Top = 21
              Width = 161
              Height = 13
              Caption = 'Max Client Server Clock Variance:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 11
              Top = 144
              Width = 84
              Height = 13
              Caption = 'Max Date Range:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object lblInjSiteHistMaxHrs: TLabel
              Left = 11
              Top = 231
              Width = 153
              Height = 13
              Caption = 'Injection Site History Max Hours:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object lblDermSiteHistMaxDays: TLabel
              Left = 11
              Top = 260
              Width = 142
              Height = 13
              Caption = 'Dermal Site History Max Days:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object edtPatientTransfer: TEdit
              Left = 11
              Top = 57
              Width = 260
              Height = 21
              HelpContext = 130
              MaxLength = 2
              TabOrder = 1
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtPatientTransferExit
            end
            object edtTimeout: TEdit
              Left = 211
              Top = 84
              Width = 73
              Height = 21
              HelpContext = 8
              Anchors = [akTop, akRight]
              MaxLength = 4
              TabOrder = 2
              Text = 'edtTimeout'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtTimeoutExit
            end
            object chkCPRSMedOrder: TCheckBox
              Left = 25
              Top = 284
              Width = 225
              Height = 22
              HelpContext = 9
              Anchors = [akTop, akRight]
              Caption = 'Enable CPRS Med Order Button'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 8
              OnClick = chkCPRSMedOrderClick
            end
            object edtPRNDoc: TEdit
              Left = 211
              Top = 112
              Width = 73
              Height = 21
              HelpContext = 131
              Anchors = [akTop, akRight]
              MaxLength = 3
              TabOrder = 3
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtPRNDocExit
            end
            object cbxPatchDuration: TComboBox
              Left = 25
              Top = 193
              Width = 260
              Height = 21
              HelpContext = 133
              Style = csDropDownList
              Anchors = [akTop, akRight]
              ItemHeight = 13
              TabOrder = 5
              OnClick = cbxPatchDurationClick
              Items.Strings = (
                'Always Display'
                '7'
                '8'
                '9'
                '10'
                '11'
                '12'
                '13'
                '14')
            end
            object edtMaximumServerClockVariance: TEdit
              Left = 222
              Top = 13
              Width = 60
              Height = 21
              HelpContext = 7
              Anchors = [akTop, akRight]
              TabOrder = 0
              Text = 'edtMaximumServerClockVariance'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtMaximumServerClockVarianceExit
            end
            object edtMaxDateRange: TEdit
              Left = 211
              Top = 141
              Width = 73
              Height = 21
              HelpContext = 132
              Anchors = [akTop, akRight]
              MaxLength = 3
              TabOrder = 4
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtMaxDateRangeExit
            end
            object edtInjSiteHistMaxHrs: TEdit
              Left = 211
              Top = 230
              Width = 73
              Height = 21
              HelpContext = 450
              Anchors = [akTop, akRight]
              MaxLength = 2
              TabOrder = 6
              Text = 'edtInjSiteHistMaxHrs'
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtInjSiteHistMaxHrsExit
            end
            object edtDermSiteHistMaxDays: TEdit
              Left = 211
              Top = 257
              Width = 73
              Height = 21
              HelpContext = 17
              Anchors = [akTop, akRight]
              MaxLength = 2
              TabOrder = 7
              OnChange = edtChange
              OnEnter = edtEnter
              OnExit = edtDermSiteHistMaxDaysExit
            end
          end
          object grpIncludeScheduleTypes: TGroupBox
            Left = 0
            Top = 321
            Width = 299
            Height = 64
            Align = alTop
            Caption = 'Include &Schedule Types'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            object cbxCont: TCheckBox
              Left = 11
              Top = 41
              Width = 89
              Height = 17
              HelpContext = 117
              Caption = 'Continuous'
              Enabled = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = cbxContClick
            end
            object cbxPRN: TCheckBox
              Left = 11
              Top = 18
              Width = 89
              Height = 17
              HelpContext = 118
              Caption = 'PRN'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = cbxPRNClick
            end
            object cbxOneTime: TCheckBox
              Left = 98
              Top = 41
              Width = 97
              Height = 17
              HelpContext = 119
              Caption = 'One-Time'
              Enabled = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = cbxOneTimeClick
            end
            object cbxOnCall: TCheckBox
              Left = 98
              Top = 18
              Width = 97
              Height = 17
              HelpContext = 120
              Caption = 'On-Call'
              Enabled = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              OnClick = cbxOnCallClick
            end
          end
          object grpAllowableTime: TGroupBox
            Left = 0
            Top = 155
            Width = 299
            Height = 104
            Align = alTop
            Caption = 'A&llowable Time Limits (In Minutes)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            DesignSize = (
              299
              104)
            object Label9: TLabel
              Left = 11
              Top = 17
              Width = 203
              Height = 20
              AutoSize = False
              Caption = 'Before Scheduled Admin / Removal Time'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object Label10: TLabel
              Left = 11
              Top = 43
              Width = 191
              Height = 19
              AutoSize = False
              Caption = 'After Scheduled Admin / Removal Time'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object Label11: TLabel
              Left = 11
              Top = 71
              Width = 146
              Height = 19
              AutoSize = False
              Caption = 'PRN Effectiveness Entry'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object cmbxMinBefore: TComboBox
              Left = 230
              Top = 16
              Width = 60
              Height = 21
              HelpContext = 111
              Style = csDropDownList
              Anchors = [akTop, akRight]
              ItemHeight = 13
              TabOrder = 0
              OnClick = cmbxMinBeforeClick
              Items.Strings = (
                '0'
                '10'
                '20'
                '30'
                '40'
                '50'
                '60'
                '70'
                '80'
                '90'
                '100'
                '110'
                '120'
                '130'
                '140'
                '150'
                '160'
                '170'
                '180'
                '190'
                '200'
                '210'
                '220'
                '230'
                '240')
            end
            object cmbxMinAfter: TComboBox
              Left = 230
              Top = 43
              Width = 60
              Height = 21
              HelpContext = 112
              Style = csDropDownList
              Anchors = [akTop, akRight]
              ItemHeight = 13
              TabOrder = 1
              OnClick = cmbxMinAfterClick
              Items.Strings = (
                '0'
                '10'
                '20'
                '30'
                '40'
                '50'
                '60'
                '70'
                '80'
                '90'
                '100'
                '110'
                '120'
                '130'
                '140'
                '150'
                '160'
                '170'
                '180'
                '190'
                '200'
                '210'
                '220'
                '230'
                '240')
            end
            object edtPRNEffect: TEdit
              Left = 230
              Top = 70
              Width = 42
              Height = 21
              HelpContext = 113
              Anchors = [akTop, akRight]
              TabOrder = 2
              Text = '10'
              OnEnter = edtPRNEffectEnter
              OnExit = edtPRNEffectExit
            end
            object updnPRNEffect: TUpDown
              Left = 272
              Top = 70
              Width = 16
              Height = 21
              Associate = edtPRNEffect
              Min = 10
              Max = 960
              Increment = 10
              Position = 10
              TabOrder = 3
              Thousands = False
              OnExit = updnPRNEffectExit
              OnMouseLeave = updnPRNEffectMouseLeave
            end
          end
          object grpNonNurseVfy: TGroupBox
            Left = 0
            Top = 73
            Width = 299
            Height = 82
            HelpContext = 255
            Align = alTop
            Caption = 'Non-Nurse Verified Orders'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            TabStop = True
            OnEnter = grpNonNurseVfyEnter
            OnExit = grpNonNurseVfyExit
            object rbtnAllow: TRadioButton
              Left = 11
              Top = 13
              Width = 187
              Height = 17
              HelpContext = 259
              Caption = 'Allow Administration (No Warning)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = rbtnNonNurseVfyClick
            end
            object rbtnAllowWarning: TRadioButton
              Left = 11
              Top = 36
              Width = 187
              Height = 17
              HelpContext = 260
              Caption = 'Allow Administration with Warning'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = rbtnNonNurseVfyClick
            end
            object rbtnProhibit: TRadioButton
              Left = 11
              Top = 59
              Width = 131
              Height = 17
              HelpContext = 261
              Caption = 'Prohibit Administration'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = rbtnNonNurseVfyClick
            end
          end
        end
      end
      object tsAnswerList: TTabSheet
        HelpContext = 4
        Caption = '&Default Answer Lists'
        ImageIndex = 2
        object GroupBox3: TGroupBox
          Left = 0
          Top = 0
          Width = 508
          Height = 734
          Align = alClient
          Caption = 'Default Answer Lists'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          TabStop = True
          object splChartDefault: TSplitter
            Left = 2
            Top = 306
            Width = 504
            Height = 4
            Cursor = crVSplit
            Align = alBottom
            Beveled = True
            Color = clCream
            ParentColor = False
            ExplicitTop = 15
            ExplicitWidth = 471
          end
          object pnlMRR: TPanel
            Left = 2
            Top = 310
            Width = 504
            Height = 422
            Align = alBottom
            BevelOuter = bvNone
            Caption = 'pnlMRR'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            object pnlMRRTools: TPanel
              Left = 0
              Top = 0
              Width = 504
              Height = 57
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              DesignSize = (
                504
                57)
              object lblDefaultImage: TLabel
                Left = 10
                Top = 2
                Width = 29
                Height = 13
                Caption = 'Image'
                Enabled = False
                FocusControl = cmbDefaultImage
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                Visible = False
              end
              object cmbDefaultImage: TComboBox
                Left = 10
                Top = 20
                Width = 223
                Height = 21
                Style = csSimple
                Anchors = [akLeft, akTop, akRight]
                Color = clBtnFace
                Ctl3D = False
                Enabled = False
                ItemHeight = 13
                ParentCtl3D = False
                TabOrder = 0
                Visible = False
                Items.Strings = (
                  'PSB IMAGE MASTER'
                  'PSB IMAGE TRANSDERMAL')
              end
              object btnImportImage: TButton
                Left = 239
                Top = 18
                Width = 86
                Height = 25
                Action = acImageImport
                Enabled = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 1
                Visible = False
              end
              object btnDefaultImageNew: TButton
                Left = 326
                Top = 18
                Width = 38
                Height = 25
                Action = acImageNew
                TabOrder = 2
                Visible = False
              end
              object btnDefaultImageDelete: TButton
                Left = 365
                Top = 18
                Width = 45
                Height = 25
                Action = acImageDelete
                Caption = 'Delete'
                TabOrder = 3
                Visible = False
              end
              object btnEditLayoutDAL: TButton
                Left = 411
                Top = 18
                Width = 82
                Height = 25
                Action = acEditMap
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 4
              end
            end
            object pnlChartDefault: TPanel
              Left = 0
              Top = 57
              Width = 504
              Height = 365
              Align = alClient
              BevelOuter = bvNone
              Caption = 'pnlChartDefault'
              TabOrder = 1
            end
          end
          object pnlDefaults: TPanel
            Left = 2
            Top = 15
            Width = 504
            Height = 291
            Align = alClient
            BevelOuter = bvNone
            Caption = 'pnlDefaults'
            TabOrder = 0
            DesignSize = (
              504
              291)
            object lblListName: TLabel
              Left = 10
              Top = 4
              Width = 50
              Height = 13
              Caption = 'List &Name:'
              FocusControl = cbxListName
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              OnClick = lblListNameClick
            end
            object btnSaveList: TButton
              Left = 382
              Top = 17
              Width = 82
              Height = 25
              HelpContext = 123
              Caption = '&Save List'
              Enabled = False
              TabOrder = 0
              OnClick = btnSaveListClick
            end
            object cbxListName: TComboBox
              Left = 10
              Top = 19
              Width = 223
              Height = 21
              HelpContext = 121
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ItemHeight = 13
              ParentFont = False
              TabOrder = 1
              OnChange = cbxListNameChange
              OnSelect = cbxListNameSelect
              Items.Strings = (
                'Missing Dose Request Reason'
                'PRN Effectiveness'
                'Reasons Held'
                'Injection Sites'
                'Anatomic Locations')
            end
            object pnlDefAnswer: TPanel
              Left = 8
              Top = 48
              Width = 490
              Height = 237
              Anchors = [akLeft, akTop, akRight, akBottom]
              BevelOuter = bvNone
              Caption = 'pnlDefAnswer'
              TabOrder = 2
              object pnlDefaultTools: TPanel
                Left = 0
                Top = 0
                Width = 490
                Height = 33
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                Visible = False
                object btnDefaultSaveList: TSpeedButton
                  Left = 391
                  Top = 6
                  Width = 65
                  Height = 22
                  Action = acDefaultSave
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clPurple
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                  Visible = False
                end
                object btnDefautlLoadList: TSpeedButton
                  Left = 317
                  Top = 6
                  Width = 74
                  Height = 22
                  Action = acDefaultLoad
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clPurple
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                  Visible = False
                end
                object btnDefaultAddItem: TSpeedButton
                  Left = 2
                  Top = 6
                  Width = 72
                  Height = 22
                  Action = acDefaultAdd
                end
                object btnEditItem: TSpeedButton
                  Left = 74
                  Top = 6
                  Width = 75
                  Height = 22
                  Action = acDefaultRename
                end
                object btnDeleteItem: TSpeedButton
                  Left = 149
                  Top = 6
                  Width = 85
                  Height = 22
                  Action = acDefaultRemove
                end
                object btnImportList: TSpeedButton
                  Left = 234
                  Top = 6
                  Width = 83
                  Height = 22
                  Action = acDefaultImport
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                  Visible = False
                end
              end
              object lvwDefAnswer: TListView
                Left = 0
                Top = 33
                Width = 490
                Height = 204
                HelpContext = 122
                Align = alClient
                Columns = <
                  item
                    Caption = 'Item'
                    Width = 260
                  end
                  item
                    Caption = 'Injection Site'
                    Width = 90
                  end
                  item
                    Caption = 'Dermal Site'
                    Width = 80
                  end>
                GridLines = True
                HideSelection = False
                ReadOnly = True
                RowSelect = True
                PopupMenu = mnLister
                SortType = stText
                StateImages = frmALMapEdit.ImageList1
                TabOrder = 1
                ViewStyle = vsReport
                OnChanging = lvwDefAnswerChanging
                OnCustomDrawItem = lvwDefAnswerCustomDrawItem
                OnMouseDown = lvwDefAnswerMouseDown
              end
            end
          end
        end
      end
      object tbshtIVParameters: TTabSheet
        HelpContext = 6
        Caption = 'I&V Parameters'
        ImageIndex = 3
        object pnlIVParLeft: TPanel
          Left = 0
          Top = 0
          Width = 217
          Height = 734
          Align = alLeft
          BevelOuter = bvNone
          BorderWidth = 2
          Caption = 'pnlIVParLeft'
          TabOrder = 0
          object GroupBox1: TGroupBox
            Left = 2
            Top = 2
            Width = 213
            Height = 63
            Align = alTop
            Caption = '&Location'
            TabOrder = 0
            TabStop = True
            OnEnter = GroupBox1Enter
            OnExit = GroupBox1Exit
            object Label25: TLabel
              Left = 8
              Top = 24
              Width = 29
              Height = 13
              Caption = 'Ward:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object cbxIVParWard: TComboBox
              Left = 48
              Top = 20
              Width = 150
              Height = 19
              HelpContext = 256
              Style = csOwnerDrawFixed
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 0
              OnChange = cbxIVParWardChange
              OnDrawItem = cbxIVParWardDrawItem
            end
          end
          object GroupBox2: TGroupBox
            Left = 2
            Top = 65
            Width = 213
            Height = 667
            Align = alClient
            Caption = 'IV &Type'
            TabOrder = 1
            TabStop = True
            OnEnter = GroupBox2Enter
            OnExit = GroupBox2Exit
            object Label26: TLabel
              Left = 8
              Top = 24
              Width = 27
              Height = 13
              Caption = 'Type:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object cbxIVParType: TComboBox
              Left = 48
              Top = 20
              Width = 150
              Height = 19
              HelpContext = 257
              Style = csOwnerDrawFixed
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 0
              OnChange = cbxIVParTypeChange
              OnDrawItem = cbxIVParTypeDrawItem
              Items.Strings = (
                'Admixture'
                'Chemotherapy'
                'Hyperal'
                'Piggyback'
                'Syringe')
            end
            object btnReset: TButton
              Left = 114
              Top = 64
              Width = 81
              Height = 25
              Caption = 'R&eset IV Type'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = btnResetClick
            end
          end
        end
        object pnlIVParRight: TPanel
          Left = 217
          Top = 0
          Width = 291
          Height = 734
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          Caption = 'pnlIVParRight'
          TabOrder = 1
          object grpIVPrompts: TGroupBox
            Left = 2
            Top = 2
            Width = 287
            Height = 730
            Align = alClient
            Caption = 'P&rompts'
            Enabled = False
            TabOrder = 0
            TabStop = True
            OnEnter = grpIVPromptsEnter
            OnExit = grpIVPromptsExit
            object Label27: TLabel
              Left = 64
              Top = 20
              Width = 41
              Height = 13
              Caption = 'Additive:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label28: TLabel
              Left = 62
              Top = 44
              Width = 43
              Height = 13
              Caption = 'Strength:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label29: TLabel
              Left = 75
              Top = 68
              Width = 30
              Height = 13
              Caption = 'Bottle:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label30: TLabel
              Left = 64
              Top = 92
              Width = 41
              Height = 13
              Caption = 'Solution:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label31: TLabel
              Left = 67
              Top = 116
              Width = 38
              Height = 13
              Caption = 'Volume:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label32: TLabel
              Left = 39
              Top = 140
              Width = 66
              Height = 13
              Caption = 'Infusion Rate:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label33: TLabel
              Left = 49
              Top = 164
              Width = 56
              Height = 13
              Caption = 'Med Route:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label34: TLabel
              Left = 57
              Top = 188
              Width = 48
              Height = 13
              Caption = 'Schedule:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label35: TLabel
              Left = 47
              Top = 212
              Width = 58
              Height = 13
              Caption = 'Admin Time:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label37: TLabel
              Left = 31
              Top = 260
              Width = 74
              Height = 13
              Caption = 'Other Print Info:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label38: TLabel
              Left = 63
              Top = 284
              Width = 42
              Height = 13
              Caption = 'Provider:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label39: TLabel
              Left = 26
              Top = 308
              Width = 79
              Height = 13
              Caption = 'Start Date/Time:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label40: TLabel
              Left = 26
              Top = 332
              Width = 79
              Height = 13
              Caption = 'Stop Date/Time:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label41: TLabel
              Left = 11
              Top = 356
              Width = 94
              Height = 13
              Caption = 'Provider Comments:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label42: TLabel
              Left = 60
              Top = 236
              Width = 45
              Height = 13
              Caption = 'Remarks:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object btnIVParCancel: TButton
              Left = 120
              Top = 382
              Width = 73
              Height = 25
              Caption = '&Cancel'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 16
              OnClick = btnIVParCancelClick
            end
            object btnIVParOK: TButton
              Left = 40
              Top = 382
              Width = 73
              Height = 25
              Caption = '&OK'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 15
              OnClick = btnIVParOKClick
            end
            object ComboBox1: TComboBox
              Tag = 2
              Left = 112
              Top = 16
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 0
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox2: TComboBox
              Tag = 3
              Left = 112
              Top = 40
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 1
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox3: TComboBox
              Tag = 4
              Left = 112
              Top = 64
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 2
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox4: TComboBox
              Tag = 5
              Left = 112
              Top = 88
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 3
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox5: TComboBox
              Tag = 6
              Left = 112
              Top = 112
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 4
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox6: TComboBox
              Tag = 7
              Left = 112
              Top = 136
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 5
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox7: TComboBox
              Tag = 8
              Left = 112
              Top = 160
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 6
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox8: TComboBox
              Tag = 9
              Left = 112
              Top = 184
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 7
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox9: TComboBox
              Tag = 10
              Left = 112
              Top = 208
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 8
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox10: TComboBox
              Tag = 11
              Left = 112
              Top = 232
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 9
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox11: TComboBox
              Tag = 12
              Left = 112
              Top = 256
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 10
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox12: TComboBox
              Tag = 13
              Left = 112
              Top = 280
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 11
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox13: TComboBox
              Tag = 14
              Left = 112
              Top = 304
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 12
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox14: TComboBox
              Tag = 15
              Left = 112
              Top = 328
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 13
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
            object ComboBox15: TComboBox
              Tag = 16
              Left = 112
              Top = 352
              Width = 89
              Height = 21
              HelpContext = 258
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 14
              OnChange = ComboBox1Change
              Items.Strings = (
                'Warning'
                'Non-Verify'
                'Invalid Bag')
            end
          end
        end
      end
      object tbshtIHS: TTabSheet
        HelpContext = 250
        Caption = '&IHS'
        ImageIndex = 4
        object lbledtPatIdLabel: TLabeledEdit
          Left = 105
          Top = 10
          Width = 75
          Height = 21
          EditLabel.Width = 97
          EditLabel.Height = 13
          EditLabel.Caption = 'IHS Patient ID &Label'
          LabelPosition = lpLeft
          MaxLength = 5
          TabOrder = 0
        end
        object lbledtDivPatIdLabel: TLabeledEdit
          Left = 105
          Top = 61
          Width = 121
          Height = 21
          Color = clBtnFace
          EditLabel.Width = 114
          EditLabel.Height = 13
          EditLabel.Caption = 'Division Patient Id Label'
          Enabled = False
          ReadOnly = True
          TabOrder = 3
          Visible = False
        end
        object lbledtSysPatIdLabel: TLabeledEdit
          Left = 105
          Top = 102
          Width = 121
          Height = 21
          Color = clBtnFace
          EditLabel.Width = 111
          EditLabel.Height = 13
          EditLabel.Caption = 'System Patient Id Label'
          Enabled = False
          ReadOnly = True
          TabOrder = 4
          Visible = False
        end
        object btnIHSOK: TButton
          Left = 299
          Top = 564
          Width = 75
          Height = 25
          Caption = '&OK'
          ModalResult = 1
          TabOrder = 1
          OnClick = btnIHSOKClick
        end
        object btnIHSCancel: TButton
          Left = 380
          Top = 564
          Width = 75
          Height = 25
          Caption = '&Cancel'
          ModalResult = 2
          TabOrder = 2
          OnClick = btnIHSCancelClick
        end
        object lbledtAllPatIdLabel: TLabeledEdit
          Left = 105
          Top = 142
          Width = 121
          Height = 21
          Color = clBtnFace
          EditLabel.Width = 90
          EditLabel.Height = 13
          EditLabel.Caption = 'All Patient ID Label'
          Enabled = False
          ReadOnly = True
          TabOrder = 5
          Visible = False
        end
      end
      object tsAL: TTabSheet
        Caption = 'Anatomic Locations'
        ImageIndex = 5
        object grpAL: TGroupBox
          Left = 0
          Top = 0
          Width = 508
          Height = 734
          Align = alClient
          Caption = 'Anatomic Location Groups'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object splChart: TSplitter
            Left = 2
            Top = 198
            Width = 504
            Height = 3
            Cursor = crVSplit
            Align = alBottom
            Beveled = True
            Color = clCream
            ParentColor = False
            ExplicitLeft = 0
            ExplicitTop = 305
            ExplicitWidth = 469
          end
          object pnlMasterList: TPanel
            Left = 2
            Top = 66
            Width = 504
            Height = 132
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 2
            object mmMaster: TMemo
              Left = 0
              Top = 22
              Width = 504
              Height = 110
              Align = alBottom
              BorderStyle = bsNone
              Color = clInfoBk
              Ctl3D = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Lines.Strings = (
                'MASTER LIST contains all known Anatomic Location Items.'
                
                  'Items of the Master List are grouped to use in different context' +
                  '.'
                'An item can be included in different groups. '
                
                  'An image is assigned to every group to allow visual presentation' +
                  ' of the group of items.'
                'To add an item to a group:'
                '- select the group'
                '- checkmark the item')
              ParentCtl3D = False
              ParentFont = False
              ScrollBars = ssVertical
              TabOrder = 3
            end
            object pnlMasterListAL: TPanel
              Left = 0
              Top = 0
              Width = 504
              Height = 27
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Color = clSilver
              TabOrder = 0
              DesignSize = (
                504
                27)
              object lblColumns: TLabel
                Left = 472
                Top = 7
                Width = 8
                Height = 13
                Alignment = taRightJustify
                Anchors = [akTop, akRight]
                Caption = '1'
                ExplicitLeft = 439
              end
              object udColumns: TUpDown
                Left = 486
                Top = 2
                Width = 16
                Height = 24
                Hint = 'Change # of the list columns '
                Anchors = [akTop, akRight]
                Min = 1
                Max = 5
                Position = 1
                TabOrder = 0
                OnClick = udColumnsClick
              end
              object ckbSelectAll: TCheckBox
                Left = 2
                Top = -1
                Width = 87
                Height = 32
                Hint = 'Select all available items'
                Action = acGroupSelectAll
                Ctl3D = False
                ParentCtl3D = False
                TabOrder = 1
              end
              object pnlMasterTool: TPanel
                Left = 83
                Top = -3
                Width = 383
                Height = 28
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 2
                object btnMasterSave: TSpeedButton
                  Left = 339
                  Top = 6
                  Width = 44
                  Height = 22
                  Action = acMasterSave
                  Flat = True
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clPurple
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object btnMasterLoad: TSpeedButton
                  Left = 287
                  Top = 6
                  Width = 50
                  Height = 22
                  Action = acMasterLoad
                  Flat = True
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clPurple
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object btnItemAdd: TSpeedButton
                  Left = 0
                  Top = 9
                  Width = 44
                  Height = 22
                  Action = acItemAdd
                  Flat = True
                end
                object btnItemRename: TSpeedButton
                  Left = 46
                  Top = 6
                  Width = 62
                  Height = 22
                  Action = acItemRename
                  Flat = True
                end
                object btnItemRemove: TSpeedButton
                  Left = 108
                  Top = 6
                  Width = 68
                  Height = 22
                  Action = acItemRemove
                  Flat = True
                end
                object btnMasterImport: TSpeedButton
                  Left = 180
                  Top = 6
                  Width = 64
                  Height = 22
                  Action = acMasterImport
                  Flat = True
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object btnMasterExport: TSpeedButton
                  Left = 244
                  Top = 6
                  Width = 43
                  Height = 22
                  Action = acMasterExport
                  Caption = 'Export'
                  Flat = True
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
              end
            end
            object ckbLocations: TCheckListBox
              Left = 0
              Top = 27
              Width = 504
              Height = 55
              OnClickCheck = ckbLocationsClickCheck
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Color = clCream
              Columns = 1
              Ctl3D = True
              ItemHeight = 13
              ParentCtl3D = False
              TabOrder = 1
            end
            object lbMaster: TListBox
              Left = 0
              Top = 27
              Width = 504
              Height = 55
              Align = alClient
              BorderStyle = bsNone
              Color = clCream
              Ctl3D = False
              ItemHeight = 13
              ParentCtl3D = False
              TabOrder = 2
            end
          end
          object pnlChart: TPanel
            Left = 2
            Top = 201
            Width = 504
            Height = 531
            Align = alBottom
            BevelOuter = bvLowered
            DragCursor = crDefault
            TabOrder = 0
            object pnlBodyChart: TPanel
              Left = 1
              Top = 55
              Width = 502
              Height = 475
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
            end
            object pnlImageTools: TPanel
              Left = 1
              Top = 1
              Width = 502
              Height = 54
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 1
              DesignSize = (
                502
                54)
              object lblGroupImage: TLabel
                Left = 6
                Top = 5
                Width = 61
                Height = 13
                Caption = 'Group &Image'
                FocusControl = cbxListName
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object cmbALImages: TComboBox
                Left = 3
                Top = 24
                Width = 245
                Height = 21
                Anchors = [akLeft, akTop, akRight]
                Color = clCream
                Ctl3D = False
                ItemHeight = 13
                ParentCtl3D = False
                TabOrder = 0
                Text = 'PSB AL IMAGE GENERAL'
                OnChange = cmbALImagesChange
              end
              object btnImportImageAL: TButton
                Left = 248
                Top = 22
                Width = 89
                Height = 25
                Action = acImageImport
                TabOrder = 1
              end
              object btnImageNew: TButton
                Left = 336
                Top = 22
                Width = 36
                Height = 25
                Action = acImageNew
                TabOrder = 2
              end
              object btnImageDelete: TButton
                Left = 371
                Top = 22
                Width = 34
                Height = 25
                Action = acImageDelete
                TabOrder = 3
              end
              object btnEditLayoutAL: TButton
                Left = 405
                Top = 22
                Width = 82
                Height = 25
                Action = acEditMap
                TabOrder = 4
              end
            end
          end
          object pnlGroupList: TPanel
            Left = 2
            Top = 15
            Width = 504
            Height = 51
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object lblGroupName: TLabel
              Left = 6
              Top = 5
              Width = 63
              Height = 13
              Caption = 'Group &Name:'
              FocusControl = cbxListName
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object sbMode: TSpeedButton
              Left = 453
              Top = 1
              Width = 12
              Height = 7
              Flat = True
              OnClick = sbModeClick
            end
            object cmbALList: TComboBox
              Left = 6
              Top = 21
              Width = 212
              Height = 21
              Color = clCream
              Ctl3D = False
              ItemHeight = 13
              ParentCtl3D = False
              TabOrder = 0
              Text = 'MASTER LIST'
              OnClick = cmbALListClick
              Items.Strings = (
                'MASTER LIST'
                'IV'
                'IM'
                'TRANSDERMAL')
            end
            object btnGroupNew: TButton
              Left = 285
              Top = 17
              Width = 42
              Height = 25
              Action = acGroupNew
              TabOrder = 1
            end
            object btnGroupDelete: TButton
              Left = 327
              Top = 17
              Width = 50
              Height = 25
              Action = acGroupDelete
              TabOrder = 2
            end
            object btnGroupSave: TButton
              Left = 386
              Top = 17
              Width = 82
              Height = 25
              Action = acGroupSave
              TabOrder = 3
            end
            object btnGroupLoad: TButton
              Left = 224
              Top = 17
              Width = 55
              Height = 25
              Action = acGroupLoad
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
            end
          end
        end
      end
    end
  end
  object menu: TMainMenu
    Left = 462
    Top = 163
    object menuFile: TMenuItem
      Caption = '&File'
      HelpContext = 5
      object menuFileOpen: TMenuItem
        Caption = '&Open...'
        HelpContext = 101
        OnClick = menuFileOpenClick
      end
      object menuFileClose: TMenuItem
        Caption = '&Close'
        HelpContext = 102
        OnClick = menuFileCloseClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object menuFileExit: TMenuItem
        Caption = 'E&xit'
        HelpContext = 103
        OnClick = menuFileExitClick
      end
    end
    object menuHelp: TMenuItem
      Caption = '&Help'
      HelpContext = 1
      object menuHelpContents: TMenuItem
        Caption = '&Contents and Index'
        HelpContext = 1
        OnClick = menuHelpContentsClick
      end
      object menuHelpIndex: TMenuItem
        Caption = '&Index'
        HelpContext = 1
        Visible = False
        OnClick = menuHelpIndexClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object menuHelpAbout: TMenuItem
        Caption = '&About'
        OnClick = menuHelpAboutClick
      end
    end
    object DEBUG1: TMenuItem
      Caption = 'DEBUG'
      object RPCLog1: TMenuItem
        Caption = 'RPC &Log'
        OnClick = RPCLog1Click
      end
      object ALTab1: TMenuItem
        Caption = 'AL Tab Visible'
        Hint = 'Save Backup to Server'
        OnClick = ALTab1Click
      end
    end
  end
  object mnLister: TPopupMenu
    HelpContext = 122
    OnPopup = mnListerPopup
    Left = 433
    Top = 163
    object mnListAdd: TMenuItem
      Caption = '&Add New ...'
      HelpContext = 14
      OnClick = mnListAddClick
    end
    object mnListEdit: TMenuItem
      Caption = '&Edit ...'
      HelpContext = 15
      OnClick = mnListEditClick
    end
    object mnDeleteItem: TMenuItem
      Caption = '&Delete'
      OnClick = mnDeleteItemClick
    end
  end
  object HelpRouter1: THelpRouter
    HelpType = htMixedMode
    ShowType = stMain
    Helpfile = 'bcmapar.chm'
    CHMPopupTopics = 'CSHelp.txt'
    ValidateID = True
    Left = 464
    Top = 96
  end
  object WhatsThis1: TWhatsThis
    Active = True
    F1Action = goContext
    Options = [wtMenuRightClick, wtNoContextHelp, wtNoContextMenu, wtInheritFormContext]
    PopupCaption = 'What'#39's this?'
    PopupHelpContext = 0
    OnPopup = WhatsThis1Popup
    Left = 432
    Top = 96
  end
  object mnAL: TPopupMenu
    OnPopup = acRemoveExecute
    Left = 432
    Top = 128
    object Add1: TMenuItem
      Action = acDefaultAdd
    end
    object Rename1: TMenuItem
      Action = acDefaultRename
    end
    object Remove1: TMenuItem
      Action = acDefaultRemove
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object ImportList1: TMenuItem
      Action = acDefaultImport
    end
  end
  object alLocations: TActionList
    Left = 464
    Top = 127
    object acRemove: TAction
      Caption = 'Remove'
      OnExecute = acRemoveExecute
    end
    object acRename: TAction
      Caption = 'Rename'
    end
    object acEditMap: TAction
      Caption = '&Edit Layout'
      Hint = 'Change Locations coordinates'
      OnExecute = acEditMapExecute
    end
    object acCountShapes: TAction
      Caption = 'Shapes'
      OnExecute = acCountShapesExecute
    end
    object acBackupData: TAction
      Caption = 'Backup -> Srv'
      Hint = 'Save Backup to Server'
      OnExecute = acBackupDataExecute
    end
    object acReloadFromServer: TAction
      Caption = 'Srv-> Backup'
      Hint = 'ReLoad data from Server'
      OnExecute = acReloadFromServerExecute
    end
    object acBackupEdit: TAction
      Caption = 'Edit Backup'
      Hint = 'Edit Backup List'
      OnExecute = acBackupEditExecute
    end
    object acResetMap: TAction
      Caption = 'Map'
      Hint = 'Reset Map By Backup Data'
      OnExecute = acResetMapExecute
    end
    object acNewBackup: TAction
      Caption = 'New'
      Hint = 'Create New Backup based on Defaults'
      OnExecute = acNewBackupExecute
    end
    object acImageNew: TAction
      Caption = 'New'
      Hint = 'Add description of the new image to the list'
      OnExecute = acImageNewExecute
    end
    object acImageDelete: TAction
      Caption = 'Del'
      Hint = 'Remove the image description from the list'
      OnExecute = acImageDeleteExecute
    end
    object acGroupNew: TAction
      Caption = 'New'
      Hint = 'Add description of the new group to the list'
      OnExecute = acGroupNewExecute
    end
    object acGroupDelete: TAction
      Caption = 'Delete'
      Hint = 'Remove Description from the list'
      OnExecute = acGroupDeleteExecute
    end
    object acGroupLoadList: TAction
      Caption = 'Load'
      Hint = 'Load List of AL Groups'
      OnExecute = acGroupLoadListExecute
    end
    object acImageLoadList: TAction
      Caption = 'Load'
      Hint = 'Load List of available images'
    end
    object acGroupSelectAll: TAction
      Caption = 'Select All'
      OnExecute = acGroupSelectAllExecute
    end
    object acItemAdd: TAction
      Caption = 'Add'
      HelpContext = 14
      Hint = 'Add New Item To The List'
      OnExecute = acItemAddExecute
    end
    object acItemRename: TAction
      Caption = 'Rename'
      HelpContext = 15
      Hint = 'Rename Item'
      OnExecute = acItemRenameExecute
    end
    object acItemRemove: TAction
      Caption = 'Remove'
      Hint = 'Remove Item From the list'
      OnExecute = acItemRemoveExecute
    end
    object acMasterSave: TAction
      Caption = 'Save'
      Hint = 'Save Master List in VistA'
      OnExecute = acMasterSaveExecute
    end
    object acMasterLoad: TAction
      Caption = 'Load'
      Hint = 'Load Master List from VistA'
      OnExecute = acMasterLoadExecute
    end
    object acImages: TAction
      Caption = 'Get Image List'
      Hint = 'Get List of Available Images'
      OnExecute = acImagesExecute
    end
    object acImageReplace: TAction
      Caption = 'Replace'
      Hint = 'Replace image with the one from a file'
    end
    object acGroupSave: TAction
      Caption = 'Save Group'
      Hint = 'Save AL Group Data in VistA'
      OnExecute = acGroupSaveExecute
    end
    object acMasterImport: TFileOpen
      Category = 'File'
      Caption = 'Import...'
      Dialog.DefaultExt = 'txt'
      Dialog.Filter = 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*'
      Hint = 'Import Master List from a file'
      ShortCut = 16463
      OnAccept = acMasterImportAccept
    end
    object acImageImport: TFileOpen
      Category = 'File'
      Caption = 'Import Image'
      Dialog.DefaultExt = 'jpg'
      Dialog.Filter = 'JPG Images (*.jpg)|*.jpg|All Images (*.*)|*.*'
      Hint = 'Import Image from a file'
      ShortCut = 16463
      OnAccept = acImageImportAccept
    end
    object acDefaultAdd: TAction
      Caption = 'Add Item...'
      HelpContext = 14
      OnExecute = acDefaultAddExecute
    end
    object acDefaultRename: TAction
      Caption = 'Edit Item...'
      HelpContext = 15
      OnExecute = acDefaultRenameExecute
    end
    object acDefaultRemove: TAction
      Caption = 'Delete Item...'
      OnExecute = acDefaultRemoveExecute
    end
    object acDefaultImport: TAction
      Caption = 'Import List...'
    end
    object acDefaultSave: TAction
      Caption = 'Save List'
    end
    object acDefaultLoad: TAction
      Caption = 'Load List'
    end
    object acGroupLoad: TAction
      Caption = 'Load'
      OnExecute = acGroupLoadExecute
    end
    object acMasterExport: TFileSaveAs
      Category = 'File'
      Caption = 'Save &As...'
      Hint = 'Save As|Saves the active file with a new name'
      ImageIndex = 30
      OnAccept = acMasterExportAccept
    end
  end
end
