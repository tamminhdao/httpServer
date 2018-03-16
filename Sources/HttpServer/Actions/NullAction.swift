public class NullAction: HttpAction {

    private var dataStorage: DataStorage
    private var routesTable: RoutesTable

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        storeCookieData(request: request, dataStorage: self.dataStorage)
        return ResponseBuilder(dataStorage: self.dataStorage)
                .assembleResponse(request: request)
                .setAllow(url: options(url: request.returnUrl()))
                .build()
    }


   private func options(url: String) -> String {
       let listOfMethods = routesTable.options(url: url)
       return listOfMethods.joined(separator: ",")
   }
}
