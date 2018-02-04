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
            var responseGenerator: ResponseGenerator!

            beforeEach {
                dataStorage = DataStorage()
                dataStorage.addValues(key: "data", value: "fatcat")
                routesTable = RoutesTable()
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
                action = DeleteAction(responseGenerator: responseGenerator, dataStorage: dataStorage)
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
                let allValues = dataStorage.logValues()
                let expectedValues : [String: String] = [:]
                expect(allValues).to(equal(expectedValues))
            }
        }
    }
}
