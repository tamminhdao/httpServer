import Foundation
import Server
import Requests
import Router
import Route
import Values
import Actions

let data = DataStorage()
let httpParser = RequestParser()
let routesTable = RoutesTable()
let router = Router(routesTable: routesTable)
let server = Server(parser: httpParser, router: router)
let nullAction = NullAction()
let putAction = PutAction(dataStorage: data)
let postAction = PostAction(dataStorage: data)

routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.post, action: postAction))

routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.post, action: postAction))

routesTable.addRoute(route: Route(url: "/file1", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/text-file.txt", method: HttpMethod.get, action: nullAction))

routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.head, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.options, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.post, action: postAction))
routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.options, action: nullAction))

server.run()
