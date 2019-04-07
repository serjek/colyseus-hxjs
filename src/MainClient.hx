package;
import colyseus.client.Colyseus;

class MainClient {
	
	static function main() {
		var client = new Client("ws://0.0.0.0:2567", {age: 45});
		//var lobbyRoom = client.join("lobby", {hello: 'world'});

		//client.onOpen.add(function() {
			client.getAvailableRooms("match", function(rooms, ?err) {
				if (err != null) trace("ERROR! " + err);
				var targID:String = null;
				for (room in rooms) {
					trace("roomId: " + room.roomId);
					trace("clients: " + room.clients);
					trace("maxClients: " + room.maxClients);
					trace("metadata: " + room.metadata);
					targID = room.roomId;
				}

				//-----------------------
				var matchRoom = 
					if (targID == null) {
						trace('no match exists, create one');
						client.join("match", {nickname: "Coffee"});
					} else {
						trace('join existing match');
						client.join(targID, {nickname: 'Sugar'});
					}

				var time:Int = 0;
				function recurrentSend() {
					//matchRoom.send({data: 'current time: $time'});
					trace(matchRoom.state);
					time++;
					haxe.Timer.delay(recurrentSend, 1000);
				}

				matchRoom.onJoin.add(function(a,b,c){
					trace('onJoin', matchRoom.state);
					recurrentSend();
				});

				matchRoom.onMessage.add(function(e) trace(e));
				matchRoom.onStateChange.add(function(e) trace(e));
			});
		//});

		
	}
}