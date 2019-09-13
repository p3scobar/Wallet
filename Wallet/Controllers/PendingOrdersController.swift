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
    
    var orders: [ExchangeOrder] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(OrderBookCell.self, forCellReuseIdentifier: orderCell)
        tableView.tableFooterView = UIView()
        title = "Pending"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getOffers()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: orderCell, for: indexPath) as! OrderBookCell
        let order = orders[indexPath.row]
        setupCell(order: order, cell: cell)
        return cell
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
        return 60
    }
    
    func getOffers() {
        OrderService.getOffers { (offers) in
            self.orders = offers
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let order = orders[indexPath.row]
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
    
}


