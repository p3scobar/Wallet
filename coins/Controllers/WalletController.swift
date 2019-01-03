//
//  ViewController.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Pulley

class WalletController: UITableViewController, PulleyDrawerViewControllerDelegate {
    
    private var refresh = UIRefreshControl()
    
    let tokenCell = "tokenCell"
    
    var tokens: [Token] = [] {
        didSet {
            self.refresh.endRefreshing()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Wallet"
        
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.refreshControl = refresh
        tableView.separatorColor = Theme.border
        
        tableView.backgroundColor = Theme.black
        view.backgroundColor = Theme.black
    
        extendedLayoutIncludesOpaqueBars = true
        
        tableView.register(TokenCell.self, forCellReuseIdentifier: tokenCell)
        
        refresh.addTarget(self, action: #selector(auth), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(auth), name: Notification.Name(rawValue: "login"), object: nil)
        
        auth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Passphrase: \(KeychainHelper.mnemonic)")
        print("Public Key: \(KeychainHelper.publicKey)")
        print("Secret Key: \(KeychainHelper.privateSeed)")
        getAssets()
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
        getAssets()
    }
    
    
    func handleLoggedOut() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: false, completion: nil)
    }
    
    @objc func getAssets() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: tokenCell, for: indexPath) as! TokenCell
        cell.token = tokens[indexPath.row]
        return cell
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let token = tokens[indexPath.row]
        let vc = TokenController(token)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}


