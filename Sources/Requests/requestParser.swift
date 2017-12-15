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

    //    print("this is how lines look at first \(lines)")

            let firstLine = lines.removeFirst()
            let statusLine = try parseStatusLine(statusLine: firstLine)
            let headers = parseHeaders(headerLines: lines)

    //    print("this is the headers \(headers)")

            let numberOfHeaderLines = headers.count

    //    print("number of header lines = \(numberOfHeaderLines)")

            for _ in 1...numberOfHeaderLines {
                lines.removeFirst()
            }

    //   print("this is how lines look after removing the headers \(lines)")

            let body = parseBody (bodyLines: lines)

    //    print("this is the body \(body)")

            let parsedRequest = HttpRequest(
                method: statusLine.method,
                url: statusLine.url,
                version: statusLine.version,
                headers: headers,
                body : body
            )

            return parsedRequest
    }


    private func getLines(request: String) -> [String] {
        return request.components(separatedBy: CharacterSet(charactersIn: "\r\n"))
    }

    private func parseStatusLine(statusLine: String) throws -> (method: String, url: String, version: String) {
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

        if (bodyLines != []) {
            print ("is there a body somewhere \(bodyLines)")
            // ["\"My\"=\"Data\""]
        }

        if bodyLines.count > 0 {
            for item in bodyLines {
                let bodyText = item.trimmingCharacters(in: .whitespacesAndNewlines)

                print("this is the body text: \(bodyText)")

                var keyValuePairs = [Substring]()

                if (bodyText.contains("&")) {
                    keyValuePairs = bodyText.split(separator: "&")
                } else {
                    keyValuePairs.append(Substring(bodyText))

                    print("test a keyValuePair \(keyValuePairs)")
                    print("test a keyValuePair \(keyValuePairs[0])")
                }


                for item in keyValuePairs {
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
