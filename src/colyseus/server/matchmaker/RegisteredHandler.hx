package colyseus.server.matchmaker;
import js.node.events.EventEmitter;
import colyseus.server.Room;

@:jsRequire("colyseus","RegisteredHandler")
extern class RegisteredHandler<T> extends EventEmitter<Dynamic> {
	var klass : RoomConstructor<T>;
	var options : Dynamic;
	function new(klass:RoomConstructor<T>, options:Dynamic):Void;
}
