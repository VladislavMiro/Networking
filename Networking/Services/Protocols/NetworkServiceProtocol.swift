import Foundation

protocol NetworkServiceProtocol {
    
    func postRequest(data: Data, url: URL, completion: @escaping (RequestResult) -> Void)
    func getRequest(url: URL, completion: @escaping (RequestResult) -> Void)
    func putRequest(url: URL, for data: Data, completion: @escaping (RequestResult) -> Void)
    func deleteRequest(for url: URL, completion: @escaping (RequestResult) -> Void)
    
}
