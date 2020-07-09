//
//  AccountController.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit
import Stripe

class AccountController: UITableViewController {
    
    let client = PaymentService()
    var customerContext: STPCustomerContext?
    var paymentContext: STPPaymentContext?
    
    let assetCell = "assetCell"
    let standardCell = "standardCell"
    
    
    lazy var header: AccountHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160)
        let view = AccountHeaderView(frame: frame)
        view.delegate = self
        return view
    }()

    
    @objc func baseAssetController() {
        let vc = BaseCurrencyController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        tableView.tableHeaderView = header
        tableView.showsVerticalScrollIndicator = false
        extendedLayoutIncludesOpaqueBars = true

        tableView.backgroundColor = Theme.background

        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))

        header.publicKey = KeychainHelper.publicKey

        getPaymentMethods()
    }
    
    func setupStripe() {
//        customerContext = STPCustomerContext(keyProvider: client)
        
//        paymentContext = STPPaymentContext(customerContext: customerContext!)
//        
//        paymentContext?.delegate = self
//        paymentContext?.hostViewController = self
    }
    
    func getPaymentMethods() {
//        PaymentService.getCards { (cards) in
//            
//        }
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 1
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
            cell.textLabel?.text = "Profile"
        case (0,1):
            cell.textLabel?.text = "Username"
        case (1,0):
            cell.textLabel?.text = "$20 USD / Mo."
        case (2,0):
            cell.textLabel?.text = "Payment Methods"
        case (3,0):
            cell.textLabel?.text = "Passphrase"
        case (4,0):
            cell.textLabel?.text = "Sign Out"
            cell.textLabel?.textColor = .red
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            pushProfileController()
        case (0,1):
            pushUsernameController()
        case (1,0):
            pushPlansController()
        case(2,0):
            pushCardsController()
        case (3,_):
            pushPassphraseController()
        case (4,0):
            promptToSavePassphrase()
        default:
            break
        }
    }
    
    func pushTokenController(_ token: Token) {
        let vc = TokenController(token)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    func pushSubscriptionController() {
        let vc = PlanController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func pushProfileController() {
        let vc = ProfileController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushUsernameController() {
        let vc = UsernameController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushPlansController() {
        let vc = PlanController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushPassphraseController() {
        let vc = PassphraseController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushPendingOrdersController() {
        let vc = PendingOrdersController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func promptToSavePassphrase() {
        let alert = UIAlertController(title: "Backup Passphrase", message: "Have you backed up your passphrase? It is the only way to recover your account.", preferredStyle: .alert)
       
        let done = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let signOut = UIAlertAction(title: "Sign Out", style: .destructive) { (signout) in
            self.handleLogout()
        }
        alert.addAction(done)
        alert.addAction(signOut)
        present(alert, animated: true, completion:  nil)
    }
    
    func handleLogout() {
        UserService.signout { _ in }
        self.presentHomeController()
    }
    
    func presentHomeController() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true) {
            
        }
    }
    
}


extension AccountController: AccountHeaderDelegate {
    
    
    func handleQRTap(publicKey: String) {
        let vc = QRController()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Profile"
        case 1:
            return "Savings"
        case 2:
            return "Payments"
        case 3:
            return "Security"
        case 4:
            return "Sign Out"
        default:
            return ""
        }
    }
    
    
}

