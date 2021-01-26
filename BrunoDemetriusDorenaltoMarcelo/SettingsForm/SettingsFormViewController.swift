import UIKit
import CoreData

class SettingsFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        viewModel.loadStates()
    }

    @IBAction func xrateChanged(_ sender: UITextField) {
        ud.set(sender.text!, forKey: "xrate")
        sender.resignFirstResponder()
    }

    @IBAction func operationTaxChanged(_ sender: UITextField) {
        ud.set(sender.text!, forKey: "operationtax")
        sender.resignFirstResponder()
    }

    // MARK: - Methods
    private func showStateAlert(for state: State? = nil){
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
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?[0].text

            if let alertTextFieldsContent = alert.textFields {
                if let textContent = alertTextFieldsContent[1].text{
                    if let doubleContent = Double(textContent) {
                        state.tax = doubleContent
                    }
                }
            }

            do {
                try self.context.save()
                self.viewModel.loadStates()
            } catch {
                print(error)
            }
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
//            self.states.remove(at: indexPath.row)
            self.tableViewStateTax.deleteRows(at: [indexPath], with: .automatic)

            completionHandler(true)
        }

        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showStateAlert(for: viewModel.getState(at: indexPath.row))
    }
}

extension SettingsFormViewController: SettingsFormViewModelDelegate {
    func onSucess() {
        
    }

    func onError(error: String) {
        
    }
}
