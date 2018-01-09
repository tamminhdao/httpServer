import Foundation
import Requests
import Responses
import Route
import Actions

public class Router {
    private var routesTable: RoutesTable
    private var responseGenerator: ResponseGenerator

    public init(routesTable: RoutesTable) {
        self.routesTable = routesTable
        self.responseGenerator = ResponseGenerator(routesTable: routesTable)
    }

    public func addRoute(route: Route) {
        self.routesTable.addRoute(route: route)
    }

    public func showAllRoutes() -> [Route] {
        return self.routesTable.showAllRoutes()
    }

    public func route(request: HttpRequest) -> HttpResponse {
        if let validMethod = request.returnMethod() {
            let requestUrl = request.returnUrl()
            return checkRoutes(request: request, requestMethod: validMethod, requestUrl: requestUrl)
        } else {
            return responseGenerator.generate404Response()
        }
    }

    private func checkRoutes(request: HttpRequest, requestMethod: HttpMethod, requestUrl: String) -> HttpResponse {
        for route in showAllRoutes() {
            if route.url == requestUrl && route.method == requestMethod {
                route.action.execute(request: request)
                return responseGenerator.generate200Response(method: requestMethod, url: requestUrl)
            } else if route.url == requestUrl && route.method != requestMethod {
                return responseGenerator.generate405Response()
            }
        }
        return responseGenerator.generate404Response()
    }
}
