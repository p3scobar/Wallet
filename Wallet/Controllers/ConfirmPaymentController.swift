//
//  ConfirmPaymentController.swift
//  coins
//
//  Created by Hackr on 1/6/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit

class ConfirmPaymentController: UITableViewController {
    
    let cellID = "cellID"
    
    var token: Token
    var publicKey: String
    var amount: Decimal
    var submitted = false
    var username: String?
    var user: User?
    var currency: Decimal
    
    init(user: User?, token: Token, amount: Decimal, currency: Decimal) {
        self.token = token
        self.publicKey = user?.publicKey ?? ""
        self.amount = amount
        self.username = user?.username ?? ""
        self.user = user
        self.currency = currency
        super.init(style: .plain)
    }
    
    init(token: Token, publicKey: String, amount: Decimal, username: String?) {
        self.token = token
        self.publicKey = publicKey
        self.amount = amount
        self.username = username
        self.currency = 0
        super.init(style: .plain)
        fetchUser(publicKey)
    }
    
    func fetchUser(_ publicKey: String) {
        UserService.getUserFor(publicKey: publicKey) { (user) in
            self.user = user
            self.header.user = user
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.white
        tableView.tableHeaderView = header
        tableView.separatorColor = Theme.border
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InputCurrencyCell.self, forCellReuseIdentifier: cellID)
        title = "Confirm Payment"
        tableView.tableFooterView = footer
    }
    
    
    lazy var header: PaymentHeader = {
        let frame = self.view.frame
        let view = PaymentHeader(frame: CGRect(x: 0, y: 0, width: frame.width, height: 120))
        view.user = user
        return view
    }()
    
    
    lazy var footer: ButtonTableFooterView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        let view = ButtonTableFooterView(frame: frame, title: "Confirm")
        view.delegate = self
        return view
    }()
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! InputCurrencyCell
        cell.valueInput.isEnabled = false
        setupCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func setupCell(cell: InputCurrencyCell, indexPath: IndexPath) {
        cell.backgroundColor = .white
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Amount"
            cell.valueInput.text = amount.rounded(6)
        case 1:
            cell.textLabel?.text = "USD"
            cell.valueInput.text = currency.currency()
        case 2:
            cell.textLabel?.text = "To"
            guard let username = username else { return }
            cell.valueInput.text = "$\(username)"
        default:
            break
        }
    }
    
    func submitOrder() {
        WalletService.sendPayment(token: token, toAccountID: publicKey, amount: amount) { (success) in
            if success == true {
                self.paymentSuccess()
            } else {
                ErrorPresenter.showError(message: "Failed to Send", on: self)
                self.footer.isLoading = false
            }
        }
    }
    
    func paymentSuccess() {
        SoundKit.playSound(type: .pay)
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}


extension ConfirmPaymentController: ButtonTableFooterDelegate {
    func didTapButton() {
        footer.isLoading = true
        submitOrder()
    }
}

