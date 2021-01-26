import Foundation

protocol SettingsFormViewModelDelegate: AnyObject {
    func onSucess()
    func onError(error: String)
}

class SettingsFormViewModel {
    private let service: CoreDataNetworking
    private var states: [State] = []
    weak var delegate: SettingsFormViewModelDelegate?

    var countStates: Int {
        states.count
    }

    init(service: CoreDataNetworking = CoreDataNetwork()) {
        self.service = service
    }

    func getState(at index: Int) -> State {
        states[index]
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

    func deleteState(at index: Int) {
        let state = getState(at: index)

        service.deleteState(state) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(_):
                self.loadStates()
            case . failure(let error):
                self.delegate?.onError(error: error.localizedDescription)
            }
        }
    }
}
