//
//  PaymentController.swift
//  coins
//
//  Created by Hackr on 12/19/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit
import UIKit

class PaymentController: UITableViewController {
    
    var username = "" {
        didSet {
            tableView.reloadData()
        }
    }
    
    let cellId = "cellId"
    var payment: Payment!
    
    
    lazy var header: PaymentHeader = {
        let view = PaymentHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 180))
        view.payment = self.payment
        return view
    }()
    
    convenience init(payment: Payment) {
        self.init(style: .grouped)
        self.payment = payment
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = header
        view.backgroundColor = Theme.black
        tableView.backgroundColor = Theme.black
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(InputTextCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = Theme.border
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        self.navigationItem.title = "Transaction"
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func fetchUsername(payment: Payment) {
        if let pk = KeychainHelper.publicKey != payment.from ? payment.from : payment.to {
//            UserManager.fetchUserFromPublicKey(pk) { (user) in
//                guard let username = user?.username else { return }
//                self.username = username
//            }
        }
    }
    
    var isReceived: Bool {
//        return payment.paymentType == .receive
        return false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InputTextCell
        cell.valueInput.isEnabled = false
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Date"
            let date = payment.timestamp
            cell.valueInput.text = date?.medium()
        default:
            break
        }
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

