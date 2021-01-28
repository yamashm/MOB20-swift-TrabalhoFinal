import UIKit

class ProductFormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldState: UITextField!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonState: UIButton!
    @IBOutlet weak var switchCard: UISwitch!
    @IBOutlet weak var buttonPoster: UIButton!
    
    // MARK: - Properties
    var selectedState: State?
    let pikerViewState = UIPickerView()
    let viewModel: ProductFormViewModel = ProductFormViewModel(product: nil)

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        pikerViewState.dataSource = self
        pikerViewState.delegate = self

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textFieldState.inputView = pikerViewState
        textFieldState.inputAccessoryView = toolBar

        setupView()
        viewModel.loadStates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Observar o evento do teclado aparecer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //Observa o evento do teclado desaparecer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - IBActions
    @IBAction func selectImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde voce quer escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
                // codigo quando clicar no botao camera
                self.selectPictureFrom(.camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (_) in
            self.selectPictureFrom(.photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default) { (_) in
            self.selectPictureFrom(.savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        if textFieldName.text!.isEmpty || textFieldState.text!.isEmpty || textFieldValue.text!.isEmpty {
            showErrorAlert(title: "Alerta!", message: "Todos os campos devem estar preechidos!")

            return
        }

        if viewModel.product == nil {
            viewModel.initProduct()
        }

        viewModel.product?.name = textFieldName.text
        viewModel.product?.image = buttonPoster.currentImage?.pngData()
        viewModel.product?.state = selectedState
        let value = Double(textFieldValue.text ?? "0.0") ?? 0
        viewModel.product?.value = value
        viewModel.product?.card = switchCard.isOn

        view.endEditing(true)

        viewModel.saveProduct()
    }

    // MARK: - Methods
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    private func setupView() {
        if let product = viewModel.product {
            textFieldName.text = product.name
            buttonSave.setTitle("Alterar", for: .normal)
            buttonPoster.setImage(product.poster, for: .normal)
            textFieldState.text = product.state?.name
            selectedState = product.state
            textFieldValue.text = String(format: "%.2f",product.value)
            switchCard.isOn = product.card
        }
    }

    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        //Altera o espaco na base da scrollview com base na altura do teclado tirando a safearea
        scrollView.contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.verticalScrollIndicatorInsets.bottom  = keyboardFrame.size.height - view.safeAreaInsets.bottom
    }

    @objc
    private func keyboardWillHide(){
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom  = 0
    }

    @objc func donePicker() {
        let row = pikerViewState.selectedRow(inComponent: 0)
        if viewModel.countStates > 0 {
            let state = viewModel.getState(at: row)

            pikerViewState.selectRow(row, inComponent: 0, animated: false)
            selectedState = state
            textFieldState.text = state.name
            textFieldState.resignFirstResponder()
        }
    }

    @objc func cancelPicker() {
        textFieldState.resignFirstResponder()
    }

    // MARK: - Picker view data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.countStates
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return viewModel.getState(at: row).name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldState.text = viewModel.getState(at: row).name
    }
}

extension ProductFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            buttonPoster.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProductFormViewController: ProductFormViewModelDelegate {
    func onSucess() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    func onError(error: String) {
        DispatchQueue.main.async {
            self.showErrorAlert(title: "Alerta!", message: error)
        }
    }
}
