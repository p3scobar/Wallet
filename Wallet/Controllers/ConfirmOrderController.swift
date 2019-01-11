//
//  ConfirmOrderController.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit

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
        tableView.backgroundColor = Theme.lightbackground
        tableView.tableHeaderView = header

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InputCurrencyCell.self, forCellReuseIdentifier: cellID)
        title = "Confirm \(type.rawValue.capitalized)"
        tableView.tableFooterView = footer
    }
    
    
    
    lazy var header: PaymentHeader = {
        let view = PaymentHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
//        view.amountLabel.text = size.rounded(3)
        view.backgroundColor = Theme.lightbackground
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
        cell.backgroundColor = Theme.lightbackground
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Price"
            cell.valueInput.text = price.currency()
        case 1:
            cell.textLabel?.text = "Total"
            cell.valueInput.text = total.currency()
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
    
    
    fileprivate func confirmBuy() {
        let total = "\(price*size)"
        let sizeAsString = "\(size)"
        let priceAsString = "\(price)"
        TransferService.createOrder(size: sizeAsString, price: priceAsString, total: total) { (transfer) in
            self.pushReceiptController(transfer)
        }
    }
    
    func pushReceiptController(_ transfer: Transfer) {
        let vc = TransferController(transfer: transfer, hideBackButton: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func confirmSell() {

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
