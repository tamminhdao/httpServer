import Foundation

public class LogRequestsAction: HttpAction {
    private var dataStorage: DataStorage

    public init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        dataStorage.addData(url: request.returnUrl(), value: obtainRequestLog())
        let bodyString = obtainDataByUrlKey(url: request.returnUrl(), dataStorage: self.dataStorage)
        return ResponseBuilder()
                .assemble200Response(request: request)
                .setBody(body: Data(bodyString.utf8))
                .build()
    }

    private func obtainRequestLog() -> String {
        var log = ""
        for item in dataStorage.logRequests() {
            log += "\(item)\n"
        }
        return log
    }
}
