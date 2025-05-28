unit processingForm;

interface

uses
  globals, utils,

  RzPanel, RzDlgBtn, RzEdit, RzLaunch,

  System.SysUtils, System.Variants, System.Classes, System.IOUtils,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls,

  Winapi.Windows, Winapi.Messages;

type
  TfrmProcessing = class(TForm)
    memoOutput: TRzMemo;
    ProcessingDialogButtons: TRzDialogButtons;
    RzLauncher: TRzLauncher;
    procedure FormActivate(Sender: TObject);
    procedure ErrorOutput(msg: String);
    procedure WarnOutput(msg: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProcessing: TfrmProcessing;

implementation

{$R *.dfm}

procedure TfrmProcessing.ErrorOutput(msg: String);
begin
  memoOutput.lines.Append(Format('Error: %s', [msg]));
end;

procedure TfrmProcessing.WarnOutput(msg: String);
begin
  memoOutput.lines.Append(Format('Warning: %s', [msg]));
end;

procedure TfrmProcessing.FormActivate(Sender: TObject);
var
  listFile: TextFile;
  closeCmd, doCopy: boolean;
  copiedFiles, sourceIdx, skippedFiles: integer;
  closeStr, driveStr, listFilePath,  operationOption,
    processingOption, rootPath, executablePath, tmpPath, tmpStr: string;
  sourceFolderList: TStringList;
begin
  memoOutput.lines.Append('Validating process configuration');
  doCopy := true;
  copiedFiles := 0;
  skippedFiles := 0;

  // Target Drive
  tmpStr := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyTargetDrive, '');
  if Length(tmpStr) < 1 then begin
    ErrorOutput('Missing target drive assignment.');
    doCopy := false;
  end;
  // does the target drive exist?
  if doCopy then begin
    driveStr := tmpStr[1] + ':\';
    if not TPath.DriveExists(driveStr) then begin
      ErrorOutput('Target drive does not exist');
      doCopy := false;
    end else begin
      memoOutput.lines.Append(Format('Target Drive: %s', [driveStr]));
    end;
  end;

  // TeraCopy executable
  executablePath := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyExecutable, globals.TeraCopyDefaultPath);
  // does the executable exist?
  if not FileExists(executablePath) then begin
    ErrorOutput('TeraCpy executable does not exist');
    doCopy := false;
  end else begin
    memoOutput.lines.Append(Format('TeraCopy Executable: %s',
      [executablePath]));
  end;

  // Root Directory
  rootPath := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keyRootDirectory);
  if Length(rootPath) > 0 then begin
    memoOutput.lines.Append(Format('Root Path: %s', [rootPath]));
    if not DirectoryExists(rootPath) then begin
      ErrorOutput(Format('Path "%s" does not exist', [rootPath]));
      doCopy := false;
    end;
  end;

  // Source Directories
  sourceFolderList := TStringList.Create();
  tmpStr := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
    keySourceDirectories);
  if Length(tmpStr) > 0 then begin
    Split(';', tmpStr, sourceFolderList);
    memoOutput.lines.Append(Format('Source folders: %d',
      [sourceFolderList.Count]));
    if sourceFolderList.Count < 1 then begin
      ErrorOutput('You must define at least one Source Folder location');
      doCopy := false;
    end;
  end else begin
    ErrorOutput('You must define at least one Source Folder location');
    doCopy := false;
  end;

  if doCopy then begin
    // create the list file
    listFilePath := TPath.GetTempFileName();
    memoOutput.lines.Append(Format('Creating temporary file: %s',
      [listFilePath]));
    AssignFile(listFile, listFilePath);
    ReWrite(listFile);
    // now start populating it
    for sourceIdx := 0 to sourceFolderList.Count - 1 do begin
      tmpPath := TPath.Combine(rootPath, sourceFolderList.strings[sourceIdx]);
      // does the file exist?
      if DirectoryExists(tmpPath) then begin
        // write it to the file
        writeln(listFile, tmpPath);
        inc(copiedFiles);
      end else begin
        // otherwise log it as an error
        WarnOutput(Format('Path does not exist (%s)', [tmpPath]));
        inc(skippedFiles);
      end;

    end;
    CloseFile(listFile);

    memoOutput.lines.Append(Format('Folders to copy: %d', [copiedFiles]));
    memoOutput.lines.Append(Format('Folders skipped: %d', [skippedFiles]));

    if copiedFiles > 0 then begin
      operationOption := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
        keyOperationStr, 'Copy');
      processingOption := ReadRegistryString(HKEY_CURRENT_USER, AppRegistryKey,
        keyProcessingStr, '/OverwriteOlder');
      closeCmd := ReadRegistryBool(HKEY_CURRENT_USER, AppRegistryKey,
        keyCloseTeraCopy, false);

      if closeCmd then begin
        closeStr := '/Close';
      end else begin
        closeStr := '/NoClose';
      end;

      // now launch Teracopy and pass in the file
      memoOutput.lines.Append('Launching TeraCopy');
      RzLauncher.fileName := executablePath;
      tmpStr := Format('%s *"%s" "%s" %s %s', [operationOption, listFilePath,
        driveStr, processingOption, closeStr]);
      memoOutput.lines.Append(Format('TeraCopy command line parameters: %s',
        [tmpStr]));
      RzLauncher.Parameters := tmpStr;
      RzLauncher.Launch;
    end else begin
      ErrorOutput('Cancelling operation, no files to copy');
    end;
  end;

  sourceFolderList.Free;
  ProcessingDialogButtons.EnableCancel := true;
end;

end.
