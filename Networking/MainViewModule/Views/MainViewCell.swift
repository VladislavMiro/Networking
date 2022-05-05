import UIKit

final class MainViewCell: UICollectionViewCell, MainViewCellProtocol {
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var selectMark: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    public var controller: CellControllerProtocol!
    
    public var isEditing: Bool = false {
        didSet {
            selectMark.isHidden = !isEditing
        }
    }
    
    public func updateCell() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        let data = controller.product
        
        layer.cornerRadius = 5.0
        
        title.text = data.title
        price.text = "Price: $\(data.price)"
        
        controller.downloadImage { [unowned self] (data) in
            if let image = data {
                self.image.image = UIImage(data: image)
            }
            
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
        }
        
    }
}
