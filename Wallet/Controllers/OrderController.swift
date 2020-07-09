//
//  OrderController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

//import UIKit
//import stellarsdk
//
//class OrderController: UITableViewController, InputNumberCellDelegate {
//    
//    var numberCell = "numberCell"
//    var currencyCell = "currencyCell"
//    
//    var token: Token
//    var side: TransactionType
//    var size: Double = 0
//    var price: Double = 0
//    var total: Double = 0
//    
//    init(token: Token, side: TransactionType, size: Decimal, price: Decimal) {
//        self.token = token
//        self.side = side
//        self.size = size
//        self.price = price
//        self.total = size*price
//        super.init(style: .grouped)
//    }
//    
//    init(token: Token, side: TransactionType) {
//        self.token = token
//        self.side = side
//        super.init(style: .grouped)
//        
//    }
//    
//    func getBestPrice() {
//        OrderService.bestPrices(buy: baseAsset, sell: token) { (bestOffer, bestBid) in
//            if self.side == .buy {
//                self.price = bestOffer
//            } else {
//                self.price = bestBid
//            }
//            self.tableView.reloadData()
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        title = "\(side.rawValue.capitalized)"
//        tableView.isScrollEnabled = true
//        tableView.alwaysBounceVertical = true
//        tableView.backgroundColor = Theme.background
//        
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//        extendedLayoutIncludesOpaqueBars = true
//        tableView.register(InputNumberCell.self, forCellReuseIdentifier: numberCell)
//        tableView.tableFooterView = UIView()
//        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Review", style: .done, target: self, action: #selector(handleReview))
//        
//        if isModal {
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        getBestPrice()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? InputNumberCell {
//            cell.valueInput.becomeFirstResponder()
//        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        view.resignFirstResponder()
//    }
//    
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: numberCell, for: indexPath) as! InputNumberCell
//        cell.delegate = self
//        cell.key = indexPath.row
//        cell.delegate = self
//        switch indexPath.row {
//        case 0:
//            cell.value = size
//            cell.textLabel?.text = "Amount"
//            cell.valueInput.placeholder = "0"
//            cell.valueInput.isEnabled = true
//            if size != 0.0 { cell.valueInput.text = "\(size)" }
//        case 1:
//            cell.textLabel?.text = "Price"
//            cell.value = price
//            cell.valueInput.text = price.currency(2)
//        case 2:
//            cell.value = total
//            cell.textLabel?.text = "Total"
//            cell.valueInput.isEnabled = false
//            cell.valueInput.text = total.rounded(2) + " \(baseAsset.assetCode)"
//        default:
//            break
//        }
//        return cell
//    }
//    
//    
//    
//    func textFieldDidChange(key: Int, value: Decimal) {
//        if key == 0 {
//            size = value
//        }
//        if key == 1 {
//            price = value
//        }
//        calculateTotals()
//    }
//    
//    
//    func calculateTotals() {
//        total = size*price
//        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
//        
//        print("SIZE: \(size)")
//        print("PRICE: \(price)")
//        print("TOTAL: \(total)")
//        print("")
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 72
//    }
//    
//    
//    @objc func handleReview() {
//        guard orderSizeIsValid(amount: size) else {
//            presentAlertController(message: "Invalid order size.")
//            return
//        }
//        handleConfirm()
//    }
//    
//    
//    func orderSizeIsValid(amount: Decimal) -> Bool {
//        //        let minimum: Decimal = 1
//        //        let maximum: Decimal = 100.00
//        //        if amount < minimum || amount > maximum {
//        //            return false
//        //        }
//        return true
//    }
//    
//    
//    func presentAlertController(message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
//        alert.addAction(done)
//        present(alert, animated: true, completion: nil)
//    }
//    
//    
//    @objc func handleCancel() {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    
//    var isModal: Bool {
//        return presentingViewController != nil ||
//            navigationController?.presentingViewController?.presentedViewController === navigationController ||
//            tabBarController?.presentingViewController is UITabBarController
//    }
//    
//    
//    lazy var signupButton: UIButton = {
//        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
//        let button = UIButton(frame: frame)
//        button.setTitle("Confirm Order", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = Theme.semibold(20)
//        button.layer.cornerRadius = 18
//        button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    
//    
//    @objc func handleConfirm() {
//        let vc = OrderConfirmController(token: counterAsset, side: side, amount: size, price: price, total: total)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    
//}
//
