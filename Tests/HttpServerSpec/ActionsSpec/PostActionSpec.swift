import Quick
import Nimble
import HttpServer

class PostActionSpec: QuickSpec {
    override func spec() {
        describe("#PostAction") {
            var action: PostAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!
            var responseBuilder: ResponseBuilder!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
                action = PostAction(responseBuilder: responseBuilder, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.post,
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: ["Content": "Text", "My": "Value"]
                )
            }

            it("generates a 200 response to an appropriate post request") {
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(("Content=Text My=Value ").count),
                                  "Content-Type": "text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: "Content=Text My=Value "
                )
                expect(response).to(equal(expected))
            }

            it("adds the content in the post request to dataStorage") {
                action.execute(request: request)
                let allValues = dataStorage.logDataByUrl(url: "/form")
                let expectedValues = "Content=Text My=Value "
                expect(allValues).to(equal(expectedValues))
            }
        }
    }
}
