import Foundation

public class RoutesTable {
    private var routes: [Route]

    public init() {
        self.routes = [Route]()
    }

    public func addRoute(route: Route) {
        self.routes.append(route)
    }

    public func showAllRoutes() -> [Route] {
        return self.routes
    }



//    public func getOptions (url: String) -> [String] {
//
//    }
}
