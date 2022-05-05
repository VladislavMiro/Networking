import UIKit

final class DetailView: UIViewController, DetailViewProtocol {

    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var titeField: UITextField!
    @IBOutlet private weak var descriptionField: UITextView!
    @IBOutlet private weak var priceField: UITextField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    public var controller: DetailViewControllerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationView()
        fillFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    @IBAction private func editButton(_ sender: UIBarButtonItem) {
        self.setEditing(!isEditing, animated: true)
        
        titeField.isEnabled = isEditing
        descriptionField.isEditable = isEditing
        priceField.isEnabled = isEditing
        
        descriptionField.isUserInteractionEnabled = isEditing
        
        if !isEditing {
            saveChanges()
            editButton.title = "Edit"
        } else {
            editButton.title = "Save"
        }
    }
    
    private func saveChanges() {
        guard let title = titeField.text,
              let descriptionOfProduct = descriptionField.text,
              let price = priceField.text
        else { return }
        
        controller.saveData(title: title, descriptionOfProduct: descriptionOfProduct, price: price) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func configurationView() {
        productImage.layer.cornerRadius = 5.0
        productImage.layer.masksToBounds = true
        productImage.layer.borderColor = UIColor.lightGray.cgColor
        productImage.layer.borderWidth = 1.0
        
        titeField.isEnabled = isEditing
        descriptionField.isEditable = isEditing
        priceField.isEnabled = isEditing
        
        descriptionField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionField.layer.borderWidth = 1.0
        descriptionField.layer.cornerRadius = 5.0
        
        titeField.delegate = self
        priceField.delegate = self
        descriptionField.delegate = self
    }

    private func fillFields() {
        guard let controller = controller else { return }
        let data = controller.product
        
        titeField.text = data.title
        descriptionField.text = data.description
        priceField.text = String(data.price.description)
        
        controller.downloadImage { [unowned self] (image) in
            if let image = image {
                self.productImage.image = UIImage(data: image)
            }
        }
    }
}

//MARK: Клавиатура
extension DetailView {
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func showKeyboard(notification: Notification) {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
            let keyboardHeight = keyboardFrame.cgRectValue.height
        
            UIView.animate(withDuration: 1.0) {
                self.view.frame.origin.y = -(keyboardHeight - self.priceField.frame.height)
            }
        
    }
    
    @objc private func hideKeyboard() {
        UIView.animate(withDuration: 1.0) {
            self.view.frame.origin.y = 0
        }
    }
}

extension DetailView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DetailView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isEditing {
            let toolBar = UIToolbar()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                
            toolBar.items = [flexibleSpace, doneButton]
            toolBar.sizeToFit()
                
            textView.inputAccessoryView = toolBar
        }
        return true
    }
    
    @objc private func doneButtonPressed() {
        descriptionField.endEditing(true)
    }
}
