package colyseus.server.schema;

import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;

typedef DecoratedField = {
	field:Field,
	meta:MetadataEntry
};

class Decorator {
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
		return switch params.meta.name {
			case ':type': macro ExternDecorator.type($e{params.meta.params[0]})(untyped ($i{localClass.name}).prototype, $v{params.field.name});
			case ':view': macro ExternDecorator.view($e{params.meta.params[0]})(untyped ($i{localClass.name}).prototype, $v{params.field.name});
			case _: null;
		}
	}

	static function getDecoratedFields(fields:Array<Field>)
		return fields.map(getDecoration).flatten();

	static function getDecoration(field:Field):Array<DecoratedField>
		return [
			for (meta in field.meta)
				if (meta.name == ':type' || meta.name == ':view')
					{field: field, meta: meta}
		];
}
