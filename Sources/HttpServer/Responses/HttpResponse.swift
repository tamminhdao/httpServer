import Foundation

public class HttpResponse {
    let VERSION: String = "HTTP/1.1"
    private var statusCode: Int
    private var statusPhrase: String
    private var headers: [String: String]
    private var body: Data
    private var crlf: String
    private var space: String

    public init(statusCode: Int, statusPhrase: String, headers: [String:String], body: Data) {
        self.statusCode = statusCode
        self.statusPhrase = statusPhrase
        self.headers = headers
        self.body = body
        self.crlf = "\r\n"
        self.space = " "
    }

    public func constructResponse() -> Data {
        let responseText = self.VERSION + self.space + String(self.statusCode) + self.space + self.statusPhrase
                + self.crlf + self.convertHeaders(headers: self.headers) + self.crlf
        var responseData = Data(responseText.utf8)
        responseData.append(self.body)
        return responseData
    }

    private func convertHeaders(headers: [String: String]) -> String {
        var headerString = String()
        for header in headers {
            headerString += header.key + ": " + header.value
            headerString += self.crlf
        }
        return headerString
    }

    public static func emptyResponse() -> HttpResponse {
        return HttpResponse(statusCode: 404, statusPhrase: "Not Found", headers: [:], body: Data())
    }

    public func setResponseStatusCode(status: Int) -> HttpResponse {
    self.statusCode = status
    return self
}

    public func getResponseStatusCode() -> Int {
        return self.statusCode
    }

    public func setResponseStatusPhrase(phrase: String) -> HttpResponse {
        self.statusPhrase = phrase
        return self
    }

    public func getResponseStatusPhrase() -> String {
        return self.statusPhrase
    }

    public func setResponseContentLength(length: String) -> HttpResponse {
        self.headers["Content-Length"] = length
        return self
    }

    public func getResponseContentLength() -> String? {
        return self.headers["Content-Length"]
    }

    public func setResponseContentType(type: String) -> HttpResponse {
        self.headers["Content-Type"] = type
        return self
    }

    public func getResponseContentType() -> String? {
        return self.headers["Content-Type"]
    }

    public func setResponseAllow(allow: String) -> HttpResponse {
        self.headers["Allow"] = allow
        return self
    }

    public func getResponseAllow() -> String? {
        return self.headers["Allow"]
    }

    public func setResponseLocation(location: String) -> HttpResponse {
        self.headers["Location"] = location
        return self
    }

    public func getResponseLocation() -> String? {
        return self.headers["Location"]
    }

    public func setResponseCookie(cookie: String) -> HttpResponse {
        self.headers["Set-Cookie"] = cookie
        return self
    }

    public func getResponseCookie() -> String? {
        return self.headers["Set-Cookie"]
    }

    public func setResponseWWWAuthenticate(authenticate: String) -> HttpResponse {
        self.headers["WWW-Authenticate"] = authenticate
        return self
    }

    public func getResponseWWWAuthenticate() -> String? {
        return self.headers["WWW-Authenticate"]
    }

    public func setResponseBody(body: Data) -> HttpResponse {
        self.body = body
        return self
    }

    public func getResponseBody() -> Data {
        return self.body
    }
}

extension HttpResponse: Equatable {
    public static func ==(lhs: HttpResponse, rhs: HttpResponse) -> Bool {
        return
            lhs.VERSION == rhs.VERSION &&
            lhs.statusCode == rhs.statusCode &&
            lhs.statusPhrase == rhs.statusPhrase &&
            lhs.headers == rhs.headers &&
            lhs.body == rhs.body
    }
}
