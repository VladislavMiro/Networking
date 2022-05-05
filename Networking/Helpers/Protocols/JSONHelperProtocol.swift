import Foundation

protocol JSONHelperProtocol {
    
    func decode<T: Codable>(type: T.Type, from data: Data) -> (data: T?, error: Error?)
    func encode<T: Codable>(for data: T) -> (data: Data?, error: Error?)
    func serialization(for data: Data) -> (data: [String : Any]?, error: Error?)
    func deserialization(data: Data) -> (data: Data?, error: Error?)
    
}
