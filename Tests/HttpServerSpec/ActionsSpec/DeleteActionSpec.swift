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

            beforeEach {
                dataStorage = DataStorage()
                dataStorage.addData(url: "/form", value: "data=fatcat")
                action = DeleteAction(dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.delete,
                        url: "/form",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("deletes all data in the data storage") {
                action.execute(request: request)
                let allValues = dataStorage.logData()
                let expectedValues : [String: String] = [:]
                expect(allValues).to(equal(expectedValues))
            }
        }
    }
}
