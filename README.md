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
- what is lix? lix is haxe package manager alternative to haxelib: https://github.com/lix-pm/lix.client

### Compiling client to verify server is working

```
haxe client.hxml
cd bin/client
yarn
node index.js
```

TODO:
1. proper tests
2. example project
