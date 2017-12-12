import Foundation

public class HttpResponse {
    var version: String
    var statusCode: Int
    var statusPhrase: String
    var headers: [String: String]? = nil
    var crlf: String
    var space: String

    public init(version: String, statusCode: Int, statusPhrase: String, headers: [String:String]?) {
        self.version = version
        self.statusCode = statusCode
        self.statusPhrase = statusPhrase
        self.headers = headers
        self.crlf = "\r\n"
        self.space = " "
    }

    public func constructResponse() -> Data {
        let responseText = self.version + self.space + String(self.statusCode) + self.space + self.statusPhrase
                + self.crlf + self.crlf
        return Data(responseText.utf8)
    }
}

extension HttpResponse: Equatable {
    public static func ==(lhs: HttpResponse, rhs: HttpResponse) -> Bool {
        return
            lhs.version == rhs.version &&
            lhs.statusCode == rhs.statusCode &&
            lhs.statusPhrase == rhs.statusPhrase &&
            lhs.headers! == rhs.headers!
    }
}
