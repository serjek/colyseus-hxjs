package;
import colyseus.server.*;
import colyseus.server.Room;
import js.node.Http;

using tink.CoreApi;

@:tink class MainServer {
	static function main() {
		var s = new Server({server:Http.createServer()});
		s.listen(2567);

		s.register("lobby", _ => new LobbyRoom().room);
		s.register("match", _ => new MatchRoom().room);
		
		trace('-- listening on 0.0.0.0:2567... --');
	}
}

class LobbyRoom implements IRoomWrapper {

	public var room = new Room();
	
	public function new() {
		room.onInit = function(options:Dynamic):Void {
			trace('LOBBY created with options $options');
		};
		room.onJoin = function(client:Client, ?options:Dynamic, ?auth:Dynamic) {
			trace('LOBBY join: ${client.id} ${options}');
			trace([for (c in room.clients) c.id]);
			return cast null;
		};
		room.onMessage = function(client:Client, data:Dynamic) {
			trace('LOBBY MESSAGE FROM ${client.id}: $data');
			room.send(client, {feedback: 'Thank you for your data, ${client.id}!'});
		}
		
	}
}
class MatchRoom implements IRoomWrapper {

	public var room = new Room();
	
	public function new() {
		room.maxClients = 4;
		room.onInit = function(options:Dynamic):Void {
			trace('MATCH with options $options');
		};
		room.onJoin = function(client:Client, ?options:Dynamic, ?auth:Dynamic) {
			trace('MATCH join ${client.id} ${client.options} ${options}');
			trace([for (c in room.clients) c.id]);
			return cast null;
		};
		room.onAuth = function(options:Dynamic) {
			trace('MATCH on auth',options);
			return new js.Promise(function(res, rej){
				haxe.Timer.delay(function() Math.random() > .5 ? rej('not allowed') : res(true), 3000);
			});
		}
		room.onMessage = function(client:Client, data:Dynamic) {
			trace('MATCH MESSAGE FROM ${client.id}: $data');
			room.send(client, {feedback: 'Thank you for your data, ${client.id} ${client.options}!'});
			for (c in room.clients) if (c.id != client.id) room.send(c, {feedback: '${client.id} with options ${client.options} says to others: $data'});
			if (data.data != null && data.data.indexOf("10") != -1)
				client.close(1001);
		}
		
	}

}