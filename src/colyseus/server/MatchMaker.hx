package colyseus.server;

import js.lib.Promise;
import colyseus.server.matchmaker.RegisteredHandler;

typedef SeatReservation = {
	var sessionId:String;
	var room:Dynamic;
};

@:jsRequire("colyseus", "matchMaker")
extern class MatchMaker {
	static function joinOrCreate(roomName:String, ?clientOptions:Dynamic, ?authContext:Dynamic):Promise<SeatReservation>;
	static function create(roomName:String, ?clientOptions:Dynamic, ?authContext:Dynamic):Promise<SeatReservation>;
	static function join(roomName:String, ?clientOptions:Dynamic, ?authContext:Dynamic):Promise<SeatReservation>;
	static function joinById(roomId:String, ?clientOptions:Dynamic, ?authContext:Dynamic):Promise<SeatReservation>;
	static function reconnect(roomId:String, ?clientOptions:Dynamic):Promise<SeatReservation>;
	static function query(?conditions:Dynamic, ?sortOptions:Dynamic):Promise<Array<Dynamic>>;
	static function findOneRoomAvailable(roomName:String, filterOptions:Dynamic, ?additionalSortOptions:Dynamic):Promise<Dynamic>;
	static function remoteRoomCall(roomId:String, method:String, ?args:Array<Dynamic>, ?rejectionTimeout:Float):Promise<Dynamic>;
	static function createRoom(roomName:String, clientOptions:Dynamic):Promise<Dynamic>;
	static function reserveSeatFor(room:Dynamic, options:Dynamic, ?authData:Dynamic):Promise<SeatReservation>;
	static function defineRoomType(roomName:String, klass:Dynamic, ?defaultOptions:Dynamic):RegisteredHandler;
	static function removeRoomType(roomName:String):Void;
	static function getRoomById(roomId:String):Promise<Dynamic>;
	static function getLocalRoomById(roomId:String):Dynamic;
	static function disconnectAll(?closeCode:Int):Array<Promise<Dynamic>>;
	static function gracefullyShutdown():Promise<Dynamic>;
}
