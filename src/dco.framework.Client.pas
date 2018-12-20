(**
 * $Id: dco.framework.Client.pas 847 2014-05-25 18:16:04Z QXu $
 *
 * Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either
 * express or implied. See the License for the specific language governing rights and limitations under the License.
 *)

unit dco.framework.Client;

interface

uses
  System.TimeSpan,
  superobject { An universal object serialization framework with Json support },
  dco.rpc.Serializer,
  dco.transport.Connection,
  dco.framework.Backlog,
  dco.framework.Command,
  dco.framework.Executor;

type
  /// <summary>This class implements a command executor.</summary>
  TClient = class(TInterfacedObject, IExecutor)
  private
    FConnection: IConnection;
    FSerializer: ISerializer;
    FBacklog: TBacklog;
  public
    constructor Create(const Connection: IConnection; const Serializer: ISerializer; Backlog: TBacklog);
    destructor Destroy; override;
  public
    /// <summary>Exeuctes a command. The current thread is blocked until response is available.</summary>
    /// <exception cref="ERPCException">RPC error (typically network issue)</exception>
    function ExecuteAwait(Command: TCommand): ISuperObject; overload;
    /// <summary>Exeuctes a command. The current thread is blocked until response is available or timed out.</summary>
    /// <exception cref="ERPCException">RPC error (typically network issue)</exception>
    function ExecuteAwait(Command: TCommand; const Timeout: TTimeSpan): ISuperObject; overload;
    /// <summary>Sends a notification and then returns immediately without any delivery garantee.</summary>
    procedure Notify(Command: TCommand);
  end;

implementation

uses
  System.DateUtils,
  System.SysUtils,
  Vcl.Forms,
  Winapi.Windows,
  dutil.util.concurrent.Result,
  dco.rpc.Identifier;

constructor TClient.Create(const Connection: IConnection; const Serializer: ISerializer; Backlog: TBacklog);
begin
  assert(Connection <> nil);
  assert(Serializer <> nil);
  assert(Backlog <> nil);
  inherited Create;

  FConnection := Connection;
  FSerializer := Serializer;
  FBacklog := Backlog;
end;

destructor TClient.Destroy;
begin
  FBacklog := nil;
  FSerializer := nil;
  FConnection := nil;

  inherited;
end;

function TClient.ExecuteAwait(Command: TCommand): ISuperObject;
begin
  Result := ExecuteAwait(Command, TTimeSpan.FromSeconds(30));
end;

function TClient.ExecuteAwait(Command: TCommand; const Timeout: TTimeSpan): ISuperObject;
var
  ResultContainer: TResult<ISuperObject>;
  Id: TIdentifier;
  Message_: string;
  Expiration: TDateTime;
begin
  assert(Command <> nil);
  assert(Command.Type_ = TCommand.TType.REQUEST);
  assert((Command.Params_ = nil) or (Command.Params_.DataType in [TSuperType.stArray, TSuperType.stObject]));

  ResultContainer := TResult<ISuperObject>.Create;
  try
    Id := FBacklog.Put(ResultContainer);
    Message_ := FSerializer.EncodeRequest(Command.Method_, Command.Params_, Id);

    if not FConnection.WriteEnsured(Message_) then
    begin
      FBacklog.TakeAndFailResult(Id);
      assert(ResultContainer.Available);
      // The result container has an exception now
    end
    else
    begin
      Expiration := IncMilliSecond(Now, Round(Timeout.TotalMilliseconds));
      while not ResultContainer.Available do
      begin
        if Expiration < Now then
        begin
          FBacklog.TakeAndFailResult(Id);
          assert(ResultContainer.Available);
          // The result container has an exception now
          Break;
        end;

        // CAUTION: Waiting for a result in the main thread is *EXTREMELY EXPENSIVE*. If the current execution context is 
        // in the main thread, we will call an idle callback periodically.
        if GetCurrentThreadId = System.MainThreadId then
        begin
          Application.ProcessMessages;
        end;
      end;
    end;

    Result := ResultContainer.Take;
  finally
    ResultContainer.Free;
  end;
end;

procedure TClient.Notify(Command: TCommand);
var
  Message_: string;
begin
  assert(Command <> nil);
  assert(Command.Type_ = TCommand.TType.NOTIFICATION);
  assert((Command.Params_ = nil) or (Command.Params_.DataType in [TSuperType.stArray, TSuperType.stObject]));

  Message_ := FSerializer.EncodeNotification(Command.Method_, Command.Params_);
  FConnection.Write(Message_);
end;

end.
