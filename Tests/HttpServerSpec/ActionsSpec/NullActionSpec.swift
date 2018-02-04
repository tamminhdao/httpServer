import HttpServer
import Quick
import Nimble

class NullActionSpec: QuickSpec {
    override func spec() {
        describe("#NullAction") {
            var action: NullAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!
            var responseGenerator: ResponseGenerator!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
                action = NullAction(responseGenerator: responseGenerator)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                it ("generates a 200 response to an appropriate request") {
                    let response = action.execute(request: request)
                    let expected = HttpResponse(
                            version: "HTTP/1.1",
                            statusCode: 200,
                            statusPhrase: "OK",
                            headers: ["Content-Length": "0",
                                      "Content-Type": "text/html"],
                            body: ""
                    )
                    expect(response).to(equal(expected))
                }
            }
        }
    }
}
