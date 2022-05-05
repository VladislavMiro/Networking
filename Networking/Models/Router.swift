import Foundation
import UIKit

final class Router: RouterProtocol {
    
    private let navigationController: UINavigationController?
    private let builder: ViewBuilderProtocol
    
    init(navigationController: UINavigationController, builder: ViewBuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    public func initialView() {
        if let navigationController = navigationController {
            let view = builder.buildMainView(router: self) 
            navigationController.viewControllers = [view]
        }
    }
    
    public func openDetailView(data: Product) {
        if let navigationController = navigationController {
            guard let view = builder.buildDetailView(data: data, router: self) else { return }
            navigationController.pushViewController(view, animated: true)
        }
    }
    
    public func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    public func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}
