import HttpServer
import Quick
import Nimble
import Foundation

class DirectoryListingActionSpec : QuickSpec {
    override func spec() {
        describe("#DirectoryListingAction") {
            var action: DirectoryListingAction!
            var routesTable: RoutesTable!
            var directoryNavigator: DirectoryNavigator!

            beforeEach {
                routesTable = RoutesTable()
                directoryNavigator = DirectoryNavigator(directoryPath: "./cob_spec/public")
                action = DirectoryListingAction(directoryNavigator: directoryNavigator, routesTable: routesTable)
            }

            it ("fetches the directory content") {
                let request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                let response = action.execute(request: request)

                let bodyContent = "<!DOCTYPE html><html><head><title>Directory Listing</title></head>" +
                        "<body><ul><li><a href=/file1> /file1 </a></li><li><a href=/file2> /file2 </a></li>" +
                        "<li><a href=/image.gif> /image.gif </a></li><li><a href=/image.jpeg> /image.jpeg </a></li>" +
                        "<li><a href=/image.png> /image.png </a></li><li><a href=/partial_content.txt> /partial_content.txt </a></li>" +
                        "<li><a href=/patch-content.txt> /patch-content.txt </a></li><li><a href=/text-file.txt> /text-file.txt </a></li></ul></body></html>"

                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(bodyContent.count),
                                  "Content-Type":"text/html"],
                        body: Data(bodyContent.utf8)
                )

                expect(response).to(equal(expected))
            }

            it ("returns the correct file content in the body of the response") {
                let requestTextFile = HttpRequest(
                        method: HttpMethod.get,
                        url: "/text-file.txt",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                let response = action.execute(request: requestTextFile)

                let expectedResponse = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(Data("file1 contents".utf8).count),
                                  "Content-Type": "text/plain"],
                        body: Data("file1 contents".utf8))

                expect(response).to(equal(expectedResponse))
            }

            it ("sets content type as text/html if the file does not have an extension") {
                let requestFile = HttpRequest(
                        method: HttpMethod.get,
                        url: "/file2",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                let response = action.execute(request: requestFile)

                let expectedResponse = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(Data("file2 contents\n".utf8).count),
                                  "Content-Type": "text/html"],
                        body: Data("file2 contents\n".utf8))

                expect(response).to(equal(expectedResponse))
            }
        }
    }
}
