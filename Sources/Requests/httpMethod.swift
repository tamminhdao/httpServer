import Foundation

public enum MethodError: Error {
    case InvalidMethodError
}

public enum HttpMethod {
    case get
    case head
    case post
    case put
    case delete
    case connect
    case options
    case patch

    public static func resolveMethod(method: String) throws -> HttpMethod {

        let mapping : [String: HttpMethod] = [
            "GET" : HttpMethod.get,
            "HEAD": HttpMethod.head,
            "POST": HttpMethod.post,
            "PUT" : HttpMethod.put,
            "DELETE" : HttpMethod.delete,
            "CONNECT": HttpMethod.connect,
            "OPTIONS": HttpMethod.options,
            "PATCH"  : HttpMethod.patch
        ]

        if let result: HttpMethod = mapping[method] {
            return result
        } else {
            throw MethodError.InvalidMethodError
        }
    }
}
