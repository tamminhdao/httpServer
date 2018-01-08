import Foundation
import Route
import Actions
import Requests
import Quick
import Nimble

class RoutesTableSpec: QuickSpec {
    override func spec() {
        describe("#RoutesTable") {
            var routesTable: RoutesTable!
            var nullAction: NullAction!

            beforeEach {
                routesTable = RoutesTable()
                nullAction = NullAction()
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
            }

            it ("can add a new route to the collection") {
                let allRoutes = routesTable.showAllRoutes()
                expect(allRoutes[0].url).to(equal("/"))
                expect(allRoutes[0].method).to(equal(HttpMethod.get))
                expect(allRoutes[0].action).to(be(nullAction))
            }

            it ("can support the OPTIONS request by identifying all allowed methods on an url") {
                let expectedVerbs = ["GET"]
                let allowedMethods = routesTable.options(url: "/")
                expect(allowedMethods).to(equal(expectedVerbs))
            }
        }
    }
}