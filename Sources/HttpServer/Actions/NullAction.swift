import Foundation

public class NullAction: HttpAction {

    private var dataStorage: DataStorage
    private var routesTable: RoutesTable

    public init(routesTable: RoutesTable, dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        storeCookieData(request: request, dataStorage: self.dataStorage)
        let bodyString = obtainDataByUrlKey(url: request.returnUrl(), dataStorage: self.dataStorage)
        return ResponseBuilder(dataStorage: self.dataStorage)
                .assemble200Response(request: request)
                .setAllow(url: options(url: request.returnUrl()))
                .setCookie(cookieData: obtainCookieDataByUrl(url: request.returnUrl()))
                .setBody(body: Data(bodyString.utf8))
                .build()
    }

   private func options(url: String) -> String {
       let listOfMethods = routesTable.options(url: url)
       return listOfMethods.joined(separator: ",")
   }

    private func obtainCookieDataByUrl(url: String) -> String {
        let dataInArray = dataStorage.retrieveCookieByUrl(url: url)
        print(dataInArray)
        return dataInArray.joined(separator: ";")
    }
}
