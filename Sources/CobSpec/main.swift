import HttpServer

let dataStorage = DataStorage()
let httpParser = RequestParser()
let routesTable = RoutesTable()
let responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
let router = Router(routesTable: routesTable, responseBuilder: responseBuilder)
let commandLineReader = CommandLineReader(args: CommandLine.arguments)
let port = try commandLineReader.getPort()
let directory = try commandLineReader.getDirectory()
let server = Server(port: port, directory: directory, router: router, dataStorage: dataStorage)
let directoryNavigator = DirectoryNavigator(directoryPath: directory)

let nullAction = NullAction(routesTable: routesTable, dataStorage: dataStorage)
let putAction = PutAction(routesTable: routesTable, dataStorage: dataStorage)
let postAction = PostAction(routesTable: routesTable, dataStorage: dataStorage)
let deleteAction = DeleteAction(routesTable: routesTable, dataStorage: dataStorage)
let directoryListingAction = DirectoryListingAction(directoryNavigator: directoryNavigator, routesTable: routesTable, dataStorage: dataStorage)
let redirectAction = RedirectAction(redirectPath: "/", routesTable: routesTable, dataStorage: dataStorage)
let logRequestsAction = LogRequestsAction(routesTable: routesTable, dataStorage: dataStorage)
let returnCookieInfoAction = ReturnCookieInfoAction(routesTable: routesTable, dataStorage: dataStorage)
let urlDecodeAction = UrlDecodeAction(routesTable: routesTable, dataStorage: dataStorage)

routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: directoryListingAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.post, action: postAction))

routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.post, action: postAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.delete, action: deleteAction))


routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.head, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.options, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.post, action: postAction))
routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.options,  action: nullAction))

routesTable.addRoute(route: Route(url: "/redirect", method: HttpMethod.get, action: redirectAction))
routesTable.addRoute(route: Route(url:"/logs", method: HttpMethod.get, action: logRequestsAction, realm: "basic-auth", credentials: "YWRtaW46aHVudGVyMg=="))
routesTable.addRoute(route: Route(url:"/cookie", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url:"/eat_cookie", method: HttpMethod.get, action: returnCookieInfoAction))
routesTable.addRoute(route: Route(url:"/parameters", method: HttpMethod.get, action: urlDecodeAction))

server.run()
