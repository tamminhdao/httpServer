import Quick
import Nimble
import HttpServer

class RouteSpec : QuickSpec {
    override func spec() {
        describe("#Route") {
            var route: Route!
            var routesTable: RoutesTable!
            var dataStorage: DataStorage!
            var responseGenerator: ResponseGenerator!
            var authorizedRoute: Route!
            var action: HttpAction!

            beforeEach {
                routesTable = RoutesTable()
                dataStorage = DataStorage()
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
                action = NullAction(responseGenerator: responseGenerator)
                route = Route(url: "/", method: HttpMethod.get, action: action)
                authorizedRoute = Route(url: "/", method: HttpMethod.get, action: action, realm: "authorized", credentials: "YWRtaW46aHVudGVyMg==")
            }

            it ("returns true if a route needs authorized credentials") {
                let boolean = authorizedRoute.needsAuthorization()
                expect(boolean).to(be(true))
            }

            it ("returns false if a route does not need authorized credentials") {
                let boolean = route.needsAuthorization()
                expect(boolean).to(be(false))
            }

            it ("returns the correct string value for the realm of an authorized route") {
                let realm = authorizedRoute.getRealm()
                expect(realm).to(equal("authorized"))
            }

            it ("returns the correct credentials of an authorized route") {
                let credentials = authorizedRoute.getCredentials()
                expect(credentials).to(equal("YWRtaW46aHVudGVyMg=="))
            }
        }
    }
}
