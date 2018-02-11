import Foundation

public class ResponseBuilder {
    private var routesTable: RoutesTable
    private var dataStorage: DataStorage
    private var statusCode: Int?
    private var statusPhrase: String?
    private var contentType: String?
    private var body: String?
    private var allow: String?

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.routesTable = routesTable
        self.dataStorage = dataStorage
    }

    public func setStatusCode(statusCode: Int) -> ResponseBuilder {
        self.statusCode = statusCode
        return self
    }

    public func setStatusPhrase(statusPhrase: String) -> ResponseBuilder {
        self.statusPhrase = statusPhrase
        return self
    }
    
    public func setContentType(contentType: String) -> ResponseBuilder {
        self.contentType = contentType
        return self
    }

    public func setBody(body: String) -> ResponseBuilder {
        self.body = body
        return self
    }

    public func setAllow(url: String) -> ResponseBuilder {
        self.allow = url
        return self
    }

    private func checkField<T>(value: T?, defaultValue: T) -> T {
        if let value = value {
            return value
        } else {
            return defaultValue
        }
    }

    public func build() -> HttpResponse {
        let bodyValue = checkField(value: self.body, defaultValue: "")
        return HttpResponse(
                statusCode: checkField(value: self.statusCode, defaultValue: 404),
                statusPhrase: checkField(value: self.statusPhrase, defaultValue: "Not Found"),
                headers: [
                    "Content-Length": String(bodyValue.count),
                    "Content-Type": checkField(value: self.contentType, defaultValue: "text/html"),
                    "Allow": checkField(value: self.allow, defaultValue: "")
                ],
                body: bodyValue)
    }

    public func generate200Response(method: HttpMethod, url: String) -> HttpResponse {
        self.setStatusCode(statusCode: 200)
            .setStatusPhrase(statusPhrase: "OK")
            .setContentType(contentType: "text/html")
            .setAllow(url: options(url: url))
            .setBody(body: obtainDataByUrlKey(url: url))
        return self.build()
    }

    public func obtainDataByUrlKey(url: String) -> String {
        var result = ""
        result += dataStorage.logDataByUrl(url: url)
        return result
    }

    public func obtainRequestLog() -> String {
        var log = ""
        for item in dataStorage.logRequests() {
            log += item + "\n"
        }
        return log
    }

    public func options(url: String) -> String {
        var allMethods = ""
        let listOfMethods = routesTable.options(url: url)
        for method in listOfMethods {
            allMethods = allMethods + "\(method),"
        }
        return allMethods
    }

    public func generateLogContent() -> HttpResponse {
        return HttpResponse(statusCode: 200,
                statusPhrase: "OK",
                headers: ["Content-Length":String(obtainRequestLog().count), "Content-Type":"text/html"],
                body: obtainRequestLog())
    }

    public func generate400Response() -> HttpResponse {
        return HttpResponse(statusCode: 400,
                statusPhrase: "Bad Request",
                headers: ["Content-Length": "0", "Content-Type":"text/html"],
                body: "")
    }

    public func generate401Response(realm: String) -> HttpResponse {
        return HttpResponse(statusCode: 401,
                statusPhrase: "Unauthorized",
                headers: ["WWW-Authenticate": "Basic realm=\(realm)", "Content-Type":"text/html"],
                body: "")
    }

    public func generate404Response() -> HttpResponse {
        return self.build()
    }

    public func generate405Response() -> HttpResponse {
        self.setStatusCode(statusCode: 405)
            .setStatusPhrase(statusPhrase: "Method Not Allowed")
        return self.build()
    }

    public func generate302Response() -> HttpResponse {
        return HttpResponse(statusCode: 302,
                statusPhrase: "Found",
                headers: ["Content-Length":"0", "Location": dataStorage.getLocation()],
                body: "")
    }

    public func generateDirectory(body: String) -> HttpResponse {
        return HttpResponse(statusCode: 200,
                statusPhrase: "OK",
                headers: ["Content-Length":String(body.count), "Content-Type":"text/html"],
                body: body)
    }

    public func generateFile(body: Data?) -> HttpResponse {
        return HttpResponse(statusCode: 200,
                statusPhrase: "OK",
                headers: ["Content-Length":String(body!.count), "Content-Type":"text/html"],
                body: String(data: body!, encoding: .utf8)!)
    }
}
