public class RedirectAction: HttpAction {

    private var redirectPath: String
    private var responseGenerator: ResponseGenerator
    public var dataStorage: DataStorage

    public init(redirectPath: String, responseGenerator: ResponseGenerator, dataStorage: DataStorage) {
        self.redirectPath = redirectPath
        self.dataStorage = dataStorage
        self.responseGenerator = responseGenerator
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        dataStorage.addValues(key: "location", value: redirectPath)

        return responseGenerator.generate200Response(method: request.returnMethod()!, url: request.returnUrl())
    }
}
