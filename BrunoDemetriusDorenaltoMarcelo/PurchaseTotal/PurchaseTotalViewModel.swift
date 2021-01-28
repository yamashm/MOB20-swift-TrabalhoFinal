import Foundation

protocol PurchaseTotalViewModelDelegate: AnyObject {
    func onSucess()
    func onError(error: String)
}

class PurchaseTotalViewModel {
    private let service: CoreDataNetworking
    private var products: [Product] = []

    weak var delegate: PurchaseTotalViewModelDelegate?

    init(service: CoreDataNetworking = CoreDataNetwork()) {
        self.service = service
    }

    func totalValue() -> (String, String) {
        var totalUSD: Double = 0
        var totalBRL: Double = 0

        let ud = UserDefaults.standard
        guard let xrate = ud.string(forKey: "xrate") else {
            return ("", "")
        }

        guard let operationtax = ud.string(forKey: "operationtax") else {
            return ("", "")
        }

        let xrateValue = Double(xrate) ?? 0
        let operationtaxValue = Double(operationtax) ?? 0

        for p in products {
            let valueUSD = p.value * (1 + (p.state?.tax ?? 0)/100)
            totalUSD += valueUSD

            if p.card {
                totalBRL += (valueUSD * xrateValue) * (1 + operationtaxValue/100)
            } else {
                totalBRL += (valueUSD * xrateValue)
            }
        }

        return (String(format: "%.2f", totalUSD), String(format: "%.2f", totalBRL))
    }

    func loadProducts() {
        service.getAllProducts { result in
            switch result {
            case .success(let products):
                self.products = products
                self.delegate?.onSucess()
            case .failure(let error):
                self.delegate?.onError(error: error.localizedDescription)
            }
        }
    }
}
