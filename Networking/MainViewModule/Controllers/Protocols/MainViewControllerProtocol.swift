import Foundation

protocol MainViewControllerProtocol: class {
    var products: [Product] { get }
    func preloadData(completion: @escaping (Error?) -> Void)
    func deleteData(at index: Int, completion: @escaping (Error?) -> Void)
    func openDetailView(forDataAt index: Int)
}
