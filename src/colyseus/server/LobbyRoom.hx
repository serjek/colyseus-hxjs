package colyseus.server;

import haxe.DynamicAccess;
import haxe.extern.EitherType;
import js.lib.Promise;

@:jsRequire("colyseus", "LobbyRoom")
extern class LobbyRoom extends Room {
	var rooms:Array<Dynamic>;
	var unsubscribeLobby:Void->Void;
	var clientOptions:DynamicAccess<Dynamic>;

	function onCreate(options:Dynamic):Promise<Void>;
	function onJoin(client:Client, ?options:Dynamic):Void;
	function onLeave(client:Client):Void;
	function onDispose():Void;
}
