import Foundation
import Quick
import Nimble
import Responses

class HttpResponseSpec: QuickSpec {
    override func spec() {
        describe ("#HttpResponse") {
            it ("can equate two response objects") {
                let response1 = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: [:]
                )

                let response2 = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: [:]
                )

                expect(response1).to(equal(response2))
            }

            it ("can convert a response object to type Data") {
                let response = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":"0"]
                )

                let data = response.constructResponse()
                //print(data)
                let expected = Data("HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n".utf8)
                expect(data).to(equal(expected))
            }
        }
    }
}
