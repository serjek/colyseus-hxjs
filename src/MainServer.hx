package;
import colyseus.server.*;
import colyseus.server.Room;
import colyseus.server.schema.Schema;
import colyseus.server.schema.SchemaDecorator;

import js.node.Http;

using tink.CoreApi;
using Reflect;

@:tink class MainServer {
	static function main() {
		var s = new Server({server:Http.createServer()});
		s.listen(2567);

		/*s.register("lobby", _ => new LobbyRoom().room).then(
			@do(h) h
				.on("create", room => trace('From global scope: Room ${room.roomId} created'))
				.on("join", [room , client] => trace('From global scope: client ${client.id} joined room ${room.roomId}'))
		);
*/
		s.register("match", _ => new MatchRoom()).then(
			@do(h) h
				.on("create", room => trace('From global scope: Room ${room.roomId} created'))
				.on("join", [room , client] => trace('From global scope: client ${client.id} joined room ${room.roomId}'))
		);
		
		trace('-- listening on 0.0.0.0:2567... --');
	}
}

class LobbyRoom {

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


class MatchState extends Schema implements ISchema {

	@:type("number")
	public var someProp:Float;

	@:type("string")
	public var foo:String = 'meme';
	
	public function new() {
		
	}
}

class MatchRoom extends Room {
	

	public function new() {
		super();
		this.setState(new MatchState());
		maxClients = 4;		
		/*room.onJoin = function(client:Client, ?options:Dynamic, ?auth:Dynamic) {
			trace('MATCH join ${client.id} ${client.options} ${options}');
			trace([for (c in room.clients) c.id]);
			room.setMetadata(options);
			return cast null;
		};
		room.onAuth = function(options:Dynamic) {
			trace('MATCH on auth',options);
			return new js.Promise(function(res, rej){
				var allowPass = true;
				haxe.Timer.delay(function() allowPass ? res(true) : rej('not allowed'), 1200);
			});
		}
		room.onMessage = function(client:Client, data:Dynamic) {
			trace('MATCH MESSAGE FROM ${client.id}: $data');
			room.send(client, {feedback: 'Thank you for your data, ${client.id} ${client.options}!'});
			for (c in room.clients) if (c.id != client.id) room.send(c, {feedback: '${client.id} with options ${client.options} says to others: $data'});
			if (data.data != null && data.data.indexOf("4") != -1)
				client.close(1001);
		}*/
		
	}

	override function onInit(options:Dynamic):Void {
		trace('MATCH with options $options');
		haxe.Timer.delay(function() {
			state.someProp = 20;
			state.foo = "baz";
		}, 2000);
	};

}