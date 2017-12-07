import Foundation

enum RequestParserError: Error {
    case InvalidStatusLine(String)
}

public class RequestParser {
    public init() {}

    public func parse(request: String) throws {

        var lines = request.components(separatedBy: CharacterSet(charactersIn: "\r\n")) //returns an array

        // parse status line
        let statusLine = lines.removeFirst()
        let trimmedStatus = statusLine.trimmingCharacters(in: .whitespacesAndNewlines)
        let statusLineTokens = trimmedStatus.components(separatedBy: " ")

        if statusLineTokens.count < 3 {
            throw RequestParserError.InvalidStatusLine(statusLine)
        }

        let method = statusLineTokens[0]
        let url = statusLineTokens[1]
        let version = statusLineTokens[2]

        // parse header
    }
}