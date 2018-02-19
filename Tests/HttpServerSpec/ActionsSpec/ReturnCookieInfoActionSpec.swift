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
            var routesTable: RoutesTable!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                action = ReturnCookieInfoAction(routesTable: routesTable, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/eat_cookie",
                        params: [],
                        version: "HTTP/1.1",
                        headers: ["Cookie": "flavor=chocolate"],
                        body: [:]
                )
            }

            it("generates a 200 response using info from the Cookie header of the request") {
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(Data("mmmm chocolate".utf8).count),
                                  "Content-Type": "text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": "",
                                  "Set-Cookie": ""],
                        body: Data("mmmm chocolate".utf8)
                )
                expect(response).to(equal(expected))
            }
        }
    }
}
