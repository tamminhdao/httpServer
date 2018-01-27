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

    public func options (url: String) -> [String] {
        var methods : [String] = []
        for route in routes {
            if route.url == url {
                methods.append(route.method.rawValue)
            }
        }
        return methods
    }
}
