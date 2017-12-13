import Foundation
import Requests
import Responses

public class Router {

    private var routes: [String: [String]]

    private func routeSetUp() {
        routes["/"] = ["GET", "POST", "PUT"]
        routes["/form"] = ["GET", "POST", "PUT"]
    }

    public init() {
        self.routes = [:]
        self.routeSetUp()
    }

    public func checkRoute(request: HttpRequest) -> HttpResponse {
        let requestMethod = request.returnMethod()
        let requestUrl = request.returnUrl()

        for route in routes {
            if route.key == requestUrl {
                for method in route.value {
                    if method == requestMethod {
                        return generate200Response()
                    }
                }
            }
        }

        return generate404Response()
    }

    private func generate200Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 200, statusPhrase: "OK", headers: ["Content-Length":"8", "Content-Type":"text/html"], body: pageTemplate(message: "All good"))
    }

    private func generate404Response() -> HttpResponse {
        return HttpResponse(version: "HTTP/1.1", statusCode: 404, statusPhrase: "NotFound", headers: ["Content-Length":"18", "Content-Type":"text/html"], body: pageTemplate(message: "URL does not exist"))
    }

    private func pageTemplate(message: String) -> String {
        let html = "<!DOCTYPE html \"><html>" +
                "<body>" +
                "<p> \(message) </p>" +
                "</body>" +
                "</html>"
        return html
    }
}
