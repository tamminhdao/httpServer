import Foundation
import Socket
import Requests

public class Server {

    var listeningSocket: Socket!
    var clientSocket: Socket!
    var readData = Data()
    var parser = RequestParser()

    public init(parser: RequestParser) {
        self.parser = parser
    }

    public func run() {
        do {
            try self.listeningSocket = Socket.create()
            try self.listeningSocket.listen(on: 5000)
            repeat {
                try clientSocket = self.listeningSocket.acceptClientConnection()
                let parsedIncomingRequest = parseRequest(socket: clientSocket)
                let httpMethod = parsedIncomingRequest.returnMethod()
                if (httpMethod == "GET" || httpMethod == "POST") {
                    response200(socket: clientSocket)
                }
            } while true
        } catch let error {
            print (error.localizedDescription)
        }
    }

    public func response200(socket: Socket) {
        do {
            let response = Data("HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n".utf8)
            try socket.write(from: response)
        }
        catch let error {
            print (error.localizedDescription)
        }
    }

    public func parseRequest(socket: Socket) -> HttpRequest {
        do {
            _ = try socket.read(into: &readData)
            let incomingText = String(data: readData, encoding: .utf8)
            let parsedRequest = try parser.parse(request: incomingText!)
            readData.count = 0
            return parsedRequest
        } catch let error {
            print (error.localizedDescription)
            return HttpRequest(method: "", url: "", version: "", headers: ["" : ""])
        }
    }
}
