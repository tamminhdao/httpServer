import Quick
import Nimble
import HttpServer

class ResponseGeneratorSpec: QuickSpec {
    override func spec() {
        describe("#ResponseGenerator") {
            var responseBuilder: ResponseBuilder!
            var routesTable: RoutesTable!
            var dataStorage: DataStorage!

            beforeEach {
                routesTable = RoutesTable()
                dataStorage = DataStorage()
                dataStorage.addValues(key: "data", value: "fatcat")
                responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
            }
            it ("can generate a response for a GET request putting server data in the body") {
                let response: HttpResponse = responseBuilder
                        .setStatusCode(statusCode: 200)
                        .setStatusPhrase(statusPhrase: "OK")
                        .setContentType(contentType: "text/html")
                        .setBody(body: "data=fatcat \n")
                        .build()

                let expectedResponse = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":String(("data=fatcat \n").count),
                                  "Content-Type":"text/html"],
                        body: "data=fatcat \n"
                )

                expect(response).to(equal(expectedResponse))
            }
        }
    }
}
