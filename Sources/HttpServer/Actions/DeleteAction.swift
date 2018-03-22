public class DeleteAction: HttpAction {
    private var dataStorage: DataStorage

    public init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        for item in dataStorage.logData() {
            dataStorage.removeData(url: item.key)
        }
         return ResponseBuilder()
                 .assemble200Response(request: request)
                 .build()
    }
}
