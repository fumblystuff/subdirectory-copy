unit mainForm;

interface

uses
  aboutForm, globals, processingForm, settingsForm, startForm, utils,

  CodesiteLogging,

  JvExStdCtrls, JvCombobox, JvDriveCtrls, jclSysInfo,

  RzPanel, RzDlgBtn, RzEdit, RzBtnEdt, RzLabel, RzCommon, RzForms,
  RzStatus, RzLaunch, RzShellDialogs, RzButton, RzLstBox, RzFilSys,

  ShellAPI,

  System.SysUtils, System.Variants, System.Classes, System.Actions,
  System.ImageList, System.IOUtils,

  Vcl.Controls, Vcl.Dialogs, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ActnList, Vcl.Graphics, Vcl.ImgList, Vcl.FileCtrl,

  Winapi.Windows, Winapi.Messages, Vcl.Menus, JvBaseDlg, JvWinDialogs;

type
  TfrmMain = class(TForm)
    StatusBar: TRzStatusBar;
    RzFormState: TRzFormState;
    RzRegApp: TRzRegIniFile;
    RzVersionInfo: TRzVersionInfo;
    RzPanelRoot: TRzPanel;
    labelRootDirectory: TLabel;
    RzSelectFolderDialog: TRzSelectFolderDialog;
    ActionList: TActionList;
    ActionSourceItemSelectionChange: TAction;
    RzPanelSource: TRzPanel;
    labelSourceDirectories: TLabel;
    listSourceDirectories: TRzListBox;
    btnAddSourceDirectory: TRzButton;
    btnRemoveSourceDirectory: TRzButton;
    btnClearSourceDirectories: TRzButton;
    RzStatusPaneCopyright: TRzStatusPane;
    RzStatusPaneVersion: TRzVersionInfoStatus;
    RzStatusPaneSpacer: TRzStatusPane;
    editRootDirectory: TRzButtonEdit;
    RzLauncherMain: TRzLauncher;
    MainMenu: TMainMenu;
    menuFile: TMenuItem;
    menuNew: TMenuItem;
    menuOpen: TMenuItem;
    Open2: TMenuItem;
    menuExit: TMenuItem;
    menuSettings: TMenuItem;
    menuSave: TMenuItem;
    N1: TMenuItem;
    menuHelp: TMenuItem;
    menuAbout: TMenuItem;
    menuDocumentation: TMenuItem;
    RzDialogButtonsMain: TRzDialogButtons;
    menuSaveAs: TMenuItem;
    RzIniProject: TRzRegIniFile;
    FileOpenDialog: TFileOpenDialog;
    menuReopen: TMenuItem;
    RzSaveDialog: TRzSaveDialog;
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
    procedure editRootDirectoryButtonClick(Sender: TObject);
    procedure editRootDirectoryChange(Sender: TObject);
    procedure setButtonState;
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
    procedure UpdateSourceFolderCaption;
    procedure OpenSettingsDialog;
    procedure PromptSaveProject;
    procedure OpenProject;
  private
    procedure SaveProject;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  end;

var
  frmMain: TfrmMain;
  ProjectChanged: Boolean;
  ProjectPath: string;

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

procedure TfrmMain.OpenProject;
var
  idx, tmpIdx: Integer;
  strings: TStringList;
  folderName, tmpStr: String;
begin
  if FileExists(ProjectPath) then begin
    // write the changes to the file
    RzIniProject.path := ProjectPath;
    // Root directory
    editRootDirectory.Text := RzIniProject.ReadString(keyRoot, keyRootDirectory,
      editRootDirectory.Text);
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
  RzIniProject.WriteString(keyRoot, keyRootDirectory, editRootDirectory.Text);
  // Source Directories
  for idx := 0 to listSourceDirectories.Count - 1 do begin
    RzIniProject.WriteString(keySource, 'source' + IntToStr(idx),
      listSourceDirectories.items[idx]);
  end;
  ProjectChanged := False;
end;

procedure TfrmMain.PromptSaveProject;
begin
  if ProjectChanged then begin
    if MessageConfirmationCentered('Confirmation',
      'Save changes to the project?') then begin
      SaveProject();
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
  PromptSaveProject();
  RzFormState.SaveState;
  Application.Terminate;
end;

procedure TfrmMain.RzDialogButtonsMainClickOk(Sender: TObject);
var
  startForm: TfrmStart;
  processingForm: TfrmProcessing;
begin
  PromptSaveProject();
  startForm := TfrmStart.Create(nil);
  startForm.ShowModal;
  if startForm.ModalResult = mrOk then begin
    processingForm := TfrmProcessing.Create(nil);
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
  btnAddSourceDirectory.Enabled := Length(editRootDirectory.Text) > 0;
  RzDialogButtonsMain.EnableOk := (Length(editRootDirectory.Text) > 0) and
    (listSourceDirectories.items.Count > 0);
end;

procedure TfrmMain.UpdateSourceFolderCaption;
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
  RzSelectFolderDialog.SelectedPathName := editRootDirectory.Text;
  if RzSelectFolderDialog.Execute then begin
    tmpPath := ExtractFileName(RzSelectFolderDialog.SelectedPathName);
    if listSourceDirectories.IndexOf(tmpPath) < 0 then begin
      listSourceDirectories.Add(tmpPath);
      UpdateSourceFolderCaption();
      setButtonState();
      ProjectChanged := True;
    end else begin
      MessageDialogCentered('Item already exists');
    end;
  end;
end;

procedure TfrmMain.btnClearSourceDirectoriesClick(Sender: TObject);
begin
  listSourceDirectories.Clear;
  UpdateSourceFolderCaption();
  setButtonState();
  ProjectChanged := True;
end;

procedure TfrmMain.btnRemoveSourceDirectoryClick(Sender: TObject);
begin
  listSourceDirectories.Delete(listSourceDirectories.ItemIndex);
  setButtonState();
  ProjectChanged := True;
end;

procedure TfrmMain.editRootDirectoryButtonClick(Sender: TObject);
begin
  if RzSelectFolderDialog.Execute then begin
    editRootDirectory.Text := RzSelectFolderDialog.SelectedPathName;
    ProjectChanged := True;
  end;
end;

procedure TfrmMain.editRootDirectoryChange(Sender: TObject);
begin
  setButtonState();
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
    SaveProject();
  end;
end;

procedure TfrmMain.menuSaveClick(Sender: TObject);
begin
  SaveProject();
end;

procedure TfrmMain.menuNewClick(Sender: TObject);
begin
  Codesite.Send('New');
  editRootDirectory.Clear;
  listSourceDirectories.Clear;
end;

procedure TfrmMain.menuOpenClick(Sender: TObject);
begin
  if FileOpenDialog.Execute then begin
    ProjectPath := FileOpenDialog.FileName;
    SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyProjectPath,
      ProjectPath);
    OpenProject();
  end;

  // TODO: Update the recent project list
  Codesite.Send('Update the recent project list');
end;

procedure TfrmMain.menuAboutClick(Sender: TObject);
var
  aboutForm: TfrmAbout;
begin
  aboutForm := TfrmAbout.Create(nil);
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
  OpenSettingsDialog();
end;

// =============================================================
// Toolbar button routines
// =============================================================

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  startForm: TfrmStart;
  processingForm: TfrmProcessing;
begin
  PromptSaveProject();

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
  PromptSaveProject();
  RzFormState.SaveState;
  Application.Terminate;
end;

procedure TfrmMain.WMDropFiles(var Msg: TWMDropFiles);
// supports dragged and dropped folders
var
  attrs: DWORD;
  i, NumFiles, FilenameLength: Integer;
  filePath, s, rootPath, tmpPath: string;
begin
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
      rootPath := IncludeTrailingBackslash(editRootDirectory.Text);
      filePath := ExtractFilePath(s);
      if rootPath = filePath then begin
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
  UpdateSourceFolderCaption();
  setButtonState();
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  tmpPath: String;
begin
  RzVersionInfo.filePath := Application.ExeName;
  RzRegApp.path := AppRegistryKey;
  DragAcceptFiles(Handle, True);
  ProjectPath := '';
  RzSaveDialog.InitialDir := TPath.GetDocumentsPath();

  tmpPath := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyProjectPath, '');
  if not tmpPath.IsEmpty() then begin
    if FileExists(tmpPath) then begin
      ProjectPath := tmpPath;
      OpenProject();
    end;
  end;
  UpdateSourceFolderCaption();

  // TODO: Populate the Recent Projects submenu
  Codesite.Send('Populate the Recent Projects menu');
end;

procedure TfrmMain.FormActivate(Sender: TObject);
var
  OpenSettings: Boolean;
  exePath: String;
begin
  setButtonState();
  // should we open the settings dialog?
  OpenSettings := False;
  exePath := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyExecutable, '');
  // do we have an executable path?
  if Length(exePath) < 1 then begin
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
    OpenSettingsDialog();
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  // Adjust the number of source folder columns based on the
  // width of the listbox
  listSourceDirectories.Columns := listSourceDirectories.Width div 250;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Codesite.Send('Close');
  PromptSaveProject();
end;

end.
