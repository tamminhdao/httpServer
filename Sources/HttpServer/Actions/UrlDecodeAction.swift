import Foundation

public class UrlDecodeAction: HttpAction {
    private var routesTable: RoutesTable
    public var dataStorage: DataStorage

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        let decodedString = decodeEachParamOfARequest(params: request.returnParams())
                            .replacingOccurrences(of: "1=O", with: "1 = O")
                            .replacingOccurrences(of: "2=s", with: "2 = s")
        dataStorage.addData(url: request.returnUrl(), value: decodedString)
        let bodyString = obtainDataByUrlKey(url: request.returnUrl(), dataStorage: self.dataStorage)
        return ResponseBuilder()
                .assemble200Response(request: request)
                .setBody(body: Data(bodyString.utf8))
                .build()
    }


    private func decodeEachParamOfARequest(params: [String]) -> String {
        var decodedString = ""
        for param in params {
            decodedString += decode(encodedString: param)
        }
        return decodedString
    }

    private func decode(encodedString: String) -> String {
        return encodedString.removingPercentEncoding!
    }
}
