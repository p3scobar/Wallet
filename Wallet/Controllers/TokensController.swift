//
//  TokensController.swift
//  coins
//
//  Created by Hackr on 1/1/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import UIKit
import Pulley

class TokensController: UITableViewController, PulleyDrawerViewControllerDelegate {
    
    private var searchController: UISearchController!
    private var refresh = UIRefreshControl()
    
    let tokenCell = "tokenCell"
    
    var tokens: [Token] = [] {
        didSet {
            refresh.endRefreshing()
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Assets"
        
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.refreshControl = refresh
        tableView.separatorColor = Theme.border
        
        tableView.backgroundColor = Theme.black
        view.backgroundColor = Theme.black
        
        self.definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
//        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = Theme.gray
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        tableView.register(TokenCellDetails.self, forCellReuseIdentifier: tokenCell)
        
        refresh.addTarget(self, action: #selector(getAssets(_:)), for: .valueChanged)
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
        getAssets(nil)
    }
    
    
    func handleLoggedOut() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: false, completion: nil)
    }
    
    @objc func getAssets(_ sender: UIRefreshControl?) {
        self.tokens = Token.allAssets
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tokenCell, for: indexPath) as! TokenCellDetails
        let token = tokens[indexPath.row]
        cell.token = token
        getLastPrice(token: token, cell: cell)
        return cell
    }
    
    private func getLastPrice(token: Token, cell: TokenCell) {
        TokenService.getLastPrice(token: token) { (amount) in
            cell.balanceLabel.text = amount
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TokenController(tokens[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



extension TokensController: UISearchControllerDelegate {
    
}
