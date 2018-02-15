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

            var lines = getLines(request: request).filter {$0 != ""}

            let firstLine = lines.removeFirst()
            let statusLine = try parseStatusLine(statusLine: firstLine)
            let headers = parseHeaders(headerLines: lines)

            let numberOfHeaderLines = headers.count

            for _ in 1...numberOfHeaderLines {
                lines.removeFirst()
            }

            let body = parseBody (bodyLines: lines)

            let parsedRequest = HttpRequest(
                method: HttpMethod(rawValue: statusLine.method),
                url: statusLine.url,
                params: statusLine.params,
                version: statusLine.version,
                headers: headers,
                body : body
            )

            return parsedRequest
    }

    private func getLines(request: String) -> [String] {
        return request.components(separatedBy: CharacterSet(charactersIn: "\r\n"))
    }

    private func parseStatusLine(statusLine: String) throws -> (method: String, url: String, params: [String], version: String) {
        let trimmedStatus = statusLine.trimmingCharacters(in: .whitespacesAndNewlines)
        let statusLineTokens = trimmedStatus.components(separatedBy: " ")

        if statusLineTokens.count != 3 {
            throw RequestParserError.InvalidStatusLine(statusLine)
        }

        let method = statusLineTokens[0]
        let urlAndParams = statusLineTokens[1]
        let version = statusLineTokens[2]
        let urlPlusParams = separateUrlFromParams(path: urlAndParams)
        return (method: method, url: urlPlusParams.url, params: urlPlusParams.params, version: version)
    }

    private func separateUrlFromParams(path: String) -> (url: String, params: [String]) {
        guard path.contains("?") else {
            return (url: path, params: [String]())
        }
        let urlAndParams = path.components(separatedBy: "?")
        let url = urlAndParams[0]
        let paramString = urlAndParams[1]
        let params = paramString.components(separatedBy: "&")
        return (url: url, params: params)
    }

    private func parseHeaders(headerLines: [String]) -> [String: String] {
        var headers = [String: String]()

        for line in headerLines where line.contains(":") {
            let keyValue = line.split(separator: ":", maxSplits: 1)
            let trimmedKey = keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedValue = keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
            headers[trimmedKey] = trimmedValue
        }

        return headers
    }

    private func parseBody(bodyLines: [String]) -> [String: String] {
        var body = [String: String]()

        if bodyLines.count > 0 {
            for item in bodyLines {
                let bodyText = item.trimmingCharacters(in: .whitespacesAndNewlines)

                var bodyValues = [Substring]()

                if (bodyText.contains("&")) {
                    bodyValues = bodyText.split(separator: "&")
                } else {
                    bodyValues.append(Substring(bodyText))
                }

                for item in bodyValues {
                    let keyValue = item.split(separator: "=", maxSplits: 1)
                    if (keyValue.count > 1) {
                        let trimmedKey = keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedValue = keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        body[trimmedKey] = trimmedValue
                    }
                }

            }
        }
        return body
    }
}
