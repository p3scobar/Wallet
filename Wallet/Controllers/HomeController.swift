//
//  HomeController.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    
    private var passphrase: String = ""
    private var isLoading: Bool = false {
        didSet {
            if isLoading {
                indicator.startAnimating()
                indicator.isHidden = false
                signupButton.isHidden = true
            } else {
                indicator.stopAnimating()
                indicator.isHidden = true
                signupButton.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = Theme.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    lazy var headline: UILabel = {
        let frame = CGRect(x: 0, y: 140, width: self.view.frame.width, height: 60)
        let view = UILabel(frame: frame)
        view.text = "Token"
        view.font = UIFont(name: "Avenir-Black", size: 48)
        view.textAlignment = .center
        view.textColor = Theme.white
        return view
    }()
    

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: UIScreen.main.bounds)
        view.backgroundColor = Theme.black
        view.alwaysBounceVertical = true
        view.delegate = self
        return view
    }()
    
    
    lazy var inputField: UITextField = {
        let frame = CGRect(x: 16, y: 240, width: self.view.frame.width-32, height: 54)
        let view = UITextField(frame: frame)
        view.font = Theme.semibold(18)
        view.textColor = .white
        view.placeholder = "12 word passphrase"
        view.attributedPlaceholder = NSAttributedString(string: view.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        view.textAlignment = .center
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.keyboardAppearance = .dark
        view.backgroundColor = Theme.tint
        view.tintColor = Theme.highlight
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(updatePassphrase), for: .editingChanged)
        return view
    }()
    
    
    lazy var loginButton: UIButton = {
        let frame = CGRect(x: 16, y: 320, width: self.view.frame.width-32, height: 54)
        let button = UIButton(frame: frame)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(Theme.black, for: .normal)
        button.titleLabel?.font = Theme.semibold(20)
        button.backgroundColor = Theme.white
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var signupButton: UIButton = {
        let frame = CGRect(x: 16, y: self.view.frame.height-120, width: UIScreen.main.bounds.width-32, height: 54)
        let button = UIButton(frame: frame)
        button.setTitle("Need an Account? Sign Up", for: .normal)
        button.setTitleColor(Theme.gray, for: .normal)
        button.titleLabel?.font = Theme.medium(16)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: signupButton.frame)
        view.isHidden = true
        return view
    }()
    
    @objc func updatePassphrase() {
        passphrase = inputField.text ?? ""
    }
    
    @objc func handleSignup() {
        self.isLoading = true
        WalletService.signUp {
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
        }
    }
    
    @objc func handleLogin() {
        guard passphrase.components(separatedBy: " ").count > 8 else {
            ErrorPresenter.showError(message: "Please include a passphrase.", on: self)
            return
        }
        
        WalletService.login(passphrase) { (success) in
            if success == true {
                self.dismiss(animated: true, completion: nil)
            } else {
                ErrorPresenter.showError(message: "Login failed", on: self)
            }
        }
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(headline)
        scrollView.addSubview(inputField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(signupButton)
        scrollView.addSubview(indicator)
    }
    
}

extension HomeController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        inputField.endEditing(true)
    }
}
