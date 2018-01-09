import Foundation
import Server
import Requests
import Responses
import Router
import Route
import Values
import Actions

let data = DataStorage()
let httpParser = RequestParser()
let routesTable = RoutesTable()
let responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: data)
let router = Router(routesTable: routesTable, responseGenerator: responseGenerator)
let server = Server(parser: httpParser, router: router)
let nullAction = NullAction()
let putAction = PutAction(dataStorage: data)
let postAction = PostAction(dataStorage: data)
let deleteAction = DeleteAction(dataStorage: data)

router.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
router.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
router.addRoute(route: Route(url: "/", method: HttpMethod.put, action: putAction))
router.addRoute(route: Route(url: "/", method: HttpMethod.post, action: postAction))
router.addRoute(route: Route(url: "/form", method: HttpMethod.get, action: nullAction))
router.addRoute(route: Route(url: "/form", method: HttpMethod.put, action: putAction))
router.addRoute(route: Route(url: "/form", method: HttpMethod.post, action: postAction))
router.addRoute(route: Route(url: "/form", method: HttpMethod.delete, action: postAction))
router.addRoute(route: Route(url: "/method_options", method: HttpMethod.head, action: nullAction))
router.addRoute(route: Route(url: "/method_options", method: HttpMethod.get, action: nullAction))
router.addRoute(route: Route(url: "/method_options", method: HttpMethod.put, action: putAction))
router.addRoute(route: Route(url: "/method_options", method: HttpMethod.options, action: nullAction))
router.addRoute(route: Route(url: "/method_options", method: HttpMethod.post, action: postAction))
router.addRoute(route: Route(url: "/method_options2", method: HttpMethod.get, action: nullAction))
router.addRoute(route: Route(url: "/method_options2", method: HttpMethod.options, action: nullAction))

server.run()
