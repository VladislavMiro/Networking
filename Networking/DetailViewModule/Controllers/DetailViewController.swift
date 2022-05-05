import Foundation

final class DetailViewController: DetailViewControllerProtocol {
    
    public var product: Product
    
    private let networkManager: NetworkManagerProtocol!
    private let router: RouterProtocol
    
    required init(data: Product, networkManager: NetworkManagerProtocol, router: RouterProtocol) {
        self.product = data
        self.networkManager = networkManager
        self.router = router
    }
    
    public func downloadImage(completion: @escaping (Data?) -> Void) {
        
        networkManager.downloadImage(for: product.image) { (result) in
            var image: Data?
            
            switch result {
            case .success(data: let data):
                image = data
            case .falure(error: _):
                break
            }
            
            completion(image)
        }
    }
    
    public func saveData(title: String, descriptionOfProduct: String, price: String, completion: @escaping (Error?) -> Void) {
        var newProduct = product
        
        newProduct.title = title
        newProduct.description = descriptionOfProduct
        newProduct.price = Float(price) ?? 0.00
        
        networkManager.changeData(data: newProduct) { (result) in
            
            switch result {
            case .success(data: let data):
                self.product = data
            case .falure(error: let error):
                completion(error)
            }
            
        }
    }
    
    
}
