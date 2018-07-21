unit Controllers.Login;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI,
  EMS.ResourceTypes;

type

  [ResourceName('login')]
  TLoginResource = class
  published
    procedure Get(const AContext: TEndpointContext;
      const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

uses Config.Static, Providers.Session;

procedure TLoginResource.Get(const AContext: TEndpointContext;
  const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LHtml: TMemoryStream;
begin
  LHtml := TMemoryStream.Create;
  LHtml.LoadFromFile(TConfigStatic.GetPath('login.html'));
  AResponse.Body.SetStream(LHtml, 'text/html', true);
end;

initialization

RegisterResource(TypeInfo(TLoginResource));

end.
