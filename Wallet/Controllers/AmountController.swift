//
//  AmountController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

//class AmountController: UIViewController, UITextFieldDelegate {
//    
//    var type: TransactionType?
//    var publicKey: String
//    var username: String?
//    
//    var amount: Double = 0.0 {
//        didSet {
//            
//        }
//    }
//    
//    var currency: Double = 0 {
//        didSet {
//            
//        }
//    }
//    
//    init(publicKey: String) {
//        self.publicKey = publicKey
//        self.type = .send
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        view.endEditing(true)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        view.endEditing(true)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Send"
//        view.backgroundColor = Theme.tint
//        extendedLayoutIncludesOpaqueBars = true
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
//        setupView()
//        currency = amount/lastPrice
//    
//    }
//    
//    
//    func handleError(message: String) {
//        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
//        let doneButton = UIAlertAction(title: "Done", style: .default, handler: nil)
//        alert.addAction(doneButton)
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    
//    @objc func handleSubmit() {
////        guard amountIsValid else { return }
//        switch type {
//        case .send:
//            pushConfirmPaymentController()
//        default:
//            break
//        }
//    }
//    
//    
//    func pushConfirmPaymentController() {
//        
//    }
//    
//    
//    var amountIsValid: Bool {
//        guard amount > 0.0000001 else {
//            ErrorPresenter.showError(message: "Invalid amount", on: self)
//            return false
//        }
//        return true
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        amountInput.becomeFirstResponder()
//    }
//    
//    
//    @objc func textFieldDidChange(textField: UITextField){
//        let amount = Decimal(string: textField.text ?? "") ?? 0
//        self.amount = amount
//        formatInput()
//    }
//    
//    func formatInput() {
//        guard amountInput.decimal <= amountInput.maximum else {
//            amountInput.text = amountInput.lastValue
//            return
//        }
//        amountInput.lastValue = amountInput.text ?? ""
////        amountInput.text = amountInput.decimal.currency(2)
////        currency = amountInput.decimal
////
////        amount = currency
//
//    }
//    
//    
//    var decimalFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.generatesDecimalNumbers = true
//        formatter.numberStyle = .decimal
//        return formatter
//    }()
//    
//    lazy var amountInput: CurrencyField = {
//        let frame = CGRect(x: 0, y: self.view.center.y-150, width: self.view.frame.width, height: 80)
//        let field = CurrencyField(frame: frame)
//        field.textAlignment = .center
//        field.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
//        field.adjustsFontSizeToFitWidth = true
//        field.keyboardType = .decimalPad
//        field.keyboardAppearance = UIKeyboardAppearance.dark
//        field.font = Theme.bold(48)
//        field.textColor = Theme.white
//        field.tintColor = Theme.highlight
//        field.borderStyle = UITextField.BorderStyle.none
//        field.delegate = self
//        field.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
//        return field
//    }()
//    
//    lazy var publicKeyLabel: UILabel = {
//        let frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 80)
//        let view = UILabel(frame: frame)
//        view.textAlignment = .center
//        view.adjustsFontSizeToFitWidth = true
//        view.font = Theme.semibold(24)
//        view.textColor = .gray
//        view.adjustsFontForContentSizeCategory = true
//        return view
//    }()
//    
//    
//    func setupView() {
//        view.addSubview(amountInput)
////        view.addSubview(captionLabel)
//        
//    }
//    
//}

