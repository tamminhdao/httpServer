import Quick
import Nimble
import HttpServer
import Foundation

class PutActionSpec: QuickSpec {
    override func spec() {
        describe("#PutAction") {
            var action: PutAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                action = PutAction(routesTable: routesTable, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.put,
                        url: "/form",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: ["Content": "Text", "My": "Value"]
                )
            }

            it ("logs the content from the request into dataStorage") {
                action.execute(request: request)
                let value = dataStorage.logDataByUrl(url: "/form")
                let expected = "Content=Text My=Value "
                expect(value).to(equal(expected))
            }

            it("generates a 200 response to an appropriate put request") {
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(Data("Content=Text My=Value ".utf8).count),
                                  "Content-Type": "text/html"],
                        body: Data("Content=Text My=Value ".utf8)
                )
                expect(response).to(equal(expected))
            }
        }
    }
}
