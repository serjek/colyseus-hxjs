package colyseus.server.matchmaker;

import js.node.events.EventEmitter;

@:jsRequire("colyseus", "RegisteredHandler")
extern class RegisteredHandler extends EventEmitter<RegisteredHandler> {
	var klass:Dynamic;
	var options:Dynamic;
	var name:String;
	var filterOptions:Array<String>;
	var sortOptions:Dynamic;
	var realtimeListingEnabled:Bool;

	function new(klass:Dynamic, ?options:Dynamic);

	function filterBy(options:Array<String>):RegisteredHandler;
	function sortBy(options:Dynamic):RegisteredHandler;
	function enableRealtimeListing():RegisteredHandler;
	function getFilterOptions(options:Dynamic):Dynamic;
	function getMetadataFromOptions(options:Dynamic):Dynamic;
}
