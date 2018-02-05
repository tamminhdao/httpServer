import Quick
import Nimble
import HttpServer

class DirectoryNavigatorSpec : QuickSpec {
    override func spec() {
        var directoryNavigator: DirectoryNavigator!

        beforeEach {
            directoryNavigator = DirectoryNavigator()
        }

        describe("#DirectoryNavigator") {
            it ("throws PathDoesNotExistError for the path is invalid") {
                let emptyPath = "invalidPath"
                expect {
                    try directoryNavigator.contentsOfDirectory(atPath: emptyPath)
                }.to(throwError(DirectoryNavigatorError.PathDoesNotExist(atPath: emptyPath)))
            }
        }
    }
}
