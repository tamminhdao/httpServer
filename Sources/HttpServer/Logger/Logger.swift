import Foundation
import SwiftyBeaver

public class Logger {

    let log = SwiftyBeaver.self
    let console = ConsoleDestination()
    let file = FileDestination()
    let fileURL = URL(string: "/Users/tamdao/Swift/httpServer/server.log")

    public init() {}

    public func logToConsole_info(message: String) {
        log.addDestination(console)
        log.info(message)
    }

    public func logToConsole_debug(message: String) {
        log.addDestination(console)
        log.debug(message)
    }

    public func logToConsole_warning(message: String) {
        log.addDestination(console)
        log.warning(message)
    }

    public func logToConsole_error(message: String) {
        log.addDestination(console)
        log.error(message)
    }

    public func logToFile(message: String) {
//        try createLogFile()
        file.logFileURL = fileURL
        log.addDestination(file)
        log.debug(message)
    }

//    private func createLogFile() throws {
//        try "".write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
//    }
}
