//
//  AccountController+STPPaymentContextDelegate.swift
//  Wallet
//
//  Created by Hackr on 3/21/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit
import Stripe

extension AccountController {
    
    func pushCardsController() {
        let service = PaymentService()
        service.createCustomerKey(withAPIVersion: "latest") { (data, error) in }
        let config = STPPaymentConfiguration.shared()
        let context = STPCustomerContext(keyProvider: client)
        let vc = STPPaymentOptionsViewController(configuration: config, theme: .default(), customerContext: context, delegate: self)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
}


extension AccountController: STPPaymentContextDelegate {

    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        let label = paymentContext.selectedPaymentOption?.label
        print("Selected Method: \(label)")
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        dismiss(animated: true)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        dismiss(animated: true)
    }
    

}



extension AccountController: STPPaymentOptionsViewControllerDelegate {
    
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didFailToLoadWithError error: Error) {
        print("Failed to load Add Card View Controller")
        dismiss(animated: true, completion: nil)
    }
    
    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didSelect paymentOption: STPPaymentOption) {
        let option = paymentOption.label
        print("LABEL: \(option)")
        
        
    }
    
}
