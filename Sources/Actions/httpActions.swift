import Foundation
import Requests
import Values

public class HttpActions {
    private var dataStorage: DataStorage

    public init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }

    public func nullAction(request: HttpRequest) {}

    public func putAction(request: HttpRequest) {
        let requestBody : [String: String] = request.returnBody()
        for item in requestBody {
            dataStorage.addValues(key: item.key, value: item.value)
        }
        dataStorage.logValues()
    }
}
