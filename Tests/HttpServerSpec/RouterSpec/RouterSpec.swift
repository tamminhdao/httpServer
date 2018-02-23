import Quick
import Nimble
import HttpServer
import Foundation

class RouterSpec: QuickSpec {
    override func spec() {
        describe("#Router") {
            var router: Router!
            var routesTable: RoutesTable!
            var responseBuilder: ResponseBuilder!
            var dataStorage: DataStorage!
            var nullAction: NullAction!
            var directoryNavigator: DirectoryNavigator!
            var directoryListingAction: DirectoryListingAction!
            var redirectAction: RedirectAction!

            beforeEach {
                routesTable = RoutesTable()
                dataStorage = DataStorage()
                directoryNavigator = DirectoryNavigator(directoryPath: "./cob_spec/public")
                dataStorage.addData(url: "/", value: "data=fatcat ")
                responseBuilder = ResponseBuilder(routesTable: routesTable, dataStorage: dataStorage)
                router = Router(routesTable: routesTable, responseBuilder: responseBuilder)
                nullAction = NullAction(routesTable: routesTable, dataStorage: dataStorage)
                redirectAction =  RedirectAction(redirectPath: "/", routesTable: routesTable, dataStorage: dataStorage)
                directoryListingAction = DirectoryListingAction(directoryNavigator: directoryNavigator, routesTable: routesTable, dataStorage: dataStorage)
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
                routesTable.addRoute(route: Route(url: "/directory", method: HttpMethod.get, action: directoryListingAction))
                routesTable.addRoute(route: Route(url: "/method_options2", method: HttpMethod.get, action: nullAction))
                routesTable.addRoute(route: Route(url: "/redirect", method: HttpMethod.get, action: redirectAction))
                routesTable.addRoute(route: Route(url: "/logs", method: HttpMethod.get, action: nullAction, realm: "basic-auth", credentials: "YWRtaW46aHVudGVyMg=="))
            }

            it("returns a 200 OK response with data in the body") {
                let validRequest = HttpRequest(
                        method: HttpMethod.get,
                        url: "/",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let responseOK = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(("data=fatcat ").count),
                                  "Content-Type": "text/html",
                                  "Allow": "GET"],
                        body: Data("data=fatcat ".utf8)
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(responseOK))
            }

            it ("returns a 200 OK if the credential for an authorized route is correct") {
                let validRequest = HttpRequest(
                        method: HttpMethod.get,
                        url: "/logs",
                        params: [],
                        version: "HTTP/1.1",
                        headers: ["Authorization": "Basic YWRtaW46aHVudGVyMg=="],
                        body: [:]
                )

                let authorizedResponse = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "Allow": "GET"],
                        body: Data()
                )
                let response = router.route(request: validRequest)
                expect(response).to(equal(authorizedResponse))
            }

            it ("returns a 404 Not Found if the url does not exist") {
                let validRequest = HttpRequest(
                        method: HttpMethod.head,
                        url: "/foobar",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let notFoundResponse = HttpResponse(
                        statusCode: 404,
                        statusPhrase: "Not Found",
                        headers: ["Content-Length": "0",
                                  "Content-Type": "text/html"],
                        body: Data()
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(notFoundResponse))
            }

            it ("returns a 405 Method Not Allowed if the url exists but it doesn't accept the verb") {
                let validRequest = HttpRequest(
                        method: HttpMethod.post,
                        url: "/",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let notAllowedResponse = HttpResponse(
                        statusCode: 405,
                        statusPhrase: "Method Not Allowed",
                        headers: ["Content-Length": "0",
                                  "Content-Type": "text/html"],
                        body: Data()
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(notAllowedResponse))
            }

            it ("returns a 302 Found in case of a redirect") {
                        let validRequest = HttpRequest(
                        method: HttpMethod.get,
                        url: "/redirect",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let redirectResponse = HttpResponse(
                        statusCode: 302,
                        statusPhrase: "Found",
                        headers: ["Content-Length": "0",
                                "Content-Type":"text/html",
                                "Location": "/"],
                        body: Data()
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(redirectResponse))
            }


            it("returns a 401 Unauthorized if the credential is incorrect") {
                let validRequest = HttpRequest(
                        method: HttpMethod.get,
                        url: "/logs",
                        params: [],
                        version: "HTTP/1.1",
                        headers: ["Authorization": "incorrect"],
                        body: [:]
                )

                let unauthorizedResponse = HttpResponse(
                        statusCode: 401,
                        statusPhrase: "Unauthorized",
                        headers: ["Content-Length": "0",
                                  "Content-Type":"text/html",
                                  "WWW-Authenticate": "Basic realm=basic-auth"],
                        body: Data()
                )

                let response = router.route(request: validRequest)
                expect(response).to(equal(unauthorizedResponse))
            }

            it ("lists the Cobspec public directory with links to each file") {

                let validRequest = HttpRequest(
                        method: HttpMethod.get,
                        url: "/directory",
                        params: [],
                        version: "HTTP/1.1",
                        headers: [:],
                        body: [:]
                )

                let folderContent = "<!DOCTYPE html><html><head><title>Directory Listing</title></head>" +
                    "<body><ul><li><a href=/file1> file1 </a></li><li><a href=/file2> file2 </a></li>" +
                    "<li><a href=/image.gif> image.gif </a></li><li><a href=/image.jpeg> image.jpeg </a></li>" +
                    "<li><a href=/image.png> image.png </a></li><li><a href=/partial_content.txt> partial_content.txt </a></li>" +
                    "<li><a href=/patch-content.txt> patch-content.txt </a></li><li><a href=/text-file.txt> text-file.txt </a></li></ul></body></html>"

                let responseOK = HttpResponse(
                        statusCode: 200,
                        statusPhrase: "OK",
                        headers: ["Content-Length": String(folderContent.count),
                                  "Content-Type":"text/html"],
                        body: Data(folderContent.utf8)
                )

                let response = router.route(request: validRequest)

                expect(response).to(equal(responseOK))
            }
        }
    }
}
