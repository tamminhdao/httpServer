import Foundation

public class FetchFileAction : HttpAction {

    private var directoryNavigator: DirectoryNavigator
    private var responseGenerator: ResponseGenerator

    public init(directoryNavigator: DirectoryNavigator, responseGenerator: ResponseGenerator) {
        self.directoryNavigator = directoryNavigator
        self.responseGenerator = responseGenerator
    }

    public func execute(request: HttpRequest) -> HttpResponse {
        do {
            let data = try directoryNavigator.readFileContents(filePath: request.returnUrl())
            return responseGenerator.generateFile(body: data)
        } catch let error {
            print(error.localizedDescription)
            return responseGenerator.generate404Response()
        }
    }
}
