import HttpServer

let dataStorage = DataStorage()
let httpParser = RequestParser()
let commandLineReader = CommandLineReader(args: CommandLine.arguments)
let port = try commandLineReader.getPort()
let directory = try commandLineReader.getDirectory()
let directoryNavigator = DirectoryNavigator(directoryPath: directory)
let router = Router(dataStorage: dataStorage, directoryNavigator: directoryNavigator)
let server = Server(port: port, directory: directory, router: router, dataStorage: dataStorage)

server.run()
