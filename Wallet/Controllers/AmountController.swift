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
    var token: Token
    var amount: Decimal = 0.0
    var username: String?
    var user: User?
    
    init(publicKey: String, type: TransactionType, token: Token?) {
        self.publicKey = publicKey
        self.type = type
        self.token = Token.GOLD
        super.init(nibName: nil, bundle: nil)
    }
    
    init(user: User, type: TransactionType, token: Token?) {
        self.user = user
        self.publicKey = user.publicKey ?? ""
        self.type = type
        self.token = token ?? Token.GOLD
        self.amount = 0
        self.username = user.username ?? ""
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Amount"
        view.backgroundColor = Theme.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
        setupView()
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
        guard let user = user else { return }
        let vc = ConfirmPaymentController(user: user, token: token, amount: amount, currency: 0)
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
        amount = Decimal(string: textField.text ?? "") ?? 0
    }
    
    func formatInput() {
        guard amountInput.decimal <= amountInput.maximum else {
            amountInput.text = amountInput.lastValue
            return
        }
        amountInput.lastValue = amountInput.text ?? ""
        amountInput.text = amountInput.lastValue
        amount = amountInput.decimal
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
        field.font = Theme.bold(36)
        field.textColor = Theme.black
        field.tintColor = Theme.highlight
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
        view.textColor = Theme.lightGray
        view.text = token.assetCode ?? "GOLD"
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func setupView() {
        view.addSubview(amountInput)
        view.addSubview(captionLabel)
        
        amountInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        amountInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        let offset = -view.frame.height/5
        amountInput.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive = true
        amountInput.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        captionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        captionLabel.topAnchor.constraint(equalTo: amountInput.bottomAnchor, constant: 0).isActive = true
        captionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
}
