import Foundation
public class PutAction: HttpAction {

    private var dataStorage: DataStorage

    public init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        let requestBody : [String: String] = request.returnBody()
        var UrlData = ""
        for item in requestBody {
            UrlData += "\(item.key)=\(item.value) "
        }
        dataStorage.addData(url: request.returnUrl(), value: UrlData)
        let bodyString = obtainDataByUrlKey(url: request.returnUrl(), dataStorage: self.dataStorage)
        return ResponseBuilder()
                .assemble200Response(request: request)
                .setBody(body: Data(bodyString.utf8))
                .build()
    }
}
