import Foundation
import Quick
import Nimble
import Requests

class HttpRequestSpec: QuickSpec {
    override func spec() {
        describe ("#HttpRequest") {
            var request: HttpRequest!

            beforeEach {
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [
                            "Host": "localhost:5000",
                            "User-Agent": "curl/7.54.0",
                            "Accept": "*/*"
                        ],
                        body: ["Content":"Text", "My":"Value"]
                )
            }

            it ("can return the method of a request") {
                let method = request.returnMethod()
                expect(method).to(equal(HttpMethod.get))
            }

            it ("can return the url of a request") {
                let method = request.returnUrl()
                expect(method).to(equal("/form"))
            }

            it ("can return the body of a request") {
                let method = request.returnBody()
                expect(method).to(equal(["Content":"Text", "My":"Value"]))
            }
        }
    }
}
