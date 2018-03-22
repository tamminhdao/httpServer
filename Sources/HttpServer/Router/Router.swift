public class Router {
    private var routesTable: RoutesTable
    private var responseBuilder: ResponseBuilder
    private var nullAction: NullAction
    private var putAction: PutAction
    private var postAction: PostAction
    private var deleteAction: DeleteAction
    private var directoryListingAction: DirectoryListingAction
    private var redirectAction: RedirectAction
    private var logRequestsAction: LogRequestsAction
    private var returnCookieInfoAction: ReturnCookieInfoAction
    private var urlDecodeAction: UrlDecodeAction

    public init(dataStorage: DataStorage, directoryNavigator: DirectoryNavigator) {
        self.routesTable = RoutesTable()
        self.responseBuilder = ResponseBuilder()
        self.nullAction = NullAction(routesTable: routesTable, dataStorage: dataStorage)
        self.putAction = PutAction(dataStorage: dataStorage)
        self.postAction = PostAction(dataStorage: dataStorage)
        self.deleteAction = DeleteAction(dataStorage: dataStorage)
        self.directoryListingAction = DirectoryListingAction(directoryNavigator: directoryNavigator, routesTable: routesTable)
        self.redirectAction = RedirectAction(redirectPath: "/", dataStorage: dataStorage)
        self.logRequestsAction = LogRequestsAction(dataStorage: dataStorage)
        self.returnCookieInfoAction = ReturnCookieInfoAction(dataStorage: dataStorage)
        self.urlDecodeAction = UrlDecodeAction(dataStorage: dataStorage)

        populateRoutesTable()
    }

    public func route(request: HttpRequest) -> HttpResponse {

        if let validMethod = request.returnMethod() {
            let requestUrl = request.returnUrl()
            return checkRoutes(request: request, requestMethod: validMethod, requestUrl: requestUrl)
        } else {
            return responseBuilder.generate405Response()
        }
    }

    private func checkRoutes(request: HttpRequest, requestMethod: HttpMethod, requestUrl: String) -> HttpResponse {
        let route = routeExists(requestUrl: requestUrl, requestMethod: requestMethod)

        if let validRoute = route {
            if validRoute.authorizeSucceeded(requestHeaders: request.returnHeaders()) {
                return validRoute.action.execute(request: request)
            } else {
                return responseBuilder.generate401Response(realm: validRoute.getRealm())
            }
        }

        if methodNotAllowed(requestUrl: requestUrl, requestMethod:requestMethod) {
            return responseBuilder.generate405Response()
        }
        return responseBuilder.generate404Response()
    }

    private func methodNotAllowed(requestUrl: String, requestMethod: HttpMethod) -> Bool {
        for route in self.routesTable.showAllRoutes() {
            if route.url == requestUrl && route.method != requestMethod {
                return true
            }
        }
        return false
    }

    private func routeExists(requestUrl: String, requestMethod: HttpMethod) -> Route? {
        for route in self.routesTable.showAllRoutes() {
            if route.url == requestUrl && route.method == requestMethod {
                return route
            }
        }
        return nil
    }

    private func populateRoutesTable() {
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
    }
}
