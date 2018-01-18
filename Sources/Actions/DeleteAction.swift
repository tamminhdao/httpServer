import Foundation
import Requests
import Data

public class DeleteAction: HttpAction {
    public var dataStorage: DataStorage

    public init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) {
        for item in dataStorage.myVals {
            dataStorage.myVals.removeValue(forKey: item.key)
        }
    }
}
