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
        print("List all data persisted in the server:")
        for item in self.myVals {
            print("\(item.key)=\(item.value)")
        }
        return myVals
    }
}
