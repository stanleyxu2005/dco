unit rpc.ControlRemoteWindowProtocol;

interface

uses
  dco.framework.Executor;

type
  TControlRemoteWindowProtocol = class
  public type
    Iface = interface
      procedure ResizeWindow(Width: Cardinal; Height: Cardinal);
    end;
  public type
    TClient = class(TInterfacedObject, Iface)
    private
      FExecutor: IExecutor;
    public
      constructor Create(const Executor: IExecutor); reintroduce;
      destructor Destroy; override;
    protected
      // Iface
      procedure ResizeWindow(Width: Cardinal; Height: Cardinal);
    end;
  end;

implementation

uses
  System.SysUtils,
  superobject,
  dco.framework.Command;

constructor TControlRemoteWindowProtocol.TClient.Create(const Executor: IExecutor);
begin
  assert(Executor <> nil);
  inherited Create;
  FExecutor := Executor;
end;

destructor TControlRemoteWindowProtocol.TClient.Destroy;
begin
  FExecutor := nil;
  inherited;
end;

procedure TControlRemoteWindowProtocol.TClient.ResizeWindow(Width: Cardinal; Height: Cardinal);
var
  Params: ISuperObject;
  ResponseContainer: ISuperObject;
begin
  // Prepare parameters
  Params := SO;
  Params.I['Width'] := Width;
  Params.I['Height'] := Height;

  try
    ResponseContainer := FExecutor.ExecuteAwait('ResizeWindow', Params);
    // Do validation optionally
  except
    on E: Exception do
      raise EExternalException.Create(E.ToString);
  end;
end;

end.
