import Foundation
import Quick
import Nimble
import Requests

class RequestParseSpec: QuickSpec {
    override func spec() {
        describe("#RequestParser") {
            var httpParser: RequestParser!

            beforeEach {
                httpParser = RequestParser()
            }

            it ("throw an error if the request is empty") {
                let emptyRequest = String()
                expect{try httpParser.parse(request: emptyRequest)}.to(throwError(RequestParserError.EmptyRequest))
            }

            it ("parse the status line correctly") {
                let sampleStatusLine = "GET / HTTP/1.1"
                let expected = (method: "GET", url: "/", version: "HTTP/1.1")
                do {
                    let (method, url, version) = try httpParser.parseStatusLine(statusLine: sampleStatusLine)
                    expect(method).to(equal(expected.method))
                    expect(url).to(equal(expected.url))
                    expect(version).to(equal(expected.version))
                } catch {
                    expect(false).to(beTrue())
                }
            }
        }
    }
}
