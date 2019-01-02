//
//  SignupController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class SignupController: UIViewController {
    
    var email = ""
    let inputCell = "inputCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.black
        navigationController?.navigationBar.prefersLargeTitles = false
        setupView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
    }
    
    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: UIScreen.main.bounds)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = Theme.black
        return view
    }()
    
    @objc func handleSubmit() {
        guard email != "" else {
            self.presentAlert(title: "Error", message: "Please include an email.")
            return
        }
        WalletService.signUp {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func updateEmail(_ sender: UITextField) {
        guard let text = sender.text else { return }
        email = text
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Your email address, please"
        view.font = Theme.bold(36)
        view.textColor = .darkGray
        view.textAlignment = .center
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var inputLabel: UITextField = {
        let view = UITextField()
        view.font = Theme.semibold(18)
        view.textColor = .white
        view.tintColor = Theme.highlight
        view.placeholder = "Email address"
        view.textAlignment = .center
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.backgroundColor = Theme.tint
        view.keyboardType = .emailAddress
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(updateEmail), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(inputLabel)
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
        
        inputLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        inputLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        inputLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        inputLabel.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
    }
    
    
}

