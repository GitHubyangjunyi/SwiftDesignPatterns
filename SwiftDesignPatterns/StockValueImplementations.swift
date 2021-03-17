//
//  StockValueImplementations.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/3/17.
//

import Foundation

protocol StockValueFormatter {
    func formatTotal(total: Double) -> String
}

class DollarStockValueFormatter: StockValueFormatter {
    func formatTotal(total: Double) -> String {
        let formatted = Utils.currencyStringFromNumber(number: total)
        return formatted
    }
}

class PoundStockValueFormatter: StockValueFormatter {
    func formatTotal(total: Double) -> String {
        let formatted = Utils.currencyStringFromNumber(number: total)
        return "#\(formatted.dropFirst())"
    }
}

protocol StockValueConverter {
    func convertTotal(total: Double) -> Double
}

class DollarStockValueConverter: StockValueConverter {
    func convertTotal(total: Double) -> Double {
        return total
    }
}


