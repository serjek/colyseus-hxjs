package colyseus.server.schema;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

typedef DecoratedField = {
	field:Field,
	meta:MetadataEntry
};

#end
@:jsRequire("@colyseus/schema", "Schema")
@:autoBuild(colyseus.server.schema.Schema.Decorator.build())
extern class Schema {}

@:jsRequire("@colyseus/schema", "ArraySchema")
extern class ArraySchema<T> extends Array<T>{
	public function new(rest:haxe.extern.Rest<T>);
}

@:jsRequire("@colyseus/schema", "MapSchema")
private extern class MapSchemaImpl<T> extends haxe.ds.StringMap<T>{
	public function new(?items:Any);
}

#if !macro
@:forward
abstract MapSchema<T>(MapSchemaImpl<T>) from MapSchemaImpl<T> to MapSchemaImpl<T> {
	inline public function new(?items:Any) this = new MapSchemaImpl<T>(items);

	inline public function set<T>(k:String, v:T):Void {
		js.Syntax.code('{0}[{1}] = {2}', this, k, v);
	}

	inline public function get<T>(k:String):T
		return js.Syntax.code('{0}[{1}]', this, k);

	inline public function delete<T>(k:String):Void {
		js.Syntax.code('delete {0}[{1}]', this, k);
	}

	inline public function keys<T>():Array<String>
		return js.Syntax.code('Object.keys({0})', this);
}
#end

@:jsRequire("@colyseus/schema")
extern class ExternDecorator {
	public static function type(type:SchemaType):PropertyDecorator;
}

typedef PropertyDecorator = Dynamic->String->Void;

class Decorator {
	#if macro
	static public function build() {
		var fields = Context.getBuildFields();
		var decorated = getDecoratedFields(fields);
		if (decorated.length > 0)
			emitInit(fields, decorated);

		return fields;
	}

	static function emitInit(fields:Array<Field>, decorated:Array<DecoratedField>)
		fields.push({
			name: '__init__',
			access: [AStatic, APrivate],
			kind: FFun({
				args: [],
				ret: macro:Void,
				expr: macro {
					$b{decorated.map(emitDecoration)}
				}
			}),
			pos: Context.currentPos()
		});

	static function emitDecoration(params:DecoratedField) {
		var localClass = Context.getLocalClass().get();
		return macro ExternDecorator.type($e{params.meta.params[0]})(untyped ($i{localClass.name}).prototype, $v{params.field.name});
	}

	static function getDecoratedFields(fields:Array<Field>)
		return fields.map(getDecoration).filter(notNull);

	static function getDecoration(field:Field):DecoratedField {
		for (meta in field.meta) {
			if (meta.name == ':type')
				return {
					field: field,
					meta: meta
				};
		}
		return null;
	}

	static function notNull(v:Dynamic)
		return v != null;
	#end
}

typedef SchemaType = Dynamic;

// TODO one of: TypePrimitive, [TypePrimitive], [Dynamic], {map:Dynamic}

@:enum abstract TypePrimitive(String) from String to String {
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
