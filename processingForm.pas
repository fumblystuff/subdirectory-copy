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
    procedure FormActivate(Sender: TObject);
    procedure ErrorOutput(msg: String);
    procedure WarnOutput(msg: String);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    RootPath, TemporaryFilePath: String;
        RzLauncher:  TRzLauncher;
    SourceSubdirectoryList: TStringList;
  private
    { private declarations }
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
  closeStr, driveStr, operationOption, processingOption, executablePath,
    tmpPath, tmpStr: string;
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

  // Root Path
  if Length(RootPath) > 0 then begin
    memoOutput.lines.Append(Format('Root Path: %s', [RootPath]));
    if not DirectoryExists(RootPath) then begin
      ErrorOutput(Format('Path "%s" does not exist', [RootPath]));
      doCopy := false;
    end;
  end;

  // Source Directories
  memoOutput.lines.Append(Format('Source diretcories: %d',
    [SourceSubdirectoryList.Count]));
  if SourceSubdirectoryList.Count < 1 then begin
    ErrorOutput('You must define at least one Source directory');
    doCopy := false;
  end;

  if doCopy then begin
    // create the list file
    memoOutput.lines.Append(Format('Creating temporary file: %s',
      [TemporaryFilePath]));
    AssignFile(listFile, TemporaryFilePath);
    ReWrite(listFile);
    // now start populating it
    for sourceIdx := 0 to SourceSubdirectoryList.Count - 1 do begin
      tmpPath := TPath.Combine(RootPath, SourceSubdirectoryList.strings
        [sourceIdx]);
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
      tmpStr := Format('%s *"%s" "%s" %s %s',
        [operationOption, TemporaryFilePath, driveStr, processingOption,
        closeStr]);
      memoOutput.lines.Append(Format('TeraCopy command line parameters: %s',
        [tmpStr]));
      RzLauncher.Parameters := tmpStr;
      RzLauncher.Launch;
    end else begin
      ErrorOutput('Cancelling operation, no files to copy');
    end;
  end;

  ProcessingDialogButtons.EnableCancel := true;
end;

procedure TfrmProcessing.FormCreate(Sender: TObject);
begin
  SourceSubdirectoryList := TStringList.Create;
end;

procedure TfrmProcessing.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SourceSubdirectoryList.Free;
end;

end.
