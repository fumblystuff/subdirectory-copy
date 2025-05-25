unit settingsForm;

interface

uses
  globals, utils,

  CodeSiteLogging,

  jclSysInfo,

  RzPanel, RzDlgBtn, RzEdit, RzBtnEdt, RzLabel,

  System.SysUtils, System.Variants, System.Classes,

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
begin
  editExecutable.text := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyExecutable);
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
