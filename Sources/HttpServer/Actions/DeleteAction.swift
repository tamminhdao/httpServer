public class DeleteAction: HttpAction {

    private var dataStorage: DataStorage
    private var routesTable: RoutesTable

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        for item in dataStorage.logData() {
            dataStorage.removeData(url: item.key)
        }
         return ResponseBuilder()
                 .assemble200Response(request: request)
                 .build()
    }
}
