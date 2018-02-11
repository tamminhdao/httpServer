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

            it ("can generate a 200 response putting url data in the body") {
                dataStorage.addData(url: "/", value: "data=fatcat ")
                let response200 = responseBuilder.generate200Response(method: HttpMethod.get, url: "/")
                let expectedResponse200 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":String(("data=fatcat ").count),
                                  "Content-Type":"text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: "data=fatcat "
                )
                expect(response200).to(equal(expectedResponse200))
            }

            it ("can generate a 200 response with an empty body to a HEAD request") {
                dataStorage.addData(url: "/pets", value: "my=spoiled_cat ")
                let response200Head = responseBuilder.generate200Response(method: HttpMethod.head, url: "/pets")
                let expectedResponse200Head = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: ""
                )
                expect(response200Head).to(equal(expectedResponse200Head))
            }

            it ("can generate a 200 response to an OPTIONS request") {
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.put, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.post, action: nullAction))

                let responseOptions = responseBuilder.generate200Response(method: HttpMethod.options, url: "/")
                let expectedResponseOptions = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": "GET, HEAD, PUT, POST",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: "")
            }

            it ("can generate a 404 response") {
                let response404 = responseBuilder.generate404Response()
                let expectedResponse404 = HttpResponse(
                        statusCode: 404,
                        statusPhrase: "Not Found",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: ""
                )
                expect(response404).to(equal(expectedResponse404))
            }

            it ("can generate a 405 response") {
                let response405 = responseBuilder.generate405Response()
                let expectedResponse405 = HttpResponse(
                        statusCode: 405,
                        statusPhrase: "Method Not Allowed",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: ""
                )
                expect(response405).to(equal(expectedResponse405))
            }
        }
    }
}
