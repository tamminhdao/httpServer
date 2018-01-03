import Foundation

public class DataStorage {

    public var myVals: [String: String]

    public init() {
        self.myVals = [:]
    }

    public func addValues(key: String, value: String) {
        self.myVals[key] = value
    }

    public func logValues() -> [String:String] {
        for item in self.myVals {
            print("List all data persisted in the server: \(item.key)=\(item.value)")
        }
        return myVals
    }
}
