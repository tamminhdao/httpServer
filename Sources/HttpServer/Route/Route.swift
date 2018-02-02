public class Route {
    public var url: String
    public var method: HttpMethod
    public var action: HttpAction

//    let routeMap: [String: ()] = [:]

    public init(url: String, method: HttpMethod, action: HttpAction) {
        self.url = url
        self.method = method
        self.action = action
    }
//
//    func post(){
//
//    }
//
//    func put() {
//        returns response
//    }
//
//
//    func options() {
//
//    }
}
