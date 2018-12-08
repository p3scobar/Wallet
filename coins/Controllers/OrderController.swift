//
//  OrderController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class OrderController: UITableViewController, InputNumberCellDelegate {
    
    var side = ""
    var inputCellId = "inputCell"
    var orderValues: [String : Any] = [:]
    
    convenience init(style: UITableView.Style, side: String) {
        self.init(style: style)
        self.side = side
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(side.capitalized) Gold"
        orderValues["side"] = side
//        orderValues["rate"] = RateService.offerPrice
        
        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = true
//        tableView.backgroundColor = Theme.lightGrayBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(InputNumberCell.self, forCellReuseIdentifier: inputCellId)
        tableView.tableFooterView = UIView()
        
        fetchData()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Review", style: .done, target: self, action: #selector(handleReview))
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    func fetchData() {
        //        RateService.goldQuote { (bid, ask) in
        //            if self.side == "buy" {
        //                self.orderValues["rate"] = ask
        //            } else {
        //                self.orderValues["rate"] = bid
        //            }
        //            DispatchQueue.main.async {
        //                self.tableView.reloadData()
        //            }
        //        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: inputCellId, for: indexPath) as! InputNumberCell
        cell.delegate = self
        setupCell(indexPath: indexPath.row, cell: cell)
        return cell
    }
    
    
    func setupCell(indexPath: Int, cell: InputNumberCell) {
        cell.key = indexPath
        cell.backgroundColor = .white
        cell.valueInput.textColor = .black
        cell.valueInput.keyboardType = .numberPad
        switch indexPath {
        case 0:
            cell.textLabel?.text = "Troy Ounces"
            cell.valueInput.becomeFirstResponder()
        case 1:
            cell.valueInput.isEnabled = false
            cell.textLabel?.text = "Rate"
            if let rate = orderValues["rate"] as? Decimal {
                cell.valueInput.text = rate.rounded(2) + "/oz."
            }
        case 2:
            cell.textLabel?.text = "Total"
            cell.valueInput.isEnabled = false
            if let total = orderValues["total"] as? Decimal {
                cell.valueInput.text = total.rounded(2)
            }
        default:
            break
        }
        
    }
    
    func textFieldDidChange(key: Int, value: Decimal) {
        if key == 0 {
            orderValues["amount"] = value
        }
        calculateTotals()
    }
    
    
    func calculateTotals() {
        guard let amount = orderValues["amount"] as? Decimal,
            let rate = orderValues["rate"] as? Decimal
            else { return }
        let total = amount*rate
        orderValues["side"] = side
        orderValues["total"] = total
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    @objc func handleReview() {
        guard let amount = orderValues["amount"] as? Decimal, orderSizeIsValid(amount: amount) else {
            presentAlertController(message: "Invalid order size.")
            return
        }
        presentConfirmButton()
    }
    
    
    func orderSizeIsValid(amount: Decimal) -> Bool {
        let minimum: Decimal = 1
        let maximum: Decimal = 100.00
        if amount < minimum || amount > maximum {
            return false
        }
        return true
    }
    
    
    func presentAlertController(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(done)
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    lazy var signupButton: UIButton = {
        let frame = CGRect(x: 0, y: self.view.frame.height-84, width: UIScreen.main.bounds.width, height: 64)
        let button = UIButton(frame: frame)
        button.setTitle("Confirm Order", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Theme.semibold(20)
        button.backgroundColor = Theme.black
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    func presentConfirmButton() {
        view.endEditing(true)
        view.addSubview(signupButton)
    }
    
    @objc func handleConfirm() {
        guard let amount = orderValues["amount"] as? Decimal else { return }
        CoinbaseService.createCharge(amount: "\(amount)") { (address, amount) in
            let vc = DepositController(amount: amount, address: address)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

