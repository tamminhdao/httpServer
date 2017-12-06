import Foundation
import Socket

public class Server {

    var listeningSocket: Socket!
    var clientSocket: Socket!
    var readData = Data()

    public init() {}

    public func run() {
        do {
            try self.listeningSocket = Socket.create()
            try self.listeningSocket.listen(on: 5000)
            repeat {
                try clientSocket = self.listeningSocket.acceptClientConnection()
                printRequest(socket: clientSocket)
                response200(socket: clientSocket)
//                clientSocket.close()
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

    public func printRequest(socket: Socket) {
        do {
                _ = try socket.read(into: &readData)
                let request = String(data: readData, encoding: .utf8)
                let reply = "Received:\n \(request!)\n"
                print(reply)
                readData.count = 0
        } catch let error {
            print (error.localizedDescription)
        }
    }
}
