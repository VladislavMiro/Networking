import Foundation

final class MainViewCellController: CellControllerProtocol {
    
    public var product: Product
    
    private let networkManager: NetworkManagerProtocol
    
    init(product: Product) {
        self.product = product
        self.networkManager = NetworkManager(jsonHelper: JSONHelper(), networkService: URLSessionService(), cacheHelper: CacheHelper())
    }
    
    public func downloadImage(completion: @escaping (Data?) -> Void) {
        
        networkManager.downloadImage(for: product.image) { (result) in
            switch result {
            case .success(data: let data):
                completion(data)
            case .falure(error: _):
                completion(nil)
            }
        }
        
    }
    
}
