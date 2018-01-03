import Foundation
import Requests
import Values

public protocol HttpAction {
    var dataStorage: DataStorage {get set}
    func execute(request: HttpRequest)
}
