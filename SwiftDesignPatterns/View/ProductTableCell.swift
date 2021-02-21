//
//  ProductTableCell.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/2/20.
//

import UIKit

class ProductTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stockStepper: UIStepper!
    @IBOutlet weak var stockField: UITextField!
    
    var product: Product?
    
}
