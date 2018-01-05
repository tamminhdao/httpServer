import Foundation
import Quick
import Nimble
import Router
import Requests
import Responses
import Values
import Actions

class RouterSpec: QuickSpec {
    override func spec() {
        describe("#Router") {
            var router: Router!
            var nullAction: NullAction!

            beforeEach {
                nullAction = NullAction()
                router = Router()
                router.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
                router.addRoute(route: Route(url: "/method_options2", method: HttpMethod.get, action: nullAction))
            }

            it ("adds new route to the list of available routes") {
                let allRoutes = router.showAllRoutes()
                expect(allRoutes[0].url).to(equal("/"))
                expect(allRoutes[0].method).to(equal(HttpMethod.get))
            }

            it ("identifies all allowed methods on an url") {
                let expectedVerbs = ["GET", "OPTIONS"]
                let allowedMethods = router.obtainMethods("method_options2")
                expect(allowedMethods).to(equal(allowedMethods))
            }

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

            it ("returns a 400 NotFound if the method/url combo is not correct") {
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
                        statusPhrase: "NotFound",
                        headers: ["Content-Length":String(("<p> URL does not exist </p>").count),
                                  "Content-Type":"text/html"],
                        body: "<p> URL does not exist </p>"
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(notFound))
            }
        }
    }
}
