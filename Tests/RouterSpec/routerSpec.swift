import Foundation
import Quick
import Nimble
import Router
import Route
import Requests
import Responses
import Values
import Actions

class RouterSpec: QuickSpec {
    override func spec() {
        describe("#Router") {
            var router: Router!
            var routesTable: RoutesTable!
            var nullAction: NullAction!

            beforeEach {
                nullAction = NullAction()
                routesTable = RoutesTable()
                router = Router(routesTable: routesTable)
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
                routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.get, action: nullAction))
            }

//            it ("adds new route to the list of available routes") {
//                let allRoutes = router.showAllRoutes()
//                expect(allRoutes[0].url).to(equal("/"))
//                expect(allRoutes[0].method).to(equal(HttpMethod.get))
//                expect(allRoutes[0].action).to(be(nullAction))
//            }

            it ("returns a 200 OK response if the method/url combo is correct") {
                let validRequest = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let responseOK = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":String(("<p> Get Request has a body! </p>").count),
                                  "Content-Type":"text/html"],
                        body: "<p> Get Request has a body! </p>"
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(responseOK))
            }

            it ("returns a 404 Not Found if the url does not exist") {
                let validRequest = HttpRequest(
                        method: HttpMethod.head,
                        url: "/foobar",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let notFound = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 404,
                        statusPhrase: "Not Found",
                        headers: ["Content-Length":String(("<p> URL does not exist </p>").count),
                                  "Content-Type":"text/html"],
                        body: "<p> URL does not exist </p>"
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(notFound))
            }

            it ("returns a 405 Method Not Allowed if the url exists but it doesn't accept the verb") {
                let validRequest = HttpRequest(
                        method: HttpMethod.post,
                        url: "/",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let notFound = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 405,
                        statusPhrase: "Method Not Allowed",
                        headers: ["Content-Length":"0",
                                  "Content-Type":"text/html"],
                        body: ""
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(notFound))
            }
        }
    }
}
