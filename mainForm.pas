unit mainForm;

interface

uses
  startForm, globals, processingForm, settingsForm, utils,

  JvExStdCtrls, JvCombobox, JvDriveCtrls, jclSysInfo,

  RzPanel, RzDlgBtn, RzEdit, RzBtnEdt, RzLabel, RzCommon, RzForms,
  RzStatus, RzLaunch, RzShellDialogs, RzButton, RzLstBox, RzFilSys,

  ShellAPI,

  System.SysUtils, System.Variants, System.Classes, System.Actions,
  System.ImageList, System.IOUtils,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ActnList, Vcl.Graphics, Vcl.ImgList, Vcl.FileCtrl,

  Winapi.Windows, Winapi.Messages, Vcl.Menus;

type
  TfrmMain = class(TForm)
    StatusBar: TRzStatusBar;
    RzFormState: TRzFormState;
    RzRegIniFile: TRzRegIniFile;
    RzVersionInfo: TRzVersionInfo;
    RzPanel2: TRzPanel;
    labelRootDirectory: TLabel;
    RzSelectFolderDialog: TRzSelectFolderDialog;
    ActionList: TActionList;
    ActionSourceItemSelectionChange: TAction;
    RzToolbar: TRzToolbar;
    btnStart: TRzToolButton;
    ImageList: TImageList;
    RzSpacer1: TRzSpacer;
    btnSettings: TRzToolButton;
    RzSpacer2: TRzSpacer;
    btnClose: TRzToolButton;
    RzPanel3: TRzPanel;
    labelSourceDirectories: TLabel;
    listSourceDirectories: TRzListBox;
    btnAddSourceDirectory: TRzButton;
    btnRemoveSourceDirectory: TRzButton;
    btnClearSourceDirectories: TRzButton;
    RzStatusPaneCopyright: TRzStatusPane;
    RzStatusPaneVersion: TRzVersionInfoStatus;
    RzStatusPaneSpacer: TRzStatusPane;
    editRootDirectory: TRzButtonEdit;
    RzSpacer3: TRzSpacer;
    btnHelp: TRzToolButton;
    RzLauncherMain: TRzLauncher;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    File2: TMenuItem;
    Open1: TMenuItem;
    Open2: TMenuItem;
    Exit1: TMenuItem;
    Settings1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    Documentation1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReadConfiguration;
    procedure SaveConfiguration;
    procedure btnAddSourceDirectoryClick(Sender: TObject);
    procedure btnRemoveSourceDirectoryClick(Sender: TObject);
    procedure ActionSourceItemSelectionChangeExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnClearSourceDirectoriesClick(Sender: TObject);
    procedure UpdateSourceFolderCaption;
    procedure btnStartClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure editRootDirectoryButtonClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure editRootDirectoryChange(Sender: TObject);
    procedure setButtonState;
    procedure RzStatusPaneCopyrightClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  end;

var
  frmMain: TfrmMain;

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

procedure TfrmMain.ReadConfiguration;
var
  tmpStr: string;
  theStrings: TStringList;
begin
  editRootDirectory.text := ReadRegistryString(HKEY_CURRENT_USER,
    AppRegistryKey, keyRootDirectory);

  theStrings := TStringList.Create;
  tmpStr := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keySourceDirectories);
  if Length(tmpStr) > 0 then begin
    Split(';', tmpStr, theStrings);
    listSourceDirectories.items.AddStrings(theStrings);
  end;
  theStrings.Free;
end;

procedure TfrmMain.RzStatusPaneCopyrightClick(Sender: TObject);
begin
  RzLauncherMain.FileName := FumblyURL;
  RzLauncherMain.Launch;
end;

procedure TfrmMain.SaveConfiguration;
begin
  SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyRootDirectory,
    editRootDirectory.text);
  SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keySourceDirectories,
    CreatePathStr(listSourceDirectories.items));
end;

procedure TfrmMain.setButtonState;
begin
  btnAddSourceDirectory.Enabled := Length(editRootDirectory.text) > 0;
  btnStart.Enabled := (Length(editRootDirectory.text) > 0) and
    (listSourceDirectories.items.count > 0);
end;

procedure TfrmMain.UpdateSourceFolderCaption;
begin
  labelSourceDirectories.Caption := Format('Source Folders (%d)',
    [listSourceDirectories.items.count]);
end;

procedure TfrmMain.ActionSourceItemSelectionChangeExecute(Sender: TObject);
begin
  btnRemoveSourceDirectory.Enabled := listSourceDirectories.ItemIndex > -1;
end;

procedure TfrmMain.btnAddSourceDirectoryClick(Sender: TObject);
var
  tmpPath: string;
begin
  RzSelectFolderDialog.SelectedPathName := editRootDirectory.text;
  if RzSelectFolderDialog.Execute then begin
    tmpPath := ExtractFileName(RzSelectFolderDialog.SelectedPathName);
    if listSourceDirectories.IndexOf(tmpPath) < 0 then begin
      listSourceDirectories.Add(tmpPath);
      UpdateSourceFolderCaption();
      setButtonState();
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
end;

procedure TfrmMain.btnRemoveSourceDirectoryClick(Sender: TObject);
begin
  listSourceDirectories.Delete(listSourceDirectories.ItemIndex);
  setButtonState();
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  startForm: TfrmStart;
  processingForm: TfrmProcessing;
begin
  SaveConfiguration();
  startForm := TfrmStart.Create(nil);
  startForm.ShowModal;
  if startForm.ModalResult = mrOk then begin
    processingForm := TfrmProcessing.Create(nil);
    processingForm.ShowModal;
    processingForm.Free;
  end;
  startForm.Free;
end;

procedure TfrmMain.editRootDirectoryButtonClick(Sender: TObject);
begin
  if RzSelectFolderDialog.Execute then begin
    editRootDirectory.text := RzSelectFolderDialog.SelectedPathName;
  end;
end;

procedure TfrmMain.editRootDirectoryChange(Sender: TObject);
begin
  setButtonState();
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
var
  settingsForm: TfrmSettings;
begin
  settingsForm := TfrmSettings.Create(nil);
  settingsForm.ShowModal;
  settingsForm.Free;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  SaveConfiguration();
  RzFormState.SaveState;
  Application.Terminate;
end;

procedure TfrmMain.btnHelpClick(Sender: TObject);
begin
  // launch the docs in the default browser
  RzLauncherMain.FileName := DocsURL;
  RzLauncherMain.Launch;
end;

procedure TfrmMain.WMDropFiles(var Msg: TWMDropFiles);
// supports dragged and dropped folders
var
  attrs: DWORD;
  i, NumFiles, FilenameLength: integer;
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
      rootPath := IncludeTrailingBackslash(editRootDirectory.text);
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
begin
  RzVersionInfo.filePath := Application.ExeName;
  RzRegIniFile.path := AppRegistryKey;
  ReadConfiguration();
  UpdateSourceFolderCaption();
  DragAcceptFiles(Handle, true);
end;

procedure TfrmMain.FormActivate(Sender: TObject);
var
  openSettings: Boolean;
  exePath: String;
begin
  setButtonState();

  // should we open the settings dialog?
  openSettings := false;
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
  openSettings := not Length(exePath) > 0;
  // is it a valid file path?
  openSettings := openSettings or not TPath.HasValidPathChars(exePath, false);
  // does the file exist?
  openSettings := openSettings or not FileExists(exePath, false);
  if openSettings then begin
    btnSettingsClick(Sender);
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
  SaveConfiguration();
end;

end.
