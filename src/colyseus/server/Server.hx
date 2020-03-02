package colyseus.server;
import js.lib.Promise;
import colyseus.server.Room;
import colyseus.server.matchmaker.*;
import colyseus.server.presence.*;

@:jsRequire("colyseus","Server")
extern class Server {
    var matchMaker:MatchMaker;
	var server: colyseus.server.websocket.WebSocket.Server;
	var httpServer:haxe.extern.EitherType<js.node.net.Server, js.node.http.Server>;
	var presence:Presence;
	var pingInterval:Dynamic; //NodeJS.Timer
	var pingTimeout:Float;
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

typedef ServerOptions = {
    > colyseus.server.websocket.WebSocket.ServerOptions,
    @:optional var pingTimeout: Float;
    @:optional var presence: Dynamic;
    @:optional var engine: Dynamic;
    @:optional var ws: Dynamic;
	@:optional var gracefullyShutdown: Bool;
	@:optional var express:Dynamic;
}