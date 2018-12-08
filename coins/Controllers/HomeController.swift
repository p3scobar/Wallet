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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    let headline: UILabel = {
        let view = UILabel()
        view.text = "Sigma"
        view.font = UIFont(name: "Avenir-Black", size: 60)
        view.textAlignment = .center
        view.textColor = Theme.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Already have an account? Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = Theme.medium(16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let signupButton: UIButton = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let button = UIButton(frame: frame)
        button.setTitle("Create an Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Theme.semibold(20)
        button.backgroundColor = Theme.black
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleLogin() {
        let vc = LoginController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleSignup() {
        let vc = SignupController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupView() {
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        view.addSubview(headline)
        
        headline.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        headline.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        headline.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        headline.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        signupButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        signupButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        signupButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
}