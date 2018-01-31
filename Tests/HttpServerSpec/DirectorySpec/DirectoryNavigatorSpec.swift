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
            it ("can return the current directory path") {
                let path = directoryNavigator.currentPath()
                print(path)
            }

            it ("can list the content of particular path") {
                do {
                    let content = try directoryNavigator.contentsOfDirectory(atPath: "/Users/tamdao/Swift/httpServer/cob_spec/public")
                    print(content)
                } catch {
                    print(error)
                }
            }
        }
    }
}