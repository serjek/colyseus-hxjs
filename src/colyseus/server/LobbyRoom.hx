package colyseus.server;
import colyseus.server.presence.*;
import haxe.extern.EitherType;
import js.lib.Promise;

//NOTE you *must* call super for functions you override in LobbyRoom

@:jsRequire("colyseus","LobbyRoom")
extern class LobbyRoom extends Room {
	function onMessage(type:String, handler:Client->Dynamic->Void):Void;
	function onCreate(options:Map<String,Dynamic>):EitherType<Void, Promise<Dynamic>>;
	function onJoin(client:Client, ?options:Map<String,Dynamic>, ?auth:Dynamic):EitherType<Void, Promise<Dynamic>>;
	function onLeave(client:Client, ?consented:Bool):EitherType<Void, Promise<Dynamic>>;
	function onDispose():EitherType<Void, Promise<Dynamic>>;
	function onAuth(client:Client, options:Map<String,Dynamic>, ?request:Dynamic):EitherType<Bool, Promise<Dynamic>>;
}

@:jsRequire("colyseus","updateLobby")
extern class LobbyHandler {
	@:selfCall static function updateLobby(room:Room):Void;
}