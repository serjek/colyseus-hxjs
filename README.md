# colyseus-server-hx
Haxe externs for colyseus server

### Compiling server

```
git clone https://github.com/serjek/colyseus-server-hx
lix download
haxe server.hxml
cd bin/server
yarn
node index.js
```

### Compiling client to verify servrer is working

```
haxe client.hxml
```
open index.html in browser and observe server console.

TODO:
1. proper tests
2. example project
3. remove haxe-ws dependency from client lib as it is not maintaned anymore and, which is worse, compiles html.js websocket into js that is supposed to be nodejs app.