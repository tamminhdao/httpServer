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

            var lines = getLines(request: request)
            let firstLine = lines.removeFirst()
            let statusLine = try parseStatusLine(statusLine: firstLine)
            let headers = parseHeaders(headerLines: lines)


        print("this is how lines looks \(lines)")
        print ("     ")

            let numberOfHeaderLines = headers.count
            for _ in 1...numberOfHeaderLines {
                lines.removeFirst()
            }

        print("this is how lines looks \(lines)")

          //  let body = parseBody (bodyLines: lines)

            let parsedRequest = HttpRequest(
                method: statusLine.method,
                url: statusLine.url,
                version: statusLine.version,
                headers: headers,
                body : [:]
            )

            return parsedRequest
    }


    public func getLines(request: String) -> [String] {
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

    public func parseBody(bodyLines: String) -> [String: String]  {
        var result = [String: String]()
        var keyValuePairs = [Substring]()

        if (bodyLines.contains("&")) {
            keyValuePairs = bodyLines.split(separator: "&")
            print(keyValuePairs[0])
        } else {
            keyValuePairs[0] = Substring(bodyLines)
            print(keyValuePairs[0])
        }


        for item in keyValuePairs {
            let keyValue = item.split(separator: "=", maxSplits: 1)
            let trimmedKey = keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedValue = keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
            result[trimmedKey] = trimmedValue
        }

        return result
    }
}
