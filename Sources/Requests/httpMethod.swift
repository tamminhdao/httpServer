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
            "Get" : HttpMethod.get,
            "Head": HttpMethod.head,
            "Post": HttpMethod.post,
            "Put" : HttpMethod.put,
            "Delete" : HttpMethod.delete,
            "Connect": HttpMethod.connect,
            "Options": HttpMethod.options,
            "Patch"  : HttpMethod.patch
        ]

        if let result: HttpMethod = mapping[method] {
            return result
        } else {
            throw MethodError.InvalidMethodError
        }
    }
}
