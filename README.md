# colyseus-hxjs

Haxe externs for [colyseus](https://colyseus.io/) server and client to compile into js/nodejs/react/react-native projects.

Note that since ES6 code is required you should use haxe no earlier than 4.0.0-rc.3

[Examples](https://github.com/serjek/colyseus-hxjs-examples)

### Enabling Express and Monitor

Have @colyseus/monitor installed along with colyseus and declare externs, like so:
```haxe
@:jsRequire('express')
extern class Express {
  @:selfCall static function create():Express;
  function use(path:String, what:Dynamic):Void;
}

@:jsRequire('@colyseus/monitor','monitor')
extern class Monitor {
  @:selfCall static function create():Monitor;
}
```

Use externs with server init:
```haxe
public function new() {
  var app:Express = Express.create();
  var server:Server = new Server({
    server: Http.createServer(cast app),
    express: app
  });

  app.use('/colyseus', Monitor.create());
  server.listen(2567);
};
```
