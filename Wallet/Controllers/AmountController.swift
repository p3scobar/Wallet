//
//  AmountController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class AmountController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    var type: TransactionType
    var publicKey: String
    var username: String?
    var user: User?
    
    var amount: Decimal = 0.0 {
        didSet {
            
        }
    }
    
    var currency: Decimal = 0 {
        didSet {
            
        }
    }
    
    init(publicKey: String, type: TransactionType) {
        self.publicKey = publicKey
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    init(user: User, type: TransactionType) {
        self.user = user
        self.publicKey = user.publicKey ?? ""
        self.type = type
        self.amount = 0
        self.username = user.username ?? ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Amount"
        view.backgroundColor = Theme.background
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
        setupView()
        currency = amount/nav
    }
    
    
    func handleError(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func handleSubmit() {
        guard amountIsValid else { return }
        switch type {
        case .send:
            pushConfirmPaymentController()
        default:
            break
        }
    }
    
    
    func pushConfirmPaymentController() {
        let token = Token.XSG
        let vc = ConfirmPaymentController(user: user,
                                          publicKey: publicKey,
                                          token: token,
                                          amount: amount,
                                          currency: currency)
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
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        let amount = Decimal(string: textField.text ?? "") ?? 0
        self.amount = amount
        formatInput()
    }
    
    func formatInput() {
        guard amountInput.decimal <= amountInput.maximum else {
            amountInput.text = amountInput.lastValue
            return
        }
        amountInput.lastValue = amountInput.text ?? ""
        amountInput.text = amountInput.decimal.currency(2)
        currency = amountInput.decimal
        
        amount = currency/nav
        captionLabel.text = amount.rounded(3) + " Shares"
    }
    
    
    var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    lazy var amountInput: CurrencyField = {
        let field = CurrencyField()
        field.textAlignment = .center
        field.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        field.adjustsFontSizeToFitWidth = true
        field.keyboardType = .decimalPad
        field.keyboardAppearance = UIKeyboardAppearance.default
        field.font = Theme.semibold(60)
        field.textColor = Theme.black
        field.tintColor = Theme.black
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
        view.textColor = .gray
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func setupView() {
        view.addSubview(amountInput)
        view.addSubview(captionLabel)
        
        amountInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        amountInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        let offset = -view.frame.height/5
        amountInput.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive = true
        amountInput.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        captionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        captionLabel.topAnchor.constraint(equalTo: amountInput.bottomAnchor, constant: 20).isActive = true
        captionLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
    }
    
}

