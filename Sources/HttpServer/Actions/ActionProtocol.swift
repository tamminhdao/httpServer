public protocol HttpAction {
    func execute(request: HttpRequest) -> HttpResponse
}

extension HttpAction {
    func storeCookieData (request: HttpRequest, dataStorage: DataStorage) {
        dataStorage.saveCookie(url: request.returnUrl(), value: request.returnParams())
    }

    func obtainDataByUrlKey(url: String, dataStorage: DataStorage) -> String {
        var result = ""
        result += dataStorage.logDataByUrl(url: url)
        return result
    }
}
