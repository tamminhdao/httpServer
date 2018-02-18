import HttpServer
import Quick
import Nimble
import Foundation

class NullActionSpec: QuickSpec {
    override func spec() {
        describe("#NullAction") {
            var action: NullAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                action = NullAction(routesTable: routesTable, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("generates a 200 response to an appropriate request") {
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type": "text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": "",
                                  "Set-Cookie": ""],
                        body: Data()
                )
                expect(response).to(equal(expected))
            }
        }
    }
}
