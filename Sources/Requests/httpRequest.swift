import Foundation

public class HttpRequest {
    var method: String
    var url: String
    var version: String
    var headers: [String: String]
    var crlf: String
    var space: String

    public init(method: String, url: String, version: String, headers: [String: String]) {
        self.method = method
        self.url = url
        self.version = version
        self.headers = headers
        self.crlf = "\r\n"
        self.space = " "
    }

    public func returnMethod () -> String {
        return self.method
    }

    public func returnUrl () -> String {
        return self.url
    }
}

extension HttpRequest: Equatable {
    public static func == (lhs: HttpRequest, rhs: HttpRequest) -> Bool {
        return
            lhs.method == rhs.method &&
            lhs.url == rhs.url &&
            lhs.version == rhs.version &&
            lhs.headers == rhs.headers
    }
}
