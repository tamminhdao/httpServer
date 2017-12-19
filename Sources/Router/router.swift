import Foundation
import Requests
import Responses

public class Router {

    private var routes: [String: [String]]
    private var errorMessage: String = "<p> URL does not exist </p>"

    private func routeSetUp() {
        routes["/"] = ["GET", "POST", "PUT"]
        routes["/form"] = ["GET", "POST", "PUT"]
    }

    public init() {
        self.routes = [:]
        self.routeSetUp()
    }

    public func checkRoute(request: HttpRequest) -> HttpResponse {
        let requestMethod = request.returnMethod()
        let requestUrl = request.returnUrl()

        for route in routes {
            if route.key == requestUrl {
                for method in route.value {
                    if method == requestMethod {
                        return generate200Response()
                    }
                }
            }
        }

        return generate404Response()
    }

    private func generate200Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"0", "Content-Type":"text/html"], body: "")
    }

    private func generate404Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 404, statusPhrase: "NotFound", headers: ["Content-Length":String(errorMessage.count), "Content-Type":"text/html"], body: errorMessage)
    }
}
