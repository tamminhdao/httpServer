import Foundation
import Requests
import Data

public protocol HttpAction {
    func execute(request: HttpRequest)
}