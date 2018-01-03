import Foundation
import Requests
import Actions
import Values
import Quick
import Nimble

class HttpActionsSpec: QuickSpec {
    override func spec() {
        describe ("#HttpActions") {
            var action: HttpActions!
            var dataStorage: DataStorage!
            var request: HttpRequest!

            beforeEach {
                dataStorage = DataStorage()
                action = HttpActions(dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.put,
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: ["Content":"Text", "My":"Value"]
                )
            }

            it ("can perform a put action") {
                action.putAction(request: request)
                let allValues = dataStorage.logValues()
                let expectedValues = ["Content":"Text", "My":"Value"]
                expect(allValues).to(equal(expectedValues))
            }
        }
    }
}
