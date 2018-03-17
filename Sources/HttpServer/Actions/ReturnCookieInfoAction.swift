import Foundation

public class ReturnCookieInfoAction: HttpAction {

    private var dataStorage: DataStorage
    private var routesTable: RoutesTable

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        let cookieValues = extractCookieInfoFromHeaders(headers: request.returnHeaders())
        var body = ""
        for value in cookieValues {
            body += "mmmm \(value)\n"
        }
        dataStorage.addData(url: request.returnUrl(), value: body)
        let bodyString = obtainDataByUrlKey(url: request.returnUrl(), dataStorage: self.dataStorage)
        return ResponseBuilder(dataStorage: self.dataStorage)
                .assemble200Response(request: request)
                .setBody(body: Data(bodyString.utf8))
                .build()
    }

    private func extractCookieInfoFromHeaders(headers: [String: String]) -> [String] {
        if let cookieHeader = headers["Cookie"] {
            let allCookies = cookieHeader.components(separatedBy: ";")
            return extractValueFromKeyValuePair(array: allCookies)
        } else {
            return []
        }
    }

    private func extractValueFromKeyValuePair(array: [String]) -> [String]{
        var newCookies = [String]()
        for cookie in array {
            newCookies.append(cookie.components(separatedBy: "=").last!)
        }
        return newCookies
    }
}
