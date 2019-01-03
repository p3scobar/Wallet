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
        view.backgroundColor = Theme.black
        tableView.backgroundColor = Theme.black
        tableView.separatorColor = Theme.border
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
            cell.textLabel?.text = "Buy \(order.size) \(buyingAssetCode) @ \(price.currency())"
        } else {
            cell.textLabel?.text = "Sell \(order.size) \(sellingAssetCode) @ \(price.currency())"
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
        let order = orders[indexPath.row]
        cancelOrder(order)
    }
    
    func cancelOrder(_ order: ExchangeOrder) {
        guard let sell = order.sell,
            let buy = order.buy else { return }
        
        let id = UInt64(order.id ?? 0)
        
        OrderService.cancelOffer(offerID: id, sell: sell, buy: buy) { (success) in
            if success == true {
                self.getOffers()
            }
        }
    }
    
}


