import Foundation

public class ResponseBuilder {
    private var statusCode: Int?
    private var statusPhrase: String?
    private var contentType: String?
    private var body: Data?
    private var allow: String?
    private var location: String?
    private var authenticate: String?
    private var cookieData: String?

    public init() {}

    public func assemble200Response(request: HttpRequest) -> ResponseBuilder {
        self.resetBuilder()
                .setStatusCode(statusCode: 200)
                .setStatusPhrase(statusPhrase: "OK")
        return self
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
        if let content = content {
            self.setBody(body: content)
        } else {
            self.setBody(body: Data())
        }
        return self.build()
    }

    public func assemble302Response() -> ResponseBuilder {
        self.resetBuilder()
                .setStatusCode(statusCode: 302)
                .setStatusPhrase(statusPhrase: "Found")
        return self
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
        .setBody(body: Data("404 Not Found".utf8))
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

    public func setBody(body: Data) -> ResponseBuilder {
        self.body = body
        return self
    }

    public func setAllow(url: String) -> ResponseBuilder {
        self.allow = url
        return self
    }

    public func setLocation(location: String) -> ResponseBuilder {
        self.location = location
        return self
    }

    private func setWWWAuthenticate(authenticate: String) -> ResponseBuilder {
        self.authenticate = authenticate
        return self
    }

    public func setCookie(cookieData: String) -> ResponseBuilder {
        self.cookieData = cookieData
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
        self.cookieData = nil
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
        let bodyValue = checkField(value: self.body, defaultValue: Data())
        return HttpResponse.emptyResponse()
                            .setResponseStatusCode(status: checkField(value: self.statusCode, defaultValue: 404))
                            .setResponseStatusPhrase(phrase: checkField(value: self.statusPhrase, defaultValue: "Not Found"))
                            .setResponseContentLength(length: String(bodyValue.count))
                            .setResponseContentType(type: checkField(value: self.contentType, defaultValue: "text/html"))
                            .setResponseAllow(allow: checkField(value: self.allow, defaultValue: ""))
                            .setResponseLocation(location: checkField(value: self.location, defaultValue: ""))
                            .setResponseWWWAuthenticate(authenticate: checkField(value: self.authenticate, defaultValue: ""))
                            .setResponseCookie(cookie: checkField(value: self.cookieData, defaultValue: ""))
                            .setResponseBody(body: bodyValue)
    }
}
