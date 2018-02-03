public class PostAction: HttpAction {

    private var responseGenerator: ResponseGenerator
    public var dataStorage: DataStorage

    public init(responseGenerator: ResponseGenerator, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.responseGenerator = responseGenerator
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        let requestBody : [String: String] = request.returnBody()
        for item in requestBody {
            dataStorage.addValues(key: item.key, value: item.value)
        }
        return responseGenerator.generate200Response(method: HttpMethod.post, url: request.returnUrl())
    }
}