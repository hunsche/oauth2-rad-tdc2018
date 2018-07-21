unit Controllers.OAuth2;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI,
  EMS.ResourceTypes, System.Generics.Collections,
  System.Hash;

type

  [ResourceName('oauth2')]
  TOAuthResource = class
  private
    function GrantToken: string;
  published
    procedure Get(const AContext: TEndpointContext;
      const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

{ TOAuthResource }

uses Providers.Session;

procedure TOAuthResource.Get(const AContext: TEndpointContext;
  const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LClientID, LUser, LPassword, LKey, LCookie, LItem: string;
  LCookies: TStringList;
  LSession: TJSONObject;
  LRedirectUrl: string;
begin
  ARequest.Headers.TryGetValue('Cookie', LCookie);
  ARequest.Params.TryGetValue('user', LUser);
  ARequest.Params.TryGetValue('password', LPassword);

  LCookies := TStringList.Create;
  try
    LCookies.AddStrings(LCookie.Split([';']));
    LKey := LCookies.Values['SESSION_ID'];
  finally
    LCookies.Free;
  end;

  LSession := TProviderSession.GetSession(LKey);
  LSession.GetValue('redirect_url').TryGetValue(LRedirectUrl);
  LSession.GetValue('client_id').TryGetValue(LClientID);

  if (LClientID = 'fffe7555-f028-4416-a563-478b4264c930') and (LUser = 'admin') and
    (LPassword = 'admin') then
  begin
    AResponse.StatusCode := 302;
    AResponse.Headers.SetValue('Location', LRedirectUrl + '?access_token='
      + GrantToken);
  end
  else
    AResponse.RaiseUnauthorized();
end;

function TOAuthResource.GrantToken: string;
begin
  result := THashSHA2.Create.HashAsString;
end;

initialization

RegisterResource(TypeInfo(TOAuthResource));

end.
