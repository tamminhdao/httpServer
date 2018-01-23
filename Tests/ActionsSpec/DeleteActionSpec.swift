import Foundation
import Quick
import Nimble
import Actions
import Data
import Requests

class DeleteActionSpec: QuickSpec {
    override func spec() {
        describe("#DeleteAction") {
            var action: DeleteAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!

            beforeEach {
                dataStorage = DataStorage()
                dataStorage.addValues(key: "data", value: "fatcat")
                action = DeleteAction(dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.delete,
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("deletes all data in the data storage") {
                action.execute(request: request)
                let allValues = dataStorage.logValues()
                let expectedValues : [String: String] = [:]
                expect(allValues).to(equal(expectedValues))
            }
        }
    }
}
