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
    selectProcessing: TRzComboBox;
    checkCloseTeraCopy: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure CopyDialogButtonsClickOk(Sender: TObject);
    procedure DriveTimerTimer(Sender: TObject);
    procedure SetDriveState;
    procedure TargetDriveDriveChange(Sender: TObject);
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
  if TargetDrive.Drive <> '' then begin
    WriteRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyTargetDrive,
      TargetDrive.Drive);
  end;
  // Operation value (command) and Idx
  WriteRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyOperationStr,
    selectOperation.value);
  WriteRegistryInteger(HKEY_CURRENT_USER, AppRegistryKey, keyOperationIdx,
    selectOperation.ItemIndex);
  // Processing value (command) and Idx
  WriteRegistryString(HKEY_CURRENT_USER, AppRegistryKey, keyProcessingStr,
    selectProcessing.value);
  WriteRegistryInteger(HKEY_CURRENT_USER, AppRegistryKey, keyProcessingIdx,
    selectProcessing.ItemIndex);
  // TeraCopy close
  WriteRegistryBool(HKEY_CURRENT_USER, AppRegistryKey, keyCloseTeraCopy,
    checkCloseTeraCopy.Checked);
end;

procedure TfrmStart.DriveTimerTimer(Sender: TObject);
begin
  SetDriveState();
end;

procedure TfrmStart.SetDriveState;
begin
  CopyDialogButtons.EnableOk := (TargetDrive.items.Count > 0);
end;

procedure TfrmStart.TargetDriveDriveChange(Sender: TObject);
begin
  TargetDrive.Refresh();
  SetDriveState();
end;

procedure TfrmStart.FormActivate(Sender: TObject);
var
  tmpChar: Char;
  tmpInt: Integer;
  tmpStr: String;
begin
  checkCloseTeraCopy.Checked := ReadRegistryBool(HKEY_CURRENT_USER,
    AppRegistryKey, keyCloseTeraCopy, checkCloseTeraCopy.Checked);

  // Set the selected Operation
  tmpInt := ReadRegistryInteger(HKEY_CURRENT_USER, AppRegistryKey,
    keyOperationIdx, -1);
  if tmpInt > -1 then begin
    selectOperation.ItemIndex := tmpInt;
  end;

  // Set the selected Processing option
  tmpInt := ReadRegistryInteger(HKEY_CURRENT_USER, AppRegistryKey,
    keyProcessingIdx, -1);
  if tmpInt > -1 then begin
    selectProcessing.ItemIndex := tmpInt;
  end;

  if TargetDrive.items.Count < 1 then begin
    CopyDialogButtons.EnableOk := false;
    MessageDialogCentered('Unable to copy, no external drives available');
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

end.
