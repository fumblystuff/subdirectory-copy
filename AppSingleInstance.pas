unit AppSingleInstance;

interface

uses
  Windows, Messages;

const
  AppWindowName = 'SingleInstance.johnwargo.com';
  // Any 32 bit number here to perform check on copied data
  cCopyDataWaterMark = $DE1F1DAB;
  // User window message handled by main form ensures that
  // app not minimized or hidden and is in foreground
  UM_ENSURERESTORED = WM_USER + 1;

function SwitchToPrevInst(Wdw: HWND): Boolean;

implementation

uses
   SysUtils;

function SendParamsToPrevInst(Wdw: HWND): Boolean;
var
  CopyData: TCopyDataStruct;
  idx: Integer;
  CharCount: Integer;
  Data: PChar;
  PData: PChar;
begin
  // Initialize this here so we have a determined result
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
    Result := SendMessage(Wdw, WM_COPYDATA, 0, LPARAM(@CopyData)) = 1;
  finally
    StrDispose(Data);
  end;
end;

function SwitchToPrevInst(Wdw: HWND): Boolean;
begin
  Assert(Wdw <> 0);
  // Again, initialize this here so we have a determined result
  Result := True;
  // Do we have any runtime parameters?
  if ParamCount > 0 then begin
    // then send them to the existing application instance
    Result := SendParamsToPrevInst(Wdw);
  end;
  if Result then begin
    // Switch to the existing app window
    // this skips only if sending parameters fails
    SendMessage(Wdw, UM_ENSURERESTORED, 0, 0);
  end;
end;

end.
