import Foundation
import Alamofire

final class AlamofireService: NetworkServiceProtocol {
    
    private let session = Alamofire.AF
    
    public func postRequest(data: Data, url: URL, completion: @escaping (RequestResult) -> Void) {
        let headers = HTTPHeaders([HTTPHeader(name: "application/json", value: "Content-Type"),
                                   HTTPHeader(name: "application/json", value: "Accept")])
        
        let jsonHelper = JSONHelper()
        let json = jsonHelper.serialization(for: data)

        if json.error == nil, let data = json.data {

            let parameters: Parameters = data
            
            session.request(url, method: .post, parameters: parameters,  encoding: JSONEncoding.default, headers: headers).validate().responseData { (response) in
                var result: RequestResult
            
                switch response.result {
                case .success(let data):
                    result = .success(data: data)
                case .failure(let error):
                    result = .failure(error: error)
                }
                
                completion(result)
            }
        } else {
            completion(.failure(error: json.error))
        }
    }
    
    public func getRequest(url: URL, completion: @escaping (RequestResult) -> Void) {

        session.request(url, method: .get) .validate().responseData { (response) in
            var result: RequestResult
                
            switch response.result {
            case .success(let data):
                result = .success(data: data)
               case .failure(let error):
                result = .failure(error: error)
            }
                
            completion(result)
        }

    }
    
    public func putRequest(url: URL, for data: Data, completion: @escaping (RequestResult) -> Void) {
        let headers = HTTPHeaders([HTTPHeader(name: "application/json", value: "Content-Type"),
                                   HTTPHeader(name: "application/json", value: "Accept")])
        
        let jsonHelper = JSONHelper()
        let json = jsonHelper.serialization(for: data)

        if json.error == nil, let data = json.data {

            let parameters: Parameters = data
            
            session.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { (response) in
                var result: RequestResult
            
                switch response.result {
                case .success(let data):
                    result = .success(data: data)
                case .failure(let error):
                    result = .failure(error: error)
                }
                
                completion(result)
            }
        } else {
            completion(.failure(error: json.error))
        }
    }
    
    public func deleteRequest(for url: URL, completion: @escaping (RequestResult) -> Void) {
        session.request(url, method: .delete).validate().responseData { (response) in
            var result: RequestResult
            
            switch response.result {
            case .success(let data):
                result = .success(data: data)
            case .failure(let error):
                result = .failure(error: error)
            }
            
            completion(result)
        }
    }

}
