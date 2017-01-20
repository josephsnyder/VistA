object frmReportRequest: TfrmReportRequest
  Left = 540
  Top = 263
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 1
  Caption = 'Report Request'
  ClientHeight = 575
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 534
    Width = 512
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object pnlBottomButtons: TPanel
      Left = 252
      Top = 0
      Width = 260
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnPreview: TButton
        Left = 24
        Top = 10
        Width = 70
        Height = 24
        Caption = 'Pre&view'
        Default = True
        ModalResult = 1
        TabOrder = 0
        OnClick = btnPreviewClick
      end
      object btnCancel: TButton
        Left = 176
        Top = 10
        Width = 70
        Height = 24
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 2
        OnClick = btnCancelClick
      end
      object btnPrint: TButton
        Left = 100
        Top = 10
        Width = 70
        Height = 24
        Caption = '&Print'
        ModalResult = 1
        TabOrder = 1
        OnClick = btnPreviewClick
      end
    end
    object txtBanner: TStaticText
      Left = 2
      Top = 14
      Width = 269
      Height = 17
      Caption = 'This report includes both Inpatient and Clinic Order data.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 512
    Height = 534
    ActivePage = tsMedicationLog
    Align = alClient
    TabOrder = 1
    TabStop = False
    object tsDueList: TTabSheet
      HelpContext = 46
      Caption = 'Due List'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grpPrintBy: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 341
        Width = 498
        Height = 160
        HelpContext = 700
        Margins.Top = 5
        Margins.Bottom = 5
        Align = alBottom
        Caption = 'Print b&y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object rbtnPatient: TRadioButton
          Left = 16
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Patient'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbtnPatientClick
        end
        object rbtnWard: TRadioButton
          Left = 16
          Top = 34
          Width = 97
          Height = 17
          Caption = '&Ward'
          TabOrder = 1
          OnClick = rbtnWardClick
          OnEnter = rgrpWardOptionsClick
        end
        object pnlPrintByWardOptions: TPanel
          Left = 1
          Top = 55
          Width = 491
          Height = 67
          BevelOuter = bvNone
          Caption = 'pnlPrintByWardOptions'
          TabOrder = 4
          object rgrpWardOptions: TRadioGroup
            Left = 46
            Top = 0
            Width = 436
            Height = 67
            Caption = 'Print by Ward Options'
            Enabled = False
            Items.Strings = (
              'Sort by Patient'
              'Sort by Room-Bed'
              'Print Selected Patients on Ward - ')
            TabOrder = 0
            OnClick = rgrpWardOptionsClick
          end
          object btnSelectPatients: TButton
            Left = 373
            Top = 35
            Width = 89
            Height = 25
            Caption = 'Select P&atients'
            Enabled = False
            TabOrder = 2
            OnClick = btnSelectPatientsClick
          end
          object edtPatientsSelected: TEdit
            Left = 234
            Top = 48
            Width = 121
            Height = 17
            BorderStyle = bsNone
            Color = clBtnFace
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            Text = 'No Patients Selected'
          end
        end
        object cbxWards: TComboBox
          Left = 72
          Top = 30
          Width = 253
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemHeight = 0
          TabOrder = 2
          OnChange = cbxWardsChange
        end
        object chkExcludeInactiveWards: TCheckBox
          Left = 345
          Top = 32
          Width = 138
          Height = 17
          Caption = 'Exclude Inactive Wards'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = chkExcludeInactiveWardsClick
        end
        object btnSelectClinics: TButton
          Left = 75
          Top = 128
          Width = 75
          Height = 25
          HelpContext = 242
          Caption = 'Select Clinics'
          TabOrder = 5
          OnClick = btnSelectClinicsClick
        end
        object rbtnClinic: TRadioButton
          Left = 19
          Top = 132
          Width = 50
          Height = 17
          Caption = 'Clinic'
          TabOrder = 6
          OnClick = rbtnClinicClick
        end
        object lblSelectedClinicsMsg: TStaticText
          Left = 168
          Top = 132
          Width = 115
          Height = 17
          Caption = 'No Clinics Selected'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
      end
      object pnlDateTimeRange: TPanel
        Left = 0
        Top = 0
        Width = 504
        Height = 109
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object pnlDateRange: TPanel
          Left = 0
          Top = 0
          Width = 504
          Height = 54
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object grpStartDate: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 198
            Height = 48
            Align = alLeft
            Caption = 'Start &Date: '
            TabOrder = 0
            object dtpkrStart: TDateTimePicker
              Left = 19
              Top = 16
              Width = 102
              Height = 21
              Date = 38930.709073229170000000
              Time = 38930.709073229170000000
              TabOrder = 0
            end
          end
          object grpStopDate: TGroupBox
            AlignWithMargins = True
            Left = 207
            Top = 3
            Width = 294
            Height = 48
            Align = alClient
            Anchors = [akLeft, akTop, akBottom]
            Caption = 'Stop Dat&e: '
            TabOrder = 1
            object dtpkrStop: TDateTimePicker
              Left = 19
              Top = 16
              Width = 102
              Height = 21
              Date = 38930.709073229170000000
              Time = 38930.709073229170000000
              TabOrder = 0
            end
          end
        end
        object pnlTimeRange: TPanel
          Left = 0
          Top = 54
          Width = 504
          Height = 55
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object grpStartTime: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 198
            Height = 49
            Align = alLeft
            Caption = 'Start &Time: '
            TabOrder = 0
            object cbxStart: TComboBox
              Left = 19
              Top = 16
              Width = 60
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '0001'
                '0100'
                '0200'
                '0300'
                '0400'
                '0500'
                '0600'
                '0700'
                '0800'
                '0900'
                '1000'
                '1100'
                '1200'
                '1300'
                '1400'
                '1500'
                '1600'
                '1700'
                '1800'
                '1900'
                '2000'
                '2100'
                '2200'
                '2300'
                '2400')
            end
          end
          object grpStopTime: TGroupBox
            AlignWithMargins = True
            Left = 207
            Top = 3
            Width = 294
            Height = 49
            Align = alClient
            Caption = 'Stop T&ime: '
            TabOrder = 1
            object cbxStop: TComboBox
              Left = 19
              Top = 16
              Width = 60
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '0000'
                '0100'
                '0200'
                '0300'
                '0400'
                '0500'
                '0600'
                '0700'
                '0800'
                '0900'
                '1000'
                '1100'
                '1200'
                '1300'
                '1400'
                '1500'
                '1600'
                '1700'
                '1800'
                '1900'
                '2000'
                '2100'
                '2200'
                '2300'
                '2400')
            end
          end
        end
      end
      object pnlCenterDueList: TPanel
        Left = 0
        Top = 109
        Width = 504
        Height = 233
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          504
          233)
        object grpIncludeScheduleTypes: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 0
          Width = 498
          Height = 65
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Include &Schedule Types: '
          TabOrder = 0
          object cbxDLContinuous: TCheckBox
            Left = 47
            Top = 22
            Width = 82
            Height = 15
            Caption = 'Continuous'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object cbxDLPRN: TCheckBox
            Left = 47
            Top = 43
            Width = 82
            Height = 15
            Caption = 'PRN'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object cbxDLOnCall: TCheckBox
            Left = 155
            Top = 22
            Width = 82
            Height = 15
            Caption = 'On-Call'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object cbxDLOneTime: TCheckBox
            Left = 155
            Top = 43
            Width = 82
            Height = 15
            Caption = 'One-Time'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
        end
        object grpIncludeOrderTypes: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 70
          Width = 498
          Height = 91
          Margins.Top = 5
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Include &Order Types: '
          TabOrder = 1
          object cbxIncludeIV: TCheckBox
            Left = 45
            Top = 17
            Width = 81
            Height = 17
            Caption = 'IVs'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object cbxIncludeUD: TCheckBox
            Left = 155
            Top = 17
            Width = 73
            Height = 17
            Caption = 'Unit Dose'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object cbxIncludeFuture: TCheckBox
            Left = 45
            Top = 40
            Width = 161
            Height = 17
            Caption = 'Include Future Orders'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object cbxIncludeAddendums: TCheckBox
            Left = 45
            Top = 63
            Width = 137
            Height = 17
            Caption = 'Include Addendums'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
        end
        object grpDLInclDetail: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 164
          Width = 268
          Height = 66
          Caption = 'Include &Detail'
          TabOrder = 2
          object chkDLIncludeSpecInstr: TCheckBox
            Left = 47
            Top = 25
            Width = 199
            Height = 17
            Caption = 'Special Instructions / Other Print Info'
            TabOrder = 0
          end
        end
        object rgrpDLOrderMode: TRadioGroup
          Left = 277
          Top = 164
          Width = 224
          Height = 66
          Anchors = [akLeft, akTop, akRight]
          Caption = 'I&nclude Orders'
          Items.Strings = (
            'Inpatient Orders'
            'Clinic Orders')
          TabOrder = 3
          TabStop = True
          OnClick = rgrpMMOrderModeClick
        end
      end
    end
    object tsMedicationLog: TTabSheet
      HelpContext = 10
      Caption = 'Med Log'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlCenterMedLog: TPanel
        Left = 3
        Top = 144
        Width = 398
        Height = 73
        BevelOuter = bvNone
        TabOrder = 0
        object grpInclude: TGroupBox
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 388
          Height = 63
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Caption = 'Incl&ude Detail: '
          TabOrder = 0
          object cbComments: TCheckBox
            Left = 47
            Top = 37
            Width = 121
            Height = 17
            Caption = 'Comments'
            TabOrder = 1
            OnClick = cbCommentsClick
          end
          object cbAudits: TCheckBox
            Left = 47
            Top = 14
            Width = 105
            Height = 17
            Caption = 'Audits'
            TabOrder = 0
          end
        end
      end
    end
    object tsMedicationsGiven: TTabSheet
      HelpContext = 40
      Caption = 'Med Admin History'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tsWardAdministrationTimes: TTabSheet
      HelpContext = 28
      Caption = 'Administration Times'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        504
        506)
      object pnlCenterAT: TPanel
        Left = 3
        Top = 128
        Width = 498
        Height = 73
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        object rgrpATOrderMode: TRadioGroup
          Left = 6
          Top = 1
          Width = 486
          Height = 64
          Caption = 'I&nclude Orders'
          Items.Strings = (
            'Inpatient Orders'
            'Clinic Orders')
          TabOrder = 0
          TabStop = True
          OnClick = rgrpMMOrderModeClick
        end
      end
    end
    object tsMissedMedications: TTabSheet
      HelpContext = 43
      Caption = 'Missed Medications'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        504
        506)
      object pnlCenterMM: TPanel
        Left = 3
        Top = 176
        Width = 497
        Height = 153
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        Padding.Left = 2
        Padding.Right = 2
        TabOrder = 0
        object grpMMIncludeOrderStatus: TGroupBox
          Left = 2
          Top = 0
          Width = 493
          Height = 49
          Margins.Left = 5
          Margins.Right = 5
          Align = alTop
          Caption = 'Include &Order Status: '
          TabOrder = 0
          object chkMMActive: TCheckBox
            Left = 33
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Active'
            Checked = True
            Enabled = False
            State = cbChecked
            TabOrder = 0
          end
          object chkMMDCd: TCheckBox
            Left = 130
            Top = 20
            Width = 81
            Height = 17
            Caption = 'DC'#39'd'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkMMExpired: TCheckBox
            Left = 217
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Expired'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
        object grpIncludeStatus: TGroupBox
          Left = 2
          Top = 49
          Width = 493
          Height = 48
          Align = alTop
          Caption = 'Include Admin &Status: '
          TabOrder = 1
          object chkMMMissingDose: TCheckBox
            Left = 33
            Top = 18
            Width = 81
            Height = 21
            Caption = 'Missing Dose'
            Checked = True
            Enabled = False
            State = cbChecked
            TabOrder = 0
          end
          object chkMMHeld: TCheckBox
            Left = 130
            Top = 18
            Width = 81
            Height = 21
            Caption = 'Held'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkMMRefused: TCheckBox
            Left = 217
            Top = 18
            Width = 81
            Height = 21
            Caption = 'Refused'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
        object grpMMInclude: TGroupBox
          Left = 2
          Top = 97
          Width = 223
          Height = 56
          Margins.Bottom = 0
          Align = alLeft
          Caption = 'Incl&ude Detail: '
          TabOrder = 2
          object chkMMComments: TCheckBox
            Left = 33
            Top = 18
            Width = 128
            Height = 17
            Caption = 'Comments/Reasons'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
        end
        object rgrpMMOrderMode: TRadioGroup
          Left = 225
          Top = 97
          Width = 270
          Height = 56
          Align = alClient
          Caption = 'I&nclude Orders'
          Items.Strings = (
            'Inpatient Orders'
            'Clinic Orders')
          TabOrder = 3
          TabStop = True
          OnClick = rgrpMMOrderModeClick
        end
      end
    end
    object tbshtPRNEffectivenessList: TTabSheet
      HelpContext = 95
      Caption = 'PRN Effectiveness List'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tbshtMedVarianceLog: TTabSheet
      HelpContext = 85
      Caption = 'Medication Variance'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tbshtVitalsCumulative: TTabSheet
      HelpContext = 88
      Caption = 'Vitals Cumulative'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tbshtMedHistory: TTabSheet
      HelpContext = 42
      Caption = 'Medication History'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlCenterMedHistory: TPanel
        Left = 7
        Top = 168
        Width = 387
        Height = 57
        BevelOuter = bvNone
        TabOrder = 0
        object grpIncludeMedHistory: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 381
          Height = 51
          Align = alClient
          Caption = 'Incl&ude Detail: '
          TabOrder = 0
          object chkMedHistoryComments: TCheckBox
            Left = 48
            Top = 20
            Width = 121
            Height = 17
            Caption = 'Comments'
            TabOrder = 0
          end
        end
      end
    end
    object tbshtUnknownActions: TTabSheet
      HelpContext = 115
      Caption = 'Unknown Actions'
      ImageIndex = 9
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tbshtUnableToScanDetailed: TTabSheet
      HelpContext = 86
      Caption = 'Unable to Scan (Detailed)'
      ImageIndex = 10
      OnShow = tbshtUnableToScanDetailedShow
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlCenterUtSDetailed: TPanel
        Left = 3
        Top = 274
        Width = 406
        Height = 107
        BevelOuter = bvNone
        TabOrder = 0
        object grpSortBy: TGroupBox
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 396
          Height = 96
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          Caption = 'Sort By: '
          TabOrder = 0
          object pnlUtSDetailedSortDir: TPanel
            Left = 2
            Top = 42
            Width = 127
            Height = 45
            BevelOuter = bvNone
            TabOrder = 0
            object rbtnAscending: TRadioButton
              Left = 33
              Top = 7
              Width = 129
              Height = 17
              Caption = 'Ascending'
              Checked = True
              Enabled = False
              TabOrder = 0
              TabStop = True
            end
            object rbtnDescending: TRadioButton
              Left = 33
              Top = 30
              Width = 129
              Height = 11
              Caption = 'Descending'
              Enabled = False
              TabOrder = 1
            end
          end
          object cbxUtSDetailedSortBy: TComboBox
            Left = 35
            Top = 21
            Width = 225
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            Sorted = True
            TabOrder = 1
            OnChange = cbxUtSDetailedSortByChange
          end
        end
      end
      object grpMSFReason: TGroupBox
        Left = 254
        Top = 3
        Width = 237
        Height = 78
        Caption = 'Select &Reason: '
        TabOrder = 2
        object cbxMSFReasons: TComboBox
          Left = 12
          Top = 32
          Width = 209
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'All Reasons'
          OnChange = cbxMSFReasonsChange
          Items.Strings = (
            'All Reasons'
            'Damaged Medication Label'
            'Damaged Wristband'
            'Dose Discrepancy'
            'No Bar Code'
            'Scanning Equipment Failure'
            'Unable to Determine')
        end
      end
      object rgScanFailureType: TRadioGroup
        Left = 3
        Top = 3
        Width = 245
        Height = 78
        Caption = 'Type of Sca&nning Failure: '
        ItemIndex = 0
        Items.Strings = (
          'All Scanning Failures'
          'Medication Only'
          'Wristband Only')
        TabOrder = 1
        OnClick = rgScanFailureTypeClick
      end
      object grpMSFFor: TGroupBox
        Left = 3
        Top = 387
        Width = 496
        Height = 83
        Caption = '&For: '
        TabOrder = 3
        object cbxForSelectWard: TComboBox
          Left = 69
          Top = 46
          Width = 248
          Height = 21
          Style = csDropDownList
          Color = clBtnFace
          Enabled = False
          ItemHeight = 0
          TabOrder = 2
        end
        object cbForExcludeInactiveWards: TCheckBox
          Left = 334
          Top = 41
          Width = 138
          Height = 17
          Caption = 'Exclude Inactive Wards'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = cbForExcludeInactiveWardsClick
        end
        object rbForSelectWard: TRadioButton
          Left = 14
          Top = 46
          Width = 49
          Height = 17
          Caption = '&Ward'
          TabOrder = 1
          TabStop = True
          OnClick = rbForSelectWardClick
        end
        object rbForAllWardsPatients: TRadioButton
          Left = 14
          Top = 23
          Width = 113
          Height = 17
          Caption = 'All Wards/Patients'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbForAllWardsPatientsClick
        end
        object cbExcludeMasWardsDetailed: TCheckBox
          Left = 334
          Top = 56
          Width = 126
          Height = 17
          Caption = 'Exclude MAS Wards'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = cbExcludeMasWardsDetailedClick
        end
      end
      object grpMSFSortBy: TGroupBox
        Left = 3
        Top = 81
        Width = 496
        Height = 191
        Caption = '&Sort: '
        TabOrder = 4
        object GroupBox2: TGroupBox
          Left = 13
          Top = 22
          Width = 470
          Height = 48
          Caption = 'Primary Sort By: '
          TabOrder = 0
          object cbxSort1: TComboBox
            Left = 56
            Top = 18
            Width = 192
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 0
            Text = 'Date/Time of Scanning Failure'
            OnChange = cbxSort1Change
            Items.Strings = (
              'Date/Time of Scanning Failure'
              'Drug'
              'Location (Ward, Room-Bed)'
              'Patient Name'
              'Reason'
              'Type (Wristband or Medication)'
              'User')
          end
          object rbSort1Asc: TRadioButton
            Left = 263
            Top = 19
            Width = 75
            Height = 17
            Caption = 'Ascending'
            Checked = True
            TabOrder = 1
            TabStop = True
            OnClick = rbSort1AscClick
          end
          object rbSort1Desc: TRadioButton
            Left = 345
            Top = 18
            Width = 87
            Height = 17
            Caption = 'Descending'
            TabOrder = 2
            TabStop = True
            OnClick = rbSort1DescClick
          end
        end
        object GroupBox3: TGroupBox
          Left = 13
          Top = 76
          Width = 470
          Height = 48
          Caption = 'Second Sort By: '
          TabOrder = 1
          object cbxSort2: TComboBox
            Left = 55
            Top = 18
            Width = 192
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = cbxSort2Change
            OnDropDown = cbxSort2DropDown
            Items.Strings = (
              'none'
              'Date/Time of Scanning Failure'
              'Drug'
              'Location (Ward, Room-Bed)'
              'Patient Name'
              'Reason'
              'Type (Wristband or Medication)'
              'User')
          end
          object rbSort2Asc: TRadioButton
            Left = 263
            Top = 19
            Width = 75
            Height = 17
            Caption = 'Ascending'
            TabOrder = 1
            TabStop = True
            Visible = False
            OnClick = rbSort2AscClick
          end
          object rbSort2Desc: TRadioButton
            Left = 345
            Top = 18
            Width = 87
            Height = 17
            Caption = 'Descending'
            TabOrder = 2
            TabStop = True
            Visible = False
            OnClick = rbSort2DescClick
          end
        end
        object GroupBox4: TGroupBox
          Left = 13
          Top = 130
          Width = 470
          Height = 48
          Caption = 'Third Sort By: '
          TabOrder = 2
          object cbxSort3: TComboBox
            Left = 55
            Top = 18
            Width = 192
            Height = 21
            Style = csDropDownList
            Color = clBtnFace
            ItemHeight = 13
            TabOrder = 0
            OnChange = cbxSort3Change
            OnDropDown = cbxSort3DropDown
            Items.Strings = (
              'none'
              'Date/Time of Scanning Failure'
              'Drug'
              'Location (Ward, Room-Bed)'
              'Patient Name'
              'Reason'
              'Type (Wristband or Medication)'
              'User')
          end
          object rbSort3Asc: TRadioButton
            Left = 263
            Top = 19
            Width = 75
            Height = 17
            Caption = 'Ascending'
            TabOrder = 1
            TabStop = True
            Visible = False
            OnClick = rbSort3AscClick
          end
          object rbSort3Desc: TRadioButton
            Left = 345
            Top = 18
            Width = 87
            Height = 17
            Caption = 'Descending'
            TabOrder = 2
            TabStop = True
            Visible = False
            OnClick = rbSort3DescClick
          end
        end
      end
    end
    object tbshtUnableToScanSummary: TTabSheet
      HelpContext = 114
      Caption = 'Unable to Scan (Summary)'
      ImageIndex = 11
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grpUASSummaryFor: TGroupBox
        Left = 3
        Top = 168
        Width = 496
        Height = 109
        Caption = '&For: '
        TabOrder = 0
        object rbEntireFacility: TRadioButton
          Left = 16
          Top = 26
          Width = 201
          Height = 17
          Caption = 'Entire Facility (1 page report)'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbEntireFacilityClick
        end
        object rbNurseUnitLocation: TRadioButton
          Left = 16
          Top = 50
          Width = 281
          Height = 17
          Caption = '&Nurse Unit/Location (1 Unit per page)'
          TabOrder = 1
          TabStop = True
          OnClick = rbNurseUnitLocationClick
        end
        object cbxUASSummaryWardList: TComboBox
          Left = 68
          Top = 73
          Width = 249
          Height = 21
          Style = csDropDownList
          Color = clBtnFace
          ItemHeight = 0
          TabOrder = 3
        end
        object cbUASSummaryExcludeInactiveWards: TCheckBox
          Left = 332
          Top = 67
          Width = 137
          Height = 17
          Caption = 'Exclude Inactive Wards'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = cbUASSummaryExcludeInactiveWardsClick
        end
        object rbUASSummaryWard: TRadioButton
          Left = 16
          Top = 75
          Width = 48
          Height = 17
          Caption = '&Ward'
          TabOrder = 2
          TabStop = True
          OnClick = rbUASSummaryWardClick
        end
        object cbExcludeMasWards: TCheckBox
          Left = 332
          Top = 82
          Width = 126
          Height = 17
          Caption = 'Exclude MAS Wards'
          Checked = True
          State = cbChecked
          TabOrder = 5
          OnClick = cbExcludeMasWardsClick
        end
      end
    end
    object tbshtMedicationOverview: TTabSheet
      HelpContext = 102
      Caption = 'Medication Overview'
      ImageIndex = 12
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        504
        506)
      object pnlCenterMO: TPanel
        Left = 3
        Top = 144
        Width = 498
        Height = 113
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        Padding.Left = 2
        Padding.Right = 2
        TabOrder = 0
        object grpMOIncludeOrderTypes: TGroupBox
          Left = 2
          Top = 0
          Width = 303
          Height = 62
          Align = alLeft
          Caption = 'Include Order &Status:  '
          TabOrder = 0
          object chkMOFuture: TCheckBox
            Left = 106
            Top = 20
            Width = 71
            Height = 17
            Caption = 'Future'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkMOActive: TCheckBox
            Left = 30
            Top = 20
            Width = 59
            Height = 17
            Caption = 'Active'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object chkMOExpired: TCheckBox
            Left = 193
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Expired/DC'#39'd'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
        object grpMOIncludeDetail: TGroupBox
          Left = 2
          Top = 62
          Width = 494
          Height = 51
          Align = alBottom
          Caption = 'Incl&ude Detail: '
          TabOrder = 1
          object chkMOActions: TCheckBox
            Left = 30
            Top = 20
            Width = 59
            Height = 17
            Caption = 'Actions'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chkMOActionsClick
          end
          object chkMOComments: TCheckBox
            Left = 106
            Top = 20
            Width = 71
            Height = 17
            Caption = 'Comments'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkMOSpecInstr: TCheckBox
            Left = 193
            Top = 20
            Width = 197
            Height = 17
            Caption = 'Special Instructions / Other Print Info'
            TabOrder = 2
          end
        end
        object rgrpMOOrderMode: TRadioGroup
          Left = 305
          Top = 0
          Width = 191
          Height = 62
          Align = alClient
          Caption = 'I&nclude Orders'
          Items.Strings = (
            'Inpatient Orders'
            'Clinic Orders')
          TabOrder = 2
          TabStop = True
          OnClick = rgrpMMOrderModeClick
        end
      end
    end
    object tbshtPRNOverview: TTabSheet
      HelpContext = 913
      Caption = 'PRN Overview'
      ImageIndex = 13
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        504
        506)
      object pnlCenterPRN: TPanel
        Left = 3
        Top = 144
        Width = 498
        Height = 113
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        Padding.Left = 2
        Padding.Right = 2
        TabOrder = 0
        object grpPRNIncludeOrderTypes: TGroupBox
          Left = 2
          Top = 0
          Width = 295
          Height = 56
          Align = alLeft
          Caption = 'Include Order &Status:'
          TabOrder = 0
          object chkPRNFuture: TCheckBox
            Left = 106
            Top = 20
            Width = 69
            Height = 17
            Caption = 'Future'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkPRNActive: TCheckBox
            Left = 35
            Top = 20
            Width = 59
            Height = 17
            Caption = 'Active'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object chkPRNExpired: TCheckBox
            Left = 181
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Expired/DC'#39'd'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
        object grpIncludeDetail: TGroupBox
          Left = 2
          Top = 56
          Width = 494
          Height = 57
          Align = alBottom
          Caption = 'Incl&ude Detail: '
          TabOrder = 1
          object chkPRNActions: TCheckBox
            Left = 35
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Actions'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chkPRNActionsClick
          end
          object chkPRNComments: TCheckBox
            Left = 106
            Top = 20
            Width = 71
            Height = 17
            Caption = 'Comments'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkPRNSpecInstr: TCheckBox
            Left = 181
            Top = 20
            Width = 202
            Height = 17
            Caption = 'Special Instructions / Other Print Info'
            TabOrder = 2
          end
        end
        object rgrpPOOrderMode: TRadioGroup
          Left = 297
          Top = 0
          Width = 199
          Height = 56
          Align = alClient
          Caption = 'I&nclude Orders'
          Items.Strings = (
            'Inpatient Orders'
            'Clinic Orders')
          TabOrder = 2
          TabStop = True
          OnClick = rgrpMMOrderModeClick
        end
      end
    end
    object tbshtIVOverview: TTabSheet
      HelpContext = 916
      Caption = 'IV Overview'
      ImageIndex = 14
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        504
        506)
      object pnlCenterIVO: TPanel
        Left = 3
        Top = 144
        Width = 498
        Height = 113
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        Padding.Left = 2
        Padding.Right = 2
        TabOrder = 0
        object grpIVOIncludeOrderTypes: TGroupBox
          Left = 2
          Top = 0
          Width = 311
          Height = 56
          Align = alLeft
          Caption = 'Include Order &Status:'
          TabOrder = 0
          object chkIVOStopped: TCheckBox
            Left = 127
            Top = 20
            Width = 90
            Height = 17
            Caption = 'Stopped Bags'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkIVOInfusing: TCheckBox
            Left = 30
            Top = 20
            Width = 91
            Height = 17
            Caption = 'Infusing Bags'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object chkIVOOthers: TCheckBox
            Left = 223
            Top = 20
            Width = 66
            Height = 17
            Caption = 'All Others'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
        object grpIVOIncludeDetail: TGroupBox
          Left = 2
          Top = 56
          Width = 494
          Height = 57
          Align = alBottom
          Caption = 'Incl&ude Detail: '
          TabOrder = 1
          object chkIVOActions: TCheckBox
            Left = 30
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Actions'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chkIVOActionsClick
          end
          object chkIVOComments: TCheckBox
            Left = 127
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Comments'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkIVOtherPrintInfo: TCheckBox
            Left = 223
            Top = 20
            Width = 97
            Height = 17
            Caption = 'Other Print Info'
            TabOrder = 2
          end
        end
        object rgrpIVOrderMode: TRadioGroup
          Left = 313
          Top = 0
          Width = 183
          Height = 56
          Align = alClient
          Caption = 'I&nclude Orders'
          Items.Strings = (
            'Inpatient Orders'
            'Clinic Orders')
          TabOrder = 2
          TabStop = True
          OnClick = rgrpMMOrderModeClick
        end
      end
    end
    object tbshtExpiredOrders: TTabSheet
      HelpContext = 915
      Caption = 'Expired/DC'#39'd/Expiring Orders'
      ImageIndex = 15
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        504
        506)
      object pnlCenterEX: TPanel
        Left = 3
        Top = 144
        Width = 498
        Height = 113
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        Padding.Left = 2
        Padding.Right = 2
        TabOrder = 0
        object grpEXIncludeOrderTypes: TGroupBox
          Left = 2
          Top = 0
          Width = 319
          Height = 56
          Align = alLeft
          Caption = 'Include Order &Status:'
          TabOrder = 0
          object chkEXExpiring: TCheckBox
            Left = 107
            Top = 20
            Width = 90
            Height = 17
            Caption = 'Expiring Today'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkEXExpired: TCheckBox
            Left = 20
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Expired/DC'#39'd'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object chkEXExpiringTomorrow: TCheckBox
            Left = 203
            Top = 20
            Width = 111
            Height = 17
            Caption = 'Expiring Tomorrow'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
        object grpEXIncludeDetail: TGroupBox
          Left = 2
          Top = 56
          Width = 494
          Height = 57
          Align = alBottom
          Caption = 'Incl&ude Detail: '
          TabOrder = 1
          object chkEXActions: TCheckBox
            Left = 20
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Actions'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chkEXActionsClick
          end
          object chkEXComments: TCheckBox
            Left = 107
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Comments'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkEXSpecInstr: TCheckBox
            Left = 203
            Top = 20
            Width = 204
            Height = 17
            Caption = 'Special Instructions / Other Print Info'
            TabOrder = 2
          end
        end
        object rgrpEXOrderMode: TRadioGroup
          Left = 321
          Top = 0
          Width = 175
          Height = 56
          Align = alClient
          Caption = 'I&nclude Orders'
          Items.Strings = (
            'Inpatient Orders'
            'Clinic Orders')
          TabOrder = 2
          TabStop = True
          OnClick = rgrpMMOrderModeClick
        end
      end
    end
    object tbshtMedTherapy: TTabSheet
      HelpContext = 12
      Caption = 'Medication Therapy'
      ImageIndex = 16
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        504
        506)
      object pnlCenterMedTherapy: TPanel
        Left = 3
        Top = 144
        Width = 334
        Height = 193
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        Padding.Left = 2
        Padding.Right = 2
        TabOrder = 0
        object grpMedTherapyIncludeScheduleTypes: TGroupBox
          Left = 2
          Top = 0
          Width = 330
          Height = 81
          Align = alTop
          Caption = 'Include &Schedule Types: '
          TabOrder = 0
          object chkMedTherapyContinuous: TCheckBox
            Left = 30
            Top = 22
            Width = 82
            Height = 15
            Caption = 'Continuous'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object chkMedTherapyPRN: TCheckBox
            Left = 30
            Top = 43
            Width = 82
            Height = 15
            Caption = 'PRN'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object chkMedTherapyOnCall: TCheckBox
            Left = 138
            Top = 22
            Width = 82
            Height = 15
            Caption = 'On-Call'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkMedTherapyOneTime: TCheckBox
            Left = 138
            Top = 43
            Width = 82
            Height = 15
            Caption = 'One-Time'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
        end
        object grpMedTherapyIncludeDetail: TGroupBox
          Left = 2
          Top = 81
          Width = 330
          Height = 57
          Align = alTop
          Caption = 'Incl&ude Detail: '
          TabOrder = 1
          object chkMedTherapyComments: TCheckBox
            Left = 30
            Top = 20
            Width = 89
            Height = 17
            Caption = 'Comments'
            TabOrder = 0
          end
        end
        object grpMedicationSearch: TGroupBox
          Left = 2
          Top = 138
          Width = 330
          Height = 55
          Align = alTop
          Caption = 'Medication Search: '
          TabOrder = 2
          object btnSelectMedications: TButton
            Left = 30
            Top = 19
            Width = 107
            Height = 25
            Caption = 'Select &Medications'
            TabOrder = 0
            OnClick = btnSelectMedicationsClick
          end
          object edtMedTherapyMedicationsSelected: TEdit
            Left = 151
            Top = 25
            Width = 153
            Height = 12
            BorderStyle = bsNone
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            Text = 'No Medications Selected'
          end
        end
      end
    end
    object tbshtIVBagStatus: TTabSheet
      HelpContext = 38
      Caption = 'IV Bag Status'
      ImageIndex = 17
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        504
        506)
      object pnlCenterIVB: TPanel
        Left = 3
        Top = 144
        Width = 334
        Height = 193
        Anchors = [akLeft, akTop, akRight]
        BevelOuter = bvNone
        Padding.Left = 2
        Padding.Right = 2
        TabOrder = 0
        object grpIVBIncludeOrderStatus: TGroupBox
          Left = 2
          Top = 0
          Width = 330
          Height = 50
          Align = alTop
          Caption = 'Include &Order Status: '
          TabOrder = 0
          object chkIVBDCd: TCheckBox
            Left = 143
            Top = 20
            Width = 81
            Height = 17
            Caption = 'DC'#39'd'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkIVBActive: TCheckBox
            Left = 30
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Active'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object chkIVBExpired: TCheckBox
            Left = 230
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Expired'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
        object grpIVBIncludeBagStatus: TGroupBox
          Left = 2
          Top = 50
          Width = 330
          Height = 95
          Align = alTop
          Caption = 'Include &Bag Status:'
          TabOrder = 1
          object chkIVBCompleted: TCheckBox
            Left = 30
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Completed'
            TabOrder = 0
          end
          object chkIVBInfusing: TCheckBox
            Left = 143
            Top = 20
            Width = 81
            Height = 17
            Caption = 'Infusing'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkIVBStopped: TCheckBox
            Left = 230
            Top = 16
            Width = 81
            Height = 21
            Caption = 'Stopped'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object chkIVBMissing: TCheckBox
            Left = 30
            Top = 43
            Width = 81
            Height = 17
            Caption = 'Missing Dose'
            TabOrder = 3
          end
          object chkIVBHeld: TCheckBox
            Left = 143
            Top = 43
            Width = 81
            Height = 17
            Caption = 'Held'
            Checked = True
            State = cbChecked
            TabOrder = 4
          end
          object chkIVBRefused: TCheckBox
            Left = 230
            Top = 39
            Width = 81
            Height = 21
            Caption = 'Refused'
            TabOrder = 5
          end
          object chkIVBNoAction: TCheckBox
            Left = 30
            Top = 66
            Width = 119
            Height = 17
            Caption = 'No Action Taken'
            TabOrder = 6
          end
        end
        object grpIVBIncludeDetail: TGroupBox
          Left = 2
          Top = 145
          Width = 330
          Height = 48
          Align = alClient
          Caption = 'Incl&ude Detail: '
          TabOrder = 2
          object chkIVBComments: TCheckBox
            Left = 30
            Top = 20
            Width = 89
            Height = 17
            Caption = 'Comments'
            TabOrder = 0
          end
          object chkIVBOtherPrintInfo: TCheckBox
            Left = 143
            Top = 20
            Width = 97
            Height = 17
            Caption = 'Other Print Info'
            TabOrder = 1
          end
        end
      end
    end
  end
end
