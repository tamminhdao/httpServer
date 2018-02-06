import Foundation

public class ResponseGenerator {
    private var errorMessage: String = "<p> URL does not exist </p>"
    private var routesTable: RoutesTable
    private var dataStorage: DataStorage

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.routesTable = routesTable
        self.dataStorage = dataStorage
    }

    public func generate200Response(method: HttpMethod, url: String) -> HttpResponse {
        switch method {
            case HttpMethod.get:
                return HttpResponse(version: "HTTP/1.1",
                                    statusCode: 200,
                                    statusPhrase: "OK",
                                    headers: ["Content-Length":String(obtainDataFromStorage().count), "Content-Type":"text/html"],
                                    body: obtainDataFromStorage())

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

    private func obtainDataFromStorage() -> String {
        var result = ""
        for item in dataStorage.myVals {
            result = result + "\(item.key)=\(item.value)" + "\n"
        }
        return result
    }

    private func obtainRequestLog() -> String {
        var log = ""
        for item in dataStorage.incomingRequests {
            log += item + "\n"
        }
        return log
    }

    private func options(url: String) -> String {
        var allMethods = ""
        let listOfMethods = routesTable.options(url: url)
        for method in listOfMethods {
            allMethods = allMethods + "\(method),"
        }
        return allMethods
    }

    public func generateLogContent() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1",
                statusCode: 200,
                statusPhrase: "OK",
                headers: ["Content-Length":String(obtainRequestLog().count), "Content-Type":"text/html"],
                body: obtainRequestLog())
    }

    public func generate400Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1",
                statusCode: 400,
                statusPhrase: "Bad Request",
                headers: ["Content-Length": "0", "Content-Type":"text/html"],
                body: "")
    }

    public func generate401Response(realm: String) -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1",
                statusCode: 401,
                statusPhrase: "Unauthorized",
                headers: ["WWW-Authenticate": "Basic realm=\(realm)", "Content-Type":"text/html"],
                body: "")
    }

    public func generate404Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1",
                            statusCode: 404,
                            statusPhrase: "Not Found",
                            headers: ["Content-Length":"0", "Content-Type":"text/html"],
                            body: "")
    }

    public func generate405Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1",
                statusCode: 405,
                statusPhrase: "Method Not Allowed",
                headers: ["Content-Length":"0", "Content-Type":"text/html"],
                body: "")
    }

    public func generate302Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1",
                statusCode: 302,
                statusPhrase: "Found",
                headers: ["Content-Length":"0", "Location": dataStorage.getLocation()],
                body: "")
    }

    public func generateDirectory(body: String) -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1",
                statusCode: 200,
                statusPhrase: "OK",
                headers: ["Content-Length":String(body.count), "Content-Type":"text/html"],
                body: body)
    }

    public func generateFile(body: Data?) -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1",
                statusCode: 200,
                statusPhrase: "OK",
                headers: ["Content-Length":String(body!.count), "Content-Type":"text/html"],
                body: String(data: body!, encoding: .utf8)!)
    }
}
