//
//  UsernameController.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.

import Foundation
import UIKit

class UsernameController: UITableViewController {
    
    private var username = CurrentUser.username
    
    let editableCell = "editableCell"
    
    lazy var header: UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        let view = UIView(frame: frame)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Username"
        view.backgroundColor = Theme.white
        tableView.backgroundColor = Theme.white
        tableView.separatorColor = Theme.border
        tableView.register(InputTextCell.self, forCellReuseIdentifier: editableCell)
        tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        self.navigationItem.rightBarButtonItem = save
        tableView.reloadData()
        
        extendedLayoutIncludesOpaqueBars = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    @objc func handleSave() {
        UserService.checkIfUsernameAvailable(username) { (available) in
            if available == true {
                self.saveUsername()
                CurrentUser.username = self.username.lowercased()
            } else {
                ErrorPresenter.showError(message: "Username unavailable.", on: self)
                return
            }
        }
    }
    
    private func saveUsername() {
        UserService.setUsername(publicKey: KeychainHelper.publicKey, username: username.lowercased()) { (success) in
            self.dismissController()
        }
    }
    
    func dismissController() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: editableCell, for: indexPath) as! InputTextCell
        cell.delegate = self
        cell.key = indexPath.row
        setupCell(cell: cell, indexPath)
        return cell
    }
    
    func setupCell(cell: InputTextCell, _ indexPath: IndexPath) {
        cell.textLabel?.textColor = Theme.gray
        cell.textLabel?.font = Theme.medium(18)
        cell.valueInput.autocapitalizationType = .none
        cell.valueInput.autocorrectionType = .no
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Username"
            cell.valueInput.text = CurrentUser.username
            cell.valueInput.placeholder = "$"
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    private var isModal: Bool {
        return presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }
    
    
}



extension UsernameController: InputTextCellDelegate {
    func textFieldDidChange(key: Int, value: String) {
        username = value
    }
}
