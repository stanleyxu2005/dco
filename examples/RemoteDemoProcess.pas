unit RemoteDemoProcess;

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.Forms,
  dco.framework.RemotingSystem,
  remote.model.WindowOrigin;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FDemoObjectStub: TDemoObjectOrigin;
    FRemotingSystem: TRemotingSystem;
    procedure SetupCommunication;
  private
    procedure ChangeFormSize(NewWidth, NewHeight: Cardinal);
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  System.SysUtils,
  dco.transport.np.NamedPipeTransportImpl,
  dco.framework.RPCObjectImpl;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FRemotingSystem := TRemotingSystem.Create(TNamedPipeTransportImpl.Create('form2'));
  FRemotingSystem.Start;
  SetupCommunication;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  if Assigned(FDemoObjectStub) then
  begin
    FRemotingSystem.Remove(FDemoObjectStub.GetRPCObjectId);
    FDemoObjectStub.Free;
  end;
  FRemotingSystem.Free;
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FDemoObjectStub) then
    FDemoObjectStub.NotifyPositionChanged(X, Y);
end;

procedure TForm2.FormResize(Sender: TObject);
begin
  if Assigned(FDemoObjectStub) then
    FDemoObjectStub.NotifySizeChanged(Width, Height);
end;

procedure TForm2.SetupCommunication;
const
  PROCESS_UUID = 'remote1';
var
  RemoteUri: string;
  RPCObject: TRPCObjectImpl;
begin
  // Create a remote object
  RemoteUri := ParamStr(2);
  RPCObject := FRemotingSystem.CreateAndAdd(RemoteUri);
  assert(RPCObject <> nil);
  RPCObject.Ping;

  FDemoObjectStub := TDemoObjectOrigin.Create(RPCObject);
  FDemoObjectStub.OnRequestResizeWindow := ChangeFormSize;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  FDemoObjectStub.NotifySystemTime;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 1 to 10000 do
    FDemoObjectStub.NotifySystemTime;
end;

procedure TForm2.ChangeFormSize(NewWidth, NewHeight: Cardinal);
begin
  Width := NewWidth;
  Height := NewHeight;
end;

end.
