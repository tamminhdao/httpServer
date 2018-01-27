import Quick
import Nimble
import HttpServer

class PostActionsSpec: QuickSpec {
    override func spec() {
        describe ("#PostAction") {
            var action: PostAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!

            beforeEach {
                dataStorage = DataStorage()
                action = PostAction(dataStorage: dataStorage)
                request = HttpRequest(
                        method: HttpMethod.post,
                        url: "/form",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: ["Content":"Text", "My":"Value"]
                )
            }

            it ("can perform a post action") {
                action.execute(request: request)
                let allValues = dataStorage.logValues()
                let expectedValues = ["Content":"Text", "My":"Value"]
                expect(allValues).to(equal(expectedValues))
            }
        }
    }
}
