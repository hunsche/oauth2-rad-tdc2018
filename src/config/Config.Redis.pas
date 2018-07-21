unit Config.Redis;

interface

type

  TConfigRedis = class
  public
    class function GetHost: string;
    class function GetPort: Integer;
  end;

implementation

uses
  System.SysUtils;

{ TConfigRedis }

class function TConfigRedis.GetHost: string;
begin
  Result := GetEnvironmentVariable('REDIS_HOST');
end;

class function TConfigRedis.GetPort: Integer;
begin
  Result := StrToIntDef(GetEnvironmentVariable('REDIS_PORT'), 6379);
end;

end.
