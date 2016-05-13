inherited frmDupPro: TfrmDupPro
  Left = 160
  Top = 190
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Similar Providers'
  ClientHeight = 187
  ClientWidth = 463
  Position = poScreenCenter
  OnActivate = FormActivate
  ExplicitWidth = 479
  ExplicitHeight = 225
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDupPros: TPanel [0]
    Left = 0
    Top = 0
    Width = 463
    Height = 187
    Align = alClient
    TabOrder = 0
    DesignSize = (
      463
      187)
    object lblSelDupPros: TLabel
      Left = 1
      Top = 1
      Width = 461
      Height = 13
      Align = alTop
      Caption = 'Please select the correct provider:'
      ExplicitWidth = 161
    end
    object pnlSelDupPro: TPanel
      Left = 2
      Top = 19
      Width = 461
      Height = 120
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      object lboSelPro: TCaptionListView
        Left = 1
        Top = 1
        Width = 459
        Height = 118
        Margins.Left = 8
        Margins.Right = 8
        Align = alClient
        Columns = <
          item
            Caption = 'Name'
            Width = 454
          end>
        HideSelection = False
        HoverTime = 0
        IconOptions.WrapText = False
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowWorkAreas = True
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = lboSelProDblClick
        AutoSize = False
        Caption = 'Please select the correct patient'
        Pieces = '2'
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 137
      Width = 461
      Height = 49
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        461
        49)
      object btnOK: TButton
        Left = 292
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&OK'
        Default = True
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 373
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 40
    Data = (
      (
        'Component = pnlDupPros'
        'Status = stsDefault')
      (
        'Component = pnlSelDupPro'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = lboSelPro'
        'Status = stsDefault')
      (
        'Component = frmDupPro'
        'Status = stsDefault'))
  end
end
