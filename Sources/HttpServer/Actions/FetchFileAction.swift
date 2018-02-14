import Foundation

public class FetchFileAction : HttpAction {

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
            let data = try directoryNavigator.readFileContents(filePath: request.returnUrl())
            let contentType = determineFileType(filePath: request.returnUrl())
            return ResponseBuilder(
                    routesTable: self.routesTable,
                    dataStorage: self.dataStorage)
                    .generate200ResponseWithFileContent(
                            content: data,
                            contentType: contentType)
        } catch let error {
            print(error.localizedDescription)
            return ResponseBuilder(
                    routesTable: self.routesTable,
                    dataStorage: self.dataStorage)
                    .generate404Response()
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
            case "png":
                return (fileType: "image", fileExt: "png")
            case "gif":
                return (fileType: "image", fileExt: "gif")
            default:
                return (fileType: "text", fileExt: "html")
        }
    }
}
