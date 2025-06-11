object frmProcessing: TfrmProcessing
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  AutoScroll = True
  Caption = 'Copying...'
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object memoOutput: TRzMemo
    Left = 0
    Top = 0
    Width = 624
    Height = 405
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 622
    ExplicitHeight = 397
  end
  object ProcessingDialogButtons: TRzDialogButtons
    Left = 0
    Top = 405
    Width = 624
    CaptionCancel = '&Close'
    EnableOk = False
    EnableCancel = False
    EnableHelp = False
    ShowOKButton = False
    Color = 15987699
    TabOrder = 1
    ExplicitTop = 397
    ExplicitWidth = 622
  end
  object RzLauncher: TRzLauncher
    Action = 'Open'
    Timeout = -1
    WaitType = wtProcessMessages
    Left = 80
    Top = 72
  end
end
