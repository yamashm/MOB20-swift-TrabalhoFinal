import Foundation
import UIKit
import CoreData

protocol ProductListViewModelDelegate: AnyObject {
    func onSucess()
    func onError(error: String)
}

class ProductListViewModel {
    private var products: [Product] = []
    private let service: CoreDataNetworking
    weak var delegate: ProductListViewModelDelegate?

    var count: Int {
        products.count
    }

    init(service: CoreDataNetworking = CoreDataNetwork()) {
        self.service = service
    }

    func getProduct(at index: Int) -> Product {
        return products[index]
    }

    func loadProducts() {
        service.getAllProducts { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let products):
                self.products = products
                self.delegate?.onSucess()
            case .failure(let error):
                self.delegate?.onError(error: error.localizedDescription)
            }
        }
    }

    func deleteProduct(at index: Int) {
        let product = getProduct(at: index)

        service.deleteProduct(product) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(_):
                self.delegate?.onSucess()
            case . failure(let error):
                self.delegate?.onError(error: error.localizedDescription)
            }
        }
    }
}
