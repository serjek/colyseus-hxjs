package;
import colyseus.server.*;
import js.node.Http;

class MainServer {
	static function main() {
		var s = new Server({server:Http.createServer()});
		s.listen(2567);
	}
}