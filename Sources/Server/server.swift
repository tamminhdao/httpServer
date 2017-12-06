import Foundation
import Socket

public class Server {

    public init() {}

    public func run() {

        var listeningSocket: Socket!
        var clientSocket: Socket!

        do {
            try listeningSocket = Socket.create()
            try listeningSocket.listen(on: 5000)

            repeat {
                try clientSocket = listeningSocket.acceptClientConnection()
                let response = Data("HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n".utf8)
                try clientSocket.write(from: response)
            } while true
        }
        catch {
            print ("Something went wrong")
        }
    }
}
