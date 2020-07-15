//
//  AmountController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class AmountController: UIViewController, UITextFieldDelegate {
    
    var assetCode: String
    
    var amount: Double = 0.0 {
        didSet {
            print("AMOUNT: \(amount)")
        }
    }
    
    init(assetCode: String) {
        self.assetCode = assetCode
        super.init(nibName: nil, bundle: nil)
        self.checkForPlan()
    }
    
    fileprivate func checkForPlan() {
        if let plan = plans[assetCode] {
            self.amount = plan.amount ?? 0.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Savings"
        view.backgroundColor = Theme.background
        extendedLayoutIncludesOpaqueBars = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSubmit))
        setupView()
    }
    
    
    func handleError(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: TODO
    // Eventually add a confirmation controller for subscriptions
    
    @objc func handleSubmit() {
        let vc = ConfirmSubscriptionController(amount: amount, assetCode: assetCode)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    var amountIsValid: Bool {
        guard amount > 0.0000001 else {
            ErrorPresenter.showError(message: "Invalid amount", on: self)
            return false
        }
        return true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        amountInput.becomeFirstResponder()
        amountInput.text = amount.currency(2)
        amountInput.lastValue = amount.currency(2)
        formatInput()
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        formatInput()
    }
    
    
    func formatInput() {
        guard amountInput.decimal <= amountInput.maximum else {
            amountInput.text = amountInput.lastValue
            return
        }
        amountInput.lastValue = Formatter.currency.string(for: amountInput.decimal) ?? ""
        amountInput.text = amountInput.lastValue
        amount = amountInput.doubleValue
    }
    
    
    var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .currency
        return formatter
    }()
    
    lazy var amountInput: CurrencyField = {
        let frame = CGRect(x: 0, y: self.view.center.y-150, width: self.view.frame.width, height: 80)
        let field = CurrencyField(frame: frame)
        field.textAlignment = .center
        field.attributedPlaceholder = NSAttributedString(string: "$0.00 USD", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        field.adjustsFontSizeToFitWidth = true
        field.keyboardType = .decimalPad
        field.keyboardAppearance = UIKeyboardAppearance.dark
        field.font = Theme.bold(48)
        field.textColor = Theme.white
        field.tintColor = Theme.highlight
        field.borderStyle = UITextField.BorderStyle.none
        field.lastValue = CurrentUser.savings.currency(2)
        field.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        return field
    }()
    
    lazy var subtitleLabel: UILabel = {
        let frame = CGRect(x: 20, y: amountInput.frame.maxY+20, width: self.view.frame.width-40, height: 32)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(20)
        label.textColor = Theme.gray
        label.textAlignment = .center
        label.text = "PER MONTH"
        return label
    }()
    
    
    func setupView() {
        view.addSubview(amountInput)
        view.addSubview(subtitleLabel)
    }
    
}

