object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 430
  ClientWidth = 700
  Caption = 'MainForm'
  Color = clBtnFace
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 13
  inline UniFrame11: TUniFrame1
    Left = 352
    Top = 377
    Width = 166
    Height = 40
    Align = alNone
    Anchors = [akLeft, akTop]
    ShowHint = False
    Visible = True
    TabOrder = 0
    ParentFont = True
    ParentRTL = False
    RTL = False
    ExplicitLeft = 352
    ExplicitTop = 377
    inherited UniPanel1: TUniPanel
      ExplicitLeft = 72
      ExplicitTop = 32
      ExplicitWidth = 166
      ExplicitHeight = 40
      inherited btXLS: TUniBitBtn
        OnClick = nil
      end
      inherited btODS: TUniBitBtn
        OnClick = nil
      end
      inherited bt4PDF: TUniBitBtn
        OnClick = nil
      end
      inherited btCSV: TUniBitBtn
        OnClick = nil
      end
    end
  end
end
