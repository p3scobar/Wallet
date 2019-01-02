//
//  AmountController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
//import MPNumericTextField

class AmountController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    var publicKey: String?
    var amount: Decimal = 0.0
    var username: String?
    
    convenience init(publicKey: String?) {
        self.init()
        self.publicKey = publicKey
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Amount"
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
        setupView()
    }
    
    
    func handleError(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func handleCancel() {
        amountInput.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSubmit() {
        guard amountIsValid else { return }
    }
    
    var amountIsValid: Bool {
        guard amount > 1 else {
            ErrorPresenter.showError(message: "Invalid amount", on: self)
            return false
        }
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        amountInput.becomeFirstResponder()
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
        amount = amountInput.decimal
    }
    
    
    override var inputAccessoryView: UIView? {
        return confirmButton
    }
    
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        return button
    }()
    
    
    var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    lazy var amountInput: CurrencyField = {
        let field = CurrencyField()
        field.textAlignment = .center
        field.attributedPlaceholder = NSAttributedString(string: "$0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        field.adjustsFontSizeToFitWidth = true
        field.keyboardType = .decimalPad
        field.keyboardAppearance = UIKeyboardAppearance.light
        field.font = Theme.bold(36)
        field.borderStyle = UITextField.BorderStyle.none
        field.delegate = self
        field.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var captionLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = Theme.semibold(24)
        view.textColor = Theme.gray
        view.text = "USD"
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    func setupView() {
        view.addSubview(amountInput)
        view.addSubview(captionLabel)
        
        amountInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        amountInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        let offset = -view.frame.height/6
        amountInput.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive = true
        amountInput.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        captionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        captionLabel.topAnchor.constraint(equalTo: amountInput.bottomAnchor, constant: 0).isActive = true
        captionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
}

