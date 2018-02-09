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
                let emptyPath = "invalidPath"
                expect {
                    try directoryNavigator.contentsOfDirectory()
                }.to(throwError(DirectoryNavigatorError.PathDoesNotExist(atPath: "/invalid/path/")))
            }
        }
    }
}
