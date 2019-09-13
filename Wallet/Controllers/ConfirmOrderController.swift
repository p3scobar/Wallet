//
//  ConfirmOrderController.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit
import stellarsdk

class ConfirmOrderController: UITableViewController {
    
    let cellID = "cellID"
    var type: TransactionType
    
    var size: Decimal
    var price: Decimal
    var total: Decimal
    var submitted = false
    
    lazy var footer: ButtonTableFooterView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        let view = ButtonTableFooterView(frame: frame, title: "Confirm")
        view.delegate = self
        return view
    }()
    
    
    init(type: TransactionType, size: Decimal, price: Decimal, total: Decimal) {
        self.type = type
        self.size = size
        self.price = price
        self.total = total
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.background
        tableView.tableHeaderView = header

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InputCurrencyCell.self, forCellReuseIdentifier: cellID)
        title = "Confirm \(type.rawValue.capitalized)"
        tableView.tableFooterView = footer
    }
    
    
    
    lazy var header: PaymentHeader = {
        let view = PaymentHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        view.backgroundColor = Theme.background
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
        cell.backgroundColor = Theme.background
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Price"
            cell.valueInput.text = price.currency(2)
        case 1:
            cell.textLabel?.text = "Total"
            cell.valueInput.text = total.currency(2)
        default:
            break
        }
    }

    
    func submitOrder() {
        switch type {
        case .buy:
            confirmBuy()
        case .sell:
            confirmSell()
        default:
            break
        }
        
    }
    
    
    
    func confirmBuy() {
        let token = Token.XSG
        guard let n: Int32 = Int32("\(price*100)"),
            let d: Int32 = Int32("100") else { return }
        let p = Price(numerator: n, denominator: d)
        let buyAsset = baseAsset
        let sellAsset = token
        submitOffer(buy: buyAsset, sell: sellAsset, amount: size, price: p)
    }
    
    func confirmSell() {
        let token = Token.XSG
        guard let n: Int32 = Int32("\(price*100)"),
            let d: Int32 = Int32("100") else { return }
        let p = Price(numerator: n, denominator: d)
        let buyAsset = baseAsset
        let sellAsset = token
        submitOffer(buy: buyAsset, sell: sellAsset, amount: size, price: p)
    }
    
    
    
    func submitOffer(buy: Token, sell: Token, amount: Decimal, price: Price) {
        guard let buying = buy.toRawAsset(),
            let selling = sell.toRawAsset() else {
                print("failed to generate raw assets")
                return
        }
        OrderService.offer(buy: buying, sell: selling, amount: amount, price: price) { success in
            
            if success == true {
                self.dismiss(animated: true, completion: nil)
            } else {
                ErrorPresenter.showError(message: "Order Failed", on: self)
            }
            self.footer.isLoading = false
        }
    }
    
    func pushReceiptController(_ transfer: Transfer) {
        let vc = TransferController(transfer: transfer, hideBackButton: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func animateCardSuccess(amount: Decimal, type: TransactionType) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        
        UIView.animate(withDuration: 0.2) {
            UIDevice.vibrate()
        }
    }
    
    func presentFailureAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default) { (done) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension ConfirmOrderController: ButtonTableFooterDelegate {
    func didTapButton() {
        footer.isLoading = true
        submitOrder()
    }
}
