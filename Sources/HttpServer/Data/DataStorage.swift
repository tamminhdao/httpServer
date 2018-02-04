import Foundation

public class DataStorage {

    public var myVals: [String: String]
    public var incomingRequests: [String]
    private var location: String


    public init() {
        self.myVals = [:]
        self.incomingRequests = []
        self.location = ""
    }

    public func addValues(key: String, value: String) {
        self.myVals[key] = value
    }

    public func logValues() -> [String:String] {
        return myVals
    }

    public func addToRequestList(request: String) {
        self.incomingRequests.append(request)
    }

    public func logRequests() -> [String] {
//        print(self.incomingRequests)
        return self.incomingRequests
    }

    public func setLocation(location: String) {
        self.location = location
    }

    public func getLocation() -> String {
        return self.location
    }
}