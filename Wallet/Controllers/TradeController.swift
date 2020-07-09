//
//  TradeController.swift
//  Wallet
//
//  Created by Hackr on 2/13/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit
import UIKit

class TradeController: UITableViewController {
    
    let cellId = "cellId"
    var trade: Trade!
    
    init(_ trade: Trade) {
        self.trade = trade
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.black
        tableView.backgroundColor = Theme.black
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(InputTextCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = Theme.border
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        self.navigationItem.title = trade.side?.capitalized
        extendedLayoutIncludesOpaqueBars = true
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InputTextCell
        cell.valueInput.isEnabled = false
        let counterAmount = Decimal(string: trade.counterAmount ?? "") ?? 0.0
        let amt = trade.baseAmount ?? ""
        let baseAmount = Decimal(string: amt) ?? 0.0
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Date"
            cell.valueInput.text = trade.timestamp.medium()
        case 1:
            cell.textLabel?.text = "Side"
            cell.valueInput.text = trade.side?.capitalized
        case 2:
            cell.textLabel?.text = "Asset"
            cell.valueInput.text = trade.counterAssetCode
        case 3:
            cell.textLabel?.text = "Amount"
            let amount = trade.counterAmount ?? ""
            let code = trade.counterAssetCode ?? ""
            cell.valueInput.text = amount.rounded(4) + " \(code)"
        case 4:
            let counterAmount = Decimal(string: trade.counterAmount ?? "") ?? 0.0
            let baseAmount = Decimal(string: trade.baseAmount ?? "") ?? 0.0

            let price = (baseAmount/counterAmount).rounded(4)
            
            cell.textLabel?.text = "Price"
            let assetCode = trade.baseAssetCode ?? ""
            cell.valueInput.text = price + " \(assetCode)"
        case 5:
            cell.textLabel?.text = "Total"
            let amount = trade.baseAmount ?? ""
            let assetCode = trade.baseAssetCode ?? ""
            cell.valueInput.text = amount.rounded(4) + " \(assetCode)"
        
        default:
            break
        }
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}


