import HttpServer
import Quick
import Nimble

class DataStorageSpec : QuickSpec {
    override func spec() {
        describe("#DataStorage") {
            var dataStorage : DataStorage!

            beforeEach {
                dataStorage = DataStorage()
            }

            it ("can add data as key value pairs") {
                dataStorage.addData(url: "/form", value: "Info")
                let value = dataStorage.logDataByUrl(url: "/form")
                expect(value).to(equal("Info"))
            }

            it ("returns an empty string if the url key does not exist in the data dictionary") {
                let value = dataStorage.logDataByUrl(url: "/unknownURL")
                expect(value).to(equal(""))
            }

            it ("can remove data by the url key") {
                dataStorage.addData(url: "/", value: "Some value")
                dataStorage.removeData(url: "/")
                let value = dataStorage.logDataByUrl(url: "/")
                expect(value).to(equal(""))
            }
        }
    }
}
