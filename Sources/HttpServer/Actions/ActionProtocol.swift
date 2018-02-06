public protocol HttpAction {
    func execute(request: HttpRequest) -> HttpResponse
}
