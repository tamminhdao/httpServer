public class NullAction: HttpAction {

    private var responseGenerator: ResponseGenerator

    public init(responseGenerator: ResponseGenerator) {
        self.responseGenerator = responseGenerator
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        return responseGenerator.generate200Response(method: request.returnMethod()!, url: request.returnUrl())
    }
}
