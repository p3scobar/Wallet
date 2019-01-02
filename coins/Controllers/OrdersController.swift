//
//  OrdersController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class OrdersController: UITableViewController {
    
    let tableCell = "tableCell"
    let transferCell = "transferCell"
    
    var transfers: [Transfer] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Orders"
        tableView.backgroundColor = Theme.lightbackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCell)
        tableView.register(TransferCell.self, forCellReuseIdentifier: transferCell)
        tableView.tableFooterView = UIView()
        fetchOrders()
    }

    
    func fetchOrders() {
        TransferService.getChargesFromDatabase(completion: { (transfers) in
            self.transfers = transfers
        })
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return transfers.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableCell, for: indexPath)
            cell.textLabel?.text = "New Order"
            cell.textLabel?.font = Theme.semibold(18)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: transferCell, for: indexPath) as! TransferCell
            cell.transfer = transfers[indexPath.row]
            return cell
        }
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
        if indexPath.section == 0 {
            newDeposit()
        } else {
            let transfer = transfers[indexPath.row]
            let vc = TransferController(transfer)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func newDeposit() {
//        let vc = NewOrderController(type: .buy, amount: 0, total: 0)
//        let nav = UINavigationController(rootViewController: vc)
//        self.present(nav, animated: true, completion: nil)
    }
    
}



