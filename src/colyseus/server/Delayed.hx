package colyseus.server;

@:jsRequire("colyseus", "Delayed") extern class Delayed {
	function new(handler:haxe.Constraints.Function, args:Dynamic, time:Float, type:Float);
	var active : Bool;
	var paused : Bool;
	var time : Float;
	var elapsedTime : Float;
	private var handler : haxe.Constraints.Function;
	private var args : Dynamic;
	private var type : Float;
	function tick(deltaTime:Float):Void;
	function execute():Void;
	function reset():Void;
	function pause():Void;
	function resume():Void;
	function clear():Void;
	static var prototype : Delayed;
}