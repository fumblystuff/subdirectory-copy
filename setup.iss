[Setup]
AppName=Multiple Source Folder Copy
AppPublisher=Fumbly Diddle Software
AppPublisherURL=https://www.fumblydiddle.com/
AppContact=support@fumblydiddle.com
AppSupportURL=https://fumblydiddle.com/support/
AppVersion=1.0.6
VersionInfoVersion={#SetupSetting("AppVersion")}
WizardStyle=modern
DefaultDirName={autopf}\Fumbly Diddle Software\msfcopy
DefaultGroupName=Fumbly Diddle
UninstallDisplayIcon={app}\msfcopy.exe
InfoBeforeFile=about.txt
Compression=lzma2
SolidCompression=yes
OutputDir=installer
OutputBaseFilename=MSFCopySetup-{#SetupSetting("AppVersion")}
SetupIconFile=msfcopy_Icon.ico
ArchitecturesInstallIn64BitMode=x64Compatible

[Files]
Source: "Win64\Release\msfcopy.exe"; DestDir: "{app}"; Check: Is64BitInstallMode
Source: "about.txt"; DestDir: "{app}"; Check: Is64BitInstallMode

[Icons]
Name: "{group}\Multiple Source Folder Copy"; Filename: "{app}\msfcopy.exe"

[Run]
Filename: "https://docs.fumblydiddle.com/msfcopy"; Flags: shellexec runasoriginaluser postinstall; Description: "Launch product documentation (in browser)"