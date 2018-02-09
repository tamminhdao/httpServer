import HttpServer

let dataStorage = DataStorage()
let httpParser = RequestParser()
let routesTable = RoutesTable()
let responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
let router = Router(routesTable: routesTable, responseGenerator: responseGenerator)
let commandLineReader = CommandLineReader(args: CommandLine.arguments)
let port = try commandLineReader.getPort()
let directory = try commandLineReader.getDirectory()
let server = Server(port: port, directory: directory, router: router, dataStorage: dataStorage)
let directoryNavigator = DirectoryNavigator(directoryPath: directory)

let nullAction = NullAction(responseGenerator: responseGenerator)
let putAction = PutAction(responseGenerator: responseGenerator, dataStorage: dataStorage)
let postAction = PostAction(responseGenerator: responseGenerator, dataStorage: dataStorage)
let deleteAction = DeleteAction(responseGenerator: responseGenerator, dataStorage: dataStorage)
let logRequestAction = LogRequestsAction(responseGenerator: responseGenerator)
let directoryListingAction = DirectoryListingAction(directoryNavigator: directoryNavigator, responseGenerator: responseGenerator)
let fetchFileAction = FetchFileAction(directoryNavigator: directoryNavigator, responseGenerator: responseGenerator)

routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: directoryListingAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/", method: HttpMethod.post, action: postAction))

routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.post, action: postAction))
routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.delete, action: deleteAction))

routesTable.addRoute(route: Route(url: "/redirect", method: HttpMethod.get, action: RedirectAction(redirectPath: "/", responseGenerator:responseGenerator, dataStorage: dataStorage)))

routesTable.addRoute(route: Route(url: "/file1", method: HttpMethod.get, action: fetchFileAction))
routesTable.addRoute(route: Route(url: "/file2", method: HttpMethod.get, action: fetchFileAction))
routesTable.addRoute(route: Route(url: "/partial_content.txt", method: HttpMethod.get, action: fetchFileAction))
routesTable.addRoute(route: Route(url: "/patch-content.txt", method: HttpMethod.get, action: fetchFileAction))
routesTable.addRoute(route: Route(url: "/text-file.txt", method: HttpMethod.get, action: fetchFileAction))

routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.head, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.put, action: putAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.options, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options", method: HttpMethod.post, action: postAction))
routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.get, action: nullAction))
routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.options,  action: nullAction))

routesTable.addRoute(route: Route(url:"/logs", method: HttpMethod.get, action: logRequestAction, realm: "basic-auth", credentials: "YWRtaW46aHVudGVyMg=="))

server.run()
