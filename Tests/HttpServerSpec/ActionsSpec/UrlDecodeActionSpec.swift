import Foundation
import Quick
import Nimble
import HttpServer

class UrlDecodeActionSpec: QuickSpec {
    override func spec() {
        describe("#UrlDecodeAction") {
            var action: UrlDecodeAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!

            beforeEach {
                dataStorage = DataStorage()
                action = UrlDecodeAction(dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/params",
                        params: ["%3C", "this=stuff"],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("can decode the params of a request") {
                let response = action.execute(request: request)
                let expectedResponse = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(("<this=stuff").count),
                                  "Content-Type": "text/html"],
                        body: Data("<this=stuff".utf8))
                
                expect(response).to(equal(expectedResponse))
            }
        }
    }
}
