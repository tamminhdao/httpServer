import Foundation
import Server
import Requests
import Router
import Values

let data = DataStorage()
let httpParser = RequestParser()
let router = Router(data: data)
let server = Server(parser: httpParser, router: router)
server.run()
