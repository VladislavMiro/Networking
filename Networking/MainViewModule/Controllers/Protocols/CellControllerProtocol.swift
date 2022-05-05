import Foundation

protocol CellControllerProtocol: class {
    var product: Product { get }
    func downloadImage(completion: @escaping (Data?) -> Void)
}
