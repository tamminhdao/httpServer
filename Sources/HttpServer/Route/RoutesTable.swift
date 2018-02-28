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

    public func showAllRoutesUrl() -> [String] {
        var routesUrl = [String]()
        for route in showAllRoutes() {
            routesUrl.append(route.url)
        }
        return routesUrl
    }

    public func verifyRoute(newRoute: Route) -> Bool {
        var exist = false
        for route in showAllRoutes() {
            if route == newRoute {
                exist = true
                break
            }
        }
        return exist
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
