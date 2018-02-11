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

            let logger = Logger()

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
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.options, action: nullAction))

                let responseOptions = responseBuilder.generate200Response(method: HttpMethod.options, url: "/")
                let expectedResponseOptions = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": " GET, HEAD, PUT, POST, OPTIONS,",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: "")

                expect(responseOptions).to(equal(expectedResponseOptions))
            }

            it ("can generate a 302 response") {
                let response302 = responseBuilder.generate302Response()
                let expectedResponse302 = HttpResponse(
                        statusCode: 302,
                        statusPhrase: "Found",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: ""
                )

//
//                let realData = response302.constructResponse()
//                logger.logToConsole_debug(message: String(data: realData, encoding: .utf8)!)

                expect(response302).to(equal(expectedResponse302))
            }

            it ("can generate a 401 response") {
                let response401 = responseBuilder.generate401Response(realm: "basic-auth")
                let expectedResponse401 = HttpResponse(
                        statusCode: 401,
                        statusPhrase: "Unauthorized",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": "Basic realm=basic-auth"],
                        body: ""
                )
                expect(response401).to(equal(expectedResponse401))
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
