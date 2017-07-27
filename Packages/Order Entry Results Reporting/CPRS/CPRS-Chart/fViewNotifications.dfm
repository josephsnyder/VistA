object frmViewNotifications: TfrmViewNotifications
  Left = 0
  Top = 0
  Caption = 'Patient Notifications'
  ClientHeight = 510
  ClientWidth = 944
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    944
    510)
  PixelsPerInch = 120
  TextHeight = 17
  object clvNotifications: TCaptionListView
    Left = 10
    Top = 10
    Width = 924
    Height = 443
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Info'
        Width = 63
      end
      item
        Caption = 'Location'
        Width = 63
      end
      item
        Caption = 'Urgency'
        Width = 63
      end
      item
        Caption = 'Alert Date/Time'
        Width = 63
      end
      item
        Caption = 'Message'
        Width = 63
      end
      item
        Caption = 'Forwarded By/When'
        Width = 63
      end
      item
        Alignment = taCenter
        Caption = 'Mine'
        Width = 63
      end>
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = clvNotificationsColumnClick
    OnDblClick = acProcessExecute
    AutoSize = False
    Caption = 'clvNotifications'
  end
  object btnDefer: TButton
    Left = 740
    Top = 469
    Width = 94
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Action = acDefer
    Anchors = [akRight, akBottom]
    TabOrder = 1
  end
  object btnProcess: TButton
    Left = 639
    Top = 469
    Width = 94
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Action = acProcess
    Anchors = [akRight, akBottom]
    TabOrder = 2
  end
  object btnClose: TButton
    Left = 840
    Top = 469
    Width = 94
    Height = 31
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Action = acClose
    Anchors = [akRight, akBottom]
    TabOrder = 3
  end
  object acList: TActionList
    OnUpdate = acListUpdate
    Left = 24
    Top = 48
    object acProcess: TAction
      Caption = '&Process'
      OnExecute = acProcessExecute
    end
    object acDefer: TAction
      Caption = '&Defer'
      OnExecute = acDeferExecute
    end
    object acClose: TAction
      Caption = '&Close'
      OnExecute = acCloseExecute
    end
    object acClearList: TAction
      Caption = 'acClearList'
      OnExecute = acClearListExecute
    end
    object acSortByColumn: TAction
      Caption = 'acSortByColumn'
      OnExecute = acSortByColumnExecute
    end
  end
end
