//
//  PassphraseController.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk

class PassphraseController: UITableViewController {
    
    let cellId = "cellId"
    let mnemonic: String = KeychainHelper.mnemonic
    
    lazy var header: UIView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140)
        let view = UIView(frame: frame)
        view.backgroundColor = Theme.black
        var instructionsLabel: UITextView = {
            let view = UITextView(frame: frame)
            view.textContainerInset = UIEdgeInsets(top: 30, left: 12, bottom: 10, right: 12)
            view.backgroundColor = Theme.black
            view.font = UIFont.boldSystemFont(ofSize: 18)
            view.textColor = Theme.white
            view.isEditable = false
            view.text = "Please write down this secret phrase. It is the only way to recover your wallet. Do not share it with anyone."
            return view
        }()
        view.addSubview(instructionsLabel)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = header
        tableView.allowsSelection = false
        tableView.separatorColor = Theme.border
        tableView.backgroundColor = Theme.black
        view.backgroundColor = Theme.black
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        self.navigationItem.title = "Secret Phrase"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if isModal {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continue", style: .done, target: self, action: #selector(handleContinue))
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.font = Theme.semibold(20)
        cell.textLabel?.textColor = Theme.white
        cell.backgroundColor = Theme.tint
        let words = mnemonic.components(separatedBy: .whitespaces)
        let word = words[indexPath.row]
        cell.textLabel?.text = word
        return cell
    }
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleContinue() {
       
    }
    
    var isModal: Bool {
        return presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }
    
}

