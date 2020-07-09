//
//  HomeController.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk

class HomeController: UIViewController {
    
    private var passphrase: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = Theme.background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //
    //    lazy var tokenView: UIImageView = {
    //        let frame = CGRect(x: self.view.frame.width/2-20, y: headline.frame.minY-72, width: 40, height: 40)
    //        let view = UIImageView(frame: frame)
    //        view.image = UIImage(named: "token")?.withRenderingMode(.alwaysTemplate)
    //        view.tintColor = .white
    //        return view
    //    }()
    //
    
    
    lazy var headline: UILabel = {
        let frame = CGRect(x: 0, y: inputField.frame.minY-80, width: self.view.frame.width, height: 48)
        let view = UILabel(frame: frame)
        view.text = "goldwire"
        view.font = Theme.bold(36)
        view.textAlignment = .center
        view.textColor = Theme.white
        return view
    }()
    
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: UIScreen.main.bounds)
        view.backgroundColor = Theme.background
        view.alwaysBounceVertical = true
        view.delegate = self
        return view
    }()
    
    
    lazy var inputField: UITextField = {
        let frame = CGRect(x: 16, y: scrollView.center.y-100, width: self.view.frame.width-32, height: 54)
        let view = UITextField(frame: frame)
        view.font = Theme.semibold(18)
        view.textColor = .black
        view.placeholder = "12 word passphrase"
        view.attributedPlaceholder = NSAttributedString(string: view.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        view.textAlignment = .center
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.keyboardAppearance = .dark
        view.backgroundColor = Theme.white
        view.tintColor = Theme.highlight
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(updatePassphrase), for: .editingChanged)
        return view
    }()
    
    
    lazy var loginButton: UIButton = {
        let frame = CGRect(x: 16, y: self.view.frame.height-110, width: self.view.frame.width-32, height: 64)
        let button = UIButton(frame: frame)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(Theme.white, for: .normal)
        button.titleLabel?.font = Theme.semibold(20)
        button.backgroundColor = Theme.black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(pushLoginController), for: .touchUpInside)
        return button
    }()
    
    lazy var signupButton: UIButton = {
        let frame = CGRect(x: 16, y: loginButton.frame.minY-80, width: UIScreen.main.bounds.width-32, height: 64)
        let button = UIButton(frame: frame)
        button.setTitle("Open an Account", for: .normal)
        button.setTitleColor(Theme.black, for: .normal)
        button.titleLabel?.font = Theme.semibold(20)
        button.backgroundColor = Theme.white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(pushSignupController), for: .touchUpInside)
        return button
    }()
    
    @objc func updatePassphrase() {
        passphrase = inputField.text ?? ""
    }
    
    
    func pushUsernameController() {
        let vc = UsernameController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushLoginController() {
        print("Login")
        let vc = LoginController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushSignupController() {
        print("Signup")
        let vc = SignupController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleLogin() {
        
        
//        guard passphrase.components(separatedBy: " ").count > 8 else {
//            ErrorPresenter.showError(message: "Please include a passphrase.", on: self)
//            return
//        }
//
//        WalletService.login(passphrase) { (success) in
//            if success == true {
//                self.dismiss(animated: true, completion: nil)
//            } else {
//                ErrorPresenter.showError(message: "Login failed", on: self)
//            }
//        }
    }
    
    @objc func handleSignup() {
    //        let vc = SignupController()
    //        self.navigationController?.pushViewController(vc, animated: true)
            
            
            
    //        WalletService.signUp {
    //            DispatchQueue.main.async {
    //                NotificationCenter.default.post(name: Notification.Name("signup"), object: nil)
    //                self.pushUsernameController()
    //            }
    //        }
            
        }
    
    func setupView() {
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
        scrollView.addSubview(headline)
//        scrollView.addSubview(inputField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
    }
    
}

extension HomeController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        inputField.endEditing(true)
    }
}
