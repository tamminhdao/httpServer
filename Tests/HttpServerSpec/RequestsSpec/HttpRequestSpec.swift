import Quick
import Nimble
import HttpServer

class HttpRequestSpec: QuickSpec {
    override func spec() {
        describe ("#HttpRequest") {
            var request: HttpRequest!

            beforeEach {
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/form",
                        params: [],
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
                let url = request.returnUrl()
                expect(url).to(equal("/form"))
            }

            it ("can return the body of a request") {
                let body = request.returnBody()
                expect(body).to(equal(["Content":"Text", "My":"Value"]))
            }

            it ("can return the correct http version of a request") {
                let version = request.returnVersion()
                expect(version).to(equal("HTTP/1.1"))
            }

            it ("can return the headers of a request") {
                let headers = request.returnHeaders()
                let expected = [
                    "Host": "localhost:5000",
                    "User-Agent": "curl/7.54.0",
                    "Accept": "*/*"
                ]
                expect(headers).to(equal(expected))
            }
        }
    }
}
