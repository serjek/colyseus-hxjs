package colyseus.client;

@:jsRequire("colyseus.js","Client")
extern class Client {
	@:optional
	var id : String;
	var onOpen : Signal;
	var onMessage : Signal;
	var onClose : Signal;
	var onError : Signal;
	var protected : Dynamic;
	var connection : Connection;
	var rooms : { };
	var connectingRooms : { };
	var requestId : Float;
	var hostname : String;
	var storage : Storage;
	var roomsAvailableRequests : { };
	function new(url:String, ?options:Dynamic):Void;
	function join<T>(roomName:String, ?options:Dynamic):Room<T>;
	function getAvailableRooms(roomName:String, callback:Array<RoomAvailable> -> ?String -> Void):Void;
	function close(colyseusId:String):Void;
}
@:jsRequire("colyseus.js","Connection")
extern class Connection {
	function new(url:Dynamic, ?querry:Dynamic):Void;
	function onOpenCallback(even:Dynamic):Void;
	function onCloseCallback(even:Dynamic):Void;
	function send(data:Dynamic):Void;
}
@:enum abstract Protocol(Int) {
	var USER_ID = 1;
	var JOIN_ROOM = 10;
	var JOIN_ERROR = 11;
	var LEAVE_ROOM = 12;
	var ROOM_DATA = 13;
	var ROOM_STATE = 14;
	var ROOM_STATE_PATCH = 15;
	var ROOM_LIST = 20;
	var BAD_REQUEST = 50;
}
@:jsRequire("colyseus.js","Signal")
extern class Signal {
	function new():Void;
	function add(listener:haxe.Constraints.Function):Slot;
}
@:jsRequire("colyseus.js","Slot")
extern class Slot {
	var protected : Dynamic;
	var _signal : Dynamic;
	var _enabled : Bool;
	var _listener : haxe.Constraints.Function;
	var _once : Bool;
	var _priority : Float;
	var _params : Array<Dynamic>;
	function execute0():Void;
	function execute1(value:Dynamic):Void;
	function execute(valueObjects:Array<Dynamic>):Void;
	var listener : haxe.Constraints.Function;
	var readonly : Dynamic;
	var once : Bool;
	var priority : Float;
	function toString():String;
	var enabled : Bool;
	var params : Array<Dynamic>;
	function remove():Void;
	function verifyListener(listener:haxe.Constraints.Function):Void;
}
@:jsRequire("colyseus.js","StateContainer")
extern class StateContainer<T> {
	var state : T;
	function new(state:T):Void;
	function set(newState:T):Void;
	function registerPlaceholder(placeholder:String, matcher:js.RegExp):Void;
	function listen(segments:haxe.extern.EitherType<String, haxe.Constraints.Function>, ?callback:haxe.Constraints.Function):Void;
	function removeListener(listener:Dynamic):Void;
	function removeAllListeners():Void;
}
@:jsRequire("colyseus.js","Room")
extern class Room<T> extends StateContainer<T> {
	var id : String;
	var sessionId : String;
	var name : String;
	var options : Dynamic;
	var clock : Clock;
	var remoteClock : Clock;
	var onJoin : Signal;
	var onStateChange : Signal;
	var onMessage : Signal;
	var onError : Signal;
	var onLeave : Signal;
	var connection : Connection;
	function new(name:String, ?options:Dynamic):Void;
	function connect(connection:Connection):Void;
	function leave():Void;
	function send(data:Dynamic):Void;
	override function removeAllListeners():Void;
	var protected : Dynamic;
	function onMessageCallback(event:Dynamic):Void;
	function setState(encodedState:Dynamic, ?remoteCurrentTime:Float, ?remoteElapsedTime:Float):Void;
	function patch(binaryPatch:Dynamic):Void;
}
typedef RoomAvailable = {
	var roomId : String;
	var clients : Float;
	var maxClients : Float;
	@:optional
	var metadata : Dynamic;
};
typedef Clock = Dynamic;
typedef Storage = Dynamic;