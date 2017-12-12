import Foundation
import Quick
import Nimble
import Requests

class HttpRequestSpec: QuickSpec {
    override func spec() {
        describe ("#HttpRequest") {
            it ("can return the method of a request") {
                let request = HttpRequest(
                        method: "GET",
                        url: "/",
                        version: "HTTP/1.1",
                        headers: [
                            "Host": "localhost:5000",
                            "User-Agent": "curl/7.54.0",
                            "Accept": "*/*"
                        ]
                )

                let method = request.returnMethod()
                expect(method).to(equal("GET"))
            }

            it ("can return the url of a request") {
                let request = HttpRequest(
                        method: "GET",
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [
                            "Host": "localhost:5000",
                            "User-Agent": "curl/7.54.0",
                            "Accept": "*/*"
                        ]
                )

                let method = request.returnUrl()
                expect(method).to(equal("/form"))
            }
        }
    }
}
