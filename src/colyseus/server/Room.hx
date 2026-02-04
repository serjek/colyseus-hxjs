package colyseus.server;
import haxe.DynamicAccess;
import colyseus.server.presence.*;
import haxe.extern.EitherType;
import js.lib.Promise;

typedef RoomConstructor = Presence->Room;
typedef SimulationCallback = Float->Void;
typedef RoomAvailable = {
	var roomId: String;
	var clients: Int;
	var maxClients: Int;
	@:optional var metadata: Dynamic;
};

typedef BroadcastOptions = {
	@:optional var except: Client;
	@:optional var afterNextPatch: Bool;
};

typedef Room = RoomOf<Dynamic, Dynamic>;

@:jsRequire("colyseus","Room")
extern class RoomOf<State, Metadata> {
	var clock: Clock;
	var roomId: String;
	var roomName: String;
	var maxClients: Float;
	var patchRate: Float;
	var autoDispose: Bool;
	var state: State;
	var metadata: Metadata;
	var presence: Presence;
	var clients: Array<Client>;
	var protected: Dynamic;
	var seatReservationTime: Float;
	var reservedSeats: Array<String>; //perhaps this is wrong as it was Set originally; investigate this
	var reservedSeatTimeouts: Dynamic;
	var reconnections: Dynamic;
	var isDisconnecting: Bool;
	function new(?presence:Presence):Void;
	function onMessage(type:String, handler:Client->Dynamic->Void):Void;
	function onCreate(options:DynamicAccess<Any>):Void;
	function onAuth(client:Client, ?options:DynamicAccess<Any>, context:AuthContext):EitherType<Bool, Promise<Dynamic>>;
	function onJoin(client:Client, ?options:DynamicAccess<Any>):EitherType<Void, Promise<Dynamic>>;
	function onDrop(client:Client, code:Int):Promise<Dynamic>;
	function onReconnect(client:Client):Void;
	function onLeave(client:Client, ?consented:Bool):EitherType<Void, Promise<Dynamic>>;
	function onDispose():EitherType<Void, Promise<Dynamic>>;
	var readonly: Dynamic;
	var locked: Bool;
	
	function hasReachedMaxClients():Bool;
	function setSeatReservationTime(seconds:Float):RoomOf<State, Metadata>;
	function hasReservedSeat(sessionId:String):Bool;
	function setSimulationInterval(callback:SimulationCallback, ?delay:Float):Void;
	function setPatchRate(milliseconds:Float):Void;
	function setState(newState:State):Void;
	function setMetadata(meta:Metadata):Promise<Void>;
	function lock():Void;
	function unlock():Void;
	function broadcast(type:String, data:Dynamic, ?options:BroadcastOptions):Bool;
	function getAvailableData():Promise<RoomAvailable>;
	function disconnect():Promise<Dynamic>;
	var get_serializer: String;
	function sendState(client:Client):Void;
	function broadcastPatch():Bool;
	function broadcastAfterPatch():Void;
	function allowReconnection(client:Client, ?seconds:Float):Promise<Client>;
	function resetAutoDisposeTimeout(timeoutInSeconds:Float):Void;
}

typedef AuthContext = {
	var token:String;
	var headers:DynamicAccess<String>;
	var ip:String;
}

typedef Clock = Dynamic;
