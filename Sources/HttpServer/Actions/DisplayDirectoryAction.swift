import Foundation

public class DisplayDirectoryAction: HttpAction {
    private var directoryNavigator: DirectoryNavigator
    public var dataStorage: DataStorage

    public init(directoryNavigator: DirectoryNavigator, dataStorage: DataStorage) {
        self.directoryNavigator = directoryNavigator
        self.dataStorage = dataStorage
    }

    public func execute(request: HttpRequest) {
        do {
            let content = try directoryNavigator.contentsOfDirectory(atPath:directoryNavigator.currentPath() + "/cob_spec/public")
            let htmlContent = convertToHTML(content: content)
            dataStorage.addToDirectory(content: htmlContent)
        } catch let error {
            print(error.localizedDescription)
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
