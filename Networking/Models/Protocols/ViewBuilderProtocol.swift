import Foundation
import UIKit

protocol ViewBuilderProtocol {
    func buildMainView(router: RouterProtocol) -> UIViewController
    func buildDetailView(data: Product, router: RouterProtocol) -> UIViewController?
}
