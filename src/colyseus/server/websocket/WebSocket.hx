package colyseus.server.websocket;
import js.lib.Error;
import js.node.http.Agent;
import js.node.Buffer;
import js.node.net.Socket;
import js.node.events.EventEmitter;
import js.node.http.IncomingMessage;
import colyseus.server.websocket.Ws;

typedef ClientOptions = {
	@:optional var protocol : String;
	@:optional var handshakeTimeout : Float;
	@:optional var perMessageDeflate : haxe.extern.EitherType<Bool, PerMessageDeflateOptions>;
	@:optional var localAddress : String;
	@:optional var protocolVersion : Float;
	@:optional var headers : { };
	@:optional var origin : String;
	@:optional var agent : Agent;
	@:optional var host : String;
	@:optional var family : Float;
	@:optional function checkServerIdentity(servername:String, cert:CertMeta):Bool;
	@:optional var rejectUnauthorized : Bool;
	@:optional var passphrase : String;
	@:optional var ciphers : String;
	@:optional var cert : CertMeta;
	@:optional var key : CertMeta;
	@:optional var pfx : haxe.extern.EitherType<String, Buffer>;
	@:optional var ca : CertMeta;
	@:optional var maxPayload : Float;
};
typedef PerMessageDeflateOptions = {
	@:optional var serverNoContextTakeover : Bool;
	@:optional var clientNoContextTakeover : Bool;
	@:optional var serverMaxWindowBits : Float;
	@:optional var clientMaxWindowBits : Float;
	@:optional var zlibDeflateOptions : { @:optional var flush : Float; @:optional var finishFlush : Float; @:optional var chunkSize : Float; @:optional var windowBits : Float; @:optional var level : Float; @:optional var memLevel : Float; @:optional var strategy : Float; @:optional var dictionary : haxe.extern.EitherType<Buffer, haxe.extern.EitherType<Array<Buffer>, DataView>>; @:optional var info : Bool; };
	@:optional var threshold : Float;
	@:optional var concurrencyLimit : Float;
};
typedef ServerOptions = {
	@:optional var host : String;
	@:optional var port : Float;
	@:optional var backlog : Float;
	@:optional var server : haxe.extern.EitherType<js.node.http.Server, js.node.https.Server>;
	@:optional var verifyClient : haxe.extern.EitherType<VerifyClientCallbackAsync, VerifyClientCallbackSync>;
	@:optional var handleProtocols : Dynamic;
	@:optional var path : String;
	@:optional var noServer : Bool;
	@:optional var clientTracking : Bool;
	@:optional var perMessageDeflate : haxe.extern.EitherType<Bool, PerMessageDeflateOptions>;
	@:optional var maxPayload : Float;
};
typedef AddressInfo = {
	var address : String;
	var family : String;
	var port : Float;
};

@:jsRequire("ws","Server")
extern class Server extends EventEmitter<Dynamic> {
	var options : ServerOptions;
	var path : String;
	var clients : Array<WebSocket>; //it was Set and perhaps will not work
	function new(?options:ServerOptions, ?callback:Void -> Void):Void;
	function address():haxe.extern.EitherType<AddressInfo, String>;
	function close(?cb:?Error -> Void):Void;
	function handleUpgrade(request:IncomingMessage, socket:Socket, upgradeHead:Buffer, callback:WebSocket -> Void):Void;
	function shouldHandle(request:IncomingMessage):Bool;
}

typedef VerifyClientData = {origin: String, secure: Bool, req: IncomingMessage};
typedef VerifyClientDataCB = {res: Bool, ?code: Int, ?message: String, ?headers: OutgoingHttpHeaders}
typedef VerifyClientCallbackSync =  {info:VerifyClientData} -> Bool;
typedef VerifyClientCallbackAsync = {info:VerifyClientData, callback:VerifyClientDataCB->Void} -> Void;
typedef Data = Dynamic;
typedef CertMeta = Dynamic;
typedef DataView = Dynamic;
typedef OutgoingHttpHeaders = Dynamic; //available from node 8