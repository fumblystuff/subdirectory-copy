program SubCopy;

uses
  Vcl.Forms,
  mainForm in 'mainForm.pas' {frmMain},
  utils in 'utils.pas',
  settingsForm in 'settingsForm.pas' {frmSettings},
  startForm in 'startForm.pas' {frmStart},
  globals in 'globals.pas',
  processingForm in 'processingForm.pas' {frmProcessing};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'MSFCopy';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmStart, frmStart);
  Application.CreateForm(TfrmProcessing, frmProcessing);
  Application.Run;
end.
