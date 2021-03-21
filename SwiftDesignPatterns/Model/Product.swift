//
//  Product.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/2/21.
//

import Foundation

class Product: NSObject, NSCopying {
    
    private(set) var name: String
    private(set) var productDescription: String
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
        get { price  * Double(stockLevel) }
    }
    
    required init(name: String, description: String, category: String, price: Double, stockLevel: Int) {
        self.name = name
        self.productDescription = description
        self.category = category
        
        // 子类调用父类初始化器的时机是存储属性赋值完成但计算属性使用之前
        super.init()
        
        self.price = price
        self.stockLevel = stockLevel
    }
    
    class func createProduct(name: String, description: String, category: String, price: Double, stockLevel: Int) -> Product {
        var productType: Product.Type
        
        switch category {
        case "Watersports":
            productType = WatersportsProduct.self
        case "Soccer":
            productType = SoccerProduct.self
        default:
            productType = Product.self
        }
        return productType.init(name: name, description: description, category: category, price: price, stockLevel: stockLevel)
    }
    
    // MARK: --NSCopying克隆协议
    func copy(with zone: NSZone? = nil) -> Any {
        return Product(name: self.name, description: self.productDescription, category: self.category, price: self.price, stockLevel: self.stockLevel)
    }
    
}

class WatersportsProduct: Product {
    required init(name: String, description: String, category: String, price: Double, stockLevel: Int) {
        super.init(name: name, description: description, category: category, price: price, stockLevel: stockLevel)
    }
    
}

class SoccerProduct: Product {
    required init(name: String, description: String, category: String, price: Double, stockLevel: Int) {
        super.init(name: name, description: description, category: category, price: price, stockLevel: stockLevel)
    }
    
}

class ProductComposite: Product {
    private let products: [Product]
    
    required init(name: String, description: String, category: String, price: Double, stockLevel: Int) {
        fatalError()
    }
    
    init(name: String, description: String, category: String, stockLevel: Int, products: Product...) {
        self.products = products
        super.init(name: name, description: description, category: category, price: 0, stockLevel: stockLevel)
    }
    
    override var price: Double {
        return products.reduce(0) { (total, p) -> Double in
           total +  p.price
        }
    }
}
