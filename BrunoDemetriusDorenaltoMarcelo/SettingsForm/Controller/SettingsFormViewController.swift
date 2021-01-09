//
//  SettingsFormViewController.swift
//  BrunoDemetriusDorenaltoMarcelo
//
//  Created by user189149 on 1/9/21.
//  Copyright © 2021 FIAP. All rights reserved.
//

import UIKit

class SettingsFormViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var textFieldXRate: UITextField!
    @IBOutlet weak var buttonAddState: UIButton!
    @IBOutlet weak var textFieldTax: UITextField!
    @IBOutlet weak var tableViewStateTax: UITableView!
    
    // MARK: - Properties
    let label: UILabel = {
           let label = UILabel(frame: .zero)
           label.text = "Lista de estados vazia."
           label.textAlignment = .center
           label.font = UIFont.italicSystemFont(ofSize: 16.0)
           return label
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

