import Foundation
import Requests
import Data

public class NullAction: HttpAction {

    public init() {}

    public func execute(request: HttpRequest) {}
}
