//import Foundation
//import Requests
//import Responses
//import Route
//import Actions

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
            perform_action(request: request, route: validRoute)
            if redirect(route: validRoute) {
                return responseGenerator.generate302Response()
            } else {
                return responseGenerator.generate200Response(method: requestMethod, url: requestUrl)
            }
        }

        if methodDoesNotExists(requestUrl: requestUrl, requestMethod: requestMethod) {
            return responseGenerator.generate405Response()
        }

        return responseGenerator.generate404Response()

    }

    private func redirect(route: Route) -> Bool {
        return type(of: route.action) == RedirectAction.self
    }

    private func methodDoesNotExists(requestUrl: String, requestMethod: HttpMethod) -> Bool {
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

    private func perform_action(request: HttpRequest, route: Route) {
        route.action.execute(request: request)
    }
}
