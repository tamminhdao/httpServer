import Foundation

public class ResponseBuilder {
    private var routesTable: RoutesTable
    private var dataStorage: DataStorage
    private var statusCode: Int?
    private var statusPhrase: String?
    private var contentType: String?
    private var body: Data?
    private var allow: String?
    private var location: String?
    private var authenticate: String?

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.routesTable = routesTable
        self.dataStorage = dataStorage
    }

    public func generate200Response(request: HttpRequest) -> HttpResponse {
        self.resetBuilder()
                .setStatusCode(statusCode: 200)
                .setStatusPhrase(statusPhrase: "OK")
                .setAllow(url: options(url: request.returnUrl()))
        if (request.returnMethod() != HttpMethod.head) {
            let bodyString = obtainDataByUrlKey(url: request.returnUrl())
            self.setBody(body: Data(bodyString.utf8))
        }
        if (request.returnUrl() == "/logs") {
            self.setBody(body: Data(obtainRequestLog().utf8))
        }
        return self.build()
    }

    public func generate200ResponseWithDirectoryListing(directory: String) -> HttpResponse {
        self.resetBuilder()
            .setStatusCode(statusCode: 200)
            .setStatusPhrase(statusPhrase: "OK")
            .setBody(body: Data(directory.utf8))
        return self.build()
    }

    public func generate200ResponseWithFileContent(content: Data?, contentType: (fileType: String, fileExt: String)) -> HttpResponse {
        self.resetBuilder()
            .setStatusCode(statusCode: 200)
            .setStatusPhrase(statusPhrase: "OK")
            .setContentType(contentType: "\(contentType.fileType)/\(contentType.fileExt)")
            .setBody(body: content!)
        return self.build()
    }

    public func generate302Response() -> HttpResponse {
        self.resetBuilder()
        .setStatusCode(statusCode: 302)
        .setStatusPhrase(statusPhrase: "Found")
        .setLocation(location: dataStorage.getLocation())
        return self.build()
    }

    public func generate401Response(realm: String) -> HttpResponse {
        self.resetBuilder()
        .setStatusCode(statusCode: 401)
        .setStatusPhrase(statusPhrase: "Unauthorized")
        .setWWWAuthenticate(authenticate: "Basic realm=\(realm)")
        return self.build()
    }

    public func generate404Response() -> HttpResponse {
        self.resetBuilder()
        .setStatusCode(statusCode: 404)
        .setStatusPhrase(statusPhrase: "Not Found")
        return self.build()
    }

    public func generate405Response() -> HttpResponse {
        self.resetBuilder()
        .setStatusCode(statusCode: 405)
        .setStatusPhrase(statusPhrase: "Method Not Allowed")
        return self.build()
    }


    private func setStatusCode(statusCode: Int) -> ResponseBuilder {
        self.statusCode = statusCode
        return self
    }

    private func setStatusPhrase(statusPhrase: String) -> ResponseBuilder {
        self.statusPhrase = statusPhrase
        return self
    }

    private func setContentType(contentType: String) -> ResponseBuilder {
        self.contentType = contentType
        return self
    }

    private func setBody(body: Data) -> ResponseBuilder {
        self.body = body
        return self
    }

    private func setAllow(url: String) -> ResponseBuilder {
        self.allow = url
        return self
    }

    private func setLocation(location: String) -> ResponseBuilder {
        self.location = location
        return self
    }

    private func setWWWAuthenticate(authenticate: String) -> ResponseBuilder {
        self.authenticate = authenticate
        return self
    }

    private func resetBuilder() -> ResponseBuilder {
        self.statusCode = nil
        self.statusPhrase = nil
        self.contentType = nil
        self.body = nil
        self.location = nil
        self.authenticate = nil
        self.allow = nil
        return self
    }

    private func checkField<T>(value: T?, defaultValue: T) -> T {
        if let value = value {
            return value
        } else {
            return defaultValue
        }
    }

    private func build() -> HttpResponse {
        let bodyValue = checkField(value: self.body, defaultValue: Data())
        return HttpResponse(
        statusCode: checkField(value: self.statusCode, defaultValue: 404),
        statusPhrase: checkField(value: self.statusPhrase, defaultValue: "Not Found"),
        headers: [
        "Content-Length": String(bodyValue.count),
        "Content-Type": checkField(value: self.contentType, defaultValue: "text/html"),
        "Allow": checkField(value: self.allow, defaultValue: ""),
        "Location": checkField(value: self.location, defaultValue: ""),
        "WWW-Authenticate": checkField(value: self.authenticate, defaultValue: "")
        ],
        body: bodyValue)
    }

    private func obtainDataByUrlKey(url: String) -> String {
        var result = ""
        result += dataStorage.logDataByUrl(url: url)
        return result
    }

//    private func obtainCookieDataByUrlKey(url: String) -> String {
//        var result = ""
//        result += dataStorage.retrieveCookieByUrl(url: url)
//        return result
//    }

    private func obtainRequestLog() -> String {
        var log = ""
        for item in dataStorage.logRequests() {
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
}
