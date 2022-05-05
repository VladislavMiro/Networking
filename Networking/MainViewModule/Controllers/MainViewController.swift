import Foundation

final class MainViewController: MainViewControllerProtocol {
        
    private let networkManager: NetworkManagerProtocol
    private let router: RouterProtocol
    
    public var products: [Product]
    
    init(networkManager: NetworkManagerProtocol, router: RouterProtocol) {
        self.networkManager = networkManager
        self.products = [Product]()
        self.router = router
    }
    
    public func preloadData(completion: @escaping (Error?) -> Void) {
        
        networkManager.fetchAllData(for: "https://fakestoreapi.com/products") { [unowned self] (result) in
            var error: Error? = nil
            
            switch result {
            case .success(data: let data):
                self.products = data
            case .falure(error: let err):
                error = err
            }
            
            completion(error)
        }
        
    }
    
    public func deleteData(at index: Int, completion: @escaping (Error?) -> Void) {
        
        let product = products[index]
        
        networkManager.deleteData(data: product) { (result) in
            var error: Error? = nil
            
            switch result {
            case .success(data: _):
                self.products.remove(at: index)
            case .falure(error: let err):
                error = err
            }

            completion(error)
        }
    }
    
    public func openDetailView(forDataAt index: Int) {
        let data = products[index]
        router.openDetailView(data: data)
    }
}
