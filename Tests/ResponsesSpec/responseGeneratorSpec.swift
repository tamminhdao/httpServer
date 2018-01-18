import Foundation
import Quick
import Nimble
import Responses
import Requests
import Route
import Data

class responseGeneratorSpec: QuickSpec {
    override func spec() {
        describe("#ResponseGenerator") {
            var responseGenerator: ResponseGenerator!
            var routesTable: RoutesTable!
            var dataStorage: DataStorage!

            beforeEach {
                routesTable = RoutesTable()
                dataStorage = DataStorage()
                dataStorage.addValues(key: "data", value: "fatcat")
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
            }
            it ("can generate a response for a GET request putting server data in the body") {
                let expectedResponse = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":String(("data=fatcat").count),
                                  "Content-Type":"text/html"],
                        body: "data=fatcat"
                )

                let response = responseGenerator.generate200Response(method: HttpMethod.get, url: "/")

                expect(response).to(equal(expectedResponse))
            }
        }
    }
}
