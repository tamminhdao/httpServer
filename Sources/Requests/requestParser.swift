import Foundation

public enum RequestParserError: Error {
    case InvalidStatusLine(String)
    case EmptyRequest
}

public class RequestParser {
    public init() {}

    public func parse(request: String) throws -> HttpRequest {
            if request.isEmpty {
                throw RequestParserError.EmptyRequest
            }

            let headAndBody = getLines(request: request, separator: "\r\n\r\n")

            var head = getLines(request: headAndBody[0], separator: "\r\n")
            let firstLine = head.removeFirst()
            let statusLine = try parseStatusLine(statusLine: firstLine)
            let headers = parseHeaders(headerLines: head)

//            let body = parseBody(body: headAndBody[1])

            let parsedRequest = HttpRequest(
                method: statusLine.method,
                url: statusLine.url,
                version: statusLine.version,
                headers: headers,
                body : ""
            )

            return parsedRequest
    }


    public func getLines(request: String, separator: String) -> [String] {
        return request.components(separatedBy: CharacterSet(charactersIn: separator))
    }

    public func parseStatusLine(statusLine: String) throws -> (method: String, url: String, version: String) {
        let trimmedStatus = statusLine.trimmingCharacters(in: .whitespacesAndNewlines)
        let statusLineTokens = trimmedStatus.components(separatedBy: " ")

        if statusLineTokens.count != 3 {
            throw RequestParserError.InvalidStatusLine(statusLine)
        }

        let method = statusLineTokens[0]
        let url = statusLineTokens[1]
        let version = statusLineTokens[2]

        return (method: method, url: url, version: version)
    }

    public func parseHeaders(headerLines: [String]) -> [String: String] {
        var headers = [String: String]()

        for line in headerLines where line.contains(":") {
            let keyValue = line.split(separator: ":", maxSplits: 1)
            let trimmedKey = keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedValue = keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
            headers[trimmedKey] = trimmedValue
        }

        return headers
    }

//    public func parseBody(body: String) -> String {
//
//    }
}
