public class DeleteAction: HttpAction {
    public var dataStorage: DataStorage
    private var responseGenerator: ResponseGenerator

    public init(dataStorage: DataStorage, responseGenerator: ResponseGenerator) {
        self.dataStorage = dataStorage
        self.responseGenerator = responseGenerator
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        for item in dataStorage.myVals {
            dataStorage.myVals.removeValue(forKey: item.key)
        }
         return responseGenerator.generate200Response(
                 method: request.returnMethod(), url: request.returnUrl())
    }
}
