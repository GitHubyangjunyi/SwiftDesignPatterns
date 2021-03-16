//
//  ChangeRecord.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/3/16.
//

import Foundation

// 要被建造的对象
class ChangeRecord: CustomStringConvertible {
    
    private let outerTag: String
    private let innerTag: String
    private let productName: String
    private let category: String
    private let value: String
    
    fileprivate init(outer: String, name: String, category: String, inner: String, value: String) {
        self.outerTag = outer
        self.productName = name
        self.category = category
        self.innerTag = inner
        self.value = value
    }
    
    var description: String {
        return "<\(outerTag)><\(innerTag) name=\"\(productName)\"" + " category=\"\(category)\">\(value)</\(innerTag)></\(outerTag)>"
    }
    
}

// 建造者
class ChangeRecordBuilder {
    var outerTag: String
    var innerTag: String
    var productName: String?
    var category: String?
    var value: String?
    
    
    init() {
        outerTag = "change"
        innerTag = "product"
    }
    
    var changeRecord: ChangeRecord? {
        get {
            if productName != nil && category != nil && value != nil {
                return ChangeRecord(outer: outerTag, name: productName!, category: category!, inner: innerTag, value: value!)
            } else {
                return nil
            }
        }
    }
    
}

