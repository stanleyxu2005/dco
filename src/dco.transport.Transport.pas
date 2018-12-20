(**
 * $Id: dco.transport.Transport.pas 840 2014-05-24 06:04:58Z QXu $
 *
 * Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either
 * express or implied. See the License for the specific language governing rights and limitations under the License.
 *)

unit dco.transport.Transport;

interface

uses
  dco.transport.Pdu;

type
  /// <summary>The interface defines the basic behaviors of a transport resource.</summary>
  ITransport = interface
    /// <summary>Returns the identifier of the transport resource.</summary>
    function GetUri: string;
    /// <summary>Blocks until an inbound message is retrieved.</summary>
    function Read: TPdu;
    /// <summary>Sends an outbound message and waits for it is actually sent out.</summary>
    function WriteEnsured(const Pdu: TPdu): Boolean;
    /// <summary>Sends an outbound message and returns immediately.</summary>
    procedure Write(const Pdu: TPdu);
    /// <summary>Pushs an inbound message to the recipient.</summary>
    procedure ForceRead(const Pdu: TPdu);
  end;

implementation

end.
