public class Route {
    public var url: String
    public var method: HttpMethod
    public var action: HttpAction
    public var realm: String
    public let credentials: String

    public init(url: String, method: HttpMethod, action: HttpAction, realm: String = "", credentials: String = "") {
        self.url = url
        self.method = method
        self.action = action
        self.realm = realm
        self.credentials = credentials
    }

    public func needsAuthorization() -> Bool {
        return self.realm != "" && self.credentials != ""
    }

    public func getRealm() -> String {
        return self.realm
    }

    public func getCredentials() -> String {
        return self.credentials
    }

    public func authorizeSucceeded(requestHeaders: [String: String]) -> Bool {
        if !needsAuthorization() {
            return true
        } else {
            var status = false
            let credential = getCredentials()
            for line in requestHeaders {
                if line.key == "Authorization" {
                    status = (line.value == "Basic " + credential)
                }
            }
            return status
        }
    }
}

extension Route: Equatable {
    public static func == (lhs: Route, rhs: Route) -> Bool {
        return
            lhs.url == rhs.url &&
            lhs.method == rhs.method &&
            type(of: rhs.action) == type(of: lhs.action) &&
            lhs.realm == rhs.realm &&
            lhs.credentials == rhs.credentials

    }
}