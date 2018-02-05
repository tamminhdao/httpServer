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

    public func readFileContents(filePath: String) throws -> Data? {
        let path = "\(currentPath())/cob_spec/public/\(filePath)"

        guard fileExists(atPath: path) else {
            throw DirectoryNavigatorError.PathDoesNotExist(atPath: path)
        }

        let file : FileHandle? = FileHandle(forReadingAtPath: path)
        let data = file?.readDataToEndOfFile()
        file?.closeFile()
        return data
    }

    private func fileExists(atPath: String) -> Bool {
        return self.fileManager.fileExists(atPath: atPath)
    }
}
