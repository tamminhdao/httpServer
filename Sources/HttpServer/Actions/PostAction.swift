public class PostAction: HttpAction {

    private var responseBuilder: ResponseBuilder
    public var dataStorage: DataStorage

    public init(responseBuilder: ResponseBuilder, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.responseBuilder = responseBuilder
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        let requestBody : [String: String] = request.returnBody()
        var UrlData = ""
        for item in requestBody {
            UrlData += "\(item.key)=\(item.value) "
        }
        dataStorage.addData(url: request.returnUrl(), value: UrlData)
        return responseBuilder.generate200Response(method: HttpMethod.post, url: request.returnUrl())
    }
}
