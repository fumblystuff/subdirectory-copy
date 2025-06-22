[Setup]
AppName=Subdirectory Copy
AppPublisher=Fumbly Diddle Software
AppPublisherURL=https://www.fumblydiddle.com/
AppContact=support@fumblydiddle.com
AppSupportURL=https://fumblydiddle.com/support/
AppVersion=1.1.2.0
AppVerName=Subdirectory Copy
VersionInfoVersion={#SetupSetting("AppVersion")}
WizardStyle=modern
DefaultDirName={autopf}\Fumbly Diddle Software\Subdirectory Copy\
DefaultGroupName=Fumbly Diddle Software
UninstallDisplayIcon={app}\subcopy.exe
InfoBeforeFile=about.txt
Compression=lzma2
SolidCompression=yes
OutputDir=installer
OutputBaseFilename=SubCopySetup-{#SetupSetting("AppVersion")}
SetupIconFile=subcopy_Icon.ico
ArchitecturesInstallIn64BitMode=x64Compatible
ChangesAssociations = yes

[Files]
Source: "Win64\Release\subcopy.exe"; DestDir: "{app}"; Check: Is64BitInstallMode
Source: "about.txt"; DestDir: "{app}"; Check: Is64BitInstallMode

[Icons]
Name: "{group}\Subdirectory Copy"; Filename: "{app}\subcopy.exe"

[Registry]

Root: HKCR; Subkey: ".scpy"; ValueType: string; ValueData: "SubdirectoryCopy"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "SubdirectoryCopy"; ValueType: string; ValueData: "Program Subdirectory Copy"; Flags: uninsdeletekey
Root: HKCR; Subkey: "SubdirectoryCopy\DefaultIcon"; ValueType: string; ValueData: "{app}\subcopy.exe,0"
Root: HKCR; Subkey: "SubdirectoryCopy\shell\open\command"; ValueType: string; ValueData: """{app}\subcopy.exe"" ""%1"""

[Run]
Filename: "https://docs.fumblydiddle.com/subcopy"; Flags: shellexec runasoriginaluser postinstall; Description: "Launch product documentation (in browser)"