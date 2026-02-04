package colyseus.server;
import haxe.DynamicAccess;

@:jsRequire('express')
extern class Express {
	@:selfCall static function create():Express;
	@:overload(function(?path:String, auth:ExpressAuth, what:Dynamic):Void {})
	function use(?path:String, what:Dynamic):Void;
	function get(path:String, handler:Dynamic):Void;
}

@:jsRequire('express-basic-auth')
extern class ExpressAuth {
	@:selfCall static function create(config:ExpressAuthConfig):ExpressAuth;
}

typedef ExpressAuthConfig = {
	final users:DynamicAccess<String>;
	final challenge:Bool;
}