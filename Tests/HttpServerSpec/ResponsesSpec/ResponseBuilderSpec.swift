import Quick
import Nimble
import HttpServer

class ResponseBuilderSpec: QuickSpec {
    override func spec() {
        describe("#ResponseBuilder") {
            var responseBuilder: ResponseBuilder!
            var routesTable: RoutesTable!
            var dataStorage: DataStorage!
            var nullAction: NullAction!

            beforeEach {
                routesTable = RoutesTable()
                dataStorage = DataStorage()
                responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
                nullAction = NullAction(responseBuilder: responseBuilder)
            }

            it ("can generate a 200 response putting server data in the body") {
                dataStorage.addData(url: "/", value: "data=fatcat ")
                let response200: HttpResponse = responseBuilder
                        .setStatusCode(statusCode: 200)
                        .setStatusPhrase(statusPhrase: "OK")
                        .setContentType(contentType: "text/html")
                        .setBody(body: responseBuilder.obtainDataByUrlKey(url: "/"))
                        .build()

                let expectedResponse200 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":String(("data=fatcat ").count),
                                  "Content-Type":"text/html",
                                  "Allow": ""],
                        body: "data=fatcat "
                )

                expect(response200).to(equal(expectedResponse200))
            }

            it ("can generate a 200 response to an OPTIONS request") {
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.put, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.post, action: nullAction))

                let responseOptions: HttpResponse = responseBuilder
                        .setStatusCode(statusCode: 200)
                        .setStatusPhrase(statusPhrase: "OK")
                        .setContentType(contentType: "text/html")
                        .setAllow(url: responseBuilder.options(url: "/"))
                        .setBody(body: responseBuilder.obtainDataByUrlKey(url: "/"))
                        .build()

                let expectedResponseOptions = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                 "Content-Type":"text/html",
                                 "Allow": "GET, HEAD, PUT, POST"],
                        body: "")
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
                                  "Content-Type":"text/html",
                                  "Allow": ""],
                        body: ""
                )

                expect(response404).to(equal(expectedResponse404))
            }

            it ("can generate a 405 response") {
                let response405: HttpResponse = responseBuilder
                        .setStatusCode(statusCode: 405)
                        .setStatusPhrase(statusPhrase: "Method Not Allowed")
                        .setContentType(contentType: "text/html")
                        .setBody(body: "")
                        .build()


                let expectedResponse405 = HttpResponse(
                        statusCode: 405,
                        statusPhrase: "Method Not Allowed",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": ""],
                        body: ""
                )

                expect(response405).to(equal(expectedResponse405))
            }


        }
    }
}
