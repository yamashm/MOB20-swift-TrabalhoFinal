import Foundation
import UIKit
import CoreData

protocol CoreDataNetworking {
    func getContext() -> NSManagedObjectContext
    func getAllProducts(_ completion: @escaping (Result<[Product], Error>) -> Void)
    func saveProduct(_ product: Product, _ completion: @escaping (Result<String, Error>) -> Void)
    func deleteProduct(_ product: Product, _ completion: @escaping (Result<String, Error>) -> Void)
    func getAllStates(_ completion: @escaping (Result<[State], Error>) -> Void)
    func deleteState(_ state: State, _ completion: @escaping (Result<String, Error>) -> Void)
}

class CoreDataNetwork: CoreDataNetworking {
    func getContext() -> NSManagedObjectContext {
        context
    }

    private var context: NSManagedObjectContext {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            return context
        }

        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }

    // MARK: - Products
    private let fetchProductRequest: NSFetchRequest<Product> = Product.fetchRequest()

    func getAllProducts(_ completion: @escaping (Result<[Product], Error>) -> Void) {
        do {
            let products = try context.fetch(fetchProductRequest)
            completion(.success(products))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }

    func saveProduct(_ product: Product, _ completion: @escaping (Result<String, Error>) -> Void) {
        do {
            context.insert(product)
            try context.save()
            completion(.success("Objeto Salvo!!"))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deleteProduct(_ product: Product, _ completion: @escaping (Result<String, Error>) -> Void) {
        do {
            context.delete(product)
            try context.save()
            completion(.success("Excluído com sucesso!"))
        } catch let error {
            completion(.failure(error))
        }
    }

    // MARK: - State
    private let fetchStateRequest: NSFetchRequest<State> = State.fetchRequest()

    func getAllStates(_ completion: @escaping (Result<[State], Error>) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchStateRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let states = try context.fetch(fetchStateRequest)
            completion(.success(states))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deleteState(_ state: State, _ completion: @escaping (Result<String, Error>) -> Void) {
        do {
            context.delete(state)
            try context.save()
            completion(.success("Excluído com sucesso!"))
        } catch let error {
            completion(.failure(error))
        }
    }
}
