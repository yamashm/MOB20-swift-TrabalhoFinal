//
//  ProductTableViewCell.swift
//  BrunoDemetriusDorenaltoMarcelo
//
//  Created by user189149 on 1/6/21.
//  Copyright © 2021 FIAP. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    
    // MARK: - Methods
    func configure(with product: Product){
        imageViewPoster.image = product.poster
        labelPrice.text = product.valueFormatted
        labelName.text = product.name
    }

}
