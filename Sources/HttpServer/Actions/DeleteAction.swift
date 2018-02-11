public class DeleteAction: HttpAction {

    private var responseBuilder: ResponseBuilder
    public var dataStorage: DataStorage

    public init(responseBuilder: ResponseBuilder, dataStorage: DataStorage) {
        self.responseBuilder = responseBuilder
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        for item in dataStorage.logData() {
            dataStorage.removeData(url: item.key)
        }
         return responseBuilder.generate200Response(
                 method: HttpMethod.delete, url: request.returnUrl())
    }
}
