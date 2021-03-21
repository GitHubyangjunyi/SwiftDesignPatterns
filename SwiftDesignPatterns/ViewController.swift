//
//  ViewController.swift
//  SwiftDesignPatterns
//
//  Created by 杨俊艺 on 2021/2/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalStockLabel: UILabel!
    
    var productStore = ProductDataStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        displayStockTotal()
        
        let bridge = EventBridge(callback: updateStockLevel(name:level:))
        
        productStore.callBack = bridge.inputCallback
    }
    
    func updateStockLevel(name: String, level: Int) {
        for cell in tableView.visibleCells {
            if let pcell = cell as? ProductTableCell {
                if pcell.product?.name == name {
                    pcell.stockStepper.value = Double(level)
                    pcell.stockField.text = String(level)
                }
            }
        }
        displayStockTotal()
    }

    func displayStockTotal() {
        let finalTotals = productStore.products.reduce((0, 0.0)) { (result, item) -> (Int, Double) in
            (result.0 + item.stockLevel, result.1 + item.stockValue)
        }
        
        //let factory = StockTotalFactory.getFactory(curr: .GBP)
        //let totalAmount = factory.converter?.convertTotal(total: finalTotals.1)
        //let formatted = factory.formatter?.formatTotal(total: totalAmount!)
        let formatted = StockTotalFacade.formatCurrencyAmount(amount: finalTotals.1, currency: .EUR)
        
        totalStockLabel.text = "\(finalTotals.0) Products in Stock | Total Value: \(String(describing: formatted)))"
    }
    
    @IBAction func stockLevelDidChange(_ sender: Any) {
        if var currentCell = sender as? UIView {
            while true {
                currentCell = currentCell.superview!
                if let cell = currentCell as? ProductTableCell {
                    if let product = cell.product {
                        if let stepper = sender as? UIStepper {
                            product.stockLevel = Int(stepper.value)
                        } else if let textfield = sender as? UITextField{
                            if let newValue = Int(textfield.text ?? "") {
                                product.stockLevel = newValue
                            }
                        }
                        cell.stockStepper.value = Double(product.stockLevel)
                        cell.stockField.text = String(product.stockLevel)
                        logger.logItem(item: product)
                    }
                    break
                }
            }
            displayStockTotal()
        }
    }
    
    // MARK: - 模型数据
    var products = [
        Product.init(name: "Kayak", description: "A boat for one person", category: "Watersports", price: 275.0, stockLevel: 10),
        Product.init(name: "Lifejacket", description: "Protective and fashionable", category: "Watersports", price: 48.95, stockLevel: 14),
        Product.init(name: "Soccer Ball", description: "FIFA-approved size and weight", category: "Soccer", price: 19.5, stockLevel: 32),
    Product.init(name: "Corner Flags", description: "Give you playing field a professional touch", category: "Soccer", price: 34.95, stockLevel: 1),
    Product.init(name: "Stadium", description: "Flat-packed 35,000-seat stadium", category: "Soccer", price: 79500.0, stockLevel: 4),
    Product.init(name: "Thinking Cap", description: "Improve your brain efficiency by 75%", category: "Chess", price: 16.0, stockLevel: 8),
    Product.init(name: "Unsteady Chair", description: "Secretly give your opponent a disadvantage", category: "Chess", price: 29.95, stockLevel: 3),
        Product.init(name: "Human Chess Board", description: "A fun game for the family", category: "Chess", price: 75.0, stockLevel: 2),
        Product.init(name: "Bling-Bling King", description: "Gold-plated, diamond-studded King", category: "Chess", price: 1200.0, stockLevel: 4)
        ]
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productStore.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductTableCell
        let product = productStore.products[indexPath.row]
        cell.product = product
        cell.nameLabel.text = product.name
        cell.descriptionLabel.text = product.productDescription
        cell.stockStepper.value = Double(product.stockLevel)
        cell.stockField.text = String(product.stockLevel)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// 用来分离事件的来源与事件的去向
class EventBridge {
    private let outputCallback: (String, Int) -> Void
    
    init(callback: @escaping (String, Int) -> Void) {
        self.outputCallback = callback
    }
    
    var inputCallback: (Product) -> Void {
        return { p in
            self.outputCallback(p.name, p.stockLevel)
        }
    }
    
}
