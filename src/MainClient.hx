package;
import io.colyseus.Client;
import io.colyseus.Room;

class MainClient {
	
	static function main() {
		var client = new Client("ws://0.0.0.0:2567");
		var room = client.join("state_handler");

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

		/**
		 * Client callbacks
		 */
		client.onOpen = function() {
			trace("CLIENT OPEN, id => " + client.id);
		};

		client.onClose = function () {
			trace("CLIENT CLOSE");
		};

		client.onError = function (message){
			trace("CLIENT ERROR: " + message);
		};

		/**
		 * Room callbacks
		 */
		room.onJoin = function() {
			trace("JOINED ROOM");
		};

		room.onStateChange = function (state) {
			trace("STATE CHANGE: " + Std.string(state));
		};

		room.onMessage = function (message) {
			trace("ROOM MESSAGE: " + Std.string(message));
		};

		room.onError = function (message) {
			trace("ROOM ERROR: " + message);
		};

		room.onLeave = function () {
			trace("ROOM LEAVE");
		}

		room.listen("players/:id", function(change) {
			trace('ON CHANGE $change');
		}, true);
	}
}