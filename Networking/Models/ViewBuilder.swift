import Foundation
import UIKit

final class ViewBuilder: ViewBuilderProtocol {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    public func buildMainView(router: RouterProtocol) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let view = storyboard.instantiateViewController(withIdentifier: "MainView") as? MainView else { fatalError() }
        
        let controller = MainViewController(networkManager: networkManager, router: router)
        
        view.controller = controller
        
        return view
    }
    
    public func buildDetailView(data: Product, router: RouterProtocol) -> UIViewController? {
        let storyboard = UIStoryboard(name: "DetailView", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(withIdentifier: "DetailView") as? DetailView else { return nil }
        
        let controller: DetailViewControllerProtocol = DetailViewController(data: data, networkManager: networkManager, router: router)
        
        view.controller = controller
        
        return view
    }
}
