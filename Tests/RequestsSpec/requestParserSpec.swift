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
        }
    }
}