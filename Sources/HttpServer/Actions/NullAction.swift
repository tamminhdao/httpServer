public class NullAction: HttpAction {

    private var dataStorage: DataStorage
    private var routesTable: RoutesTable

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        return ResponseBuilder(
                routesTable: self.routesTable,
                dataStorage: self.dataStorage)
                .generate200Response(
                        method: request.returnMethod()!,
                        url: request.returnUrl())
    }
}
