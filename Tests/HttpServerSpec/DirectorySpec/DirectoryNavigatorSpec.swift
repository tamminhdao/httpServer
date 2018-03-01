import Quick
import Nimble
import HttpServer

class DirectoryNavigatorSpec : QuickSpec {
    override func spec() {
        var directoryNavigator: DirectoryNavigator!

        beforeEach {
            directoryNavigator = DirectoryNavigator(directoryPath: "/invalid/path/")
        }

        describe("#DirectoryNavigator") {
            it ("throws PathDoesNotExistError for the path is invalid") {
                expect {
                    try directoryNavigator.contentsOfDirectory(atPath: "/invalid/path/")
                }.to(throwError(DirectoryNavigatorError.PathDoesNotExist(atPath: "/invalid/path/")))
            }

            it ("can distinguish between a directory and a file") {
                do {
                    let typeDirectory = try directoryNavigator.fileType(atPath: "./cob_spec/public")
                    let typeFile = try directoryNavigator.fileType(atPath: "./cob_spec/public/file1")
                    expect(typeDirectory).to(equal("NSFileTypeDirectory"))
                    expect(typeFile).to(equal("NSFileTypeRegular"))
                } catch {}
            }
        }
    }
}
