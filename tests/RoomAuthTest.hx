import colyseus.server.Client;
import colyseus.server.Room;
import colyseus.server.Room.AuthContext;
import colyseus.server.Room.RoomAuth;
import colyseus.server.Room.RoomOptions;
import haxe.extern.EitherType;
import js.Node;
import js.html.Headers;
import js.lib.Error;
import js.lib.Promise;

private typedef JoinOptions = {final userId:Int;}
private typedef Authorization = {final userId:Int;}

private class AuthRoom extends Room {
	@:native("onAuth") public static var onAuthStatic:RoomAuth<JoinOptions, Authorization>;
}

private class LegacyAuthRoom extends Room {
	override function onAuth(client:Client, ?options:RoomOptions, context:AuthContext):EitherType<Bool, Promise<Dynamic>>
		return true;
}

class RoomAuthTest {
	static function check(value:Bool, message:String):Void {
		if (!value) throw new Error(message);
	}

	static function main() {
		final headers = new Headers();
		headers.set('x-auth-test', 'typed');
		final context:AuthContext = {headers: headers, ip: null};
		AuthRoom.onAuthStatic = (token, options, context) -> {
			check(token == null, 'Cookie authentication can omit the bearer token');
			check(context.headers.get('x-auth-test') == 'typed', 'AuthContext exposes Fetch Headers');
			check(context.ip == null, 'The transport can omit the peer address');
			return Promise.resolve({userId: options.userId});
		};
		check(Reflect.isFunction(Room.onAuthStatic), 'The base static alias reads the runtime onAuth method');
		check(!Reflect.hasField(AuthRoom, 'onAuthStatic'), 'The Haxe alias is emitted as onAuth');
		final runtimeHook:RoomAuth<JoinOptions, Authorization> = Reflect.field(AuthRoom, 'onAuth');
		runtimeHook(null, {userId: 42}, context).then(auth -> {
			check(auth.userId == 42, 'The static hook returns the typed authorization');
			check((cast new LegacyAuthRoom().onAuth(null, null, context):Bool), 'The instance authentication hook remains usable');
			AuthRoom.onAuthStatic = (_, _, _) -> Promise.reject(new Error('denied'));
			final rejectedHook:RoomAuth<JoinOptions, Authorization> = Reflect.field(AuthRoom, 'onAuth');
			return rejectedHook('invalid', {userId: 42}, context).then(_ -> {
				throw new Error('Rejected authentication must remain rejected');
			}, error -> {
				check(error.message == 'denied', 'Authentication errors reach the caller');
				Sys.println('PASS static and instance room authentication');
			});
		}).catchError(error -> {
			Node.console.error(error);
			Node.process.exitCode = 1;
		});
	}
}
