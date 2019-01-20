//
//  HomeController.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import LocalAuthentication

class HomeController: UIViewController {
    
    var email = ""
    let inputCell = "inputCell"
    var passphrase = KeychainHelper.mnemonic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.black
        navigationController?.navigationBar.prefersLargeTitles = false
        setupView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Create an Account", style: .done, target: self, action: #selector(handleNewAccount))
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = Theme.black
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getGoldPrice()
        inputLabel.becomeFirstResponder()
    }
    
    internal func getGoldPrice() {
        let gold = Token.GOLD
        let usd = Token.USD
        
        OrderService.getOrderBook(buy: usd, sell: gold, limit: 10) { [weak self] (_, _) in
//            let lastPrice = OrderService.lastPrice
//            self?.priceLabel.text = lastPrice.currency() + " USD / Share"
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: self.view.frame)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    @objc func handleLogin() {
        guard passphrase.components(separatedBy: " ").count > 8 else {
            self.presentAlert(title: "Error", message: "Please include a passphrase.")
            return
        }
        WalletService.login(passphrase) { (success) in
            if success == true {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.presentAlert(title: "Error", message: "Please include a passphrase.")
            }
        }
    }
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func updatePassphrase(_ sender: UITextField) {
        guard let text = sender.text else { return }
        passphrase = text
    }
    
    override var inputAccessoryView: UIView? {
        return menu
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    static var AllowUserInteraction: UIView.KeyframeAnimationOptions {
        get {
            return UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.allowUserInteraction.rawValue)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "RIT Capital Partners"
        view.font = Theme.semibold(24)
        view.textColor = Theme.white
        view.textAlignment = .left
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let view = UILabel()
//        let p = OrderService.lastPrice.currency()
//        view.text = "\(p) USD / Share"
        view.font = Theme.medium(16)
        view.textColor = Theme.white
        view.textAlignment = .left
        view.numberOfLines = 1
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var menu: UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        let view = UIView(frame: frame)
        view.backgroundColor = Theme.black
        view.addSubview(inputLabel)
        view.addSubview(loginButton)
        return view
    }()
    
    lazy var inputLabel: UITextField = {
        let frame = CGRect(x: 16, y: 20, width: self.view.frame.width-32, height: 44)
        let view = UITextField(frame: frame)
        view.font = Theme.medium(18)
        view.textColor = .white
        view.backgroundColor = Theme.tint
        view.textAlignment = .center
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.layer.cornerRadius = 8
        view.keyboardAppearance = .dark
        view.attributedPlaceholder =
            NSAttributedString(string: "Your Passphrase", attributes: [NSAttributedString.Key.foregroundColor: Theme.gray])
        view.addTarget(self, action: #selector(updatePassphrase), for: .editingChanged)
        return view
    }()
    
    
    lazy var loginButton: Button = {
        let frame = CGRect(x: 16, y: 80, width: self.view.frame.width-32, height: 44)
        let button = Button(frame: frame, title: "Login")
        button.setTitleColor(Theme.black, for: .normal)
        button.titleLabel?.font = Theme.semibold(18)
        button.backgroundColor = Theme.white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(priceLabel)
        scrollView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        priceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    
    @objc func handleNewAccount() {
        let vc = SignupController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func touchID(){
        let authContext = LAContext()
        var authError : NSError?
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login With Touch ID", reply: { (success, error) in
                if success {
                    print("Touch ID success!")
                    DispatchQueue.main.async {
                        self.passphrase = KeychainHelper.mnemonic
                    }
                } else {
                    print("Touch ID failed!")
                }}
            );
        } else {
            print("No local authentication")
        }
    }
    
}
