package colyseus.server;

import haxe.DynamicAccess;
import haxe.extern.EitherType;
import js.lib.Promise;
import colyseus.server.Express;
import colyseus.server.matchmaker.*;
import colyseus.server.presence.*;

@:jsRequire("colyseus")
extern class Colyseus {
	static function defineServer(options:ServerOptions):Server;
	static function defineRoom<T>(clazz:T, ?options:Dynamic):RegisteredHandler;
	static function monitor():Dynamic;
	static function playground():Dynamic;
	static function createRouter(endpoints:Dynamic):Router;
	static function createEndpoint(path:String, options:EndpointOptions, handler:EndpointContext->Promise<Dynamic>):Endpoint;
}

typedef EndpointOptions = {
	@:optional var method:String; // "GET" | "POST" | "PUT" | "DELETE" | "PATCH"
};

typedef EndpointContext = Dynamic;
typedef Endpoint = Dynamic;

typedef Router = {
	var handler:Dynamic;
	var endpoints:Dynamic;
	function addEndpoint(endpoint:Endpoint):Void;
};

typedef ServerOptions = {
	@:optional var publicAddress:String;
	@:optional var transport:Dynamic;
	@:optional var presence:Presence;
	@:optional var driver:Dynamic;
	@:optional function selectProcessIdToCreateRoom(roomName:String, clientOptions:Dynamic):Promise<String>;
	@:optional var devMode:Bool;
	@:optional var gracefullyShutdown:Bool;
	@:optional var greet:Bool;
	@:optional var logger:Dynamic;
	@:optional function beforeListen():EitherType<Void, Promise<Void>>;
	@:optional function express(app:Express):Void;
	@:optional var rooms:DynamicAccess<RegisteredHandler>;
	@:optional var routes:Router;
};

@:jsRequire("colyseus", "Server")
extern class Server {
	var transport:Dynamic;
	var router:Dynamic;
	var options:ServerOptions;

	function new(?options:ServerOptions):Void;
	function attach(options:ServerOptions):Promise<Void>;
	function listen(port:EitherType<Int, String>, ?hostname:String, ?backlog:Int, ?listeningListener:haxe.Constraints.Function):Promise<Dynamic>;
	@:overload(function(name:String, roomClass:Dynamic, ?defaultOptions:Dynamic):RegisteredHandler {})
	function define(roomClass:Dynamic, ?defaultOptions:Dynamic):RegisteredHandler;
	function removeRoomType(name:String):Void;
	function gracefullyShutdown(?exit:Bool, ?err:Dynamic):Promise<Void>;
	function simulateLatency(milliseconds:Float):Void;
	function onShutdown(callback:Void->EitherType<Void, Promise<Dynamic>>):Void;
	function onBeforeShutdown(callback:Void->EitherType<Void, Promise<Dynamic>>):Void;
}
