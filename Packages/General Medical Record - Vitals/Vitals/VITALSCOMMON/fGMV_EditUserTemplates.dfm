object frmGMV_EditUserTemplates: TfrmGMV_EditUserTemplates
  Left = 450
  Top = 183
  Width = 807
  Height = 624
  HelpContext = 4
  Caption = 'Create/Edit user templates'
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 529
    Width = 799
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 611
      Top = 0
      Width = 188
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object btnSaveTemplate: TButton
        Left = 23
        Top = 8
        Width = 80
        Height = 25
        Caption = '&Save'
        Enabled = False
        TabOrder = 0
        OnClick = btnSaveTemplateClick
      end
      object btnClose: TButton
        Left = 112
        Top = 8
        Width = 69
        Height = 25
        Caption = 'E&xit'
        TabOrder = 1
        OnClick = btnCloseClick
      end
    end
    object btnDelete: TButton
      Left = 104
      Top = 8
      Width = 73
      Height = 25
      Caption = '&Delete'
      TabOrder = 1
      TabStop = False
      OnClick = btnDeleteClick
    end
    object btnNewTemplate: TButton
      Left = 24
      Top = 8
      Width = 73
      Height = 25
      Caption = 'Ne&w'
      TabOrder = 0
      TabStop = False
      OnClick = btnNewTemplateClick
    end
  end
  object Panel8: TPanel
    Left = 0
    Top = 0
    Width = 799
    Height = 529
    Align = alClient
    Caption = 'Panel8'
    TabOrder = 0
    object Panel7: TPanel
      Left = 1
      Top = 1
      Width = 199
      Height = 527
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        199
        527)
      object GroupBox1: TGroupBox
        Left = 11
        Top = 4
        Width = 185
        Height = 515
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = '&User Templates'
        TabOrder = 0
        DesignSize = (
          185
          515)
        object lbxTemplates: TListBox
          Left = 11
          Top = 19
          Width = 162
          Height = 485
          Anchors = [akLeft, akTop, akBottom]
          BevelInner = bvNone
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          OnClick = lbxTemplatesClick
          OnEnter = lbxTemplatesEnter
          OnExit = lbxTemplatesExit
        end
      end
    end
    object Panel1: TPanel
      Left = 200
      Top = 1
      Width = 590
      Height = 527
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 1
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 590
        Height = 9
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
      end
      object Panel4: TPanel
        Left = 0
        Top = 519
        Width = 590
        Height = 8
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
      end
      object Panel9: TPanel
        Left = 0
        Top = 9
        Width = 590
        Height = 510
        Align = alClient
        Caption = 'Panel9'
        TabOrder = 2
        inline fraGMV_EditTemplate1: TfraGMV_EditTemplate
          Left = 1
          Top = 1
          Width = 588
          Height = 508
          Align = alClient
          Enabled = False
          TabOrder = 0
          inherited Splitter1: TSplitter
            Top = 233
            Width = 588
            Height = 3
          end
          inherited pnlQualifiers: TPanel
            Top = 236
            Width = 588
            Height = 272
            inherited Panel7: TPanel
              Height = 272
              Visible = False
            end
            inherited pnlDefaults: TPanel
              Width = 579
              Height = 272
              inherited Panel8: TPanel
                Top = 264
                Width = 579
                Height = 8
                TabOrder = 1
                Visible = False
              end
              inherited pnlDefaultQualifiers: TPanel
                Width = 579
                Height = 197
                TabOrder = 2
                inherited gb: TGroupBox
                  Width = 579
                  Height = 197
                end
              end
              inherited Panel2: TPanel
                Width = 579
                TabOrder = 0
                inherited rgMetric: TRadioGroup
                  Width = 579
                end
              end
              inherited Panel4: TPanel
                Width = 579
              end
            end
          end
          inherited pnlVitals: TPanel
            Width = 588
            Height = 233
            BevelOuter = bvNone
            inherited pnlListView: TPanel
              Left = 0
              Top = 100
              Width = 588
              Height = 133
              inherited Panel1: TPanel
                Width = 588
                Height = 133
                inherited Panel3: TPanel
                  Width = 588
                  Height = 25
                  inherited lblVitals: TLabel
                    Caption = 'V&itals'
                  end
                  inherited Panel5: TPanel
                    Left = 301
                    Width = 287
                    Height = 25
                    inherited SpeedButton1: TSpeedButton
                      Left = 17
                    end
                    inherited SpeedButton2: TSpeedButton
                      Left = 82
                    end
                    inherited SpeedButton3: TSpeedButton
                      Left = 147
                    end
                    inherited SpeedButton4: TSpeedButton
                      Left = 212
                    end
                  end
                end
                inherited lvVitals: TListView
                  Top = 25
                  Width = 588
                  Height = 108
                  OnEnter = fraGMV_EditTemplate1lvVitalsEnter
                  OnExit = fraGMV_EditTemplate1lvVitalsExit
                end
              end
            end
            inherited pnlHeader: TPanel
              Left = 0
              Top = 0
              Width = 588
            end
            inherited pnlNameDescription: TPanel
              Left = 0
              Top = 20
              Width = 588
              DesignSize = (
                588
                80)
              inherited Label1: TLabel
                Top = 4
              end
              inherited edtTemplateDescription: TEdit
                Left = 4
                Width = 579
              end
              inherited edtTemplateName: TEdit
                Left = 4
                Width = 579
              end
            end
          end
          inherited ActionList1: TActionList
            Top = 42
          end
          inherited ImageList1: TImageList
            Top = 104
          end
        end
      end
    end
    object Panel6: TPanel
      Left = 790
      Top = 1
      Width = 8
      Height = 527
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 64
    object File1: TMenuItem
      Caption = '&File'
      object A1: TMenuItem
        Caption = 'Ne&w Template'
        OnClick = btnNewTemplateClick
      end
      object Delete2: TMenuItem
        Caption = '&Delete'
        OnClick = btnDeleteClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = btnSaveTemplateClick
      end
      object Close1: TMenuItem
        Caption = 'E&xit'
        OnClick = btnCloseClick
      end
    end
    object Vitals1: TMenuItem
      Caption = '&Vitals'
      object Add1: TMenuItem
        Action = fraGMV_EditTemplate1.acAdd
      end
      object Delete1: TMenuItem
        Action = fraGMV_EditTemplate1.acDelete
      end
      object Down1: TMenuItem
        Action = fraGMV_EditTemplate1.acDown
      end
      object Up1: TMenuItem
        Action = fraGMV_EditTemplate1.acUp
      end
    end
  end
end
