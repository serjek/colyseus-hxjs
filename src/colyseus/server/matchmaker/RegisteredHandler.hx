package colyseus.server.matchmaker;
import js.node.events.EventEmitter;
import colyseus.server.Room;

@:jsRequire("colyseus","RegisteredHandler")
extern class RegisteredHandler extends EventEmitter<RegisteredHandler> {
	var klass : RoomConstructor;
	var options : Dynamic;
	var filterOptions: Array<String>;
    var sortOptions: SortOptions;
	function new(klass: RoomConstructor, options: Dynamic);
	
    function filterBy(options: Array<String>): RegisteredHandler;
    function sortBy(options: SortOptions): RegisteredHandler;
    function getFilterOptions(options: Dynamic): Array<String>;
}

enum abstract SortOptions(String) {
	final ascending;
	final descending;
}
