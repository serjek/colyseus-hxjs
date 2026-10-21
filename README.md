# colyseus-hxjs

Haxe externs for [Colyseus](https://colyseus.io/) v0.18 multiplayer framework (`colyseus` + `@colyseus/schema` v5).

Write Colyseus servers in Haxe and compile to Node.js via `haxe ... -js server.js`.

## Target versions

- Colyseus **v0.18.x**
- @colyseus/schema **v5.x**

## Server externs

| Module | Provides |
|---|---|
| `colyseus.server.Colyseus` | `defineServer`, `defineRoom`, `Server`, `createRouter`, `createEndpoint`, `monitor`, `playground` |
| `colyseus.server.Room` | `RoomOf<State, Metadata, Options>`, `Room`, `RoomAuth<Options, Auth>`, `Clock`, `CloseCode`, `ErrorCode`, `AuthContext` |
| `colyseus.server.Client` | `Client`, `ClientState`, `ClientArray`, `SendOptions` |
| `colyseus.server.schema.Schema` | `Schema`, `ArraySchema`, `MapSchema`, `SetSchema`, `CollectionSchema`, `StateView` |
| `colyseus.server.schema.Decorator` | Build macro -- `@:type` and `@:view` metadata on Schema fields |
| `colyseus.server.presence.Presence` | `Presence` typedef (Redis-like pub/sub, hash, list ops) |
| `colyseus.server.MatchMaker` | `matchMaker` static methods, `SeatReservation` |
| `colyseus.server.matchmaker.RegisteredHandler` | Room handler registration with `filterBy` / `sortBy` |
| `colyseus.server.Delayed` | Timer tasks from `@colyseus/timer` |
| `colyseus.server.LobbyRoom` | Built-in lobby room |

## Static room authentication

Colyseus 0.18 calls static `onAuth(token, options, context)` before creating a room or
reserving a seat. Haxe cannot give a static field and an instance method the same name,
so the extern exposes the static hook as `onAuthStatic`, mapped to JavaScript `onAuth`.
The existing instance `onAuth(client, options, context)` remains available.

Haxe does not inherit static fields. Declare the hook on each concrete room class:

```haxe
import colyseus.server.Room;
import colyseus.server.Room.RoomAuth;

typedef JoinOptions = {final name:String;}
typedef PlayerAuth = {final userId:Int;}

class GameRoom extends Room {
    @:native("onAuth") public static var onAuthStatic:RoomAuth<JoinOptions, PlayerAuth>;
}

// During server setup, assign your verifier returning Promise<PlayerAuth>:
GameRoom.onAuthStatic = authenticate;
```

`context.headers` is the Fetch `Headers` object (`get`, `has`, `entries`, etc.).
`context.ip` is a nullable string when the transport has no peer address.

## Schema decorators

Schema fields use Haxe metadata processed by a build macro (`@:autoBuild`):

```haxe
class PlayerState extends Schema {
    @:type(NUMBER) public var x:Float;
    @:type(STRING) public var name:String;

    @:type(INT32) @:view public var score:Int;       // view-filtered (default tag)
    @:type(STRING) @:view(1) public var secret:String; // view-filtered (tag 1)
}
```

The macro emits runtime `type()` / `view()` decorator calls on the JS prototype at class init.

## Examples

See [colyseus-hxjs-examples](https://github.com/serjek/colyseus-hxjs-examples) for working rooms:

- **ChatRoom** -- messaging, `broadcast`, `onMessage` callback
- **StateHandlerRoom** -- `MapSchema` state, player tracking, `allowReconnection`
- **ViewRoom** -- `@:view` decorators, `StateView` per-client, conditional view grant based on score
- **NotAllowedRoom** -- async `onJoin` rejection

Build & run:
```bash
haxe server.hxml        # compile to bin/server/index.js
node ./bin/server        # start on port 2567
```
