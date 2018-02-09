import Foundation

public class FetchFileAction : HttpAction {

    private var directoryNavigator: DirectoryNavigator
    private var responseBuilder: ResponseBuilder

    public init(directoryNavigator: DirectoryNavigator, responseBuilder: ResponseBuilder) {
        self.directoryNavigator = directoryNavigator
        self.responseBuilder = responseBuilder
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        do {
            let data = try directoryNavigator.readFileContents(filePath: request.returnUrl())
            return responseBuilder.generateFile(body: data)
        } catch let error {
            print(error.localizedDescription)
            return responseBuilder.generate404Response()
        }
    }
}
