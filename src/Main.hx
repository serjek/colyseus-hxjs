package;
import colyseus.server.*;
import js.node.Http;

class Main {
	static function main() {
		var s = new Server({server:Http.createServer()});
		s.listen(2567);
	}
}