package colyseus.server;
import js.lib.Promise;
import colyseus.server.presence.*;
import colyseus.server.matchmaker.*;
import colyseus.server.Room;
import colyseus.server.websocket.WebSocket;

typedef RoomWithScore = {
	var roomId : String;
	var score : Float;
};

@:jsRequire("colyseus","matchMaker")
extern class MatchMaker {
	static function joinOrCreate(roomName:String, options:Dynamic):Promise<Dynamic>;
	static function create(roomName:String, options:Dynamic):Promise<Dynamic>;
	static function join(roomName:String, options:Dynamic):Promise<Dynamic>;
	static function joinById(roomId:String, options:Dynamic):Promise<Dynamic>;
	static function query(conditions:Dynamic):Promise<Dynamic>;
	static function findOneRoomAvailable(roomName:String, options:Dynamic):Promise<Dynamic>;
	static function remoteRoomCall(roomId:String, method:String, ?args:Array<Dynamic>):Promise<Dynamic>;
	static function createRoom(roomName:String, options:Dynamic):Promise<Dynamic>;
	static function reserveSeatFor(room:String, options:Dynamic):Promise<Dynamic>;
}