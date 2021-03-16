//
//  Logger.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/2/23.
//

import Foundation

let logger = Logger<Product> { (product) in
    var builder = ChangeRecordBuilder()
    builder.productName = product.name
    builder.category = product.category
    builder.value = String(product.stockLevel)
    builder.outerTag = "stockChange"
    var changeRecord = builder.changeRecord
    
    if changeRecord != nil {
        print(builder.changeRecord!)
    }
}

final class Logger<T> where T: NSObject, T: NSCopying {
    
    var dataItems: [T] = []
    var callback: (T) -> Void
    
    // 单例对象需要自己确保操作安全
    private var arrayQ = DispatchQueue.init(label: "arrayQ", attributes: [.concurrent])
    private var callbackQ = DispatchQueue.init(label: "callBackQ")
    
    fileprivate init(callback: @escaping (T) -> Void, protect:Bool = true) {
        self.callback = callback
        // 如果需要并发保护callback就重新设置callback的执行环境
        if protect {
            self.callback = { item in
                self.callbackQ.sync(execute: {
                    callback(item)
                })
            }
        }
    }
    
    func logItem(item: T) {
        // 当某个barrier block队列到达最前端时将会等待前面所有正在进行的读取操作完成
        // 读取操作完成后才会进行写操作并且在写操作完成之前不会处理任何后续的blcok
        arrayQ.async(group: nil, qos: .default, flags: [.barrier], execute: {() in
            self.dataItems.append(item.copy() as! T)
            self.callback(item)
        })
    }
    
    func processItems(callBack: (T) -> Void) {
        arrayQ.sync {
            for item in dataItems {
                callBack(item)
            }
        }
    }
    
}

