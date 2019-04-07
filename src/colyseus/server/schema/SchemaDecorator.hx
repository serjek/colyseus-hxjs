package colyseus.server.schema;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

typedef DecoratedField = {
  field: Field,
  meta: MetadataEntry
};
#end

@:jsRequire("@colyseus/schema")
extern class ExternDecorator {
    public static function type(type:String):PropertyDecorator;
}

typedef PropertyDecorator = Dynamic->String->Void;

class Decorator {
  #if macro
  static public function build() {
    var fields = Context.getBuildFields();
    var decorated = getDecoratedFields(fields);
    if (decorated.length > 0) emitInit(fields, decorated);
    return fields;
  }
  
  static function emitInit(
    fields: Array<Field>, 
    decorated: Array<DecoratedField>
  ) {
    fields.push({
      name: '__init__',
      access: [AStatic, APrivate],
      kind: FFun({
				args: [],
				ret: macro :Void,
        expr: macro {
        	$b{decorated.map(emitDecoration)}
				}
			}),
      pos: Context.currentPos()
    });
  }
  
  static function emitDecoration(params: DecoratedField) {
    var localClass = Context.getLocalClass().get();
    return macro ExternDecorator.type($e{params.meta.params[0]})(untyped ($i{localClass.name}).prototype, $v{params.field.name});
  }
  
  static function getDecoratedFields(fields: Array<Field>) {
    return fields.map(getDecoration).filter(notNull);
  }
  
  static function getDecoration(field: Field): DecoratedField {
    for (meta in field.meta) {
      if (meta.name == ':type') return {
        field: field,
        meta: meta
      };
    }
    return null;
  }
  
  static function notNull(v: Dynamic) {
    return v != null;
  }
  #end
}

@:autoBuild(colyseus.server.schema.SchemaDecorator.Decorator.build())
interface ISchema {}
