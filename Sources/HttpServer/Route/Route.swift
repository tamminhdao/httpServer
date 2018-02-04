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
}
