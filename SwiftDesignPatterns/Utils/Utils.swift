//
//  Utils.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/2/21.
//

import Foundation

class Utils {
    class func currencyStringFromNumber(number: Double) -> String {
        let formatter = NumberFormatter.init()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: number)) ?? ""
        
    }
}
