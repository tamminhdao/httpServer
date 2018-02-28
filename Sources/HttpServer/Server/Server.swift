import Foundation
import Dispatch
import Socket
import SwiftyBeaver

public class Server {

    var port: Int
    var directory: String
    var listeningSocket: Socket!
    var parser: RequestParser
    var router: Router
    var dataStorage: DataStorage
    let serialQueue = DispatchQueue(label: "queue incoming requests", qos: .default)
    let logger = SwiftyBeaver.self
    let console = ConsoleDestination()
    let file = FileDestination()

    public init(port: Int = 5000, directory: String = "./cob_spec/public", router: Router, dataStorage: DataStorage) {
        self.parser = RequestParser()
        self.port = port
        self.directory = directory
        self.router = router
        self.dataStorage = dataStorage
        file.logFileURL = URL(string: "/Users/tamdao/Swift/httpServer/server.log")
        logger.addDestination(console)
        logger.addDestination(file)
    }

    public func run() {
        let queue = DispatchQueue.global(qos: .userInteractive)

        do {
            try self.listeningSocket = Socket.create()

            guard let socket = self.listeningSocket else {
                logger.error("Unable to unwrap socket...")
                return
            }

            try socket.listen(on: port)
            logger.info("Listening on port: \(port)")

            repeat {
                let clientSocket = try socket.acceptClientConnection()

                queue.async {
                    self.handleRequest(socket: clientSocket)
                }
            } while true
        } catch let error {
            logger.error("Error while making socket connection \(error.localizedDescription)")
        }
    }

    private func handleRequest(socket: Socket) {
        let parsedIncomingRequest = parseRequest(socket: socket)
        let categorizedResponse = router.route(request: parsedIncomingRequest)
        sendBackResponse(socket: socket, response: categorizedResponse)
        socket.close()
    }

    private func sendBackResponse (socket: Socket, response: HttpResponse) {
        do {
            let data = response.constructResponse()
            try socket.write(from: data)

            if let dataToString = String(data: data, encoding: .utf8) {
                logger.debug("Outgoing response: \n\(dataToString)")
            } else {
                logger.debug("Fetching an image file")
            }
        }
        catch let error {
            logger.error("Error while sending back response \(error.localizedDescription)")
        }
    }

    private func parseRequest(socket: Socket) -> HttpRequest {
        do {
            var readData = Data()
            _ = try socket.read(into: &readData)

            if let incomingText = String(data: readData, encoding: .utf8) {
                logger.debug("Incoming request: \n\(incomingText)")

                let parsedRequest = try self.parser.parse(request: incomingText)

                readData.count = 0
                serialQueue.async {
                    self.logRequest(parsedRequest: parsedRequest)
                }

                return parsedRequest
            } else {
                return HttpRequest.emptyRequest()
            }
        } catch let error {
            logger.error("Error while parsing request \(error.localizedDescription)")
            return HttpRequest.emptyRequest()
        }
    }

    private func logRequest(parsedRequest: HttpRequest) {
        if let validMethod = parsedRequest.returnMethod() {
            let statusLine = validMethod.rawValue + " " + parsedRequest.returnUrl() + " " + parsedRequest.returnVersion()
            dataStorage.addToRequestList(request: statusLine)
        }
    }
}
