public class DeleteAction: HttpAction {

    private var responseGenerator: ResponseGenerator
    public var dataStorage: DataStorage

    public init(responseGenerator: ResponseGenerator, dataStorage: DataStorage) {
        self.responseGenerator = responseGenerator
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        for item in dataStorage.myVals {
            dataStorage.myVals.removeValue(forKey: item.key)
        }
         return responseGenerator.generate200Response(
                 method: HttpMethod.delete, url: request.returnUrl())
    }
}
