public class PutAction: HttpAction {

    private var responseBuilder: ResponseBuilder
    public var dataStorage: DataStorage

    public init(responseBuilder: ResponseBuilder, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.responseBuilder = responseBuilder
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        let requestBody : [String: String] = request.returnBody()
        for item in requestBody {
            dataStorage.addData(key: item.key, value: item.value)
        }
        return responseBuilder.generate200Response(method: HttpMethod.put, url: request.returnUrl())
    }
}
