import Foundation
import Requests
import Responses
import Values

public class Router {
    private var data: DataStorage
    private var routes: [String: [HttpMethod]]
    private var errorMessage: String = "<p> URL does not exist </p>"
    private var getRequestMessage: String = "<p> Get Request has a body! </p>"

    private func routeSetUp() {
        routes["/"] = [HttpMethod.get, HttpMethod.post, HttpMethod.put, HttpMethod.head]
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
        let requestBody : [String: String] = request.returnBody()
        for item in requestBody {
            data.addValues(key: item.key, value: item.value)
        }
        data.logValues()
        return generateResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"0", "Content-Type":"text/html"], body: "")
    }

    private func handlePut(request: HttpRequest) -> HttpResponse {
        let requestBody : [String: String] = request.returnBody()
        for item in requestBody {
            data.addValues(key: item.key, value: item.value)
        }
        data.logValues()
        return generateResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"0", "Content-Type":"text/html"], body: "")
    }

    private func generateResponse(version: String, statusCode: Int, statusPhrase: String, headers: [String: String], body: String) -> HttpResponse {
        return HttpResponse(version: version, statusCode: statusCode, statusPhrase: statusPhrase, headers: headers, body: body)
    }
}
