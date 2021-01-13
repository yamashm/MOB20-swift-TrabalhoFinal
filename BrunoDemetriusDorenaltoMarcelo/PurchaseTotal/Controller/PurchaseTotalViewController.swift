//
//  PurchaseTotalViewController.swift
//  BrunoDemetriusDorenaltoMarcelo
//
//  Created by user189149 on 1/12/21.
//  Copyright © 2021 FIAP. All rights reserved.
//

import UIKit
import CoreData

class PurchaseTotalViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var labelTotalUSD: UILabel!
    @IBOutlet weak var labelTotalBRL: UILabel!
    
    // MARK: - Properties
    var products: [Product] = []
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProducts()
        
    }
    
    private func loadProducts(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            products = try context.fetch(fetchRequest)
            totalValue()
        }catch{
            print(error)
        }
    }
    
    private func totalValue(){
        var totalUSD: Double = 0
        var totalBRL: Double = 0
        
        let ud = UserDefaults.standard
        let xrate = ud.string(forKey: "xrate")
        let operationtax = ud.string(forKey: "operationtax")
        
        let xrateValue = Double(xrate!) ?? 0
        let operationtaxValue = Double(operationtax!) ?? 0
        
        for p in products {
            let valueUSD = p.value * (1 + p.state!.tax/100)
            totalUSD += valueUSD
            
            if p.card {
                totalBRL += (valueUSD * xrateValue) * (1 + operationtaxValue/100)
            } else {
                totalBRL += (valueUSD * xrateValue)
            }

        }
        
        labelTotalUSD.text = String(format: "%.2f", totalUSD)
        labelTotalBRL.text = String(format: "%.2f", totalBRL)
    }
}
