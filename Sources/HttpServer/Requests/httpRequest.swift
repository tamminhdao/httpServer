public class HttpRequest {
    var method: HttpMethod?
    var url: String
    var version: String
    var headers: [String: String]
    var body: [String: String]
    var crlf: String
    var space: String

    public init(method: HttpMethod?, url: String, version: String, headers: [String: String], body: [String: String]) {
        self.method = method
        self.url = url
        self.version = version
        self.headers = headers
        self.body = body
        self.crlf = "\r\n"
        self.space = " "
    }

    public func returnMethod() -> HttpMethod? {
        return self.method
    }

    public func returnUrl() -> String {
        return self.url
    }

    public func returnBody() -> [String: String] {
        return self.body
    }
}

extension HttpRequest: Equatable {
    public static func == (lhs: HttpRequest, rhs: HttpRequest) -> Bool {
        return
            lhs.method == rhs.method &&
            lhs.url == rhs.url &&
            lhs.version == rhs.version &&
            lhs.headers == rhs.headers &&
            lhs.body == rhs.body
    }
}
