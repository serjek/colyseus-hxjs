package colyseus.server;

@:jsRequire("colyseus","Server")
extern class Server {
    function new(options:ServerOptions);
    function listen(port:Int):Void;
}

//TODO all Dynamic should eventually go away
typedef ServerOptions = {
    server: js.node.http.Server,
    ?presence: Dynamic,
    ?verifyClient:Dynamic,
    ?gracefullyShutdown:Dynamic
}