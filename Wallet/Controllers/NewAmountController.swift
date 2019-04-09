//
//  NewAmountController.swift
//  Wallet
//
//  Created by Hackr on 1/9/19.
//  Copyright © 2019 Sugar. All rights reserved.
//
//
//import Foundation
//import UIKit
//
//class NewAmountController: UITableViewController {
//
//    var publicKey: String
//    var user: User?
//    var size: Decimal = 0.0
//    var spotPrice: Decimal = goldSpotPrice
//    var currency: Decimal = 0.0
//
//    init(_ user: User) {
//        self.user = user
//        self.publicKey = user.publicKey ?? ""
//        super.init(style: .grouped)
//    }
//
//    init(_ publicKey: String) {
//        self.publicKey = publicKey
//        super.init(style: .grouped)
//        fetchUserForKey(publicKey)
//    }
//
//    private func fetchUserForKey(_ publicKey: String) {
//        UserService.getUserFor(publicKey: publicKey) { (user) in
//            self.user = user
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private let USDCell = "usdCell"
//    private let GOLDCell = "goldCell"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Amount"
//        tableView.backgroundColor = Theme.white
//        tableView.separatorColor = Theme.border
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(InputCurrencyCell.self, forCellReuseIdentifier: USDCell)
//        tableView.register(InputNumberCell.self, forCellReuseIdentifier: GOLDCell)
//
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InputNumberCell
//        cell.valueInput.becomeFirstResponder()
//    }
//
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 72
//    }
//
//    var goldCell: InputNumberCell!
//    var currencyCell: InputCurrencyCell!
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            goldCell = InputNumberCell(style: .default, reuseIdentifier: GOLDCell)
//            goldCell.key = 0
//            goldCell.delegate = self
//            goldCell.textLabel?.text = "Shares"
//            goldCell.valueInput.placeholder = "0.000"
//            if size != 0 {
//                goldCell.valueInput.text = "\(size)"
//            }
//            return goldCell
//        } else {
//            currencyCell = InputCurrencyCell(style: .default, reuseIdentifier: USDCell)
//            currencyCell.key = 1
//            currencyCell.delegate = self
//            currencyCell.textLabel?.text = "USD"
//            currencyCell.valueInput.text = currency.currency()
//            return currencyCell
//        }
//    }
//
//    @objc func handleSubmit() {
//        pushConfirmPaymentController()
//    }
//
//    func pushConfirmPaymentController() {
//
//        guard let user = user else {
//            ErrorPresenter.showError(message: "Could not find a user for key", on: self)
//            return
//        }
//        let vc = ConfirmPaymentController(user: user, token: Token.GOLD, amount: size, currency: currency)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//
//
//}
//
//extension NewAmountController: InputNumberCellDelegate {
//    func textFieldDidChange(key: Int, value: Decimal) {
//        if key == 0 {
//            size = value
//            calculateUSD()
//        } else {
//            currency = value
//            calculateGOLD()
//        }
//    }
//
//    func calculateGOLD() {
//
//        let amount = currency/spotPrice
//        size = amount
//        goldCell.valueInput.text = amount.rounded(3)
//
//        print("USD: \(currency)")
//        print("SIZE: \(size)")
//
//    }
//
//    func calculateUSD() {
//
//        let price = size * spotPrice
//        currency = price
//        currencyCell.valueInput.text = price.currency()
//
//
//        print("USD: \(currency)")
//        print("SIZE: \(size)")
//
//
//    }
//
//
//
//}

