import HttpServer
import Quick
import Nimble
import Foundation

class RedirectActionSpec : QuickSpec {
    override func spec() {
        describe("#RedirectAction") {
            var action: RedirectAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                action = RedirectAction(redirectPath: "/", routesTable: routesTable, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/redirect",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("saves the location into dataStorage") {
                action.execute(request: request)
                expect(dataStorage.getLocation()).to(equal("/"))
            }

            it ("returns a 302 Found response") {
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 302,
                        statusPhrase: "Found",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Location": "/"],
                        body: Data()
                )
                expect(response).to(equal(expected))
            }
        }
    }
}
