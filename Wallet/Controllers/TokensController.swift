//
//  TokensController.swift
//  coins
//
//  Created by Hackr on 1/1/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import UIKit

class TokensController: UITableViewController {
    
    private var searchController: UISearchController!
    private var refresh = UIRefreshControl()
    
    let cardCell = "tokenCell"
    
    var tokens: [Token] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Wallet"
        tableView.backgroundColor = .black
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        extendedLayoutIncludesOpaqueBars = true
        tableView.refreshControl = refresh
        tableView.separatorStyle = .none
        tableView.register(CardCell.self, forCellReuseIdentifier: cardCell)
        
        refresh.addTarget(self, action: #selector(getData(_:)), for: .valueChanged)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "user"), style: .done, target: self, action: #selector(handlePlusTap))
        getData(nil)
    }
    
    @objc func handlePlusTap() {
        let vc = AccountController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func getData(_ control: UIRefreshControl?) {
        WalletService.getAssets { (tokens) in
            self.tokens = tokens.sorted(by: { $0.assetCode > $1.assetCode })
            self.refresh.endRefreshing()
        }
        PaymentService.getPlan()
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
    }
    
    
    func handleLoggedOut() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: false, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cardCell, for: indexPath) as! CardCell
        let token = tokens[indexPath.row]
        cell.token = token
        getLastPrice(token: token, cell: cell)
//        setupCell(cell, token)
        return cell
    }
    
    private func getLastPrice(token: Token, cell: CardCell) {
        RateManager.getPrice(assetCode: token.assetCode) { (price) in
//            cell.cardView.price = price
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width*0.64
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = WalletController(tokens[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



extension TokensController: UISearchControllerDelegate {
    
}
