import Foundation
import Quick
import Nimble
import Actions
import Requests
import Values

class RedirectActionSpec: QuickSpec {
    override func spec() {
        describe("#RedirectAction") {
            var action: RedirectAction!
            var request: HttpRequest!
            var dataStorage: DataStorage!

            beforeEach {
                dataStorage = DataStorage()
                action = RedirectAction(redirectPath: "/", dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/redirect",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
            }

            it ("can insert location into the dataStorage") {
                action.execute(request: request)
                expect(dataStorage.myVals["location"]).to(equal("/"))
            }
        }
    }
}
