import Foundation
import Requests
import Responses
import Values

public class Router {
    private var data: DataStorage
    private var routes: [String: [HttpMethod]]
    private var errorMessage: String = "<p> URL does not exist </p>"

    private func routeSetUp() {
        routes["/"] = [HttpMethod.get, HttpMethod.post, HttpMethod.put]
        routes["/form"] = [HttpMethod.get, HttpMethod.post, HttpMethod.put]
    }

    public init(data: DataStorage) {
        self.data = data
        self.routes = [:]
        self.routeSetUp()
    }

    public func checkRoute(request: HttpRequest) -> HttpResponse {
        if let validMethod = request.returnMethod() {
            let requestUrl = request.returnUrl()
            for route in routes {
                if route.key == requestUrl {
                    for method in route.value {
                        if method == validMethod {
                            return handleRequest(request: request)
                        }
                    }
                }
            }
            return generate404Response()
        } else {
            return generate404Response()
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

            default:
                return generate404Response()
            }
        } else {

            return generate404Response()
        }
    }

    private func handleGet(request: HttpRequest) -> HttpResponse {
        return generate200Response()
    }

    private func handlePost(request: HttpRequest) -> HttpResponse {
        let requestBody : [String: String] = request.returnBody()
        for item in requestBody {
            data.addValues(key: item.key, value: item.value)
        }
        data.logValues()
        return generate200Response()
    }

    private func handlePut(request: HttpRequest) -> HttpResponse {
        let requestBody : [String: String] = request.returnBody()
        for item in requestBody {
            data.addValues(key: item.key, value: item.value)
        }
        data.logValues()
        return generate200Response()
    }

    private func generate200Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"0", "Content-Type":"text/html"], body: "")
    }

    private func generate404Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 404, statusPhrase: "NotFound", headers: ["Content-Length":String(errorMessage.count), "Content-Type":"text/html"], body: errorMessage)
    }
}
