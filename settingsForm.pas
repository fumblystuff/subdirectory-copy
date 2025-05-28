unit settingsForm;

interface

uses
  globals, utils,

  jclSysInfo,

  RzPanel, RzDlgBtn, RzEdit, RzBtnEdt, RzLabel,

  System.SysUtils, System.Variants, System.Classes, System.IOUtils,

  Winapi.Windows, Winapi.Messages,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Mask;

type
  TfrmSettings = class(TForm)
    SettingsDialogButtons: TRzDialogButtons;
    RzLabel1: TRzLabel;
    editExecutable: TRzButtonEdit;
    FileOpenDialog: TFileOpenDialog;
    procedure editExecutableButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SettingsDialogButtonsClickOk(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

procedure TfrmSettings.editExecutableButtonClick(Sender: TObject);
begin
  if FileOpenDialog.Execute then begin
    editExecutable.text := FileOpenDialog.fileName;
  end;
end;

procedure TfrmSettings.FormActivate(Sender: TObject);
var
  exePath: string;
begin
  // read the exe path from the registry
  exePath := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyExecutable, '');
  // do we have a value?
  if Length(exePath) > 0 then begin
    // does the path point to a file?
    if TPath.HasValidPathChars(exePath, false) and fileExists(exePath) then
    begin
      editExecutable.text := exePath;
    end;
  end else begin
    // see if we can use the default value
    if fileExists(globals.TeraCopyDefaultPath) then begin
      editExecutable.text := globals.TeraCopyDefaultPath;
      SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyExecutable,
        globals.TeraCopyDefaultPath);
    end;
  end;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  FileOpenDialog.DefaultFolder := GetProgramFilesFolder();
end;

procedure TfrmSettings.SettingsDialogButtonsClickOk(Sender: TObject);
begin
  SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyExecutable,
    editExecutable.text);
end;

end.
