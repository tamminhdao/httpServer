import Foundation
import Dispatch
import Socket

public class Server {

    var port: Int
    var directory: String
    var listeningSocket: Socket!
    var parser: RequestParser
    var router: Router
    var dataStorage: DataStorage
    let serialQueue = DispatchQueue(label: "queue incoming requests", qos: .default)

    public init(port: Int, directory: String, router: Router, dataStorage: DataStorage) {
        self.parser = RequestParser()
        self.port = port
        self.directory = directory
        self.router = router
        self.dataStorage = dataStorage
    }

    public func run() {
        let queue = DispatchQueue.global(qos: .userInteractive)

        do {
            try self.listeningSocket = Socket.create()
            try self.listeningSocket.listen(on: port)

            repeat {
                let clientSocket = try self.listeningSocket.acceptClientConnection()
                queue.async {
                    self.handleRequest(socket: clientSocket)
                }
            } while true
        } catch let error {
            print (error.localizedDescription)
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
        }
        catch let error {
            print (error.localizedDescription)
        }
    }

    private func parseRequest(socket: Socket) -> HttpRequest {
        do {
            var readData = Data()
            _ = try socket.read(into: &readData)
            let incomingText = String(data: readData, encoding: .utf8)

            let parsedRequest = try self.parser.parse(request: incomingText!)
            readData.count = 0
            serialQueue.async {
                self.logRequest(parsedRequest: parsedRequest)
            }

            return parsedRequest
        } catch let error {
            print (error.localizedDescription)
            return HttpRequest(method: nil, url: "", params: [:], version: "", headers: ["" : ""], body: ["": ""])
        }
    }

    private func logRequest(parsedRequest: HttpRequest) {
        if let validMethod = parsedRequest.returnMethod() {
            let statusLine = validMethod.rawValue + " " + parsedRequest.returnUrl() + " " + parsedRequest.returnVersion()
            dataStorage.addToRequestList(request: statusLine)
        }
    }
}
