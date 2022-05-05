import Foundation

enum RequestResult {
    case success(data: Data)
    case failure(error: Error?)
}
