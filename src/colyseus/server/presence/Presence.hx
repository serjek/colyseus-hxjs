package colyseus.server.presence;

import js.lib.Promise;
import haxe.DynamicAccess;

typedef Presence = {
	// Pub/Sub
	function subscribe(topic:String, callback:haxe.Constraints.Function):Promise<Dynamic>;
	function unsubscribe(topic:String, ?callback:haxe.Constraints.Function):Dynamic;
	function publish(topic:String, data:Dynamic):Dynamic;
	function channels(?pattern:String):Promise<Array<String>>;

	// String operations
	function exists(key:String):Promise<Bool>;
	function set(key:String, value:String):Dynamic;
	function setex(key:String, value:String, seconds:Float):Dynamic;
	function expire(key:String, seconds:Float):Dynamic;
	function get(key:String):Dynamic;
	function del(key:String):Void;
	function incr(key:String):Promise<Int>;
	function decr(key:String):Promise<Int>;

	// Set operations
	function sadd(key:String, value:Dynamic):Dynamic;
	function smembers(key:String):Promise<Array<String>>;
	function sismember(key:String, field:String):Dynamic;
	function srem(key:String, value:Dynamic):Dynamic;
	function scard(key:String):Dynamic;
	function sinter(keys:haxe.extern.Rest<String>):Promise<Array<String>>;

	// Hash operations
	function hset(key:String, field:String, value:String):Promise<Bool>;
	function hincrby(key:String, field:String, value:Int):Promise<Int>;
	function hincrbyex(key:String, field:String, value:Int, expireInSeconds:Int):Promise<Int>;
	function hget(key:String, field:String):Promise<Null<String>>;
	function hgetall(key:String):Promise<DynamicAccess<String>>;
	function hdel(key:String, field:String):Promise<Bool>;
	function hlen(key:String):Promise<Int>;

	// List operations
	function llen(key:String):Promise<Int>;
	function rpush(key:String, values:haxe.extern.Rest<String>):Promise<Int>;
	function lpush(key:String, values:haxe.extern.Rest<String>):Promise<Int>;
	function rpop(key:String):Promise<Null<String>>;
	function lpop(key:String):Promise<Null<String>>;

	// Utility
	function setMaxListeners(number:Int):Void;
	function shutdown():Void;
};
