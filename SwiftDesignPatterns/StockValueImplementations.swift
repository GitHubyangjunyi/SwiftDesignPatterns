//
//  StockValueImplementations.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/3/17.
//

import Foundation

// 格式化器协议
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

// 汇率转换器协议
protocol StockValueConverter {
    func convertTotal(total: Double) -> Double
}

class DollarStockValueConverter: StockValueConverter {
    func convertTotal(total: Double) -> Double {
        return total
    }
}

class PoundStockValueConverter: StockValueConverter {
    func convertTotal(total: Double) -> Double {
        return total * 0.60338
    }
}

class StockTotalFactory {
    enum Currency {
        case USD
        case GBP
        
        // 适配EuroHandler
        case EUR
    }
    
    fileprivate(set) var formatter: StockValueFormatter?
    fileprivate(set) var converter: StockValueConverter?
    
    class func getFactory(curr: Currency) -> StockTotalFactory {
        switch curr {
        case .USD:
            return DollarStockTotalFactory.sharedInstance
        case .GBP:
            return PoundStockTotalFactory.sharedInstance
        case .EUR:
            return EuroHandlerAdapter.sharedInstance
        }
    }
    
}

private class DollarStockTotalFactory: StockTotalFactory {
    static let sharedInstance = DollarStockTotalFactory()
    
    private override init() {
        super.init()
        formatter = DollarStockValueFormatter()
        converter = DollarStockValueConverter()
    }
}

private class PoundStockTotalFactory: StockTotalFactory {
    static let sharedInstance = PoundStockTotalFactory()
    
    private override init() {
        super.init()
        formatter = PoundStockValueFormatter()
        converter = PoundStockValueConverter()
    }
}

class EuroHandlerAdapter: StockTotalFactory, StockValueConverter, StockValueFormatter {
    static let sharedInstance = EuroHandlerAdapter()
    private let handler: EuroHandler
    
    override init() {
        self.handler = EuroHandler()
        super.init()
        super.formatter = self
        super.converter = self
    }
    
    func formatTotal(total: Double) -> String {
        return handler.getDisplayString(amount: total)
    }
    
    func convertTotal(total: Double) -> Double {
        return handler.getCurrencyAmount(amount: total)
    }
    
}
