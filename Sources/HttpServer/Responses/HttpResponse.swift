import Foundation

public class HttpResponse {
    let VERSION: String = "HTTP/1.1"
    var statusCode: Int
    var statusPhrase: String
    var headers: [String: String]
    var body: Data
    var crlf: String
    var space: String

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
}

extension HttpResponse: Equatable {
    public static func ==(lhs: HttpResponse, rhs: HttpResponse) -> Bool {
        return
            lhs.VERSION == rhs.VERSION &&
            lhs.statusCode == rhs.statusCode &&
            lhs.statusPhrase == rhs.statusPhrase &&
            lhs.headers == rhs.headers
    }
}
