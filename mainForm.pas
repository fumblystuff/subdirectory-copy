unit mainForm;

interface

uses
  aboutForm, globals, processingForm, settingsForm, startForm, utils,

  // CodesiteLogging,

  JclFileUtils,

  JvExStdCtrls, JvCombobox, JvDriveCtrls, jclSysInfo, JvBaseDlg, JvWinDialogs,

  RzPanel, RzDlgBtn, RzEdit, RzBtnEdt, RzLabel, RzCommon, RzForms,
  RzStatus, RzLaunch, RzShellDialogs, RzButton, RzLstBox, RzFilSys,

  ShellAPI,

  System.SysUtils, System.Variants, System.Classes, System.Actions,
  System.ImageList, System.IOUtils, System.UITypes,

  Vcl.Controls, Vcl.Dialogs, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ActnList, Vcl.Graphics, Vcl.ImgList, Vcl.FileCtrl, Vcl.Menus,

  Winapi.Windows, Winapi.Messages;

type
  TfrmMain = class(TForm)
    ActionList: TActionList;
    ActionSourceItemSelectionChange: TAction;
    btnAddSourceDirectory: TRzButton;
    btnClearSourceDirectories: TRzButton;
    btnRemoveSourceDirectory: TRzButton;
    editRootPath: TRzButtonEdit;
    labelRootDirectory: TLabel;
    labelSourceDirectories: TLabel;
    listSourceDirectories: TRzListBox;
    MainMenu: TMainMenu;
    menuAbout: TMenuItem;
    menuDocumentation: TMenuItem;
    menuExit: TMenuItem;
    menuFile: TMenuItem;
    menuHelp: TMenuItem;
    menuNew: TMenuItem;
    menuOpen: TMenuItem;
    menuRecent: TMenuItem;
    menuSave: TMenuItem;
    menuSaveAs: TMenuItem;
    menuSettings: TMenuItem;
    RzDialogButtonsMain: TRzDialogButtons;
    RzFormState: TRzFormState;
    RzIniProject: TRzRegIniFile;
    RzLauncherMain: TRzLauncher;
    RzPanelRoot: TRzPanel;
    RzPanelSource: TRzPanel;
    RzSaveDialog: TRzSaveDialog;
    RzSelectFolderDialog: TRzSelectFolderDialog;
    RzStatusPaneCopyright: TRzStatusPane;
    RzStatusPaneSpacer: TRzStatusPane;
    RzStatusPaneVersion: TRzVersionInfoStatus;
    RzVersionInfo: TRzVersionInfo;
    StatusBar: TRzStatusBar;
    RzOpenDialog: TRzOpenDialog;
    RzRegApp: TRzRegIniFile;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddSourceDirectoryClick(Sender: TObject);
    procedure btnRemoveSourceDirectoryClick(Sender: TObject);
    procedure ActionSourceItemSelectionChangeExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnClearSourceDirectoriesClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure editRootPathButtonClick(Sender: TObject);
    procedure editRootPathChange(Sender: TObject);
    procedure RzStatusPaneCopyrightClick(Sender: TObject);
    procedure menuSettingsClick(Sender: TObject);
    procedure menuDocumentationClick(Sender: TObject);
    procedure RzDialogButtonsMainClickCancel(Sender: TObject);
    procedure RzDialogButtonsMainClickOk(Sender: TObject);
    procedure menuAboutClick(Sender: TObject);
    procedure menuNewClick(Sender: TObject);
    procedure menuOpenClick(Sender: TObject);
    procedure menuSaveClick(Sender: TObject);
    procedure menuSaveAsClick(Sender: TObject);
    procedure SetSourceFolderCaption;
    procedure OpenSettingsDialog;
    procedure PromptSaveProject;
    procedure OpenProject;
    procedure AddRecentProject(ProjectPath: String);
    procedure RemoveRecentProject(ProjectPath: String);
    procedure UpdateRecentProjectsMenu;
    procedure CheckOpenSettings;
    procedure DeleteTemporaryFile;
    procedure setButtonState;
    procedure SetFormCaption;
  private
    procedure SaveProject;
    procedure RecentProjectClick(Sender: TObject);
  public
  protected
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  end;

var
  frmMain: TfrmMain;
  MenuItems: array [0 .. 5] of TMenuItem;
  RecentProjects: TStringList;
  ProjectChanged: Boolean;
  ProjectPath, TemporaryFilePath: string;

implementation

{$R *.dfm}

function CreatePathStr(pathList: TStrings): string;
// convert path array to string
var
  theItem, resultStr: string;
begin
  resultStr := '';
  for theItem in pathList do begin
    resultStr := resultStr + theItem + ';'
  end;
  Result := Copy(resultStr, 1, Length(resultStr) - 1);
end;

procedure TfrmMain.CheckOpenSettings;
var
  OpenSettings: Boolean;
  exePath: String;
begin
  // should we open the settings dialog?
  exePath := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyExecutable, '');
  // do we have an executable path?
  if exePath.IsEmpty then begin
    // No? Can we use the default?
    if FileExists(globals.TeraCopyDefaultPath) then begin
      // Yes!
      exePath := globals.TeraCopyDefaultPath;
      SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
        keyExecutable, exePath);
      Exit;
    end;
  end;
  // do we have an exePath value?
  OpenSettings := not Length(exePath) > 0;
  // is it a valid file path?
  OpenSettings := OpenSettings or not TPath.HasValidPathChars(exePath, False);
  // does the file exist?
  OpenSettings := OpenSettings or not FileExists(exePath, False);
  if OpenSettings then begin
    OpenSettingsDialog;
  end;
end;

procedure TfrmMain.DeleteTemporaryFile;
begin
  // get rid of the temporary file if it exists
  If FileExists(TemporaryFilePath) then begin
    System.SysUtils.DeleteFile(TemporaryFilePath);
  end;
end;

procedure TfrmMain.AddRecentProject(ProjectPath: String);
var
  itemIdx: Integer;
begin
  itemIdx := RecentProjects.IndexOf(ProjectPath);
  if itemIdx > -1 then begin
    // the item is in the list
    if itemIdx < 1 then begin
      // its the first item, so we're good here
      Exit;
    end;
    // it's not the first item, so delete it where it is
    RecentProjects.Delete(itemIdx);
  end;
  // insert the project in the list (at the beginning)
  RecentProjects.Insert(0, ProjectPath);
  if RecentProjects.Count > 5 then begin
    RecentProjects.Delete(5);
  end;
  // Write the recent project list to the registry
  SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyRecentProjects,
    CreatePathStr(RecentProjects));
  UpdateRecentProjectsMenu;
end;

procedure TfrmMain.UpdateRecentProjectsMenu;
var
  idx: Integer;
begin
  menuRecent.Clear;
  menuRecent.Enabled := RecentProjects.Count > 0;
  For idx := 0 to RecentProjects.Count - 1 do begin
    MenuItems[idx] := TMenuItem.Create(Self);
    MenuItems[idx].Caption := RecentProjects.strings[idx];
    MenuItems[idx].OnClick := RecentProjectClick;
    menuRecent.Add(MenuItems[idx]);
  end;
end;

procedure TfrmMain.RecentProjectClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  tmpPath: String;
begin
  MenuItem := Sender as TMenuItem;
  // Had to do this this way because Delphi/Windows automatically adds a
  // shortcut character (&) in the caption.
  tmpPath := RecentProjects[MenuItem.MenuIndex];

  // Are we changing anything?
  if ProjectPath = tmpPath then begin
    // Nothing to do here, no project change
    Exit;
  end;

  // Offer to save the current project if it's changed
  PromptSaveProject;

  if FileExists(tmpPath) then begin
    ProjectPath := tmpPath;
    OpenProject;
  end else begin
    MessageDialogCentered(Format('Selected Project does not exist (%s)',
      [tmpPath]));
    RemoveRecentProject(tmpPath);
  end;
end;

procedure TfrmMain.RemoveRecentProject(ProjectPath: String);
var
  idx: Integer;
begin
  idx := RecentProjects.IndexOf(ProjectPath);
  if idx > -1 then begin
    RecentProjects.Delete(idx);
  end;
end;

procedure TfrmMain.OpenProject;
var
  idx, tmpIdx: Integer;
  strings: TStringList;
  folderName, tmpStr: String;
begin
  if FileExists(ProjectPath) then begin
    SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyProjectPath,
      ProjectPath);
    AddRecentProject(ProjectPath);
    // clear the UI
    editRootPath.Clear;
    listSourceDirectories.Clear;
    // write the changes to the file
    RzIniProject.path := ProjectPath;
    // Root directory
    editRootPath.text := RzIniProject.ReadString(keyRoot, keyRootDirectory, '');
    // Source Directories
    strings := TStringList.Create();
    RzIniProject.ReadSectionValues(keySource, strings);
    if strings.Count > 0 then begin
      for idx := 0 to strings.Count - 1 do begin
        tmpStr := strings[idx];
        tmpIdx := tmpStr.IndexOf('=');
        if tmpIdx > -1 then begin
          folderName := Copy(tmpStr, tmpIdx + 2, 99);
          listSourceDirectories.Add(folderName);
        end else begin
          MessageDialogCentered(Format('Invalid Source Directory: "%s"',
            [tmpStr]));
        end;
      end;
    end;
    SetFormCaption;
    setButtonState;
    SetSourceFolderCaption;
    ProjectChanged := False;
  end;
end;

procedure TfrmMain.SaveProject;
var
  idx: Integer;
begin
  if ProjectPath.IsEmpty then begin
    if RzSaveDialog.Execute then begin
      ProjectPath := RzSaveDialog.FileName;
    end else begin
      Exit;
    end;
  end;

  RzIniProject.path := ProjectPath;
  // Root directory
  RzIniProject.WriteString(keyRoot, keyRootDirectory, editRootPath.text);
  // Source Directories
  for idx := 0 to listSourceDirectories.Count - 1 do begin
    RzIniProject.WriteString(keySource, 'source' + IntToStr(idx),
      listSourceDirectories.items[idx]);
  end;
  ProjectChanged := False;
end;

procedure TfrmMain.PromptSaveProject;
var
  tmpMsg: String;
begin
  if ProjectChanged then begin
    if Length(ProjectPath) > 0 then begin
      tmpMsg := Format('Save changes to the "%s" project?',
        [TPath.GetFileNameWithoutExtension(ProjectPath)]);
    end else begin
      tmpMsg := 'Save changes to the project?';
    end;
    if MessageConfirmationCentered('Confirmation', tmpMsg) then begin
      SaveProject;
    end;
  end;
end;

procedure TfrmMain.OpenSettingsDialog;
var
  settingsForm: TfrmSettings;
begin
  settingsForm := TfrmSettings.Create(nil);
  settingsForm.ShowModal;
  settingsForm.Free;
end;

procedure TfrmMain.RzDialogButtonsMainClickCancel(Sender: TObject);
begin
  PromptSaveProject;
  DeleteTemporaryFile;
  RzFormState.SaveState;
  Application.Terminate;
end;

procedure TfrmMain.RzDialogButtonsMainClickOk(Sender: TObject);
var
  startForm: TfrmStart;
  processingForm: TfrmProcessing;
  i: Integer;
begin
  PromptSaveProject;
  startForm := TfrmStart.Create(nil);
  startForm.ShowModal;
  if startForm.ModalResult = mrOk then begin
    processingForm := TfrmProcessing.Create(nil);
    // Assign root folder
    processingForm.RootPath := editRootPath.text;
    // Assign subdirectory list
    for i := 0 to listSourceDirectories.items.Count - 1 do begin
      processingForm.SourceSubdirectoryList.Add
        (listSourceDirectories.items.strings[i])
    end;
    processingForm.TemporaryFilePath := TemporaryFilePath;
    processingForm.ShowModal;
    processingForm.Free;
  end;
  startForm.Free;
end;

procedure TfrmMain.RzStatusPaneCopyrightClick(Sender: TObject);
begin
  RzLauncherMain.FileName := FumblyURL;
  RzLauncherMain.Launch;
end;

procedure TfrmMain.setButtonState;
begin
  btnAddSourceDirectory.Enabled := Length(editRootPath.text) > 0;
  RzDialogButtonsMain.EnableOk := (Length(editRootPath.text) > 0) and
    (listSourceDirectories.items.Count > 0);
end;

procedure TfrmMain.SetFormCaption;
begin
  // Put the project name in the form caption
  frmMain.Caption := Format('%s: %s',
    [ApplicationName, TPath.GetFileNameWithoutExtension(ProjectPath)]);
end;

procedure TfrmMain.SetSourceFolderCaption;
begin
  labelSourceDirectories.Caption := Format('Source Folders (%d)',
    [listSourceDirectories.items.Count]);
end;

procedure TfrmMain.ActionSourceItemSelectionChangeExecute(Sender: TObject);
begin
  btnRemoveSourceDirectory.Enabled := listSourceDirectories.ItemIndex > -1;
end;

procedure TfrmMain.btnAddSourceDirectoryClick(Sender: TObject);
var
  tmpPath: string;
begin
  RzSelectFolderDialog.Title := 'Select Source directory';
  RzSelectFolderDialog.SelectedPathName := editRootPath.text;
  if RzSelectFolderDialog.Execute then begin
    tmpPath := ExtractFileName(RzSelectFolderDialog.SelectedPathName);
    if listSourceDirectories.IndexOf(tmpPath) < 0 then begin
      listSourceDirectories.Add(tmpPath);
      SetSourceFolderCaption;
      setButtonState;
      ProjectChanged := True;
    end else begin
      MessageDialogCentered('Item already exists');
    end;
  end;
end;

procedure TfrmMain.btnClearSourceDirectoriesClick(Sender: TObject);
begin
  listSourceDirectories.Clear;
  SetSourceFolderCaption;
  setButtonState;
  ProjectChanged := True;
end;

procedure TfrmMain.btnRemoveSourceDirectoryClick(Sender: TObject);
begin
  listSourceDirectories.Delete(listSourceDirectories.ItemIndex);
  setButtonState;
  ProjectChanged := True;
end;

procedure TfrmMain.editRootPathButtonClick(Sender: TObject);
begin
  RzSelectFolderDialog.Title := 'Select Root directory';
  if RzSelectFolderDialog.Execute then begin
    editRootPath.text := RzSelectFolderDialog.SelectedPathName;
    ProjectChanged := True;
  end;
end;

procedure TfrmMain.editRootPathChange(Sender: TObject);
begin
  setButtonState;
  ProjectChanged := True;
end;


// =============================================================
// Menu routinees
// =============================================================

procedure TfrmMain.menuSaveAsClick(Sender: TObject);
// Save the configuration to a new project
begin
  // Prompt for the new project file
  if RzSaveDialog.Execute then begin
    ProjectPath := RzSaveDialog.FileName;
    SaveProject;
    SetFormCaption;
    AddRecentProject(ProjectPath);
  end;
end;

procedure TfrmMain.menuSaveClick(Sender: TObject);
begin
  SaveProject;
end;

procedure TfrmMain.menuNewClick(Sender: TObject);
begin
  editRootPath.Clear;
  listSourceDirectories.Clear;
  ProjectPath := '';
  ProjectChanged := False;
end;

procedure TfrmMain.menuOpenClick(Sender: TObject);
begin
  PromptSaveProject;
  if RzOpenDialog.Execute then begin
    ProjectPath := RzOpenDialog.FileName;
    OpenProject;
  end;
end;

procedure TfrmMain.menuAboutClick(Sender: TObject);
var
  aboutForm: TfrmAbout;
begin
  aboutForm := TfrmAbout.Create(frmMain);
  aboutForm.FileVersionString := Format('Version %s',
    [RzVersionInfo.FileVersion]);
  aboutForm.ShowModal;
  aboutForm.Free;
end;

procedure TfrmMain.menuDocumentationClick(Sender: TObject);
begin
  RzLauncherMain.FileName := DocsURL;
  RzLauncherMain.Launch;
end;

procedure TfrmMain.menuSettingsClick(Sender: TObject);
begin
  OpenSettingsDialog;
end;

// =============================================================
// Toolbar button routines
// =============================================================

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  startForm: TfrmStart;
  processingForm: TfrmProcessing;
begin
  PromptSaveProject;

  startForm := TfrmStart.Create(nil);
  startForm.ShowModal;
  if startForm.ModalResult = mrOk then begin
    processingForm := TfrmProcessing.Create(nil);
    processingForm.ShowModal;
    processingForm.Free;
  end;
  startForm.Free;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  PromptSaveProject;
  RzFormState.SaveState;
  Application.Terminate;
end;

// =============================================================
// Drag and Drop
// =============================================================

procedure TfrmMain.WMDropFiles(var Msg: TWMDropFiles);
// supports dragged and dropped folders
var
  attrs: DWORD;
  i, NumFiles, FilenameLength: Integer;
  filePath, s, RootPath, tmpPath: string;
begin
  if Length(editRootPath.text) < 1 then begin
    MessageDialogCentered
      ('Please select a Root Directory before drqgging folder onto the application');
    Exit;
  end;

  frmMain.Cursor := crHourglass;
  NumFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
  for i := 0 to NumFiles - 1 do begin
    FilenameLength := DragQueryFile(Msg.Drop, i, nil, 0) + 1;
    SetLength(s, FilenameLength);
    DragQueryFile(Msg.Drop, i, PChar(s), FilenameLength);
    // is it a directory?
    attrs := GetFileAttributes(PChar(s));
    if attrs = INVALID_FILE_ATTRIBUTES then begin
      MessageDialogCentered('Invalid file attributes');
      Exit;
    end else if (attrs and FILE_ATTRIBUTE_DIRECTORY) <> 0 then begin
      RootPath := IncludeTrailingBackslash(editRootPath.text);
      filePath := ExtractFilePath(s);
      if RootPath = filePath then begin
        tmpPath := ExtractFileName(s);
        if listSourceDirectories.IndexOf(tmpPath) < 0 then begin
          listSourceDirectories.Add(ExtractFileName(tmpPath));
        end;
      end else begin
        MessageDialogCentered('Dropped folder(s) do not match Root Directory');
        Exit;
      end;
    end;
  end;
  DragFinish(Msg.Drop);
  SetSourceFolderCaption;
  setButtonState;
  frmMain.Cursor := crDefault;
end;

// =============================================================
// Form Lifecycle events
// =============================================================

procedure TfrmMain.FormCreate(Sender: TObject);
var
  tmpPath, tmpStr: String;
begin

  // Codesite.Clear;

  DragAcceptFiles(Handle, True);
  frmMain.Caption := ApplicationName;
  RzRegApp.path := AppRegistryKey;
  RzVersionInfo.filePath := Application.ExeName;
  RzOpenDialog.InitialDir := TPath.GetDocumentsPath;
  RzSaveDialog.InitialDir := TPath.GetDocumentsPath;
  ProjectPath := '';
  TemporaryFilePath := FileGetTempName('scp');

  // Populate the Recent Projects submenu
  RecentProjects := TStringList.Create();
  tmpStr := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyRecentProjects, '');
  if Length(tmpStr) > 0 then begin
    Split(';', tmpStr, RecentProjects);
  end;
  UpdateRecentProjectsMenu;

  tmpPath := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyProjectPath, '');
  if not tmpPath.IsEmpty then begin
    if FileExists(tmpPath) then begin
      ProjectPath := tmpPath;
      OpenProject;
    end;
  end;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  setButtonState;
  CheckOpenSettings;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  // Adjust the number of source folder columns based on the
  // width of the listbox
  listSourceDirectories.Columns := listSourceDirectories.Width div 250;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PromptSaveProject;
  DeleteTemporaryFile;
  RecentProjects.Free;
end;

end.
