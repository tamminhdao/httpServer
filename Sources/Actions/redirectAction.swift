import Foundation
import Requests
import Values

public class RedirectAction: HttpAction {
    private var redirectPath: String
    public var dataStorage: DataStorage

    public init(redirectPath: String, dataStorage: DataStorage) {
        self.redirectPath = redirectPath
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) {
        print("A")
        dataStorage.addValues(key: "location", value: redirectPath)
        print("B")
    }
}
