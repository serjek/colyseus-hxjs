package colyseus.server;

import haxe.extern.EitherType;
import js.node.Buffer;
import colyseus.server.schema.Schema.StateView;

enum abstract ClientState(Int) {
	var JOINING = 0;
	var JOINED = 1;
	var RECONNECTED = 2;
	var LEAVING = 3;
	var CLOSED = 4;
}

@:jsRequire("colyseus", "Client")
extern class Client {
	/** @deprecated Use sessionId instead */
	var id:String;
	var sessionId:String;
	var state:ClientState;
	var reconnectionToken:String;

	/** Optional: when using @:view decorator, this is the StateView instance for this client. */
	@:optional var view:StateView;

	@:optional var userData:Dynamic;
	@:optional var auth:Dynamic;

	function send(type:EitherType<String, Int>, ?message:Dynamic, ?options:SendOptions):Void;
	function sendBytes(type:EitherType<String, Int>, bytes:EitherType<Buffer, js.lib.Uint8Array>, ?options:SendOptions):Void;
	function raw(data:EitherType<js.lib.Uint8Array, Buffer>, ?options:SendOptions):Void;
	function enqueueRaw(data:EitherType<js.lib.Uint8Array, Buffer>, ?options:SendOptions):Void;
	function leave(?code:Int, ?data:String):Void;
	/** @deprecated Use leave() instead */
	function close(?code:Int, ?data:String):Void;
	function error(code:Int, ?message:String):Void;
}

typedef SendOptions = {
	@:optional var afterNextPatch:Bool;
};

@:jsRequire("colyseus", "ClientArray")
extern class ClientArray<C:Client> extends Array<C> {
	function getById(sessionId:String):Null<C>;
	function delete(client:C):Bool;
}
