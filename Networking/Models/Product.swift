import Foundation

struct Product: Codable {
    public var id: Int
    public var title: String
    public var description: String
    public var price: Float
    public var image: String
    
    init(dict: [String:Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.title = dict["titie"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
        self.price = dict["price"] as? Float ?? 0.0
        self.image = dict["image"] as? String ?? ""
    }
}
