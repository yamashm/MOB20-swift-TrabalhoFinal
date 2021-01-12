//
//  ProductFormViewController.swift
//  BrunoDemetriusDorenaltoMarcelo
//
//  Created by user189149 on 1/6/21.
//  Copyright © 2021 FIAP. All rights reserved.
//

import UIKit
import CoreData

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
    var product: Product?
    var selectedState: State?
    var states: [State] = []
    
    let pikerViewState = UIPickerView()
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Observar o evento do teclado aparecer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //Observa o evento do teclado desaparecer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        loadStates()
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
        if product == nil {
            product = Product(context: context)
        }
        product?.name = textFieldName.text
        product?.image = buttonPoster.currentImage?.pngData()
        product?.state = selectedState
        let value = Double(textFieldValue.text!) ?? 0
        product?.value = value
        product?.card = switchCard.isOn
        
        view.endEditing(true)
        
        do{
            try context.save()
            navigationController?.popViewController(animated: true)
        }catch{
            print(error)
        }
    }
    
    // MARK: - Methods
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupView(){
        if let product = product{
            textFieldName.text = product.name
            buttonSave.setTitle("Alterar", for: .normal)
            buttonPoster.setImage(product.poster, for: .normal) 
        }
    }
    
    private func loadStates(){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            states = try context.fetch(fetchRequest)
        }catch{
            print(error)
        }
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
        pikerViewState.selectRow(row, inComponent: 0, animated: false)
        textFieldState.text = states[row].name
        textFieldState.resignFirstResponder()
    }

    @objc func cancelPicker() {
        textFieldState.text = nil
        textFieldState.resignFirstResponder()
    }
    
    // MARK: - Picker view data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedState = states[row]
        return states[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldState.text = states[row].name
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


