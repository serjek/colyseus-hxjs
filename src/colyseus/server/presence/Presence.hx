package colyseus.server.presence;
import js.lib.Promise;

typedef Presence = {
	function subscribe(topic:String, callback:haxe.Constraints.Function):Dynamic;
	function unsubscribe(topic:String):Dynamic;
	function publish(topic:String, data:Dynamic):Dynamic;
	function exists(roomId:String):Promise<Bool>;
	function setex(key:String, value:String, seconds:Float):Dynamic;
	function get(key:String):Dynamic;
	function del(key:String):Void;
	function sadd(key:String, value:Dynamic):Dynamic;
	function smembers(key:String):Dynamic;
	function srem(key:String, value:Dynamic):Dynamic;
	function scard(key:String):Dynamic;
	function hset(roomId:String, key:String, value:String):Dynamic;
	function hget(roomId:String, key:String):Promise<String>;
	function hdel(roomId:String, key:String):Dynamic;
	function hlen(roomId:String):Promise<Float>;
	function incr(key:String):Dynamic;
	function decr(key:String):Dynamic;
};
