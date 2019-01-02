//
//  LoginController.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    var email = ""
    let inputCell = "inputCell"
    var passphrase = ""
    
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
    
//
//    lazy var toolbar: UIToolbar = {
//        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
//        let bar = UIToolbar(frame: frame)
//        bar.barStyle = .blackTranslucent
//
//        return bar
//    }()
//
//    override var inputAccessoryView: UIView? {
//        return toolbar
//    }
    
    
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
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Sign in With Your Passphrase"
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
        view.placeholder = "12 word passphrase"
        view.textAlignment = .center
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.backgroundColor = Theme.tint
        view.tintColor = Theme.highlight
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(updatePassphrase), for: .editingChanged)
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
