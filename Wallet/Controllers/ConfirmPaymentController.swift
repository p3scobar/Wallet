//
//  ConfirmPaymentController.swift
//  coins
//
//  Created by Hackr on 1/6/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk

class ConfirmPaymentController: UITableViewController {
    
    let cellID = "cellID"
    
    var token: Token
    var publicKey: String
    var amount: Decimal
    var submitted = false
    
    init(publicKey: String, token: Token, amount: Decimal) {
        self.token = token
        self.publicKey = publicKey
        self.amount = amount
        super.init(style: .grouped)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InputCurrencyCell.self, forCellReuseIdentifier: cellID)
        title = "Confirm Payment"
        tableView.tableFooterView = footer
        tableView.backgroundColor = Theme.background
        extendedLayoutIncludesOpaqueBars = true
    }
    
    
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
        return 2
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
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "DMT"
            cell.valueInput.text = amount.rounded(4)
        case 1:
            cell.textLabel?.text = "USD"
            let value = amount.currency(2)
            cell.valueInput.text = value.currency()
        default:
            break
        }
    }
    
    func submitOrder() {
        guard let memo = try? Memo(text: "midgets") else { return }
        WalletService.sendPayment(token: token, toAccountID: publicKey, amount: amount, memo: memo) { (success) in
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

