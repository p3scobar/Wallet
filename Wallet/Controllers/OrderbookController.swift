//
//  OrderbookController.swift
//  coins
//
//  Created by Hackr on 1/2/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk

class OrderbookController: UITableViewController {
    
    let orderCell = "orderCell"
    
    var token: Token
    
    init(_ token: Token) {
        self.token = token
        super.init(style: .grouped)
        title = "\(token.assetCode)/\(baseAsset.assetCode)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var asks: [ExchangeOrder] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var bids: [ExchangeOrder] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getOrderBook()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.white
        tableView.backgroundColor = Theme.white
        tableView.separatorColor = Theme.border
        tableView.register(OrderBookCell.self, forCellReuseIdentifier: orderCell)
        title = "Order Book"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Orders", style: .done, target: self, action: #selector(pushOrdersController))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return asks.count
        } else {
            return bids.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: orderCell, for: indexPath) as! OrderBookCell
        if indexPath.section == 0 {
            cell.offer = asks[indexPath.row]
        } else {
            cell.offer = bids[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func getOrderBook() {
        OrderService.getOrderBook(buy: Token.USD, sell: token, limit: 40) { (asks, bids) in
            self.asks = asks
            self.bids = bids
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var order: ExchangeOrder
        if indexPath.section == 0 {
            order = asks[indexPath.row]
            presentOrderVC(order: order, side: .buy)
        } else {
            order = bids[indexPath.row]
            presentOrderVC(order: order, side: .sell)
        }
    }
    
    func presentOrderVC(order: ExchangeOrder, side: TransactionType) {
        let vc = OrderController(token: token, side: side, size: order.size, price: order.price)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Asks"
        default:
            return "Bids"
        }
    }
    
    @objc func pushOrdersController() {
        let vc = PendingOrdersController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


