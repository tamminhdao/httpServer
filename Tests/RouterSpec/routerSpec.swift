import Foundation
import Quick
import Nimble
import Router
import Requests
import Responses

class RouterSpec: QuickSpec {
    override func spec() {
        describe("#Router") {
            var router: Router!

            beforeEach {
                router = Router()
            }

            it ("return a 200 OK response if the method/url combo is correct") {
                let validRequest = HttpRequest(
                        method: "GET",
                        url: "/",
                        version: "HTTP/1.1",
                        headers: [
                            "Host": "localhost:5000",
                            "User-Agent": "curl/7.54.0",
                            "Accept": "*/*"
                        ]
                )

                let responseOK = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: [:]
                )

                let response = router.checkRoute(request: validRequest)
                expect(response).to(equal(responseOK))
            }

            it ("returns a 400 NotFound if the method/url combo is not correct") {
                let validRequest = HttpRequest(
                        method: "GET",
                        url: "/foobar",
                        version: "HTTP/1.1",
                        headers: [
                            "Host": "localhost:5000",
                            "User-Agent": "curl/7.54.0",
                            "Accept": "*/*"
                        ]
                )

                let notFound = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 404,
                        statusPhrase: "NotFound",
                        headers: [:]
                )

                let response = router.checkRoute(request: validRequest)
                expect(response).to(equal(notFound))
            }
        }
    }
}
