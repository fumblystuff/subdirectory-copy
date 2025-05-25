object frmStart: TfrmStart
  Left = 0
  Top = 0
  Caption = 'Copy Source Directories'
  ClientHeight = 191
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  TextHeight = 15
  object labelTargetDrive: TRzLabel
    Left = 68
    Top = 14
    Width = 63
    Height = 15
    Alignment = taRightJustify
    Caption = 'Target Drive'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelOperation: TLabel
    Left = 78
    Top = 54
    Width = 53
    Height = 15
    Alignment = taRightJustify
    Caption = 'Operation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object labelExistingFiles: TLabel
    Left = 10
    Top = 94
    Width = 121
    Height = 15
    Alignment = taRightJustify
    Caption = 'Existing File Processing'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object CopyDialogButtons: TRzDialogButtons
    Left = 0
    Top = 155
    Width = 376
    CaptionOk = '&Copy'
    OnClickOk = CopyDialogButtonsClickOk
    TabOrder = 0
    ExplicitTop = 147
    ExplicitWidth = 374
  end
  object TargetDrive: TJvDriveCombo
    Left = 140
    Top = 8
    Width = 225
    Height = 26
    DriveTypes = [dtUnknown, dtRemovable, dtRemote]
    Offset = 4
    ItemHeight = 20
    TabOrder = 1
  end
  object selectOperation: TRzComboBox
    Left = 140
    Top = 50
    Width = 225
    Height = 23
    TabOrder = 2
    Text = 'Copy'
    Items.Strings = (
      'Copy'
      'Move'
      'Test')
    ItemIndex = 0
    Values.Strings = (
      'Copy'
      'Move'
      'Test')
  end
  object comboOptions: TRzComboBox
    Left = 140
    Top = 90
    Width = 225
    Height = 23
    TabOrder = 3
    Text = 'Overwrite Older'
    Items.Strings = (
      'Skip All'
      'Overwrite All'
      'Overwrite Older'
      'Overwrite Different Size'
      'Rename Copied'
      'Rename Destination')
    ItemIndex = 2
    Values.Strings = (
      '/SkipAll'
      '/OverwriteAll'
      '/OverwriteOlder'
      '/OverwriteDiffSize'
      '/RenameCopied'
      '/RenameDestination')
  end
  object checkCloseTeraCopy: TCheckBox
    Left = 140
    Top = 125
    Width = 225
    Height = 17
    Caption = 'Close TeraCopy after operation'
    TabOrder = 4
  end
  object DriveTimer: TTimer
    Enabled = False
    OnTimer = DriveTimerTimer
    Left = 16
    Top = 32
  end
end
