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
                nullAction = NullAction(routesTable: routesTable, dataStorage: dataStorage)
            }

            it ("can generate a 200 response putting url data in the body") {
                dataStorage.addData(url: "/", value: "data=fatcat ")
                let request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                let response200 = responseBuilder.generate200Response(request: request)
                let expectedResponse200 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":String(Data("data=fatcat ".utf8).count),
                                  "Content-Type":"text/html"],
                        body: Data("data=fatcat ".utf8)
                )
                expect(response200).to(equal(expectedResponse200))
            }

            it ("can generate a 200 response with an empty body to a HEAD request") {
                dataStorage.addData(url: "/pets", value: "my=spoiled_cat ")
                let request = HttpRequest(
                        method: HttpMethod.head,
                        url: "/pets",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                let response200Head = responseBuilder.generate200Response(request: request)
                let expectedResponse200Head = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html"],
                        body: Data()
                )
                expect(response200Head).to(equal(expectedResponse200Head))
            }

            it ("can generate a 200 response to an OPTIONS request") {
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.head, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.put, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.post, action: nullAction))
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.options, action: nullAction))
                let request = HttpRequest(
                        method: HttpMethod.options,
                        url: "/",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                let responseOptions = responseBuilder.generate200Response(request: request)
                let expectedResponseOptions = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": "GET,HEAD,PUT,POST,OPTIONS"],
                        body: Data())

                expect(responseOptions).to(equal(expectedResponseOptions))
            }

            it ("can generate a 200 response with directory listing") {
                let directory =  """
                         <!DOCTYPE html>
                             <html>
                                 <head>
                                     <title>Directory Listing</title>
                                 </head>
                                 <body>
                                     <ul>
                                         <li>
                                             <a href=file1> file1 </a>
                                         </li>
                                         <li>
                                             <a href=file2> file2 </a>
                                         </li>
                                     </ul>
                                 </body>
                             </html>
                         """
                let response200Directory = responseBuilder.generate200ResponseWithDirectoryListing(directory: directory)
                let expectedResponse200Directory = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(directory.count),
                                  "Content-Type":"text/html"],
                        body: Data(directory.utf8))

                expect(response200Directory).to(equal(expectedResponse200Directory))
            }
            
            it ("can generate a 200 response with the correct content type for a given file type and extension") {
                let response200FileContent = responseBuilder.generate200ResponseWithFileContent(content: Data(), contentType: (fileType: "image", fileExt: "jpg"))
                let expectedResponse200FileContent = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"image/jpg"],
                        body: Data())

                expect(response200FileContent).to(equal(expectedResponse200FileContent))
            }

            it ("can set cookie with parameters from the url") {
                let request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/my_cookie",
                        params: ["type=chocolate"],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                dataStorage.saveCookie(url: "/my_cookie", value: ["type=chocolate"])
                let response200Cookie = responseBuilder.generate200Response(request: request)

                let expectedResponse200Cookie = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type": "text/html",
                                  "Set-Cookie": "type=chocolate"],
                        body: Data()
                )

                expect(response200Cookie).to(equal(expectedResponse200Cookie))
            }

            it ("can generate a 302 response") {
                let response302 = responseBuilder.generate302Response()
                let expectedResponse302 = HttpResponse(
                statusCode: 302,
                statusPhrase: "Found",
                headers: ["Content-Length": "0",
                          "Content-Type":"text/html"],
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
                                  "Content-Type":"text/html"],
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
                                  "Content-Type":"text/html"],
                        body: Data()
                )
                expect(response405).to(equal(expectedResponse405))
            }
        }
    }
}
