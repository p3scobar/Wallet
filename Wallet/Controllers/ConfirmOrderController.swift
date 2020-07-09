//
//  ConfirmOrderController.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit
import Stripe

class ConfirmOrderController: UITableViewController {

    let cellID = "cellID"
    
    var size: Double
    var price: Double
    var subtotal: Double
    var fee: Double
    var total: Double
    
    let client = PaymentService()
    var customerContext: STPCustomerContext
    var paymentContext: STPPaymentContext
    
    var usingApplePay = true
    
//    var paymentMethod: PaymentMethod = defaultPaymentMethod {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    
    var selectedMethodLabel: String = "Payment Method" {
        didSet {
            tableView.reloadData()
        }
    }
    
    var walletRefreshDelegate: WalletRefreshDelegate?
    
    var submitted = false

    lazy var footer: ButtonTableFooterView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140)
        let view = ButtonTableFooterView(frame: frame, title: "Pay Now")
        view.delegate = self
        return view
    }()


    init(size: Double, price: Double, subtotal: Double, fee: Double, total: Double) {
        self.size = size
        self.price = price
        self.subtotal = subtotal
        self.fee = fee
        self.total = total
        
        print("Size: \(size)")
        print("Price: \(price)")
        print("Subtotal: \(subtotal)")
        print("Fee: \(fee)")
        print("Total: \(total)")
        
        self.customerContext = STPCustomerContext(keyProvider: client)
        self.paymentContext = STPPaymentContext(customerContext: customerContext)
        
        super.init(style: .grouped)
        self.paymentContext.delegate = self
        self.paymentContext.hostViewController = self
        self.paymentContext.paymentAmount = Int(self.total*100)
//            NSNumber(decimal: self.total*100).intValue
        
        if Stripe.deviceSupportsApplePay() {
            STPPaymentConfiguration.shared().appleMerchantIdentifier = merchantID
        }
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
        title = "Confirm Buy"
        tableView.tableFooterView = footer
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
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
            cell.value = size
            cell.textLabel?.text = "Amount"
            cell.valueInput.placeholder = "1.000"
            if size != 0.0 { cell.valueInput.text = "\(size)" }
        case (0,1):
            cell.value = price
            cell.textLabel?.text = "Price"
            cell.valueInput.text = price.currency(2)
        case (0,2):
            cell.value = subtotal
            cell.textLabel?.text = "Subtotal"
            cell.valueInput.text = subtotal.currency(2)
        case (0,3):
            cell.value = fee
            cell.textLabel?.text = "Fee"
            cell.valueInput.text = fee.currency(2)
        case (0,4):
            cell.value = total
            cell.textLabel?.text = "Total"
            cell.valueInput.text = total.currency(2)
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
    
    
    func payWithCard() {
        print("handle card payment")
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
        paymentContext.pushPaymentOptionsViewController()
    }
    
    
    func pushReceipt() {
        let assetCode = "XAU"
        let side = "Buy"
        let date = Date().medium()
        
        let data = [
            (key: "Date", value: date),
            (key: side.capitalized, value: "\(size) \(assetCode)"),
            (key: "Price", value: price.currency(2)),
            (key: "Subtotal", value: subtotal.currency(2)),
            (key: "Processing Fee", value: fee.currency(2)),
            (key: "Total", value: total.currency(2)),
            (key: "Status", value: "Pending")
        ]
        
        let vc = ReceiptController(data)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem()
        vc.walletRefreshDelegate?.getData(nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



extension ConfirmOrderController: ButtonTableFooterDelegate {
    
    func didTapButton() {
        footer.isLoading = true
        paymentContext.requestPayment()
    }
    
}



extension ConfirmOrderController: STPPaymentContextDelegate {

    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        let label = paymentContext.selectedPaymentOption?.label
        selectedMethodLabel = label ?? "Payment Method"
        print("Selected Method: \(label)")
        
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        dismiss(animated: true)
        print(error.localizedDescription)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        guard let stripeId = paymentResult.paymentMethod?.stripeId else {
           print("Failed to parse stripeID")
            return
        }
        print("STRIPE ID: \(stripeId)")

        PaymentService.paymentIntent(size: size, paymentMethodID: stripeId) { (secret) in
                    guard let secret = secret else {
                        return
                    }
                    let paymentIntentParams = STPPaymentIntentParams(clientSecret: secret)
                    
                    STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: self.paymentContext) { status, paymentIntent, error in
                        switch status {
                        case .succeeded:
                            completion(.success, nil)
                            self.pushReceipt()
                        case .failed:
                            completion(.error, error)
                            let errorMessage = error?.localizedDescription ?? ""
                            ErrorPresenter.showError(message: errorMessage, on: self)
                        case .canceled:
                            completion(.userCancellation, nil)
                            print("paymentContext Cancelled")
                        @unknown default:
                            completion(.error, nil)
                            break
                        }
                    }
                }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        print(error?.localizedDescription)
        footer.isLoading = false
    }
    
}



extension ConfirmOrderController: STPApplePayContextDelegate {
    
//    func presentApplePay() {
//        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchantID,
//                                                   country: "US",
//                                                   currency: "USD")
//        paymentRequest.paymentSummaryItems = [
//            PKPaymentSummaryItem(label: "Gold",
//                                 amount: NSDecimalNumber(decimal: total)),
//            PKPaymentSummaryItem(label: "Bank Fee",
//                                 amount: NSDecimalNumber(decimal: total*0.03)),
//            PKPaymentSummaryItem(label: "Goldwire, Inc.",
//                                 amount: NSDecimalNumber(decimal: total*1.03)),
//        ]
//
//        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
//            applePayContext.presentApplePay(on: self)
//        } else {
//            print("There is a problem with your Apple Pay configuration")
//            ErrorPresenter.showError(message: "Apple Pay is not enabled", on: self)
//        }
//    }
    
    
    
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        
        PaymentService.paymentIntent(size: size, paymentMethodID: paymentMethod.stripeId) { (secret) in
            guard secret != nil else {
                let error = NSError(domain: "", code: 0, userInfo: nil)
                completion(nil, error)
                return
            }
            completion(secret, nil)
        }
        
    }
    
    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
        
        switch status {
        case .success:
            pushReceipt()
            break
        case .error:
            print("Payment failed, show the error")
            
            break
        case .userCancellation:
            
            break
        default:
            break
        }
    }

}


extension ConfirmOrderController: PaymentMethodDelegate {

    func selectedPaymentMethod(_ method: PaymentMethod) {
//        self.paymentMethod = method
    }

}




