import Foundation
import Requests
import Data

public class RedirectAction: HttpAction {
    private var redirectPath: String
    public var dataStorage: DataStorage

    public init(redirectPath: String, dataStorage: DataStorage) {
        self.redirectPath = redirectPath
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) {
        dataStorage.addValues(key: "location", value: redirectPath)
    }
}
