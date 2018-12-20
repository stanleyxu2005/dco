unit dco.rpc.jsonrpc.EncoderTest;
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
  dco.rpc.jsonrpc.Encoder;

type
  // Test methods for class TEncoder
  TEncoderTest = class(TTestCase)
  strict private
    FEncoder: TEncoder;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestEncodeRequest;
    procedure TestEncodeNotification;
    procedure TestEncodeResponse;
    procedure TestEncodeResponseError;
  end;

implementation

procedure TEncoderTest.SetUp;
begin
  FEncoder := TEncoder.Create;
end;

procedure TEncoderTest.TearDown;
begin
  FEncoder.Free;
  FEncoder := nil;
end;

procedure TEncoderTest.TestEncodeRequest;
var
  ReturnValue: string;
  Id: TIdentifier;
  Params: ISuperObject;
  Method: string;
begin
  Id := TIdentifier.NumberIdentifier(1);
  Params := SA([SO(2), SO(3), SO(7)]);
  Method := 'multiply';

  ReturnValue := FEncoder.EncodeRequest(Method, Params, Id);
  CheckEquals('{"method":"multiply","params":[2,3,7],"id":1,"jsonrpc":"2.0"}', ReturnValue);
end;

procedure TEncoderTest.TestEncodeNotification;
var
  ReturnValue: string;
  Params: ISuperObject;
  Method: string;
begin
  Params := SO(['progress', 0.0]);
  Method := 'progress';

  ReturnValue := FEncoder.EncodeNotification(Method, Params);
  CheckEquals('{"method":"progress","params":{"progress":0},"jsonrpc":"2.0"}', ReturnValue);
end;

procedure TEncoderTest.TestEncodeResponse;
var
  ReturnValue: string;
  Id: TIdentifier;
  Result_: ISuperObject;
begin
  Id := TIdentifier.NumberIdentifier(1);
  Result_ := SO(42);

  ReturnValue := FEncoder.EncodeResponse(Result_, Id);
  CheckEquals('{"result":42,"id":1,"jsonrpc":"2.0"}', ReturnValue);
end;

procedure TEncoderTest.TestEncodeResponseError;
var
  ReturnValue: string;
  Id: TIdentifier;
  Error: TErrorObject;
begin
  Id := TIdentifier.NullIdentifier;
  Error := TErrorObject.CreateInvalidRequest('don''t panic');

  ReturnValue := FEncoder.EncodeResponse(Error, Id);
  CheckEquals('{"id":null,"error":{"message":"Invalid request","data":"don''t panic","code":-32600},"jsonrpc":"2.0"}',
    ReturnValue);
end;

initialization

// Register any test cases with the test runner
RegisterTest(TEncoderTest.Suite);

end.
