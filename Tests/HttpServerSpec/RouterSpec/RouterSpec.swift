import Quick
import Nimble
import HttpServer

class RouterSpec: QuickSpec {
    override func spec() {
        describe("#Router") {
            var router: Router!
            var routesTable: RoutesTable!
            var responseGenerator: ResponseGenerator!
            var dataStorage: DataStorage!
            var nullAction: NullAction!

            beforeEach {
                routesTable = RoutesTable()
                dataStorage = DataStorage()
                dataStorage.addValues(key: "data", value: "fatcat")
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
                router = Router(routesTable: routesTable, responseGenerator: responseGenerator)
                nullAction = NullAction()
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
                routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.get, action: nullAction))
                routesTable.addRoute(route: Route(url: "/redirect", method: HttpMethod.get, action: RedirectAction(redirectPath: "/", dataStorage: dataStorage)))
            }

            it ("returns a 200 OK response if the method/url combo is correct") {

                let validRequest = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let responseOK = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length":String("data=fatcat".count),
                                  "Content-Type":"text/html"],
                        body: "data=fatcat"
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(responseOK))
            }

            it ("returns a 404 Not Found if the url does not exist") {
                let validRequest = HttpRequest(
                        method: HttpMethod.head,
                        url: "/foobar",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let notFoundResponse = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 404,
                        statusPhrase: "Not Found",
                        headers: ["Content-Length":String(("<p> URL does not exist </p>").count),
                                  "Content-Type":"text/html"],
                        body: "<p> URL does not exist </p>"
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(notFoundResponse))
            }

            it ("returns a 405 Method Not Allowed if the url exists but it doesn't accept the verb") {
                let validRequest = HttpRequest(
                        method: HttpMethod.post,
                        url: "/",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let notAllowedResponse = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 405,
                        statusPhrase: "Method Not Allowed",
                        headers: ["Content-Length":"0",
                                  "Content-Type":"text/html"],
                        body: ""
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(notAllowedResponse))
            }

            it ("returns a 302 Found in case of a redirect") {
                let validRequest = HttpRequest(
                        method: HttpMethod.get,
                        url: "/redirect",
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let redirectResponse = HttpResponse(
                        version: "HTTP/1.1",
                        statusCode: 302,
                        statusPhrase: "Found",
                        headers: ["Location": "/"],
                        body: ""
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(redirectResponse))
            }
        }
    }
}
