public class PutAction: HttpAction {


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
//        dataStorage.logValues()

        return responseGenerator.generate200Response(method: HttpMethod.put, url: request.returnUrl())
    }
}
