import Foundation
import Server
import Requests
import Router
import Values
import Actions

let data = DataStorage()
let httpParser = RequestParser()
let router = Router()
let server = Server(parser: httpParser, router: router)
let nullAction = NullAction(dataStorage: data)

router.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
router.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
//router.addRoute(route: ("/", HttpMethod.put))
//router.addRoute(route: ("/", HttpMethod.post))
//router.addRoute(route: ("/form", HttpMethod.get))
//router.addRoute(route: ("/form", HttpMethod.put))
//router.addRoute(route: ("/form", HttpMethod.post))

server.run()
