import Foundation
import Dispatch
import Socket
import Requests
import Responses
import Router

public class Server {

    var listeningSocket: Socket!
    var parser: RequestParser
    var router: Router
    var numberOfThread = 0

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
                if numberOfThread < 5 {
                    let clientSocket = try self.listeningSocket.acceptClientConnection()
                    numberOfThread += 1
                    queue.async {
                        self.handleRequest(socket: clientSocket)
                    }
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
        numberOfThread -= 1
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
            return parsedRequest
        } catch let error {
            print (error.localizedDescription)
            return HttpRequest(method: HttpMethod.get, url: "", version: "", headers: ["" : ""], body: ["": ""])
        }
    }
}
