public class LogRequestsAction: HttpAction {
    private var dataStorage: DataStorage
    private var routesTable: RoutesTable

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        dataStorage.addData(url: request.returnUrl(), value: obtainRequestLog())
        return ResponseBuilder(dataStorage: self.dataStorage)
                .generate200Response(request: request)
    }

    private func obtainRequestLog() -> String {
        var log = ""
        for item in dataStorage.logRequests() {
            log += "\(item)\n"
        }
        return log
    }
}
