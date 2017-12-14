import Foundation
import Requests
import Responses
import Values

public class Router {
    private var data: DataStorage
    private var routes: [String: [String]]
    private var errorMessage: String = "<p> URL does not exist </p>"

    private func routeSetUp() {
        routes["/"] = ["GET", "POST", "PUT"]
        routes["/form"] = ["GET", "POST", "PUT"]
    }

    public init(data: DataStorage) {
        self.data = data
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
                        return handleRequest(request: request)
                    }
                }
            }
        }

        return generate404Response()
    }

    private func handleRequest(request: HttpRequest) -> HttpResponse {

        switch request.returnMethod() {
        case "GET":
            return handleGet(request: request)

        case "POST":
            return handlePost(request: request)

        case "PUT":
            return handlePut(request: request)

        default:
            return generate404Response()
        }
    }

    private func handleGet(request: HttpRequest) -> HttpResponse {
        return generate200Response()
    }

    private func handlePost(request: HttpRequest) -> HttpResponse {
        return generate200Response()
    }

    private func handlePut(request: HttpRequest) -> HttpResponse {
        return generate200Response()
    }

    private func generate200Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"0", "Content-Type":"text/html"], body: "")
    }

    private func generate404Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 404, statusPhrase: "NotFound", headers: ["Content-Length":String(errorMessage.count), "Content-Type":"text/html"], body: errorMessage)
    }
}
