import Quick
import Nimble
import HttpServer
import Foundation

class ReturnCookieInfoActionSpec: QuickSpec {
    override func spec() {
        describe("#ReturnCookieInfoAction") {
            var action: ReturnCookieInfoAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!

            beforeEach {
                dataStorage = DataStorage()
                action = ReturnCookieInfoAction(dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/eat_cookie",
                        params: [],
                        version: "HTTP/1.1",
                        headers: ["Cookie": "type=vegan; flavor=chocolate"],
                        body: [:]
                )
            }

            it("generates the correct response using info from the Cookie header from the request") {
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/eat_cookie",
                        params: [],
                        version: "HTTP/1.1",
                        headers: ["Cookie": "flavor=chocolate"],
                        body: [:]
                )
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(Data("mmmm chocolate\n".utf8).count),
                                  "Content-Type": "text/html"],
                        body: Data("mmmm chocolate\n".utf8)
                )
                expect(response).to(equal(expected))
            }

            it("generates the correct response when there are more than one piece of cookie data") {
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/eat_cookie",
                        params: [],
                        version: "HTTP/1.1",
                        headers: ["Cookie": "type=vegan; flavor=chocolate"],
                        body: [:]
                )
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(Data("mmmm vegan\nmmmm chocolate\n".utf8).count),
                                  "Content-Type": "text/html"],
                        body: Data("mmmm vegan\nmmmm chocolate\n".utf8)
                )
                expect(response).to(equal(expected))
            }
        }
    }
}
