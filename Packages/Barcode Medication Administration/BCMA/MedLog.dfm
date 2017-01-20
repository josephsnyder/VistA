object frmMedLog: TfrmMedLog
  Left = 549
  Top = 281
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 10
  Caption = 'Medication Log'
  ClientHeight = 414
  ClientWidth = 728
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = lbxPRNReasonsKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 381
    Width = 728
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      728
      33)
    object btnOK: TButton
      Left = 550
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 630
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 57
    Top = 0
    Width = 671
    Height = 381
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel3'
    TabOrder = 1
    object PageControl: TPageControl
      Left = 0
      Top = 246
      Width = 671
      Height = 135
      ActivePage = tsAddComment
      Align = alClient
      TabOrder = 1
      TabStop = False
      object tsConfirmPRN: TTabSheet
        HelpContext = 345
        Caption = 'PRN Reasons'
        DesignSize = (
          663
          107)
        object lblConfirmPRNSelectReason: TLabel
          Left = 5
          Top = 0
          Width = 82
          Height = 13
          Caption = 'Select a Reason:'
          FocusControl = lbxPRNReasons
        end
        object btnSubmit: TBitBtn
          Left = 336
          Top = 394
          Width = 75
          Height = 25
          Caption = '&Submit'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          Kind = bkOK
        end
        object BitBtn2: TBitBtn
          Left = 442
          Top = 394
          Width = 75
          Height = 25
          Caption = '&Cancel'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          Kind = bkCancel
        end
        object lbxPRNReasons: TListBox
          Left = 9
          Top = 14
          Width = 651
          Height = 75
          Anchors = [akLeft, akTop, akRight]
          Columns = 2
          ItemHeight = 13
          Items.Strings = (
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789')
          ParentShowHint = False
          ShowHint = True
          Sorted = True
          TabOrder = 2
          OnClick = lbxPRNReasonsClick
          OnContextPopup = lbxPRNReasonsContextPopup
          OnEnter = lbxPRNReasonsEnter
          OnKeyPress = lbxPRNReasonsKeyPress
        end
      end
      object tsPRNEffectiveness: TTabSheet
        HelpContext = 346
        Caption = 'PRN Effectiveness'
        ImageIndex = 1
        DesignSize = (
          663
          107)
        object lblPRNEffEnterComment: TLabel
          Left = 0
          Top = 0
          Width = 212
          Height = 13
          Caption = 'Enter a Comment  (150 Characters Maximum)'
          FocusControl = memPRNEffectiveness
        end
        object Label9: TLabel
          Left = 320
          Top = 0
          Width = 125
          Height = 13
          Alignment = taRightJustify
          Caption = '(150 Characters Maximum)'
          Enabled = False
          Visible = False
        end
        object memPRNEffectiveness: TMemo
          Left = 3
          Top = 19
          Width = 652
          Height = 64
          Anchors = [akLeft, akTop, akRight]
          Lines.Strings = (
            '0123456789012345678901234567890123456789012345678901234567890'
            '1234567890123456789012345678901234567890123456789012345678901'
            '2345678901234567890123456789')
          MaxLength = 150
          TabOrder = 0
          WantReturns = False
          OnChange = memPRNEffectivenessChange
          OnEnter = memPRNEffectivenessEnter
        end
      end
      object tsConfirmContinuous: TTabSheet
        HelpContext = 347
        Caption = 'Confirm Continuous'
        ImageIndex = 2
        DesignSize = (
          663
          107)
        object lblConfContEnterComment: TLabel
          Left = 3
          Top = 0
          Width = 212
          Height = 13
          Caption = 'Enter a Comment  (150 Characters Maximum)'
          FocusControl = memConfCont
        end
        object Label8: TLabel
          Left = 320
          Top = 0
          Width = 125
          Height = 13
          Alignment = taRightJustify
          Caption = '(150 Characters Maximum)'
          Enabled = False
          Visible = False
        end
        object memConfCont: TMemo
          Left = 3
          Top = 19
          Width = 652
          Height = 64
          Anchors = [akLeft, akTop, akRight]
          Lines.Strings = (
            '0123456789012345678901234567890123456789012345678901234567890'
            '1234567890123456789012345678901234567890123456789012345678901'
            '2345678901234567890123456789')
          MaxLength = 150
          TabOrder = 0
          WantReturns = False
          OnChange = memConfContChange
          OnEnter = memConfContEnter
        end
      end
      object tsNotGiven: TTabSheet
        HelpContext = 348
        Caption = 'Not Given'
        ImageIndex = 4
        DesignSize = (
          663
          107)
        object lblNotGivenSelectReason: TLabel
          Left = 3
          Top = 0
          Width = 79
          Height = 13
          Caption = 'Select a Reason'
          FocusControl = lbxNotGivenReasons
        end
        object lbxNotGivenReasons: TListBox
          Left = 9
          Top = 15
          Width = 651
          Height = 75
          Anchors = [akLeft, akTop, akRight]
          Columns = 2
          ItemHeight = 13
          Items.Strings = (
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789'
            '012345678901234567890123456789')
          ParentShowHint = False
          ShowHint = True
          Sorted = True
          TabOrder = 0
          OnClick = lbxNotGivenReasonsClick
          OnEnter = lbxNotGivenReasonsEnter
          OnKeyPress = lbxNotGivenReasonsKeyPress
        end
      end
      object tsAddComment: TTabSheet
        HelpContext = 349
        Caption = 'Add Comment'
        ImageIndex = 3
        DesignSize = (
          663
          107)
        object lblAddCommentEnterComment: TLabel
          Left = 5
          Top = 0
          Width = 212
          Height = 13
          Caption = 'Enter a Comment  (150 Characters Maximum)'
          FocusControl = mmoAddComment
        end
        object mmoAddComment: TMemo
          Left = 3
          Top = 19
          Width = 652
          Height = 82
          Anchors = [akLeft, akTop, akRight, akBottom]
          Lines.Strings = (
            '0123456789012345678901234567890123456789012345678901234567890'
            '1234567890123456789012345678901234567890123456789012345678901'
            '2345678901234567890123456789')
          MaxLength = 150
          TabOrder = 0
          WantReturns = False
          OnChange = mmoAddCommentChange
          OnContextPopup = mmoAddCommentContextPopup
          OnEnter = mmoAddCommentEnter
          OnMouseActivate = mmoAddCommentMouseActivate
          OnMouseDown = mmoAddCommentMouseDown
          OnMouseUp = mmoAddCommentMouseUp
        end
      end
    end
    object pnlConfirmation: TPanel
      Left = 0
      Top = 246
      Width = 671
      Height = 135
      Caption = 'pnlConfirmation'
      TabOrder = 2
      object lblConfComment: TLabel
        Left = 10
        Top = 7
        Width = 212
        Height = 13
        Caption = 'Enter a Comment  (135 Characters Maximum)'
        Transparent = True
      end
      object memConfComment: TMemo
        Left = 10
        Top = 24
        Width = 652
        Height = 82
        MaxLength = 135
        TabOrder = 0
        OnChange = memConfCommentChange
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 671
      Height = 246
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object pnlMedications: TPanel
        Left = 0
        Top = 0
        Width = 671
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblActiveMedicationCaption: TLabel
          Left = 4
          Top = 1
          Width = 88
          Height = 13
          Caption = '&Active Medication:'
          FocusControl = lblActiveMedication
        end
        object lblDispensedDrugCaption: TLabel
          Left = 4
          Top = 20
          Width = 79
          Height = 13
          Caption = '&Dispensed Drug:'
          FocusControl = lblDispensedDrug
        end
        object lblActiveMedication: TVA508StaticText
          Name = 'lblActiveMedication'
          Left = 108
          Top = 0
          Width = 87
          Height = 15
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Active Medication'
          ParentColor = True
          TabOrder = 0
          TabStop = True
          ShowAccelChar = True
        end
        object lblDispensedDrug: TVA508StaticText
          Name = 'lblDispensedDrug'
          Left = 108
          Top = 20
          Width = 78
          Height = 15
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Dispensed Drug'
          ParentColor = True
          TabOrder = 1
          TabStop = True
          ShowAccelChar = True
        end
      end
      object pnlInstructions: TPanel
        Left = 0
        Top = 33
        Width = 671
        Height = 116
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          671
          116)
        object lblSpecInstructions: TLabel
          Left = 4
          Top = 8
          Width = 177
          Height = 13
          Caption = '&Special Instructions / Other Print Info:'
          FocusControl = mmoSpecialInstructions
        end
        object pnlScrollDown: TPanel
          Left = 192
          Top = 1
          Width = 477
          Height = 27
          Anchors = [akTop, akRight]
          Caption = 'pnlScrollDown'
          TabOrder = 0
          object lblScrollDown: TStaticText
            Left = 8
            Top = 7
            Width = 316
            Height = 17
            Caption = '<Scroll down or click '#39'Display Instructions'#39' for full text>'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object btnDisplaySIOPI: TButton
            Left = 340
            Top = 2
            Width = 129
            Height = 25
            Caption = 'Display I&nstructions'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnClick = btnDisplaySIOPIClick
          end
        end
        object mmoSpecialInstructions: TMemo
          Left = 4
          Top = 28
          Width = 666
          Height = 88
          Anchors = [akLeft, akTop, akRight]
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Lines.Strings = (
            'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
            'MMMMMMMMM MMMM'
            'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
            'MMMMMMMMM MMMM'
            'MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM MMMMMMMMM '
            'MMMMMMMMM MMMM'
            '')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 1
          WantReturns = False
          OnEnter = mmoSpecialInstructionsEnter
        end
      end
      object pnlMessage: TPanel
        Left = 0
        Top = 149
        Width = 671
        Height = 97
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          671
          97)
        object lblMessage: TLabel
          Left = 4
          Top = 3
          Width = 46
          Height = 13
          Caption = '&Message:'
        end
        object mmoMessage: TMemo
          Left = 4
          Top = 20
          Width = 666
          Height = 70
          Anchors = [akLeft, akTop, akRight, akBottom]
          Color = clBtnFace
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Lines.Strings = (
            'Status Message'
            'Status Message'
            'Status Message'
            'Status Message'
            'Status Message')
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          WantReturns = False
          OnEnter = mmoMessageEnter
        end
      end
    end
  end
  object pnlImage: TPanel
    Left = 0
    Top = 0
    Width = 57
    Height = 381
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    object Image: TImage
      Left = 2
      Top = 0
      Width = 49
      Height = 45
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 640
    Data = (
      (
        'Component = frmMedLog'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = PageControl'
        'Status = stsDefault')
      (
        'Component = lbxPRNReasons'
        'Label = lblConfirmPRNSelectReason'
        'Status = stsOK')
      (
        'Component = tsPRNEffectiveness'
        'Status = stsDefault')
      (
        'Component = mmoAddComment'
        'Label = lblAddCommentEnterComment'
        'Status = stsOK')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = tsConfirmPRN'
        'Status = stsDefault')
      (
        'Component = btnSubmit'
        'Status = stsDefault')
      (
        'Component = BitBtn2'
        'Status = stsDefault')
      (
        'Component = tsConfirmContinuous'
        'Status = stsDefault')
      (
        'Component = tsNotGiven'
        'Status = stsDefault')
      (
        'Component = tsAddComment'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = memConfCont'
        'Label = lblConfContEnterComment'
        'Status = stsOK')
      (
        'Component = memPRNEffectiveness'
        'Label = lblPRNEffEnterComment'
        'Status = stsOK')
      (
        'Component = lbxNotGivenReasons'
        'Label = lblNotGivenSelectReason'
        'Status = stsOK')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = pnlImage'
        'Status = stsDefault')
      (
        'Component = pnlMedications'
        'Status = stsDefault')
      (
        'Component = lblActiveMedication'
        'Status = stsDefault')
      (
        'Component = lblDispensedDrug'
        'Status = stsDefault')
      (
        'Component = pnlInstructions'
        'Status = stsDefault')
      (
        'Component = pnlScrollDown'
        'Status = stsDefault')
      (
        'Component = lblScrollDown'
        'Status = stsDefault')
      (
        'Component = btnDisplaySIOPI'
        'Status = stsDefault')
      (
        'Component = mmoSpecialInstructions'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = mmoMessage'
        'Status = stsDefault')
      (
        'Component = pnlConfirmation'
        'Status = stsDefault')
      (
        'Component = memConfComment'
        'Label = lblConfComment'
        'Status = stsOK'))
  end
end
