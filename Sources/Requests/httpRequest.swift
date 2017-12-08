import Foundation

public class HttpRequest {
    var method: String
    var url: String
    var version: String
    var headers: [String: String]

    public init(method: String, url: String, version: String, headers: [String: String]) {
        self.method = method
        self.url = url
        self.version = version
        self.headers = headers
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
