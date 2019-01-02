//
//  AccountController.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class AccountController: UITableViewController {
    
    let standardCell = "standardCell"
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        title = "Account"
        view.backgroundColor = Theme.black
        tableView.backgroundColor = Theme.black
        tableView.separatorColor = Theme.border
        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath) as! StandardCell
        setupCell(cell: cell, indexPath)
        return cell
    }
    
    func setupCell(cell: UITableViewCell, _ indexPath: IndexPath) {
    
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.textLabel?.text = "Profile"
        case (0,1):
            cell.textLabel?.text = "Username"
        case (1,0):
            cell.textLabel?.text = "Banking"
        case (1,1):
            cell.textLabel?.text = "Pending Orders"
        case (2,0):
            cell.textLabel?.text = "Passphrase"
        case (2,1):
            cell.textLabel?.text = "Sign Out"
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
            pushBankingController()
        case (1,1):
            pushPendingOrdersController()
        case (2,0):
            pushPassphraseController()
        case (2,1):
            handleLogout()
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
    
    func pushPassphraseController() {
        let vc = PassphraseController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushOrdersController() {
        let vc = OrdersController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushBankingController() {
//        let vc = BankingController(style: .grouped)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushPendingOrdersController() {
        let vc = OffersController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleLogout() {
        WalletService.logOut {
            let vc = HomeController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}
