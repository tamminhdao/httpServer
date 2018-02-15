import Quick
import Nimble
import HttpServer
import Foundation

class PostActionSpec: QuickSpec {
    override func spec() {
        describe("#PostAction") {
            var action: PostAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                action = PostAction(routesTable: routesTable, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.post,
                        url: "/form",
                        params: [],
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
                        headers: ["Content-Length": String(Data("Content=Text My=Value ".utf8).count),
                                  "Content-Type": "text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: Data("Content=Text My=Value ".utf8)
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
