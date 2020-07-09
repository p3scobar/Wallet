//
//  DiscoverController.swift
//  Wallet
//
//  Created by Hackr on 5/2/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

class DiscoverController: UITableViewController {
    
    private var searchController: UISearchController!
    private var refresh = UIRefreshControl()
    
    let cardCell = "cardCell"
    
    var assets: [Token] = [] {
        didSet {
            refresh.endRefreshing()
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Discover"
        extendedLayoutIncludesOpaqueBars = true
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.refreshControl = refresh
//        tableView.separatorColor = Theme.border

        tableView.backgroundColor = Theme.background
        view.backgroundColor = Theme.background
        
        self.navigationController?.navigationBar.barTintColor = Theme.background
        extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = Theme.background
        self.definesPresentationContext = true
//        let vc = ResultsController(style: .plain)
//        searchController = UISearchController(searchResultsController: vc)
//        searchController.delegate = self
//        searchController.searchResultsUpdater = vc
//        searchController.hidesNavigationBarDuringPresentation = false
//
//        searchController.searchBar.tintColor = .gray
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.register(CardCell.self, forCellReuseIdentifier: cardCell)
        
        refresh.addTarget(self, action: #selector(getData(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(auth), name: Notification.Name(rawValue: "login"), object: nil)
        
        auth()
        getData(nil)
    }
    
    @objc func getData(_ refresh: UIRefreshControl?) {
//        RewardService.discover(query: "") { (rewards) in
//            self.rewards = rewards
//            refresh?.endRefreshing()
//        }
    }
    
    @objc func refresh(_ control: UIRefreshControl) {
        control.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refresh.endRefreshing()
    }
    
    
    @objc func handleMoreTap() {
       
    }
    
    @objc func auth() {
//        let vc = HomeController()
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true) {}
    }
    
    
    func handleLoggedOut() {
     
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cardCell, for: indexPath) as! CardCell
        cell.token = assets[indexPath.row]
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let vc = RewardController(reward: rewards[indexPath.row])
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



extension DiscoverController: UISearchControllerDelegate {
    
}


