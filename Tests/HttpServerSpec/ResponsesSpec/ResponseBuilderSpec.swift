import Quick
import Nimble
import HttpServer
import Foundation

class ResponseBuilderSpec: QuickSpec {
    override func spec() {
        describe("#ResponseBuilder") {
            var responseBuilder: ResponseBuilder!
            var dataStorage: DataStorage!

            beforeEach {
                dataStorage = DataStorage()
                responseBuilder = ResponseBuilder()
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
                let response200Head = responseBuilder.assemble200Response(request: request).build()
                let expectedResponse200Head = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html"],
                        body: Data()
                )
                expect(response200Head).to(equal(expectedResponse200Head))
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

            it ("can generate a 302 response") {
                let response302 = responseBuilder.assemble302Response().build()
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
                        headers: ["Content-Length": String(("404 Not Found").count),
                                  "Content-Type":"text/html"],
                        body: Data("404 Not Found".utf8)
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
