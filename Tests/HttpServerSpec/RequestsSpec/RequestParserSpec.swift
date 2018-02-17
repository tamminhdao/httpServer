import Quick
import Nimble
import HttpServer

class RequestParserSpec: QuickSpec {
    override func spec() {
        describe("#RequestParser") {
            var httpParser: RequestParser!

            beforeEach {
                httpParser = RequestParser()
            }

            it ("throws an empty request error if the request is empty") {
                let emptyRequest = String()
                expect{try httpParser.parse(request: emptyRequest)}.to(throwError(RequestParserError.EmptyRequest))
            }

            it ("throws an invalid status line error if the request format is incorrect") {
                let badRequest = """
                Host: localhost:5000
                User-Agent: curl/7.54.0
                Accept: */*
                """
                expect {try httpParser.parse(request: badRequest)}.to(throwError(RequestParserError.InvalidStatusLine(badRequest)))
            }

            it ("returns an HttpRequest object if the incoming request is valid") {
                let validRequest = """
                    GET /logs?language=english&format=html HTTP/1.1
                    Host: localhost:5000
                    Connection: Keep-Alive
                    User-Agent: Apache-HttpClient/4.3.5 (java 1.5)
                    Accept-Encoding: gzip,deflate

                    Content=Text&My=Value
                    Protocol=html
                """

                let expected = HttpRequest(
                        method: HttpMethod.get,
                        url: "/logs",
                        params: ["language=english", "format=html"],
                        version: "HTTP/1.1",
                        headers: [
                            "Host": "localhost:5000",
                            "Connection": "Keep-Alive",
                            "User-Agent": "Apache-HttpClient/4.3.5 (java 1.5)",
                            "Accept-Encoding": "gzip,deflate"
                        ],
                        body: ["Content":"Text", "My":"Value", "Protocol":"html"]
                )

                do {
                    let parsedRequest = try httpParser.parse(request: validRequest)
                    expect(parsedRequest).to(equal(expected))
                } catch {
                }
            }
        }
    }
}
