package colyseus.server.schema;

@:jsRequire("@colyseus/schema","Schema")
extern class Schema {
    public var prototype:Dynamic;
}

/*
@:jsRequire("@colyseus/schema")
extern class SchemaDecorator {
    public static function type(type:String):PropertyDecorator;
}

typedef PropertyDecorator = Dynamic->String->Void;
*/