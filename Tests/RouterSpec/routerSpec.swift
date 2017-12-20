import Foundation
import Quick
import Nimble
import Router
import Requests
import Responses
import Values

class RouterSpec: QuickSpec {
    override func spec() {
        describe("#Router") {
            var router: Router!
            var data: DataStorage!

            beforeEach {
                data = DataStorage()
                router = Router(input: data)
            }

            it ("return a 200 OK response if the method/url combo is correct") {
                let validRequest = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        version: "HTTP/1.1",
                        headers: [
                            "Host": "localhost:5000",
                            "User-Agent": "curl/7.54.0",
                            "Accept": "*/*"
                        ],
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
                        method: HttpMethod.get,
                        url: "/foobar",
                        version: "HTTP/1.1",
                        headers: [
                            "Host": "localhost:5000",
                            "User-Agent": "curl/7.54.0",
                            "Accept": "*/*"
                        ],
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
