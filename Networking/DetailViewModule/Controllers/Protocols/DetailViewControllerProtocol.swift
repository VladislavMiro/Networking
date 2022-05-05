import Foundation

protocol DetailViewControllerProtocol {
    var product: Product { get }
    func saveData(title: String, descriptionOfProduct: String, price: String, completion: @escaping (Error?) -> Void)
    func downloadImage(completion: @escaping (Data?) -> Void)
}
