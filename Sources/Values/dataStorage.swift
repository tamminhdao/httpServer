import Foundation

public class DataStorage {

    private var myVals: [String: String]

    public init() {
        self.myVals = [:]
    }

    public func addValues(key: String, value: String) {
        self.myVals[key] = value
    }

    public func logValues() {
        for item in self.myVals {
            print("\(item.key)=\(item.value)")
        }
    }
}
