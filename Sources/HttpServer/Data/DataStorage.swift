import Foundation

public class DataStorage {

    public var myVals: [String: String]
    public var directory: String

    public init() {
        self.myVals = [:]
        self.directory = ""
    }

    public func addValues(key: String, value: String) {
        self.myVals[key] = value
    }

    public func logValues() -> [String:String] {
        return myVals
    }

    public func addToDirectory(content: String) {
        directory = ""
        directory += content
    }

    public func returnDirectory() -> String {
        return directory
    }
}
