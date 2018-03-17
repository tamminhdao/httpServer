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
        let root = directoryNavigator.directoryPath
        do {
            let fileType = try directoryNavigator.fileType(atPath: "\(root)\(request.returnUrl())")

            if fileType == "NSFileTypeDirectory" {
                let listings = try directoryNavigator.contentsOfDirectory(atPath: request.returnUrl())
                let path = request.returnUrl() == "/" ? "" : request.returnUrl()
                let listingsWithFullPath = listings.map{"\(path)/\($0)"}
                let htmlContent = convertToHTML(content: listingsWithFullPath)
                addRoutesToRoutesTable(contentOfDirectory: listingsWithFullPath)
                return ResponseBuilder().generate200ResponseWithDirectoryListing(directory: htmlContent)
            } else {
                let fileContent = try directoryNavigator.readFileContents(filePath: request.returnUrl())
                let contentType = determineFileType(filePath: request.returnUrl())
                    return ResponseBuilder()
                            .generate200ResponseWithFileContent(
                                    content: fileContent,
                                    contentType: contentType)

            }
        } catch {
            print(error.localizedDescription)
            return ResponseBuilder().generate404Response()
        }
    }

    private func determineFileType(filePath: String) -> (fileType: String, fileExt: String) {
        guard let fileExt = filePath.components(separatedBy: ".").last else {
            return (fileType: "text", fileExt: "html")
        }

        switch fileExt {
        case "txt":
            return (fileType: "text", fileExt: "plain")
        case "html":
            return (fileType: "text", fileExt: "html")
        case "jpeg":
            return (fileType: "image", fileExt: "jpeg")
        case "jpg":
            return (fileType: "image", fileExt: "jpg")
        case "png":
            return (fileType: "image", fileExt: "png")
        case "gif":
            return (fileType: "image", fileExt: "gif")
        default:
            return (fileType: "text", fileExt: "html")
        }
    }

    private func addRoutesToRoutesTable(contentOfDirectory: [String]) {
        for item in contentOfDirectory {
            let action = DirectoryListingAction(directoryNavigator: self.directoryNavigator, routesTable: self.routesTable, dataStorage: self.dataStorage)
            let newRoute = Route(url: "\(item)", method: HttpMethod.get, action: action)
            if routesTable.verifyRoute(newRoute: newRoute) == false {
                routesTable.addRoute(route: newRoute)
            }
        }
    }

    private func convertToHTML(content: [String]) -> String {
        var htmlBody = "<!DOCTYPE html><html><head><title>Directory Listing</title></head><body><ul>"
        for item in content {
            htmlBody += "<li><a href=" + "\(item)> \(item) </a></li>"
        }
        htmlBody += "</ul></body></html>"
        return htmlBody
    }
}
