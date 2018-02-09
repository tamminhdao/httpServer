public class NullAction: HttpAction {

    private var responseBuilder: ResponseBuilder

    public init(responseBuilder: ResponseBuilder) {
        self.responseBuilder = responseBuilder
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        return responseBuilder.generate200Response(method: request.returnMethod()!, url: request.returnUrl())
    }
}
