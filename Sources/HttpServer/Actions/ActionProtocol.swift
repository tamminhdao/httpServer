public protocol HttpAction {
    func execute(request: HttpRequest) -> HttpResponse
}

extension HttpAction {
    func storeCookieData (request: HttpRequest, dataStorage: DataStorage) {
        dataStorage.saveCookie(url: request.returnUrl(), value: request.returnParams())
    }
}
