//
//  BaseCurrencyController.swift
//  Wallet
//
//  Created by Hackr on 3/15/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

class BaseCurrencyController: UITableViewController {
    
    let tokenCell = "tokenCell"
    
    var tokens: [Token] = [Token.native, Token.USD] {
        didSet {
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Base Currency"
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .automatic
//        tableView.separatorColor = Theme.border
//        tableView.backgroundColor = Theme.black
//        view.backgroundColor = Theme.black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tokenCell)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tokenCell, for: indexPath)
        let token = tokens[indexPath.row]
        customizeCell(cell, token)
        let assetCode = token.assetCode ?? ""
        let baseAssetCode = baseAsset.assetCode ?? "USD"
        if assetCode == baseAssetCode {
            cell.textLabel?.textColor = Theme.highlight
        }
        return cell
            
    }
    
    func customizeCell(_ cell: UITableViewCell, _ token: Token) {
        cell.textLabel?.text = token.name
//        cell.backgroundColor = Theme.tint
        cell.textLabel?.textColor = .black
        let bgView = UIView()
        bgView.backgroundColor = .white
        cell.selectedBackgroundView = bgView
        
        //accessoryView = UITableViewCell.AccessoryType.checkmark
    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let token = tokens[indexPath.row]
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let token = tokens[indexPath.row]
        let balance = Decimal(string: token.balance) ?? 0.0
        return (balance > 0) ? false : true
    }
    

    
}





