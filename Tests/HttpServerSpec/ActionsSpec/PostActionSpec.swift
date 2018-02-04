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
            var responseGenerator: ResponseGenerator!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
                action = PostAction(responseGenerator: responseGenerator, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.post,
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: ["Content": "Text", "My": "Value"]
                )

                it("generates a 200 response to an appropriate post request") {
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

                it("adds the content in the post request to dataStorage") {
                    let _ = action.execute(request: request)
                    let allValues = dataStorage.logValues()
                    let expectedValues = ["Content": "Text", "My": "Value"]
                    expect(allValues).to(equal(expectedValues))
                }
            }
        }
    }
}
