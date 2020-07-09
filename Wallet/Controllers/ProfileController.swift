//
//  ProfileController.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class ProfileController: UITableViewController {
    
    private var name = CurrentUser.name
    private var email = CurrentUser.email
    
    let editableCell = "editableCell"
    let standardCell = "standardCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: standardCell)
        tableView.register(InputTextCell.self, forCellReuseIdentifier: editableCell)
        tableView.tableFooterView = UIView()
        
        let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        self.navigationItem.rightBarButtonItem = save
        tableView.reloadData()
        tableView.backgroundColor = Theme.background
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    @objc func handleSave() {
        CurrentUser.name = name
        CurrentUser.email = email
        let data = ["name":name,
         "email": email]
//        UserService.setUserData(data)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: editableCell, for: indexPath) as! InputTextCell
            cell.delegate = self
            cell.key = indexPath.row
            setupCell(cell: cell, indexPath)
            return cell
    }
    
    func setupCell(cell: InputTextCell, _ indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.valueInput.text = CurrentUser.name
            cell.placeholder = "Your name"
        case 1:
            cell.textLabel?.text = "Email"
            cell.placeholder = "you@email.com"
            cell.valueInput.text = CurrentUser.email
            cell.valueInput.keyboardType = .emailAddress
            cell.valueInput.autocapitalizationType = .none
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    
}


extension ProfileController: InputTextCellDelegate {
    func textFieldDidChange(key: Int, value: String) {
        switch key {
        case 0:
            name = value
        case 1:
            email = value
        default:
            break
        }
    }
    
    
    
    
}

