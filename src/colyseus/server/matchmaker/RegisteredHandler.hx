package colyseus.server.matchmaker;
import js.node.events.EventEmitter;
import colyseus.server.Room;

@:jsRequire("colyseus","RegisteredHandler")
extern class RegisteredHandler extends EventEmitter<Dynamic> {
	var klass : RoomConstructor;
	var options : Dynamic;
	function new(klass:RoomConstructor, options:Dynamic):Void;
}
