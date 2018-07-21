unit Config.Static;

interface

type

  TConfigStatic = class
  public
    class function GetPath(AName: string): string;
  end;

implementation

uses
  System.SysUtils, System.IOUtils;

{ TConfigStatic }

class function TConfigStatic.GetPath(AName: string): string;
var
  LEnv: string;
begin
  LEnv := GetEnvironmentVariable('STATIC_PATH');
  Result := TPath.Combine(LEnv, AName);
end;

end.
