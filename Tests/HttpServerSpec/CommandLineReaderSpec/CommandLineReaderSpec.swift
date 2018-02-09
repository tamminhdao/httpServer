import HttpServer
import Quick
import Nimble

class CommandLineReaderSpec : QuickSpec {
    override func spec() {
        describe("#CommandLineReader") {
            it ("can return the argument for the port number") {
                do {
                    let args = ["/path/to/executable", "-p", "8000", "-d", "/path/to/directory"]
                    let commandLineReader = CommandLineReader(args: args)
                    let port = try commandLineReader.getPort()
                    expect(port).to(equal(8000))
                } catch {}
            }

            it ("throws an error if the port argument is not an integer") {
                let args = ["/path/to/executable", "-p", "number", "-d", "/path/to/directory"]
                let commandLineReader = CommandLineReader(args: args)
                expect {
                    try commandLineReader.getPort()
                }.to(throwError(CommandLineError.InvalidArgument))
            }

            it ("throws an error the port argument is missing") {
                let args = ["/path/to/executable", "-p", "-d", "/path/to/directory"]
                let commandLineReader = CommandLineReader(args: args)
                expect {
                    try commandLineReader.getPort()
                }.to(throwError(CommandLineError.MissingRequiredArgument))
            }

            it ("can return the argument for the directory path") {
                do {
                    let args = ["/path/to/executable", "-p", "8000", "-d", "/path/to/directory"]
                    let commandLineReader = CommandLineReader(args: args)
                    let port = try commandLineReader.getDirectory()
                    expect(port).to(equal("/path/to/directory"))
                } catch {}
            }

            it ("throws an error if the directory argument is missing") {
                let args = ["/path/to/executable", "-p", "-d"]
                let commandLineReader = CommandLineReader(args: args)
                expect {
                    try commandLineReader.getDirectory()
                }.to(throwError(CommandLineError.MissingRequiredArgument))
            }
        }
    }
}
