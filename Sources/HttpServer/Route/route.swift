//import Foundation
//import Requests
//import Actions

public class Route {
    public var url: String
    public var method: HttpMethod
    public var action: HttpAction

    public init(url: String, method: HttpMethod, action: HttpAction) {
        self.url = url
        self.method = method
        self.action = action
    }
}
