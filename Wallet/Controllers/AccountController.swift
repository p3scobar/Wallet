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
    
    var cardTitle = "Add a Card" {
        didSet {
            tableView.reloadData()
        }
    }
    
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

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPaymentMethods()
    }
    
    func getPaymentMethods() {
        guard cards.count == 0 else { return }
        PaymentService.getCards { (cards) in
            
        }
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
            cell.textLabel?.text = cardTitle
        case (2,0):
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
            pushCardsController()
        case (2,0):
            promptToSavePassphrase()
        case (3,0):
            pushOrderController()
        default:
            break
        }
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
        
    }
    
    
    func pushPassphraseController() {
        let vc = PassphraseController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushOrderController() {
        let vc = CardOrderController(token: Token.XAU, side: .buy)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
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
            return "Payment Methods"
        default:
            return ""
        }
    }
    
    
}

