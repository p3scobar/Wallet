//
//  ConfirmSubscriptionController.swift
//  Wallet
//
//  Created by Hackr on 7/13/20.
//  Copyright © 2020 Sugar. All rights reserved.
//


import Foundation
import UIKit
import Stripe

class ConfirmSubscriptionController: UITableViewController {
    
    var planDelegate: PlanDelegate?

    let cellID = "cellID"
    
    var amount: Double
    var assetCode: String
    
    var walletRefreshDelegate: WalletRefreshDelegate?

    let client = PaymentService()
    var customerContext: STPCustomerContext
    var paymentMethodID: String?
    var selectedMethodLabel: String = "Select" {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var header: UIView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        let view = UIView(frame: frame)
        var instructionsLabel: UITextView = {
            let view = UITextView(frame: frame)
            view.textContainerInset = UIEdgeInsets(top: 4, left: 14, bottom: 10, right: 14)
            view.backgroundColor = Theme.background
            view.font = UIFont.boldSystemFont(ofSize: 18)
            view.textColor = Theme.white
            view.isEditable = false
            view.text = "Your card will be charged monthly."
            return view
        }()
        view.addSubview(instructionsLabel)
        return view
    }()

    lazy var footer: ButtonTableFooterView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140)
        let view = ButtonTableFooterView(frame: frame, title: "Subscribe")
        view.delegate = self
        return view
    }()


    init(amount: Double, assetCode: String) {
        self.amount = amount
        self.assetCode = assetCode
        self.customerContext = STPCustomerContext(keyProvider: client)
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.background

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InputNumberCell.self, forCellReuseIdentifier: cellID)
        title = "Confirm Subscription"
        tableView.tableHeaderView = header
        tableView.tableFooterView = footer
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! InputNumberCell
        cell.valueInput.isEnabled = false
        setupCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func setupCell(cell: InputNumberCell, indexPath: IndexPath) {
        cell.valueInput.isEnabled = false
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.value = amount
            cell.textLabel?.text = "Asset Code"
            cell.valueInput.text = assetCode
        case (0,1):
            cell.value = amount
            cell.textLabel?.text = "Amount"
            cell.valueInput.text = amount.currency(2) + " USD"
        case (1,0):
            cell.textLabel?.text = selectedMethodLabel
            cell.valueInput.text = nil
            cell.tintColor = .white
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
    }


    func presentFailureAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default) { (done) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    

    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "Payment Method"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            pushPaymentMethodController()
        default:
            break
        }
    }
    
    func pushPaymentMethodController() {
        let config = STPPaymentConfiguration()
        let vc = STPPaymentOptionsViewController(configuration: config, theme: .default(), apiAdapter: customerContext, delegate: self)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    
    func updateSubscription() {
        guard let paymentMethodID = paymentMethodID else {
            footer.isLoading = false
            ErrorPresenter.showError(message: "Select a payment method", on: self)
            return
        }
        footer.isLoading = true
        PaymentService.subscribe(assetCode: assetCode, amount: amount, paymentMethodID: paymentMethodID) { (plan) in
            self.footer.isLoading = false
            guard let plan = plan else {
                ErrorPresenter.showError(message: "Something went wrong. Please try again.", on: self)
                return
            }
            self.pushPlanController(plan)
        }
    }
    
//    func presentSuccessAlert() {
//        let alert = UIAlertController(title: "Success", message: "Your subscription has been updated successfully.", preferredStyle: .alert)
//        let done = UIAlertAction(title: "Done", style: .default) { (_) in
////            self.navigationController?.popToRootViewController(animated: true)
////            self.pushPlanController()
//        }
//        alert.addAction(done)
//        present(alert, animated: true, completion:  nil)
//    }
    
    
    func pushPlanController(_ plan: Plan) {
//        let vc = PlanController(plan: plan)
        dismiss(animated: true) {
            self.planDelegate?.pushPlanController(plan)
        }
    }
    
}



extension ConfirmSubscriptionController: ButtonTableFooterDelegate {
    
    func didTapButton() {
        updateSubscription()
    }
    
}



extension ConfirmSubscriptionController: STPPaymentOptionsViewControllerDelegate {
   
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didFailToLoadWithError error: Error) {
        ErrorPresenter.showError(message: "Failed to get payment methods", on: self)
    }
    
    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        dismiss(animated: true) {}
    }
    
    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        dismiss(animated: true) {}
    }
    
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didSelect paymentOption: STPPaymentOption) {
        selectedMethodLabel = paymentOption.label
        print(paymentOption.label)
        if let method = paymentOption as? STPPaymentMethod {
            self.paymentMethodID = method.stripeId
        }
    }
    
    
    
    
}
