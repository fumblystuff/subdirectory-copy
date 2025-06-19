object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  Caption = 'Settings'
  ClientHeight = 111
  ClientWidth = 464
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  DesignSize = (
    464
    111)
  TextHeight = 15
  object RzLabel1: TRzLabel
    Left = 10
    Top = 10
    Width = 109
    Height = 15
    Caption = 'TeraCopy Executable'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object SettingsDialogButtons: TRzDialogButtons
    Left = 0
    Top = 75
    Width = 464
    OnClickOk = SettingsDialogButtonsClickOk
    Color = 15987699
    TabOrder = 0
    ExplicitTop = 67
    ExplicitWidth = 462
  end
  object editExecutable: TRzButtonEdit
    Left = 8
    Top = 31
    Width = 440
    Height = 23
    Text = ''
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    AltBtnNumGlyphs = 1
    ButtonNumGlyphs = 1
    OnButtonClick = editExecutableButtonClick
  end
  object FileOpenDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Executables'
        FileMask = '*.exe'
      end>
    OkButtonLabel = 'Select'
    Options = [fdoPathMustExist, fdoFileMustExist]
    Title = 'Select Teracopy Executable'
    Left = 176
    Top = 32
  end
end
