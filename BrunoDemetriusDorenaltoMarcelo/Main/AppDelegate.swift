//
//  AppDelegate.swift
//  BrunoDemetriusDorenaltoMarcelo
//
//  Created by user189149 on 1/6/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BrunoDemetriusDorenaltoMarcelo")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print(error)
            }
        }
        return container
    }()
}

