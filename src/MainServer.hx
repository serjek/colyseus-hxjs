package;
import colyseus.server.*;
import colyseus.server.Room;
import colyseus.server.schema.Schema;

import js.node.Http;

using tink.CoreApi;
using Reflect;

@:tink class MainServer {
	static function main() {
		var s = new Server({server:Http.createServer()});
		s.listen(2567);

		s.register("lobby", LobbyRoom).then(
			@do(h) h
				.on("create", room => trace('From global scope: Room ${room.roomId} created'))
				.on("join", [room , client] => trace('From global scope: client ${client.id} joined room ${room.roomId}'))
		);

		s.register("match", MatchRoom).then(
			@do(h) h
				.on("create", room => trace('From global scope: Room ${room.roomId} created'))
				.on("join", [room , client] => trace('From global scope: client ${client.id} joined room ${room.roomId}'))
		);
		
		trace('-- listening on 0.0.0.0:2567... --');
	}
}

class LobbyRoom extends Room {

    override function onInit(options:Dynamic):Void {
        trace('LOBBY created with options $options');
    };

    override function onJoin(client:Client, ?options:Dynamic, ?auth:Dynamic) {
        trace('LOBBY join: ${client.id} ${options}');
        trace([for (c in clients) c.id]);
        return cast null;
    };
}


class MatchState extends Schema implements ISchema {

	@:type(NUMBER)
	public var someProp:Float;

	@:type(STRING)
	public var foo:String;

    public function new(){
        someProp = 88.99;
        foo = "hey man!";
    }
}

class MatchRoom extends Room {

	public function new() {
		super();
		maxClients = 4;		
	}

	override function onInit(options:Dynamic):Void {
		trace('MATCH with options $options');
        this.setState(new MatchState());
		haxe.Timer.delay(function() {
			state.someProp += 20;
			state.foo = "baz";
		}, 2000);
	};

    override function onJoin(client:Client, ?options:Dynamic, ?auth:Dynamic) {
        trace('MATCH join ${client.id} ${client.options} ${options}');
        trace([for (c in clients) c.id]);
        setMetadata(options);
        return cast null;
    };

}