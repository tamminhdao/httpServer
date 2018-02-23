import Foundation
import Quick
import Nimble
import HttpServer
import Foundation

class HttpResponseSpec: QuickSpec {
    override func spec() {
        describe ("#HttpResponse") {
            var response: HttpResponse!

            beforeEach {
                response = HttpResponse.emptyResponse()
            }

            it ("can equate two response objects") {
                let response1 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: [:],
                        body: Data()
                )

                let response2 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: [:],
                        body: Data()
                )

                expect(response1).to(equal(response2))
            }

            it ("can convert a response object to type Data") {
                let response200 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":"5"],
                        body : Data("Hello".utf8)
                )

                let data = response200.constructResponse()
                let expected = Data("HTTP/1.1 200 OK\r\nContent-Length: 5\r\n\r\nHello".utf8)
                expect(data).to(equal(expected))
            }

            it ("can edit the status code of a response") {
                response.setResponseStatusCode(status: 200)
                expect(response.getResponseStatusCode()).to(equal(200))
            }

            it ("can edit the status phrase of a response") {
                response.setResponseStatusPhrase(phrase: "OK")
                expect(response.getResponseStatusPhrase()).to(equal("OK"))
            }

            it ("can add headers to the response") {
                response.setResponseContentLength(length: "15")
                response.setResponseContentType(type: "text/html")
                response.setResponseAllow(allow: "GET, PUT, POST")
                response.setResponseLocation(location: "Chicago")
                response.setResponseCookie(cookie: "format=text")
                response.setResponseWWWAuthenticate(authenticate: "password=secret")
                expect(response.getResponseContentLength()).to(equal("15"))
                expect(response.getResponseContentType()).to(equal("text/html"))
                expect(response.getResponseAllow()).to(equal("GET, PUT, POST"))
                expect(response.getResponseLocation()).to(equal("Chicago"))
                expect(response.getResponseCookie()).to(equal("format=text"))
                expect(response.getResponseWWWAuthenticate()).to(equal("password=secret"))
            }

            it ("can set the body of a response") {
                response.setResponseBody(body: Data("this is the body".utf8))
                expect(response.getResponseBody()).to(equal(Data("this is the body".utf8)))
            }

            it ("can reset all attribute of a response") {
                response.setResponseStatusCode(status: 200)
                response.setResponseStatusPhrase(phrase: "OK")
                response.setResponseContentLength(length: "5")
                response.setResponseContentType(type: "text/html")
                response.setResponseAllow(allow: "GET, PUT, POST")
                response.setResponseLocation(location: "Chicago")
                response.setResponseCookie(cookie: "format=text")
                response.setResponseWWWAuthenticate(authenticate: "password=secret")
                response.setResponseBody(body: Data("Hello".utf8))
                let expectedResponse = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "5",
                                  "Content-Type":"text/html",
                                  "Allow": "GET, PUT, POST",
                                  "Location": "Chicago",
                                  "WWW-Authenticate": "password=secret",
                                  "Set-Cookie": "format=text"],
                        body: Data("Hello".utf8))
                expect(response).to(equal(expectedResponse))
            }

            it ("does not add a header if its value is an empty string") {
                response.setResponseStatusCode(status: 200)
                response.setResponseStatusPhrase(phrase: "OK")
                response.setResponseContentLength(length: "5")
                response.setResponseContentType(type: "text/html")
                response.setResponseAllow(allow: "")
                response.setResponseLocation(location: "")
                response.setResponseCookie(cookie: "")
                response.setResponseWWWAuthenticate(authenticate: "")
                response.setResponseBody(body: Data("Hello".utf8))
                let expectedResponse = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "5",
                                  "Content-Type":"text/html"],
                        body: Data("Hello".utf8))
                expect(response).to(equal(expectedResponse))
            }
        }
    }
}
