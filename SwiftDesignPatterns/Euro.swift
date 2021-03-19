//
//  Euro.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/3/19.
//

import Foundation

class EuroHandler {
    func getDisplayString(amount: Double) -> String {
        let formatted = Utils.currencyStringFromNumber(number: amount)
        return "@\(formatted.dropFirst())"
    }
    
    func getCurrencyAmount(amount: Double) -> Double {
        return 0.76164 * amount
    }
}
