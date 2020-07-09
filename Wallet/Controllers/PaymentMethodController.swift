//
//  PaymentMethodController.swift
//  Wallet
//
//  Created by Hackr on 7/6/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit
import Stripe

protocol PaymentMethodDelegate {
    func selectedPaymentMethod(_ method: PaymentMethod)
}

class PaymentMethodController: UITableViewController {
    
    var delegate: PaymentMethodDelegate?
    
    let standardCell = "standardCell"
    
    var paymentMethods: [PaymentMethod] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment Method"

        tableView.showsVerticalScrollIndicator = false
        extendedLayoutIncludesOpaqueBars = true

        tableView.backgroundColor = Theme.background

        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))

        getPaymentMethods()
    }
    
    func getPaymentMethods() {
        paymentMethods = Array(cards.values).sorted (by: { $0.brand < $1.brand })
        PaymentService.getCards { (cards) in
            self.paymentMethods = cards
        }
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return paymentMethods.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath) as! StandardCell
        setupCell(cell: cell, indexPath)
        return cell
    }
    

    
    func setupCell(cell: StandardCell, _ indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.textLabel?.text = " Apple Pay"
        case (1,_):
            cell.textLabel?.text = paymentMethods[indexPath.row].brand.uppercased()
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let method = PaymentMethod(id: "0000", type: .applePay, brand: nil, last4: nil)
            delegate?.selectedPaymentMethod(method)
            defaultPaymentMethod = method
        case 1:
            let method = paymentMethods[indexPath.row]
            delegate?.selectedPaymentMethod(method)
            defaultPaymentMethod = method
        default:
            break
        }
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    

    
    
}


    
