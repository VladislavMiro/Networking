import Foundation

enum Result<T: Codable> {
    case success(data: T)
    case falure(error: Error?)
}

final class NetworkManager: NetworkManagerProtocol {

    private let json: JSONHelperProtocol
    private let request: NetworkServiceProtocol
    private var cache: CacheHelperProtocol
    
    init(jsonHelper: JSONHelperProtocol, networkService: NetworkServiceProtocol, cacheHelper: CacheHelperProtocol) {
        self.json = jsonHelper
        self.request = networkService
        self.cache = cacheHelper
    }
    
    public func fetchAllData(for url: String, completion: @escaping (Result<[Product]>) -> Void) {

        guard let url = URL(string: url) else { return }
        
        request.getRequest(url: url) { [unowned self] (requestResult) in
            switch requestResult {
            case .success(data: let data):
                let decodeData = self.json.decode(type: [Product].self, from: data)
                decodeData.error == nil ? completion(.success(data: decodeData.data!)) : completion(.falure(error: decodeData.error))
            case .failure(error: let error):
                completion(.falure(error: error))
            }
        }
    }
    
    public func downloadImage(for url: String, completion: @escaping (Result<Data>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        if let data = cache.getDataFromCache(for: url) {
            completion(.success(data: data))
        } else {
            request.getRequest(url: url) { [unowned self] (requestResult) in

                var result: Result<Data>
                
                switch requestResult {
                case .success(data: let data):
                    self.cache.cachedData(for: url, data: data)
                    result = .success(data: data)
                case .failure(error: let error):
                    result = .falure(error: error)
                }
                
                completion(result)
            }
        }
        
    }
    
    public func deleteData(data: Product, completion: @escaping (Result<Product>) -> Void) {
        
        guard let url = URL(string: "https://fakestoreapi.com/products/\(data.id)"),
              let imageURL = URL(string: data.image)  else { return }
        
        request.deleteRequest(for: url) { [unowned self] (requestResult) in
            var result: Result<Product>
            
            switch requestResult {
            case .success(data: let data):
                let decodeData = self.json.decode(type: Product.self, from: data)
                
                if decodeData.error == nil, let data = decodeData.data {
                    self.cache.removeCachedData(for: imageURL)
                    result = .success(data: data)
                } else {
                    result = .falure(error: decodeData.error)
                }
                
            case .failure(error: let err):
                result = .falure(error: err)
            }
            
            completion(result)
        }
    }
    
    public func changeData(data: Product, completion: @escaping (Result<Product>) -> Void) {

        guard let url = URL(string: "https://fakestoreapi.com/products/\(data.id)"),
              let imageURL = URL(string: data.image) else { return }

        let encodeData = json.encode(for: data)
        
        if encodeData.error == nil, let data = encodeData.data {
            request.putRequest(url: url, for: data) { (requestResult) in
                var result: Result<Product>
                
                switch requestResult {
                case .success(data: let data):
                    
                    let decodeData = self.json.decode(type: Product.self, from: data)
                    
                    if decodeData.error == nil, let data = decodeData.data  {
                        self.cache.removeCachedData(for: imageURL)
                        result = .success(data: data)
                    } else {
                        result = .falure(error: decodeData.error)
                    }
                case .failure(error: let error):
                    result = .falure(error: error)
                }
                
                completion(result)
            }
        } else {
            completion(.falure(error: encodeData.error))
        }

    }
    
}
