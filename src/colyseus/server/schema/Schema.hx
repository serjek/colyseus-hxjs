package colyseus.server.schema;

import haxe.extern.EitherType;

@:jsRequire("@colyseus/schema", "Schema")
@:autoBuild(colyseus.server.schema.Decorator.build())
extern class Schema {
	public function new();
	public function assign(data:Dynamic):Schema;
	public function clone():Schema;
	public function toJSON():Dynamic;
	public function restore(jsonData:Dynamic):Schema;
	public function setDirty(property:EitherType<String, Int>):Void;
	public function discardAllChanges():Void;

	public static function isSchema(obj:Dynamic):Bool;
}

#if !macro
@:jsRequire("@colyseus/schema", "ArraySchema")
extern class ArraySchema<T> {
	function new();
	var length:Int;

	// Mutating methods
	function push(values:haxe.extern.Rest<T>):Int;
	function pop():Null<T>;
	function shift():Null<T>;
	function unshift(items:haxe.extern.Rest<T>):Int;
	function splice(start:Int, ?deleteCount:Int, insertItems:haxe.extern.Rest<T>):ArraySchema<T>;
	function reverse():ArraySchema<T>;
	function sort(?compareFn:T->T->Int):ArraySchema<T>;
	function clear():Void;
	function move(cb:ArraySchema<T>->Void):ArraySchema<T>;
	function shuffle():ArraySchema<T>;

	// Access methods
	function at(index:Int):Null<T>;
	function slice(?start:Int, ?end:Int):ArraySchema<T>;
	function concat(items:haxe.extern.Rest<Dynamic>):ArraySchema<T>;
	function join(?separator:String):String;

	// Iteration methods
	function forEach(cb:T->Int->Void):Void;
	function map<U>(cb:T->Int->U):Array<U>;
	function filter(cb:T->Int->Bool):Array<T>;
	function find(predicate:T->Int->Bool):Null<T>;
	function findIndex(predicate:T->Int->Bool):Int;
	function every(predicate:T->Int->Bool):Bool;
	function some(predicate:T->Int->Bool):Bool;
	function indexOf(searchElement:T, ?fromIndex:Int):Int;
	function includes(searchElement:T, ?fromIndex:Int):Bool;
	function reduce<U>(cb:U->T->Int->U, initialValue:U):U;

	// Conversion
	function toArray():Array<T>;
	function toJSON():Array<Dynamic>;
	function clone(?isDecoding:Bool):ArraySchema<T>;
}

// NOTE: add `using js.lib.HaxeIterator;` to a module where iteration over keys() or values() is used
@:jsRequire("@colyseus/schema", "MapSchema")
extern class MapSchema<T> extends js.lib.Map<String, T> {
	function new();
	function toJSON():Dynamic;
	function clone(?isDecoding:Bool):MapSchema<T>;
}

@:jsRequire("@colyseus/schema", "SetSchema")
extern class SetSchema<T> {
	function new();
	var size:Int;

	function add(value:T):EitherType<Int, Bool>;
	function delete(item:T):Bool;
	function clear():Void;
	function has(value:T):Bool;
	function forEach(cb:T->Int->SetSchema<T>->Void):Void;
	function values():Dynamic; // MapIterator<T>
	function entries():Dynamic; // MapIterator<[Int, T]>
	function toArray():Array<T>;
	function toJSON():Array<Dynamic>;
	function clone(?isDecoding:Bool):SetSchema<T>;
}

@:jsRequire("@colyseus/schema", "StateView")
extern class StateView {
	var items:Array<Dynamic>;

	function new(?iterable:Bool);
	function add(obj:Dynamic, ?tag:Int, ?checkIncludeParent:Bool):Bool;
	function remove(obj:Dynamic, ?tag:Int):StateView;
	function has(obj:Dynamic):Bool;
	function hasTag(obj:Dynamic, ?tag:Int):Bool;
	function clear():Void;
}

@:jsRequire("@colyseus/schema", "CollectionSchema")
extern class CollectionSchema<T> {
	function new();
	var size:Int;

	function add(value:T):Int;
	function at(index:Int):Null<T>;
	function delete(item:T):Bool;
	function clear():Void;
	function has(value:T):Bool;
	function forEach(cb:T->Int->CollectionSchema<T>->Void):Void;
	function values():Dynamic; // MapIterator<T>
	function entries():Dynamic; // MapIterator<[Int, T]>
	function toArray():Array<T>;
	function toJSON():Array<Dynamic>;
	function clone(?isDecoding:Bool):CollectionSchema<T>;
}

#end

@:jsRequire("@colyseus/schema")
extern class ExternDecorator {
	public static function type(type:SchemaType):PropertyDecorator;
	public static function defineTypes(target:Dynamic, fields:Dynamic):Dynamic;
	public static function view(?tag:Int):PropertyDecorator;
	public static function schema(fieldsAndMethods:Dynamic, ?name:String, ?inherits:Dynamic):Dynamic;
}

typedef PropertyDecorator = Dynamic->String->Void;

typedef SchemaType = Dynamic;

// TODO - strict type check in schema type:
/*EitherType<TypePrimitive,
	EitherType<Array<TypePrimitive>,
		EitherType<Array<Dynamic>,
			EitherType<{map:TypePrimitive},{map:Dynamic}>
		>
	>
>;*/

enum abstract TypePrimitive(String) to String {
	var STRING = "string"; // utf8 strings	maximum byte size of 4294967295
	var NUMBER = "number"; // auto-detects the int or float type to be used. (adds an extra byte on output)	0 to 18446744073709551615
	var BOOLEAN = "boolean"; // true or false	0 or 1
	var INT8 = "int8"; // signed 8-bit integer	-128 to 127
	var UINT8 = "uint8"; // unsigned 8-bit integer	0 to 255
	var INT16 = "int16"; // signed 16-bit integer	-32768 to 32767
	var UINT16 = "uint16"; // unsigned 16-bit integer	0 to 65535
	var INT32 = "int32"; // signed 32-bit integer	-2147483648 to 2147483647
	var UINT32 = "uint32"; // unsigned 32-bit integer	0 to 4294967295
	var INT64 = "int64"; // signed 64-bit integer	-9223372036854775808 to 9223372036854775807
	var UINT64 = "uint64"; // unsigned 64-bit integer	0 to 18446744073709551615
	var FLOAT32 = "float32"; // single-precision floating-point	-3.40282347e+38 to 3.40282347e+38
	var FLOAT64 = "float64"; // double-precision floating-point	-1.7976931348623157e+308 to 1.7976931348623157e+308
	var BIGINT64 = "bigint64"; // signed 64-bit BigInt
	var BIGUINT64 = "biguint64"; // unsigned 64-bit BigInt
}
