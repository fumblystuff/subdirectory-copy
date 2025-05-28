object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Subdirectory Copy'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object StatusBar: TRzStatusBar
    Left = 0
    Top = 419
    Width = 624
    Height = 22
    AutoScalePanes = True
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    StyleElements = [seFont, seClient]
    TabOrder = 0
    object RzStatusPaneCopyright: TRzStatusPane
      Left = 0
      Top = 0
      Width = 521
      Height = 22
      BorderWidth = 0
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clDefault
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = RzStatusPaneCopyrightClick
      Caption = 'Copyright 2025 Fumbly Diddle Software'
      ExplicitLeft = 176
      ExplicitWidth = 448
      ExplicitHeight = 19
    end
    object RzStatusPaneVersion: TRzVersionInfoStatus
      Left = 521
      Top = 0
      Width = 83
      Height = 22
      BorderWidth = 0
      Align = alRight
      FieldLabel = 'V'
      FieldLabelColor = clBtnText
      AutoSize = True
      Field = vifFileVersion
      VersionInfo = RzVersionInfo
      ExplicitLeft = 504
      ExplicitHeight = 19
    end
    object RzStatusPaneSpacer: TRzStatusPane
      Left = 604
      Top = 0
      Width = 20
      Height = 22
      BorderWidth = 0
      Align = alRight
      Caption = ''
      ExplicitLeft = 524
      ExplicitHeight = 19
    end
  end
  object RzPanel2: TRzPanel
    Left = 0
    Top = 29
    Width = 624
    Height = 36
    Align = alTop
    BorderOuter = fsNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 1
    ExplicitWidth = 622
    DesignSize = (
      624
      36)
    object labelRootDirectory: TLabel
      Left = 10
      Top = 14
      Width = 76
      Height = 15
      Caption = 'Root Directory'
    end
    object editRootDirectory: TRzButtonEdit
      Left = 95
      Top = 10
      Width = 513
      Height = 23
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = editRootDirectoryChange
      AltBtnNumGlyphs = 1
      ButtonNumGlyphs = 1
      OnButtonClick = editRootDirectoryButtonClick
      ExplicitWidth = 511
    end
  end
  object RzToolbar: TRzToolbar
    Left = 0
    Top = 0
    Width = 624
    Height = 29
    Images = ImageList
    BorderInner = fsNone
    BorderOuter = fsGroove
    BorderSides = [sdTop]
    BorderWidth = 0
    Caption = 'Help'
    TabOrder = 2
    ExplicitWidth = 622
    ToolbarControls = (
      btnStart
      RzSpacer1
      btnSettings
      RzSpacer2
      btnHelp
      RzSpacer3
      btnClose)
    object btnStart: TRzToolButton
      Left = 4
      Top = 2
      Width = 50
      Images = ImageList
      ShowCaption = True
      UseToolbarButtonSize = False
      UseToolbarShowCaption = False
      Caption = '&Start'
      OnClick = btnStartClick
    end
    object RzSpacer1: TRzSpacer
      Left = 54
      Top = 2
    end
    object btnSettings: TRzToolButton
      Left = 62
      Top = 2
      Width = 50
      ShowCaption = True
      UseToolbarButtonSize = False
      UseToolbarShowCaption = False
      Caption = 'Se&ttings'
      ParentShowHint = False
      ShowHint = False
      OnClick = btnSettingsClick
    end
    object RzSpacer2: TRzSpacer
      Left = 112
      Top = 2
    end
    object btnClose: TRzToolButton
      Left = 165
      Top = 2
      Width = 50
      Images = ImageList
      ShowCaption = True
      UseToolbarButtonSize = False
      UseToolbarShowCaption = False
      Caption = '&Close'
      OnClick = btnCloseClick
    end
    object RzSpacer3: TRzSpacer
      Left = 157
      Top = 2
    end
    object btnHelp: TRzToolButton
      Left = 120
      Top = 2
      Width = 37
      ShowCaption = True
      UseToolbarShowCaption = False
      Caption = 'Help'
      OnClick = btnHelpClick
    end
  end
  object RzPanel3: TRzPanel
    Left = 0
    Top = 65
    Width = 624
    Height = 354
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 3
    ExplicitWidth = 622
    ExplicitHeight = 349
    DesignSize = (
      624
      354)
    object labelSourceDirectories: TLabel
      Left = 10
      Top = 10
      Width = 95
      Height = 15
      Caption = 'Source Directories'
    end
    object listSourceDirectories: TRzListBox
      Left = 13
      Top = 31
      Width = 516
      Height = 317
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = 2
      HorzScrollBar = True
      ItemHeight = 15
      Sorted = True
      TabOrder = 0
      OnClick = ActionSourceItemSelectionChangeExecute
      OnDblClick = btnRemoveSourceDirectoryClick
      OnEnter = ActionSourceItemSelectionChangeExecute
      OnExit = ActionSourceItemSelectionChangeExecute
      ExplicitWidth = 514
      ExplicitHeight = 312
    end
    object btnAddSourceDirectory: TRzButton
      Left = 535
      Top = 31
      Anchors = [akTop, akRight]
      Caption = 'Add'
      TabOrder = 1
      OnClick = btnAddSourceDirectoryClick
      ExplicitLeft = 533
    end
    object btnRemoveSourceDirectory: TRzButton
      Left = 535
      Top = 70
      Anchors = [akTop, akRight]
      Caption = 'Remove'
      Enabled = False
      TabOrder = 2
      OnClick = btnRemoveSourceDirectoryClick
      ExplicitLeft = 533
    end
    object btnClearSourceDirectories: TRzButton
      Left = 535
      Top = 110
      Anchors = [akTop, akRight]
      Caption = 'Clear'
      TabOrder = 3
      OnClick = btnClearSourceDirectoriesClick
      ExplicitLeft = 533
    end
  end
  object RzFormState: TRzFormState
    RegIniFile = RzRegIniFile
    Left = 264
    Top = 216
  end
  object RzRegIniFile: TRzRegIniFile
    PathType = ptRegistry
    Left = 176
    Top = 216
  end
  object RzVersionInfo: TRzVersionInfo
    Left = 80
    Top = 216
  end
  object RzSelectFolderDialog: TRzSelectFolderDialog
    FormPosition = poMainFormCenter
    Left = 80
    Top = 280
  end
  object ActionList: TActionList
    Left = 360
    Top = 216
    object ActionSourceItemSelectionChange: TAction
      Caption = 'ActionSourceItemSelectionChange'
      OnExecute = ActionSourceItemSelectionChangeExecute
    end
  end
  object ImageList: TImageList
    Left = 448
    Top = 216
  end
  object RzLauncherMain: TRzLauncher
    Action = 'Open'
    Timeout = -1
    Left = 200
    Top = 280
  end
end
