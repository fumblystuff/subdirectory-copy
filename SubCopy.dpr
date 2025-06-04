program SubCopy;

uses
  Vcl.Forms,
  mainForm in 'mainForm.pas' {frmMain},
  utils in 'utils.pas',
  settingsForm in 'settingsForm.pas' {frmSettings},
  startForm in 'startForm.pas' {frmStart},
  globals in 'globals.pas',
  processingForm in 'processingForm.pas' {frmProcessing},
  aboutForm in 'aboutForm.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SubCopy';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
