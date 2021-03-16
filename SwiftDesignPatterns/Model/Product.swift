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
    fileprivate var salesTaxRate: Double = 0.2
    
    private(set) var price: Double {
        get { priceBackingValue }
        set { priceBackingValue = max(1, newValue) }
    }
    
    var stockLevel: Int {
        get { stockLevelBackingValue }
        set { stockLevelBackingValue = max(0, newValue) }
    }
    
    var stockValue: Double {
        get { (price * (1 + salesTaxRate)) * Double(stockLevel) }
    }
    
    var upsells: [UpsellPooortunities] {
        return Array()
    }
    
    // 顾客可能感兴趣的产品
    enum UpsellPooortunities {
        case SwimmingLessons
        case MapOfLakes
        case SoccerVideos
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
        salesTaxRate = 0.1
    }
    
    override var upsells: [Product.UpsellPooortunities] {
        return [.SwimmingLessons, .MapOfLakes]
    }
}

class SoccerProduct: Product {
    required init(name: String, description: String, category: String, price: Double, stockLevel: Int) {
        super.init(name: name, description: description, category: category, price: price, stockLevel: stockLevel)
        salesTaxRate = 0.25
    }
    
    override var upsells: [Product.UpsellPooortunities] {
        return [.SoccerVideos]
    }
}
