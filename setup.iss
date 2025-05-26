[Setup]
AppName=Subdirectory Copy
AppPublisher=Fumbly Diddle Software
AppPublisherURL=https://www.fumblydiddle.com/
AppContact=support@fumblydiddle.com
AppSupportURL=https://fumblydiddle.com/support/
AppVersion=1.0.5
VersionInfoVersion={#SetupSetting("AppVersion")}
WizardStyle=modern
DefaultDirName={autopf}\Fumbly Diddle Software\subcopy
DefaultGroupName=Fumbly Diddle
UninstallDisplayIcon={app}\subcopy.exe
InfoBeforeFile=about.txt
Compression=lzma2
SolidCompression=yes
OutputDir=installer
; OutputBaseFilename=SubCopySetup-{#SetupSetting("AppVersion")}
OutputBaseFilename=SubCopySetup-{#SetupSetting("AppVersion")}
SetupIconFile=subcopy_Icon.ico
ArchitecturesInstallIn64BitMode=x64Compatible

[Files]
Source: "Win64\Release\subcopy.exe"; DestDir: "{app}"; Check: Is64BitInstallMode
Source: "about.txt"; DestDir: "{app}"; Check: Is64BitInstallMode

[Icons]
Name: "{group}\Subdirectory Copy"; Filename: "{app}\subcopy.exe"

[Run]
Filename: "https://docs.fumblydiddle.com/subcopy"; Flags: shellexec runasoriginaluser postinstall; Description: "Launch product documentation (in browser)"