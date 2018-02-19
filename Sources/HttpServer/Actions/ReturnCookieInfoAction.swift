public class ReturnCookieInfoAction: HttpAction {

    private var dataStorage: DataStorage
    private var routesTable: RoutesTable

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        let cookieHeader: String = extractCookieInfoFromHeaders(headers: request.returnHeaders())
        dataStorage.addData(url: request.returnUrl(), value: "mmmm \(cookieHeader)")
        return ResponseBuilder(
                routesTable: self.routesTable,
                dataStorage: self.dataStorage)
                .generate200Response(request: request)
    }

    private func extractCookieInfoFromHeaders(headers: [String: String]) -> String {
        if let cookieHeader = headers["Cookie"] {
            return cookieHeader.components(separatedBy: "=").last!.trimmingCharacters(in: .punctuationCharacters)
        } else {
            return ""
        }
    }
}
