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
    RzVersionInfoAbout: TRzVersionInfo;
    LabelAboutVersion: TLabel;
    RzLauncherAbout: TRzLauncher;
    procedure FormCreate(Sender: TObject);
    procedure LabelAboutCopyrightClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  RzVersionInfoAbout.FilePath := Application.ExeName;
  LabelAboutVersion.Caption := Format('Version %s',
    [RzVersionInfoAbout.FileVersion]);
end;

procedure TfrmAbout.LabelAboutCopyrightClick(Sender: TObject);
begin
  RzLauncherAbout.FileName := AppURL;
  RzLauncherAbout.Launch;
end;

end.
