import Foundation

protocol NetworkManagerProtocol {
    
    func fetchAllData(for url: String, completion: @escaping (Result<[Product]>) -> Void)
    func downloadImage(for url: String, completion: @escaping (Result<Data>) -> Void)
    func deleteData(data: Product, completion: @escaping (Result<Product>) -> Void)
    func changeData(data: Product, completion: @escaping (Result<Product>) -> Void)
    
}
