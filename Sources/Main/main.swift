import Foundation
import Server
import Requests

let httpParser = RequestParser()
let server = Server(parser: httpParser)
server.run()
