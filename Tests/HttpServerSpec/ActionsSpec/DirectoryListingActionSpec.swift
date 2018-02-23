import HttpServer
import Quick
import Nimble
import Foundation

class DirectoryListingActionSpec : QuickSpec {
    override func spec() {
        describe("#DirectoryListingAction") {
            var action: DirectoryListingAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!
            var directoryNavigator: DirectoryNavigator!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                directoryNavigator = DirectoryNavigator(directoryPath: "./cob_spec/public")
                action = DirectoryListingAction(directoryNavigator: directoryNavigator, routesTable: routesTable, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("return a response with a directory in html format in the body") {
                let response = action.execute(request: request)

                let bodyContent = "<!DOCTYPE html><html><head><title>Directory Listing</title></head>" +
                        "<body><ul><li><a href=/file1> file1 </a></li><li><a href=/file2> file2 </a></li>" +
                        "<li><a href=/image.gif> image.gif </a></li><li><a href=/image.jpeg> image.jpeg </a></li>" +
                        "<li><a href=/image.png> image.png </a></li><li><a href=/partial_content.txt> partial_content.txt </a></li>" +
                        "<li><a href=/patch-content.txt> patch-content.txt </a></li><li><a href=/text-file.txt> text-file.txt </a></li></ul></body></html>"

                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(bodyContent.count),
                                  "Content-Type":"text/html"],
                        body: Data(bodyContent.utf8)
                )

                expect(response).to(equal(expected))
            }
        }
    }
}
