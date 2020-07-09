//
//  OrdersController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class TradesController: UITableViewController {
    
    let tradeCell = "tradeCell"
    let transferCell = "transferCell"
    
    var trades: [Trade] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Orders"
        tableView.backgroundColor = Theme.background
        tableView.register(TradeCell.self, forCellReuseIdentifier: tradeCell)
        tableView.register(TransferCell.self, forCellReuseIdentifier: transferCell)
        tableView.tableFooterView = UIView()
        fetchOrders()
    }

    
    func fetchOrders() {
        WalletService.getTrades { (trades) in
            self.trades = trades
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return trades.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: transferCell, for: indexPath) as! TradeCell
            cell.trade = trades[indexPath.row]
            return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 64
        } else {
            return 90
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let trade = trades[indexPath.row]
        let vc = TradeController(trade)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



