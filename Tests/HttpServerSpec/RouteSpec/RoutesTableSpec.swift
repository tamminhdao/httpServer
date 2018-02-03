import Quick
import Nimble
import HttpServer

class RoutesTableSpec: QuickSpec {
    override func spec() {
        describe("#RoutesTable") {
            var routesTable: RoutesTable!
            var nullAction: NullAction!
            var dataStorage: DataStorage!
            var responseGenerator: ResponseGenerator!

            beforeEach {
                routesTable = RoutesTable()
                dataStorage = DataStorage()
                responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
                nullAction = NullAction(responseGenerator: responseGenerator)
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