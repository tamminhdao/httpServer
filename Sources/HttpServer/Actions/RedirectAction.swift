public class RedirectAction: HttpAction {

    private var redirectPath: String
    private var responseBuilder: ResponseBuilder
    public var dataStorage: DataStorage

    public init(redirectPath: String, responseBuilder: ResponseBuilder, dataStorage: DataStorage) {
        self.redirectPath = redirectPath
        self.dataStorage = dataStorage
        self.responseBuilder = responseBuilder
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        dataStorage.setLocation(location: redirectPath)

        return responseBuilder.generate302Response()
    }
}
