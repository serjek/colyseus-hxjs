package colyseus.server;

@:jsRequire("colyseus","Client")
extern class Client extends websocket.Ws.WebSocket {
    @:optional var upgradeReq: js.node.http.IncomingMessage;
    var id: String;
    var options: Dynamic;
    var sessionId: String;
    var pingCount: Int;
    @:optional var remote: Bool;
    @:optional var auth: Dynamic;
}