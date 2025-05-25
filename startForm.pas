unit startForm;

interface

uses
  globals, utils,

  JvExStdCtrls, JvCombobox, JvDriveCtrls,

  RzPanel, RzDlgBtn, RzLabel, RzCmboBx,

  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes, System.IOUtils,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TfrmStart = class(TForm)
    CopyDialogButtons: TRzDialogButtons;
    labelTargetDrive: TRzLabel;
    TargetDrive: TJvDriveCombo;
    selectOperation: TRzComboBox;
    labelOperation: TLabel;
    labelExistingFiles: TLabel;
    comboOptions: TRzComboBox;
    checkCloseTeraCopy: TCheckBox;
    DriveTimer: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure CopyDialogButtonsClickOk(Sender: TObject);
    procedure DriveTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStart: TfrmStart;

implementation

{$R *.dfm}

procedure TfrmStart.CopyDialogButtonsClickOk(Sender: TObject);
begin
  SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyTargetDrive,
    TargetDrive.Drive);
  SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyOperation,
    selectOperation.value);
  SaveRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyProcessing,
    comboOptions.Value);
  SaveRegistryBool(HKEY_CURRENT_USER, AppRegistryKey, keyCloseTeraCopy,
    checkCloseTeraCopy.Checked);
end;

procedure TfrmStart.DriveTimerTimer(Sender: TObject);
begin
  CopyDialogButtons.EnableOk := (TargetDrive.items.Count > 0);
end;

procedure TfrmStart.FormActivate(Sender: TObject);
var
  tmpChar: Char;
  tmpStr: String;
begin
  checkCloseTeraCopy.Checked := ReadRegistryBool(HKEY_CURRENT_USER,
    AppRegistryKey, keyCloseTeraCopy, checkCloseTeraCopy.Checked);

  if TargetDrive.items.Count < 1 then begin
    CopyDialogButtons.EnableOk := false;
    MessageDialogCentered('Unable to copy, no external drives available');
    DriveTimer.Enabled := true; // keep checking for drives
    // nothing else to do here
    Exit;
  end;

  // read the selected drive
  tmpStr := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyTargetDrive);
  if Length(tmpStr) > 0 then begin
    tmpChar := tmpStr[1];
    if TPath.DriveExists(tmpChar + ':') then begin
      TargetDrive.Drive := tmpChar;
    end;
  end;
end;

procedure TfrmStart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DriveTimer.Enabled := false;
end;

end.
