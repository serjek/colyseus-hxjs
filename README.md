# colyseus-hxjs
Haxe externs for colyseus server and client to compile into js/nodejs/react/react-native projects

### Download
```
git clone https://github.com/serjek/colyseus-hxjx
```
### Compile and run server
```
lix download
haxe server.hxml
cd bin/server
yarn
node index.js
```
- what is lix? lix is haxe package manager alternative to haxelib: https://github.com/lix-pm/lix.client

### Compile and run client(s)
```
haxe client.hxml
cd bin/client
yarn
node index.js
```

TODO:
1. proper tests
2. example project
