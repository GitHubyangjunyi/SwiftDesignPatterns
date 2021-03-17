//
//  ProductDecorators.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/3/17.
//

import Foundation

class PriceDecorator: Product {
    fileprivate let wrappedProduct: Product
    
    required init(name: String, description: String, category: String, price: Double, stockLevel: Int) {
        fatalError()
    }
    
    init(product: Product) {
        self.wrappedProduct = product
        super.init(name: product.name, description: product.description, category: product.category, price: product.price, stockLevel: product.stockLevel)
    }
}

class LowStockIncreaseDecorator: PriceDecorator {
    override var price: Double {
        var price = wrappedProduct.price
        if stockLevel <= 4 {
            price *= 1.5
        }
        return price
    }
}

class SoccerDecreaseDecorator: PriceDecorator {
    override var price: Double {
        return super.wrappedProduct.price * 0.5
    }
}
