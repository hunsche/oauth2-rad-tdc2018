unit Controllers.OAuth2;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI,
  EMS.ResourceTypes, System.Generics.Collections;

type

  [ResourceName('oauth2')]
  TOAuthResource = class
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
  LKey, LCookie, LItem: string;
  LCookies: TStringList;
  LSession: TJSONObject;
  LRedirectUrl, LToken: string;
begin
  ARequest.Headers.TryGetValue('Cookie', LCookie);

  LCookies := TStringList.Create;
  try
    LCookies.AddStrings(LCookie.Split([';']));
    LKey := LCookies.Values['SESSION_ID'];
  finally
    LCookies.Free;
  end;

  LSession := TProviderSession.GetSession(LKey);
  LSession.GetValue('redirect_url').TryGetValue(LRedirectUrl);

  LToken := 'adsisdfsdfs';

  AResponse.StatusCode := 302;
  AResponse.Headers.SetValue('Location', LRedirectUrl + '?access_token='
    + LToken);
end;

initialization

RegisterResource(TypeInfo(TOAuthResource));

end.
