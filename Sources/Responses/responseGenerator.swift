import Foundation

public class ResponseGenerator {
    private var errorMessage: String = "<p> URL does not exist </p>"
    private var getRequestMessage: String = "<p> Get Request has a body! </p>"

    public init() {}


    public func generate200Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"0", "Content-Type":"text/html"], body: "")
    }

    public func generate404Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 404, statusPhrase: "NotFound", headers: ["Content-Length":String(errorMessage.count), "Content-Type":"text/html"], body: errorMessage)
    }
}