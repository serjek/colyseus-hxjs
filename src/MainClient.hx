package;
import colyseus.client.Colyseus;

class MainClient {
	
	static function main() {
		var client = new Client("ws://0.0.0.0:2567");
		var room = client.join("state_handler", {hello: 'world', age: 99});

		// list available rooms for connection
        haxe.Timer.delay(function() {
			client.getAvailableRooms("state_handler", function(rooms, ?err) {
				if (err != null) trace("ERROR! " + err);
				for (room in rooms) {
					trace("RoomAvailable:");
					trace("roomId: " + room.roomId);
					trace("clients: " + room.clients);
					trace("maxClients: " + room.maxClients);
					trace("metadata: " + room.metadata);
				}
			});
        }, 3000);


		var time:Int = 0;
		function recurrentSend() {
			room.send({data: 'current time: $time'});
			time++;
			haxe.Timer.delay(recurrentSend, 1000);
		}

		client.onOpen.add(function() {
			trace("CLIENT OPEN, id => " + client.id);
		});

		room.onJoin.add(function(){
			trace('JOIN');
			recurrentSend();
		});
	}
}