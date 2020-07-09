//
//  PlanController.swift
//  Wallet
//
//  Created by Hackr on 3/20/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

class PlanController: UITableViewController {
    
    let planCell = "cellID"
    
    var selected: Plan?
    
    var plans: [Plan] = [Plan(id: "00", price: 50),
                         Plan(id: "01", price: 100),
                         Plan(id: "02", price: 250)
    ]

    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Savings"
        tableView.register(PlanCell.self, forCellReuseIdentifier: planCell)
        view.backgroundColor = Theme.black
        tableView.backgroundColor = Theme.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: planCell, for: indexPath) as! PlanCell
        cell.titleLeftLabel.text = plans[indexPath.row].price.currency(2) + " / Mo."
        addCheckmark(indexPath, cell)
        return cell
    }
    
    
    internal func addCheckmark(_ indexPath: IndexPath, _ cell: UITableViewCell) {
        guard let selected = selected else { return }
        if selected.id == plans[indexPath.row].id {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selected = plans[indexPath.row]
        tableView.reloadData()
    }
    
    
    
}
