package colyseus.server;
import js.Promise;
import colyseus.server.presence.*;
import colyseus.server.matchmaker.*;
import colyseus.server.Room;
import colyseus.server.websocket.WebSocket;

typedef RoomWithScore = {
	var roomId : String;
	var score : Float;
};

@:jsRequire("colyseus","MatchMaker")
extern class MatchMaker {
	var handlers : Dynamic;
	function new(?presence:Presence):Void;
	function connectToRoom(client:Client, roomId:String):Promise<Void>;
	function onJoinRoomRequest(client:Client, roomToJoin:String, clientOptions: ClientOptions):Promise<String>;
	function remoteRoomCall(roomId:String, method:String, ?args:Array<Dynamic>, ?rejectionTimeout:Float):Promise<Dynamic>;
	function registerHandler(name:String, klass:RoomConstructor, ?options:Dynamic):Promise<RegisteredHandler>;
	function hasHandler(name:String):Bool;
	function joinById(roomId:String, clientOptions:ClientOptions, ?rejoinSessionId:String):Promise<String>;
	function getAvailableRoomByScore(roomName:String, clientOptions:ClientOptions):Promise<Array<RoomWithScore>>;
	function create(roomName:String, clientOptions:ClientOptions):Promise<String>;
	function getAvailableRooms(roomName:String, ?roomMethodName:String):Promise<Array<RoomAvailable>>;
	function getAllRooms(roomName:String, ?roomMethodName:String):Promise<Array<RoomAvailable>>;
	function getRoomById(roomId:String):Room;
	function gracefullyShutdown():Promise<Dynamic>;
	function cleanupStaleRooms(roomName:String):Promise<Void>;
	function getRoomsWithScore(roomName:String, clientOptions:ClientOptions):Promise<Array<RoomWithScore>>;
	function createRoomReferences(room:Room, ?init:Bool):Promise<Bool>;
	function clearRoomReferences(room:Room):Void;
	function awaitRoomAvailable(roomToJoin:String):Promise<{ }>;
	function getRoomChannel(roomId:String):String;
	function getHandlerConcurrencyKey(name:String):String;
}