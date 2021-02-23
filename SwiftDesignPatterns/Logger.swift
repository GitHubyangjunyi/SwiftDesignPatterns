//
//  Logger.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/2/23.
//

import Foundation

class Logger<T> where T: NSObject, T: NSCopying {
    
    var dataItems: [T] = []
    var callBack: (T) -> Void
    
    init(callBack: @escaping (T) -> Void) {
        self.callBack = callBack
    }
    
    func logItem(item: T) {
        dataItems.append(item.copy() as! T)
        callBack(item)
    }
    
    func processItems(callBack: (T) -> Void) {
        for item in dataItems {
            callBack(item)
        }
    }
    
}











