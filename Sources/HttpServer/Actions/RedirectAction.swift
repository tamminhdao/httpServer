public class RedirectAction: HttpAction {

    private var redirectPath: String
    private var routesTable: RoutesTable
    public var dataStorage: DataStorage

    public init(redirectPath: String, routesTable: RoutesTable, dataStorage: DataStorage) {
        self.redirectPath = redirectPath
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        dataStorage.setLocation(location: redirectPath)

        return ResponseBuilder()
                .assemble302Response()
                .setLocation(location: self.dataStorage.getLocation())
                .build()
    }
}
