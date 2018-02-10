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
                responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
            }

            it ("can generate a 200 response putting server data in the body") {
                dataStorage.addData(key: "data", value: "fatcat")
                let response200: HttpResponse = responseBuilder
                        .setStatusCode(statusCode: 200)
                        .setStatusPhrase(statusPhrase: "OK")
                        .setContentType(contentType: "text/html")
                        .setBody(body: responseBuilder.obtainDataFromStorage())
                        .build()

                let expectedResponse200 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":String(("data=fatcat \n").count),
                                  "Content-Type":"text/html"],
                        body: "data=fatcat \n"
                )

                expect(response200).to(equal(expectedResponse200))
            }

            it ("can generate a 404 response") {
                let response404: HttpResponse = responseBuilder
                        .setStatusCode(statusCode: 404)
                        .setStatusPhrase(statusPhrase: "Not Found")
                        .setContentType(contentType: "text/html")
                        .setBody(body: "")
                        .build()


                let expectedResponse404 = HttpResponse(
                        statusCode: 404,
                        statusPhrase: "Not Found",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html"],
                        body: ""
                )

                expect(response404).to(equal(expectedResponse404))
            }
        }
    }
}
