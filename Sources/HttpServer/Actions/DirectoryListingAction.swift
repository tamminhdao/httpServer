import Foundation

public class DirectoryListingAction: HttpAction {

    private var directoryNavigator: DirectoryNavigator
    private var routesTable: RoutesTable
    public var dataStorage: DataStorage

    public init(directoryNavigator: DirectoryNavigator, routesTable: RoutesTable, dataStorage: DataStorage) {
        self.directoryNavigator = directoryNavigator
        self.dataStorage = dataStorage
        self.routesTable = routesTable
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        do {
            let content = try directoryNavigator.contentsOfDirectory()
            let htmlContent = convertToHTML(content: content)
            addRoutesToRoutesTable(contentOfDirectory: content)
            return ResponseBuilder(
                    routesTable: self.routesTable,
                    dataStorage: self.dataStorage)
                    .generate200ResponseWithDirectoryListing(directory: htmlContent)
        } catch let error {
            print(error.localizedDescription)
            return ResponseBuilder(
                    routesTable: self.routesTable,
                    dataStorage: self.dataStorage)
                    .generate404Response()
        }
    }

    private func addRoutesToRoutesTable(contentOfDirectory: [String]) {
        for item in contentOfDirectory {
            let action = FetchFileAction(directoryNavigator: self.directoryNavigator, routesTable: self.routesTable, dataStorage: self.dataStorage)
            let newRoute = Route(url: "/\(item)", method: HttpMethod.get, action: action)
            if routesTable.verifyRoute(newRoute: newRoute) == false {
                routesTable.addRoute(route: newRoute)
            }
        }
    }

    private func convertToHTML(content: [String]) -> String {
        var htmlBody = "<!DOCTYPE html><html><head><title>Directory Listing</title></head><body><ul>"
        for item in content {
            htmlBody += "<li><a href=" + "/\(item)> \(item) </a></li>"
        }
        htmlBody += "</ul></body></html>"
        return htmlBody
    }
}
