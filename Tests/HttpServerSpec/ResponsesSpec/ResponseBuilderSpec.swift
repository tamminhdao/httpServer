import Quick
import Nimble
import HttpServer
import Foundation

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
                        headers: ["Content-Length":String(Data("data=fatcat ".utf8).count),
                                  "Content-Type":"text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: Data("data=fatcat ".utf8)
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
                        body: Data()
                )
                expect(response200Head).to(equal(expectedResponse200Head))
            }

            it ("can generate a 200 response logging all incoming requests for /logs route") {
                dataStorage.addToRequestList(request: "PUT /form HTTP/1.1")
                dataStorage.addToRequestList(request: "HEAD /requests HTTP/1.1")
                let response200Logs = responseBuilder.generate200Response(method: HttpMethod.get, url: "/logs")
                let bodyContent = "PUT /form HTTP/1.1\nHEAD /requests HTTP/1.1\n"

                let expectedResponse200Logs = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(Data(bodyContent.utf8).count),
                                  "Content-Type":"text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: Data(bodyContent.utf8)
                )

                expect(response200Logs).to(equal(expectedResponse200Logs))
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
                                  "Allow": "GET,HEAD,PUT,POST,OPTIONS,",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: Data())

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
                        body: Data()
                )

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
                        body: Data()
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
                        body: Data()
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
                        body: Data()
                )
                expect(response405).to(equal(expectedResponse405))
            }
        }
    }
}
