unit Controllers.Authorize;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI,
  EMS.ResourceTypes;

type

  [ResourceName('authorize')]
  TAuthorizeResource = class
  published
    procedure Get(const AContext: TEndpointContext;
      const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

uses Config.Static, Providers.Session;

procedure TAuthorizeResource.Get(const AContext: TEndpointContext;
  const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
const
  JSON_SESSION = '{"redirect_url": "%s", "client_id": "%s"}';
var
  LJsonString: string;
  LJson: TJSONValue;
  LHtml: TMemoryStream;
  LClientId, LRedirectUrl, LSessionId: string;
  AJson: TArray<TJSONPair>;
begin
  ARequest.Params.TryGetValue('redirect_uri', LRedirectUrl);
  ARequest.Params.TryGetValue('client_id', LClientId);

  LSessionId := TProviderSession.GetSessionId;
  AResponse.Headers.SetValue('Set-Cookie', 'SESSION_ID=' + LSessionId);

  LJsonString := Format(JSON_SESSION, [LRedirectUrl, LClientId]);
  LJson := TJSONObject.ParseJSONValue(LJsonString);
  TProviderSession.SetSession(LSessionId, TJSONObject(LJson));

  AResponse.StatusCode := 302;
  AResponse.Headers.SetValue('Location', GetEnvironmentVariable('BASE_URL') +
    '/login');
end;

initialization

RegisterResource(TypeInfo(TAuthorizeResource));

end.
