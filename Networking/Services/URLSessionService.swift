import Foundation

final class URLSessionService: NetworkServiceProtocol {
    
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.shouldUseExtendedBackgroundIdleMode = false
        config.waitsForConnectivity = true
        config.isDiscretionary = true
        
        session = URLSession(configuration: config)
    }
    
    init(with config: URLSessionConfiguration) {
        session = URLSession(configuration: config)
    }
    
    public func postRequest(data: Data, url: URL, completion: @escaping (RequestResult) -> Void) {
        var request = URLRequest(url: url,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 5 * 60)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = data

        session.dataTask(with: request) { (data, response, error) in
            var result: RequestResult
            
            guard let response = response, let data = data else { return }
            
            print(response)
            
            result = error == nil ? .success(data: data) : .failure(error: error)
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    public func getRequest(url: URL, completion: @escaping (RequestResult) -> Void) {

        let request = URLRequest(url: url,
                                    cachePolicy: .returnCacheDataElseLoad,
                                    timeoutInterval: 5 * 60)
            
        session.dataTask(with: request) { (data, response, error) in
            var result: RequestResult
            guard let data = data, let response = response else { return }
                
            print(response)
                
            result = error == nil ? .success(data: data) : .failure(error: error)
                
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()

    }

    public func putRequest(url: URL, for data: Data, completion: @escaping (RequestResult) -> Void) {
        var request = URLRequest(url: url,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 5 * 60)
        
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = data

        session.dataTask(with: request) { (data, response, error) in
            var result: RequestResult
            
            guard let response = response, let data = data else { return }
            
            print(response)
            
            result = error == nil ? .success(data: data) : .failure(error: error)
            
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
    
    public func deleteRequest(for url: URL, completion: @escaping (RequestResult) -> Void) {
        var request = URLRequest(url: url,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 5 * 60)
        
        request.httpMethod = "DELETE"

        session.dataTask(with: request) { (data, response, error) in
            var result: RequestResult

            guard let response = response, let data = data else { return }
            
            print(response.expectedContentLength)
            
            result = error == nil ? .success(data: data) : .failure(error: error)
            
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
    
    
}
