public class LogRequestsAction: HttpAction {

    private var responseGenerator: ResponseGenerator

    public init(responseGenerator: ResponseGenerator) {
        self.responseGenerator = responseGenerator
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        return responseGenerator.generateLogContent()
    }
}
