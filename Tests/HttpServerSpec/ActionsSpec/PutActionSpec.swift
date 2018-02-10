import Quick
import Nimble
import HttpServer

class PutActionSpec: QuickSpec {
    override func spec() {
        describe("#PutAction") {
            var action: PutAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!
            var responseBuilder: ResponseBuilder!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
                action = PutAction(responseBuilder: responseBuilder, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.put,
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: ["Content": "Text", "My": "Value"]
                )
            }

            it("generates a 200 response to an appropriate put request") {
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type": "text/html"],
                        body: ""
                )
                expect(response).to(equal(expected))
            }

            it("adds the content in the put request to dataStorage") {
                let _ = action.execute(request: request)
                let allValues = dataStorage.logData()
                let expectedValues = ["Content": "Text", "My": "Value"]
                expect(allValues).to(equal(expectedValues))
            }
        }
    }
}
