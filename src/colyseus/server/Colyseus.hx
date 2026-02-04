package colyseus.server;
import haxe.DynamicAccess;
import js.lib.Promise;
import colyseus.server.Express;
import colyseus.server.matchmaker.*;
import colyseus.server.presence.*;

@:jsRequire("colyseus") 
extern class Colyseus {
	static function defineServer(options:ServerOptions):Server;
    static function defineRoom<T>(clazz:T, ?options:RoomOptions):RoomDef;
    static function monitor():Monitor;
    static function playground():Playground;
    static function createRouter():Void;
    static function createEndpoint():Void;
}

typedef RoomDef = {
	@:optional function filterBy(opt:Array<String>):RoomDef;
}

typedef ServerOptions = {
	@:optional var transport:Dynamic;
	@:optional var presence:Dynamic;
	@:optional function selectProcessIdToCreateRoom(roomName: String, clientOptions: Any):Promise<String>;
	@:optional var devMode:Bool;
	@:optional var gracefullyShutdown:Bool;
	@:optional function express(app:Express):Void;
	var rooms:DynamicAccess<RoomDef>;
}

typedef Monitor = Dynamic;
typedef Playground = Dynamic;
typedef RoomOptions = Dynamic;

@:jsRequire("colyseus","Server")
extern class Server {
	var server: colyseus.server.websocket.WebSocket.Server;
	var httpServer:haxe.extern.EitherType<js.node.net.Server, js.node.http.Server>;
	var presence:Presence;
	var pingInterval:Float;
    var processId:String;
	function new(?options:ServerOptions):Void;
	function attach(options:ServerOptions):Void;
	function listen(port:Int, ?hostname:String, ?backlog:Float, ?listeningListener:haxe.Constraints.Function):Void;
	function define(name:String, handler:Dynamic, ?options:Dynamic):RegisteredHandler;
	function gracefullyShutdown(?exit:Bool):Promise<Void>;
	function onShutdown(callback:Void -> haxe.extern.EitherType<Void, Promise<Dynamic>>):Void;
	var onShutdownCallback:Void -> haxe.extern.EitherType<Void, Promise<Dynamic>>;
	function autoTerminateUnresponsiveClients(pingTimeout:Float):Void;
	var verifyClient:Dynamic -> Dynamic -> Promise<Dynamic>;
	var onConnection:Client -> ?Dynamic -> Void;
	function onMessageMatchMaking(client:Client, message:Dynamic):Void;
}