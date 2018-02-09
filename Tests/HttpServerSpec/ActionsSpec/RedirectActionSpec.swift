import HttpServer
import Quick
import Nimble

class RedirectActionSpec : QuickSpec {
    override func spec() {
        describe("#RedirectAction") {
            var action: RedirectAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!
            var responseBuilder: ResponseBuilder!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
                action = RedirectAction(redirectPath: "/", responseBuilder: responseBuilder, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/redirect",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("saves the location into dataStorage") {
                let _ = action.execute(request: request)
                expect(dataStorage.getLocation()).to(equal("/"))
            }

            it ("returns a 302 Found response") {
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 302,
                        statusPhrase: "Found",
                        headers: ["Content-Length": "0",
                                  "Location": "/"],
                        body: ""
                )
                expect(response).to(equal(expected))
            }
        }
    }
}
