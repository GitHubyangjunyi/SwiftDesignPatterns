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
        get { price * Double(stockLevel) }
    }
    
    init(name: String, description: String, category: String, price: Double, stockLevel: Int) {
        self.name = name
        self.productDescription = description
        self.category = category
        
        // 子类调用父类初始化器的时机是存储属性赋值完成但计算属性使用之前
        super.init()
        
        self.price = price
        self.stockLevel = stockLevel
        
    }
    
    // MARK: --NSCopying克隆协议
    func copy(with zone: NSZone? = nil) -> Any {
        return Product(name: self.name, description: self.productDescription, category: self.category, price: self.price, stockLevel: self.stockLevel)
    }
    
}

// 解耦实现复制对象的过程和定义对象类的过程意味着修改Product类的初始化器/创建子类和使用子类无需在Logger类中做出相应的修改
