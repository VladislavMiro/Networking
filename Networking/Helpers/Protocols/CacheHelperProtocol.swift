import Foundation

protocol CacheHelperProtocol {
    func cachedData(for url: URL, data: Data)
    func clearCache()
    func removeCachedData(for url: URL)
    func getDataFromCache(for url: URL) -> Data?
}
