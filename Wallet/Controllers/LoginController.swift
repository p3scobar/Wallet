//
//  LoginController.swift
//  Wallet
//
//  Created by Hackr on 6/26/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UITableViewController {
    
    let inputCell = "inputCell"
    var email = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(InputTextCell.self, forCellReuseIdentifier: inputCell)
        title = "Login"

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Theme.background
        view.backgroundColor = Theme.background
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
    }
    
    
    @objc func handleSubmit() {
        UserService.login(email, password) { (success) in
            if success == true {
                self.dismiss(animated: true, completion: nil)

            } else {
                self.presentAlert(title: "Error", message: "Login failed. Please try again.")
            }
        }
    }
    
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        let password = UIAlertAction(title: "Reset Password", style: .destructive, handler: nil)
        alert.addAction(done)
        alert.addAction(password)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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
        switch indexPath.row {
        case 0:
            cell.valueInput.keyboardType = .emailAddress
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .none
            let placeholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        case 1:
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


extension LoginController: InputTextCellDelegate {
    
    func textFieldDidChange(key: Int, value: String) {
           switch key {
           case 0:
               email = value
           case 1:
               password = value
           default:
               break
           }
       }
    
}

