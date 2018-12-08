//
//  ViewController.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class WalletController: UITableViewController {
    
    private var refresh = UIRefreshControl()
    
    let cardCell = "cardCell"
    
    var tokens: [Token] = [] {
        didSet {
            self.refresh.endRefreshing()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wallet"
        tableView.register(CardCell.self, forCellReuseIdentifier: cardCell)
        let moreIcon = UIImage(named: "more")?.withRenderingMode(.alwaysTemplate)
        let more = UIBarButtonItem(image: moreIcon, style: .done, target: self, action: #selector(handleMoreTap))
        self.navigationItem.rightBarButtonItem = more
        extendedLayoutIncludesOpaqueBars = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(fetchAccountBalance), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(auth), name: Notification.Name(rawValue: "login"), object: nil)
        auth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Passphrase: \(KeychainHelper.mnemonic)")
        print("Public Key: \(KeychainHelper.publicKey)")
        print("Secret Key: \(KeychainHelper.privateSeed)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refresh.endRefreshing()
    }
    
    
    @objc func handleMoreTap() {
        let vc = AccountController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func auth() {
        guard KeychainHelper.publicKey != "" else {
            handleLoggedOut()
            return
        }
        fetchAccountBalance()
        fetchPayments()
    }
    
    func fetchPayments() {
        WalletService.fetchTransactions { (payments) in
            
        }
    }
    
    func handleLoggedOut() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: false, completion: nil)
    }
    
    @objc func fetchAccountBalance() {
        WalletService.getAccountDetails { (tokens) in
            self.tokens = tokens
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cardCell, for: indexPath) as! CardCell
        cell.token = tokens[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TokenController(style: .grouped)
        vc.token = tokens[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }


    
}

