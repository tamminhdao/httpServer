import Foundation

public enum DirectoryNavigatorError: Error {
    case PathDoesNotExist(atPath: String)
}
public class DirectoryNavigator {
    let fileManager: FileManager
    let directoryPath: String

    public init(directoryPath: String) {
        self.fileManager = FileManager.default
        self.directoryPath = directoryPath
    }

    public func contentsOfDirectory(atPath: String) throws -> [String] {
        var content : [String] = []
        do {
            try content = fileManager.contentsOfDirectory(atPath: "\(directoryPath)\(atPath)").sorted()
        } catch {
            throw DirectoryNavigatorError.PathDoesNotExist(atPath: atPath)
        }
        return content
    }

    public func readFileContents(filePath: String) throws -> Data? {
        let path = "\(directoryPath)/\(filePath)"

        guard fileExists(atPath: path) else {
            return nil
            throw DirectoryNavigatorError.PathDoesNotExist(atPath: path)
        }

        let file : FileHandle? = FileHandle(forReadingAtPath: path)
        let data = file?.readDataToEndOfFile()
        file?.closeFile()
        return data
    }

    private func fileExists(atPath: String) -> Bool {
        var isDir : ObjCBool = false

        if self.fileManager.fileExists(atPath: atPath, isDirectory: &isDir) {
            if isDir.boolValue {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
