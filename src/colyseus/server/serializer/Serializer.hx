package colyseus.server.serializer;
import colyseus.server.Client;

typedef Serializer<T> = {
	var id : String;
	function reset(data:Dynamic):Void;
	function getFullState(client:Client):Dynamic;
	function applyPatches(clients:Array<Client>, state:T):Bool;
	@:optional function handshake():Array<Float>;
};