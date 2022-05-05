import Foundation

struct JSONHelper: JSONHelperProtocol {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func decode<T: Codable>(type: T.Type, from data: Data) -> (data: T?, error: Error?) {
        do {
            let data = try decoder.decode(type, from: data)
            print(data)
            return (data, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    public func encode<T: Codable>(for data: T) -> (data: Data?, error: Error?) {
        do {
            let data = try encoder.encode(data)
            return (data, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    public func serialization(for data: Data) -> (data: [String : Any]?, error: Error?) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            return (json, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    public func deserialization(data: Data) -> (data: Data?, error: Error?) {
        do {
            let json = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return (json, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
}
