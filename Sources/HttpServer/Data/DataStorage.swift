import Foundation

public class DataStorage {

    private var data: [String: String]
    private var incomingRequests: [String]
    private var location: String

    public init() {
        self.data = [:]
        self.incomingRequests = []
        self.location = ""
    }

    public func addData(key: String, value: String) {
        self.data[key] = value
    }

    public func removeData(value: String) {
        self.data.removeValue(forKey: value)
    }

    public func logData() -> [String:String] {
        return data
    }

    public func addToRequestList(request: String) {
        self.incomingRequests.append(request)
    }

    public func logRequests() -> [String] {
        return self.incomingRequests
    }

    public func setLocation(location: String) {
        self.location = location
    }

    public func getLocation() -> String {
        return self.location
    }
}
