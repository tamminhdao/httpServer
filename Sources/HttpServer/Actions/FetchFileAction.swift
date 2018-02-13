import Foundation

public class FetchFileAction : HttpAction {

    private var directoryNavigator: DirectoryNavigator
    private var responseBuilder: ResponseBuilder

    public init(directoryNavigator: DirectoryNavigator, responseBuilder: ResponseBuilder) {
        self.directoryNavigator = directoryNavigator
        self.responseBuilder = responseBuilder
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        do {
            let data = try directoryNavigator.readFileContents(filePath: request.returnUrl())
            let contentType = determineFileType(filePath: request.returnUrl())
            return responseBuilder.generate200ResponseWithFileContent(content: data, contentType: contentType)
        } catch let error {
            print(error.localizedDescription)
            return responseBuilder.generate404Response()
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
