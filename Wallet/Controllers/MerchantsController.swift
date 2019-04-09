//
//  MerchantsController.swift
//  Wallet
//
//  Created by Hackr on 4/8/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class MerchantsController: UITableViewController {
    
    
    private var publicKey: String?
    
    var isFiltering: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filteredUsers: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchController: UISearchController!
    
    let userCell = "editableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Merchants"
        
        tableView.backgroundColor = Theme.background
        tableView.separatorColor = Theme.border
        tableView.contentInsetAdjustmentBehavior = .always
        extendedLayoutIncludesOpaqueBars = true
        
        tableView.register(UserCell.self, forCellReuseIdentifier: userCell)
        tableView.tableFooterView = UIView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        
        self.definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .default
        //        searchController.searchBar.backgroundColor = Theme.background
        searchController.searchBar.sizeToFit()
        //        searchController.searchBar.barTintColor = Theme.background
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        //        self.navigationController?.navigationBar.barStyle = .black
        //        self.navigationController?.navigationBar.tintColor = .white
        //        self.navigationController?.navigationBar.barTintColor = Theme.black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchFavorites()
        //        getContacts()
    }
    
    func fetchFavorites() {
        UserService.getFavorites { (favorites) in
            self.users = favorites
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath) as! UserCell
        if isFiltering {
            cell.user = filteredUsers[indexPath.row]
        } else {
            cell.user = users[indexPath.row]
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var user: User
        if isFiltering {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        let vc = AmountController(user: user, type: .send, token: Token.GOLD)
        self.navigationController?.pushViewController(vc, animated: true)
        guard let username = user.username else { return }
        UserService.setFavorite(username) { _ in }
    }
    
    
}


extension MerchantsController: InputTextCellDelegate {
    func textFieldDidChange(key: Int, value: String) {
        switch key {
        case 0:
            publicKey = value
        default:
            break
        }
    }
}

extension MerchantsController: UISearchResultsUpdating {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        isFiltering = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased() else { return }
        isFiltering = query.count > 0
        UserService.getUserFor(username: query) { (user) in
            self.filteredUsers = [user]
        }
    }
    
}

extension MerchantsController: UISearchControllerDelegate {
    
}


extension MerchantsController: UISearchBarDelegate {
    
}
