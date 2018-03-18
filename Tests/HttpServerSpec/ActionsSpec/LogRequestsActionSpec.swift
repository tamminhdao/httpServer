import Quick
import Nimble
import HttpServer
import Foundation

class LogRequestsActionSpec: QuickSpec {
    override func spec() {
        describe("#LogRequestsAction") {
            var action: LogRequestsAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
//            var routesTable: RoutesTable!

            beforeEach {
                dataStorage = DataStorage()
                dataStorage.addToRequestList(request: "PUT /form HTTP/1.1")
                dataStorage.addToRequestList(request: "HEAD /requests HTTP/1.1")
//                routesTable = RoutesTable()
                action = LogRequestsAction(dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/logs",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("logs the content from the request into dataStorage") {
                let response200Logs = action.execute(request: request)
                let bodyContent = "PUT /form HTTP/1.1\nHEAD /requests HTTP/1.1\n"

                let expectedResponse200Logs = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(Data(bodyContent.utf8).count),
                                  "Content-Type":"text/html"],
                        body: Data(bodyContent.utf8)
                )

                expect(response200Logs).to(equal(expectedResponse200Logs))

            }
        }
    }
}
