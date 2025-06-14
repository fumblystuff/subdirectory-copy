unit Utils;

interface

uses

  globals,

  System.Classes, System.SysUtils,

  Vcl.Controls, Vcl.Dialogs, Vcl.Forms,

  Winapi.Windows;

procedure MessageDialogCentered(msg: String);
function MessageConfirmationCentered(headerText, msg: String): boolean;
function CheckRegistryValue(rootKey: HKEY; key, value: string): boolean;
procedure RenameRegistryValue(rootKey: HKEY; key, oldValue, newValue: string);
procedure DeleteRegistryValue(rootKey: HKEY; key, value: String);
function ReadRegistryBool(rootKey: HKEY; key, valueName: String;
  defaultValue: boolean = false): boolean;
function ReadRegistryString(rootKey: HKEY; key, valueName: String;
  defaultValue: String = ''): String;
function ReadRegistryInteger(rootKey: HKEY; key, valueName: String;
  defaultValue: integer = 0): integer;
procedure SaveRegistryBool(rootKey: HKEY; key, valueName: String;
  value: boolean);
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

function MessageConfirmationCentered(headerText, msg: String): boolean;
var
  f: TForm;
begin
  f := CreateMessageDialog(msg, mtConfirmation, [mbYes, mbNo]);
  f.Caption := headerText;
  f.Position := poOwnerFormCenter;
  f.ShowModal;
  Result := f.ModalResult = mrYes;
end;

function CheckRegistryValue(rootKey: HKEY; key, value: string): boolean;
begin
  Result := false;
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, false) then begin
      Result := Reg.ValueExists(value);
    end;
  end;
end;

procedure DeleteRegistryValue(rootKey: HKEY; key, value: String);
begin
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, true) then begin
      if Reg.ValueExists(value) then begin
        Reg.DeleteValue(value);
      end;
      Reg.CloseKey;
    end;
  end;
end;

procedure RenameRegistryValue(rootKey: HKEY; key, oldValue, newValue: string);
begin
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, false) then begin
      if Reg.ValueExists(oldValue) then begin
        Reg.RenameValue(oldValue, newValue);
      end;
    end;
  end;
end;

function ReadRegistryBool(rootKey: HKEY; key, valueName: String;
  defaultValue: boolean = false): boolean;
begin
  Result := defaultValue;
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, false) then begin
      if Reg.ValueExists(valueName) then begin
        Result := Reg.ReadBool(valueName);
      end;
      Reg.CloseKey;
    end;
  end;
end;

procedure SaveRegistryBool(rootKey: HKEY; key, valueName: String;
  value: boolean);
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
  Result := defaultValue;
  Reg.rootKey := rootKey;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, false) then begin
      if Reg.ValueExists(valueName) then begin
        Result := Reg.ReadInteger(valueName);
      end;
      Reg.CloseKey;
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
  Result := defaultValue;
  if Reg.KeyExists(key) then begin
    if Reg.OpenKey(key, false) then begin
      if Reg.ValueExists(valueName) then begin
        Result := Reg.ReadString(valueName);
      end;
      Reg.CloseKey;
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
