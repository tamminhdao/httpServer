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
                response = HttpResponse.empty404Response()
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
                response.setStatusCode(status: 200)
                expect(response.getStatusCode()).to(equal(200))
            }

            it ("can edit the status phrase of a response") {
                response.setStatusPhrase(phrase: "OK")
                expect(response.getStatusPhrase()).to(equal("OK"))
            }

            it ("can add headers to the response") {
                response.setContentLength(length: "15")
                response.setContentType(type: "text/html")
                response.setAllow(allow: "GET, PUT, POST")
                response.setLocation(location: "Chicago")
                response.setCookie(cookie: "format=text")
                response.setWWWAuthenticate(authenticate: "password=secret")
                expect(response.getContentLength()).to(equal("15"))
                expect(response.getContentType()).to(equal("text/html"))
                expect(response.getAllow()).to(equal("GET, PUT, POST"))
                expect(response.getLocation()).to(equal("Chicago"))
                expect(response.getCookie()).to(equal("format=text"))
                expect(response.getWWWAuthenticate()).to(equal("password=secret"))
            }

            it ("can set the body of a response") {
                response.setBody(body: Data("this is the body".utf8))
                expect(response.getBody()).to(equal(Data("this is the body".utf8)))
            }

            it ("can reset all attribute of a response") {
                response.setStatusCode(status: 200)
                response.setStatusPhrase(phrase: "OK")
                response.setContentLength(length: "5")
                response.setContentType(type: "text/html")
                response.setAllow(allow: "GET, PUT, POST")
                response.setLocation(location: "Chicago")
                response.setCookie(cookie: "format=text")
                response.setWWWAuthenticate(authenticate: "password=secret")
                response.setBody(body: Data("Hello".utf8))
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
        }
    }
}
