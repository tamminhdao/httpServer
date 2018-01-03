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
            var dataStorage: DataStorage!
//            var action: HttpActions!
            var nullAction: NullAction!

            beforeEach {
                dataStorage = DataStorage()
//                action = HttpActions(dataStorage: dataStorage)
                nullAction = NullAction(dataStorage: dataStorage)
                router = Router()
                router.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
            }

            it ("add new route to the list of available routes") {
                let allRoutes = router.showAllRoutes()
                expect(allRoutes[0].url).to(equal("/"))
                expect(allRoutes[0].method).to(equal(HttpMethod.get))

            }

            it ("return a 200 OK response if the method/url combo is correct") {
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

                let response = router.checkRoute(request: validRequest)
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
                        headers: ["Content-Length":"27",
                                  "Content-Type":"text/html"],
                        body: "<p> URL does not exist </p>"
                )

                let response = router.checkRoute(request: validRequest)
                expect(response).to(equal(notFound))
            }
        }
    }
}
