program SubCopy;

uses
  CodesiteLogging,

  Vcl.Forms,
  Vcl.Dialogs,
  Messages,
  Windows,
  mainForm in 'mainForm.pas' {frmMain} ,
  settingsForm in 'settingsForm.pas' {frmSettings} ,
  startForm in 'startForm.pas' {frmStart} ,
  processingForm in 'processingForm.pas' {frmProcessing} ,
  aboutForm in 'aboutForm.pas' {frmAbout} ,
  AppSingleInstance in 'AppSingleInstance.pas',
  globals in 'globals.pas', utils in 'utils.pas';

{$R *.res}

begin

  if not LaunchInstance then begin
    halt;
  end;

  // continue with qpplication initialization
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SubCopy';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
