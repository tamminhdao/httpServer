public class Router {
    private var routesTable: RoutesTable
    private var responseBuilder: ResponseBuilder
    let logger = Logger()

    public init(routesTable: RoutesTable, responseBuilder: ResponseBuilder) {
        self.routesTable = routesTable
        self.responseBuilder = responseBuilder
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
                logger.logToFile(message: "Only valid route should show up here")
                return validRoute.action.execute(request: request)
            } else {
                return responseBuilder.generate401Response(realm: validRoute.getRealm())
            }
        }

        if methodNotAllowed(requestUrl: requestUrl, requestMethod:requestMethod) {
            return responseBuilder.generate405Response()
        }

        logger.logToFile(message: "Invalid route [\(requestMethod) + \(requestUrl)] will end up here")
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
                logger.logToFile(message: "\(requestMethod) + \(requestUrl) is a valid route")
                return route
            }
        }

        logger.logToFile(message: "\(requestMethod) + \(requestUrl) is NOT a valid route")
        return nil
    }
}
