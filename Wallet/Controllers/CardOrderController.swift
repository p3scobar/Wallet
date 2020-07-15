//
//  CardOrderController.swift
//  Wallet
//
//  Created by Hackr on 3/21/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk
import PassKit
import Stripe

class CardOrderController: UITableViewController, InputNumberCellDelegate {
    
    var numberCell = "numberCell"
    var currencyCell = "currencyCell"
    
    var token: Token
    var side: TransactionType
    var size: Double = 1.000
    var price: Double = 0.0
//      RateManager.rates[token.assetCode]
    var subtotal: Double = 0.0
//      RateManager.XAUUSD
    var fee: Double = 0.0
//      RateManager.XAUUSD*0.03
    var total: Double = 0.0
//      RateManager.XAUUSD*1.03
    
//    var payment: PKPayment?
    
    init(token: Token, side: TransactionType) {
        self.token = token
        self.side = side
        super.init(style: .grouped)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var walletRefreshDelegate: WalletRefreshDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(side.rawValue.capitalized)"
        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = Theme.black
        tableView.separatorColor = Theme.border

        extendedLayoutIncludesOpaqueBars = true
        tableView.register(InputNumberCell.self, forCellReuseIdentifier: numberCell)
        tableView.tableFooterView = UIView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Review", style: .done, target: self, action: #selector(pushConfirmController))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("STRIPE CUSTOMER ID: \(CurrentUser.stripeID)")
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func pushConfirmController() {
        let vc = ConfirmOrderController(size: size, price: price, subtotal: subtotal, fee: fee, total: total)
        vc.walletRefreshDelegate = walletRefreshDelegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? InputNumberCell {
            cell.valueInput.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.resignFirstResponder()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: numberCell, for: indexPath) as! InputNumberCell
        cell.delegate = self
        cell.key = indexPath.row
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.value = size
            cell.textLabel?.text = "Amount"
            cell.valueInput.placeholder = "1.000"
            cell.valueInput.isEnabled = true
            if size != 0.0 { cell.valueInput.text = "\(size)" }
        case (0,1):
            cell.value = price
            cell.textLabel?.text = "Price"
            cell.valueInput.isEnabled = false
            cell.valueInput.text = price.currency(2)
        case (0,2):
            cell.value = total
            cell.textLabel?.text = "Subtotal"
            cell.valueInput.isEnabled = false
            cell.valueInput.text = subtotal.currency(2)
        default:
            break
        }
        return cell
    }
    
    
    
    func textFieldDidChange(key: Int, value: Double) {
        if key == 0 {
            size = value
        }
        if key == 1 {
            price = value
        }
        calculateTotals()
    }
    
    
    func calculateTotals() {
        price = price.rounded(toPlaces: 2)
        size = size.rounded(toPlaces: 2)
        subtotal = (size*price).rounded(toPlaces: 2)
        fee = subtotal*0.03
        total = subtotal+fee
        print("SIZE: \(size)")
        print("PRICE: \(price)")
        print("SUBTOTAL: \(subtotal)")
        print("FEE: \(fee)")
        print("TOTAL: \(total)")
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    
}
 
