package;
import colyseus.server.*;
import colyseus.server.Room;
import js.node.Http;

using tink.CoreApi;

@:tink class MainServer {
	static function main() {
		var s = new Server({server:Http.createServer()});
		s.listen(2567);

		s.register("state_handler", _ => new MyRoom().room);
		
		
		/*haxe.Timer.delay(function(){

			(s.verifyClient('a','b'):Promise<Dynamic>).handle(v => trace('yo $v'));
		}, 1000);
		*/
		trace('-- listening on 0.0.0.0:2567... --');
	}
}

class MyRoom implements IRoomWrapper {

	public var room = new Room();
	
	public function new() {
		room.maxClients = 4;
		room.onInit = function(options:Dynamic):Void {
			trace('>>>>>>>> created with options $options');
		};
		room.onJoin = function(client:Client, ?options:Dynamic, ?auth:Dynamic) {
			trace('>>>>> ${client.id} ${options}');
			trace([for (c in room.clients) c.id]);
			return cast null;
		};
		room.onMessage = function(client:Client, data:Dynamic) {
			trace('MESSAEG FROM ${client.id}: $data');
			room.send(client, {feedback: 'Thank you for your data, ${client.id}!'});
		}
		
	}

}