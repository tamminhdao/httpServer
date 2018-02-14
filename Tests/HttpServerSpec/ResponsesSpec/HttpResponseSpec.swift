import Foundation
import Quick
import Nimble
import HttpServer
import Foundation

class HttpResponseSpec: QuickSpec {
    override func spec() {
        describe ("#HttpResponse") {
            it ("can equate two response objects") {
                let response1 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: [:],
                        body: Data()
                )

                let response2 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: [:],
                        body: Data()
                )

                expect(response1).to(equal(response2))
            }

            it ("can convert a response object to type Data") {
                let response = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":"5"],
                        body : Data("Hello".utf8)
                )

                let data = response.constructResponse()
                let expected = Data("HTTP/1.1 200 OK\r\nContent-Length: 5\r\n\r\nHello".utf8)
                expect(data).to(equal(expected))
            }
        }
    }
}
