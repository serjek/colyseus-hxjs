package colyseus.server;

import haxe.DynamicAccess;
import haxe.extern.EitherType;
import js.lib.Promise;
import colyseus.server.Client;
import colyseus.server.presence.*;

typedef SimulationCallback = Float->Void;

typedef RoomAvailable = {
	var roomId:String;
	var clients:Int;
	var maxClients:Int;
	@:optional var metadata:Dynamic;
};

typedef BroadcastOptions = {
	@:optional var except:Client;
	@:optional var afterNextPatch:Bool;
};

typedef Room = RoomOf<Dynamic, Dynamic>;

typedef RoomException = {
	var message:String;
	@:optional var stack:String;
};

enum abstract CloseCode(Int) to Int {
	var NORMAL_CLOSURE = 1000;
	var GOING_AWAY = 1001;
	var NO_STATUS_RECEIVED = 1005;
	var ABNORMAL_CLOSURE = 1006;
	var CONSENTED = 4000;
	var SERVER_SHUTDOWN = 4001;
	var WITH_ERROR = 4002;
	var MAY_TRY_RECONNECT = 4010;
}

enum abstract ErrorCode(Int) to Int {
	var MATCHMAKE_NO_HANDLER = 520;
	var MATCHMAKE_INVALID_CRITERIA = 521;
	var MATCHMAKE_INVALID_ROOM_ID = 522;
	var MATCHMAKE_UNHANDLED = 523;
	var MATCHMAKE_EXPIRED = 524;
	var AUTH_FAILED = 525;
	var APPLICATION_ERROR = 526;
	var INVALID_PAYLOAD = 4217;
}

@:jsRequire("colyseus", "Room")
extern class RoomOf<State, Metadata> {
	// Properties
	var clock:Clock;
	var roomId:String;
	var roomName:String;
	var maxClients:Int;
	var patchRate:Null<Float>;
	var autoDispose:Bool;
	var state:State;
	var metadata:Metadata;
	var presence:Presence;
	var clients:ClientArray<Client>;
	var locked:Bool;
	var seatReservationTimeout:Float;
	var maxMessagesPerSecond:Float;

	function new(?presence:Presence):Void;

	// Lifecycle hooks
	function onCreate(options:DynamicAccess<Any>):Void;
	function onAuth(client:Client, ?options:DynamicAccess<Any>, context:AuthContext):EitherType<Bool, Promise<Dynamic>>;
	function onJoin(client:Client, ?options:DynamicAccess<Any>):EitherType<Void, Promise<Dynamic>>;
	function onDrop(client:Client, ?code:Int):EitherType<Void, Promise<Dynamic>>;
	function onReconnect(client:Client):EitherType<Void, Promise<Dynamic>>;
	function onLeave(client:Client, ?code:Int):EitherType<Void, Promise<Dynamic>>;
	function onDispose():EitherType<Void, Promise<Dynamic>>;
	function onBeforePatch(state:State):EitherType<Void, Promise<Dynamic>>;
	function onBeforeShutdown():Void;
	function onUncaughtException(error:RoomException, methodName:String):Void;

	// Development mode hooks
	function onCacheRoom():Dynamic;
	function onRestoreRoom(?cached:Dynamic):Void;

	// Message handling - callback-based
	@:overload(function(messageType:String, callback:Client->Dynamic->Void):Void {})
	function onMessage(messageType:String, callback:Client->String->Dynamic->Void):Void;
	function onMessageBytes(messageType:EitherType<String, Int>, callback:Client->Dynamic->Void):Void;

	// Messages object (new v0.17 pattern) - set in subclass as field
	var messages:DynamicAccess<Dynamic>;

	// State management
	function setState(newState:State):Void;
	function setMetadata(meta:Metadata, ?persist:Bool):Promise<Void>;
	function setPrivate(?bool:Bool, ?persist:Bool):Promise<Void>;
	function setMatchmaking(updates:Dynamic):Promise<Void>;

	// Room control
	function lock():Promise<Void>;
	function unlock():Promise<Void>;
	function disconnect(?closeCode:Int):Promise<Dynamic>;
	function hasReachedMaxClients():Bool;
	function hasReservedSeat(sessionId:String, ?reconnectionToken:String):Bool;

	// Simulation & Broadcasting
	function setSimulationInterval(?onTickCallback:Float->Void, ?delay:Float):Void;
	function setPatchRate(?milliseconds:Null<Float>):Void;
	function broadcast(type:EitherType<String, Int>, ?data:Dynamic, ?options:BroadcastOptions):Void;
	function broadcastBytes(type:EitherType<String, Int>, message:js.lib.Uint8Array, ?options:BroadcastOptions):Void;
	function broadcastPatch():Bool;

	// Client communication
	function send(client:Client, type:EitherType<String, Int>, ?message:Dynamic, ?options:SendOptions):Void;

	// Reconnection
	function allowReconnection(previousClient:Client, ?seconds:EitherType<Float, String>):Promise<Client>;

	/** @deprecated Use seatReservationTimeout instead */
	function setSeatReservationTime(seconds:Float):RoomOf<State, Metadata>;
	function sendState(client:Client):Void;
}

typedef AuthContext = {
	@:optional var token:String;
	var headers:Dynamic;
	var ip:EitherType<String, Array<String>>;
	@:optional var req:Dynamic;
};

@:jsRequire("@colyseus/timer", "ClockTimer")
extern class Clock {
	var running:Bool;
	var deltaTime:Float;
	var currentTime:Float;
	var elapsedTime:Float;
	var delayed:Array<colyseus.server.Delayed>;

	function new(?autoStart:Bool);
	function start(?useInterval:Bool):Void;
	function stop():Void;
	function tick(?newTime:Dynamic):Void;
	function setInterval(handler:haxe.Constraints.Function, time:Float, args:haxe.extern.Rest<Dynamic>):colyseus.server.Delayed;
	function setTimeout(handler:haxe.Constraints.Function, time:Float, args:haxe.extern.Rest<Dynamic>):colyseus.server.Delayed;
	function duration(ms:Float):Promise<Void>;
	function clear():Void;
}
