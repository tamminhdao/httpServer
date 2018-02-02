public class PostAction: HttpAction {

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
        let requestBody : [String: String] = request.returnBody()
        for item in requestBody {
            dataStorage.addValues(key: item.key, value: item.value)
        }
//        dataStorage.logValues()

        return responseGenerator.generate200Response(method: HttpMethod.post, url: request.returnUrl())
    }
}