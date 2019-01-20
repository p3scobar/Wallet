//
//  PaymentsController.swift
//  Wallet
//
//  Created by Hackr on 1/8/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit

class PaymentsController: UITableViewController {
    
    let paymentCell = "paymentCell"
    
    var payments: [Payment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        tableView.backgroundColor = Theme.white
        tableView.register(PaymentCell.self, forCellReuseIdentifier: paymentCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPayments()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchPayments() {
        payments = Payment.fetchAll()
        WalletService.fetchPayments { (payments) in
            self.payments = payments
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: paymentCell, for: indexPath) as! PaymentCell
        cell.payment = payments[indexPath.row]
        return cell
    }
    
    
}
