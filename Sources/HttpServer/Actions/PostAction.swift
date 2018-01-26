public class PostAction: HttpAction {
    public var dataStorage: DataStorage

    public init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) {
        let requestBody : [String: String] = request.returnBody()
        for item in requestBody {
            dataStorage.addValues(key: item.key, value: item.value)
        }
        dataStorage.logValues()
    }
}