import Foundation

protocol ProductFormViewModelDelegate: AnyObject {
    func onSucess()
    func onError(error: String)
}

class ProductFormViewModel {
    private var states: [State] = []
    private let service: CoreDataNetworking
    var product: Product?

    weak var delegate: ProductFormViewModelDelegate?

    var countStates: Int {
        states.count
    }

    init(service: CoreDataNetworking = CoreDataNetwork(), product: Product?) {
        self.service = service
        self.product = product
    }

    func initProduct() {
        self.product = Product(context: service.getContext())
    }

    func getState(at index: Int) -> State {
        states[index]
    }
    
    func stateExists(state: State) -> Bool {
        return states.contains(state)
    }

    func loadStates() {
        service.getAllStates { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let states):
                self.states = states
            case .failure(let error):
                self.delegate?.onError(error: error.localizedDescription)
            }
        }
    }

    func saveProduct() {
        guard let prod = self.product else {
            self.delegate?.onError(error: "Erro ao salvar produto!!")
            return
        }

        service.saveProduct(prod) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(_):
                self.delegate?.onSucess()
            case .failure(let error):
                self.delegate?.onError(error: error.localizedDescription)
            }
        }
    }
}
