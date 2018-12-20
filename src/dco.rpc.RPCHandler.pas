(**
 * $Id: dco.rpc.RPCHandler.pas 840 2014-05-24 06:04:58Z QXu $
 *
 * Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either
 * express or implied. See the License for the specific language governing rights and limitations under the License.
 *)

unit dco.rpc.RPCHandler;

interface

uses
  superobject { An universal object serialization framework with Json support },
  dco.rpc.ErrorObject,
  dco.rpc.Identifier;

type
  /// <summary>This interface defines the obligation to handle RPC requests and responses. The implementation may
  /// require that the specified error and the identifier are not null.</summary>
  IRPCHandler = interface
    procedure HandleRequest(const Method: string; const Params: ISuperObject; const Id: TIdentifier);
    procedure HandleNotification(const Method: string; const Params: ISuperObject);
    procedure HandleResponse(const Result: ISuperObject; const Id: TIdentifier); overload;
    procedure HandleResponse(const Error: TErrorObject; const Id: TIdentifier); overload;
  end;

implementation

end.
