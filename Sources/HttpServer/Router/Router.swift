public class Router {
    private var routesTable: RoutesTable
    private var responseGenerator: ResponseGenerator

    public init(routesTable: RoutesTable, responseGenerator: ResponseGenerator) {
        self.routesTable = routesTable
        self.responseGenerator = responseGenerator
    }

    public func route(request: HttpRequest) -> HttpResponse {

        if let validMethod = request.returnMethod() {
            let requestUrl = request.returnUrl()
            return checkRoutes(request: request, requestMethod: validMethod, requestUrl: requestUrl)
        } else {
            return responseGenerator.generate405Response()
        }
    }

    private func checkRoutes(request: HttpRequest, requestMethod: HttpMethod, requestUrl: String) -> HttpResponse {
        let route = routeExists(requestUrl: requestUrl, requestMethod: requestMethod)

        if let validRoute = route {
            if validRoute.authorizeSucceeded(requestHeaders: request.returnHeaders()) {
                return validRoute.action.execute(request: request)
            } else {
                return responseGenerator.generate401Response(realm: validRoute.getRealm())
            }
        }

        if methodNotAllowed(requestUrl: requestUrl, requestMethod:requestMethod) {
            return responseGenerator.generate405Response()
        }

        return responseGenerator.generate404Response()
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
}
