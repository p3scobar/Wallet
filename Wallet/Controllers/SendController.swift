//
//  AddressController.swift
//  Wallet
//
//  Created by Hackr on 4/24/20.
//  Copyright © 2020 Sugar. All rights reserved.
//


import Foundation
import UIKit

class SendController: UITableViewController {
    
    private var token: Token?
    
    var address: String? = ""
    
    
    init(_ token: Token) {
        self.token = token
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let editableCell = "editableCell"
    let standardCell = "standardCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Send to"
        
        extendedLayoutIncludesOpaqueBars = true
        tableView.backgroundColor = Theme.background
        tableView.separatorColor = Theme.border
        
        tableView.register(InputTextCell.self, forCellReuseIdentifier: editableCell)
        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
        tableView.tableFooterView = UIView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continue", style: .done, target: self, action: #selector(handleContinue))
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        
    }
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleContinue() {
        guard let pk = address else {
            
            return
        }
//        let vc = AmountController(publicKey: pk)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: editableCell, for: indexPath) as! InputTextCell
            cell.delegate = self
            cell.key = indexPath.row
            setupCell(cell: cell, indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath) as! StandardCell
//            let username = users[indexPath.row].username ?? ""
//            cell.textLabel?.text = "@\(username)"
//            cell.textLabel?.textColor = Theme.highlight
            return cell
        }
    }
    
    func setupCell(cell: InputTextCell, _ indexPath: IndexPath) {
        cell.valueInput.autocorrectionType = .no
        cell.valueInput.autocapitalizationType = .none
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.valueInput.becomeFirstResponder()
            cell.valueInput.textAlignment = .left
            cell.valueInput.text = address
            cell.backgroundColor = Theme.tint
            cell.placeholder = "Public Key"
        case (0,1):
            cell.valueInput.becomeFirstResponder()
            cell.valueInput.textAlignment = .left
            cell.valueInput.text = address
            cell.valueInput.keyboardType = .decimalPad
            cell.placeholder = "Amount to send"
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let publicKey = address else { return }
        pushSendController()
    }
    
    func pushSendController() {

    }
    
    
}


extension SendController: InputTextCellDelegate {
    func textFieldDidChange(key: Int, value: String) {
        switch key {
        case 0:
           address = value
           print("query: \(value)")
        default:
            break
        }
    }
    
    
    
    
}


