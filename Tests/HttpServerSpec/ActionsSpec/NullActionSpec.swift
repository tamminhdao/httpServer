import HttpServer
import Quick
import Nimble
import Foundation

class NullActionSpec: QuickSpec {
    override func spec() {
        describe("#NullAction") {
            var action: NullAction!
            var dataStorage: DataStorage!
            var request: HttpRequest!
            var routesTable: RoutesTable!

            beforeEach {
                dataStorage = DataStorage()
                routesTable = RoutesTable()
                action = NullAction(routesTable: routesTable, dataStorage: dataStorage)
            }

            it("generates a 200 response to an appropriate request") {
                request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                let response = action.execute(request: request)
                let expected = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type": "text/html"],
                        body: Data()
                )
                expect(response).to(equal(expected))
            }

            it("can set cookie with parameters from the url") {
                let request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/my_cookie",
                        params: ["type=chocolate"],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                dataStorage.saveCookie(url: "/my_cookie", value: ["type=chocolate"])
                let response200Cookie = action.execute(request: request)

                let expectedResponse200Cookie = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type": "text/html",
                                  "Set-Cookie": "type=chocolate"],
                        body: Data()
                )
                expect(response200Cookie).to(equal(expectedResponse200Cookie))
            }

            it ("can generate a 200 response obtaining content from dataStorage for the body") {
                dataStorage.addData(url: "/", value: "data=fatcat ")
                let request = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                let response200 = action.execute(request: request)
                let expectedResponse200 = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":String(Data("data=fatcat ".utf8).count),
                                  "Content-Type":"text/html"],
                        body: Data("data=fatcat ".utf8)
                )
                expect(response200).to(equal(expectedResponse200))
            }

            it ("can generate a response for an OPTIONS method with the Allow header") {
                routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.get, action: action))
                routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.put, action: action))
                routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.post, action: action))
                routesTable.addRoute(route: Route(url: "/form", method: HttpMethod.delete, action: action))

                request = HttpRequest(
                        method: HttpMethod.options,
                        url: "/form",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )
                let response = action.execute(request: request)
                let expectedResponse = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type": "text/html",
                                  "Allow": "GET,PUT,POST,DELETE"
                        ],
                        body: Data()
                )
                expect(response).to(equal(expectedResponse))
            }
        }
    }
}
