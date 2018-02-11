import Foundation
import Quick
import Nimble
import HttpServer

class DeleteActionSpec: QuickSpec {
    override func spec() {
        describe("#DeleteAction") {
            var action: DeleteAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!
            var responseBuilder: ResponseBuilder!

            beforeEach {
                dataStorage = DataStorage()
                dataStorage.addData(url: "data", value: "fatcat")
                routesTable = RoutesTable()
                responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
                action = DeleteAction(responseBuilder: responseBuilder, dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.delete,
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("deletes all data in the data storage") {
                let _ = action.execute(request: request)
                let allValues = dataStorage.logData()
                let expectedValues : [String: String] = [:]
                expect(allValues).to(equal(expectedValues))
            }
        }
    }
}
