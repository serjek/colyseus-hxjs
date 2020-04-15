package colyseus.server;
import js.lib.Promise;

//TODO perhaps it makes sense to get rid of Dynamic at least in Promise someday
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