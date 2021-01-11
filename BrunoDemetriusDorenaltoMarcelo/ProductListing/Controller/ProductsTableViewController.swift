//
//  ProductsTableViewController.swift
//  BrunoDemetriusDorenaltoMarcelo
//
//  Created by user189149 on 1/6/21.
//  Copyright © 2021 FIAP. All rights reserved.
//

import UIKit
import CoreData

class ProductsTableViewController: UITableViewController {
    
    // MARK: - Properties
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Sua lista esta vazia!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    lazy var fetchedResultsController: NSFetchedResultsController<Product> = {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProducts()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Methods
    private func loadProducts(){
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count > 0 ? nil : label
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        let product = fetchedResultsController.object(at: indexPath)
        cell.configure(with: product)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let product  = fetchedResultsController.object(at: indexPath)
            context.delete(product)
            try? context.save()
        }
    }
}

extension ProductsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
