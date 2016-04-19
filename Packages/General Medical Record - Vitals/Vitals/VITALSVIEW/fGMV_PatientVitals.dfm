object frmVitals: TfrmVitals
  Left = 668
  Top = 372
  Width = 714
  Height = 547
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Patient Vitals'
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'Vitals.hlp'
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  inline TfraGMV_GridGraph1: TfraGMV_GridGraph
    Left = 0
    Top = 0
    Width = 706
    Height = 493
    Align = alClient
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    Visible = False
    inherited pnlMain: TPanel
      Width = 706
      Height = 493
      inherited pnlGridGraph: TPanel
        Top = 92
        Width = 706
        Height = 401
        inherited splGridGraph: TSplitter
          Top = 230
          Width = 706
          Height = 4
        end
        inherited pnlGraph: TPanel
          Width = 706
          Height = 230
          inherited pnlDateRange: TPanel
            Width = 119
            Height = 230
            inherited pnlGraphOptions: TPanel
              Top = 130
              Width = 119
              inherited pnlZoom: TPanel
                Width = 119
              end
            end
            inherited Panel5: TPanel
              Width = 119
              Height = 130
              inherited pnlPTop: TPanel
                Width = 119
              end
              inherited pnlPRight: TPanel
                Left = 116
                Height = 124
              end
              inherited pnlPLeft: TPanel
                Height = 124
              end
              inherited pnlPBot: TPanel
                Top = 127
                Width = 119
              end
              inherited pnlDateRangeTop: TPanel
                Width = 114
                Height = 124
                inherited lbDateRange: TListBox
                  Width = 114
                  Height = 99
                end
                inherited Panel6: TPanel
                  Width = 114
                end
              end
            end
          end
          inherited pnlGraphBackground: TPanel
            Left = 119
            Width = 587
            Height = 230
            inherited Bevel1: TBevel
              Width = 531
              Height = 230
            end
            inherited chrtVitals: TChart
              Width = 531
              Height = 230
            end
            inherited pnlRight: TPanel
              Left = 531
              Height = 230
            end
          end
        end
        inherited pnlGrid: TPanel
          Top = 234
          Width = 706
          Height = 167
          inherited grdVitals: TStringGrid
            Width = 698
            Height = 130
            Options = [goVertLine, goHorzLine]
          end
          inherited pnlGridTop: TPanel
            Width = 704
            inherited Panel4: TPanel
              Width = 585
              DesignSize = (
                585
                29)
              inherited trbHGraph: TTrackBar
                Width = 547
              end
            end
          end
          inherited pnlGBot: TPanel
            Top = 163
            Width = 704
            Height = 3
          end
          inherited pnlGTop: TPanel
            Width = 704
          end
          inherited pnlGLeft: TPanel
            Height = 130
          end
          inherited pnlGRight: TPanel
            Left = 702
            Width = 3
            Height = 130
          end
        end
      end
      inherited pnlTitle: TPanel
        Width = 706
        Height = 47
        inherited pnlPtInfo: TPanel
          Height = 47
          DesignSize = (
            233
            47)
          inherited Bevel2: TBevel
            Height = 47
          end
        end
        inherited Panel9: TPanel
          Width = 243
          Height = 47
          DesignSize = (
            243
            47)
          inherited Bevel3: TBevel
            Left = 234
            Height = 47
          end
          inherited pnlDateRangeInfo: TPanel
            Top = 27
            Width = 240
            Height = 20
            inherited Label11: TLabel
              Left = 6
              Top = -1
            end
            inherited lblDateFromTitle: TLabel
              Left = 82
              Top = -1
            end
          end
        end
        inherited pnlActions: TPanel
          Left = 476
          Width = 230
          Height = 47
          inherited sbtnAllergies: TSpeedButton
            Caption = 'Alle&rgies'
          end
        end
      end
      inherited pnlDebug: TPanel
        Top = 47
        Width = 706
        inherited sbTest: TStatusBar
          Width = 706
        end
      end
    end
    inherited ActionList1: TActionList
      inherited acEnterVitals: TAction
        OnExecute = TfraGMV_GridGraph1acEnterVitalsExecute
      end
      inherited acEnteredInError: TAction
        OnExecute = TfraGMV_GridGraph1acEnteredInErrorExecute
      end
      inherited acPatientAllergies: TAction
        OnExecute = TfraGMV_GridGraph1acPatientAllergiesExecute
      end
    end
    inherited PopupMenu1: TPopupMenu
      inherited SelectGraphColor1: TMenuItem
        Action = nil
        OnClick = TfraGMV_GridGraph1SelectGraphColor1Click
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 144
    object E1: TMenuItem
      Caption = '&File'
      object PatientInformation1: TMenuItem
        Action = TfraGMV_GridGraph1.acPatientInfo
      end
      object VitalsReport1: TMenuItem
        Action = TfraGMV_GridGraph1.acVitalsReport
      end
      object Grap1: TMenuItem
        Caption = 'Graph Report'
        ShortCut = 49234
        OnClick = Grap1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object EnteredinError1: TMenuItem
        Action = TfraGMV_GridGraph1.acEnteredInError
      end
      object EnterVitals1: TMenuItem
        Action = TfraGMV_GridGraph1.acEnterVitals
      end
      object Allergies1: TMenuItem
        Action = TfraGMV_GridGraph1.acPatientAllergies
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ShowHideGraphOptions1: TMenuItem
        Action = TfraGMV_GridGraph1.acGraphOptions
      end
      object SelectGraphColor1: TMenuItem
        Caption = 'Select Graph &Color...'
        Hint = 'Color Select'
        OnClick = SelectGraphColor1Click
      end
      object PrintGraph1: TMenuItem
        Action = TfraGMV_GridGraph1.acPrintGraph
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Index1: TMenuItem
        Caption = 'Quick Reference'
        OnClick = Index1Click
      end
      object VitalsWe1: TMenuItem
        Caption = 'Vitals Web Page'
        OnClick = VitalsWe1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
      object miShowRPCLog: TMenuItem
        Action = TfraGMV_GridGraph1.acRPCLog
      end
    end
  end
  object AppEv: TApplicationEvents
    OnHelp = AppEvHelp
    Left = 40
    Top = 64
  end
end
