//
//  PendingOrdersController.swift
//  coins
//
//  Created by Hackr on 1/2/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk

class PendingOrdersController: UITableViewController {
    
    let orderCell = "orderCell"
    let tradeCell = "tradeCell"
    
    var orders: [ExchangeOrder] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var trades: [Trade] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(OrderBookCell.self, forCellReuseIdentifier: orderCell)
        tableView.register(TradeCell.self, forCellReuseIdentifier: tradeCell)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Theme.background
        extendedLayoutIncludesOpaqueBars = true
        title = "Orders"
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrders()
        getOffers()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return orders.count
        case 1:
            return trades.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: orderCell, for: indexPath) as! OrderBookCell
            let order = orders[indexPath.row]
            setupCell(order: order, cell: cell)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: tradeCell, for: indexPath) as! TradeCell
            cell.trade = trades[indexPath.row]
            return cell
        }
        
    }
    
    func setupCell(order: ExchangeOrder, cell: OrderBookCell) {
        let sellingAssetCode = order.sell?.assetCode ?? ""
        let buyingAssetCode = order.buy?.assetCode ?? ""
        let price = order.price
        
        if order.side == .buy {
            cell.textLabel?.text = "Buy \(order.size) \(buyingAssetCode) @ \(price.currency(2))"
        } else {
            cell.textLabel?.text = "Sell \(order.size) \(sellingAssetCode) @ \(price.currency(2))"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 64
        default:
            return 80
        }
    }
    
    func getOffers() {
        OrderService.getOffers { (offers) in
            self.orders = offers
            print("\(offers.count) OFFERS")
        }
    }
    
    
    func getOrders() {
        WalletService.getTrades { (trades) in
            self.trades = trades
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            break
        case 1:
            let trade = trades[indexPath.row]
            pushTradeController(trade)
        default:
            break
        }
    }
    
    func pushTradeController(_ trade: Trade) {
        let vc = TradeController(trade)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cancelOrder(_ order: ExchangeOrder) {
        guard let sell = order.sell,
            let buy = order.buy else { return }
        
        let id = Int64(order.id ?? 0)
        
        OrderService.cancelOffer(offerID: id, sell: sell, buy: buy) { (success) in
            if success == true {
                self.getOffers()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return true
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        presentCancelOrderConfirmation(order)
    }
    
    func presentCancelOrderConfirmation(_ order: ExchangeOrder) {
        let alert = UIAlertController(title: "Cancel Order", message: nil, preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.cancelOrder(order)
        }
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pending"
        default:
            return "Completed"
        }
    }
    
}


