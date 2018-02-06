import HttpServer
import Quick
import Nimble

class DirectoryListingActionSpec : QuickSpec {
    override func spec() {
        describe("#DirectoryListingAction") {
            var action: DirectoryListingAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!
            var responseGenerator: ResponseGenerator!
            var directoryNavigator: DirectoryNavigator!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                directoryNavigator = DirectoryNavigator()
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
                action = DirectoryListingAction(directoryNavigator: directoryNavigator, responseGenerator: responseGenerator)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("return a response with a directory in html format in the body") {
                let response = action.execute(request: request)

                let bodyContent =
                        """
                         <!DOCTYPE html>
                             <html>
                                 <head>
                                     <title>Directory Listing</title>
                                 </head>
                                 <body>
                                     <ul>
                                         <li>
                                             <a href=/file1> file1 </a>
                                         </li>
                                         <li>
                                             <a href=/file2> file2 </a>
                                         </li>
                                         <li>
                                             <a href=/image.gif> image.gif </a>
                                         </li>
                                         <li>
                                             <a href=/image.jpeg> image.jpeg </a>
                                         </li>
                                         <li>
                                             <a href=/image.png> image.png </a>
                                         </li>
                                         <li>
                                             <a href=/partial_content.txt> partial_content.txt </a>
                                         </li>
                                         <li>
                                             <a href=/patch-content.txt> patch-content.txt </a>
                                         </li>
                                         <li>
                                             <a href=/text-file.txt> text-file.txt </a>
                                         </li>
                                     </ul>
                                 </body>
                             </html>
                         """

                let expected = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":"469",
                                  "Content-Type":"text/html"],
                        body: bodyContent
                )

                expect(response).to(equal(expected))
            }
        }
    }
}
