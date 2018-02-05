import Foundation

public enum DirectoryNavigatorError: Error {
    case PathDoesNotExist(atPath: String)
}
public class DirectoryNavigator {
    let fileManager: FileManager

    public init() {
        self.fileManager = FileManager.default
    }

    public func currentPath() -> String {
        return fileManager.currentDirectoryPath
    }

    public func contentsOfDirectory(atPath: String) throws -> [String] {
        var content : [String] = []
        do {
            try content = fileManager.contentsOfDirectory(atPath: atPath)
        } catch {
            throw DirectoryNavigatorError.PathDoesNotExist(atPath: atPath)
        }
        return content
    }
}
