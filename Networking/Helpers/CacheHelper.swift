import Foundation

final class CacheHelper: CacheHelperProtocol {
    
    private let cache: NSCache<NSString, NSData>
    
    init() {
        cache = NSCache<NSString, NSData>()
        cache.countLimit = 20
    }
    
    public func cachedData(for url: URL, data: Data) {
        let key = NSString(string: url.absoluteString)
        let data = NSData(data: data)
        cache.setObject(data, forKey: key)
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    public func removeCachedData(for url: URL) {
        cache.removeObject(forKey: NSString(string: url.absoluteString))
    }
    
    public func getDataFromCache(for url: URL) -> Data? {
        let url = NSString(string: url.absoluteString)
        return cache.object(forKey: url) as Data?
    }
    
}
