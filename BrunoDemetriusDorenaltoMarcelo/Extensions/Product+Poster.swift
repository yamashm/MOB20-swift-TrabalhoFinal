//
//  Product+Poster.swift
//  BrunoDemetriusDorenaltoMarcelo
//
//  Created by user189149 on 1/11/21.
//  Copyright © 2021 FIAP. All rights reserved.
//

import Foundation
import UIKit

extension Product{
    var poster: UIImage? {
           if let data = image{
               return UIImage(data: data)
           }
           else{
               return nil
           }
       }
    var valueFormatted: String{
        "U$ " + String(format: "%.2f", value)
    }
}
