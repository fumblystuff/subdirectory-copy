unit Utils;

interface

uses
  System.Classes, System.SysUtils,

  Vcl.Dialogs, Vcl.Forms,

  Winapi.Windows;

procedure MessageDialogCentered(msg: String);
function ReadRegistryBool(rootKey: HKEY; key, valueName: String;
  defaultValue: Boolean = false): Boolean;
function ReadRegistryString(rootKey: HKEY; key, valueName: String;
  defaultValue: String = ''): String;
function ReadRegistryInteger(rootKey: HKEY; key, valueName: String;
  defaultValue: integer = 0): integer;
procedure SaveRegistryBool(rootKey: HKEY; key, valueName: String;
  value: Boolean);
procedure SaveRegistryInteger(rootKey: HKEY; key, valueName: String;
  value: integer);
procedure SaveRegistryString(rootKey: HKEY; key, valueName: String;
  value: String);
procedure Split(const Delimiter: Char; Input: string;
  const theStrings: TStrings);

implementation

uses
  Registry;

var
  Reg: TRegistry;

procedure Split(const Delimiter: Char; Input: string;
  const theStrings: TStrings);
begin
  Assert(Assigned(theStrings));
  theStrings.StrictDelimiter := true;
  theStrings.Delimiter := Delimiter;
  theStrings.DelimitedText := Input;
end;

procedure MessageDialogCentered(msg: String);
var
  f: TForm;
begin
  f := CreateMessageDialog(msg, mtInformation, [mbOK]);
  f.Caption := 'Information';
  f.Position := poOwnerFormCenter;
  f.ShowModal;
end;

function ReadRegistryBool(rootKey: HKEY; key, valueName: String;
  defaultValue: Boolean = false): Boolean;
begin
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, false) then begin
      if Reg.ValueExists(valueName) then begin
        Result := Reg.ReadBool(valueName);
      end else begin
        Result := defaultValue;
      end;
      Reg.CloseKey;
    end else begin
      Result := defaultValue;
    end;
  end;
end;

procedure SaveRegistryBool(rootKey: HKEY; key, valueName: String;
  value: Boolean);
begin
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, true) then begin
      Reg.WriteBool(valueName, value);
      Reg.CloseKey;
    end;
  end;
end;

function ReadRegistryInteger(rootKey: HKEY; key, valueName: String;
  defaultValue: integer = 0): integer;
begin
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, false) then begin
      if Reg.ValueExists(valueName) then begin
        Result := Reg.ReadInteger(valueName);
      end else begin
        Result := defaultValue;
      end;
      Reg.CloseKey;
    end else begin
      Result := defaultValue;
    end;
  end;
end;

procedure SaveRegistryInteger(rootKey: HKEY; key, valueName: String;
  value: integer);
begin
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, true) then begin
      Reg.WriteInteger(valueName, value);
      Reg.CloseKey;
    end;
  end;
end;

function ReadRegistryString(rootKey: HKEY; key, valueName: String;
  defaultValue: String = ''): String;
begin
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, false) then begin
      if Reg.ValueExists(valueName) then begin
        Result := Reg.ReadString(valueName);
      end else begin
        Result := defaultValue;
      end;
      Reg.CloseKey;
    end else begin
      Result := defaultValue;
    end;
  end;
end;

procedure SaveRegistryString(rootKey: HKEY; key, valueName: String;
  value: String);
begin
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, true) then begin
      Reg.WriteString(valueName, value);
      Reg.CloseKey;
    end;
  end;
end;

initialization

begin
  Reg := TRegistry.Create(KEY_ALL_ACCESS);
end;

Finalization

begin
  Reg.CloseKey;
end;

end.
