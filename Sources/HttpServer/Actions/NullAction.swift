public class NullAction: HttpAction {
    private var responseGenerator: ResponseGenerator
    public init() {}

    public func execute(request: HttpRequest) -> HttpResponse {
        self.responseGenerator = ResponseGenerator()
    }
}
