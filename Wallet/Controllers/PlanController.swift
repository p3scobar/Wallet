//
//  PlanController.swift
//  Wallet
//
//  Created by Hackr on 3/20/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

protocol PlanDelegate {
    func pushPlanController(_ plan: Plan)
    func didCancelSubscription()
}

class PlanController: UITableViewController {
    
    var delegate: PlanDelegate?

    let standardCell = "standardCell"
    let planCell = "planCell"

    var plan: Plan {
        didSet {
            tableView.reloadData()
        }
    }

    lazy var header: UIView = {
        let frame = CGRect(x: 20, y: 0, width: self.view.frame.width-40, height: 80)
        let view = UIView(frame: frame)
        var instructionsLabel: UILabel = {
            let view = UILabel(frame: frame)
//            view.textContainerInset = UIEdgeInsets(top: 20, left: 14, bottom: 10, right: 14)
            view.backgroundColor = Theme.background
            view.font = Theme.bold(24)
            view.textColor = Theme.white
            let amount = plan.amount
            view.text = amount?.currency(2)
            return view
        }()
        view.addSubview(instructionsLabel)
        return view
    }()

    init(plan: Plan) {
        self.plan = plan
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Subscription"
        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
        tableView.register(InputNumberCell.self, forCellReuseIdentifier: planCell)
        view.backgroundColor = Theme.black
        tableView.backgroundColor = Theme.black
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath) as! StandardCell
            cell.textLabel?.text = "Edit Subscription"
            cell.textLabel?.textAlignment = .center
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath) as! StandardCell
            cell.textLabel?.text = "Cancel Subscription"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = Theme.red
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: planCell, for: indexPath) as! InputNumberCell
            setupCell(cell, indexPath)
            return cell
        }
    }
    
    func setupCell(_ cell: InputNumberCell, _ indexPath: IndexPath) {
        cell.valueInput.isEnabled = false
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.textLabel?.text = "Asset Code"
            cell.valueInput.text = plan.assetCode
        case (0,1):
            cell.textLabel?.text = "Amount"
            let amount = plan.amount ?? 0.0
            cell.valueInput.text = amount.currency(2) + " / Mo."
        case (0,2):
            cell.textLabel?.text = "Next Charge"
            cell.valueInput.text = plan.nextCharge.short()
        default:
            break
        }
    }


    internal func addCheckmark(_ indexPath: IndexPath, _ cell: UITableViewCell) {
        
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (1,0):
            handleEdit()
        case (2,0):
            handleDelete()
        default:
            break
        }
    }
    
    func handleEdit() {
        let vc = AmountController(assetCode: plan.assetCode)
        vc.planDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }

    func handleDelete() {
        let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to cancel your subscription?", preferredStyle: .alert)
        
         let no = UIAlertAction(title: "No", style: .default, handler: nil)
         let yes = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            self.deletePlan()
         }
         alert.addAction(no)
         alert.addAction(yes)
         present(alert, animated: true, completion:  nil)
    }
    
    fileprivate func deletePlan() {
        let planID = plan.id
        PaymentService.deletePlan(planID: planID, assetCode: plan.assetCode) { (result) in
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didCancelSubscription()
        }
    }

}



extension PlanController: ButtonTableFooterDelegate {
    
    func didTapButton() {
        dismiss(animated: true)
    }
    
    
}



extension PlanController: PlanDelegate {
    
    func didCancelSubscription() {}
    
    func pushPlanController(_ plan: Plan) {
        self.plan = plan
    }
    
    
}
