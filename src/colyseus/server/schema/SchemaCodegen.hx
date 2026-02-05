package colyseus.server.schema;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;

using StringTools;
using Lambda;

/**
 * Generates TypeScript schema stubs for use with `npx schema-codegen`.
 *
 * Usage in your .hxml file:
 *   -D schema-codegen-output=generated/schemas
 *   --macro colyseus.server.schema.SchemaCodegen.generate()
 *
 * Then run:
 *   npx schema-codegen generated/schemas/*.ts --haxe --output client/schemas/
 *   # or --csharp, --cpp, --ts, --js, etc.
 */
class SchemaCodegen {
    static var processedClasses:Map<String, Bool> = new Map();
    static var schemaClasses:Array<{name:String, fullName:String, fields:Array<FieldInfo>, parent:String}> = [];

    public static function generate():Void {
        Context.onAfterTyping(onAfterTyping);
    }

    static function onAfterTyping(modules:Array<ModuleType>):Void {
        var outputDir = Context.definedValue("schema-codegen-output");
        if (outputDir == null) {
            Context.warning("SchemaCodegen: No output directory specified. Use -D schema-codegen-output=path/to/output", Context.currentPos());
            return;
        }

        // Collect all Schema subclasses
        for (module in modules) {
            switch (module) {
                case TClassDecl(classRef):
                    var classType = classRef.get();
                    if (isSchemaSubclass(classType) && !processedClasses.exists(classType.name)) {
                        processedClasses.set(classType.name, true);
                        var info = extractSchemaInfo(classType);
                        if (info != null) {
                            schemaClasses.push(info);
                        }
                    }
                default:
            }
        }

        if (schemaClasses.length == 0) {
            return;
        }

        // Ensure output directory exists
        ensureDirectory(outputDir);

        // Generate a single combined TypeScript file with all schemas
        var tsContent = generateCombinedTypeScript();
        var filePath = '${outputDir}/schemas.ts';
        File.saveContent(filePath, tsContent);

        Context.info('SchemaCodegen: Generated ${filePath} with ${schemaClasses.length} schema(s)', Context.currentPos());
    }

    static function isSchemaSubclass(classType:ClassType):Bool {
        if (classType.superClass == null) return false;

        var superClass = classType.superClass.t.get();
        if (superClass.name == "Schema" && superClass.pack.join(".") == "colyseus.server.schema") {
            return true;
        }

        // Check recursively for indirect inheritance
        return isSchemaSubclass(superClass);
    }

    static function extractSchemaInfo(classType:ClassType):{name:String, fullName:String, fields:Array<FieldInfo>, parent:String} {
        var fields:Array<FieldInfo> = [];

        for (field in classType.fields.get()) {
            var typeMetaValue:String = null;
            var hasView = false;
            var viewTag:Null<Int> = null;

            for (meta in field.meta.get()) {
                if (meta.name == ":type" && meta.params != null && meta.params.length > 0) {
                    typeMetaValue = exprToTypeString(meta.params[0]);
                }
                if (meta.name == ":view") {
                    hasView = true;
                    if (meta.params != null && meta.params.length > 0) {
                        viewTag = exprToInt(meta.params[0]);
                    }
                }
            }

            if (typeMetaValue != null) {
                fields.push({
                    name: field.name,
                    schemaType: typeMetaValue,
                    hasView: hasView,
                    viewTag: viewTag
                });
            }
        }

        if (fields.length == 0) return null;

        var parent = "Schema";
        if (classType.superClass != null) {
            var superClass = classType.superClass.t.get();
            if (superClass.name != "Schema") {
                parent = superClass.name;
            }
        }

        return {
            name: classType.name,
            fullName: classType.pack.concat([classType.name]).join("."),
            fields: fields,
            parent: parent
        };
    }

    static function exprToTypeString(expr:Expr):String {
        return switch (expr.expr) {
            case EConst(CIdent(s)):
                // Handle TypePrimitive enum values like NUMBER, STRING, etc.
                typeIdentToString(s);
            case EConst(CString(s)):
                s;
            case EObjectDecl(fields):
                // Handle {map: Type} or {array: Type}
                var parts:Array<String> = [];
                for (f in fields) {
                    var key = f.field;
                    var value = exprToTypeString(f.expr);
                    parts.push('$key: $value');
                }
                '{ ${parts.join(", ")} }';
            case EArrayDecl(values):
                // Handle [Type]
                if (values.length > 0) {
                    '[ ${exprToTypeString(values[0])} ]';
                } else {
                    "[]";
                }
            case EField(e, field):
                // Handle TypePrimitive.NUMBER style access
                typeIdentToString(field);
            default:
                // Fallback: try to print the expression
                haxe.macro.ExprTools.toString(expr);
        };
    }

    static function typeIdentToString(ident:String):String {
        // Map Haxe TypePrimitive enum values to TypeScript schema type strings
        return switch (ident) {
            case "STRING": '"string"';
            case "NUMBER": '"number"';
            case "BOOLEAN": '"boolean"';
            case "INT8": '"int8"';
            case "UINT8": '"uint8"';
            case "INT16": '"int16"';
            case "UINT16": '"uint16"';
            case "INT32": '"int32"';
            case "UINT32": '"uint32"';
            case "INT64": '"int64"';
            case "UINT64": '"uint64"';
            case "FLOAT32": '"float32"';
            case "FLOAT64": '"float64"';
            case "BIGINT64": '"bigint64"';
            case "BIGUINT64": '"biguint64"';
            default: ident; // Assume it's a class reference
        };
    }

    static function exprToInt(expr:Expr):Null<Int> {
        return switch (expr.expr) {
            case EConst(CInt(v)): Std.parseInt(v);
            default: null;
        };
    }

    static function generateCombinedTypeScript():String {
        var buf = new StringBuf();

        buf.add('// Auto-generated by colyseus.server.schema.SchemaCodegen\n');
        buf.add('// Do not edit manually - regenerate by running: haxe server.hxml\n');
        buf.add('//\n');
        buf.add('// Usage: npx schema-codegen <this-file> --haxe --output client/schemas/\n');
        buf.add('//        or: --csharp, --cpp, --ts, --js, etc.\n\n');

        // Collect all imports needed
        var imports:Array<String> = ["Schema", "type"];
        var hasView = false;
        var hasMapSchema = false;
        var hasArraySchema = false;
        var hasSetSchema = false;
        var hasCollectionSchema = false;

        for (schema in schemaClasses) {
            for (field in schema.fields) {
                if (field.hasView) hasView = true;
                if (field.schemaType.indexOf("map:") >= 0) hasMapSchema = true;
                if (field.schemaType.indexOf("array:") >= 0 || field.schemaType.startsWith("[")) hasArraySchema = true;
                if (field.schemaType.indexOf("set:") >= 0) hasSetSchema = true;
                if (field.schemaType.indexOf("collection:") >= 0) hasCollectionSchema = true;
            }
        }

        if (hasView) imports.push("view");
        if (hasMapSchema) imports.push("MapSchema");
        if (hasArraySchema) imports.push("ArraySchema");
        if (hasSetSchema) imports.push("SetSchema");
        if (hasCollectionSchema) imports.push("CollectionSchema");

        buf.add('import { ${imports.join(", ")} } from "@colyseus/schema";\n\n');

        // Sort classes so parent classes come first
        var sorted = sortByDependency(schemaClasses);

        for (schema in sorted) {
            buf.add(generateSchemaClass(schema));
            buf.add('\n');
        }

        return buf.toString();
    }

    static function sortByDependency(classes:Array<{name:String, fullName:String, fields:Array<FieldInfo>, parent:String}>):Array<{name:String, fullName:String, fields:Array<FieldInfo>, parent:String}> {
        // Simple topological sort - parent classes before children
        var result:Array<{name:String, fullName:String, fields:Array<FieldInfo>, parent:String}> = [];
        var added:Map<String, Bool> = new Map();

        function addWithDeps(schema:{name:String, fullName:String, fields:Array<FieldInfo>, parent:String}) {
            if (added.exists(schema.name)) return;

            // Add parent first if it's one of our schema classes
            if (schema.parent != "Schema") {
                for (s in classes) {
                    if (s.name == schema.parent) {
                        addWithDeps(s);
                        break;
                    }
                }
            }

            // Add referenced types
            for (field in schema.fields) {
                var refType = extractReferencedType(field.schemaType);
                if (refType != null) {
                    for (s in classes) {
                        if (s.name == refType) {
                            addWithDeps(s);
                            break;
                        }
                    }
                }
            }

            added.set(schema.name, true);
            result.push(schema);
        }

        for (schema in classes) {
            addWithDeps(schema);
        }

        return result;
    }

    static function extractReferencedType(schemaType:String):String {
        // Extract type name from {map: TypeName} or [TypeName]
        var mapMatch = ~/\{\s*map:\s*(\w+)\s*\}/;
        if (mapMatch.match(schemaType)) {
            return mapMatch.matched(1);
        }
        var arrayMatch = ~/\[\s*(\w+)\s*\]/;
        if (arrayMatch.match(schemaType)) {
            return arrayMatch.matched(1);
        }
        return null;
    }

    static function generateSchemaClass(schema:{name:String, fullName:String, fields:Array<FieldInfo>, parent:String}):String {
        var buf = new StringBuf();

        buf.add('export class ${schema.name} extends ${schema.parent} {\n');

        for (field in schema.fields) {
            var tsType = schemaTypeToTsType(field.schemaType);
            var schemaTypeStr = schemaTypeToDecoratorArg(field.schemaType);

            // Add @type decorator
            buf.add('    @type($schemaTypeStr)\n');

            // Add @view decorator if present
            if (field.hasView) {
                if (field.viewTag != null) {
                    buf.add('    @view(${field.viewTag})\n');
                } else {
                    buf.add('    @view()\n');
                }
            }

            buf.add('    ${field.name}: $tsType;\n\n');
        }

        buf.add('}\n');

        return buf.toString();
    }

    static function schemaTypeToTsType(schemaType:String):String {
        // Handle primitive types
        if (schemaType == '"string"') return "string";
        if (schemaType == '"number"' || schemaType == '"float32"' || schemaType == '"float64"') return "number";
        if (schemaType == '"boolean"') return "boolean";
        if (schemaType.indexOf("int") >= 0 || schemaType.indexOf("uint") >= 0) return "number";
        if (schemaType.indexOf("bigint") >= 0) return "bigint";

        // Handle map types: { map: TypeName }
        var mapMatch = ~/\{\s*map:\s*(\w+)\s*\}/;
        if (mapMatch.match(schemaType)) {
            var innerType = mapMatch.matched(1);
            return 'MapSchema<$innerType>';
        }

        // Handle array types: [ TypeName ] or { array: TypeName }
        var arrayMatch = ~/\[\s*(\w+)\s*\]/;
        if (arrayMatch.match(schemaType)) {
            var innerType = arrayMatch.matched(1);
            return 'ArraySchema<$innerType>';
        }

        // Handle set types: { set: TypeName }
        var setMatch = ~/\{\s*set:\s*(\w+)\s*\}/;
        if (setMatch.match(schemaType)) {
            var innerType = setMatch.matched(1);
            return 'SetSchema<$innerType>';
        }

        // Handle collection types: { collection: TypeName }
        var collMatch = ~/\{\s*collection:\s*(\w+)\s*\}/;
        if (collMatch.match(schemaType)) {
            var innerType = collMatch.matched(1);
            return 'CollectionSchema<$innerType>';
        }

        // Assume it's a class reference
        return schemaType;
    }

    static function schemaTypeToDecoratorArg(schemaType:String):String {
        // For primitive types wrapped in quotes, just return as-is
        if (schemaType.startsWith('"')) {
            return schemaType;
        }

        // For object/array notation, convert to TypeScript format
        var mapMatch = ~/\{\s*map:\s*(\w+)\s*\}/;
        if (mapMatch.match(schemaType)) {
            var innerType = mapMatch.matched(1);
            return '{ map: $innerType }';
        }

        var arrayMatch = ~/\[\s*(\w+)\s*\]/;
        if (arrayMatch.match(schemaType)) {
            var innerType = arrayMatch.matched(1);
            return '[ $innerType ]';
        }

        var setMatch = ~/\{\s*set:\s*(\w+)\s*\}/;
        if (setMatch.match(schemaType)) {
            var innerType = setMatch.matched(1);
            return '{ set: $innerType }';
        }

        var collMatch = ~/\{\s*collection:\s*(\w+)\s*\}/;
        if (collMatch.match(schemaType)) {
            var innerType = collMatch.matched(1);
            return '{ collection: $innerType }';
        }

        return schemaType;
    }

    static function ensureDirectory(path:String):Void {
        var parts = path.split("/");
        var current = "";
        for (part in parts) {
            current = current == "" ? part : '$current/$part';
            if (!FileSystem.exists(current)) {
                FileSystem.createDirectory(current);
            }
        }
    }
}

typedef FieldInfo = {
    name:String,
    schemaType:String,
    hasView:Bool,
    viewTag:Null<Int>
};
#end
