//
//  CreditController.swift
//  Wallet
//
//  Created by Hackr on 9/25/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit

class CreditController: UITableViewController {
    
    let plainCell = "cell"

    override init(style: UITableView.Style) {
        super.init(style: style)
        title = "Credit"
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = Theme.background
        tableView.backgroundColor = Theme.background
        tableView.separatorColor = Theme.border
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: plainCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: plainCell, for: indexPath)
        setupCell(cell: cell, indexPath)
        return cell
    }
    
    func setupCell(cell: UITableViewCell, _ indexPath: IndexPath) {
        cell.backgroundColor = .white
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.textLabel?.text = "Balance"
        case (0,1):
            cell.textLabel?.text = "Credit Limit"
        case (0,2):
            cell.textLabel?.text = "Utilization Rate"
        case (0,3):
            cell.textLabel?.text = ""
        case (1,0):
            cell.textLabel?.text = ""
        case (1,1):
            cell.textLabel?.text = ""
        case (1,2):
            cell.textLabel?.text = ""
            
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    
}


