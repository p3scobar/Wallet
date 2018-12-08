//
//  OrdersController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class BankingController: UITableViewController {
    
    let tableCell = "tableCell"
    let orderCell = "orderCell"
    
    var charges: [Charge] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Banking"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCell)
        tableView.register(PaymentCell.self, forCellReuseIdentifier: orderCell)
        tableView.tableFooterView = UIView()
    }

    
    func fetchOrders() {
        charges = Model.shared.charges
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchOrders()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return charges.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableCell, for: indexPath)
            cell.textLabel?.text = "New Deposit"
            cell.textLabel?.font = Theme.semibold(18)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: orderCell, for: indexPath) as! PaymentCell
            cell.charge = charges[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            newDeposit()
        } else {
            let charge = charges[indexPath.row]
            let vc = DepositController(withID: charge.id, amount: charge.amount, address: charge.address)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func newDeposit() {
        let vc = AmountController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}



