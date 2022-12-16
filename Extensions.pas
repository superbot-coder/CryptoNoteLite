unit Extensions;

interface

USES
  Winapi.Windows, System.Win.Registry, System.SysUtils, Vcl.Dialogs;

// ExtName - the extension name exsample *.txt
// ExtHandler - extension handler that will open files with these extensions
function RegisterExtension(ExtName, ExtHandler: String): boolean;

implementation

function RegisterExtension(ExtName, ExtHandler: String): boolean;
var
  Reg: TRegistry;
  //ext: String;
begin
  Result := false;
  if (ExtName = '') or (ExtHandler = '') then Exit;

  if ExtName[1] <> '.' then ExtName := '.' + AnsiLowerCase(ExtName);

  Reg := TRegistry.Create(KEY_WRITE);
  Reg.RootKey := HKEY_CLASSES_ROOT;

  try
   if Not Reg.OpenKey(ExtName, true) then Exit;
   Reg.WriteString('', ExtName + 'file');
   Reg.CloseKey;
   Delete(ExtName,1,1);
   if Not Reg.OpenKey(ExtName + 'file\shell\open\command', true) then Exit;
   Reg.WriteString('', '"' + ExtHandler + '"' + '"%1"');
   Reg.CloseKey;
   Result := true;
  finally
    Reg.Free;
  end;
end;

end.