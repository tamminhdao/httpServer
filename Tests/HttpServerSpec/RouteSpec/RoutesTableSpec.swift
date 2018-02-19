import Quick
import Nimble
import HttpServer

class RoutesTableSpec: QuickSpec {
    override func spec() {
        describe("#RoutesTable") {
            var routesTable: RoutesTable!
            var nullAction: NullAction!
            var dataStorage: DataStorage!

            beforeEach {
                routesTable = RoutesTable()
                dataStorage = DataStorage()
                nullAction = NullAction(routesTable: routesTable, dataStorage: dataStorage)
                routesTable.addRoute(route: Route(url: "/", method: HttpMethod.get, action: nullAction))
                routesTable.addRoute(route: Route(url: "/table", method: HttpMethod.get, action: nullAction))
            }

            it ("can add a new route to the collection") {
                let allRoutes = routesTable.showAllRoutes()
                expect(allRoutes[0].url).to(equal("/"))
                expect(allRoutes[0].method).to(equal(HttpMethod.get))
                expect(allRoutes[0].action).to(be(nullAction))
            }

            it ("can return all existing routes in the table") {
                let allRoutes = routesTable.showAllRoutes()
                let expectedTable : [Route] = [
                    Route(url: "/", method: HttpMethod.get, action: nullAction),
                    Route(url: "/table", method: HttpMethod.get, action: nullAction)
                ]
                expect(allRoutes[0]).to(equal(expectedTable[0]))
                expect(allRoutes[1]).to(equal(expectedTable[1]))
            }

            it ("can support the OPTIONS request by identifying all allowed methods on an url") {
                let expectedVerbs = ["GET"]
                let allowedMethods = routesTable.options(url: "/")
                expect(allowedMethods).to(equal(expectedVerbs))
            }

            it ("can check if a route already exist in the table") {
                let route = Route(url: "/", method: HttpMethod.get, action: nullAction)
                let exist = routesTable.verifyRoute(newRoute: route)
                expect(exist).to(be(true))
            }

            it ("can check if a route does not currently exist in the table") {
                let route = Route(url: "/new", method: HttpMethod.head, action: nullAction)
                let exist = routesTable.verifyRoute(newRoute: route)
                expect(exist).to(be(false))
            }
        }
    }
}
