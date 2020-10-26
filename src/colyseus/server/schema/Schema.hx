package colyseus.server.schema;
import haxe.extern.EitherType;
import colyseus.server.Client;

@:jsRequire("@colyseus/schema", "Schema")
@:autoBuild(colyseus.server.schema.Decorator.build())
extern class Schema {
	public function new();
	public function assign(data:Dynamic):Void;
}

#if !macro
@:jsRequire("@colyseus/schema", "ArraySchema")
extern class ArraySchema<T> extends Array<T>{

}

//NOTE add `using js.lib.HaxeIterator;` to a module where iteration over keys() or values() is used
@:jsRequire("@colyseus/schema", "MapSchema")
extern class MapSchema<T> extends js.lib.Map<String,T> {

}

#end

@:jsRequire("@colyseus/schema")
extern class ExternDecorator {
	public static function type(type:SchemaType):PropertyDecorator;
	public static function filter(cb:FilterCallback):PropertyDecorator;
}

typedef PropertyDecorator = Dynamic->String->Void;

/**
 * see FilterCallback in @colyseus/schema/annotations.d.ts
 * Usage in externs:
 *
	@:type(STRING)
	@:filter(function(client, value:String, inst:RootSchema) {
		trace(client.id, client.sessionId);
		trace(value);
		trace(Reflect.fields(inst)); //fields of instance if class where field is annotated
		return true; //or false of value should be filtered
	})
	var someField:String;
 */

//NOTE
//It is important to specify concrete types in your filter functions
//or compiler will do weird things, as it usually happens with Dynamic type
typedef FilterCallback = Client -> Value -> Inst -> Bool;
private typedef Value = Dynamic;
private typedef Inst = Dynamic;

typedef SchemaType = Dynamic;

//TODO - strict type check in schema type:
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
	var FLOAT32 = "float32"; // single-precision floating-point number	-3.40282347e+38 to 3.40282347e+38
	var FLOAT64 = "float64"; // double-precision floating-point number	-1.7976931348623157e+308 to 1.7976931348623157e+308
}
