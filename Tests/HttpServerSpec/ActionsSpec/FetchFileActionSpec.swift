import HttpServer
import Quick
import Nimble

class FetchFileActionSpec : QuickSpec {
    override func spec() {
        describe("#FetchFileAction") {
            var action: FetchFileAction!
            var request: HttpRequest!
            var responseBuilder: ResponseBuilder!
            var dataStorage: DataStorage!
            var routesTable: RoutesTable!
            var directoryNavigator: DirectoryNavigator!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                directoryNavigator = DirectoryNavigator(directoryPath: "./cob_spec/public")
                responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
                action = FetchFileAction(directoryNavigator: directoryNavigator, responseBuilder: responseBuilder)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/image",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("returns the requested file in the body of the response") {

            }
        }
    }
}
