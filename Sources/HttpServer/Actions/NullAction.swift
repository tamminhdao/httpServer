public class NullAction: HttpAction {

    private var directoryNavigator: DirectoryNavigator
    private var responseGenerator: ResponseGenerator
    public var dataStorage: DataStorage
    private var routesTable: RoutesTable

    public init(directoryNavigator: DirectoryNavigator, dataStorage: DataStorage, routesTable: RoutesTable) {
        self.routesTable = routesTable
        self.directoryNavigator = directoryNavigator
        self.dataStorage = dataStorage
        self.responseGenerator = ResponseGenerator(routesTable: routesTable, dataStorage: dataStorage)
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        self.responseGenerator = ResponseGenerator()
    }
}
