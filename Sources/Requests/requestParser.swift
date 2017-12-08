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

            var lines = getLine(request: request)

            let firstLine = lines.removeFirst()

        print("does it get to the first line")
        print(firstLine)

            let statusLine = try parseStatusLine(statusLine: firstLine)

        print("does it get to the status line")
        print(statusLine)

        print("Let's see how the array of lines looks like")
        print(lines)

            let headers = parseHeaders(headerLines: lines)

        print("does it get to the headers line? - NO")
        print(headers)


            let parsedRequest = HttpRequest(
                method: statusLine.method,
                url: statusLine.url,
                version: statusLine.version,
                headers: headers
            )

            return parsedRequest
    }

    public func getLine(request: String) -> [String] {
        return request.components(separatedBy: CharacterSet(charactersIn: "\r\n"))
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
}
