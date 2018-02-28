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
        }
    }
}
