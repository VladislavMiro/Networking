import Foundation
import UIKit

protocol RouterProtocol {
    func initialView()
    func openDetailView(data: Product)
    func popView()
    func popToRoot()
}
