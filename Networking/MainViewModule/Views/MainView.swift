import UIKit

final class MainView: UICollectionViewController, MainViewProtocol {
        
    @IBOutlet private weak var editButton: UIBarButtonItem!
    
    public var controller: MainViewControllerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        refreshData()
    }
    
    private func configureView() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    @objc private func refreshData() {
        collectionView.refreshControl?.beginRefreshing()
        
        controller.preloadData { [unowned self] (error) in
            if error == nil {
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            } else {
                guard let error = error?.localizedDescription else { return }
                let alert = self.showAlert(title: "Error", message: error)
                self.present(alert, animated: true, completion: nil)
                self.collectionView.refreshControl?.endRefreshing()
            }
        }

    }
    
    @IBAction private func editBitton(_ sender: UIBarButtonItem) {
        self.setEditing(!isEditing, animated: true)
        
        if isEditing {
            editButton.title = "Cancel"
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        } else {
            editButton.title = "Edit"
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return controller.products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainViewCell
        
        let product = controller.products[indexPath.row]

        cell.controller = MainViewCellController(product: product)
        cell.updateCell()

        cell.isEditing = isEditing
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing {
            deleteRow(at: indexPath)
        } else {
            controller.openDetailView(forDataAt: indexPath.row)
        }
    }
    
    private func deleteRow(at indexPath: IndexPath) {

        controller.deleteData(at: indexPath.row) { [unowned self] (error) in
            if error == nil {
                self.collectionView.deleteItems(at: [indexPath])
            } else {
                guard let error = error?.localizedDescription else { return }
                
                let alert = self.showAlert(title: "Error", message: error)
                
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    private func showAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

        alert.addAction(okAction)
            
        return alert
    }
    
}
