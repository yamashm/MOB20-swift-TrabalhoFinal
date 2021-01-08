//
//  ProductFormViewController.swift
//  BrunoDemetriusDorenaltoMarcelo
//
//  Created by user189149 on 1/6/21.
//  Copyright © 2021 FIAP. All rights reserved.
//

import UIKit

class ProductFormViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldState: UITextField!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: - Properties
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func save(_ sender: UIButton) {
    }
    
    // MARK: - Methods

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

}
