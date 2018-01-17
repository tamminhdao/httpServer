import Foundation
import Dispatch
import Socket
import Requests
import Responses
import Router

enum ServerErrors: Error {
    case SocketCreationFailed
}

public class Server {

    var listeningSocket: Socket!
    var clientSocket: Socket!
    var readData = Data()
    var parser: RequestParser
    var router: Router

    public init(parser: RequestParser, router: Router) {
        self.parser = parser
        self.router = router
    }

    public func run() {
        let queue = DispatchQueue(label: "Queue", attributes: .concurrent)

        do {
            try self.listeningSocket = Socket.create()
            try self.listeningSocket.listen(on: 5000)

            repeat {
                try clientSocket = self.listeningSocket.acceptClientConnection()
                queue.async {
                    self.handleRequest(socket: self.clientSocket)
                }
            } while true
        } catch let error {
            print (error.localizedDescription)
        }
    }

    private func handleRequest(socket: Socket) {
        let parsedIncomingRequest = parseRequest(socket: clientSocket)

        let categorizedResponse = router.route(request: parsedIncomingRequest)

        sendBackResponse(socket: clientSocket, response: categorizedResponse)

        clientSocket.close()

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
            _ = try socket.read(into: &readData)
            let incomingText = String(data: readData, encoding: .utf8)
            let parsedRequest = try self.parser.parse(request: incomingText!)
            readData.count = 0
            return parsedRequest
        } catch let error {
            print (error.localizedDescription)
            return HttpRequest(method: HttpMethod.get, url: "", version: "", headers: ["" : ""], body: ["": ""])
        }
    }
}
