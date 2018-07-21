unit Providers.Session;

interface

uses
  SysUtils, System.JSON;

type
  TProviderSession = class
  public
    class function GetSessionId: string;
    class procedure SetSession(AKey: string; AJson: TJSONObject);
    class function GetSession(AKey: string): TJSONObject;
  end;

implementation

{ TProviderSession }

uses Config.Redis, Redis.Client, Redis.Command, Redis.Commons,
  Redis.NetLib.Factory, Redis.NetLib.INDY, Redis.Values, RedisMQ.Commands,
  RedisMQ;

class function TProviderSession.GetSessionId: string;
var
  LGUID: TGuid;
begin
  CreateGuid(LGUID);
  Result := LGUID.ToString.Substring(1, LGUID.ToString.Length - 2);
end;

class procedure TProviderSession.SetSession(AKey: string; AJson: TJSONObject);
var
  LRedis: TRedisClient;
begin
  LRedis := TRedisClient.Create(TConfigRedis.GetHost, TConfigRedis.GetPort);
  try
    LRedis.Connect;
    LRedis.&SET(AKey, AJson.ToString);
  finally
    LRedis.Free;
  end;
end;

class function TProviderSession.GetSession(AKey: string): TJSONObject;
var
  LRedis: TRedisClient;
  LValue: TRedisString;
  LResult: TJSONObject;
begin
  LRedis := TRedisClient.Create(TConfigRedis.GetHost, TConfigRedis.GetPort);
  try
    LRedis.Connect;
    LValue := LRedis.GET(AKey);

    if LValue.IsNull then
      LResult := TJSONObject.Create
    else
      LResult := TJSONObject(TJSONObject.ParseJSONValue(LValue.Value));

    Result := LResult;
  finally
    LRedis.Free;
  end;
end;

end.
