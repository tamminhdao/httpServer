import Foundation
import Requests
import Actions
import Data
import Quick
import Nimble

class PutActionsSpec: QuickSpec {
    override func spec() {
        describe ("#PutAction") {
            var action: PutAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!

            beforeEach {
                dataStorage = DataStorage()
                action = PutAction(dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.put,
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: ["Content":"Text", "My":"Value"]
                )
            }

            it ("can perform a put action") {
                action.execute(request: request)
                let allValues = dataStorage.logValues()
                let expectedValues = ["Content":"Text", "My":"Value"]
                expect(allValues).to(equal(expectedValues))
            }
        }
    }
}
