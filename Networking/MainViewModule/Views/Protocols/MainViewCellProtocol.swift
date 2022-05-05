import Foundation

protocol MainViewCellProtocol: class {
    var controller: CellControllerProtocol! { get set }
    func updateCell()
}
