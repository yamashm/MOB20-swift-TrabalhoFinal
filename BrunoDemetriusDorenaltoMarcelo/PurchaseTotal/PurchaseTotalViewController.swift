import UIKit
import CoreData

final class PurchaseTotalViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var labelTotalUSD: UILabel!
    @IBOutlet weak var labelTotalBRL: UILabel!

    // MARK: - Properties
    let viewModel = PurchaseTotalViewModel()

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadProducts()
    }
}

extension PurchaseTotalViewController: PurchaseTotalViewModelDelegate {
    func onSucess() {
        let totals = viewModel.totalValue()

        labelTotalUSD.text = totals.0
        labelTotalBRL.text = totals.1
    }

    func onError(error: String) {
        
    }
}
