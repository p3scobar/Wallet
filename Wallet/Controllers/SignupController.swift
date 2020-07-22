//
//  SignupController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//
//


import UIKit
import Firebase

class SignupController: UITableViewController {
    
    let inputCell = "inputCell"
    var name = ""
    var email = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.background
        view.backgroundColor = Theme.background
        tableView.register(InputTextCell.self, forCellReuseIdentifier: inputCell)
        title = "Signup"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continue", style: .done, target: self, action: #selector(handleSubmit))
    }
    
    
    @objc func handleSubmit() {
        UserService.signup(email, password, name) { (success) in
             if !success {
                self.presentAlert(title: "Error", message: "Something went wrong. Please try again.")
                return
            }
            NotificationCenter.default.post(name: Notification.Name("auth"), object: nil)
            self.pushUsernameController()
        }
    }
    
    func pushUsernameController() {
        let vc = UsernameController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: inputCell, for: indexPath) as! InputTextCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.valueInput.textAlignment = .left
        cell.key = indexPath.row
        switch indexPath.row{
        case 0:
            cell.valueInput.keyboardType = .twitter
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .words
            let placeholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        case 1:
            cell.valueInput.keyboardType = .emailAddress
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .none
            let placeholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        case 2:
            cell.valueInput.keyboardType = .default
            cell.valueInput.isSecureTextEntry = true
            let placeholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        default:
            break
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func handleForgotPassword() {
        
    }
    
    
    
    
}


extension SignupController: InputTextCellDelegate {
   
    func textFieldDidChange(key: Int, value: String) {
        switch key {
        case 0:
            name = value
        case 1:
            email = value
        case 2:
            password = value
        default:
            break
        }
    }
    
}




//import UIKit
//
//class SignupController: UIViewController {
//
//    var isLoading: Bool = false {
//        didSet {
//            if isLoading == true {
//                indicator.startAnimating()
//                button.isHidden = true
//                indicator.isHidden = false
//            } else {
//                indicator.stopAnimating()
//                button.isHidden = false
//                indicator.isHidden = true
//            }
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        isLoading = false
//    }
//
//    lazy var indicator: UIActivityIndicatorView = {
//        let view = UIActivityIndicatorView(frame: button.frame)
//        view.style = .white
//        view.isHidden = true
//        return view
//    }()
//
//    let inputCell = "inputCell"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = "Sign Up"
//        view.backgroundColor = Theme.black
//        setupView()
//    }
//
//    lazy var scrollView: UIScrollView = {
//        let view = UIScrollView(frame: self.view.frame)
//        view.alwaysBounceVertical = true
//        view.showsVerticalScrollIndicator = false
//        return view
//    }()
//
//    @objc func handleContinue() {
//        isLoading = true
//        WalletService.signUp {
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(name: Notification.Name("signup"), object: nil)
//                self.pushUsernameController()
//            }
//        }
//    }
//
//    func pushUsernameController() {
//        let vc = UsernameController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//
//    func presentAlert(title: String, message: String?) {
//        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
//        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
//        alert.addAction(done)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    override var inputAccessoryView: UIView? {
//        return menu
//    }
//
//    lazy var titleLabel: UILabel = {
//        let frame = CGRect(x: 20, y: 10, width: self.view.frame.width-40, height: 40)
//        let view = UILabel(frame: frame)
//        view.text = "Create an Account"
//        view.font = Theme.medium(24)
//        view.textColor = Theme.white
//        view.textAlignment = .left
//        view.numberOfLines = 1
//        view.lineBreakMode = .byWordWrapping
//        return view
//    }()
//
//
//    lazy var menu: UIView = {
//        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
//        let view = UIView(frame: frame)
//        view.backgroundColor = Theme.black
//        view.addSubview(button)
//        view.addSubview(indicator)
//        return view
//    }()
//
//
//    lazy var button: Button = {
//        let frame = CGRect(x: 16, y: 10, width: self.view.frame.width-32, height: 64)
//        let button = Button(frame: frame, title: "Sign Up")
//        button.setTitleColor(Theme.black, for: .normal)
//        button.titleLabel?.font = Theme.semibold(18)
//        button.backgroundColor = Theme.white
//        button.layer.cornerRadius = 16
//        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
//        return button
//    }()
//
//
//    func setupView() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(titleLabel)
//
//        scrollView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
//
//    }
//
//
//
//}
