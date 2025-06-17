unit AppSingleInstance;

// Source: How to run a single instance of an application
// https://delphidabbler.com/articles/article-13

interface

uses

  Messages, Windows;

const
  // Any 32 bit number here to perform check on copied data
  cCopyDataWaterMark = $DE1F1DAB;
  // User window message handled by main form ensures that
  // app not minimized or hidden and is in foreground
  UM_ENSURERESTORED = WM_USER + 1;

function LaunchInstance: Boolean;

implementation

uses

  globals,

  Dialogs, SysUtils;

function SendParamsToPrevInst(AppWindow: HWND): Boolean;
var
  CopyData: TCopyDataStruct;
  idx: Integer;
  CharCount: Integer;
  Data: PChar;
  PData: PChar;
begin
  Result := False;
  CharCount := 0;
  for idx := 1 to ParamCount do
    Inc(CharCount, Length(ParamStr(idx)) + 1);
  Inc(CharCount);
  Data := StrAlloc(CharCount);
  try
    PData := Data;
    for idx := 1 to ParamCount do begin
      StrPCopy(PData, ParamStr(idx));
      Inc(PData, Length(ParamStr(idx)) + 1);
    end;
    PData^ := #0;
    CopyData.lpData := Data;
    CopyData.cbData := CharCount * SizeOf(Char);
    CopyData.dwData := cCopyDataWaterMark;
    Result := SendMessage(AppWindow, WM_COPYDATA, 0, LPARAM(@CopyData)) = 1;
  finally
    StrDispose(Data);
  end;
end;

function SwitchToPrevInst(AppWindow: HWND): Boolean;
begin
  Assert(AppWindow <> 0);
  Result := True;
  // Do we have any runtime parameters?
  if ParamCount > 0 then begin
    // then send them to the existing application instance
    Result := SendParamsToPrevInst(AppWindow);
  end;
  if Result then begin
    // Switch to the existing app window
    // this skips only if sending parameters fails
    SendMessage(AppWindow, UM_ENSURERESTORED, 0, 0);
  end;
end;

function LaunchInstance: Boolean;
var
  AppWindow: HWND;

begin
  Result := True;
  AppWindow := FindWindow(AppWindowName, nil);
  // if this is the only instance, AppWindow will be 0
  if AppWindow <> 0 then begin
    Result := False;
    if not SwitchToPrevInst(AppWindow) then begin
      MessageDlg('Unable to activate existing application instance',
        mtInformation, [mbOk], 0, mbOk);
    end;
  end;
end;

end.

