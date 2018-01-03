import Foundation
import Server
import Requests
import Router
import Values
import Actions

let data = DataStorage()
let action = HttpActions(dataStorage: data)
let httpParser = RequestParser()
let router = Router(action: action)
let server = Server(parser: httpParser, router: router)

router.addRoute(route: ("/", HttpMethod.get))
router.addRoute(route: ("/", HttpMethod.head))
router.addRoute(route: ("/", HttpMethod.put))
router.addRoute(route: ("/", HttpMethod.post))
router.addRoute(route: ("/form", HttpMethod.get))
router.addRoute(route: ("/form", HttpMethod.put))
router.addRoute(route: ("/form", HttpMethod.post))

server.run()
