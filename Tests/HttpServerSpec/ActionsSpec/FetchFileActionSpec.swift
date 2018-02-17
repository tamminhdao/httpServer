import HttpServer
import Quick
import Nimble
import Foundation

class FetchFileActionSpec : QuickSpec {
    override func spec() {
        describe("#FetchFileAction") {
            var action: FetchFileAction!
            var dataStorage: DataStorage!
            var routesTable: RoutesTable!
            var directoryNavigator: DirectoryNavigator!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                directoryNavigator = DirectoryNavigator(directoryPath: "./cob_spec/public")
                action = FetchFileAction(directoryNavigator: directoryNavigator, routesTable: routesTable, dataStorage: dataStorage)
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
                                  "Content-Type": "text/plain",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
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
                                  "Content-Type": "text/html",
                                  "Allow": "",
                                  "Location": "",
                                  "WWW-Authenticate": ""],
                        body: Data("file2 contents\n".utf8))

                expect(response).to(equal(expectedResponse))
            }
        }
    }
}
