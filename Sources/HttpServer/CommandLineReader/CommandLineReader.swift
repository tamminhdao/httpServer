public enum CommandLineError: Error {
    case InvalidArgument
    case MissingRequiredArgument
}

public class CommandLineReader {
    private var args: [String]

    public init(args: [String]) {
        self.args = args
    }

    public func getPort() throws -> Int {
        guard args.count == 5 else {
            throw CommandLineError.MissingRequiredArgument
        }

        if let port = Int(args[2]) {
            return port
        } else {
            throw CommandLineError.InvalidArgument
        }
    }

    public func getDirectory() throws -> String {
        guard args.count == 5 else {
            throw CommandLineError.MissingRequiredArgument
        }

        let directoryPath = args[4]
        return directoryPath
    }
}
