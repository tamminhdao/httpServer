import Foundation
import Router
import Actions
import Requests
import Quick
import Nimble

class RoutesTableSpec: QuickSpec {
    override func spec() {
        describe("#RoutesCollection") {
            var routesTable: RoutesTable!
            var nullAction: NullAction!

            beforeEach {
                routesTable = RoutesTable()
                nullAction = NullAction()
            }

            it ("can add routes to the collection") {
                let newRoute = Route(url: "/", method: HttpMethod.get, action: nullAction)
                routesTable.addRoute(route: newRoute)
                let allRoutes = routesTable.showAllRoutes()
                expect(allRoutes[0].url).to(equal("/"))
                expect(allRoutes[0].method).to(equal(HttpMethod.get))
                expect(allRoutes[0].action).to(be(nullAction))
            }

//            it ("identifies all allowed methods on an url") {
//                let expectedVerbs = ["GET", "OPTIONS"]
//                let allowedMethods = router.obtainMethods("method_options2")
//                expect(allowedMethods).to(equal(allowedMethods))
//            }
        }
    }
}