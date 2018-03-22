public class RedirectAction: HttpAction {

    private var redirectPath: String
    public var dataStorage: DataStorage

    public init(redirectPath: String, dataStorage: DataStorage) {
        self.redirectPath = redirectPath
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        dataStorage.setLocation(location: redirectPath)

        return ResponseBuilder()
                .assemble302Response()
                .setLocation(location: self.dataStorage.getLocation())
                .build()
    }
}
