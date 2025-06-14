unit aboutForm;

interface

uses

  globals,

  RzPanel, RzDlgBtn, RzStatus,

  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls,

  Winapi.Windows, Winapi.Messages, RzLaunch;

type
  TfrmAbout = class(TForm)
    LabelAboutApp: TLabel;
    LabelAboutName: TLabel;
    LabelAboutCopyright: TLabel;
    RzDialogButtonsAbout: TRzDialogButtons;
    LabelAboutVersion: TLabel;
    RzLauncherAbout: TRzLauncher;
    procedure LabelAboutCopyrightClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    FileVersionString: String;
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.FormActivate(Sender: TObject);
begin
  LabelAboutVersion.Caption := FileVersionString;
end;

procedure TfrmAbout.LabelAboutCopyrightClick(Sender: TObject);
begin
  RzLauncherAbout.FileName := AppURL;
  RzLauncherAbout.Launch;
end;

end.
