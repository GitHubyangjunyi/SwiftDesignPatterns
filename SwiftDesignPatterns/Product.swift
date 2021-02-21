//
//  Product.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/2/21.
//

import Foundation

class Product {
    private(set) var name: String
    private(set) var description: String
    private(set) var category: String
    
    private var stockLevelBackingValue = 0
    private var priceBackingValue = 0.0
    
    private(set) var price: Double {
        get { priceBackingValue }
        set { priceBackingValue = max(1, newValue) }
    }
    
    var stockLevel: Int {
        get { stockLevelBackingValue }
        set { stockLevelBackingValue = max(0, newValue) }
    }
    
    var stockValue: Double {
        get { price * Double(stockLevel) }
    }
    
    init(name: String, description: String, category: String, price: Double, stockLevel: Int) {
        self.name = name
        self.description = description
        self.category = category
        self.price = price
        self.stockLevel = stockLevel
    }
    
}

