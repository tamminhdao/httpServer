import HttpServer
import Quick
import Nimble

class FetchFileActionSpec : QuickSpec {
    override func spec() {
        describe("#FetchFileAction") {
            var action: FetchFileAction!
            var request: HttpRequest!
            var responseGenerator: ResponseGenerator!
            var dataStorage: DataStorage!
            var routesTable: RoutesTable!
            var directoryNavigator: DirectoryNavigator!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                directoryNavigator = DirectoryNavigator()
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
                action = FetchFileAction(directoryNavigator: directoryNavigator, responseGenerator: responseGenerator)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/image",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("returns the requested file in the body of the response") {
                let response = action.execute(request: request)
            }
        }
    }
}
