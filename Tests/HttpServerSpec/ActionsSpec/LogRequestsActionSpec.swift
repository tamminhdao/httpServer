import HttpServer
import Quick
import Nimble

class LogRequestsActionSpec: QuickSpec {
    override func spec() {
        describe("#LogRequestsAction") {
            var action: LogRequestsAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!
            var responseGenerator: ResponseGenerator!

            beforeEach {
                dataStorage = DataStorage()
                dataStorage.addToRequestList(request: "GET /foobar HTTP/1.1")
                routesTable = RoutesTable()
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
                action = LogRequestsAction(responseGenerator: responseGenerator)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/logs",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("generates a 200 response with a log of all the requests in dataStorage") {
                let response = action.execute(request: request)
                let body = "GET /foobar HTTP/1.1" + "\n"

                let expected = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(body.count),
                                  "Content-Type": "text/html"],
                        body: body
                )
                expect(response).to(equal(expected))
            }
        }
    }
}