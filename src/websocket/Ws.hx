package websocket;
import js.node.events.EventEmitter;
import js.Error;
import js.node.Buffer;
import js.node.http.ClientRequest;
import js.node.http.IncomingMessage;

extern class WebSocket extends EventEmitter<Dynamic> {
	static var CONNECTING : Float;
	static var OPEN : Float;
	static var CLOSING : Float;
	static var CLOSED : Float;
	var binaryType : String;
	var bufferedAmount : Float;
	var extensions : String;
	var protocol : String;
	var readyState : Float;
	var url : String;
	var onopen : { var target : WebSocket; } -> Void;
	var onerror : { var error : Dynamic; var message : String; var type : String; var target : WebSocket; } -> Void;
	var onclose : { var wasClean : Bool; var code : Float; var reason : String; var target : WebSocket; } -> Void;
	var onmessage : { var data : WebSocket.Data; var type : String; var target : WebSocket; } -> Void;
	@:overload(function(address:String, ?protocols:haxe.extern.EitherType<String, Array<String>>, ?options:WebSocket.ClientOptions):Void { })
	function new(address:String, ?options:WebSocket.ClientOptions):Void;
	function close(?code:Float, ?data:String):Void;
	function ping(?data:Dynamic, ?mask:Bool, ?cb:Error -> Void):Void;
	function pong(?data:Dynamic, ?mask:Bool, ?cb:Error -> Void):Void;
	@:overload(function(data:Dynamic, options:{ @:optional var mask : Bool; @:optional var binary : Bool; @:optional var compress : Bool; @:optional var fin : Bool; }, ?cb:?Error -> Void):Void { })
	function send(data:Dynamic, ?cb:?Error -> Void):Void;
	function terminate():Void;
}

typedef Symbol = Dynamic;