import Foundation

public class DisplayDirectoryAction: HttpAction {
    private var directoryNavigator: DirectoryNavigator
    public var dataStorage: DataStorage

    public init(directoryNavigator: DirectoryNavigator, dataStorage: DataStorage) {
        self.directoryNavigator = directoryNavigator
        self.dataStorage = dataStorage
    }

    // add directory content to dataStorage.directory
    public func execute(request: HttpRequest) {
        do {
            let content = try directoryNavigator.contentsOfDirectory(atPath: "/Users/tamdao/Swift/httpServer/cob_spec/public")
            let contentString = content.joined(separator: "\n")
            dataStorage.addToDirectory(content: contentString)
        } catch let error {
            print(error.localizedDescription)
        }
    }

}