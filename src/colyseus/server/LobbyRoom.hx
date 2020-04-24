package colyseus.server;
import colyseus.server.presence.*;
import js.lib.Promise;

@:jsRequire("colyseus","LobbyRoom")
extern class LobbyRoom extends Room {
	
}

@:jsRequire("colyseus","updateLobby")
extern class LobbyHandler {
	@:selfCall static function updateLobby(room:Room):Void;
}