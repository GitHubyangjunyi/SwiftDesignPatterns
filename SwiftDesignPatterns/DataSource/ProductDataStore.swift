//
//  ProductDataStore.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/3/5.
//

import Foundation

final class ProductDataStore {
    var callBack: ((Product) -> Void)?
    private var networkQ: DispatchQueue
    private var uiQ: DispatchQueue
    lazy var products: [Product] = loadData()
    
    init() {
        networkQ = DispatchQueue.global(qos: .background)
        uiQ = DispatchQueue.main
    }
    
    func loadData() -> [Product] {
        for p in productData {
            networkQ.async { [self] in
                let stockConn = NetworkPool.getConnection()
                let level = stockConn.getStockLevel(name: p.name)
                if level != nil {
                    p.stockLevel = level!
                    uiQ.async {
                        // 可选回调用于告知其他组件信息更新
                        if callBack != nil {
                            callBack!(p)
                        }
                    }
                }
                NetworkPool.returnConnection(conn: stockConn)
            }
        }
        return productData
    }
    
    private var productData = [
        Product.init(name: "Kayak", description: "A boat for one person", category: "Watersports", price: 275.0, stockLevel: 0),
        Product.init(name: "Lifejacket", description: "Protective and fashionable", category: "Watersports", price: 48.95, stockLevel: 0),
        Product.init(name: "Soccer Ball", description: "FIFA-approved size and weight", category: "Soccer", price: 19.5, stockLevel: 0),
        Product.init(name: "Corner Flags", description: "Give you playing field a professional touch", category: "Soccer", price: 34.95, stockLevel: 0),
        Product.init(name: "Stadium", description: "Flat-packed 35,000-seat stadium", category: "Soccer", price: 79500.0, stockLevel: 0),
        Product.init(name: "Thinking Cap", description: "Improve your brain efficiency by 75%", category: "Chess", price: 16.0, stockLevel: 0),
        Product.init(name: "Unsteady Chair", description: "Secretly give your opponent a disadvantage", category: "Chess", price: 29.95, stockLevel: 0),
        Product.init(name: "Human Chess Board", description: "A fun game for the family", category: "Chess", price: 75.0, stockLevel: 0),
        Product.init(name: "Bling-Bling King", description: "Gold-plated, diamond-studded King", category: "Chess", price: 1200.0, stockLevel: 0)
        ]
    
}



