unit dco.rpc.jsonrpc.DecoderTest;
{

 Delphi DUnit Test Case
 ----------------------
 This unit contains a skeleton test case class generated by the Test Case Wizard.
 Modify the generated code to correctly setup and call the methods from the unit
 being tested.

}

interface

uses
  TestFramework, superobject,
  dco.rpc.ErrorObject,
  dco.rpc.Identifier,
  dco.rpc.RPCHandlerMock,
  dco.rpc.jsonrpc.Decoder;

type
  // Test methods for class TDecoder
  TDecoderTest = class(TTestCase)
  strict private
    FHandler: THandlerMock;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDecode_Request;
    procedure TestDecode_Notification;
    procedure TestDecode_Response;
    procedure TestDecode_Error;
    procedure TestDecode_BadSyntax;
    procedure TestDecode_InvalidMessage;
    procedure TestDecode_InvalidRequestWithBadId;
    procedure TestDecode_InvalidRequestWithoutVersion;
    procedure TestDecode_InvalidRequestWithBadVersion;
    procedure TestDecode_InvalidRequestWithBadMethod;
    procedure TestDecode_InvalidRequestWithBadParams;
    procedure TestDecode_InvalidRequestWithMethodAsWellAsResult;
    procedure TestDecode_InvalidResponseWithoutId;
    procedure TestDecode_InvalidErrorResponse;
    procedure TestDecode_InvalidErrorResponseWithoutCode;
    procedure TestDecode_InvalidErrorResponseWithBadCode;
    procedure TestDecode_InvalidErrorResponseWithoutMessage;
    procedure TestDecode_InvalidErrorResponseWithBadMessage;
  end;

implementation

uses
  dco.rpc.RPCException;

procedure TDecoderTest.SetUp;
begin
  FHandler := THandlerMock.Create;
end;

procedure TDecoderTest.TearDown;
begin
  FHandler.Free;
  FHandler := nil;
end;

procedure TDecoderTest.TestDecode_Request;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "method": "multiply", "params": [2, 3, 7], "id": 1}';
  FHandler.ExpectRequest('multiply', SA([SO(2), SO(3), SO(7)]), TIdentifier.NumberIdentifier(1));

  TDecoder.Decode(Message_, FHandler);
  FHandler.Verify;
end;

procedure TDecoderTest.TestDecode_Notification;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "method": "thanks"}';
  FHandler.ExpectNotification('thanks', nil);

  TDecoder.Decode(Message_, FHandler);
  FHandler.Verify;
end;

procedure TDecoderTest.TestDecode_Response;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "result": 42, "id": 1}';
  FHandler.ExpectResponse(SO(42), TIdentifier.NumberIdentifier(1));

  TDecoder.Decode(Message_, FHandler);
  FHandler.Verify;
end;

procedure TDecoderTest.TestDecode_Error;
var
  Message_: string;
  Error: TErrorObject;
begin
  Message_ := '{"jsonrpc": "2.0", "error": {"code": -1, "message": "don''t panic"}, "id": null}';
  Error := TErrorObject.Create(-1, 'don''t panic', nil);
  FHandler.ExpectResponse(Error, TIdentifier.NullIdentifier);

  TDecoder.Decode(Message_, FHandler);
  FHandler.Verify;
end;

procedure TDecoderTest.TestDecode_BadSyntax;
var
  Message_: string;
begin
  Message_ := '@#%&*!';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidMessage;
var
  Message_: string;
begin
  Message_ := '[]';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidRequestWithBadId;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "method": "multiply", "params": [2, 3, 7], "id": true}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidRequestWithoutVersion;
var
  Message_: string;
begin
  Message_ := '{"method": "multiply", "params": [2, 3, 7], "id": 1}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidRequestWithBadVersion;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "1.0", "method": "multiply", "params": [2, 3, 7], "id": 1}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidRequestWithBadMethod;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "method": null, "params": [2, 3, 7], "id": 1}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidRequestWithBadParams;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "method": "multiply", "params": null, "id": "1"}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidRequestWithMethodAsWellAsResult;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "method": "multiply", "result": 42}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidResponseWithoutId;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "result": 42}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidErrorResponse;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "error": "multiply", "id": null}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidErrorResponseWithoutCode;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "error": {"message": "don''t panic"}, "id": null}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidErrorResponseWithBadCode;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "error": {"code": null, "message": "don''t panic"}, "id": null}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidErrorResponseWithoutMessage;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "error": {"code": -1}, "id": null}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

procedure TDecoderTest.TestDecode_InvalidErrorResponseWithBadMessage;
var
  Message_: string;
begin
  Message_ := '{"jsonrpc": "2.0", "error": {"code": -1, "message": null}, "id": null}';
  StartExpectingException(ERPCException);

  TDecoder.Decode(Message_, FHandler);
  StopExpectingException;
end;

initialization

// Register any test cases with the test runner
RegisterTest(TDecoderTest.Suite);

end.
