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
  Menu = MainMenu
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
    ExplicitTop = 411
    ExplicitWidth = 622
    object RzStatusPaneCopyright: TRzStatusPane
      Left = 0
      Top = 0
      Width = 522
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
      ExplicitWidth = 524
    end
    object RzStatusPaneVersion: TRzVersionInfoStatus
      Left = 522
      Top = 0
      Width = 82
      Height = 22
      BorderWidth = 0
      Align = alRight
      FieldLabel = 'V'
      FieldLabelColor = clBtnText
      AutoSize = True
      Field = vifFileVersion
      VersionInfo = RzVersionInfo
      ExplicitLeft = 519
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
  object RzPanelRoot: TRzPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 36
    Align = alTop
    BorderOuter = fsNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 1
    ExplicitTop = 29
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
  object RzPanelSource: TRzPanel
    Left = 0
    Top = 36
    Width = 624
    Height = 347
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 2
    ExplicitTop = 65
    ExplicitWidth = 622
    ExplicitHeight = 346
    DesignSize = (
      624
      347)
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
      Height = 310
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
      ExplicitHeight = 309
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
  object RzDialogButtonsMain: TRzDialogButtons
    Left = 0
    Top = 383
    Width = 624
    CaptionOk = 'Start Copy'
    CaptionCancel = 'Close'
    EnableOk = False
    WidthOk = 100
    OnClickOk = RzDialogButtonsMainClickOk
    OnClickCancel = RzDialogButtonsMainClickCancel
    TabOrder = 3
    ExplicitLeft = 232
    ExplicitTop = 232
    ExplicitWidth = 185
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
  object MainMenu: TMainMenu
    Left = 312
    Top = 280
    object menuFile: TMenuItem
      Caption = '&File'
      object menuNew: TMenuItem
        Caption = '&New'
        ShortCut = 16462
      end
      object menuOpen: TMenuItem
        Caption = '&Open'
        ShortCut = 16463
      end
      object menuSave: TMenuItem
        Caption = '&Save'
        ShortCut = 16467
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object menuSettings: TMenuItem
        Caption = 'Se&ttings'
        OnClick = menuSettingsClick
      end
      object Open2: TMenuItem
        Caption = '-'
      end
      object menuExit: TMenuItem
        Caption = 'E&xit'
        ShortCut = 16499
        OnClick = btnCloseClick
      end
    end
    object menuHelp: TMenuItem
      Caption = '&Help'
      object menuAbout: TMenuItem
        Caption = '&About'
        OnClick = menuAboutClick
      end
      object menuDocumentation: TMenuItem
        Caption = '&Documentation'
        ShortCut = 112
        OnClick = menuDocumentationClick
      end
    end
  end
end
