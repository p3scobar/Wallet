//
//  SignupController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class SignupController: UIViewController {
    
    var isLoading: Bool = false {
        didSet {
            if isLoading == true {
                indicator.startAnimating()
                button.isHidden = true
                indicator.isHidden = false
            } else {
                indicator.stopAnimating()
                button.isHidden = false
                indicator.isHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isLoading = false
    }
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: button.frame)
        view.style = .white
        view.isHidden = true
        return view
    }()
    
    let inputCell = "inputCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.black
        navigationController?.navigationBar.prefersLargeTitles = false
        setupView()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = Theme.black
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: self.view.frame)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    @objc func handleContinue() {
        isLoading = true
        WalletService.signUp {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                self.pushUsernameController()
            }
        }
    }
    
    func pushUsernameController() {
        let vc = UsernameController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return menu
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Create an Account"
        view.font = Theme.medium(24)
        view.textColor = Theme.white
        view.textAlignment = .left
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.text = "A blockchain-based investment trust."
        view.font = Theme.medium(18)
        view.textColor = Theme.white
        view.textAlignment = .left
        view.numberOfLines = 3
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var menu: UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90)
        let view = UIView(frame: frame)
        view.backgroundColor = Theme.black
        view.addSubview(button)
        view.addSubview(indicator)
        return view
    }()
    
    
    lazy var button: Button = {
        let frame = CGRect(x: 16, y: 20, width: self.view.frame.width-32, height: 44)
        let button = Button(frame: frame, title: "Sign Up")
        button.setTitleColor(Theme.black, for: .normal)
        button.titleLabel?.font = Theme.semibold(18)
        button.backgroundColor = Theme.white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
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
        priceLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    
    
}
