import Foundation
import Server
import Requests
import Router

let httpParser = RequestParser()
let router = Router()
let server = Server(parser: httpParser, router: router)
server.run()
