import UIKit

class ProductsTableViewController: UITableViewController {
    
    // MARK: - Properties
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()

    let viewModel: ProductListViewModel = ProductListViewModel()

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadProducts()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ProductFormViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
        vc.viewModel.product = viewModel.getProduct(at: indexPath.row)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.count == 0 {
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }

        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }

        let product = viewModel.getProduct(at: indexPath.row)
        cell.configure(with: product)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteProduct(at: indexPath.row)
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ProductsTableViewController: ProductListViewModelDelegate {
    func onSucess() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func onError(error: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Error", message: error)
        }
    }
}
