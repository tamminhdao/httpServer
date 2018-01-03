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
let putAction = PutAction(dataStorage: data)

router.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
router.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
router.addRoute(route: Route(url: "/", method: HttpMethod.put, action: putAction))
router.addRoute(route: Route(url: "/", method: HttpMethod.post, action: putAction))
router.addRoute(route:  Route(url: "/form", method: HttpMethod.get, action: nullAction))
router.addRoute(route: Route(url: "/form", method: HttpMethod.put, action: putAction))
router.addRoute(route: Route(url: "/form", method: HttpMethod.post, action: putAction))

server.run()
