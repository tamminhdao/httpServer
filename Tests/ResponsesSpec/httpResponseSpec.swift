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
        }
    }
}
