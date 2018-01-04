import Foundation
import Requests
import Responses
import Actions

public class Router {
    private var routes: [Route]
    private var responseGenerator: ResponseGenerator
    private var errorMessage: String = "<p> URL does not exist </p>"
    private var getRequestMessage: String = "<p> Get Request has a body! </p>"

    public init() {
        self.routes = []
        self.responseGenerator = ResponseGenerator()
    }

    public func addRoute(route: Route) {
        self.routes.append(route)
    }

    public func showAllRoutes() -> [Route] {
        return self.routes
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
        for route in routes {
            if route.url == requestUrl && route.method == requestMethod {
                route.action.execute(request: request)
                return responseGenerator.generate200Response()
            }
        }
        return responseGenerator.generate404Response()
    }
}
