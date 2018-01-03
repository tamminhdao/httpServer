import Foundation
import Requests
import Responses
import Actions

public class Router {
   // private var action: HttpAction
    private var routes: [Route]
    private var errorMessage: String = "<p> URL does not exist </p>"
    private var getRequestMessage: String = "<p> Get Request has a body! </p>"

    public init() {
     //   self.action = action
        self.routes = []
    }

    public func addRoute(route: Route) {
        self.routes.append(route)
    }

    public func showAllRoutes() -> [Route] {
        return self.routes
    }

    public func checkRoute(request: HttpRequest) -> HttpResponse {
        if let validMethod = request.returnMethod() {
            let requestUrl = request.returnUrl()
            for route in routes {
                if route.url == requestUrl && route.method == validMethod {
                    route.action.execute(request: request)
                    return handleRequest(request: request)
                }
            }
            return generateResponse(version: "HTTP/1.1", statusCode: 404, statusPhrase: "NotFound", headers: ["Content-Length":String(errorMessage.count), "Content-Type":"text/html"], body: errorMessage)
        } else {
            return generateResponse(version: "HTTP/1.1", statusCode: 404, statusPhrase: "NotFound", headers: ["Content-Length":String(errorMessage.count), "Content-Type":"text/html"], body: errorMessage)
        }
    }

    private func handleRequest(request: HttpRequest) -> HttpResponse {

        if let validMethod = request.returnMethod() {

            switch validMethod {
            case HttpMethod.get:
                return handleGet(request: request)

            case HttpMethod.post:
                return handlePost(request: request)

            case HttpMethod.put:
                return handlePut(request: request)

            case HttpMethod.head:
                return handleHead(request: request)

            default:
                return generateResponse(version: "HTTP/1.1", statusCode: 404, statusPhrase: "NotFound", headers: ["Content-Length":String(errorMessage.count), "Content-Type":"text/html"], body: errorMessage)
            }
        } else {

            return generateResponse(version: "HTTP/1.1", statusCode: 404, statusPhrase: "NotFound", headers: ["Content-Length":String(errorMessage.count), "Content-Type":"text/html"], body: errorMessage)
        }
    }

    private func handleHead(request: HttpRequest) -> HttpResponse {
        return generateResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"0", "Content-Type":"text/html"], body: "")
    }

    private func handleGet(request: HttpRequest) -> HttpResponse {
        return generateResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":String(getRequestMessage.count), "Content-Type":"text/html"], body: getRequestMessage)
    }

    private func handlePost(request: HttpRequest) -> HttpResponse {
        //action.execute(request: request)
        return generateResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"0", "Content-Type":"text/html"], body: "")
    }

    private func handlePut(request: HttpRequest) -> HttpResponse {
        //action.execute(request: request)
        return generateResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"0", "Content-Type":"text/html"], body: "")
    }

    private func generateResponse(version: String, statusCode: Int, statusPhrase: String, headers: [String: String], body: String) -> HttpResponse {
        return HttpResponse(version: version, statusCode: statusCode, statusPhrase: statusPhrase, headers: headers, body: body)
    }
}
