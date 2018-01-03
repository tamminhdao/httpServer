import Foundation
import Requests
import Values

public class NullAction: HttpAction {
    public var dataStorage: DataStorage

    public init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) {}
}
