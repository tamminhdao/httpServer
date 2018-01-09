import Foundation
import Requests
import Route

public class ResponseGenerator {
    private var errorMessage: String = "<p> URL does not exist </p>"
    private var getRequestMessage: String = "<p> Get Request has a body! </p>"
    private var routesTable: RoutesTable

    public init(routesTable: RoutesTable) {
        self.routesTable = routesTable
    }

    public func generate200Response(method: HttpMethod, url: String) -> HttpResponse {
        switch method {
            case HttpMethod.get:
                return HttpResponse(version: "HTTP/1.1",
                                    statusCode: 200,
                                    statusPhrase: "OK",
                                    headers: ["Content-Length":String(getRequestMessage.count), "Content-Type":"text/html"],
                                    body: getRequestMessage)

            case HttpMethod.post, HttpMethod.put, HttpMethod.head, HttpMethod.delete, HttpMethod.connect, HttpMethod.patch:
                return HttpResponse(version: "HTTP/1.1",
                                    statusCode: 200,
                                    statusPhrase: "OK",
                                    headers: ["Content-Length":"0", "Content-Type":"text/html"],
                                    body: "")

            case HttpMethod.options:
                return HttpResponse(version: "HTTP/1.1",
                                    statusCode: 200,
                                    statusPhrase: "OK",
                                    headers: ["Content-Length":"0", "Content-Type":"text/html", "Allow": (options(url: url))],
                                    body: "")
            }
    }

    private func options(url: String) -> String {
        var allMethods = ""
        let listOfMethods = routesTable.options(url: url)
        for method in listOfMethods {
            allMethods = allMethods + "\(method),"
        }
        return allMethods
    }

    public func generate404Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1",
                            statusCode: 404,
                            statusPhrase: "NotFound",
                            headers: ["Content-Length":String(errorMessage.count), "Content-Type":"text/html"],
                            body: errorMessage)
    }
}
