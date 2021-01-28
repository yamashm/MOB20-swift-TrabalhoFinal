import UIKit
import CoreData

final class SettingsFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet weak var textFieldXRate: UITextField!
    @IBOutlet weak var buttonAddState: UIButton!
    @IBOutlet weak var textFieldOperationTax: UITextField!
    @IBOutlet weak var tableViewStateTax: UITableView!

    // MARK: - Properties
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Lista de estados vazia."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()

    let viewModel = SettingsFormViewModel()

    private let ud = UserDefaults.standard

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        tableViewStateTax.delegate = self
        tableViewStateTax.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadStates()
        setupView()
    }

    // MARK: - IBActions
    @IBAction func addState(_ sender: UIButton) {
        showStateAlert()
    }

    @IBAction func xrateChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }

        ud.set(text, forKey: "xrate")
    }

    @IBAction func operationTaxChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }

        ud.set(text, forKey: "operationtax")
    }

    // MARK: - Methods
    private func showStateAlert(for state: State? = nil) {
        let title = state == nil ? "Adicionar Estado" : "Editar Estado"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Nome da estado"
            textField.text = state?.name
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Imposto"
            textField.keyboardType = UIKeyboardType.numbersAndPunctuation

            if let stateContent = state {
                textField.text = String(format: "%.1f", stateContent.tax)
            } else {
                textField.text = ""
            }
        }

        let okAction = UIAlertAction(title: "Adicionar", style: .default) { (_) in
            self.viewModel.initState()

            self.viewModel.state?.name = alert.textFields?[0].text

            if let alertTextFieldsContent = alert.textFields {
                if let textContent = alertTextFieldsContent[1].text {
                    if let doubleContent = Double(textContent) {
                        self.viewModel.state?.tax = doubleContent
                    }
                }
            }

            self.viewModel.saveState()
        }

        alert.addAction(okAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    private func setupView(){
        let xrate = ud.string(forKey: "xrate")
        textFieldXRate.text = xrate

        let operationtax = ud.string(forKey: "operationtax")
        textFieldOperationTax.text = operationtax
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.countStates
        tableViewStateTax.backgroundView = count > 0 ? nil : label
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewStateTax.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let state = viewModel.getState(at: indexPath.row)

        cell.detailTextLabel?.text = String(format: "%.1f", state.tax)
        cell.textLabel?.text = state.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.viewModel.deleteState(at: indexPath.row)
            self.tableViewStateTax.deleteRows(at: [indexPath], with: .automatic)

            completionHandler(true)
        }

        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showStateAlert(for: viewModel.getState(at: indexPath.row))
    }

    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SettingsFormViewController: SettingsFormViewModelDelegate {
    func onSucess() {
        DispatchQueue.main.async {
            self.tableViewStateTax.reloadData()
        }
    }

    func onError(error: String) {
        DispatchQueue.main.async {
            self.showErrorAlert(title: "Alerta!", message: error)
        }
    }
}
