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

            it ("can log all data") {
                dataStorage.addData(url: "/", value: "Info")
                dataStorage.addData(url: "/form", value: "My_Form")
                let allValues = dataStorage.logData()
                let expected = ["/": "Info", "/form": "My_Form"]
                expect(allValues).to(equal(expected))
            }

            it ("can add requests to the list of incoming requests") {
                dataStorage.addToRequestList(request: "HEAD /form HTTP/1.1")
                dataStorage.addToRequestList(request: "GET /requests HTTP/1.1")
                dataStorage.addToRequestList(request: "PUT /logs HTTP/1.1")
                let allRequests = dataStorage.logRequests()
                let expected = ["HEAD /form HTTP/1.1", "GET /requests HTTP/1.1", "PUT /logs HTTP/1.1"]
                expect(allRequests).to(equal(expected))
            }

            it ("can store a location") {
                dataStorage.setLocation(location: "/chicago")
                let location = dataStorage.getLocation()
                expect(location).to(equal("/chicago"))
            }
        }
    }
}
