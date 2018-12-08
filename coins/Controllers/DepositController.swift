//
//  DepositController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class DepositController: UIViewController {
    
    let inputCell = "inputCell"
    var address = ""
    var amount = ""
    var status = ""
    
    init(amount: String, address: String) {
        self.amount = amount
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(withID id: String, amount: String, address: String) {
        self.init(amount: amount, address: address)
        CoinbaseService.getCharge(withID: id) {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Send bitcoin"
        setupView()
    }
    
    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: UIScreen.main.bounds)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func copyAddress() {
        UIPasteboard.general.string = address
        UIDevice.vibrate()
        dismiss(animated: true, completion: nil)
    }
    
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.text = "Status"
        view.font = Theme.semibold(18)
        view.textAlignment = .left
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var statusInputView: UITextView = {
        let view = UITextView()
        view.text = status
        view.font = Theme.semibold(18)
        view.textColor = .darkGray
        view.textAlignment = .left
        view.backgroundColor = Theme.lightGray
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.isEditable = false
        view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let view = UILabel()
        view.text = "Amount"
        view.font = Theme.semibold(18)
        view.textAlignment = .left
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var amountInputView: UITextView = {
        let view = UITextView()
        view.text = amount
        view.font = Theme.semibold(18)
        view.textColor = .darkGray
        view.textAlignment = .left
        view.backgroundColor = Theme.lightGray
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.isEditable = false
        view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.text = "Bitcoin (BTC) Address"
        view.font = Theme.semibold(18)
        view.textAlignment = .left
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addressInputView: UITextView = {
        let view = UITextView()
        view.text = address
        view.font = Theme.semibold(18)
        view.textColor = .darkGray
        view.textAlignment = .left
        view.backgroundColor = Theme.lightGray
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.isEditable = false
        view.textContainerInset = UIEdgeInsets(top: 18, left: 20, bottom: 10, right: 50)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let copyButton: UIButton = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let button = UIButton(frame: frame)
        button.setTitle("Copy Address", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Theme.semibold(20)
        button.backgroundColor = Theme.black
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(statusLabel)
        scrollView.addSubview(statusInputView)
        scrollView.addSubview(amountLabel)
        scrollView.addSubview(amountInputView)
        scrollView.addSubview(addressLabel)
        scrollView.addSubview(addressInputView)
        scrollView.addSubview(copyButton)
        
        statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        statusLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        
        statusInputView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        statusInputView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        statusInputView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10).isActive = true
        statusInputView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        amountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        amountLabel.topAnchor.constraint(equalTo: statusInputView.bottomAnchor, constant: 30).isActive = true
        
        amountInputView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        amountInputView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        amountInputView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10).isActive = true
        amountInputView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        addressLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addressLabel.topAnchor.constraint(equalTo: amountInputView.bottomAnchor, constant: 30).isActive = true
        
        addressInputView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        addressInputView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        addressInputView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        addressInputView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        copyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        copyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        copyButton.topAnchor.constraint(equalTo: addressInputView.bottomAnchor, constant: 30).isActive = true
        copyButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        
    }
    
    
}

