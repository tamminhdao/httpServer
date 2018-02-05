import Foundation

public class DirectoryListingAction: HttpAction {

    private var directoryNavigator: DirectoryNavigator
    private var responseGenerator: ResponseGenerator

    public init(directoryNavigator: DirectoryNavigator, responseGenerator: ResponseGenerator) {
        self.directoryNavigator = directoryNavigator
        self.responseGenerator = responseGenerator
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        do {
            let content = try directoryNavigator.contentsOfDirectory(atPath:directoryNavigator.currentPath() + "/cob_spec/public")
            let htmlContent = convertToHTML(content: content)
            return responseGenerator.generateDirectory(body: htmlContent)

        } catch let error {
            print(error.localizedDescription)
            return responseGenerator.generate404Response()
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
