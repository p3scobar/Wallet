//
//  UsersController.swift
//  coins
//
//  Created by Hackr on 1/6/19.
//  Copyright © 2019 Sugar. All rights reserved.
//
//
//import Foundation
//import UIKit
//import Contacts
//
//class UsersController: UITableViewController {
//
//    private var token: Token = counterAsset
//    private var publicKey: String?
//
//    override init(style: UITableView.Style) {
//        super.init(style: style)
//    }
//
//    var isFiltering: Bool = false {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//
//    var users: [User] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//
//    var filteredUsers: [User] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    var searchController: UISearchController!
//
//    let userCell = "editableCell"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = "Friends"
//
//        tableView.backgroundColor = Theme.lightBackground
//        tableView.contentInsetAdjustmentBehavior = .always
//        extendedLayoutIncludesOpaqueBars = true
//
//        tableView.register(UserCell.self, forCellReuseIdentifier: userCell)
//        tableView.tableFooterView = UIView()
//
//        self.definesPresentationContext = true
//
//        searchController = UISearchController(searchResultsController:  nil)
//        searchController.searchResultsUpdater = self
//        searchController.delegate = self
//        searchController.searchBar.delegate = self
//        searchController.searchBar.barStyle = .default
//        searchController.searchBar.sizeToFit()
//
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.dimsBackgroundDuringPresentation = false
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//
//
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        let scan = UIImage(named: "scan")?.withRenderingMode(.alwaysTemplate)
//        let scanButton = UIBarButtonItem(image: scan, style: .done, target: self, action: #selector(presentScanController))
//        self.navigationItem.rightBarButtonItem = scanButton
//        fetchFavorites()
//    }
//
//    @objc func presentScanController() {
//        let vc = ScanController()
//        vc.delegate = self
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalTransitionStyle = .crossDissolve
//        nav.modalPresentationStyle = .fullScreen
//        present(nav, animated: true)
//    }
//
//    func fetchFavorites() {
////        UserService.getFavorites { (favorites) in
////            self.users = favorites
////        }
//    }
//
//    @objc func handleCancel() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        searchController.isActive = true
//    }
//
//    func didPresentSearchController(_ searchController: UISearchController) {
//        DispatchQueue.main.async {
//            searchController.searchBar.becomeFirstResponder()
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isFiltering {
//            return filteredUsers.count
//        } else {
//            return users.count
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath) as! UserCell
//        if isFiltering {
//            cell.user = filteredUsers[indexPath.row]
//        } else {
//            cell.user = users[indexPath.row]
//        }
//        return cell
//    }
//
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 64
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        var user: User
//        if isFiltering {
//            user = filteredUsers[indexPath.row]
//        } else {
//            user = users[indexPath.row]
//        }
//
//        let pk = publicKey ?? ""
//        let vc = AmountController(publicKey: pk)
//
//        self.navigationController?.pushViewController(vc, animated: true)
//        guard let username = user.username else { return }
////        UserService.setFavorite(username) { _ in }
//    }
//
//
//}
//
//
//extension UsersController: InputTextCellDelegate {
//    func textFieldDidChange(key: Int, value: String) {
//        switch key {
//        case 0:
//           publicKey = value
//        default:
//            break
//        }
//    }
//}
//
//extension UsersController: UISearchResultsUpdating {
//
//    func willDismissSearchController(_ searchController: UISearchController) {
//        isFiltering = false
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let query = searchController.searchBar.text?.lowercased() else { return }
//        isFiltering = query.count > 0
////        UserService.getUserFor(username: query) { (user) in
////            self.filteredUsers = [user]
////        }
//    }
//
//}
//
//extension UsersController: UISearchControllerDelegate {
//
//}
//
//
//extension UsersController: UISearchBarDelegate {
//
//}
//
//
//extension UsersController {
//    func getContacts() {
//        let store = CNContactStore()
//
//        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
//            store.requestAccess(for: .contacts) { (authorized: Bool, error: Error?) in
//                if authorized {
//                self.retrieveContactsWithStore(store: store)
//                }
//            }
//        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
//               retrieveContactsWithStore(store: store)
//        }
//    }
//
//
//    func retrieveContactsWithStore(store: CNContactStore) {
////        do {
//////            let groups = try store.groups(matching: nil)
//////            let predicate: NSPredicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
//////            let keysToFetch: [CNKeyDescriptor] = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey as CNKeyDescriptor]
//////
//////            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
//////            let formatter = CNContactFormatter()
//////
//////            contacts.forEach { (contact) in
//////                let name = formatter.string(from: contact)
//////                print(name)
//////            }
//////
//////        } catch {
//////            print(error.localizedDescription)
//////        }
//
//    }
//}
//
//
//extension UsersController: ScanDelegate {
//    func handleScan(_ pk: String) {
////        let vc = AmountController(
////        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//
//
//}
