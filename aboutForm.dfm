object frmAbout: TfrmAbout
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight]
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 171
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnActivate = FormActivate
  DesignSize = (
    332
    171)
  TextHeight = 15
  object LabelAboutApp: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 15
    Width = 315
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = 'Subdirectory Copy'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelAboutName: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 80
    Width = 313
    Height = 20
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'By John M. Wargo'
    ExplicitWidth = 315
  end
  object LabelAboutCopyright: TLabel
    AlignWithMargins = True
    Left = 9
    Top = 110
    Width = 313
    Height = 20
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Copyright 2025, Fumbly Diddle Software'
    Color = clBtnText
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnClick = LabelAboutCopyrightClick
    ExplicitWidth = 315
  end
  object LabelAboutVersion: TLabel
    Left = 10
    Top = 50
    Width = 313
    Height = 15
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'LabelAboutVersion'
    ExplicitWidth = 315
  end
  object RzDialogButtonsAbout: TRzDialogButtons
    Left = 0
    Top = 135
    Width = 332
    CaptionCancel = '&Close'
    ShowOKButton = False
    TabOrder = 0
    ExplicitTop = 127
    ExplicitWidth = 330
  end
  object RzLauncherAbout: TRzLauncher
    Action = 'Open'
    Timeout = -1
    Left = 232
    Top = 24
  end
end
