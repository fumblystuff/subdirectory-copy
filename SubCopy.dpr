program SubCopy;

uses
  Vcl.Forms,
  JclAppInst,
  mainForm in 'mainForm.pas' {frmMain} ,
  utils in 'utils.pas',
  settingsForm in 'settingsForm.pas' {frmSettings} ,
  startForm in 'startForm.pas' {frmStart} ,
  globals in 'globals.pas',
  processingForm in 'processingForm.pas' {frmProcessing} ,
  aboutForm in 'aboutForm.pas' {frmAbout};

{$R *.res}

begin
  // only allow one instance of the application
  if not JclAppInstances.CheckInstance(1) then
    Halt;

  // continue with qpplication initialization
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SubCopy';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
