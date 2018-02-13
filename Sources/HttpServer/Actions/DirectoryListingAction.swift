import Foundation

public class DirectoryListingAction: HttpAction {

    private var directoryNavigator: DirectoryNavigator
    private var responseBuilder: ResponseBuilder

    public init(directoryNavigator: DirectoryNavigator, responseBuilder: ResponseBuilder) {
        self.directoryNavigator = directoryNavigator
        self.responseBuilder = responseBuilder
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        do {
            let content = try directoryNavigator.contentsOfDirectory()
            let htmlContent = convertToHTML(content: content)
            return responseBuilder.generate200ResponseWithDirectoryListing(directory: htmlContent)
        } catch let error {
            print(error.localizedDescription)
            return responseBuilder.generate404Response()
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
