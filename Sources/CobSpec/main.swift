import HttpServer

let dataStorage = DataStorage()
let httpParser = RequestParser()
let routesTable = RoutesTable()
let directoryNavigator = DirectoryNavigator()
let responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
let router = Router(routesTable: routesTable, responseGenerator: responseGenerator)
let server = Server(parser: httpParser, router: router)
let nullAction = NullAction(responseGenerator: responseGenerator)
let putAction = PutAction(responseGenerator: responseGenerator, dataStorage: dataStorage)
let postAction = PostAction(responseGenerator: responseGenerator, dataStorage: dataStorage)
let deleteAction = DeleteAction(responseGenerator: responseGenerator, dataStorage: dataStorage)
let displayDirectoryAction = DisplayDirectoryAction(directoryNavigator: directoryNavigator, responseGenerator: responseGenerator, dataStorage: dataStorage)

routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: displayDirectoryAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.post, action: postAction))

routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.post, action: postAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.delete, action: deleteAction))

routesTable.addRoute(route: Route(url: "/redirect", method: HttpMethod.get, action: RedirectAction(redirectPath: "/", responseGenerator:responseGenerator, dataStorage: dataStorage)))

routesTable.addRoute(route: Route(url: "/file1", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/text-file.txt", method: HttpMethod.get, action: nullAction))

routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.head, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.options, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.post, action: postAction))
routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.options,  action: nullAction))

server.run()
