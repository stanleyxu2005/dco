(**
 * $Id: dco.framework.Command.pas 846 2014-05-25 18:04:45Z QXu $
 *
 * Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either
 * express or implied. See the License for the specific language governing rights and limitations under the License.
 *)

unit dco.framework.Command;

interface

uses
  System.Types,
  superobject { An universal object serialization framework with Json support };

type
  /// <summary>This abstract class represents the basis of a RPC command. Any RPC command should be inherited from
  /// TCommand.</summary>
  TCommand = class
  public type
    TType = (REQUEST, NOTIFICATION);
    TClassReference = class of TCommand;
  public
    class function Type_: TType; virtual; abstract;
    class function HandleInMainThread_: Boolean; virtual; abstract;
    class function Method_: string; virtual; abstract;
    function Params_: ISuperObject; virtual; abstract;
  end;

implementation

end.
