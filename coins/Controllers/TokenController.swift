//
//  TokenController.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class TokenController: UITableViewController {
    
    let paymentCell = "transactionCell"
    
    var token: Token? {
        didSet {
            if let name = token?.assetCode {
                title = name
            }
        }
    }
    
    var payments: [Payment] = [] {
        didSet {
            tableView.reloadData()
            setupEmptyView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PaymentCell.self, forCellReuseIdentifier: paymentCell)
    }
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 80))
        label.text = "No transactions yet."
        label.textColor = Theme.gray
        label.font = Theme.medium(20)
        label.textAlignment = .center
        return label
    }()
    
    func setupEmptyView() {
        if payments.count == 0 {
            self.tableView.backgroundView = emptyLabel
        } else {
            self.tableView.backgroundView = nil
        }
        print(payments.count)
    }
    
    func fetchPayments() {
        guard let assetCode = token?.assetCode else { return }
        payments = Payment.fetchPayments(forAsset: assetCode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchPayments()
    }
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: paymentCell, for: indexPath) as! PaymentCell
        cell.payment = payments[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ReceiptController(payment: payments[indexPath.row])
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
}


