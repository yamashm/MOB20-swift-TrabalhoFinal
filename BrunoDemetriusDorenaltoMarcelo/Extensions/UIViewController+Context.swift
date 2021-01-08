//
//  UIViewController+Context.swift
//  BrunoDemetriusDorenaltoMarcelo
//
//  Created by user189149 on 1/7/21.
//  Copyright © 2021 FIAP. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController{
    var context: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
